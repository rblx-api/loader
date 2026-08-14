1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
local CoreGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

getgenv().HitboxSize = 15
getgenv().HitboxTransparency = 0

getgenv().HitboxStatus = false
getgenv().TeamCheck = false
getgenv().FriendCheck = false

getgenv().Walkspeed = 16
getgenv().Jumppower = 50

--// UI

local Rayfield = loadstring(game:HttpGet('https://[Log in to view URL]'))()

local Window = Rayfield:CreateWindow({
   Name = "Muscle legends Script V2",
   LoadingTitle = "Beamed ",
   LoadingSubtitle = "by ben1x1x1x1x",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "ben1x1x1x1x hub v2.lua"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
Sponsored: PubNub
Stop ngrok-ing your agent Dial out once; reach it from anywhere, behind your firewall. Blocks.ai →
Ads by EthicalAds