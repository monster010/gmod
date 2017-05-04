//AutoAddFile 

//Where to search custom resources:
local addon = false //allow addons including (only workshop!)
local other = true //allow sound/models folders to include

local what = 
{
    'sound',
    'models',
    'materials',
    'resource',
}

// don't touch below.
local function aafmsg(what) MsgC(Color(125,125,255),'[AAF]',Color(225,125,155),' '..what..'\n') end

local tbl    = util.JSONToTable(file.Read('aaf.dat') or '')
local addons = file.Find('addons/*','MOD')
local try    = 0

local function AddInit(tbl)

    if addon then
        for v,k in pairs(addons) do
            local buff = ''
            local st   = #k-12
            for i=st,#k-4 do
                buff = buff..k[i]
            end
            resource.AddWorkshop(buff)
            aafmsg('Adding addon '..k)
        end
    end

    local function read(path)
        path=path or ''
        local fs,ds = file.Find(path..'*','MOD')
        for k,f in pairs(fs) do
            if table.HasValue(tbl,path..f) or tbl[path..f] then continue end
            //resource.AddFile(path..f)
            aafmsg('Adding '..path..f)
        end 
        for k,d in pairs(ds) do
            read(path..d..'/') 
        end
    end 
    
    if other then
        for i = 1,#what do
            aafmsg('Reading '..what[i])
            read(what[i]..'/')
        end
    end
    
end

local function LoadGit()

    http.Fetch('https://raw.githubusercontent.com/DC144/gmod/master/AAF/data/aaf.dat',
        function(data)
            if #data < 5 then 
                if try >= 2 then return end 
                try = try + 1 aafmsg('File error! Trying to Load again') LoadGit() 
            else
                aafmsg('Data secussfully loaded!')
                file.Write('aaf.dat',data)
                tbl = util.JSONToTable(file.Read('aaf.dat'))
                AddInit(tbl)
            end
        end,
        function(error)
            aafmsg('Github dont answer or file dont exists!')
        end
    )
    
end

if !tbl then 

    aafmsg('No data found, trying to load from github') 
    LoadGit()
    
else
    
    aafmsg('Adding files, server may freeze for few seconds')
    AddInit(tbl)
    
end


