local CRANK = {
	{name='user',team=23,group='user',color=Color(255,255,0)},
	{name='admin',team=22,group='admin',color=Color(0,50,255)},
	{name='developer',team=21,group='superadmin',color=Color(255,128,0)},
	{name='owner',team=20,group='superadmin',color=Color(220,0,255)},
	{name='user',team=23,group='superadmin',color=Color(255,255,0)}
}

for k,v in pairs(CRANK) do
	team.SetUp(v.team,v.name,v.color,true)
end