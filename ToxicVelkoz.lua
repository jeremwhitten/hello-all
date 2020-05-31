local Heroes = {"Velkoz"}

if not table.contains(Heroes, myHero.charName) then return end




require('DamageLib')

if not FileExist(COMMON_PATH .. "GamsteronPrediction.lua") then
	print("GsoPred. installed Press 2x F6")
	DownloadFileAsync("https://raw.githubusercontent.com/gamsteron/GOS-EXT/master/Common/GamsteronPrediction.lua", COMMON_PATH .. "GamsteronPrediction.lua", function() end)
	while not FileExist(COMMON_PATH .. "GamsteronPrediction.lua") do end
end
    
require('GamsteronPrediction')
require "Collision"
require "2DGeometry"








local TEAM_ALLY = myHero.team
local TEAM_ENEMY = 300 - myHero.team
local TEAM_JUNGLE = 300
local Orb
local Allies, Enemies, Turrets, Units = {}, {}, {}, {}
local TableInsert = table.insert
local ControlIsKeyDown, ControlKeyDown, ControlKeyUp, ControlSetCursorPos, DrawCircle, DrawLine, DrawRect, DrawText, GameCanUseSpell, GameLatency, GameTimer, GameHero, GameMinion, GameTurret =
	Control.IsKeyDown, Control.KeyDown, Control.KeyUp, Control.SetCursorPos, Draw.Circle, Draw.Line, Draw.Rect, Draw.Text, Game.CanUseSpell, Game.Latency, Game.Timer, Game.Hero, Game.Minion, Game.Turret
local qPointsUpdatedAt = Game.Timer()
local qHitPoints
local qMissile
local qAngles = {0, -15, 15, -30, 30, -45, 45, -60, 60}
local qLastChecked = 1
local qResults = {}

function LoadUnits()
	for i = 1, Game.HeroCount() do
		local unit = Game.Hero(i); Units[i] = {unit = unit, spell = nil}
		if unit.team ~= myHero.team then TableInsert(Enemies, unit)
		elseif unit.team == myHero.team and unit ~= myHero then TableInsert(Allies, unit) end
	end
	for i = 1, Game.TurretCount() do
		local turret = Game.Turret(i)
		if turret and turret.isEnemy then TableInsert(Turrets, turret) end
	end
end

local function EnemyHeroes()
	return Enemies
end

local function Ready(spell)
    return myHero:GetSpellData(spell).currentCd == 0 and myHero:GetSpellData(spell).level > 0 and myHero:GetSpellData(spell).mana <= myHero.mana and Game.CanUseSpell(spell) == 0
end

local function IsValid(unit)
    if (unit and unit.valid and unit.isTargetable and unit.alive and unit.visible and unit.networkID and unit.pathing and unit.health > 0) then
        return true;
    end
    return false;
end

local function IsRecalling(unit)
    for i = 0, unit.buffCount do
        local buff = unit:GetBuff(i)
        if buff and buff.name == 'recall' and buff.duration > 0 then
            return true, Game.Timer() - buff.startTime
        end
    end
    return false
end

local function MyHeroNotReady()
    return myHero.dead or Game.IsChatOpen() or (_G.JustEvade and _G.JustEvade:Evading()) or (_G.ExtLibEvade and _G.ExtLibEvade.Evading) or IsRecalling(myHero)
end

local function GetTarget(range) 
	if Orb == 1 then
		if myHero.ap > myHero.totalDamage then
			return EOW:GetTarget(range, EOW.ap_dec, myHero.pos)
		else
			return EOW:GetTarget(range, EOW.ad_dec, myHero.pos)
		end
	elseif Orb == 2 and SDK.TargetSelector then
		if myHero.ap > myHero.totalDamage then
			return SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_MAGICAL)
		else
			return SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		end
	elseif _G.GOS then
		if myHero.ap > myHero.totalDamage then
			return GOS:GetTarget(range, "AP")
		else
			return GOS:GetTarget(range, "AD")
        end
    elseif _G.gsoSDK then
		return _G.gsoSDK.TS:GetTarget()
	end
end

local function GetMode()
    
    if Orb == 1 then
        if combo == 1 then
            return 'Combo'
         end     
    elseif Orb == 2 then
		if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
			return "Combo"
		end
    elseif Orb == 3 then
        return GOS:GetMode()
    elseif Orb == 4 then
        return _G.gsoSDK.Orbwalker:GetMode()
    end
end





