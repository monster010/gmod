if SERVER then
	hook.Add('Think','AAF',function()
		include('aaf.lua')
		hook.Remove('Think','AAF')
	end)
end