--!strict

assert(plugin, "This script must be run as a plugin")

const ChangeHistoryService = game:GetService("ChangeHistoryService")
const Selection = game:GetService("Selection")

const toolbar = plugin:CreateToolbar("Hopper to Tool")
const pluginToolbarButton = toolbar:CreateButton(
	"Convert Hopper",
	"Convert selected HopperBin to Tool",
	"rbxassetid://89061541585294"
)
pluginToolbarButton.ClickableWhenViewportHidden = true

-- Convert selected HopperBin to Tool when the plugin button is clicked
const function onClick()
	const hoppers = {}
	for _, part in Selection:Get() do
		if part:IsA("HopperBin") then
			hoppers[#hoppers + 1] = part
		end
	end

	if #hoppers < 1 then
		-- Nothing to do.
		return
	end

	const recording = ChangeHistoryService:TryBeginRecording("Convert selected HopperBin to Tool")
	if not recording then
		return
	end

	for _, hopper in hoppers do
		const tool = Instance.new("Tool")
		tool.Name = hopper.Name
		tool.CanBeDropped = false
		tool.TextureId = hopper.TextureId
		tool.RequiresHandle = false

		for _, script in hopper:GetDescendants() do
			if script:IsA("Script") or script:IsA("ModuleScript") then
				const content = script.Source
				local newContent, count = content:gsub("%s*%.%s*[sS]elected%s*:%s*[cC]onnect%s*%(", ".Equipped:Connect(")
				newContent, count = newContent:gsub("%s*%.%s*[dD]eselected%s*:%s*[cC]onnect%s*%(", ".Unequipped:Connect(")
				if count > 0 then
					script.Source = newContent
				end
			end
		end

		for _, child in hopper:GetChildren() do
			child.Parent = tool
		end

		tool.Parent = hopper.Parent
		hopper.Parent = nil
		Selection:Add({ tool })
	end

	ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
end
pluginToolbarButton.Click:Connect(onClick)

-- Enable plugin button only when a HopperBin is selected
const function doesSelectionContainAHopper(): boolean
	for _, hopper in Selection:Get() do
		if hopper:IsA("HopperBin") then
			return true
		end
	end
	return false
end

const function onSelectionChanged()
	pluginToolbarButton.Enabled = doesSelectionContainAHopper()
end
Selection.SelectionChanged:Connect(onSelectionChanged)
onSelectionChanged()
