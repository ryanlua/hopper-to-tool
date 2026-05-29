--!strict

assert(plugin, "This script must be run as a plugin")

const ChangeHistoryService = game:GetService("ChangeHistoryService")
const Selection = game:GetService("Selection")

const toolbar = plugin:CreateToolbar("Hopper to Tool")
const pluginToolbarButton =
	toolbar:CreateButton("Convert Hopper", "Convert selected HopperBin to Tool", "rbxassetid://89061541585294")
pluginToolbarButton.ClickableWhenViewportHidden = true

-- Convert selected HopperBin to Tool when the plugin button is clicked
const function onClick()
	const hoppers: { HopperBin } = {}
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

	Selection:Set(hoppers :: { Instance })

	for _, hopper in hoppers do
		-- Validate hopper
		if hopper.BinType ~= Enum.BinType.Script then
			warn(`Unable to convert '{hopper}' hopper. Hopper must be a script HopperBin.`)
			continue
		end

		-- Create new tool
		const tool = Instance.new("Tool")
		tool.Name = hopper.Name
		tool.CanBeDropped = false
		tool.TextureId = hopper.TextureId
		tool.RequiresHandle = false

		-- Copy scripts to new tool
		for _, child in hopper:GetChildren() do
			const clone = child:Clone()
			clone.Parent = tool
		end

		-- Convert scripts on the tool only
		for _, descendantScript in tool:GetDescendants() do
			if descendantScript:IsA("Script") or descendantScript:IsA("ModuleScript") then
				const content = descendantScript.Source
				local newContent, selectedCount =
					content:gsub("%s*%.%s*[sS]elected%s*:%s*[cC]onnect%s*%(", ".Equipped:Connect(")
				local deselectedCount
				newContent, deselectedCount =
					newContent:gsub("%s*%.%s*[dD]eselected%s*:%s*[cC]onnect%s*%(", ".Unequipped:Connect(")
				if selectedCount > 0 or deselectedCount > 0 then
					descendantScript.Source = newContent
				end
			end
		end

		-- Replace hopper with tool
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
