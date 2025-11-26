local esp = {}
local players = {}

esp.config = {
    enabled = true,
    maxDistance = 5000,
    updateRate = 0.05,
    filled = true,
    gradientFill = true,
    gradientColors = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0)},
    healthBar = true,
    healthBarGradient = true,
}

local last = 0
local rs = game:GetService("RunService")
local plrs = game:GetService("Players")
local cam = workspace.CurrentCamera
local gradSteps = 12
local invGradSteps = 1 / 11

local function drawGradient(box, top, bottom)
    if not box.Filled then
        if box._grad then
            for i = 1, #box._grad do 
                box._grad[i].Visible = false 
            end
        end
        return
    end

    local sz = box.Size
    local ps = box.Position
    local step = sz.Y / gradSteps

    box._grad = box._grad or {}
    local grad = box._grad

    for i = 1, gradSteps do
        local layer = grad[i]
        if not layer then
            layer = Drawing.new("Square")
            layer.Filled = true
            layer.Thickness = 0
            grad[i] = layer
        end
        
        layer.Transparency = box.Transparency
        layer.ZIndex = box.ZIndex - 1
        layer.Visible = box.Visible
        layer.Color = top:Lerp(bottom, (i - 1) * invGradSteps)
        layer.Size = Vector2.new(sz.X, step + 0.6)
        layer.Position = Vector2.new(ps.X, ps.Y + (i - 1) * step)
    end
end

rs.Heartbeat:Connect(function()
    if not esp.config.enabled then return end
    
    local now = tick()
    if now - last < esp.config.updateRate then return end
    last = now

    local camPos = cam.CFrame.Position
    local screenCenter = cam.ViewportSize * 0.5
    local maxDist = esp.config.maxDistance

    for plr, data in players do
        local char = plr.Character
        if not char then goto hide end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not (hrp and hum) then goto hide end

        local pos = hrp.Position
        local dist = (camPos - pos).Magnitude
        
        if dist > maxDist or hum.Health <= 0 then 
            goto hide 
        end

        local screen, visible = cam:WorldToViewportPoint(pos)
        if not (visible and screen.Z > 0.1) then 
            goto hide 
        end

        local scale = 350 / screen.Z
        local w, h = scale * 2, scale * 2.8
        local size = Vector2.new(w, h)
        local x, y = screen.X - scale, screen.Y - scale * 1.4
        local position = Vector2.new(x, y)

        local col = data.c
        local fill = data.filled
        local outlineSize = data.outlineThickness

        data.outline.Size = Vector2.new(w + outlineSize * 2, h + outlineSize * 2)
        data.outline.Position = Vector2.new(x - outlineSize, y - outlineSize)
        data.outline.Color = data.outlineColor
        data.outline.Thickness = outlineSize
        data.outline.Transparency = data.transparency
        data.outline.Visible = true

        local box = data.b
        box.Size = size
        box.Position = position
        box.Color = col
        box.Thickness = data.thickness
        box.Filled = fill
        box.Transparency = data.transparency
        box.Visible = true

        if fill and data.gradient then
            drawGradient(box, data.gradientColors[1], data.gradientColors[2])
        elseif box._grad then
            for i = 1, #box._grad do 
                box._grad[i].Visible = false 
            end
        end

        if data.tracer then
            data.t.From = screenCenter
            data.t.To = Vector2.new(screen.X, screen.Y + scale * 1.4)
            data.t.Color = col
            data.t.Visible = true
        else
            data.t.Visible = false
        end

        if data.name then
            local displayName = plr.DisplayName ~= "" and plr.DisplayName or plr.Name
            data.n.Text = displayName .. " [" .. math.floor(dist) .. "m]"
            data.n.Position = Vector2.new(screen.X, screen.Y - scale * 1.6)
            data.n.Color = col
            data.n.Visible = true
        else
            data.n.Visible = false
        end

        if data.healthbar and esp.config.healthBar then
            local barX = x - 8
            local percent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)

            data.hb_bg.Size = Vector2.new(4, h)
            data.hb_bg.Position = Vector2.new(barX, y)
            data.hb_bg.Visible = true

            local barHeight = h * percent
            data.hb_fill.Size = Vector2.new(3, barHeight)
            data.hb_fill.Position = Vector2.new(barX + 0.5, y + h - barHeight)

            if data.hb_gradient then
                drawGradient(data.hb_fill, Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0))
            else
                if data.hb_fill._grad then
                    for i = 1, #data.hb_fill._grad do 
                        data.hb_fill._grad[i].Visible = false 
                    end
                end
                data.hb_fill.Color = Color3.fromHSV(0.33 * percent, 1, 1)
            end
            data.hb_fill.Visible = true
        else
            data.hb_bg.Visible = false
            data.hb_fill.Visible = false
        end

        goto next

        ::hide::
        data.b.Visible = false
        data.outline.Visible = false
        data.t.Visible = false
        data.n.Visible = false
        data.hb_bg.Visible = false
        data.hb_fill.Visible = false
        
        if data.b._grad then
            for i = 1, #data.b._grad do 
                data.b._grad[i].Visible = false 
            end
        end
        if data.hb_fill._grad then
            for i = 1, #data.hb_fill._grad do 
                data.hb_fill._grad[i].Visible = false 
            end
        end

        ::next::
    end
