local Heroes = {"Senna"}

if not table.contains(Heroes, myHero.charName) then return end

require('DamageLib')

if not FileExist(COMMON_PATH .. "GamsteronPrediction.lua") then
	print("GsoPred. installed Press 2x F6")
	DownloadFileAsync("https://raw.githubusercontent.com/gamsteron/GOS-EXT/master/Common/GamsteronPrediction.lua", COMMON_PATH .. "GamsteronPrediction.lua", function() end)
	while not FileExist(COMMON_PATH .. "GamsteronPrediction.lua") do end
end
    
require('GGPrediction')
require "Collision"
require "2DGeometry"

local GameHeroCount = Game.HeroCount
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
local ping = Game.Latency()/1000
local table_insert = table.insert

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

local function GetDistanceSquared(vec1, vec2)
    local dx = vec1.x - vec2.x
    local dy = (vec1.z or vec1.y) - (vec2.z or vec2.y)
    return dx * dx + dy * dy
end

local function GetDistanceSqr(p1, p2)
	if not p1 then return math.huge end
	p2 = p2 or myHero
	local dx = p1.x - p2.x
	local dz = (p1.z or p1.y) - (p2.z or p2.y)
	return dx*dx + dz*dz
end

local function GetAllyHeroes()
	local _AllyHeroes = {}
	for i = 1, GameHeroCount() do
		local unit = GameHero(i)
		if unit.isAlly and not unit.isMe then
			TableInsert(_AllyHeroes, unit)
		end
	end
	return _AllyHeroes
end

local function GetDistance(p1, p2)
	p2 = p2 or myHero
	return math.sqrt(GetDistanceSqr(p1, p2))
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

local function CastSpellMM(spell,pos,range,delay)
local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
	local range = range or math.huge
	local delay = delay or 250
	local ticker = GetTickCount()
	if castSpell.state == 0 and GetDistance(myHero.pos,pos) < range and ticker - castSpell.casting > delay + Game.Latency() then
		castSpell.state = 1
		castSpell.mouse = mousePos
		castSpell.tick = ticker
	end
	if castSpell.state == 1 then
		if ticker - castSpell.tick < Game.Latency() then
			local castPosMM = pos:ToMM()
			Control.SetCursorPos(castPosMM.x,castPosMM.y)
			Control.KeyDown(spell)
			Control.KeyUp(spell)
			castSpell.casting = ticker + delay
			DelayAction(function()
				if castSpell.state == 1 then
					Control.SetCursorPos(castSpell.mouse)
					castSpell.state = 0
				end
			end,Game.Latency()/1000)
		end
		if ticker - castSpell.casting > Game.Latency() then
			Control.SetCursorPos(castSpell.mouse)
			castSpell.state = 0
		end
	end
end

local function GetAllysInRange(range, position)
    local position = position or myHero.pos
    local allys = {}
    local allysTable = GetAllyHeroes()
    for i = 1, #allysTable do
        local obj = allysTable[i]
        if IsValid(obj) and GetDistanceSquared(obj.pos, position) < range * range then
            table_insert(allys,obj)
        end
    end

    return allys
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

class "Senna"

function Senna:__init()	
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


	local QPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.4, Radius = 50, Range = 1300, Speed = math.huge, Collision = nil, MaxCollision = 0, CollisionTypes = false})
   -- local WPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.25, Radius = 60, Range = 1100, Speed = 1000, Collision = true, CollisionTypes = true})
    --local RPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 1, Radius = 80, Range = math.huge, Speed = 20000})
function Senna:LoadMenu()                     	
--MainMenu
self.Menu = MenuElement({type = MENU, id = "Senna", name = "Senna Beta.01", leftIcon = HeroIcon})		
--ComboMenu  
self.Menu:MenuElement({type = MENU, id = "Combo", name = "Combo Mode"})
	self.Menu.Combo:MenuElement({id = "UseQ", name = "[Q]",value = true})
	self.Menu.Combo:MenuElement({id = "UseW", name = "[W]",value = true})
	self.Menu.Combo:MenuElement({id = "UseR", name = "[R]",value = true})

self.Menu:MenuElement({type = MENU, id = "KS", name = "KillSteal Mode"})
	self.Menu.KS:MenuElement({id = "UseR", name = "[R]", value = true})	
--LaneClear
self.Menu:MenuElement({type = MENU, id = "LaneClear", name = "LaneClear Mode"})
	self.Menu.LaneClear:MenuElement({id = "UseQ", name = "[Q]", leftIcon = QIcon, value = true})		
--Prediction
self.Menu:MenuElement({type = MENU, id = "Pred", name = "Prediction"})
	self.Menu.Pred:MenuElement({id = "PredQ", name = "Hitchance[Q]", value = 1, drop = {"Normal", "High", "Immobile"}})
	self.Menu.Pred:MenuElement({id = "PredW", name = "Hitchance[W]", value = 1, drop = {"Normal", "High", "Immobile"}})
	self.Menu.Pred:MenuElement({id = "PredR", name = "Hitchance[R]", value = 1, drop = {"Normal", "High", "Immobile"}})		
