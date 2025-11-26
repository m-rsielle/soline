local root = "https://raw.githubusercontent.com/m-rsielle/soline/main" 
local loadt = os.date("%Y-%m-%d %H:%M:%S", os.time())
local file = {
    "/src/esp.lua",
    "/src/main.lua",
}

for _, dir in ipairs(file) do
    local fn = loadstring(game:HttpGet(root .. dir))
    if fn then fn() end
end

print(" load in...".. loadt)