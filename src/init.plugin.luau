--!strict

assert(plugin, "This script must be run as a plugin")

const ChangeHistoryService = game:GetService("ChangeHistoryService")
const Selection = game:GetService("Selection")

const toolbar = plugin:CreateToolbar("Hopper to Tool")
const pluginToolbarButton = toolbar:CreateButton(
	"Convert Hopper",
	"Convert selected HopperBin to Tool",
	"rbxasset://textures/studio_texture_test.png"
)
pluginToolbarButton.ClickableWhenViewportHidden = true

-- Convert selected HopperBin instances to Tool when the plugin button is clicked
const function onClick()
	for _, hopper in Selection:Get() do
		if hopper:IsA("HopperBin") then
			const recording = ChangeHistoryService:TryBeginRecording("Convert selected HopperBin to Tool")

			if not recording then
				return
			end

			const tool = Instance.new("Tool")
			tool.Name = hopper.Name
			tool.CanBeDropped = false
			tool.TextureId = hopper.TextureId
			tool.RequiresHandle = false

			for _, child in hopper:GetChildren() do
				child.Parent = tool
			end

			tool.Parent = hopper.Parent
			hopper:Destroy()
			Selection:Add({ tool })

			ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
		end
	end
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
