if GetObjectName(GetMyHero()) ~= "Aatrox" then return end
require ('Inspired')
local mainMenu = Menu("Aatrox", "Aatrox")
mainMenu:SubMenu("Combo", "Combo")
mainMenu.Combo:Boolean("Q", "Use Q", true)
mainMenu.Combo:Boolean("W", "Use W", true)
mainMenu.Combo:Boolean("E", "Use E", true)
mainMenu.Combo:Boolean("R", "Use R", true)

mainMenu:SubMenu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("Q", "Draw Q Range", true)
mainMenu.Drawings:Boolean("E", "Draw E Range", true)

mainMenu:SubMenu("DMG", "Draw DMG")
mainMenu.DMG:Boolean("Q", "Draw Q Dmg", true)
mainMenu.DMG:Boolean("E", "Draw E Dmg", true) 
 
OnTick(function(myHero)
        if IOW:Mode() == "Combo" then
        local target = GetCurrentTarget()
                 local QPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),2000,670,650,250,false,true)
                 local EPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1250,300,1075,35,false,false)    




                        if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and ValidTarget(target, 650) and mainMenu.Combo.Q:Value() then
                        CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
                        end
                         if CanUseSpell(myHero, _W) == READY and ValidTarget(target, 700) and mainMenu.Combo.W:Value() then
                        if GotBuff(myHero, "aatroxwlife") == 1 and (GetCurrentHP(myHero)/GetMaxHP(myHero))>0.5  then
                        CastSpell(_W)
                        elseif GotBuff(myHero, "aatroxwpower") == 1 and (GetCurrentHP(myHero)/GetMaxHP(myHero))<0.5 then
                        CastSpell(_W)
                        end
                        end
                        if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 and ValidTarget(target, 1075) and mainMenu.Combo.E:Value() then
                        CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
                        end
                        if CanUseSpell(myHero, _R) == READY and ValidTarget(target, 700)  and mainMenu.Combo.R:Value() then
                         if (GetCurrentHP(myHero)/GetMaxHP(myHero))<0.3 then 
                        CastSpell(_R)
                        end
                    end
        end


end)

 
PrintChat("Toxic Aatrox by: POPTART Loaded, Have Fun")
