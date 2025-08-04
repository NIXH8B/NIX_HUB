local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ShiftLockMobile"
gui.ResetOnSpawn = false

local btn = Instance.new("ImageButton")
btn.Size = UDim2.new(0, 60, 0, 60)
btn.Position = UDim2.new(0.7, 0, 0.78, 0)
btn.BackgroundTransparency = 1
btn.Image = "rbxasset://textures/ui/mouseLock_off@2x.png"
btn.Visible = game:GetService("UserInputService").TouchEnabled
btn.Parent = gui

-- Drag on mobile
local dragging, dragStart, startPos = false
btn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging, dragStart, startPos = true, input.Position, btn.Position
	end
end)
btn.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - dragStart
		btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
	end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- Shift Lock functionality
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local active, conn = false

local function toggleShiftLock()
	local char = player.Character or player.CharacterAdded:Wait()
	local root = char:WaitForChild("HumanoidRootPart")
	local humanoid = char:WaitForChild("Humanoid")

	if active then
		if conn then conn:Disconnect() end
		humanoid.AutoRotate = true
		btn.Image = "rbxasset://textures/ui/mouseLock_off@2x.png"
	else
		humanoid.AutoRotate = false
		conn = runService.RenderStepped:Connect(function()
			local dir = camera.CFrame.LookVector
			root.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(dir.X, 0, dir.Z))
		end)
		btn.Image = "rbxasset://textures/ui/mouseLock_on@2x.png"
	end
	active = not active
end

btn.MouseButton1Click:Connect(toggleShiftLock)
