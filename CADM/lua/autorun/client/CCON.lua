CCON = {}

net.Receive('CCON',function()
	CCON = net.ReadTable()
end)

hook.Add('ChatText','CCON',function(_,_,_,msg)
	if msg == 'joinleave' then return true end
end)