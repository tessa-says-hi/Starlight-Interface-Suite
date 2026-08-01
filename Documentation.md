# Eventide Interface Suite

Eventide is a rebranded Gen1 fork of the Starlight Interface Suite. This page documents the active API in this fork, including its components, nested controls, collapsible toggle settings, themes, configurations, dialogs, and lifecycle methods.

> [!IMPORTANT]
> Eventide is designed for client environments that provide <code>loadstring</code> and <code>game:HttpGet</code>. Configuration and custom-theme files additionally require executor filesystem functions such as <code>isfile</code>, <code>readfile</code>, and <code>writefile</code>.

## Quick links

- [Complete component gallery](example.luau)
- [Eventide source](Source.lua)
- [Raw Eventide loader](https://raw.githubusercontent.com/tessa-says-hi/Starlight-Interface-Suite/master/Source.lua)
- [Nebula Icon Library loader](https://raw.githubusercontent.com/tessa-says-hi/Nebula-Icon-Library/master/Loader.luau)
- [Upstream Starlight documentation](https://docs.nebulasoftworks.xyz/starlight/)

## Installation

Load the current Eventide source from this fork:

~~~luau
local Eventide = loadstring(game:HttpGet("https://raw.githubusercontent.com/tessa-says-hi/Starlight-Interface-Suite/master/Source.lua"))()
~~~

### Icons

Icons are Roblox asset IDs. The optional Nebula Icon Library makes those IDs easier to look up:

~~~luau
local NebulaIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/tessa-says-hi/Nebula-Icon-Library/master/Loader.luau"))()

local settingsIcon = NebulaIcons:GetIcon("settings", "Lucide")
local colorIcon = NebulaIcons:GetIcon("color_lens", "Material")
~~~

Pass a returned icon anywhere Eventide accepts <code>Icon</code>, <code>CheckboxIcon</code>, or <code>SettingsIcon</code>.

## Minimal example

~~~luau
local Eventide = loadstring(game:HttpGet("https://raw.githubusercontent.com/tessa-says-hi/Starlight-Interface-Suite/master/Source.lua"))()

local Window = Eventide:CreateWindow({
	Name = "My Eventide UI",
	Subtitle = "Example",
	LoadingEnabled = false,
	NotifyOnCallbackError = true,
	FileSettings = {
		RootFolder = "My Script",
		ConfigFolder = "Default",
		ThemesInRoot = true,
	},
})

local section = Window:CreateTabSection("MAIN")
local tab = section:CreateTab({
	Name = "General",
	Columns = 2,
}, "general")

local groupbox = tab:CreateGroupbox({
	Name = "Controls",
	Column = 1,
	Style = 1,
}, "controls")

groupbox:CreateToggle({
	Name = "Enabled",
	CurrentValue = false,
	Style = 2,
	Callback = function(enabled)
		print("Enabled:", enabled)
	end,
}, "enabled")

Eventide:LoadAutoloadTheme()
Eventide:LoadAutoloadConfig()
~~~

## Object hierarchy

Eventide uses the following hierarchy:

~~~text
Eventide
└── Window
    └── TabSection
        └── Tab
            └── Groupbox
                ├── Button
                ├── Toggle
                ├── Slider
                ├── Input
                ├── Label
                ├── Paragraph
                └── Divider
~~~

Binds, color pickers, and dropdowns are nested controls. Add them to a label or toggle with <code>AddBind</code>, <code>AddColorPicker</code>, or <code>AddDropdown</code>.

Most creation methods take a settings table followed by an index:

~~~luau
local element = groupbox:CreateButton(settings, "stable_index")
~~~

Use a unique, stable string for every tab, groupbox, element, and nested control. Eventide uses these indices to find objects when saving and loading configurations.

## Window

Create one window with <code>Eventide:CreateWindow(settings)</code>.

| Setting | Type | Description |
| --- | --- | --- |
| <code>Name</code> | string | Window title. |
| <code>Subtitle</code> | string | Text shown in the top bar. |
| <code>Icon</code> | asset ID | Window, loading, and mobile-toggle icon. |
| <code>DefaultSize</code> | UDim2 | Optional starting window size. |
| <code>LoadingEnabled</code> | boolean | Shows the loading screen when true. |
| <code>LoadingSettings.Title</code> | string | Loading title. |
| <code>LoadingSettings.Subtitle</code> | string | Loading subtitle. |
| <code>LoadingSettings.Logo</code> | asset ID | Loading logo. |
| <code>LoadingSettings.IconAnimation</code> | function | Optional animation callback receiving the loading icon. |
| <code>BuildWarnings</code> | boolean | Enables interface-build mismatch warnings. |
| <code>NotifyOnCallbackError</code> | boolean | Shows a notification when a protected callback errors. Defaults to true. |
| <code>FileSettings.RootFolder</code> | string | Root folder beneath <code>Eventide Interface Suite</code>. |
| <code>FileSettings.ConfigFolder</code> | string | Script-specific configuration folder. |
| <code>FileSettings.ThemesInRoot</code> | boolean | Shares themes across config folders when true. |

The default window visibility key is <code>K</code>. It can be changed before or after creating the window:

~~~luau
Eventide.WindowKeybind = "RightShift"
~~~

## Navigation and layout

### Home tab

<code>Window:CreateHomeTab(settings)</code> creates the prebuilt dashboard. It can only be created once.

~~~luau
Window:CreateHomeTab({
	SupportedExecutors = {},
	UnsupportedExecutors = {},
	DiscordInvite = "your-invite-code",
	Backdrop = 0,
	IconStyle = 1,
	Changelog = {
		{
			Title = "Initial release",
			Date = "July 31, 2026",
			Description = "Created the interface.",
		},
	},
})
~~~

<code>Backdrop = 0</code> uses the current game's thumbnail. A different numeric asset ID uses that image instead.

### Tab sections

~~~luau
local section = Window:CreateTabSection("COMBAT")
local hiddenHeaderSection = Window:CreateTabSection("INTERNAL", false)
~~~

Returned section methods:

- <code>section:Set(newName)</code>
- <code>section:Destroy()</code>
- <code>section:CreateTab(settings, index)</code>
- <code>section:CreateCustomTab(settings, index)</code>

### Tabs

~~~luau
local tab = section:CreateTab({
	Name = "Player",
	Icon = 0,
	Columns = 2,
}, "player")
~~~

<code>Columns</code> controls the scrolling columns available to groupboxes. Use a <code>Column</code> value from <code>1</code> through the tab's column count when creating each groupbox.

Returned tab methods:

- <code>tab:Set(newSettings)</code>
- <code>tab:Destroy()</code>
- <code>tab:CreateGroupbox(settings, index)</code>
- <code>tab:BuildThemeGroupbox(column, style, buttonsCentered)</code>
- <code>tab:BuildConfigGroupbox(column, style, buttonsCentered)</code>

### Groupboxes

~~~luau
local groupbox = tab:CreateGroupbox({
	Name = "Movement",
	Icon = 0,
	Column = 1,
	Style = 2,
}, "movement")
~~~

Groupbox <code>Style</code> accepts <code>1</code> or <code>2</code>. A groupbox supports every base component factory documented below. It also returns <code>Set(newSettings)</code> and <code>Destroy()</code>.

### Custom tabs

Use <code>CreateCustomTab</code> to place an existing <code>GuiObject</code> inside Eventide's tab container:

~~~luau
local page = Instance.new("Frame")
page.Size = UDim2.fromScale(1, 1)
page.BackgroundTransparency = 1

section:CreateCustomTab({
	Name = "Custom",
	Icon = 0,
	Page = page,
}, "custom")
~~~

## Components

| Component | Factory | Callback value |
| --- | --- | --- |
| Button | <code>groupbox:CreateButton</code> | No arguments |
| Toggle | <code>groupbox:CreateToggle</code> | boolean |
| Slider | <code>groupbox:CreateSlider</code> | number |
| Input | <code>groupbox:CreateInput</code> | string |
| Label | <code>groupbox:CreateLabel</code> | None |
| Paragraph | <code>groupbox:CreateParagraph</code> | None |
| Divider | <code>groupbox:CreateDivider</code> | None |
| Bind | <code>label:AddBind</code> or <code>toggle:AddBind</code> | boolean |
| Color picker | <code>label:AddColorPicker</code> or <code>toggle:AddColorPicker</code> | Color3, transparency |
| Dropdown | <code>label:AddDropdown</code> or <code>toggle:AddDropdown</code> | selected-options table |

### Buttons

~~~luau
local button = groupbox:CreateButton({
	Name = "Run Action",
	Icon = 0,
	Tooltip = "Runs the action once.",
	Style = 1,
	CenterContent = true,
	IndicatorStyle = 1,
	Callback = function()
		print("Pressed")
	end,
}, "run_action")
~~~

Button <code>Style</code> accepts <code>1</code> or <code>2</code>. <code>IndicatorStyle</code> accepts <code>1</code> for a chevron, <code>2</code> for the alternate indicator, or can be omitted.

### Toggles

~~~luau
local checkbox = groupbox:CreateToggle({
	Name = "Checkbox",
	CurrentValue = false,
	CheckboxIcon = 0,
	Style = 1,
	Callback = function(enabled)
		print(enabled)
	end,
}, "checkbox")

local switch = groupbox:CreateToggle({
	Name = "Switch",
	CurrentValue = true,
	Style = 2,
	Callback = function(enabled)
		print(enabled)
	end,
}, "switch")
~~~

Style <code>1</code> renders a checkbox and style <code>2</code> renders a switch.

### Sliders

~~~luau
local slider = groupbox:CreateSlider({
	Name = "Speed",
	Tooltip = "Choose a speed.",
	Range = { 0, 100 },
	CurrentValue = 50,
	Increment = 5,
	Suffix = "%",
	HideMax = false,
	Callback = function(value)
		print(value)
	end,
}, "speed")
~~~

<code>Range</code> is required. <code>CurrentValue</code> defaults to the first range value, <code>Increment</code> defaults to <code>1</code>, and <code>HideMax</code> defaults to false.

### Inputs

~~~luau
local input = groupbox:CreateInput({
	Name = "Profile Name",
	CurrentValue = "Default",
	PlaceholderText = "Enter a name",
	Numeric = false,
	Enter = false,
	MaxCharacters = 32,
	RemoveTextOnFocus = false,
	RemoveTextAfterFocusLost = false,
	Callback = function(text)
		print(text)
	end,
}, "profile_name")
~~~

When <code>Enter</code> is false, the callback runs as the text changes. When true, it runs when the input loses focus. <code>Numeric</code> filters nonnumeric text and <code>MaxCharacters = -1</code> removes the length limit.

### Labels

~~~luau
local label = groupbox:CreateLabel({
	Name = "Target",
	Icon = 0,
	Tooltip = "Labels can host nested controls.",
}, "target")
~~~

Labels are text rows and the primary parent for standalone binds, color pickers, and dropdowns.

### Paragraphs

~~~luau
local paragraph = groupbox:CreateParagraph({
	Name = "Information",
	Icon = 0,
	Content = "Paragraphs automatically resize for multi-line content.",
}, "information")
~~~

### Dividers

~~~luau
local divider = groupbox:CreateDivider()
~~~

Dividers accept no settings. The returned divider exposes <code>Destroy()</code>.

## Common element methods

Base elements return an object containing their current <code>Values</code>. Their common methods are:

| Method | Purpose |
| --- | --- |
| <code>element:Set(newSettings, newIndex?)</code> | Updates the element. Omitted settings are preserved by the active element implementations. |
| <code>element:Lock(reason?)</code> | Blocks interaction and displays an optional reason. |
| <code>element:Unlock()</code> | Restores interaction. |
| <code>element:Destroy()</code> | Removes the element and its nested controls. |

Buttons, toggles, sliders, inputs, labels, and paragraphs support these methods. A stateful element's <code>Set</code> operation can run its callback.

~~~luau
slider:Set({
	CurrentValue = 75,
})

slider:Lock("Available after spawning")
slider:Unlock()
~~~

Set <code>IgnoreConfig = true</code> on a toggle, slider, input, bind, color picker, or dropdown when its value should not be saved.

## Nested controls

> [!WARNING]
> In the current API, do not call <code>groupbox:CreateDropdown</code>, <code>groupbox:CreateBind</code>, or <code>groupbox:CreateColorPicker</code>. Create a label or toggle first, then call the matching <code>Add...</code> method.

Nested controls return objects with <code>Set(newSettings, newIndex?)</code> and <code>Destroy()</code>.

### Binds

~~~luau
local bind = label:AddBind({
	CurrentValue = "Q",
	HoldToInteract = false,
	Callback = function(active)
		print("Bind active:", active)
	end,
	OnChangedCallback = function(key)
		print("New key:", key)
	end,
}, "bind")
~~~

| Setting | Description |
| --- | --- |
| <code>CurrentValue</code> | Enum key name as a string, such as <code>Q</code> or <code>RightShift</code>. |
| <code>HoldToInteract</code> | Reports active while held when true; otherwise activates on a press. |
| <code>SyncToggleState</code> | On a toggle parent, synchronizes the toggle with the bind. Defaults to true. |
| <code>WindowSetting</code> | Makes this bind control Eventide's window visibility key. |
| <code>Callback</code> | Receives the bind's active state. |
| <code>OnChangedCallback</code> | Receives the newly selected key name. |

### Color pickers

~~~luau
local colorPicker = label:AddColorPicker({
	CurrentValue = Color3.fromRGB(159, 73, 53),
	Transparency = 0,
	Callback = function(color, transparency)
		print(color, transparency)
	end,
}, "color")
~~~

<code>Transparency</code> ranges from <code>0</code> for opaque to <code>1</code> for fully transparent.

### Dropdowns

~~~luau
local dropdown = label:AddDropdown({
	Options = { "Low", "Medium", "High" },
	CurrentOption = { "Medium" },
	MultipleOptions = false,
	Required = true,
	Placeholder = "Choose a quality",
	Callback = function(options)
		print(table.concat(options, ", "))
	end,
}, "quality")
~~~

Always treat <code>CurrentOption</code> and the callback value as tables. Set <code>MultipleOptions = true</code> for multiselect. <code>Special = 1</code> populates players and <code>Special = 2</code> populates teams.

All three nested-control types work on toggles as well:

~~~luau
toggle:AddBind(bindSettings, "bind")
toggle:AddColorPicker(colorSettings, "color")
toggle:AddDropdown(dropdownSettings, "dropdown")
~~~

## Collapsible toggle settings

<code>AddSettings</code> adds a gear beside a toggle and returns a normal groupbox inside a collapsible area. The returned groupbox supports the full groupbox component API, including labels with nested controls.

~~~luau
local feature = groupbox:CreateToggle({
	Name = "Feature",
	CurrentValue = false,
	Style = 2,
	SettingsIcon = settingsIcon,
	SettingsTooltip = "Configure this feature",
	Callback = function(enabled)
		print(enabled)
	end,
}, "feature")

local settings = feature:AddSettings({
	Name = "Feature Settings",
	Icon = settingsIcon,
	Style = 2,
	Expanded = false,
	Tooltip = "Open feature settings",
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

settings
	:CreateLabel({
		Name = "Mode",
	}, "mode_label")
	:AddDropdown({
		Options = { "Balanced", "Fast", "Precise" },
		CurrentOption = { "Balanced" },
		Required = true,
		Callback = function(options)
			print(options[1])
		end,
	}, "mode")
~~~

Settings API:

| Member | Purpose |
| --- | --- |
| <code>toggle:AddSettings(settings)</code> | Creates or returns the settings groupbox. |
| <code>toggle:CreateSettings(settings)</code> | Alias for <code>AddSettings</code>. |
| <code>toggle:SetSettingsExpanded(expanded, instant?)</code> | Opens or closes the panel and returns the resulting state. |
| <code>toggle:ToggleSettings()</code> | Toggles the panel and returns the resulting state. |
| <code>toggle.Settings</code> | References the settings groupbox after creation. |
| <code>toggle.SettingsExpanded</code> | Current expansion state. |

Calling <code>Lock()</code> on the toggle also closes its settings panel. Destroying either the toggle or settings groupbox removes the associated settings UI.

## Notifications

~~~luau
Eventide:Notification({
	Title = "Saved",
	Content = "Your configuration was saved.",
	Icon = 0,
	Duration = 5,
})
~~~

<code>Duration</code> is measured in seconds. <code>Icon</code> is optional.

## Dialogs

### Action dialog

Type <code>1</code> creates buttons. The keyed <code>Primary</code> action receives primary styling; array entries receive secondary styling.

~~~luau
Window:PromptDialog({
	Name = "Delete configuration?",
	Content = "This cannot be undone.",
	Icon = 0,
	Type = 1,
	Actions = {
		Primary = {
			Name = "Delete",
			Callback = function()
				print("Deleted")
			end,
		},
		{
			Name = "Cancel",
			Callback = function()
				print("Cancelled")
			end,
		},
	},
})
~~~

### Input dialog

Type <code>2</code> creates one or more inputs:

~~~luau
Window:PromptDialog({
	Name = "Rename profile",
	Content = "Enter a new profile name.",
	Type = 2,
	Actions = {
		{
			CurrentValue = "",
			PlaceholderText = "Profile name",
			RemoveTextOnFocus = false,
			RemoveTextAfterFocusLost = false,
			Callback = function(text)
				print(text)
			end,
		},
	},
})
~~~

Input-dialog actions also accept <code>Numeric</code> and <code>MaxCharacters</code>.

## Themes and acrylic

Add Eventide's prebuilt theme editor to a tab:

~~~luau
tab:BuildThemeGroupbox(1, 1, true)
~~~

The arguments are <code>column</code>, <code>groupboxStyle</code>, and <code>buttonsCentered</code>. The builder includes built-in and custom theme selection, color editing, main-window acrylic, and notification acrylic controls.

Change a theme directly:

~~~luau
Eventide:SetTheme("Eventide")
Eventide:SetTheme("Hollywood Dark")
~~~

Built-in names are:

- Eventide
- Hollywood Dark
- Hollywood Light
- Orca
- Glacier
- Pacific
- Neo
- Neo (Dark)
- Crimson
- Nebula
- Evergreen
- Ubuntu
- Luna
- Tokyo Night
- OperaGX
- BBot
- Hollywood Fluent
- Catppuccin Mocha
- Catppuccin Macchiato
- Catppuccin Frappe
- Catppuccin Latte

<code>Eventide:SetTheme</code> also accepts a theme table. Theme tables contain <code>Backgrounds</code>, <code>Foregrounds</code>, <code>Miscellaneous</code>, and <code>Accents</code> sections. Call <code>Eventide:LoadAutoloadTheme()</code> after building the UI to restore the selected autoload theme.

## Configurations

The easiest way to expose configuration management is the prebuilt groupbox:

~~~luau
tab:BuildConfigGroupbox(2, 2, true)
~~~

The arguments are <code>column</code>, <code>groupboxStyle</code>, and <code>buttonsCentered</code>. This UI creates, selects, loads, overwrites, refreshes, autoloads, and deletes <code>.eventide</code> configuration files.

You can also use the filesystem API directly:

~~~luau
local configPath = Eventide.FileSystem.AutoloadConfigPath

local saved, saveError = Eventide.FileSystem:SaveConfig("default", configPath)
if saved ~= true then
	warn(saveError or saved)
end

local loaded, loadError = Eventide.FileSystem:LoadConfig("default", configPath)
if loaded ~= true then
	warn(loadError or loaded)
end

local configNames = Eventide.FileSystem:RefreshConfigList(configPath)
~~~

Relevant methods:

- <code>Eventide.FileSystem:BuildFolderTree(fileSettings)</code>
- <code>Eventide.FileSystem:SaveConfig(fileName, path)</code>
- <code>Eventide.FileSystem:LoadConfig(fileName, path)</code>
- <code>Eventide.FileSystem:RefreshConfigList(path)</code>
- <code>Eventide:LoadAutoloadConfig()</code>

Configuration files are unavailable in Roblox Studio and in environments without the required filesystem functions. Eventide saves stateful base elements plus nested controls unless <code>IgnoreConfig</code> is true.

## Lifecycle and reload safety

Register cleanup work with <code>OnDestroy</code> and close the complete interface with <code>Destroy</code>:

~~~luau
Eventide:OnDestroy(function()
	print("Eventide was destroyed")
end)

Eventide:Destroy()
~~~

<code>OnDestroy</code> stores one cleanup callback; calling it again replaces the previous callback.

For scripts that may be run repeatedly, destroy the previous instance before creating another:

~~~luau
local env = getgenv()

if env.MyEventideUI and env.MyEventideUI.Destroy then
	env.MyEventideUI:Destroy()
end

env.MyEventideUI = Eventide

Eventide:OnDestroy(function()
	if env.MyEventideUI == Eventide then
		env.MyEventideUI = nil
	end
end)
~~~

## Troubleshooting

### Attempt to call missing method

If <code>CreateDropdown</code>, <code>CreateBind</code>, or <code>CreateColorPicker</code> is missing on a groupbox, attach the nested component to a label or toggle with its <code>Add...</code> method.

If <code>AddSettings</code> is missing, confirm that the script uses the Eventide source URL from the installation section and rerun it.

### Config system unavailable

The config system intentionally returns an unavailable message in Roblox Studio or when executor filesystem functions are absent. The visual component API still works.

### Incorrect config values or collisions

Give every object a unique and stable index. Reusing an index in the same parent can overwrite Eventide's internal reference and cause the wrong value to load.

### Callback error notifications

Set <code>NotifyOnCallbackError = true</code> in the window settings. Eventide protects component callbacks with <code>pcall</code> and can display the error in a notification.

## Full gallery

The repository's [example.luau](example.luau) is a reload-safe, runnable gallery with at least one use of every active Gen1 component, both groupbox styles, both toggle styles, nested controls on labels and toggles, collapsible settings, dialogs, theme/config builders, and a custom tab.

## Attribution

Eventide is based on the [Starlight Interface Suite](https://github.com/Nebula-Softworks/Starlight-Interface-Suite) by Nebula Softworks. The linked upstream documentation remains useful for historical Gen1 context; this page is the fork-specific API reference.
