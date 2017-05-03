local meta = FindMetaTable('Player')

util.AddNetworkString('CHATNET')

function ChatNet(...)
	net.Start('CHATNET')
		net.WriteTable({...})
	net.Broadcast()
end

function meta:ChatNet(...)
	if IsValid(self) and self:IsPlayer() then
		net.Start('CHATNET')
			net.WriteTable({...})
		net.Send(self)
	end
end