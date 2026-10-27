# sOU HUD SDK

Build your own CS2 HUD with HTML/CSS/JavaScript or C#/Blazor WebAssembly. The sOU HUD SDK provides processed game and match data, editable HUD panels, starter projects and tools for creating installable `.souhud` packages.

SDK 0.3.0-preview.1 owns the shared game, panel, view and options session, selective subscriptions, connection recovery and server-time helpers. HUD code selects the data it renders. Existing v2 HUDs remain supported.

This SDK release contains five matching packages, including `SOU.Hud.Sdk.Blazor`. Historical preview releases retain their original package sets and bytes.

Start with the [HUD author guide](https://www.getsou.app/docs/hud-entwicklung), which explains creating, editing, packaging and opening your HUD in sOU. The Web starter needs no npm build step; the Blazor starter uses .NET 10.

| Package | Purpose |
| --- | --- |
| [SOU.Hud.Templates](https://www.nuget.org/packages/SOU.Hud.Templates) | Web and Blazor starter projects for `dotnet new`. |
| [SOU.Hud.Tool](https://www.nuget.org/packages/SOU.Hud.Tool) | The `sou-hud` command for packaging and validation. |
| [SOU.Hud.Sdk](https://www.nuget.org/packages/SOU.Hud.Sdk) | C# session, validated object graph, selectors, options and panel helpers. |
| [SOU.Hud.Sdk.Blazor](https://www.nuget.org/packages/SOU.Hud.Sdk.Blazor) | Official v3 Blazor host, selective regions, render clock and optional diagnostics. |
| [SOU.Live.Contracts](https://www.nuget.org/packages/SOU.Live.Contracts) | Read-only data models used by the C# client. |

The package links show the publication status and available versions on NuGet.org. SDK 0.3.0-preview.1 contains five matching packages; historical previews retain their original package sets. SDK package versions, your own HUD package version and HUD protocol versions 2 and 3 are separate values.

[Game and match API](https://www.getsou.app/docs/hud-api) · [Data type reference](https://www.getsou.app/docs/hud-vertragstypen) · [HUD panels](https://www.getsou.app/docs/hud-panel-referenz) · [Package format](https://www.getsou.app/docs/hud-paketformat)

The original SDK components and starter templates are licensed under [MIT](LICENSE); see [license scope and third-party notices](LICENSING.md). You may use them in free, paid and closed-source HUDs. Preserve the required license and copyright notices when redistributing SDK code. The sOU application, trademarks and third-party HUD assets retain their existing terms.
