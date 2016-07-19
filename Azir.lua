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
AzirMenu.Escape:KeyBinding("EscapeKey", "Escape Key", string.byte("Z"))
AzirMenu.Escape:Boolean("escape", "Use escape", true)

AzirMenu:Menu("Insec", "Insec")
AzirMenu.Insec:KeyBinding("InsecKey", "Insec Key", string.byte("T"))
AzirMenu.Insec:Boolean("Insec", "Use Insec", true)

AzirMenu:SubMenu("Skinhack", "Skinhack")
AzirMenu.Skinhack:Slider("hs", "Skin Order", 0,0,7)

OnDraw(function()
		SkinChanger()
	end)

function SkinChanger()
	HeroSkinChanger(myHero, AzirMenu.Skinhack.hs:Value())
end


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
	
		if AzirMenu.Escape.escape:Value() and AzirMenu.Escape.EscapeKey:Value() then
					if Ready(_Q) and Ready(_W) and Ready(_E) then
	local cursorPos = GetMousePos()
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
		
	for i,mobs in pairs(minionManager.objects) do	
		if KeyIsDown(AzirMenu.LaneClear.LaneClearKey:Key()) then
			
			if AzirMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(mobs, 450) then
			CastSkillShot(_W, mobs.pos)
			end
			
			if AzirMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(mobs, 750) then
			CastSkillShot(_Q, mobs.pos)
			end
		end
	end
	
	
		if KeyIsDown(AzirMenu.Insec.InsecKey:Key()) then	
			if Ready(_Q) and Ready(_W) and Ready(_E) and Ready(_R) and ValidTarget(target,750) then
		local cursorPos = GetMousePos()
		local QPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target),1200,250,750,90,false,false)
		local wPos = myHero.pos + (cursorPos - myHero.pos):normalized()*450
		local rpos = Vector(target) + Vector(target):normalized()*450
                    CastSkillShot(_W,wPos)
        DelayAction(function()
                    CastSkillShot(_Q,QPred.PredPos)
        DelayAction(function()
                CastSpell(_E)
        DelayAction(function()
        	CastSkillShot(_R,rpos)
				end,0.001)
			end,0.002)
			end,0.003)
				
		end
		end
					
		
			
		

end)
			
			
	
	
	
	
		
	
	
	print ("Toxic Azir")
