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

function CRANK.SID2CID(id)
    if string.sub(id,1,7) != 'STEAM_0' then return end
    local s = string.Split(id,':')
    local a = tonumber(s[2])
    local b = tonumber(s[3])
    return '7656119'..7960265728+a+(b*2)
end

function CRANK.CID2SID(id)
    if string.sub(id,1,7) != '7656119' then return end
    local pre = string.sub(id,8,-1)
    local a = pre%2
    local b = (tonumber(pre)-7960265728-a)/2
    return 'STEAM_0:'..a..':'..b
end

function CRANK.GetSteamData(id,callback)
	local link
	if string.match(id,'STEAM_0') then link = 'http://steamcommunity.com/profiles/'..CRANK.SID2CID(id)..'/?xml=1'
	elseif string.match(id,'7656119') then link = 'http://steamcommunity.com/profiles/'..id..'/?xml=1'
	elseif string.match(id,'http://steamcommunity.com/') then link = id..'/?xml=1'
	else link = 'http://steamcommunity.com/id/'..id..'/?xml=1' end
	http.Fetch(link,function(body,len)
		if string.match(body,'<error>') then return end
		local t = {}
		t.name = string.match(body,'<steamID><!%[CDATA%[(.-)%]%]></steamID>')
		t.cid = string.match(body,'<steamID64>(.-)</steamID64>')
		t.sid = CRANK.CID2SID(t.cid)
		t.avataricon = string.match(body,'<avatarIcon><!%[CDATA%[(.-)%]%]></avatarIcon>')
		t.avatarmedium = string.match(body,'<avatarMedium><!%[CDATA%[(.-)%]%]></avatarMedium>')
		t.avatarfull = string.match(body,'<avatarFull><!%[CDATA%[(.-)%]%]></avatarFull>')
		t.vacban = string.match(body,'<vacBanned>(.-)</vacBanned>')
		t.tradeban = string.match(body,'<tradeBanState>(.-)</tradeBanState>')
		t.private = string.match(body,'<privacyState>(.-)</privacyState>')
		callback(t)
	end)
end

function CRANK.SetRank(id,num)
	if !isnumber(num) or !CRANK.Ranks[num] then return end
	for k,v in pairs(player.GetAll()) do
		if v:SteamID() == id or v:SteamID64() == id then
			v:SetRank(num)
			return
		end
	end
	CRANK.GetSteamData(id,function(tab)
		if CRANK.GetRank(tab.sid) == num then return end
		for k,v in pairs(player.GetAll()) do
			if v:SteamID() == tab.sid then
				v:SetRank(num)
				return
			end
		end
		local old = CRANK.Ranks[CRANK.GetRank(tab.sid)]
		util.SetPData(tab.sid,'CRANK',num)
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