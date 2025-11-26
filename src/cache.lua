local objects={}
local cfg={Enabled=true,MaxDistance=5000,UpdateRate=0.05}
local last=0

game:GetService("RunService").Heartbeat:Connect(function()
	if cfg.Enabled and tick()-last>=cfg.UpdateRate then
		last=tick()
		local cam=workspace.CurrentCamera
		local cpos=cam.CFrame.Position
		local half=cam.ViewportSize/2

		for plr,data in pairs(objects)do
			local char=plr.Character
			if char and char:FindFirstChild("HumanoidRootPart")and char.Humanoid.Health>0 then
				local root=char.HumanoidRootPart.Position
				local dist=(cpos-root).Magnitude
				if dist<=cfg.MaxDistance then
					local s=cam:WorldToViewportPoint(root)
					if s.Z>=0.1 then
						local scale=350/s.Z

						data.b.Size=Vector2.new(scale*2,scale*2.8)
						data.b.Position=Vector2.new(s.X-scale,s.Y-scale*1.4)
						data.b.Color=data.c
						data.b.Visible=true

						if data.tr then
							data.t.From=half
							data.t.To=Vector2.new(s.X,s.Y+scale*1.4)
							data.t.Color=data.c
							data.t.Visible=true
						end

						if data.na then
							data.n.Text=(plr.DisplayName~=""and plr.DisplayName or plr.Name).." ["..math.floor(dist).."]"
							data.n.Position=Vector2.new(s.X,s.Y-scale*1.6)
							data.n.Color=data.c
							data.n.Visible=true
						end
					else
						data.b.Visible=false
						data.t.Visible=false
						data.n.Visible=false
					end
				else
					data.b.Visible=false
					data.t.Visible=false
					data.n.Visible=false
				end
			else
				data.b.Visible=false
				data.t.Visible=false
				data.n.Visible=false
			end
		end
	end
end)

local cache={}

function cache:Add(plr,opt)
	if not objects[plr]then
		opt=opt or{}
		local b=Drawing.new("Square")b.Thickness=1.5 b.Filled=false b.Transparency=1
		local t=Drawing.new("Line")t.Thickness=1.5 t.Transparency=1
		local n=Drawing.new("Text")n.Size=13 n.Font=2 n.Center=true n.Outline=true
		objects[plr]={b=b,t=t,n=n,c=opt.Color or Color3.new(1,1,1),tr=opt.Tracer~=false,na=opt.Name~=false}
	end
end

function cache:Remove(plr)
	if objects[plr]then
		objects[plr].b:Remove()
		objects[plr].t:Remove()
		objects[plr].n:Remove()
		objects[plr]=nil
	end
end

function cache:Config(t)
	for k,v in pairs(t)do
		cfg[k]=v
	end
end

function cache:Clear()
	for plr in pairs(objects)do
		cache:Remove(plr)
	end
end

game.Players.PlayerRemoving:Connect(function(p)
	cache:Remove(p)
end)

getgenv().cache=cache
return cache