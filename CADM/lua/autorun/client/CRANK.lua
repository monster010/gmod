CRANK = {}

CRANK.Ranks = {
	{name='user',team=24,group='user',color=Color(255,255,0)},
	{name='vip',team=23,group='user',color=Color(64,255,64)},
	{name='admin',team=22,group='admin',color=Color(64,64,255)},
	{name='developer',team=21,group='superadmin',color=Color(220,0,255)},
	{name='owner',team=20,group='superadmin',color=Color(255,128,0)},
	{name='user',team=24,group='superadmin',color=Color(255,255,0)}
}

for k,v in pairs(CRANK.Ranks) do
	team.SetUp(v.team,v.name,v.color,true)
end