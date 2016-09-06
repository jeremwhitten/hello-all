if GetObjectName(GetMyHero()) ~= "Gnar" then return end
require("MapPositionGOS")

local GnarMenu = Menu("Gnar", "Gnar")
GnarMenu:SubMenu("Combo", "Combo")
GnarMenu.Combo:KeyBinding("comboKey", "Combo Key", 32)
GnarMenu.Combo:Boolean("Q", "Use Q", true)
GnarMenu.Combo:Boolean("W", "Use W", true)
GnarMenu.Combo:Boolean("E", "Use E", true)
GnarMenu.Combo:Boolean("R", "Use R", true)

GnarMenu:Menu("LaneClear", "LaneClear")
GnarMenu.LaneClear:KeyBinding("laneclearKey", "LaneClear Key", string.byte("V"))
GnarMenu.LaneClear:Boolean("Q", "Use Q", true)


OnTick(function (myHero)

local target = GetCurrentTarget()

if KeyIsDown(GnarMenu.Combo.comboKey:Key()) then

	if GnarMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1100) then
		if GetCastName(myHero,_Q) == "GnarQ" and GotBuff(myHero, "gnartransformsoon") == 0 then
		 local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1400,100,1100,90,false,true)
		 if QPred.HitChance == 1 then
		 CastSkillShot(_Q,QPred.PredPos)
		 end
		end
	end
		
	if GnarMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1100) then
		if GetCastName(myHero,_Q) == "gnarbigq" and GotBuff(myHero, "gnartransform") == 1 then
		 local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),2100,100,1100,90,true,true)
		 if QPred.HitChance == 1 then
		 CastSkillShot(_Q,QPred.PredPos)
		 end
		end	
	end
		
		
	if GnarMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 525) then
		if GetCastName(myHero,_W) == "gnarbigw" and GotBuff(myHero, "gnartransform") == 1 then
		 local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),600,250,525,90,false,true)
		 if WPred.HitChance == 1 then
		 CastSkillShot(_W,WPred.PredPos)
		 end
		end	
	end
	
	if GnarMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 500) then
		if GetCastName(myHero,_W) == "GnarE" and GotBuff(myHero, "gnartransformsoon") == 1 then
		 local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1500,100,500,120,false,false)
		 if EPred.HitChance == 1 then
		 CastSkillShot(_E,EPred.PredPos)
		 end
		end	
	end
	
	if GnarMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 500) then
		if GetCastName(myHero,_W) == "gnarbige" and GotBuff(myHero, "gnartransform") == 1 then
		 local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1500,100,500,475,false,false)
		 if EPred.HitChance == 1 then
		 CastSkillShot(_E,EPred.PredPos)
		 end
		end	
	end
	
	for _,unit in pairs(GetEnemyHeroes()) do
		local distance=590 - GetDistance(myHero,unit)
		local RPred = GetPredictionForPlayer(GetOrigin(myHero),unit,GetMoveSpeed(unit),3000,0,590,590,false,true)
        local PredPos = Vector(RPred.PredPos)
        local HeroPos = Vector(myHero)
        local maxRRange = PredPos - (PredPos - HeroPos) * ( - distance / GetDistance(RPred.PredPos))
		
		if MapPosition:inWall(Pos) and Ready(_R) and ValidTarget(target,590) and GetDistance(myHero,unit) <= 590 then
		CastSkillShot(_R,RPred.PredPos)
		end
	end
	
 end
 
end)

print ("Loaded") 
	
