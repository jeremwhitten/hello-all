if GetObjectName(GetMyHero()) ~= "Janna" then return end

require('DamageLib')

local JannaMenu = Menu("Janna", "Janna")
JannaMenu:SubMenu("Combo", "Combo")
JannaMenu.Combo:Boolean("Q", "Use Q", true)
JannaMenu.Combo:Boolean("W", "Use W", true)
JannaMenu.Combo:Boolean("E", "Use E", true)
JannaMenu.Combo:Boolean("R", "Use R", true)

JannaMenu:Menu("Harass", "Harass")
JannaMenu.Harass:Boolean("Q", "Use Q", true)
JannaMenu.Harass:Boolean("E", "Use E", true)
JannaMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80, 1)


JannaMenu:Menu("Killsteal", "Killsteal")
JannaMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)




		
OnTick(function (myHero)
	 
	local target = GetCurrentTarget()
	
	if IOW:Mode() == "Combo" then
		
		if JannaMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target,600) then
			CastTargetSpell(target, _W)
		end
		
		
		if JannaMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target,900) then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), 1200, 126, 900, 115, false, true)
			if QPred.HitChance == 1 then 
				CastSkillShot(_Q,QPred.PredPos)
			end
		end
		
		 for _, ally in pairs(GetAllyHeroes()) do
                        if JannaMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target,800) and (GetCurrentHP(ally)/GetMaxHP(ally))<0.3 then
                        CastTargetSpell(ally, _E)
                        end
         	 end
		 
		 if JannaMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target,800) and (GetCurrentHP(myHero)/GetMaxHP(myHero))<0.15 then
                        CastTargetSpell(myHero, _E)
         	 end
		 
		 for _, ally in pairs(GetAllyHeroes()) do
                        if JannaMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target,875) and (GetCurrentHP(ally)/GetMaxHP(ally))<0.3 then
                        CastSpell(_R)
                        end
         	 end
		 
	end
end)	
	
print("Toxic Janna Loaded, Have Fun!")
