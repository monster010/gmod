local meta = FindMetaTable('Player')

function meta:SetGodMode(bool)
	self.CGM = bool
	if bool then self:GodEnable() else self:GodDisable() end
end

function meta:GetGodMode()
	return self.CGM or false
end

hook.Add('PlayerSpawn','CGM',function(ply)
	if ply.CGM then ply:GodEnable() else ply:GodDisable() end
end)

hook.Add('PlayerInitialSpawn','CGM',function(ply)
	ply.CGM = false
end)

hook.Add('EntityTakeDamage','CGM',function(ent,dmg)
	if IsValid(dmg:GetAttacker()) and dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():GetGodMode() then return true end
end)