local meta = FindMetaTable('Player')

local CRANK = {
	{name='user',team=23,group='user',color=Color(255,255,0)},
	{name='admin',team=22,group='admin',color=Color(0,50,255)},
	{name='developer',team=21,group='superadmin',color=Color(255,128,0)},
	{name='owner',team=20,group='superadmin',color=Color(220,0,255)},
	{name='user',team=23,group='superadmin',color=Color(255,255,0)}
}

for k,v in pairs(CRANK) do
	team.SetUp(v.team,v.name,v.color,true)
end

function CRANK_SetRank(steamid,num)
	if !isnumber(num) or math.Clamp(num,1,#CRANK) != num or math.Round(num) != num then return end
	util.SetPData(steamid,'CRANK',num)
end

function CRANK_GetRank(steamid)
	return tonumber(util.GetPData(steamid,'CRANK')) or 1
end

function CRANK_GetRankTable(steamid)
	local num = tonumber(util.GetPData(steamid,'CRANK')) or 1
	local tab = table.Copy(CRANK[num])
	tab.num = num
	return tab
end

function meta:InitRank()
	local rank = tonumber(util.GetPData(self:SteamID(),'CRANK')) or 1
	self:SetTeam(CRANK[rank].team)
	self:SetUserGroup(CRANK[rank].group)
end

function meta:SetRank(num)
	if !isnumber(num) or math.Clamp(num,1,#CRANK) != num or math.Round(num) != num then return end
	util.SetPData(self:SteamID(),'CRANK',num)
	self:SetTeam(CRANK[num].team)
	self:SetUserGroup(CRANK[num].group)
end

function meta:GetRank()
	return tonumber(util.GetPData(self:SteamID(),'CRANK')) or 1
end

function meta:GetRankTable()
	local num = tonumber(util.GetPData(self:SteamID(),'CRANK')) or 1
	local tab = table.Copy(CRANK[num])
	tab.num = num
	return tab
end

hook.Add('PlayerInitialSpawn','CRANK',function(ply)
	timer.Simple(0,function() ply:InitRank() end)
end)