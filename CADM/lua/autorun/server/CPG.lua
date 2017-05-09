hook.Add('PhysgunPickup','CPG',function(ply,ent)
	if ent:IsPlayer() and ply:GetRank() > ent:GetRank() then return true end
end)

hook.Add('Think','CPG',function()
	for _,ply in pairs(player.GetAll()) do
		local wep = ply:GetActiveWeapon()
		local ang = wep.RotationAngle or 0
		if ply:IsAdmin() and ply:Alive() and IsValid(wep) and wep:GetClass() == 'weapon_physgun' then
			local ent = ply:GetEyeTrace().Entity
			if !ent then return end
			if ent == ply then return end
			if IsValid(ent) and ent:GetClass() and ent:GetClass() == 'player' then
			if ply:GetRank() <=	ent:GetRank() then return end
				if ply:KeyDown(IN_ATTACK) then
					ent:SetMoveType(MOVETYPE_NONE)
					if ply:KeyDown(IN_USE) then
						ent:SetEyeAngles(ent:EyeAngles()+Angle(0,ang,0))
					end	
				end
			end
		end	
	end
end)

hook.Add('PhysgunDrop','CPG',function(ply,ent)
	if ent:GetClass() == 'player' then
		ent:SetMoveType(MOVETYPE_WALK)
	end
end)

hook.Add('SetupMove','CPG',function(ply,move)
	if !IsValid(ply) or !IsValid(ply:GetActiveWeapon()) then return end
	if  ply:GetActiveWeapon():GetClass() == 'weapon_physgun' then
		if ply:KeyDown(IN_USE) then
			cmd = ply:GetCurrentCommand()
			local Y = cmd:GetMouseX()/(FrameTime()*200)
			ply:GetActiveWeapon().RotationAngle = Y
		end
	end
end)