--Drawing 
	self.Menu:MenuElement({type = MENU, id = "Drawing", name = "Drawings Mode"})
	self.Menu.Drawing:MenuElement({id = "DrawQ", name = "Draw [Q] Range", value = true})
	self.Menu.Drawing:MenuElement({id = "DrawW", name = "Draw [W] Range", value = true})
	self.Menu.Drawing:MenuElement({id = "DrawR", name = "Draw [R] Range", value = true})
	self.Menu.Drawing:MenuElement({id = "Killable", name = "DrawTargetKill", value = true})
end

function Senna:Tick()
if MyHeroNotReady() then return end
KSUlt()
AutoHeal()

local Mode = GetMode()
	if Mode == "Combo" then
		self:Combo()  	
	end	
end
 
function Senna:Draw()
  if myHero.dead then return end
                                                 
	if self.Menu.Drawing.DrawQ:Value() then
    Draw.Circle(myHero, 1100, 1, Draw.Color(225, 225, 0, 10))
	end


	if self.Menu.Drawing.DrawR:Value() then
    Draw.Circle(myHero, 800, 1, Draw.Color(225, 0, 255, 10))
	end

	local textPos = myHero.dir	
	if not FileExist(COMMON_PATH .. "GamsteronPrediction.lua") then
		Draw.Text("GsoPred. installed Press 2x F6", 50, textPos.x + 100, textPos.y - 250, Draw.Color(255, 255, 0, 0))
	end	
	
	local target = GetTarget(6000)
	if target == nil then return end 
	
        if self.Menu.Drawing.Killable:Value() and IsValid(target) then
			local QDmg = getdmg("Q", target, myHero)
			local WDmg = getdmg("W", target, myHero)
			local RDmg = getdmg("R", target, myHero)
			local Dmg = QDmg + WDmg + RDmg
		--print(Dmg)
			local hp = (target.health)
            if Ready(_R)and Dmg > hp then
			local screenPos = target.pos:To2D()
                Draw.Text("Killable", 28, screenPos.x - 30, screenPos.y, Draw.Color(255, 255, 0, 0))
            end
			else
				Draw.Text("Harass", 28, screenPos.x - 30, screenPos.y, Draw.Color(255, 255, 0, 0))
		 end
end

function AutoHeal()
    if Ready(_Q) then
        local allys = GetAllysInRange(1200)
        for i = 1, #allys do 
            local ally = allys[i]
            local percetHealth = ally.health / ally.maxHealth*100
            if ally ~= myHero and percetHealth <= 50 then
                Control.CastSpell(HK_Q, ally.pos)
            end
		end
    end
end

-- Ult KillSteal --
 function KSUlt()
 local target = GetTarget(20000)     	
if target == nil then return end
	 if IsValid(target) then
		 local Rdmg = getdmg("R", target, myHero) -- Dmg data from DamageLib
		 if myHero.pos:DistanceTo(target.pos) <= 100000 and Ready(_R) then
			 if target.health < Rdmg then
			 if target.pos2D.onScreen then 		
							CastGGPred(HK_R, target) 							
						else	   
							CastSpellMM(HK_R, target.pos, 20000, 1)
						end
				 CastGGPred(HK_R, target)
			 end
		 end
	 end
 end

function Senna:Combo()
local target = GetTarget(1300)     	
if target == nil then return end
	if IsValid(target) then
		if myHero.pos:DistanceTo(target.pos) <= 1300 and self.Menu.Combo.UseW:Value() and Ready(_W) then
				CastGGPred(HK_W, target)	
		end
		 
		if myHero.pos:DistanceTo(target.pos) <= 1100 and self.Menu.Combo.UseQ:Value() and Ready(_Q) then
				Control.CastSpell(HK_Q, target)		
		end 
	end	
end

function CastGGPred(spell, unit)
	if Ready(_W) then
		local WPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.25, Radius = 60, Range = 1100, Speed = 1000, Collision = true, CollisionTypes = COLLISION_MINION})
		WPrediction:GetPrediction(unit, myHero)
		if WPrediction:CanHit(1) then
			Control.CastSpell(HK_W, WPrediction.CastPosition)
		end	
	
	else
		if Ready(_R) then
			local RPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.5, Radius = 80, Range = 100000, Speed = 20000, Collision = false})
			RPrediction:GetPrediction(unit, myHero)
			if RPrediction:CanHit(1) then
				Control.CastSpell(HK_R, RPrediction.CastPosition)
			end	
		end	
	end
end

function OnLoad()
	if table.contains(Heroes, myHero.charName) then
		_G[myHero.charName]()
		LoadUnits()
	end
end
