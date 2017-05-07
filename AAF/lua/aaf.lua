//AutoAddFile 

AAF = {}

AAF.addon	  = true //allow addons including (only workshop!) //8192 MAX includes
AAF.other 	  = true //allow sound/models folders to include
AAF.massages  = true //massages in console

//Where to search custom resources:
AAF.include = 
{
    'sound',
    'models',
    'materials',
    'resource',
}

//Workshop id or full name of file
AAF.blacklist =
{
	'id',
}

//-----------------\\
--don't touch below--

function AAF.Msg(what) 
	if !AAF.massages then return end
	MsgC(Color(125,125,255),'[AAF]',Color(225,125,155),' '..what..'\n')
end

AAF.Try    = 0
AAF.Data   = util.JSONToTable(file.Read('aaf.dat') or '')
AAF.addons = file.Find('addons/*','MOD')

function AAF.AddInit(tbl)
	local function read(path)
		path=path or ''
		local fs,ds = file.Find(path..'*','MOD')
		for k,f in pairs(fs) do
			if (table.HasValue(tbl,path..f) or tbl[path..f]) or AAF.blacklist[path..f] then 
				continue end
			AAF.Msg('Adding '..path..f)
			resource.AddSingleFile(path..f)
		end 
		for k,d in pairs(ds) do
			read(path..d..'/') 
		end
	end
	
	AAF.Msg('Adding files, server may freeze for few seconds')
	
	if AAF.addon then
		for v,k in pairs(AAF.addons) do
			local buff = ''
			local st   = #k-12
			for i=st,#k-4 do buff = buff..k[i] end
			resource.AddWorkshop(buff)
			AAF.Msg('Adding addon '..k)
		end
	end

	if AAF.other then
		for i = 1,#AAF.include do
			AAF.Msg('Reading '..AAF.include[i])
			read(AAF.include[i]..'/')
		end
	end
end

function AAF.LoadGit()
    http.Fetch('https://raw.githubusercontent.com/DC144/gmod/master/AAF/data/aaf.dat',
        function(data)
            if #data < 30 then 
                if AAF.Try >= 2 then AAF.Msg('Something bad happend! Abort!') return end 
                AAF.Try = AAF.Try + 1 AAF.Msg('File error! Trying to Load again') AAF.LoadGit() 
            else
                AAF.Msg('Data secussfully loaded!')
                file.Write('aaf.dat',data)
                AAF.Data = util.JSONToTable(file.Read('aaf.dat'))
                AAF.AddInit(AAF.Data)
            end
        end,
        function(err)
			AAF.Msg(err)
            AAF.Msg('Github dont answer or file dont exists!')
        end
    )
end

//if GetConVar("sv_downloadurl"):GetString() != '' then
//	AAF.Msg(GetConVar("sv_downloadurl"):GetString()..' Detected FastDL! Aborting AAF!')
//return end

if !AAF.Data then 
    AAF.Msg('No data found, trying to load from github') 
    AAF.LoadGit()
else
	AAF.AddInit(AAF.Data)
end