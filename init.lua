local root = "https://raw.githubusercontent.com/m-rsielle/soline/main" 
local loadt = os.date("%Y-%m-%d %H:%M:%S", os.time())

local success, err = pcall(function()
    local fn = loadstring(game:HttpGet(root .. "/src/esp.lua"))
    if not fn then error("Failed to load esp.lua") end
    getgenv().esp = fn()
end)
if not success then
    warn("Error loading esp.lua: " .. tostring(err))
end

success, err = pcall(function()
    local fn = loadstring(game:HttpGet(root .. "/src/main.lua"))
    if not fn then error("Failed to load main.lua") end
    fn()
end)
if not success then
    warn("Error loading main.lua: " .. tostring(err))
end

print("Loaded in " .. loadt)