local function GetDistanceSqr(p1, p2)
	if not p1 then return math.huge end
	p2 = p2 or myHero
	local dx = p1.x - p2.x
	local dz = (p1.z or p1.y) - (p2.z or p2.y)
	return dx*dx + dz*dz
end

local function GetDistance(p1, p2)
	p2 = p2 or myHero
	return math.sqrt(GetDistanceSqr(p1, p2))
end

local function GetMinionCount(range, pos)
    local pos = pos.pos
	local count = 0
	for i = 1,Game.MinionCount() do
	local hero = Game.Minion(i)
	local Range = range * range
		if hero.team ~= TEAM_ALLY and hero.dead == false and GetDistanceSqr(pos, hero.pos) < Range then
		count = count + 1
		end
	end
	return count
end
	
local function HasBuff(unit, buffname)
    for i = 0, unit.buffCount do
        local buff = unit:GetBuff(i)
        if buff.name == buffname and buff.count > 0 then 
            return true
        end
    end
    return false
end

local function UndyingBuffs(unit)
    if HasBuff(unit, 'JudicatorIntervention') then
        return true
    end
    if HasBuff(unit, 'TaricR') then
        return true
    end
    if HasBuff(unit, 'kindredrnodeathbuff') then
        return true
    end
    if HasBuff(unit, 'ChronoShift') or HasBuff(unit, 'chronorevive') then
        return true
    end
    if HasBuff(unit, 'UndyingRage') then
        return true
    end
    if HasBuff(unit,'JaxCounterStrike') then
        return true
    end
    if HasBuff(unit, 'FioraW') then
        return true
    end
    if HasBuff(unit, 'aatroxpassivedeath') then
        return true
    end
    if HasBuff(unit, 'VladimirSanguinePool') then
        return true
    end
    if HasBuff(unit, 'KogMawIcathianSurprise') then
        return true
    end
    if HasBuff(unit, 'KarthusDeathDefiedBuff') then
        return true
    end
    return false
end


class "Velkoz"

function Velkoz:__init()	
	self:LoadMenu()                                            
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end) 
	
	if _G.EOWLoaded then
		Orb = 1
	elseif _G.SDK and _G.SDK.Orbwalker then
		Orb = 2
	elseif _G.GOS then
		Orb = 3
	elseif _G.gsoSDK then
		Orb = 4
	end	
end

--- Tutorial Collision Check ---
-- Collision = true or false ///// if the spell can blocked by minion then Collision = true //// if not then Collision = false 
-- MaxCollision = 0 <----- this check how many minions can hit with Collision = true //// example Lux Q can hit 1 minion + 1 target 
-- CollisionTypes = {_G.COLLISION_MINION}   < ----- this check wich type you will check for Collision,,,, 

local QData =
{
Type = _G.SPELLTYPE_LINE, Delay = 0.251, Radius = 55, Range = 1050, Speed = 1235, Collision = true, MaxCollision = 0, CollisionTypes = {_G.COLLISION_MINION}
}

local WData =
{
Type = _G.SPELLTYPE_LINE, Delay = 0.25, Radius = 80, Range = 1050, Speed = 1500, Collision = false
}

local EData =
{
Type = _G.SPELLTYPE_CIRCLE, Delay = 0.75, Radius = 235, Range = 850, Speed = math.huge, Collision = false
}

local RData =
{
Type = _G.SPELLTYPE_LINE, Delay = 0.25, Radius = 75, Range = 1550, Speed = math.huge, Collision = false
}

function Velkoz:LoadMenu()                     
	
--MainMenu
self.Menu = MenuElement({type = MENU, id = "Velkoz", name = "Velkoz Beta.04"})
		
--ComboMenu  
self.Menu:MenuElement({type = MENU, id = "Combo", name = "Combo Mode"})
	self.Menu.Combo:MenuElement({id = "UseQ", name = "[Q]", value = true})
	self.Menu.Combo:MenuElement({id = "UseW", name = "[W]", value = true})
	self.Menu.Combo:MenuElement({id = "UseE", name = "[E]", value = true})
	self.Menu.Combo:MenuElement({id = "UseR", name = "[R]", value = true})
	

self.Menu:MenuElement({type = MENU, id = "KS", name = "KillSteal Mode"})
	self.Menu.KS:MenuElement({id = "UseR", name = "[R]", value = true})	

