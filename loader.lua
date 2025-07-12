-- EzHub Loader
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ezhub-afk/ezhub/main/main.lua"))()
end)

if not success then
    warn("[EzHub] Failed to load main script:", err)
end
