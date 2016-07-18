if GetObjectName(GetMyHero()) ~= "Azir" then return end

local AzirMenu = Menu("Azir", "Azir")
AzirMenu:SubMenu("Combo", "Combo")
AzirMenu.Combo:KeyBinding("comboKey", "Combo Key", 32)
AzirMenu.Combo:Boolean("Q", "Use Q", true)
AzirMenu.Combo:Boolean("W", "Use W", true)
AzirMenu.Combo:Boolean("E", "Use E", true)
AzirMenu.Combo:Boolean("R", "Use R", true)

AzirMenu:Menu("Harass", "Harass")
AzirMenu.Harass:KeyBinding("harassKey", "Harass Key", string.byte("C"))
AzirMenu.Harass:Boolean("Q", "Use Q", true)
AzirMenu.Harass:Boolean("W", "Use W", true)
AzirMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

AzirMenu:Menu("LaneClear", "LaneClear")
AzirMenu.LaneClear:KeyBinding("laneclearKey", "LaneClear Key", string.byte("V"))
AzirMenu.LaneClear:Boolean("Q", "Use Q", true)
AzirMenu.LaneClear:Boolean("E", "Use E", true)

AzirMenu:Menu("Misc", "Misc")
AzirMenu:SubMenu("Escape", "Escape")
AzirMenu.Escape:KeyBinding("EscapeKey", "Escape Key", string.byte("S"))
AzirMenu.Escape:Boolean("escape", "Use escape", true)


OnTick(function (myHero)

local target = GetCurrentTarget()

	if KeyIsDown(AzirMenu.Combo.comboKey:Key()) then
	
		if AzirMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 450) then 
		local WPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target),1300,250,450,90,false,false)
		if WPred.HitChance == 1 then
		CastSkillShot(_W,WPred.PredPos)
		end
		end
		
		if AzirMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 750) then
		local QPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target),1200,250,750,90,false,false)
		if QPred.HitChance == 1 then
		CastSkillShot(_Q,QPred.PredPos)
		end
		end
		
		if AzirMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target,450) then
			local rpos = Vector(target) + Vector(target):normalized()
			CastSkillShot(_R,rpos)
		end
		
		
		
	if KeyIsDown(AzirMenu.Harass.harassKey:Key()) and GetPercentMP(myHero) >= AzirMenu.Harass.Mana:Value() then
	
	if AzirMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 450) then 
		local WPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target),1300,250,450,90,false,false)
		if WPred.HitChance == 1 then
		CastSkillShot(_W,WPred.PredPos)
		end
		end
		
		if AzirMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 750) then
		local QPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target),1200,250,750,90,false,false)
		if QPred.HitChance == 1 then
		CastSkillShot(_Q,QPred.PredPos)
		end
		end
		
	end
	
	if KeyIsDown(AzirMenu.Escape.escapeKey:Key()) then
        if Ready(_Q) and Ready(_W) and Ready(_E) then
        local wPos = myHero.pos + (cursorPos - myHero.pos):normalized()*450
        CastSkillShot(_W,wPos)
        DelayAction(function()
        CastSkillShot(_Q,cursorPos)
        DelayAction(function()
        CastSpell(_E)
        end,0.001)
        end,0.001)
		end
	end
end
end)
			
			
	
	
	
	
		
	
	
	print ("Loaded")
