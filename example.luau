local env = getgenv()
local previous = env.EventideExample

if previous and previous.Destroy then
	previous:Destroy()
end

env.InterfaceName = "Eventide Component Gallery"

local Eventide = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/tessa-says-hi/Starlight-Interface-Suite/master/Source.lua")
)()

local NebulaIcons = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Nebula-Icon-Library/master/Loader.luau")
)()

local function icon(name, source)
	return NebulaIcons:GetIcon(name, source)
end

local function log(name, ...)
	print(string.format("[Eventide Example] %s", name), ...)
end

local icons = {
	window = icon("sparkle", "Material"),
	components = icon("broadcast", "Phosphor"),
	nested = icon("atom", "Phosphor"),
	dialogs = icon("cursor-click", "Phosphor"),
	settings = icon("rocket", "Lucide"),
	custom = icon("aperture", "Lucide"),
	button = icon("locate", "Lucide"),
	check = icon("check", "Material"),
	color = icon("color_lens", "Material"),
	paragraph = icon("filter_list_alt", "Material"),
	notification = icon("notifications_active", "Material"),
}

local Window = Eventide:CreateWindow({
	Name = "Eventide Component Gallery",
	Subtitle = "Every active Gen1 component",
	Icon = icons.window,

	LoadingEnabled = true,
	LoadingSettings = {
		Title = "Eventide Component Gallery",
		Subtitle = "Loading every component",
		Logo = icons.window,
	},

	BuildWarnings = true,
	InterfaceAdvertisingPrompts = false,
	NotifyOnCallbackError = true,

	FileSettings = {
		RootFolder = "Eventide Examples",
		ConfigFolder = "Component Gallery",
		ThemesInRoot = true,
	},
})

Eventide:OnDestroy(function()
	if env.EventideExample == Eventide then
		env.EventideExample = nil
	end
	log("Interface destroyed")
end)

Window:CreateHomeTab({
	SupportedExecutors = {},
	UnsupportedExecutors = {},
	DiscordInvite = "nebulasoftworks",
	Backdrop = 0,
	IconStyle = 1,
	Changelog = {
		{
			Title = "Component gallery",
			Date = "July 31, 2026",
			Description = "Added one runnable example for every active Eventide Gen1 component.",
		},
	},
})

local componentsSection = Window:CreateTabSection("COMPONENTS")

local componentsTab = componentsSection:CreateTab({
	Name = "Base Elements",
	Icon = icons.components,
	Columns = 2,
}, "base_elements")

local nestedTab = componentsSection:CreateTab({
	Name = "Nested Elements",
	Icon = icons.nested,
	Columns = 2,
}, "nested_elements")

local dialogsTab = componentsSection:CreateTab({
	Name = "Dialogs & Actions",
	Icon = icons.dialogs,
	Columns = 2,
}, "dialogs_actions")

local buttonsGroup = componentsTab:CreateGroupbox({
	Name = "Buttons and Toggles",
	Icon = icons.button,
	Column = 1,
	Style = 1,
}, "buttons_toggles")

buttonsGroup:CreateButton({
	Name = "Primary Button",
	Icon = icons.button,
	Tooltip = "Style 1 with centered content and a chevron indicator.",
	CenterContent = true,
	IndicatorStyle = 1,
	Style = 1,
	Callback = function()
		Eventide:Notification({
			Title = "Primary Button",
			Content = "The Style 1 button callback fired.",
			Icon = icons.notification,
			Duration = 4,
		})
	end,
}, "primary_button")

buttonsGroup:CreateButton({
	Name = "Secondary Button",
	Icon = icons.button,
	Tooltip = "Style 2 with a fingerprint indicator.",
	IndicatorStyle = 2,
	Style = 2,
	Callback = function()
		log("Secondary button pressed")
	end,
}, "secondary_button")

