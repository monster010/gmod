//Loading menu (denz)
surface.CreateFont('LoadingMenu',{font = 'Default',size = 20})

local LoadingIndex = 0

function LoadingMenu(what,size,netspeed)
    LoadingIndex = LoadingIndex + 1

    local loadingpercent = 0
    local localindex     = LoadingIndex
    local netspeed       = netspeed or 64
    local sizecut        = size/netspeed
    local curtime        = CurTime()
    local cursize        = size
    local active         = true
    local slide          = -350
    local msg            = 'Loading: '..what..' ['..math.floor( cursize )..'/'..size..'kb]'
    local h              = LoadingIndex*60
    
    surface.SetFont( 'LoadingMenu' )
    local w = surface.GetTextSize( msg )
    
    hook.Add('HUDPaint','LoadingMenu'..localindex,function()
    
        if active then
            slide = math.Clamp( slide+( CurTime()-curtime )*85, -w, 0)
        else
            slide = math.Clamp( slide-( CurTime()-curtime )*85, -w, 0)
        end
        
        msg = 'Loading: '..what..' ['..math.floor( cursize )..'/'..size..'kb]'
        cursize = math.Clamp( ( ( CurTime()-curtime )*size )/sizecut, 0, size )
        loadingpercent = math.Clamp( ( ( CurTime()-curtime )*w )/sizecut, 0, w )
        
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawRect( slide, 250+h , w, 50 )
        
        surface.SetFont( 'LoadingMenu' )
        surface.SetTextColor( 0, 0, 0, 255 )
        surface.SetTextPos( slide, 258+h )
        surface.DrawText( msg )
        
        surface.SetDrawColor( 0, 0, 0, 55 )
        surface.DrawRect( slide, 280+h , w, 20 )
        
        surface.SetDrawColor( 0, 250, 0, 125 )
        surface.DrawRect( slide, 280+h , loadingpercent, 20 )
        
        surface.SetDrawColor( 0, 150, 0, 125 )
        surface.DrawRect( slide, 295+h , loadingpercent, 5 )
        
    end)
    
    timer.Simple(sizecut,function()
    
        active = false
        curtime = CurTime()    
        LoadingIndex = LoadingIndex - 1
        
        timer.Simple(1,function()
        
            hook.Remove('HUDPaint','LoadingMenu'..localindex)
            
        end)
       
    end)

end

LoadingMenu('rdata/luapak.lua',228,64)
