local meta = FindMetaTable('Player')

local function CreateTesla(pos,radius,count,thick,life,interval,color)
	local Tesla = ents.Create('point_tesla')
	Tesla:Spawn()
	Tesla:SetPos(pos)
	Tesla:SetKeyValue('m_flRadius',radius)
	Tesla:SetKeyValue('beamcount_min',count)
	Tesla:SetKeyValue('thick_min',thick)
	Tesla:SetKeyValue('lifetime_min',life)
	Tesla:SetKeyValue('interval_min',interval)
	Tesla:SetKeyValue('m_Color',color)
	Tesla:Fire('DoSpark',1)
	Tesla:Fire('TurnOn',1)
	timer.Simple(1,function() if IsValid(Tesla) then Tesla:Remove() end end)
end

function meta:Teleport(ply)
	if self == ply or (!ply:IsInWorld() and self:GetMoveType() != MOVETYPE_NOCLIP and ply:GetMoveType() != MOVETYPE_NOCLIP) then return end
	local yawForward = ply:EyeAngles().yaw
	local directions = {
		math.NormalizeAngle(yawForward-180),
		math.NormalizeAngle(yawForward+90),
		math.NormalizeAngle(yawForward-90),
		yawForward,
	}
	local t = {}
	t.start = ply:GetPos()+Vector(0,0,32)
	t.filter = {ply,self}
	local i = 1
	t.endpos = ply:GetPos()+Angle(0,directions[i],0):Forward()*48
	local tr = util.TraceEntity(t,self)
	while tr.Hit do
		i = i + 1
		if i > #directions then
			if self:GetMoveType() == MOVETYPE_NOCLIP or ply:GetMoveType() == MOVETYPE_NOCLIP then
				return ply:GetPos() + Angle(0,directions[1],0):Forward()*48
			else
				return false
			end
		end
		t.endpos = ply:GetPos()+Angle(0,directions[i],0):Forward()*48
		tr = util.TraceEntity(t,self)
	end
	self:SetPos(tr.HitPos+Vector(0,0,8) or ply:GetPos()-ply:GetForward()*55+Vector(0,0,8))
	self:SetEyeAngles((ply:GetPos()-self:GetPos()):Angle())
	self:EmitSound('ambient/levels/labs/electric_explosion'..math.Round(math.Rand(1,5))..'.wav')
	CreateTesla(self:GetPos()+Vector(0,0,50),500,100,1,1,.01,'125 125 255')
end

function meta:Bring(ply)
	if !IsValid(ply) or self == ply then return end
	self:SetPos(ply:GetEyeTrace().HitPos+Vector(0,0,8))
end