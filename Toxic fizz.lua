if GetObjectName(GetMyHero()) ~= "Fizz" then return end

require("Inspired")
require('DamageLib')

local FizzMenu = Menu("Fizz", "Fizz")
FizzMenu:SubMenu("Combo", "Combo")
FizzMenu.Combo:Boolean("Q", "Use Q", true)
FizzMenu.Combo:Boolean("W", "Use W", true)
FizzMenu.Combo:Boolean("E", "Use E", true)
FizzMenu.Combo:Boolean("R", "Use R", true)

FizzMenu:Menu("Harass", "Harass")
FizzMenu.Harass:Boolean("Q", "Use Q", true)
FizzMenu.Harass:Boolean("W", "Use W", true)
FizzMenu.Harass:Boolean("E", "Use E", true)
FizzMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80, 1)


FizzMenu:Menu("Killsteal", "Killsteal")
FizzMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)

local onE = false

OnProcessSpell(function(unit, spellProc)
	if unit == myHero and spellProc.name == "FizzJump" then
		onE = true print("E OFF")
	elseif spellProc.name == "fizzjumptwo" then 
		onE = false print("E OFF")
	end
	
end)
		
OnTick(function (myHero)
	 
	local target = GetCurrentTarget()
	
	if IOW:Mode() == "Combo" then

		if FizzMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target,1275) then
			local RPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), 1300, 135, 1275, 115, false, true)
			if RPred.HitChance == 1 then
				CastSkillShot(_R,RPred.PredPos)
			end
		end

		if FizzMenu.Combo.E:Value() and Ready(_E) and onE == true and ValidTarget(target, 400) then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), math.huge, 115, 400, 110, false, true) 
			if EPred.HitChance == 1 then
				CastSkillShot(_E,EPred.PredPos)
			end
		end
	

		if FizzMenu.Combo.E:Value() and Ready(_E) and onE == false and ValidTarget(target, 500) then
			CastSkillShot(_E,GetOrigin(target))
  		end
	

		if FizzMenu.Combo.W:Value() and Ready(_W) then
			CastSpell(_W)
		end

		if FizzMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 550) then
			CastTargetSpell(target, _Q)
		end
	end

	if IOW:Mode() == "Harass" and GetPercentMP(myHero) >= FizzMenu.Harass.Mana:Value() then

		
		if FizzMenu.Harass.W:Value() and Ready(_W) then
			CastSpell(_W)
		end

		if FizzMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 550) then
			CastTargetSpell(target, _Q)
		end

		if FizzMenu.Combo.E:Value() and Ready(_E) and onE == false and ValidTarget(target, 500) then
			CastSkillShot(_E,GetOrigin(target))
  		end
		

		if FizzMenu.Harass.E:Value() and Ready(_E) and onE == true and ValidTarget(target, 400) then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), math.huge, 115, 400, 110, false, true) 
			if EPred.HitChance == 1 then
				CastSkillShot(_E,EPred.PredPos)
			end
		end
     		
	end

	 for i,enemy in pairs(GetEnemyHeroes()) do

		if FizzMenu.Killsteal.Q:Value() and Ready(_Q) and ValidTarget(enemy, 550) and GetCurrentHP(enemy)+GetDmgShield(enemy) < getdmg("Q",enemy ,myHero) then
			CastTargetSpell(enemy, _Q)
		end
	end
end)

print("Fizz, By: Poptart loaded. Have Fun")