--LaneClear
self.Menu:MenuElement({type = MENU, id = "LaneClear", name = "LaneClear Mode"})
	self.Menu.LaneClear:MenuElement({id = "UseQ", name = "[Q]", value = true})
	self.Menu.LaneClear:MenuElement({id = "UseW", name = "[W]", value = true})
	self.Menu.LaneClear:MenuElement({id = "UseE", name = "[E]", value = true})	
		
--Prediction
self.Menu:MenuElement({type = MENU, id = "Pred", name = "Prediction"})
	self.Menu.Pred:MenuElement({id = "PredQ", name = "Hitchance[Q]", value = 1, drop = {"Normal", "High", "Immobile"}})
	self.Menu.Pred:MenuElement({id = "PredW", name = "Hitchance[W]", value = 1, drop = {"Normal", "High", "Immobile"}})
	self.Menu.Pred:MenuElement({id = "PredE", name = "Hitchance[E]", value = 1, drop = {"Normal", "High", "Immobile"}})
	self.Menu.Pred:MenuElement({id = "PredR", name = "Hitchance[R]", value = 1, drop = {"Normal", "High", "Immobile"}})	
	
--Drawing 
self.Menu:MenuElement({type = MENU, id = "Drawing", name = "Drawings Mode"})
	self.Menu.Drawing:MenuElement({id = "DrawQ", name = "Draw [Q] Range", value = true})	
end

function Velkoz:Tick()
if MyHeroNotReady() then return end

local Mode = GetMode()
	if Mode == "Combo" then
		self:Combo()  	
	end
	self:KSUlt()
end
 
function Velkoz:Draw()
  if myHero.dead then return end
                                                 
	if self.Menu.Drawing.DrawQ:Value() and Ready(_Q) then
    Draw.Circle(myHero, 1050, 1, Draw.Color(225, 225, 0, 10))
	end
	local textPos = myHero.dir	
	if not FileExist(COMMON_PATH .. "GamsteronPrediction.lua") then
		Draw.Text("GsoPred. installed Press 2x F6", 50, textPos.x + 100, textPos.y - 250, Draw.Color(255, 255, 0, 0))
	end			
end

local Q1 = Collision:SetSpell(1100, 800, .25, 125, true)
local qb = 0;
local sPos = 0;


Callback.Add("Draw", function() Draw2() end);
local function IsReady(slot)
	return myHero:GetSpellData(slot).currentCd == 0 and myHero:GetSpellData(slot).level > 0
end
-- 2Lazy2Merge
local function VectorExtendA(v,t,d)
	return v + d * (t-v):Perpendicular2():Normalized() 
end
local function VectorExtendB(v,t,d)
	return v + d * (t-v):Perpendicular():Normalized() 
end

local function GetBall()
	if qb ~= 0 then qb = 0; sPos = 0; end
	for i=1,Game.MissileCount() do
		local o = Game.Missile(i);
		if o.missileData.name == "VelkozQMissile" then
			sPos = o.missileData.startPos;
			qb = o;
		end
	end
end

function Draw2() 
	local p = GOS:GetTarget(1100, "AP");
	GetBall();
	if p and GOS:GetMode() == "Combo" then
		local pp = p:GetPrediction(1100,.25);
		local block, list = Q1:__GetCollision(myHero, pp, 5);
		if not block then
			if IsReady(_Q) and myHero:GetSpellData(slot).name == "VelkozQ" then
				Control.CastSpell(HK_Q, pp);
			end
			else
			if IsReady(_Q) then
				Q2(pp);
			end
		end
	end
end

function Q2(pr)
	for i= -math.pi*.5 ,math.pi*.5 ,math.pi*.09 do
		local one = 25.79618 * math.pi/180
		local an = myHero.pos + Vector(Vector(pr)-myHero.pos):Rotated(0, i*one, 0);
		local block, list = Q1:__GetCollision(myHero, an, 5);
		if not block then
			--Draw.Circle(an); Debug for pos
			if myHero:GetSpellData(slot).name == "VelkozQ" then
				Control.CastSpell(HK_Q, an);
				else
				if qb ~= 0 then
					local TA = VectorExtendA(Vector(qb.pos.x, qb.pos.y,qb.pos.z), sPos, 1100);
					local TB = VectorExtendB(Vector(qb.pos.x, qb.pos.y,qb.pos.z), sPos, 1100);
					local TC = Line(Point(TA), Point(TB));
					if TC:__distance(Point(pr)) < 200 then
						Control.CastSpell(HK_Q);
					end
				end
			end
		end
	end
