-- generated at .gg/bonnieblue

 
print("[XENHUB Hybrid] loading clean recovered section...")
 
hookmetamethod(game, "__index", function(arg, arg2)
	 
end)
 
local Players = game:GetService("Players")
 
local RunService = game:GetService("RunService")
 
local UserInputService = game:GetService("UserInputService")
 
_G.XenHubLoaded = true
 
_G.AntiBodySwapEnabled = false
 
_G.invisibleStealEnabled = false
 
_G.TPBackToPet = false
 
_G.AutoRecoverLagback = true
 
_G.AutoBuyEnabled = false
 
_G.autoKickEnabled = false
 
_G.autoTurretEnabled = false
 
_G.autoTurretPaused = false
 
_G.SpeedBoostEnabled = false
 
_G.AutoRotateInvis = false
 
_G.AutoStealDisableAnimEnabled = false
 
_G.ClearErrorEnabled = false
 
_G.RecoveryInProgress = false
 
_G.KICK_IN_PROGRESS = false
 
_G.isTeleporting = false
 
_G.isDraggingUI = false
 
_G.isMobile = false
 
_G.uiLocked = false
 
_G.VanishTPStop = false
 
_G.VanishTPBrakeDist = 20
 
_G.VanishTPDebug = false
 
_G.STEAL_RANGE = 10
 
_G.InvisStealAngle = 180
 
_G.SinkSliderValue = 8
 
_G.proximityStuds = 8
 
_G.TPSpeedItem = "Flying Carpet"
 
_G.TPTravelSpeed = 160
 
_G.SelectedStealTarget = nil
 
_G.CurrentAutoStealTarget = nil
 
_G._xenAnimalsCache = {}
 
_G.ServerPosConfig = { CloneSwapThreshold = 15, TrackCloneSwap = true }
 
_G._isFMLYUser = false
 
_G._isWNotifierUser = false
 
_G._isBraintopiaUser = false
 
_G._isAtlasUser = false
 
_G.DisableAPOnFMLY = true
 
_G.DisableAPOnWNotifier = true
 
_G.DisableAPOnBraintopia = true
 
_G.DisableAPOnAtlas = true
 
_G.DisableAPOnKawaifu = true
 
_G._BalloonResetBusy = false
 
_G._InstaResetActive = false
 
_G.XenPlatformTP = function(arg3, arg4)
	 
	arg3.CFrame = CFrame.new(arg4)
	 
	arg3.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	 
	arg3.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
end
 
_G.ScanDebrisCore = function(arg5, arg6)
end
 
_G.__uiBuildStarted = false
 
_G.__uiBuildCount = 0
 
RunService.Heartbeat:Connect(function(deltaTime)
end)
 
_G._xenEspPulseStep = function(arg7, arg8)
end
 
RunService.Heartbeat:Connect(function(deltaTime2)
end)
 
_G.XenBalloonResetSpam = function(arg9, arg10)
	 
	task.spawn(function(...)
		 
		_G._BalloonResetBusy = true
		 
		task.wait()
		 
		task.wait()
		 
	end)
end
 
RunService.Heartbeat:Connect(function(deltaTime3)
	 
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end)
 
RunService.Heartbeat:Connect(function(deltaTime4)
	 
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	 
end)
 
_G.XenUIBuildGate = function(arg11, arg12)
	 
	_G.__uiBuildStarted = true
	 
	task.wait(2.5)
	 
	_G.__uiBuildCount = 1
	 
	task.wait()
end
 
print("[XENHUB Recovered] max static recovery loaded (partial)")
 
print("[XENHUB Hybrid] loading original obfuscated payload (VM)...")
 
task.spawn(function(...)
end)
 
task.spawn(function(...)
end)
 
task.delay(29, function(...)
	 
end)
 
local ScreenGui = Instance.new("ScreenGui")
 
local Frame = Instance.new("Frame")
 
Frame.Position = UDim2.new(0, 0, 0, 0)
 
Frame.Size = UDim2.new(0, 284, 0, 214)
 
Frame.Parent = ScreenGui
 
local Path2D = Instance.new("Path2D")
 
Path2D.Parent = Frame
 
Path2D:SetControlPoints({ Path2DControlPoint.new(UDim2.new(0, -6, 0.5, 4), UDim2.new(0, 4, 0.0625, -6), UDim2.new(0, 0, 0, 0)), Path2DControlPoint.new(UDim2.new(0.0625, -1, 0.5, -5), UDim2.new(0, -4, 0, -8), UDim2.new(0, 0, 0, 0)), Path2DControlPoint.new(UDim2.new(0, -8, 0, -8), UDim2.new(0, 4, 0.125, 5), UDim2.new(0, -3, 0, 0)), Path2DControlPoint.new(UDim2.new(0.5, 9, 0.5, -9), UDim2.new(0.125, 3, 0, 5), UDim2.new(0, 3, 0, -2)), Path2DControlPoint.new(UDim2.new(0.4375, -4, 0.25, -7), UDim2.new(0, 0, 0, 0), UDim2.new(0, 6, 0.0625, -5)) })
 
Path2D:GetLength()
 
Path2D:GetPositionOnCurve(0.40000000596046448)
 
Path2D:GetPositionOnCurve(0.83333331346511841)
 
Path2D:GetPositionOnCurve(0.083333335816860199)
 
Path2D:GetTangentOnCurve(0.30000001192092896)
 
Path2D:GetTangentOnCurve(0.875)
 
Path2D:GetTangentOnCurve(0.5)
 
Path2D:GetTangentOnCurve(0.4285714328289032)
 
Path2D:GetPositionOnCurveArcLength(0.58333331346511841)
 
Path2D:GetPositionOnCurveArcLength(0.78571426868438721)
 
Path2D:GetTangentOnCurveArcLength(0.57142859697341919)
 
Path2D:GetTangentOnCurveArcLength(0.3333333432674408)
 
ScreenGui:Destroy()
 
local connection = game.DescendantRemoving:Connect(function(descendant)
end)
 
connection:Disconnect()
 
local connection2 = workspace.DescendantRemoving:Connect(function(descendant2)
end)
 
connection2:Disconnect()
 
local Folder = Instance.new("Folder")
 
local connection3 = Folder.DescendantRemoving:Connect(function(descendant3)
end)
 
connection3:Disconnect()
 
Folder:GetChildren()
 
Folder:Destroy()
 
local Folder2 = Instance.new("Folder", Folder)
 
local connection4 = Folder2.DescendantRemoving:Connect(function(descendant4)
end)
 
connection4:Disconnect()
 
Folder2.Name = "1212317632"
 
Folder:WaitForChild("1212317632")
 
Folder:Destroy()
 
Folder2:Destroy()
 
local HttpService = game:GetService("HttpService")
 
local connection5 = HttpService.DescendantRemoving:Connect(function(descendant5)
end)
 
connection5:Disconnect()
 
local connection6 = RunService.DescendantRemoving:Connect(function(descendant6)
end)
 
connection6:Disconnect()
 
 
task.spawn(function(...)
	 
	workspace:GetChildren()
	 
	game:GetChildren()
	 
	HttpService:GenerateGUID()
	 
end)