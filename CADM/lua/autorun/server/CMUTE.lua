local meta = FindMetaTable('Player')

function meta:Mute(num)
	if !num or !isnumber(num) or num < 1 then
		self.CMUTE = true
	else
		self.CMUTE = true
		timer.Simple(num,function() if IsValid(self) then self.CMUTE = false end end)
	end
end

function meta:UnMute()
	self.CMUTE = false
end

hook.Add('PlayerInitialSpawn','CMUTE',function(ply)
	ply.CMUTE = false
end)

hook.Add('PlayerCanHearPlayersVoice','CMUTE',function(listener,talker)
	return !talker.CMUTE
end)