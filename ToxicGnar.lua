if GetObjectName(GetMyHero()) ~= "Gnar" then return end

	local v = 1.0
	
	GetWebResultAsync("https://raw.githubusercontent.com/jeremwhitten/hello-all/master/ToxicGnar.version", function(num)
	if v < tonumber(num) then
		PrintChat("[ToxicGnar] Update Available. x2 f6 to Update.")
		DownloadFileAsync("https://raw.githubusercontent.com/jeremwhitten/hello-all/master/ToxicGnar.lua", SCRIPT_PATH .. "ToxicGnar.lua", function() PrintChat("Have fun!") return end)
	end
	end)
	
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
GnarMenu.LaneClear:Boolean("W", "Use W", true)

GnarMenu:Menu("Misc", "Misc")
GnarMenu.Misc:Boolean("Ignite", "Use Ignite", true)

GnarMenu:Menu("KS", "KS")
GnarMenu.KS:Boolean("Q", "Use Q", true)
GnarMenu.KS:Boolean("W", "Use W", true)
GnarMenu.KS:Boolean("E", "Use E", true)
GnarMenu.KS:Boolean("R", "Use R", true)





OnTick(function (myHero)

	local target = GetCurrentTarget()
	local MiniGnar = (GotBuff(myHero, "gnartransform") == 0 or GotBuff(myHero, "gnarfuryhigh") == 1)
	local MegaGnar = (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1)
	local miniQDMG = -30 + 30 * GetCastLevel(myHero, _Q) + myHero.totalDamage * 1.15
	local MegaQDMG = -35 + 40 * GetCastLevel(myHero, _Q) + myHero.totalDamage * 1.2
	local MegaWDMG = 5 + 20 * GetCastLevel(myHero, _W) + myHero.totalDamage
	local EDMG = -20 + 40 * GetCastLevel(myHero, _E) + GetMaxHP(myHero) * 0.06
	local RDMG = 100 + 100 * GetCastLevel(myHero, _R) + GetBonusDmg(myHero) * 0.2 + GetBonusAP(myHero) * 0.5
	
	
	if KeyIsDown(GnarMenu.Combo.comboKey:Key()) then
	
	
	
		if GnarMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 470) then
			if GetCastName(myHero,_E) == "GnarBigE" and MegaGnar then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1500,100,500,475,false,false)
			if EPred.HitChance == 1 then
			CastSkillShot(_E,EPred.PredPos)
			end
			end	
		end
	
		if GnarMenu.Combo.R:Value() then
			CastR()
			end
		

		if GnarMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1100) then
			if GetCastName(myHero,_Q) == "GnarQ" and MiniGnar then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1400,100,1100,90,false,true)
			if QPred.HitChance == 1 then
			CastSkillShot(_Q,QPred.PredPos)
			end
			end
		end
		
		if GnarMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1100) then
			if GetCastName(myHero,_Q) == "GnarBigQ" and MegaGnar then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),2100,100,1100,90,true,true)
			if QPred.HitChance == 1 then
			CastSkillShot(_Q,QPred.PredPos)
			end
			end	
		end
		
		
		if GnarMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 525) then
			if GetCastName(myHero,_W) == "GnarBigW" and MegaGnar then
			local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),600,250,525,90,false,true)
			if WPred.HitChance == 1 then
			CastSkillShot(_W,WPred.PredPos)
			end
			end	
		end
	
	
	
		if GnarMenu.Combo.R:Value() then
		CastR()
		end
	end
	
	
	
	
	function CastR()
	
		for _,unit in pairs(GetEnemyHeroes()) do
			local distance= 590 - GetDistance(myHero,unit)
			local RPred = GetPredictionForPlayer(GetOrigin(myHero),unit,GetMoveSpeed(unit),3000,0,590,590,false,true)
			local PredPos = Vector(RPred.PredPos)
			local HeroPos = Vector(myHero)
			local maxRRange = PredPos - (PredPos - HeroPos) * ( - distance / GetDistance(RPred.PredPos))
			local shootLine = LineSegment(Point(PredPos.x, PredPos.y, PredPos.z), Point(maxRRange.x, maxRRange.y, maxRRange.z))
		
		
		for i, Pos in pairs(shootLine:__getPoints()) do
		
			if MapPosition:inWall(Pos) and Ready(_R) and ValidTarget(target,590) and GetDistance(myHero,unit) <= 590 then
			CastSkillShot(_R,RPred.PredPos)
			end
		end
		end
	
	end
	
	
		
	
 for i,mobs in pairs(minionManager.objects) do
		if KeyIsDown(GnarMenu.LaneClear.laneclearKey:Key()) then
			if GnarMenu.LaneClear.W:Value() and ValidTarget(mobs,400)then
			CastSkillShot(_W,mobs)
			end
			
			if GnarMenu.LaneClear.Q:Value() and ValidTarget(mobs,1100)then
			CastSkillShot(_Q,mobs)
			end
			end
			
		end
		
	function Ignite()
		for _, G in pairs(GetEnemyHeroes()) do
		if ValidTarget(G, 700) and Ignite and GnarMenu.Misc.Ignite:Value() and CanUseSpell(myHero,_Q) ~= READY and GetDistance(G) > 400 then 
				if CanUseSpell(GetMyHero(), Ignite) == READY and (20*GetLevel(GetMyHero())+50) > GetCurrentHP(G)+GetHPRegen(G)*2.5 and GetDistanceSqr(GetOrigin(G)) < 600*600 then
                CastTargetSpell(G, Ignite)
				end
			end
		end
	end
	
	
	
	for _,enemy in pairs(GetEnemyHeroes()) do
		if GnarMenu.KS.Q:Value() and Ready(_Q) and ValidTarget(enemy) and GetCastName(myHero, _Q) == "GnarQ" and MiniGnar then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, miniQDMG, 0) then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1400,100,1100,90,false,true)
				if QPred.HitChance == 1 then
				CastSkillShot(_Q,QPred.PredPos)
				end
			end
		end
		
		
		if GnarMenu.KS.Q:Value() and Ready(_Q) and ValidTarget(enemy) and GetCastName(myHero, _Q) == "GnarBigQ" and MegaGnar then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, MegaQDMG, 0) then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),2100,100,1100,90,true,true)
				if QPred.HitChance == 1 then
				CastSkillShot(_Q,QPred.PredPos)
				end
			end
		end
		
		
		if GnarMenu.KS.W:Value() and Ready(_W) and ValidTarget(enemy) and GetCastName(myHero, _W) == "GnarBigW" and MegaGnar then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, MegaWDMG, 0) then
			local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),600,250,525,90,false,true)
				if WPred.HitChance == 1 then
				CastSkillShot(_W,WPred.PredPos)
				end
			end
		end
		
		if GnarMenu.KS.E:Value() and Ready(_E) and ValidTarget(enemy) and GetCastName(myHero, _E) == "GnarBigE" and MegaGnar then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, MegaEDMG, 0) then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1500,100,500,475,false,false)
				if EPred.HitChance == 1 then
				CastSkillShot(_E,EPred.PredPos)
				end
			end
		end
		
		if GnarMenu.KS.E:Value() and Ready(_E) and ValidTarget(enemy) and GetCastName(myHero, _E) == "GnarE" and MiniGnar then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, MegaEDMG, 0) then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1500,100,500,475,false,false)
				if EPred.HitChance == 1 then
				CastSkillShot(_E,EPred.PredPos)
				end
			end
		end
		
	end
	
	
	
	
		
		
				
		
	
		
		
	
	
	
	
	
 
end)

print ("Toxic Gnar Loaded <3") 
	
