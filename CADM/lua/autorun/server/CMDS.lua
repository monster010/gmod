hook.Add('PlayerSay','CMDS',function(ply,str)

	local word = string.Explode(' ',str)
	local cmd = string.lower(word[1])
	local pseudoent = easylua.FindEntity(word[2])
	local validate = IsValid(pseudoent) and pseudoent:IsPlayer()

	if cmd == '!goto' and validate then
		if validate then
		ply:Teleport(pseudoent)
		end
		return ''
	end

	if cmd == '!god' then
		if validate and ply:IsAdmin() and pseudoent != ply then
		pseudoent:SetGodMode(!pseudoent:GetGodMode())
		ply:ChatNet(Color(255,128,0),'God Mode ',Color(150,150,150),Either(pseudoent:GetGodMode(),'Enabled','Disabled'),Color(150,150,150),' for ',pseudoent:GetRankTable().color,pseudoent:Nick())
		pseudoent:ChatNet(Color(255,128,0),'God Mode ',Color(150,150,150),Either(pseudoent:GetGodMode(),'Enabled','Disabled'))
		else
		ply:SetGodMode(!ply:GetGodMode())
		ply:ChatNet(Color(255,128,0),'God Mode ',Color(150,150,150),Either(ply:GetGodMode(),'Enabled','Disabled'))
		end
		return ''
	end

	if cmd == '!ungod' then
		if validate and ply:IsAdmin() and pseudoent:GetGodMode() and pseudoent != ply then
		pseudoent:SetGodMode(false)
		ply:ChatNet(Color(255,128,0),'God Mode ',Color(150,150,150),'Disabled',Color(150,150,150),' for ',pseudoent:GetRankTable().color,pseudoent:Nick())
		pseudoent:ChatNet(Color(255,128,0),'God Mode ',Color(150,150,150),'Disabled')
		elseif ply:GetGodMode() then
		ply:SetGodMode(false)
		ply:ChatNet(Color(255,128,0),'God Mode ',Color(150,150,150),'Disabled')
		end
		return ''
	end

	if cmd == '!bring' then
		if validate and ply:IsAdmin() then
		pseudoent:Bring(ply)
		end
		return ''
	end

	if cmd == '!bot' then
		if ply:IsAdmin() then
		RunConsoleCommand('bot_zombie',1)
		RunConsoleCommand('bot')
		end
		return ''
	end

	if cmd == '!slay' then
		if validate and ply:IsAdmin() then
		pseudoent:Kill()
		end
		return ''
	end

	if cmd == '!kick' then
		if validate and ply:IsAdmin() then
		ChatNet(pseudoent:GetRankTable().color,pseudoent:Nick(),Color(150,150,150),' was kicked by ',ply:GetRankTable().color,ply:Nick())
		pseudoent:Kick('Kicked by '..ply:Nick())
		end
		return ''
	end

	if cmd == '!ban' then
		if validate and ply:IsAdmin() then
		local lol, phrase = Either(word[3] and isnumber(tonumber(word[3])),tonumber(word[3]),0), ''
		if lol == 0 then
		phrase = {Color(220,0,0),' permanently'}
		else
		phrase = {Color(150,150,150),' for ',Color(220,0,0),tostring(lol),Color(150,150,150),' minutes'}
		end
		pseudoent:Ban(lol)
		ChatNet(pseudoent:GetRankTable().color,pseudoent:Nick(),Color(150,150,150),' was banned by ',ply:GetRankTable().color,ply:Nick(),unpack(phrase))
		pseudoent:Kick('Banned by '..ply:Nick(),Either(lol != 0,' for '..lol..' minutes',' permanently'))
		end
		return ''
	end

	if cmd == '!hp' then
		if word[2] and ply:IsAdmin() then
			local lol = Either(validate,tonumber(word[3]),tonumber(word[2]))
			print(lol,validate)
			if validate then
				pseudoent:SetHealth(lol)
			else
				ply:SetHealth(lol)
			end
		end
		return ''
	end

	if cmd == '!revive' then
		if ply:IsAdmin() then
			local ent = Either(validate,pseudoent,ply)
			local pos, ang, vel = ent:GetPos(), ent:EyeAngles(), ent:GetVelocity()
			ent:Spawn()
			ent:SetPos(pos)
			ent:SetEyeAngles(ang)
			ent:SetVelocity(vel)
		end
		return ''
	end

	if cmd == '!freeze' then
		if validate and ply:IsAdmin() then
			pseudoent:Lock()
		end
		return ''
	end

	if cmd == '!unfreeze' then
		if validate and ply:IsAdmin() then
			pseudoent:UnLock()
		end
		return ''
	end

	if cmd == '!unban' then
		if validate and ply:IsAdmin() then
		RunConsoleCommand('removeid',word[2])
		end
		return ''
	end

	if cmd == '!mute' then
		if validate and ply:IsAdmin() then
		pseudoent:Mute(Either(word[3] and isnumber(tonumber(word[3])),tonumber(word[3]),0))
		end
		return ''
	end

	if cmd == '!unmute' then
		if validate and ply:IsAdmin() then
		pseudoent:UnMute()
		end
		return ''
	end

	if cmd == '!att' then
		if ply:IsAdmin() then
			Attention(string.sub(str,6,-1))
		end
		return ''
	end

	if cmd == '!rcon' then
		if ply:IsSuperAdmin() then
		RunConsoleCommand(word[2],word[3])
		end
		return ''
	end

	if cmd == '!cleanup' then
		if ply:IsSuperAdmin() then
			game.CleanUpMap()
		end
		return ''
	end

	if cmd == '!decals' then
		if ply:IsAdmin() then
			for k,v in pairs(player.GetAll()) do
				v:ConCommand('r_cleardecals')
			end
		end
		return ''
	end

	if cmd == '!sounds' then
		if ply:IsAdmin() then
			for k,v in pairs(player.GetAll()) do
				v:ConCommand('stopsound')
			end
		end
		return ''
	end

	if cmd == '!rank' then
		if validate and ply:IsSuperAdmin() then
			pseudoent:SetRank(tonumber(word[3]))
		end
		if !validate and word[2] and word[3] then
			CRANK.SetRank(word[2],tonumber(word[3]))
		end
		return ''
	end

end)