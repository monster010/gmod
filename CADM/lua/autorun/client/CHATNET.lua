net.Receive('CHATNET',function()
	chat.AddText(unpack(net.ReadTable()))
end)