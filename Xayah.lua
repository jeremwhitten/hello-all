if GetObjectName(GetMyHero()) ~= "Xayah" then return end

require("OpenPredict")
require("DamageLib")

local XayahQ = {range = 1075, speed = 2000, delay = 0.25, width = 75, collision = false}
local XayahW = {range = 1000, delay = 0.25}
local XayahE = {range = 1075, speed = 2000, delay = 0.00, width = 75, collision = false}
local XayahR = {range = 1040, speed = 2000, delay = 0.50, angle = 150, collision = false, aoe = true}

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
			local Qpred = GetPrediction(target, XayahQ)
			if Qpred.hitChance == 0.25 then
			CastSkillShot(_Q,Qpred.castPos)
			end
			end	
			
			if XayahMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 1000) then
			CastSpell(_W)
			end
			
			if XayahMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 1075) then
			local Epred = GetPrediction(target, XayahE)
			if Epred.hitChance == 0.25 then
			CastSpell(_E)
			end
			end
			
			if XayahMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 1040) then
			local RPred = GetPrediction(target, XayahR)
			if Rpred.hitChance == 0.25 then
			CastSkillShot(_R,Rpred.castPos)
			end
			end
			
		end
	end)
			
			
			
			
			
			
			
			
		
