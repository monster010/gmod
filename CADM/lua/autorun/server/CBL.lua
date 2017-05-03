local blacklist_props = {
	['models/props_trainstation/train005.mdl'] = true,
	['models/props_trainstation/train003.mdl'] = true,
	['models/props_wasteland/medbridge_base01.mdl'] = true,
	['models/props_combine/combine_train02b.mdl'] = true,
	['models/props_combine/combine_train02a.mdl'] = true,
	['models/props_combine/CombineTrain01a.mdl'] = true,
	['models/Cranes/crane_frame.mdl'] = true,
	['models/combine_dropship.mdl'] = true,
	['models/Combine_Strider.mdl'] = true,
	['models/cranes/crane_frame.mdl'] = true,
	['models/cranes/crane_docks.mdl'] = true,
	['models/combine_dropship.mdl'] = true,
	['models/props_canal/canal_bridge02.mdl'] = true,
	['models/props_combine/combine_citadel001b_open.mdl '] = true,
	['models/props_phx/huge/evildisc_corp.mdl'] = true,
	['models/props/de_nuke/storagetank.mdl'] = true,
	['models/props_phx/mk-82.mdl'] = true,
	['models/combine_dropship.mdl'] = true,
	['models/props_radiostation/radio_antenna01.mdl'] = true,
	['models/props_c17/oildrum001_explosive.mdl'] = true,
	['models/props_phx/cannonball_solid.mdl'] = true,
	['models/combine_helicopter.mdl'] = true,
	['models/props_c17/column02a.mdl'] = true,
	['models/props_phx/rocket1.mdl'] = true,
	['models/props_phx/amraam.mdl'] = true,
	['models/props_canal/canal_bridge01.mdl'] = true,
	['models/props_phx/ww2bomb.mdl'] = true,
	['models/combine_helicopter/helicopter_bomb01.mdl'] = true,
	['models/props_combine/combine_citadel001_open.mdl'] = true,
	['models/props_phx/torpedo.mdl'] = true,
	['models/props_phx/cannonball.mdl'] = true,
	['models/cranes/crane_frame.mdl'] = true,
	['models/props_trainstation/flatcar.mdl'] = true,
	['models/Combine_Helicopter/helicopter_bomb01.mdl'] = true,
	['models/hunter/blocks/cube8x8x8.mdl'] = true,
	['models/hunter/blocks/cube6x6x6.mdl'] = true,
	['models/hunter/blocks/cube8x8x4.mdl'] = true,
	['models/hunter/blocks/cube4x6x4.mdl'] = true
}
local blacklist_sents = {
	['combine_mine'] = true,
	['prop_thumper'] = true,
	['item_suit'] = true,
	['grenade_helicopter'] = true,
	['gmod_playx'] = true
}
local blacklist_ents = {
	['point_servercommand'] = true,
	['lua_run'] = true
}
local blacklist_tools = {
	--['adv_duplicator'] = true,
	--['duplicator'] = true,
	['wire_turret'] = true,
	['wire_explosive'] = true,
	['wire_simple_explosive'] = true,
	['paint'] = true,
	['trails'] = true,
	['spawner'] = true,
	['dynamite'] = true,
	['creator'] = true
}
local blacklist_sweps = {
	['m9k_davy_crockett'] = true,
	['m9k_orbital_strike'] = true
}




hook.Add('OnEntityCreated','CBL',function(ent)
	if blacklist_ents[blacklist_ents] then ent:Remove() end
end)

hook.Add('PlayerSpawnProp','CBL',function(ply,mdl)
	if !ply:IsAdmin() and blacklist_props[mdl] then return false end
end)

hook.Add('PlayerSpawnSENT','CBL',function(ply,class)
	if !ply:IsAdmin() and blacklist_sents[class] then return false end
end)

hook.Add('CanTool','CBL',function(ply,tr,tool)
	if !ply:IsAdmin() and blacklist_tools[tool] then return false end
end)

hook.Add('PlayerCanPickupWeapon','CBL',function(ply,wep)
	if !ply:IsAdmin() and blacklist_sweps[wep:GetClass()] then return false end
end)