end)

function esp:add(plr, opts)
    opts = opts or {}
    if players[plr] then return end

    local outline = Drawing.new("Square")
    outline.Filled = false
    outline.Visible = false

    local box = Drawing.new("Square")
    box.Thickness = opts.Thickness or 1.5
    box.Transparency = opts.Transparency or 1

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1.5

    local text = Drawing.new("Text")
    text.Size = 13
    text.Font = 2
    text.Center = true
    text.Outline = true

    local hpBg = Drawing.new("Square")
    hpBg.Filled = true
    hpBg.Color = Color3.new(0,0,0)
    hpBg.Transparency = 0.6

    local hpBar = Drawing.new("Square")
    hpBar.Filled = true

    players[plr] = {
        b = box,
        outline = outline,
        t = tracer,
        n = text,
        hb_bg = hpBg,
        hb_fill = hpBar,
        c = opts.Color or Color3.new(1,1,1),
        outlineColor = opts.OutlineColor or Color3.new(0,0,0),
        outlineThickness = opts.OutlineThickness or 2.5,
        thickness = opts.Thickness or 1.5,
        transparency = opts.Transparency or 1,
        filled = opts.Filled ~= nil and opts.Filled or esp.config.filled,
        gradient = opts.Gradient or esp.config.gradientFill,
        gradientColors = opts.GradientColors or esp.config.gradientColors,
        tracer = opts.Tracer ~= false,
        name = opts.Name ~= false,
        healthbar = opts.HealthBar ~= false,
        hb_gradient = opts.HealthBarGradient or esp.config.healthBarGradient,
    }
end

function esp:remove(plr)
    local data = players[plr]
    if not data then return end
    
    data.b:Remove()
    data.outline:Remove()
    data.t:Remove()
    data.n:Remove()
    data.hb_bg:Remove()
    data.hb_fill:Remove()
    
    if data.b._grad then
        for i = 1, #data.b._grad do 
            data.b._grad[i]:Remove() 
        end
    end
    if data.hb_fill._grad then
        for i = 1, #data.hb_fill._grad do 
            data.hb_fill._grad[i]:Remove() 
        end
    end
    
    players[plr] = nil
end

function esp:update(settings)
    for key, val in pairs(settings) do 
        esp.config[key] = val 
    end
end

function esp:clear()
    for plr in pairs(players) do
        esp:remove(plr)
    end
end

plrs.PlayerRemoving:Connect(function(p)
    esp:remove(p)
end)

return esp