local checkboxToggle = buttonsGroup:CreateToggle({
	Name = "Checkbox Toggle",
	Icon = icons.check,
	Tooltip = "Toggle Style 1.",
	CurrentValue = false,
	CheckboxIcon = icons.check,
	Style = 1,
	Callback = function(value)
		log("Checkbox toggle", value)
	end,
}, "checkbox_toggle")

buttonsGroup:CreateToggle({
	Name = "Switch Toggle",
	Tooltip = "Toggle Style 2.",
	CurrentValue = true,
	Style = 2,
	Callback = function(value)
		log("Switch toggle", value)
	end,
}, "switch_toggle")

buttonsGroup:CreateDivider()

local checkboxLocked = false

buttonsGroup:CreateButton({
	Name = "Lock or Unlock Checkbox",
	Style = 2,
	Callback = function()
		checkboxLocked = not checkboxLocked
		if checkboxLocked then
			checkboxToggle:Lock("Locked by the element API example")
		else
			checkboxToggle:Unlock()
		end
	end,
}, "lock_toggle")

local valuesGroup = componentsTab:CreateGroupbox({
	Name = "Values and Inputs",
	Icon = icons.components,
	Column = 2,
	Style = 2,
}, "values_inputs")

valuesGroup:CreateSlider({
	Name = "Percentage Slider",
	Tooltip = "Supports ranges, increments, suffixes, and direct text input.",
	Range = { 0, 100 },
	CurrentValue = 50,
	Increment = 5,
	Suffix = "%",
	HideMax = false,
	Callback = function(value)
		log("Slider", value)
	end,
}, "percentage_slider")

valuesGroup:CreateInput({
	Name = "Text Input",
	Icon = icons.paragraph,
	Tooltip = "Calls back whenever the text changes.",
	CurrentValue = "Hello",
	PlaceholderText = "Type something",
	RemoveTextAfterFocusLost = false,
	RemoveTextOnFocus = false,
	Enter = false,
	Callback = function(text)
		log("Text input", text)
	end,
}, "text_input")

valuesGroup:CreateInput({
	Name = "Numeric Input",
	Tooltip = "Accepts numbers and fires after Enter.",
	CurrentValue = "25",
	PlaceholderText = "0-999",
	Numeric = true,
	Enter = true,
	MaxCharacters = 3,
	RemoveTextOnFocus = true,
	Callback = function(text)
		log("Numeric input", text)
	end,
}, "numeric_input")

local textGroup = componentsTab:CreateGroupbox({
	Name = "Text and Layout",
	Icon = icons.paragraph,
	Column = 1,
	Style = 2,
}, "text_layout")

local editableLabel = textGroup:CreateLabel({
	Name = "Label with an Icon",
	Icon = icons.custom,
	Tooltip = "Labels can host nested elements.",
}, "editable_label")

textGroup:CreateParagraph({
	Name = "Paragraph",
	Icon = icons.paragraph,
	Content = "Paragraphs automatically resize to fit longer, multi-line bodies of text.\nThis is the second line.",
}, "paragraph")

textGroup:CreateDivider()

local labelRevision = 1

textGroup:CreateButton({
	Name = "Update Label with Set",
	Style = 2,
	Callback = function()
		labelRevision += 1
		editableLabel:Set({
			Name = string.format("Updated Label %d", labelRevision),
			Icon = icons.custom,
			Tooltip = "Updated through Element:Set.",
		})
	end,
}, "update_label")

local labelNestedGroup = nestedTab:CreateGroupbox({
	Name = "Nested on Labels",
	Icon = icons.nested,
	Column = 1,
	Style = 1,
}, "label_nested")

labelNestedGroup
	:CreateLabel({
		Name = "Keybind",
		Tooltip = "Click the key field to rebind it.",
	}, "bind_parent")
	:AddBind({
		CurrentValue = "Q",
		HoldToInteract = false,
		Callback = function(active)
			log("Label bind active", active)
		end,
		OnChangedCallback = function(key)
			log("Label bind changed", key)
		end,
	}, "bind")

