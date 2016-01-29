if GetObjectName(GetMyHero()) ~= "Fiora" then return end
require('Inspired')
local mainMenu = Menu("Fiora", "Fiora")
mainMenu:SubMenu("Combo", "Combo")
mainMenu.Combo:Boolean("Q", "Use Q", true)
mainMenu.Combo:Boolean("E", "Use E", true)
mainMenu.Combo:Boolean("R", "Use R", true)

mainMenu:SubMenu("Drawings", "Drawings:")
mainMenu.Drawings:Boolean("Q","Draw Q", true)
mainMenu.Drawings:Boolean("E","Draw E", true)
mainMenu.Drawings:Boolean("R","Draw R", true)
 
OnDraw(function(myHero)
		local pos = GetOrigin(myHero)
		if mainMenu.Drawings.Q:Value() then DrawCircle(myHeroPos().x, myHeroPos().y, myHeroPos().z,400,3,100,0xff00ff00) end
		if mainMenu.Drawings.E:Value() then DrawCircle(myHeroPos().x, myHeroPos().y, myHeroPos().z,0,3,100,0xff00ff00) end
		if mainMenu.Drawings.R:Value() then DrawCircle(myHeroPos().x, myHeroPos().y, myHeroPos().z,GetCastRange(myHero,_R),3,100,0xff00ff000) end
	end)





OnTick(function(myHero)
	if IOW:Mode() == "Combo" then
	local target = GetCurrentTarget()
                       
					    local QPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),0,0,400,250,false,true)
                        if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and ValidTarget(target, 750) and mainMenu.Combo.Q:Value() then
                        CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
                        end

                        if CanUseSpell(myHero, _R) == READY and ValidTarget(target, 500) and mainMenu.Combo.R:Value() then
                        CastTargetSpell(target, _R)
                    	end
			
			if CanUseSpell(myHero, _E) == READY and ValidTarget(target, 300) and mainMenu.Combo.E:Value() then
                        CastSpell(_E)
			end
	end
end)

PrintChat("Toxic Fiora by: POPTART Loaded, Have Fun")
