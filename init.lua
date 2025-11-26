local root = "https://raw.githubusercontent.com/m-rsielle/soline/main" 
local loadt = os.date("%Y-%m-%d %H:%M:%S", os.time())
local file = {
    "/src/esp.lua",
    "/src/main.lua",
}

for _, dir in ipairs(file) do
    local success, err = pcall(function()
        local fn = loadstring(game:HttpGet(root .. dir))
        if not fn then error("Failed to load: " .. dir) end
        fn()
    end)
    if not success then
        warn("Error loading " .. dir .. ": " .. tostring(err))
    end
end

print("Loaded in " .. loadt)