labelNestedGroup
	:CreateLabel({
		Name = "Color Picker",
		Icon = icons.color,
		Tooltip = "Includes an alpha channel.",
	}, "color_parent")
	:AddColorPicker({
		CurrentValue = Color3.fromRGB(161, 169, 225),
		Transparency = 0.15,
		Callback = function(color, transparency)
			log("Label color picker", color, transparency)
		end,
	}, "color_picker")

labelNestedGroup
	:CreateLabel({
		Name = "Single Dropdown",
		Tooltip = "Select exactly one option.",
	}, "single_dropdown_parent")
	:AddDropdown({
		Options = { "Alpha", "Beta", "Gamma" },
		CurrentOption = { "Alpha" },
		Required = true,
		MultipleOptions = false,
		Placeholder = "Choose one",
		Callback = function(options)
			log("Single dropdown", table.concat(options, ", "))
		end,
	}, "single_dropdown")

labelNestedGroup
	:CreateLabel({
		Name = "Multi Dropdown",
		Tooltip = "Select any number of options.",
	}, "multi_dropdown_parent")
	:AddDropdown({
		Options = { "Red", "Green", "Blue" },
		CurrentOption = { "Red", "Blue" },
		MultipleOptions = true,
		Placeholder = "Choose colors",
		Callback = function(options)
			log("Multi dropdown", table.concat(options, ", "))
		end,
	}, "multi_dropdown")

local toggleNestedGroup = nestedTab:CreateGroupbox({
	Name = "Nested on Toggles",
	Icon = icons.check,
	Column = 2,
	Style = 2,
}, "toggle_nested")

local nestedToggle = toggleNestedGroup:CreateToggle({
	Name = "Feature with Extras",
	CurrentValue = false,
	Style = 2,
	Callback = function(value)
		log("Nested parent toggle", value)
	end,
}, "nested_parent_toggle")

nestedToggle:AddBind({
	CurrentValue = "E",
	HoldToInteract = false,
	SyncToggleState = true,
	OnChangedCallback = function(key)
		log("Toggle bind changed", key)
	end,
}, "bind")

nestedToggle:AddColorPicker({
	CurrentValue = Color3.fromRGB(230, 186, 251),
	Callback = function(color)
		log("Toggle color picker", color)
	end,
}, "color_picker")

nestedToggle:AddDropdown({
	Options = { "Low", "Medium", "High" },
	CurrentOption = { "Medium" },
	Required = true,
	MultipleOptions = false,
	Placeholder = "Select quality",
	Callback = function(options)
		log("Toggle dropdown", table.concat(options, ", "))
	end,
}, "dropdown")

toggleNestedGroup:CreateParagraph({
	Name = "Supported Parents",
	Content = "Bind, color picker, and dropdown components can be nested on both labels and toggles.",
}, "nested_info")

local dialogsGroup = dialogsTab:CreateGroupbox({
	Name = "Notifications and Dialogs",
	Icon = icons.notification,
	Column = 1,
	Style = 1,
}, "notifications_dialogs")

dialogsGroup:CreateButton({
	Name = "Show Notification",
	Icon = icons.notification,
	Style = 1,
	Callback = function()
		Eventide:Notification({
			Title = "Example Notification",
			Content = "Notifications automatically size themselves around their content.",
			Icon = icons.notification,
			Duration = 6,
		})
	end,
}, "show_notification")

dialogsGroup:CreateButton({
	Name = "Open Action Dialog",
	Icon = icons.dialogs,
	Style = 2,
	Callback = function()
		Window:PromptDialog({
			Name = "Action Dialog",
			Content = "This is a Type 1 dialog with primary and secondary actions.",
			Icon = icons.dialogs,
			Type = 1,
			Actions = {
				Primary = {
					Name = "Confirm",
					Icon = icons.check,
					Callback = function()
						log("Action dialog confirmed")
					end,
				},
				{
					Name = "Cancel",
					Callback = function()
						log("Action dialog cancelled")
					end,
				},
			},
		})
	end,
}, "action_dialog")

