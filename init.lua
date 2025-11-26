local root = "https://raw.githubusercontent.com/YourUsername/YourRepository/main" 
local loadt = os.date("%Y-%m-%d %H:%M:%S", os.time())
local modules = {
    "/drawing.lua",
    "/hook.lua",
    "/disableanti.lua",
}

for _, dir in ipairs(modules) do
    loadstring(game:HttpGet(root .. dir))()
end

print(" load in...".. loadt)