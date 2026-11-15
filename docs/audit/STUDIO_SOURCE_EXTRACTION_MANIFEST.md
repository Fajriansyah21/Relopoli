# Studio Source Extraction Manifest

## Project and baseline

- Studio project: Pengembangan Relopoli
- Place ID: 132915201476897
- Universe ID: 10776586009
- Studio mode: Edit
- persistedToCloud at verification: true
- Repository: Fajriansyah21/Relopoli, branch `main`
- Baseline commit: `962e00ac6d9336638e13376720bc223816cc3065`
- Extraction timestamp: 2026-11-15 13:43:24 UTC
- Extraction scope: all DataModel `LuaSourceContainer` instances outside `ServerStorage.LegacyBackup`; legacy entries listed without extraction.

## Method

1. Verified the connected Studio instance with `list_roblox_studios`; confirmed Edit mode and project IDs.
2. Enumerated `LuaSourceContainer` with `search_game_tree` over Edit DataModel (maximum supported traversal depth 10); result contained 36 entries and was not truncated by the tool.
3. Used `inspect_instance` on BaseScript instances to record Enabled/Disabled. All six non-legacy Script/LocalScript instances were Enabled and not Disabled. ModuleScripts have no Disabled execution property and are loaded only when required.
4. Read every non-legacy source with `script_read`. MCP returned line-numbered text; line numbers and arrow delimiters were removed, preserving each returned source line and joining lines with LF.
5. Wrote UTF-8 without BOM to the mapped `src/` path. All destinations were checked and absent before writing.
6. Read every local file back and compared its complete text to the reconstructed source text from `script_read`. Result: 29/29 exact text matches.

The comparison covers the text exposed by `script_read`; it does not attest to runtime behavior, test results, or source synchronization from GitHub/Rojo. No Studio instance was modified.

## Complete script inventory

Dependencies list statically visible ModuleScript `require` targets and Roblox services; it is not a runtime dependency test.

