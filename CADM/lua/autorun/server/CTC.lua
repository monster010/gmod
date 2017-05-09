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
	timer.Simple(life,function() if IsValid(Tesla) then Tesla:Remove() end end)
end

local function DymLight(ent,pos,col,br,size,life,decay)
	--[[local dl = DynamicLight(ent:EntIndex())
	dl.Pos = pos
	dl.r = col.r
	dl.g = col.g
	dl.b = col.b
	dl.Brightness = br
	dl.Size = sie
	dl.DieTime = CurTime()+life
	dl.Decay = decay
	return dl]]
end

local function CreateLight(pos1,pos2)
	local effectdata = EffectData()
	effectdata:SetStart(pos1)
	effectdata:SetOrigin(pos2)
	util.Effect('cfx_bolt',effectdata)
end

local function CreateSmash(ply,pos)
	CreateLight(ply:GetPos()+Vector(0,0,50),pos+Vector(0,0,50))
	DymLight(ply,ply:GetPos()+Vector(0,0,50),Color(0,0,50),10,256,.1,512)
	sound.Play('ambient/levels/labs/electric_explosion'..math.Round(math.Rand(1,5))..'.wav',ply:GetPos()+Vector(0,0,50))
	CreateTesla(ply:GetPos()+Vector(0,0,50),128,32,2,.1,.01,'0 128 128')
	ply:SetVelocity(-ply:GetVelocity())
	ply:SetPos(pos)
	DymLight(ply,ply:GetPos()+Vector(0,0,50),Color(0,0,50),10,256,.1,512)
	sound.Play('ambient/levels/labs/electric_explosion'..math.Round(math.Rand(1,5))..'.wav',ply:GetPos()+Vector(0,0,50))
	CreateTesla(ply:GetPos()+Vector(0,0,50),128,32,2,.1,.01,'0 128 128')
	ply:ScreenFade(SCREENFADE.IN,Color(200,255,255,128),.4,0)
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
	local position = tr.HitPos+Vector(0,0,8) or ply:GetPos()-ply:GetForward()*55+Vector(0,0,8)
	CreateSmash(self,position)
	self:SetEyeAngles((ply:GetPos()-self:GetPos()):Angle())
end

function meta:Bring(ply)
	if !IsValid(ply) or self == ply then return end
	CreateSmash(self,ply:GetEyeTrace().HitPos+Vector(0,0,8))
end