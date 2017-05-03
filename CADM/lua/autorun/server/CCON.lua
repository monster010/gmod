--http://ip-api.com/json/
--http://api.sypexgeo.net/json/

CCON = {}

gameevent.Listen('player_connect')
gameevent.Listen('player_disconnect')

util.AddNetworkString('CCON')

local function Profitrole(...)
	local t = {}
	local args = {...}
	for k,v in pairs(args) do
		if v and !table.HasValue(t,v) and v != '' then
			table.insert(t,v)
		end
	end
	local toret = table.concat(t,', ')
	if #t == 1 then toret = t[1] end
	return toret
end

local function Send(t)
	net.Start('CCON')
	net.WriteTable(t)
	net.Broadcast()
end

hook.Add('player_connect','CCON',function(data)
	CCON[data.userid] = {}
	CCON[data.userid].name = data.name
	CCON[data.userid].steam = data.networkid
	CCON[data.userid].ip = data.address
	Send(CCON)

	local ip = data.address
	ip = string.Explode(':',ip)[1]

	http.Fetch('http://api.sypexgeo.net/json/'..ip,function(b)
		local see = util.JSONToTable(b)
		if !ip or ip == 'loopback' or ip == 'none' then
			ChatNet(CRANK_GetRankTable(data.networkid).color or Color(255,255,0),data.name,Color(150,150,150),' (',Color(0,0,0),data.networkid,Color(150,150,150),') is connecting')
			MsgC(Color(220,0,255),'[CCON]: ',Color(255,150,0),'Connecting '..data.name..'\n')
			return
		end
		if !see or !see.city then
			ChatNet(CRANK_GetRankTable(data.networkid).color or Color(255,255,0),data.name,Color(150,150,150),' (',Color(0,0,0),data.networkid,Color(150,150,150),') is connecting')
			MsgC(Color(220,0,255),'[CCON]: ',Color(255,150,0),'Connecting '..data.name..' ['..ip..']\n')
			return
		end
		ChatNet(CRANK_GetRankTable(data.networkid).color or Color(255,255,0),data.name,Color(150,150,150),' (',Color(0,0,0),data.networkid,Color(150,150,150),') is connecting',' ('..Profitrole(see.city.name_ru,see.region.name_ru,see.country.name_ru)..', ',Color(150,150,150),')')
		MsgC(Color(220,0,255),'[CCON]: ',Color(255,150,0),'Connecting '..data.name..' ['..ip..']\n')
	end)
end)

hook.Add('PlayerInitialSpawn','CCON',function(ply)
	timer.Create('CCON|PLY#'..ply:UserID(),.2,1,function() ChatNet(ply:GetRankTable().color or Color(255,255,0),ply:Nick(),Color(150,150,150),' connected') end)
	CCON[ply:UserID()] = nil
	Send(CCON)
end)

hook.Add('player_disconnect','CCON',function(data)
	CCON[data.userid] = nil
	Send(CCON)
	ChatNet(CRANK_GetRankTable(data.networkid).color or Color(255,255,0),data.name,Color(150,150,150),' (',Color(0,0,0),data.networkid,Color(150,150,150),') disconnected')
	MsgC(Color(220,0,255),'[CCON]: ',Color(255,150,0),'Disconnected '..data.name..'\n')
end)