dialogsGroup:CreateButton({
	Name = "Open Input Dialog",
	Icon = icons.paragraph,
	Style = 2,
	Callback = function()
		Window:PromptDialog({
			Name = "Input Dialog",
			Content = "This is a Type 2 dialog with text and numeric inputs.",
			Icon = icons.paragraph,
			Type = 2,
			Actions = {
				{
					CurrentValue = "",
					PlaceholderText = "Enter text and press Return",
					RemoveTextAfterFocusLost = false,
					RemoveTextOnFocus = false,
					Callback = function(text)
						log("Dialog text input", text)
					end,
				},
				{
					CurrentValue = "",
					PlaceholderText = "Enter a number",
					Numeric = true,
					MaxCharacters = 5,
					RemoveTextAfterFocusLost = false,
					RemoveTextOnFocus = false,
					Callback = function(text)
						log("Dialog numeric input", text)
					end,
				},
			},
		})
	end,
}, "input_dialog")

local lifecycleGroup = dialogsTab:CreateGroupbox({
	Name = "Lifecycle",
	Icon = icons.settings,
	Column = 2,
	Style = 2,
}, "lifecycle")

lifecycleGroup:CreateParagraph({
	Name = "Reload Safe",
	Content = "Running this file again destroys the previous gallery. Closing the window also runs Eventide:OnDestroy.",
}, "reload_safe")

lifecycleGroup:CreateButton({
	Name = "Use Hollywood Dark Theme",
	Style = 2,
	Callback = function()
		Eventide:SetTheme("Hollywood Dark")
	end,
}, "set_theme")

lifecycleGroup:CreateButton({
	Name = "Destroy Interface",
	Style = 1,
	Callback = function()
		Eventide:Destroy()
	end,
}, "destroy_interface")

local toolsSection = Window:CreateTabSection("TOOLS")

local settingsTab = toolsSection:CreateTab({
	Name = "Theme and Config",
	Icon = icons.settings,
	Columns = 2,
}, "theme_config")

settingsTab:BuildThemeGroupbox(1, 1, true)
settingsTab:BuildConfigGroupbox(2, 2, true)

local customPage = Instance.new("Frame")
customPage.Name = "CustomPage"
customPage.Size = UDim2.fromScale(1, 1)
customPage.BackgroundTransparency = 1

local customTitle = Instance.new("TextLabel")
customTitle.Name = "Title"
customTitle.AnchorPoint = Vector2.new(0.5, 0.5)
customTitle.Position = UDim2.fromScale(0.5, 0.46)
customTitle.Size = UDim2.fromOffset(420, 42)
customTitle.BackgroundTransparency = 1
customTitle.FontFace = Font.fromEnum(Enum.Font.GothamMedium)
customTitle.Text = "This entire page is custom content"
customTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
customTitle.TextSize = 24
customTitle.Parent = customPage

local customDescription = Instance.new("TextLabel")
customDescription.Name = "Description"
customDescription.AnchorPoint = Vector2.new(0.5, 0)
customDescription.Position = UDim2.fromScale(0.5, 0.52)
customDescription.Size = UDim2.fromOffset(480, 60)
customDescription.BackgroundTransparency = 1
customDescription.FontFace = Font.fromEnum(Enum.Font.Gotham)
customDescription.Text = "CreateCustomTab parents any GuiObject page inside Eventide's tab container."
customDescription.TextColor3 = Color3.fromRGB(165, 165, 165)
customDescription.TextSize = 16
customDescription.TextWrapped = true
customDescription.Parent = customPage

toolsSection:CreateCustomTab({
	Name = "Custom Tab",
	Icon = icons.custom,
	Page = customPage,
}, "custom_tab")

env.EventideExample = Eventide

Eventide:LoadAutoloadTheme()
Eventide:LoadAutoloadConfig()

Eventide:Notification({
	Title = "Gallery Ready",
	Content = "Every active Eventide Gen1 component has been added to the example.",
	Icon = icons.notification,
	Duration = 7,
})
