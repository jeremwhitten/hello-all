if GetObjectName(GetMyHero()) ~= "Yasuo" then return end

local YasuoMenu = Menu("Yasuo", "Yasuo")
YasuoMenu:SubMenu("Combo", "Combo")
YasuoMenu.Combo:KeyBinding("comboKey", "Combo Key", 32)
YasuoMenu:Boolean("Q", "Use Q", true)
YasuoMenu:Boolean("W", "Use W", true)
YasuoMenu:Boolean("E", "Use E", true)
YasuoMenu:Boolean("R", "Use R", true)

YasuoMenu:Menu("Harass", "Harass")
YasuoMenu.Harass:KeyBinding("harassKey", "Harass Key", string.byte("C"))
YasuoMenu.Harass:Boolean("Q", "Use Q", true)
YasuoMenu.Harass:Boolean("E", "Use E", true)

YasuoMenu:Menu("LaneClear", "LaneClear")
YasuoMenu.LaneClear:KeyBinding("laneclearKey", "LaneClear Key", string.byte("V"))
YasuoMenu.LaneClear:Boolean("Q", "Use Q", true)
YasuoMenu.LaneClear:Boolean("E", "Use E", true)

OnTick(function (myHero)

local target = GetCurrentTarget()

	if KeyIsDown(YasuoMenu.Combo.comboKey:Key()) then
		if YasuoMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 475) then
			CastTargetSpell(target, _E)
		end
		
	end
	

	for i,mobs in pairs(minionManager.objects) do
		if KeyIsDown(YasuoMenu.LaneClear.laneclearKey:Key()) then
			if YasuoMenu.LaneClear.Q:Value() and ValidTarget(mobs,475)then
			CastSkillShot(_Q,mobs)
			end
		end
	end
	
	for _,M in pairs(minionManager.objects) do
	if ValidTarget(M,475) then

	for _, M in pairs(minionManager.objects) do
	if ValidTarget(M,475) then 
	local z = (GetCastLevel(myHero,_E)*20)+(GetBonusAP(myHero)*.70)+(GetBaseDamage(myHero))
	local hp = GetCurrentHP(M)
	local Dmg = CalcDamage(myHero, M, z)
		if KeyIsDown(YasuoMenu.LaneClear.laneclearKey:Key())then
			if YasuoMenu.LaneClear.E:Value() and dmg > hp then
			CastTargetSpell(M, _E)
			end
		end
	end
	end
	end
	
	
	end
	
	
end)

print ("Loaded")
