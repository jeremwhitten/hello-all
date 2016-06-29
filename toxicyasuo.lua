if GetObjectName(GetMyHero()) ~= "Yasuo" then return end

local YasuoMenu = Menu("Yasuo", "Yasuo")
YasuoMenu:SubMenu("Combo", "Combo")
YasuoMenu.Combo:KeyBinding("comboKey", "Combo Key", 32)
YasuoMenu.Combo:Boolean("Q", "Use Q", true)
YasuoMenu.Combo:Boolean("W", "Use W", true)
YasuoMenu.Combo:Boolean("E", "Use E", true)
YasuoMenu.Combo:Boolean("R", "Use R", true)

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
	
		if YasuoMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 475) then
		local QPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target),1500,250,425,90,false,false)
		if QPred.HitChance == 1 then
		CastSkillShot(_Q,QPred.PredPos)
		end
		end
		
		if YasuoMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 900) and GetCastName(myHero,_Q) == "YasuoQ3W" then
		local QWPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target),1500,250,900,90,false,false)
		if QWPred.HitChance == 1 then
		CastSkillShot(_Q,QWPred.PredPos)
		end
		end
		
		
		if YasuoMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 475) then
			CastTargetSpell(target, _E)
		end
		
		if YasuoMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 1200) then
		if GetCurrentHP(target)+GetDmgShield(target) < CalcDamage(myHero, target, GetCastLevel(myHero,_R)+GetBonusDmg(myHero))then
		CastSpell(_R)
		end
		end
		
		local TargetDistance = GetDistance(target)
		mPos = ClosestMinion(target,MINION_ENEMY)
		if IsReady(_E) and mPos then
		CastTargetSpell(mPos, _E)
		end
		
	end
	
	
	
	
	for _,Y in pairs(minionManager.objects) do
	if ValidTarget(Y,475) then

	for _, Y in pairs(minionManager.objects) do
	if ValidTarget(Y,475) then 
	local z = (GetCastLevel(myHero,_E)*20)+(GetBonusAP(myHero)*.65)+(GetBaseDamage(myHero))
	local hp = GetCurrentHP(Y)
	local Dmg = CalcDamage(myHero, Y, z)
		if KeyIsDown(YasuoMenu.LaneClear.laneclearKey:Key())then
			if YasuoMenu.LaneClear.E:Value() and dmg > hp then
			CastTargetSpell(Y, _E)
			end
		end
	end
	end
	end
	
	
	end
	
	for i,mobs in pairs(minionManager.objects) do
		if KeyIsDown(YasuoMenu.LaneClear.laneclearKey:Key()) then
			if YasuoMenu.LaneClear.Q:Value() and ValidTarget(mobs,475)then
			CastSkillShot(_Q,mobs)
			end
		end
	end
	
	
end)

print ("Loaded")
