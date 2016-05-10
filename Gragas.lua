
    
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
if GetObjectName(GetMyHero()) ~= "Gragas" then return end

require('DamageLib')

local GragasMenu = Menu("Gragas", "Gragas")
GragasMenu:SubMenu("Combo", "Combo")
GragasMenu.Combo:KeyBinding("comboKey", "Combo Key", 32)
GragasMenu.Combo:Boolean("Q", "Use Q", true)
GragasMenu.Combo:Boolean("W", "Use W", true)
GragasMenu.Combo:Boolean("E", "Use E", true)
GragasMenu.Combo:Boolean("R", "Use R", true)

GragasMenu:Menu("Harass", "Harass")
GragasMenu.Harass:KeyBinding("harassKey", "Harass Key", string.byte("C"))
GragasMenu.Harass:Boolean("Q", "Use Q", true)
GragasMenu.Harass:Boolean("E", "Use E", true)
GragasMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80, 1)


GragasMenu:Menu("Killsteal", "Killsteal")
GragasMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)




		
OnTick(function (myHero)
	 
	local target = GetCurrentTarget()
	
	if KeyIsDown(GragasMenu.Combo.comboKey:Key()) then
		
		if GragasMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 550) then
			CastSpell(_W)
		end
			
		if GragasMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target,850) then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), 1200, 132, 850, 100, false, true)
			if QPred.HitChance == 1 then
				CastSkillShot(_Q,QPred.PredPos)
			end
		end

		if GragasMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target,1150) then
			local RPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), 1200, 132, 1150, 100, false, true)
			if RPred.HitChance == 1 then
				CastSkillShot(_R,RPred.PredPos)
			end
		end
		
		if GragasMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target,600) then
			CastSkillShot(_E,GetOrigin(target))
		end	
	end
	
	if KeyIsDown(GragasMenu.Harass.harassKey:Key()) and GetPercentMP(myHero) >= GragasMenu.Harass.Mana:Value() then
	
		if GragasMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target,850) then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), 1200, 132, 850, 100, false, true)
			if QPred.HitChance == 1 then
				CastSkillShot(_Q,QPred.PredPos)
			end
		end
		
		if GragasMenu.Harass.E:Value() and Ready(_E) and ValidTarget(target,600) then
			CastSkillShot(_E,GetOrigin(target))
		end
	end
	
	for i,enemy in pairs(GetEnemyHeroes()) do

		if GragasMenu.Killsteal.Q:Value() and Ready(_Q) and ValidTarget(enemy, 850) and GetCurrentHP(enemy)+GetDmgShield(enemy) < getdmg("Q",enemy ,myHero) then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), 1200, 132, 850, 100, false, true)
			if QPred.HitChance == 1 then
				CastSkillShot(_Q,QPred.PredPos)
			end
		end
		
	end	
end)

print("Toxic Gragas Loaded, Have Fun "..GetUser().."!")	
