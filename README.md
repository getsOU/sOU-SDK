# sOU HUD SDK

Build your own CS2 HUD with HTML/CSS/JavaScript or C#/Blazor WebAssembly. The sOU HUD SDK provides processed game and match data, editable HUD panels, starter projects and tools for creating installable `.souhud` packages.

Start with the [HUD author guide](https://sou.sofc.dev/docs/hud-entwicklung), which explains creating, editing, packaging and opening your HUD in sOU. The Web starter needs no npm build step; the Blazor starter uses .NET 10.

| Package | Purpose |
| --- | --- |
| [SOU.Hud.Templates](https://www.nuget.org/packages/SOU.Hud.Templates) | Web and Blazor starter projects for `dotnet new`. |
| [SOU.Hud.Tool](https://www.nuget.org/packages/SOU.Hud.Tool) | The `sou-hud` command for packaging and validation. |
| [SOU.Hud.Sdk](https://www.nuget.org/packages/SOU.Hud.Sdk) | C# browser client for Blazor HUDs. |
| [SOU.Live.Contracts](https://www.nuget.org/packages/SOU.Live.Contracts) | Read-only data models used by the C# client. |

The package links show the publication status and available versions on NuGet.org. Use matching versions of the four SDK packages. SDK versions, your own HUD package version and HUD protocol version 2 are separate values.

[Game and match API](https://sou.sofc.dev/docs/hud-api) · [Data type reference](https://sou.sofc.dev/docs/hud-vertragstypen) · [HUD panels](https://sou.sofc.dev/docs/hud-panel-referenz) · [Package format](https://sou.sofc.dev/docs/hud-paketformat)

The original SDK components and starter templates are licensed under [MIT](LICENSE); see [license scope and third-party notices](LICENSING.md). You may use them in free, paid and closed-source HUDs. Preserve the required license and copyright notices when redistributing SDK code. The sOU application, trademarks and third-party HUD assets retain their existing terms.
