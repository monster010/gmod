//TODO:: 
//.Prevent Client to upload same files on sever
//.MORE Net compress = fast?
//.12 line: Compress parts or whole file?
//.net.Int full bit get and out (8= 255,16= 65535,32= 4,294,967,295)( (2^n)-1 ) 5 - 32
if CLIENT then

	//MakeParts func
	local function MakeParts(what,cut)
		local Data = {}
		local Count = math.ceil(#what/cut)
		for i = 1,Count do Data[i] = util.Compress(what:sub(cut*(i-1)+1,cut*i)) end
		return Data
	end

	//SendFile func
	local Queue = 0
	function SendFile(what)
		if Queue > 0 then timer.Simple(1,function() SendFile(what) end) return end //Queue 
		Queue = Queue + 1
		local Data = file.Read(what,'MOD')
		local Size = #Data
		local SendData  = MakeParts(Data,10240)
		local Directory = what

		for i=1,#SendData do
			timer.Simple(i/2,function()
				net.Start('DenzNetwork')
					
					net.WriteUInt(#Directory,16)	                     	                     	                     	                     	                     	                      //Directory size
					
					net.WriteUInt(i,32)	                     	                     	                     	                     	                     	                     //Part
					net.WriteUInt(#SendData,32)	                     	                     	                     	                     //All Parts
					net.WriteUInt(Size,32)	                     	                     	                     	                     	                     //Full Size
					net.WriteUInt(#SendData[i],16)//Data Size
					
					net.WriteData(Directory,#Directory)//Directory data
					net.WriteData(SendData[i],#SendData[i]) //Data parts
					
				net.SendToServer()
			end)
		end
	end

	//Prevent MULTILOAD
	net.Receive('DenzNetwork',function() Queue = Queue - 1 end)
	
end
if SERVER then

	//Init Networks
	util.AddNetworkString('DenzNetwork')

	//Cleaning players
	local function Clean(x) return (x:SteamID():gsub(':','_')):lower() end

	//Making fancy directory
	local function MakeDir(what)
		local buff = what
		local tab  = string.Explode('/',what);buff = ''
		for i = 1, #tab-1 do
			buff = (buff or '')..'/'..tab[i]
		end
		return buff
	end

	//Netfuck, 64kb per net bypass
	net.Receive('DenzNetwork',function(_,pl)
		local NameSize = net.ReadUInt(16)

		local Part     = net.ReadUInt(32)
		local Parts    = net.ReadUInt(32)
		local FullSize = net.ReadUInt(32)
		local Size     = net.ReadUInt(16)
		
		local FullDirectory = net.ReadData(NameSize)
		local Directory 	= MakeDir(FullDirectory)
		
		local Data  = util.Decompress(net.ReadData(Size))
		
		//Prevent override (TODO: Client prevent, load his database DAUN?)
		file.CreateDir('denznet/'..Clean(pl)..'/'..Directory)
		if file.Size('data/denznet/'..Clean(pl)..'/'..FullDirectory..'.txt','MOD') == FullSize then 
			net.Start('DenzNetwork')net.Send(pl) return 
		end

		//Fancy console msg
		MsgC(
		Color(255,125,0)  ,'[DenzNet] ',
		Color(255,255,255),pl:Name()..':',
		Color(255,125,125),FullDirectory,' ['..Part..'/'..Parts..'] ',
		Color(125,255,125),'Net:',_,'\n'
		)
		
		//Next load
		if Part == Parts then net.Start('DenzNetwork')net.Send(pl) end
		file.Append('denznet/'..Clean(pl)..'/'..FullDirectory..'.txt',Data)
	end)

end