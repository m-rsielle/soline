local esp = getgenv().esp
local players = game:GetService("Players")

players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        wait(0.1)
        esp:add(plr, {
            Color = Color3.fromRGB(255, 100, 100),
            Tracer = true,
            HealthBar = true
        })
    end)
end)

for _, plr in pairs(players:GetPlayers()) do
    if plr ~= players.LocalPlayer and plr.Character then
        esp:add(plr)
    end
end

esp:update({
    updateRate = 0.08,
})