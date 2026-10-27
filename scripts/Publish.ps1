#Requires -Version 7.0
param([switch]$ValidateOnly)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

try {
    $root = Split-Path $PSScriptRoot -Parent
    $manifestPath = Join-Path $root 'release.json'
    $packageDirectory = Join-Path $root 'packages'
    $expectedVersion = $env:EXPECTED_SDK_VERSION
    $expectedCommit = $env:EXPECTED_SOURCE_COMMIT
    if ([string]::IsNullOrWhiteSpace($expectedVersion) -or $expectedVersion -cnotmatch '\A\d+\.\d+\.\d+(?:-[0-9A-Za-z]+(?:[.-][0-9A-Za-z]+)*)?\z') {
        throw 'EXPECTED_SDK_VERSION must contain the exact SDK package version.'
    }
    if ([string]::IsNullOrWhiteSpace($expectedCommit) -or $expectedCommit -cnotmatch '\A[0-9a-fA-F]{40}\z') {
        throw 'EXPECTED_SOURCE_COMMIT must contain the full GitLab source commit.'
    }
    if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf) -or -not (Test-Path -LiteralPath $packageDirectory -PathType Container)) {
        throw 'The committed release.json and packages folder are required.'
    }
    foreach ($fixedPath in @($manifestPath, $packageDirectory)) {
        if ((Get-Item -LiteralPath $fixedPath -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) { throw 'Release files and folders must not be symbolic links.' }
    }
    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    if ($manifest.schemaVersion -ne 1 -or $manifest.sdkVersion -cne $expectedVersion -or $manifest.commit -cne $expectedCommit) {
        throw 'Release schema, SDK version or source commit does not match the requested release.'
    }
    $ids = @('SOU.Live.Contracts', 'SOU.Hud.Sdk', 'SOU.Hud.Sdk.Blazor', 'SOU.Hud.Tool', 'SOU.Hud.Templates')
    $records = @($manifest.packages)
    if ($records.Count -ne $ids.Count) { throw 'The release manifest must contain exactly the five SDK packages.' }
    foreach ($record in $records) {
        if ($record.file -isnot [string] -or $record.file -match '[\\/]' -or $record.file.StartsWith('.')) {
            throw 'Unsafe package filename in release manifest.'
        }
    }
    $files = @(Get-ChildItem -LiteralPath $packageDirectory -Force)
    if ($files.Count -ne $ids.Count -or @($files | Where-Object { $_.PSIsContainer -or $_.Extension -cne '.nupkg' }).Count -ne 0) {
        throw 'The packages folder must contain exactly five NuGet package files.'
    }
    $validated = @()
    foreach ($id in $ids) {
        $name = "$id.$expectedVersion.nupkg"
        $matchingFiles = @($files | Where-Object { $_.Name -ceq $name })
        $matchingRecords = @($records | Where-Object { $_.file -ceq $name })
        if ($matchingFiles.Count -ne 1 -or $matchingRecords.Count -ne 1) { throw "Missing or duplicate SDK package identity: $id" }
        $file = $matchingFiles[0]
        if ($file.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw 'SDK package files must not be symbolic links.' }
        $hash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
        if ($matchingRecords[0].sha256 -isnot [string] -or $matchingRecords[0].sha256 -cnotmatch '\A[0-9a-fA-F]{64}\z' -or $matchingRecords[0].sha256 -ine $hash) {
            throw "SDK package SHA256 mismatch: $id"
        }
        $archive = [IO.Compression.ZipFile]::OpenRead($file.FullName)
        try {
            $manifests = @($archive.Entries | Where-Object { $_.FullName -ceq "$id.nuspec" })
            $licenses = @($archive.Entries | Where-Object { $_.FullName -ceq 'LICENSE' })
            $readmes = @($archive.Entries | Where-Object { $_.FullName -ceq 'README.md' })
            if ($manifests.Count -ne 1 -or $manifests[0].Length -gt 1048576 -or $licenses.Count -ne 1 -or $licenses[0].Length -eq 0 -or $readmes.Count -ne 1 -or $readmes[0].Length -eq 0) {
                throw "Missing or invalid package manifest, LICENSE or README.md: $id"
            }
            $xmlSettings = [Xml.XmlReaderSettings]::new()
            $xmlSettings.DtdProcessing = [Xml.DtdProcessing]::Prohibit
            $xmlSettings.XmlResolver = $null
            $stream = $manifests[0].Open()
            $reader = [Xml.XmlReader]::Create($stream, $xmlSettings)
            try {
                $nuspec = [Xml.XmlDocument]::new()
                $nuspec.XmlResolver = $null
                $nuspec.Load($reader)
            } finally { $reader.Dispose(); $stream.Dispose() }
            $metadata = $nuspec.SelectSingleNode("/*[local-name()='package']/*[local-name()='metadata']")
            if ($null -eq $metadata) { throw "Missing package metadata: $id" }
            $idNode = $metadata.SelectSingleNode("*[local-name()='id']")
            $versionNode = $metadata.SelectSingleNode("*[local-name()='version']")
            $licenseNode = $metadata.SelectSingleNode("*[local-name()='license']")
            $readmeNode = $metadata.SelectSingleNode("*[local-name()='readme']")
            if ($null -eq $idNode -or $null -eq $versionNode -or $null -eq $licenseNode -or $null -eq $readmeNode -or
                $idNode.InnerText -cne $id -or $versionNode.InnerText -cne $expectedVersion -or
                $licenseNode.GetAttribute('type') -cne 'expression' -or $licenseNode.InnerText -cne 'MIT' -or $readmeNode.InnerText -cne 'README.md') {
                throw "Unexpected package identity, version, MIT license or README metadata: $id"
            }
        } finally { $archive.Dispose() }
        $validated += $file.FullName
        Write-Output "Validated $name SHA256=$hash"
    }
    if ($ValidateOnly) {
        Write-Output 'Release validation passed; no credentials requested and nothing uploaded.'
        return
    }
    if ([string]::IsNullOrWhiteSpace($env:NUGET_API_KEY)) { throw 'The temporary NUGET_API_KEY is missing.' }
    foreach ($file in $validated) {
        # .NET 10.0.300+ reads NUGET_API_KEY directly. Never place the key in arguments or logs.
        & dotnet nuget push $file --source 'https://api.nuget.org/v3/index.json'
        if ($LASTEXITCODE -ne 0) { throw 'NuGet upload failed. Check accepted packages before retrying; published versions cannot be replaced.' }
    }
    Write-Output 'All five packages submitted. Check NuGet validation, indexing and sOU ownership.'
} finally {
    if (-not $ValidateOnly) { $env:NUGET_API_KEY = $null }
}
