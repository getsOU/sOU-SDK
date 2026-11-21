# sOU HUD SDK

Build your own CS2 HUD with HTML/CSS/JavaScript or C#/Blazor WebAssembly. The sOU HUD SDK provides processed game and match data, editable HUD panels, starter projects and tools for creating installable `.souhud` packages.

HUD SDK 0.3.0 is the stable release for HUD API v3. One session supplies game data, panels, views and options. HUDs subscribe to the values they render. Existing v2 HUDs remain supported.

The recording API exposes round history and combat data. Kill-feed entries can include the previous traded kill. For match countdowns, `HudCountdown.MatchStartRemaining` (C#) and `matchStartRemaining` (JavaScript) select `ManagedMatch.DelayedStartsAt` when set and fall back to `StartsAt`.

With sOU Desktop 0.4.0 or later, switching tabs or hiding a still-loaded OBS browser source preserves HUD components and playercam connections. The HUD clock synchronizes with the host when the view returns. To keep the same document across scenes, disable the OBS options that shut down the hidden source or refresh it when the scene becomes active.

Start with the [HUD author guide](https://www.getsou.app/docs/hud-entwicklung), which explains creating, editing, packaging and opening your HUD in sOU. The Web starter needs no npm build step; use .NET SDK 10.0.403 or a later .NET 10 servicing SDK, including runtime 10.0.14 or later, for author tools and Blazor.

| Package | Purpose |
| --- | --- |
| [SOU.Hud.Templates](https://www.nuget.org/packages/SOU.Hud.Templates/0.3.0) | Web and Blazor starter projects for `dotnet new`. |
| [SOU.Hud.Tool](https://www.nuget.org/packages/SOU.Hud.Tool/0.3.0) | The `sou-hud` command for packaging and validation. |
| [SOU.Hud.Sdk](https://www.nuget.org/packages/SOU.Hud.Sdk/0.3.0) | C# session, validated object graph, selectors, options and panel helpers. |
| [SOU.Hud.Sdk.Blazor](https://www.nuget.org/packages/SOU.Hud.Sdk.Blazor/0.3.0) | Official v3 Blazor host, selective regions, render clock and optional diagnostics. |
| [SOU.Live.Contracts](https://www.nuget.org/packages/SOU.Live.Contracts/0.3.0) | Read-only data models used by the C# client. |

Install all sOU SDK dependencies at version `0.3.0`. To install the packaging tool and start a Web HUD in a new directory:

```sh
dotnet tool install SOU.Hud.Tool --version 0.3.0 --tool-path ./tools
./tools/sou-hud init web ./MyWebHud --id my-web-hud
```

Use `init blazor` for a Blazor WebAssembly HUD. SDK versions, HUD package versions and HUD API versions are independent.

[Game and match API](https://www.getsou.app/docs/hud-api) · [Data type reference](https://www.getsou.app/docs/hud-vertragstypen) · [HUD panels](https://www.getsou.app/docs/hud-panel-referenz) · [Package format](https://www.getsou.app/docs/hud-paketformat)

The original SDK components and starter templates are licensed under [MIT](LICENSE); see [license scope and third-party notices](LICENSING.md). You may use them in free, paid and closed-source HUDs. Preserve the required license and copyright notices when redistributing SDK code. The sOU application, trademarks and third-party HUD assets retain their existing terms.