| Original DataModel path | Class | Local repository path | Extraction status | Source comparison | Disabled state | Dependencies |
|---|---|---|---|---|---|---|
| `StarterPlayer.StarterCharacterScripts.WalkAnimController` | LocalScript | `src/StarterPlayer/StarterCharacterScripts/WalkAnimController.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | Enabled=true; Disabled=false | `ReplicatedStorage` service |
| `StarterGui.PromptGui.PromptUI` | LocalScript | `src/StarterGui/PromptGui/PromptUI.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | Enabled=true; Disabled=false | `Players` service<br>`ReplicatedStorage` service<br>`TweenService` service |
| `StarterGui.PlayerScreen.PlayerScreenUI` | LocalScript | `src/StarterGui/PlayerScreen/PlayerScreenUI.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | Enabled=true; Disabled=false | `require(Modules:WaitForChild("Constants"))`<br>`require(Modules:WaitForChild("BoardConfig"))`<br>`require(Modules:WaitForChild("ArrowIndicator"))`<br>`Players` service<br>`ReplicatedStorage` service<br>`TweenService` service<br>`Lighting` service |
| `ReplicatedStorage.Modules.Constants` | ModuleScript | `src/ReplicatedStorage/Modules/Constants.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | — |
| `ReplicatedStorage.Modules.BoardConfig` | ModuleScript | `src/ReplicatedStorage/Modules/BoardConfig.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | — |
| `ReplicatedStorage.Modules.PropertyData` | ModuleScript | `src/ReplicatedStorage/Modules/PropertyData.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | — |
| `ReplicatedStorage.Modules.ArrowIndicator` | ModuleScript | `src/ReplicatedStorage/Modules/ArrowIndicator.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.BoardConfig)`<br>`ReplicatedStorage` service<br>`TweenService` service |
| `ServerScriptService.Systems.DiceSystem` | Script | `src/ServerScriptService/Systems/DiceSystem.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | Enabled=true; Disabled=false | `require(SSS.Core.DiceBridge)`<br>`ReplicatedStorage` service<br>`ServerScriptService` service |
| `ServerScriptService.Core.GameState` | ModuleScript | `src/ServerScriptService/Core/GameState.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`ReplicatedStorage` service |
| `ServerScriptService.Core.TurnController` | ModuleScript | `src/ServerScriptService/Core/TurnController.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`require(SSS.Core.GameState)`<br>`ReplicatedStorage` service<br>`Players` service<br>`ServerScriptService` service |
| `ServerScriptService.Core.Main` | Script | `src/ServerScriptService/Core/Main.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | Enabled=true; Disabled=false | `require(RS.Modules.Constants)`<br>`require(SSS.Core.GameState)`<br>`require(SSS.Core.TurnController)`<br>`require(SSS.Core.Economy)`<br>`require(SSS.Core.MovementEngine)`<br>`require(SSS.Core.RollFlow)`<br>`require(SSS.Core.BoardSetup)`<br>`require(SSS.Core.PropertyFlow)`<br>`require(SSS.Core.ModifierService)`<br>`require(SSS.Core.CrownFlow)`<br>`require(SSS.Core.RewardFlow)`<br>`require(SSS.Core.VictoryService)`<br>`require(SSS.Core.AssetsService)`<br>`Players` service<br>`ReplicatedStorage` service<br>`ServerScriptService` service |
| `ServerScriptService.Core.DiceBridge` | ModuleScript | `src/ServerScriptService/Core/DiceBridge.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | — |
| `ServerScriptService.Core.Economy` | ModuleScript | `src/ServerScriptService/Core/Economy.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`require(SSS.Core.GameState)`<br>`ReplicatedStorage` service<br>`ServerScriptService` service<br>`Players` service |
| `ServerScriptService.Core.StartService` | ModuleScript | `src/ServerScriptService/Core/StartService.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`require(SSS.Core.Economy)`<br>`ReplicatedStorage` service<br>`ServerScriptService` service |
| `ServerScriptService.Core.LandingResolver` | ModuleScript | `src/ServerScriptService/Core/LandingResolver.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`require(RS.Modules.BoardConfig)`<br>`ReplicatedStorage` service |
| `ServerScriptService.Core.ArrowIndicator` | ModuleScript | `src/ServerScriptService/Core/ArrowIndicator.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(game:GetService("ReplicatedStorage").Modules.ArrowIndicator)`<br>`ReplicatedStorage` service |
| `ServerScriptService.Core.MovementEngine` | ModuleScript | `src/ServerScriptService/Core/MovementEngine.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`require(RS.Modules.BoardConfig)`<br>`require(SSS.Core.GameState)`<br>`require(SSS.Core.ArrowIndicator)`<br>`Players` service<br>`ReplicatedStorage` service<br>`ServerScriptService` service<br>`RunService` service<br>`PhysicsService` service |
| `ServerScriptService.Core.RollFlow` | ModuleScript | `src/ServerScriptService/Core/RollFlow.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`require(SSS.Core.GameState)`<br>`require(SSS.Core.TurnController)`<br>`require(SSS.Core.DiceBridge)`<br>`require(SSS.Core.MovementEngine)`<br>`require(SSS.Core.StartService)`<br>`require(SSS.Core.LandingResolver)`<br>`ReplicatedStorage` service<br>`ServerScriptService` service |
| `ServerScriptService.Core.BoardSetup` | ModuleScript | `src/ServerScriptService/Core/BoardSetup.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.BoardConfig)`<br>`require(RS.Modules.Constants)`<br>`ReplicatedStorage` service |
| `ServerScriptService.Core.Liquidation` | ModuleScript | `src/ServerScriptService/Core/Liquidation.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(SSS.Core.GameState)`<br>`ReplicatedStorage` service<br>`ServerScriptService` service<br>`Players` service |
| `ServerScriptService.Core.PropertyService` | ModuleScript | `src/ServerScriptService/Core/PropertyService.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`require(RS.Modules.BoardConfig)`<br>`require(RS.Modules.PropertyData)`<br>`require(SSS.Core.GameState)`<br>`require(SSS.Core.Economy)`<br>`require(SSS.Core.TurnController)`<br>`ReplicatedStorage` service<br>`ServerScriptService` service<br>`Players` service |
| `ServerScriptService.Core.PropertyFlow` | ModuleScript | `src/ServerScriptService/Core/PropertyFlow.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`require(RS.Modules.BoardConfig)`<br>`require(RS.Modules.PropertyData)`<br>`require(SSS.Core.GameState)`<br>`require(SSS.Core.Economy)`<br>`require(SSS.Core.TurnController)`<br>`require(SSS.Core.LandingResolver)`<br>`require(SSS.Core.PropertyService)`<br>`require(SSS.Core.Liquidation)`<br>`require(SSS.Core.ModifierService)`<br>`ReplicatedStorage` service<br>`ServerScriptService` service<br>`Players` service |
| `ServerScriptService.Core.CrownService` | ModuleScript | `src/ServerScriptService/Core/CrownService.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`require(RS.Modules.BoardConfig)`<br>`require(SSS.Core.GameState)`<br>`require(SSS.Core.Economy)`<br>`require(SSS.Core.PropertyService)`<br>`ReplicatedStorage` service<br>`ServerScriptService` service<br>`Players` service |
| `ServerScriptService.Core.ModifierService` | ModuleScript | `src/ServerScriptService/Core/ModifierService.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`require(SSS.Core.GameState)`<br>`require(SSS.Core.PropertyService)`<br>`require(SSS.Core.CrownService)`<br>`require(SSS.Core.StartService)`<br>`ReplicatedStorage` service<br>`ServerScriptService` service |
| `ServerScriptService.Core.VictoryService` | ModuleScript | `src/ServerScriptService/Core/VictoryService.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`require(SSS.Core.GameState)`<br>`require(SSS.Core.Economy)`<br>`require(SSS.Core.PropertyService)`<br>`require(SSS.Core.CrownService)`<br>`ReplicatedStorage` service<br>`ServerScriptService` service |
| `ServerScriptService.Core.CrownFlow` | ModuleScript | `src/ServerScriptService/Core/CrownFlow.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`require(RS.Modules.BoardConfig)`<br>`require(SSS.Core.GameState)`<br>`require(SSS.Core.Economy)`<br>`require(SSS.Core.LandingResolver)`<br>`require(SSS.Core.CrownService)`<br>`require(SSS.Core.Liquidation)`<br>`require(SSS.Core.PropertyFlow)`<br>`ReplicatedStorage` service<br>`ServerScriptService` service |
| `ServerScriptService.Core.RewardFlow` | ModuleScript | `src/ServerScriptService/Core/RewardFlow.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.Constants)`<br>`require(RS.Modules.BoardConfig)`<br>`require(SSS.Core.GameState)`<br>`require(SSS.Core.LandingResolver)`<br>`require(SSS.Core.PropertyService)`<br>`require(SSS.Core.ModifierService)`<br>`require(SSS.Core.PropertyFlow)`<br>`ReplicatedStorage` service<br>`ServerScriptService` service |
| `ServerScriptService.Core.AssetsService` | ModuleScript | `src/ServerScriptService/Core/AssetsService.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | N/A (ModuleScript; not auto-executed) | `require(RS.Modules.BoardConfig)`<br>`require(SSS.Core.GameState)`<br>`require(SSS.Core.Economy)`<br>`require(SSS.Core.PropertyService)`<br>`require(SSS.Core.CrownService)`<br>`require(SSS.Core.ModifierService)`<br>`ReplicatedStorage` service<br>`ServerScriptService` service<br>`Players` service |
| `StarterGui.DiceGui.RollButton.LocalScript` | LocalScript | `src/StarterGui/DiceGui/RollButton/LocalScript.luau` | EXTRACTED_AND_VERIFIED | Exact text match (read-back) | Enabled=true; Disabled=false | `require(RS:WaitForChild("Modules"):WaitForChild("Constants"))`<br>`ReplicatedStorage` service<br>`Players` service |
| `ServerStorage.LegacyBackup.TilePrice_Legacy` | ModuleScript | — | LEGACY | Not extracted; not compared | N/A (ModuleScript) | Not read (excluded by scope) |
| `ServerStorage.LegacyBackup.Setup.SetupTiles` | Script | — | LEGACY | Not extracted; not compared | Disabled=true | Not read (excluded by scope) |
| `ServerStorage.LegacyBackup.Setup.SetupBillboard` | Script | — | LEGACY | Not extracted; not compared | Disabled=true | Not read (excluded by scope) |
| `ServerStorage.LegacyBackup.Systems.DiceSystem` | Script | — | LEGACY | Not extracted; not compared | Disabled=true | Not read (excluded by scope) |
| `ServerStorage.LegacyBackup.Systems.TurnSystem` | Script | — | LEGACY | Not extracted; not compared | Disabled=true | Not read (excluded by scope) |
| `ServerStorage.LegacyBackup.Systems.MovementSystem` | Script | — | LEGACY | Not extracted; not compared | Disabled=true | Not read (excluded by scope) |
| `ServerStorage.LegacyBackup.Systems.TileSystem` | Script | — | LEGACY | Not extracted; not compared | Disabled=true | Not read (excluded by scope) |

## Legacy scripts excluded

The seven `ServerStorage.LegacyBackup` entries above were recorded as LEGACY and intentionally not read or extracted. Script instances inspected in this folder reported Disabled=true. `TilePrice_Legacy` is a ModuleScript and has no Disabled property.

## Incomplete or unreadable source

None reported by `script_read`: all 29 reads had contiguous line numbering from line 1 to the final returned line and no truncation marker. No active inventory entry was left partially extracted.

## Non-script instance dependencies observed

Static source references include:
- ReplicatedStorage `RemoteEvents` used by gameplay and UI scripts, including roll, turn, prompt, liquidation, notification, movement-animation, and asset update/action remotes.
- Workspace `Board1`, its `Dice` model and physical dice/vision objects, plus board tile instances referenced by BoardConfig/MovementEngine.
- Player/character objects, Humanoid/Animator, GUI descendants, PhysicsService, and RunService.
- ReplicatedStorage Modules and ServerScriptService.Core modules listed in the dependency column.

These are references in extracted source; this manifest does not independently validate every referenced non-script instance.
