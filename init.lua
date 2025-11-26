-- init.lua (new version)
local root = "https://raw.githubusercontent.com/m-rsielle/soline/main"

-- Load esp.lua first
local esp_success, esp_module = pcall(function()
    local code = game:HttpGet(root .. "/src/esp.lua")
    local fn = loadstring(code)
    if not fn then error("Failed to compile esp.lua") end
    return fn()
end)

if not esp_success then
    error("Failed to load ESP module: " .. tostring(esp_module))
end

getgenv().esp = esp_module

-- Now load main.lua (which uses getgenv().esp)
local main_success, main_err = pcall(function()
    local code = game:HttpGet(root .. "/src/main.lua")
    local fn = loadstring(code)
    if not fn then error("Failed to compile main.lua") end
    fn()
end)

if not main_success then
    warn("Failed to load main.lua: " .. tostring(main_err))
end

print("Soline ESP loaded successfully!")