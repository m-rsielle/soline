local esp = getgenv().esp
if not esp then 
    warn("ESP module not loaded, retrying...")
    wait(0.5)
    esp = getgenv().esp
    if not esp then error("ESP module failed to load") end
end

local players = game:GetService("Players")

players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        wait(0.1)
        local ok, err = pcall(function()
            if esp and esp.add then
                esp:add(plr, {
                    Color = Color3.fromRGB(255, 100, 100),
                    Tracer = true,
                    HealthBar = true
                })
            end
        end)
        if not ok then
            warn("Failed to add ESP for " .. plr.Name .. ": " .. tostring(err))
        end
    end)
end)

local ok, err = pcall(function()
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= players.LocalPlayer and plr.Character then
            if esp and esp.add then
                esp:add(plr)
            end
        end
    end
end)
if not ok then
    warn("Failed to add ESP for existing players: " .. tostring(err))
end

ok, err = pcall(function()
    if esp and esp.update then
        esp:update({
            maxDistance = 8000,
            updateRate = 0.08,
        })
    end
end)
if not ok then
    warn("Failed to update ESP config: " .. tostring(err))
end
