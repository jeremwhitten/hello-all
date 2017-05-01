if GetObjectName(GetMyHero()) ~= "Xayah" then return end

local XayahMenu = Menu("Xayah", "Xayah")
XayahMenu:SubMenu("Combo", "Combo")
XayahMenu.Combo:KeyBinding("comboKey", "Combo Key", 32)
XayahMenu.Combo:Boolean("Q", "Use Q", true)
XayahMenu.Combo:Boolean("W", "Use W", true)
XayahMenu.Combo:Boolean("E", "Use E", true)
XayahMenu.Combo:Boolean("R", "Use R", true)

XayahMenu:Menu("LaneClear", "LaneClear")
XayahMenu.LaneClear:KeyBinding("laneclearKey", "LaneClear Key", string.byte("V"))
XayahMenu.LaneClear:Boolean("Q", "Use Q", true)
XayahMenu.LaneClear:Boolean("W", "Use W", true)
XayahMenu.LaneClear:Boolean("E", "Use E", true)

XayahMenu:Menu("Misc", "Misc")
XayahMenu.Misc:Boolean("Ignite", "Use Ignite", true)

XayahMenu:Menu("KS", "KS")
XayahMenu.KS:Boolean("Q", "Use Q", true)
XayahMenu.KS:Boolean("W", "Use W", true)
XayahMenu.KS:Boolean("E", "Use E", true)
XayahMenu.KS:Boolean("R", "Use R", true)

OnTick(function(myHero)

		local target = GetCurrentTarget()
		
		if KeyIsDown(XayahMenu.Combo.comboKey:Key()) then
		
		
			if XayahMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1075) then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1075,2000,0.25,75,false,false)
			if QPred.HitChance == 1 then
			CastSkillShot(_Q,QPred.PredPos)
			end
			end	
			
			if XayahMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 1000) then
			CastSpell(_W)
			end
			
			if XayahMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 1075) then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1075,2000,0,75,false,false)
			if EPred.HitChance == 1 then
			CastSpell(_E)
			end
			end
			
			if XayahMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 1040) and GetCurrentHP(enemy) < getdmg("R",enemy ,myHero) then
			local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1040,2000,0.50,150,false,false)
			if RPred.HitChance == 1 then
			CastSpell(_R)
			end
			end
			
		end
	end)
			
			
			
			
			
			
			
			
		
