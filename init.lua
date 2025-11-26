local root = "https://raw.githubusercontent.com/m-rsielle/soline/main" 
local loadt = os.date("%Y-%m-%d %H:%M:%S", os.time())
local file = {
    "/src/cache.lua",
    "/src/main.lua",
}

for _, dir in ipairs(file) do
    loadstring(game:HttpGet(root .. dir))()
end

print(" load in...".. loadt)