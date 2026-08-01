# Eventide Documentation

See [example.luau](example.luau) for a runnable Eventide Gen1 gallery containing every active component.

Eventide currently follows the upstream [Starlight Gen1 API documentation](https://docs.nebulasoftworks.xyz/starlight/).

## Collapsible toggle settings

Call `AddSettings` on a toggle to place a gear beside it and create a settings area that starts collapsed. The returned object is a normal groupbox, so it supports standard groupbox components, nested components through labels or toggles, and config save/load.

```luau
local feature = groupbox:CreateToggle({
	Name = "Feature",
	CurrentValue = false,
	Style = 2,
	Callback = function(enabled)
		print(enabled)
	end,
}, "feature")

local settings = feature:AddSettings({
	Name = "Feature Settings",
	Expanded = false,
})

settings:CreateSlider({
	Name = "Intensity",
	Range = { 0, 100 },
	CurrentValue = 50,
	Increment = 5,
	Callback = function(value)
		print(value)
	end,
}, "intensity")
```

`CreateSettings` is an alias for `AddSettings`. Use `SetSettingsExpanded(boolean)` or `ToggleSettings()` when the panel needs to be controlled from code. `SettingsIcon` and `SettingsTooltip` customize the gear on the toggle.