end

-- Ult KillSteal --
-- function Velkoz:KSUlt()
-- local target = GetTarget(2200)     	
-- if target == nil then return end
	-- if IsValid(target) then
		-- local Rdmg = getdmg("R", target, myHero) -- Dmg data from DamageLib
		-- if myHero.pos:DistanceTo(target.pos) < 1550 and self.Menu.KS.UseR:Value() and Ready(_R) then
			-- local pred = GetGamsteronPrediction(target, RData, myHero)
			-- if target.health < Rdmg and pred.Hitchance >= self.Menu.Pred.PredR:Value() + 1 then  --- target.health < Rdmg ,,,, check target and dmg
				-- Control.CastSpell(HK_R, pred.CastPosition)
			-- end
		-- end
	-- end
-- end


function Velkoz:Combo()
local target = GetTarget(1050)     	
if target == nil then return end
	if IsValid(target) then
		
		
		
		if myHero.pos:DistanceTo(target.pos) <= 1050 and self.Menu.Combo.UseW:Value() and Ready(_W) then
		    local pred = GetGamsteronPrediction(target, WData, myHero)
			if pred.Hitchance >= self.Menu.Pred.PredW:Value() + 1 and not myHero.pathing.isDashing then
				Control.CastSpell(HK_W, pred.CastPosition)
				
		   end
		end 

		if myHero.pos:DistanceTo(target.pos) <= 850 and self.Menu.Combo.UseE:Value() and Ready(_E) then
			local pred = GetGamsteronPrediction(target, EData, myHero)
			if pred.Hitchance >= self.Menu.Pred.PredQ:Value() + 1 and not myHero.pathing.isDashing then
				Control.CastSpell(HK_E, pred.CastPosition)
			end
		end
		
		local Rdmg = getdmg("R", target, myHero)
			if myHero.pos:DistanceTo(target.pos) <= 2200 and self.Menu.Combo.UseR:Value() and Ready(_R) then
		local pred = GetGamsteronPrediction(target, RData, myHero)
				if target.health < Rdmg and pred.Hitchance >= self.Menu.Combo.UseR:Value() + 1 then
				Control.CastSpell(HK_R, pred.CastPosition)
			end
				end
	
end

function Velkoz:DetonateQ()
	if Game.Timer() - qPointsUpdatedAt < .25 and self:IsQActive() and qHitPoints then
		for i = 1, #qHitPoints do		
			if qHitPoints[i] then
				if qHitPoints[i].playerHit and Menu.Skills.Q.Targets[qHitPoints[i].playerHit.charName] and Menu.Skills.Q.Targets[qHitPoints[i].playerHit.charName]:Value()then					
					Control.CastSpell(HK_Q)
				end
			end
		end
	end	
end

function Velkoz:UpdateQInfo()

	if self:IsQActive() then	
		local directionVector = Vector(qMissile.missileData.endPos.x - qMissile.missileData.startPos.x,qMissile.missileData.endPos.y - qMissile.missileData.startPos.y,qMissile.missileData.endPos.z - qMissile.missileData.startPos.z):Normalized()										
		local checkInterval = Menu.General.CheckInterval:Value()
		local pointCount = 600 / checkInterval * 2
		qHitPoints = {}
		
		for i = 1, pointCount, 2 do
			local result =  self:CalculateNode(qMissile,  qMissile.pos + directionVector:Perpendicular() * i * checkInterval)			
			qHitPoints[i] = result
			if result.collision then
				break
			end
		end
				
		for i = 2, pointCount, 2 do		
			local result =  self:CalculateNode(qMissile,  qMissile.pos + directionVector:Perpendicular2() * i * checkInterval)			
			qHitPoints[i] = result	
			if result.collision then
				break
			end
		end		
		qPointsUpdatedAt = Game.Timer()
		
	end
end

function Velkoz:IsQActive()
	return qMissile and qMissile.name and qMissile.name == "VelkozQMissile"
end

-- SERIES I FUCKING LOVE YOU. 
function Velkoz:IsRActive(target)
    if myHero.activeSpell and myHero.activeSpell.valid and myHero.activeSpell.name == "VelkozR" then
        SetMovement(false)
        Control.SetCursorPos(target.pos)
    else
        SetMovement(true)
    end
end
	

function OnLoad()
	if table.contains(Heroes, myHero.charName) then
		_G[myHero.charName]()
		LoadUnits()
	end
end
