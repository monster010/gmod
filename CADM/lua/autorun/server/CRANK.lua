local meta = FindMetaTable('Player')

CRANK = {}

CRANK.Ranks = {
	{name='user',team=24,group='user',color=Color(255,255,0)},
	{name='vip',team=23,group='user',color=Color(64,255,64)},
	{name='admin',team=22,group='admin',color=Color(64,64,255)},
	{name='developer',team=21,group='superadmin',color=Color(220,0,255)},
	{name='owner',team=20,group='superadmin',color=Color(255,128,0)},
	{name='user',team=24,group='superadmin',color=Color(255,255,0)}
}

for k,v in pairs(CRANK.Ranks) do
	team.SetUp(v.team,v.name,v.color,true)
end

local unids = {'BOT','NULL','STEAM_ID_PENDING','UNKNOWN'}

function CRANK.SID2CID(id)
	if table.HasValue(unids,id) then return 0 end
	local sidp = string.Split(id,':')
	return tostring('7656119' .. 7960265728+tonumber(sidp[2])+(tonumber(sidp[3])*2))
end

function CRANK.CID2SID(id)
	local s = '76561197960'
	if string.sub(id,1,#s) != s then return 'UNKNOWN' end
	local a = id % 2 == 0 and 0 or 1
	local b = (tonumber(id)-76561197960265728-a)/2
	return 'STEAM_0:'.. a ..':'..(b+2)
end

function CRANK.GetSteamData(id,callback)
	local id = id
	if string.match(id,'STEAM_0') then id = CRANK.SID2CID(id) end
	http.Fetch('http://steamcommunity.com/profiles/'..id..'/?xml=1',function(body,len)
		local t = {}
		t.name = string.match(body,'<steamID><!%[CDATA%[(.-)%]%]></steamID>')
		t.avataricon = string.match(body,'<avatarIcon><!%[CDATA%[(.-)%]%]></avatarIcon>')
		t.avatarmedium = string.match(body,'<avatarMedium><!%[CDATA%[(.-)%]%]></avatarMedium>')
		t.avatarfull = string.match(body,'<avatarFull><!%[CDATA%[(.-)%]%]></avatarFull>')
		t.vacban = string.match(body,'<vacBanned>(.-)</vacBanned>')
		t.tradeban = string.match(body,'<tradeBanState>(.-)</tradeBanState>')
		t.private = string.match(body,'<privacyState>(.-)</privacyState>')
		callback(t)
	end)
end

function CRANK.SetRank(sid,num)
	if !isnumber(num) or !CRANK.Ranks[num] or CRANK.GetRank(sid) == num then return end
	for k,v in pairs(player.GetAll()) do
		if v:SteamID() == sid then
			v:SetRank(num)
			return
		end
	end
	local old = CRANK.Ranks[CRANK.GetRank(sid)]
	util.SetPData(sid,'CRANK',num)
	CRANK.GetSteamData(sid,function(tab) 
		ChatNet(old.color,tab.name,Color(150,150,150),' was ranked to ',CRANK.Ranks[num].color,CRANK.Ranks[num].name)
	end)
end

function CRANK.GetRank(sid)
	return tonumber(util.GetPData(sid,'CRANK')) or 1
end

function CRANK.GetRankTable(sid)
	local num = tonumber(util.GetPData(sid,'CRANK')) or 1
	local tab = table.Copy(CRANK.Ranks[num])
	tab.num = num
	return tab
end

function meta:InitRank()
	local rank = tonumber(self:GetPData('CRANK')) or 1
	self:SetTeam(CRANK.Ranks[rank].team)
	self:SetUserGroup(CRANK.Ranks[rank].group)
end

function meta:SetRank(num)
	if !isnumber(num) or !CRANK.Ranks[num] or self:GetRank() == num then return end
	local old = CRANK.Ranks[self:GetRank()]
	self:SetPData('CRANK',num)
	self:SetTeam(CRANK.Ranks[num].team)
	self:SetUserGroup(CRANK.Ranks[num].group)
	ChatNet(old.color,self:Nick(),Color(150,150,150),' was ranked to ',CRANK.Ranks[num].color,CRANK.Ranks[num].name)
end

function meta:GetRank()
	return tonumber(self:GetPData('CRANK')) or 1
end

function meta:GetRankTable()
	local num = tonumber(self:GetPData('CRANK')) or 1
	local tab = table.Copy(CRANK.Ranks[num])
	tab.num = num
	return tab
end

hook.Add('PlayerInitialSpawn','CRANK',function(ply)
	timer.Simple(0,function() ply:InitRank() end)
end)