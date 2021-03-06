local Heroes = {"Swain"}

if not table.contains(Heroes, myHero.charName) then return end




require('DamageLib')
require "2DGeometry"


if not FileExist(COMMON_PATH .. "GamsteronPrediction.lua") then
	print("GsoPred. installed Press 2x F6")
	DownloadFileAsync("https://raw.githubusercontent.com/gamsteron/GOS-EXT/master/Common/GamsteronPrediction.lua", COMMON_PATH .. "GamsteronPrediction.lua", function() end)
	while not FileExist(COMMON_PATH .. "GamsteronPrediction.lua") do end
end
    
require('GamsteronPrediction')










local GameHeroCount = Game.HeroCount
local HeroIcon = ""
local QIcon = ""
local PassiveIcon = ""
local WIcon = ""
local EIcon = ""
local RIcon = ""
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

local function CountEnemiesNear(pos, range)
    local pos = pos.pos
	local count = 0
	for i = 1, GameHeroCount() do 
	local hero = GameHero(i)
	local Range = range * range
		if hero.team ~= TEAM_ALLY and GetDistanceSqr(pos, hero.pos) < Range and IsValid(hero) then
		count = count + 1
		end
	end
	return count
end

local function AllyHeroes()
	local _AllyHeroes = {}
	for i = 1, GameHeroCount() do
		local unit = GameHero(i)
		if unit.isAlly and not unit.isMe then
			TableInsert(_AllyHeroes, unit)
		end
	end
	return _AllyHeroes
end

local function GetAllyCount(pos, range)
    local pos = pos.pos
    local count = 0
    for i, hero in ipairs(AllyHeroes()) do
    local Range = range * range
        if GetDistanceSqr(pos, hero.pos) < Range and IsValid(hero) then
        count = count + 1
        end
    end
    return count
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

local function GetInventorySlotItem(itemID)
    assert(type(itemID) == "number", "GetInventorySlotItem: wrong argument types (<number> expected)")
    for _, j in pairs({ITEM_1, ITEM_2, ITEM_3, ITEM_4, ITEM_5, ITEM_6, ITEM_7}) do
        if myHero:GetItemData(j).itemID == itemID and myHero:GetSpellData(j).currentCd == 0 then return j end
    end
    return nil
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


class "Swain"

function Swain:__init()	
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


local QData =
{
Type = _G.SPELLTYPE_LINE, Delay = 0.25, Radius = 725, Range = 650, Speed = math.huge, Collision = false
}

local WData =
{
Type = _G.SPELLTYPE_CIRCLE, Delay = math.huge, Radius = 325, Range = 5500, Speed = math.huge, Collision = false
}

local EData =
{
Type = _G.SPELLTYPE_LINE, Delay = 0.25, Radius = 355, Range = 850, Speed = math.huge, Collision = false
}

local RData =
{
Type = _G.SPELLTYPE_CIRCLE, Delay = 0.25, Range = 650, Speed = math.huge, Collision = false
}

function Swain:LoadMenu()                     
	
--MainMenu
self.Menu = MenuElement({type = MENU, id = "Swain", name = "Swain Beta.01"})
		
--ComboMenu  
self.Menu:MenuElement({type = MENU, id = "Combo", name = "Combo Mode"})
	self.Menu.Combo:MenuElement({id = "UseQ", name = "[Q]", value = true})
	self.Menu.Combo:MenuElement({id = "UseW", name = "[W]", value = true})
	self.Menu.Combo:MenuElement({id = "UseE", name = "[E]", value = true})
	self.Menu.Combo:MenuElement({id = "UseR", name = "[R]", value = true})

	self.Menu:MenuElement({id = "AutoR", name = "R Settings",type = MENU})
	self.Menu.AutoR:MenuElement({id = "AutoR3", name = "Enable Auto R",value = true})
	self.Menu.AutoR:MenuElement({id = "RxEnemies", name = "CountEnemiesNear",value = 2, min = 1, max = 5,step = 1})
	


self.Menu:MenuElement({type = MENU, id = "KS", name = "KillSteal Mode"})
	self.Menu.KS:MenuElement({id = "UseR", name = "[R]", value = true})	

--LaneClear
self.Menu:MenuElement({type = MENU, id = "LaneClear", name = "LaneClear Mode"})
	self.Menu.LaneClear:MenuElement({id = "UseQ", name = "[Q]", value = true})
	self.Menu.LaneClear:MenuElement({id = "UseW", name = "[W]", value = true})
	self.Menu.LaneClear:MenuElement({id = "UseE", name = "[E]", value = true})	
	self.Menu.LaneClear:MenuElement({id = "UseR", name = "[R]", value = true})
		
--Prediction
self.Menu:MenuElement({type = MENU, id = "Pred", name = "Prediction"})
	self.Menu.Pred:MenuElement({id = "PredQ", name = "Hitchance[Q]", value = 1, drop = {"Normal", "High", "Immobile"}})
	self.Menu.Pred:MenuElement({id = "PredW", name = "Hitchance[W]", value = 1, drop = {"Normal", "High", "Immobile"}})
	self.Menu.Pred:MenuElement({id = "PredE", name = "Hitchance[E]", value = 1, drop = {"Normal", "High", "Immobile"}})
	self.Menu.Pred:MenuElement({id = "PredR", name = "Hitchance[R]", value = 1, drop = {"Normal", "High", "Immobile"}})	
	
--Drawing 
	self.Menu:MenuElement({type = MENU, id = "Drawing", name = "Drawings Mode"})
	self.Menu.Drawing:MenuElement({id = "DrawQ", name = "Draw [Q] Range", value = true})
	self.Menu.Drawing:MenuElement({id = "DrawW", name = "Draw [W] Range", value = true})
	self.Menu.Drawing:MenuElement({id = "DrawE", name = "Draw [E] Range", value = true})
	self.Menu.Drawing:MenuElement({id = "DrawR", name = "Draw [R] Range", value = true})
	self.Menu.Drawing:MenuElement({id = "Killable", name = "DrawTargetKill", value = true})

	self.Menu:MenuElement({type = MENU, id = "AutoW", name = "AutoW"})
	self.Menu.AutoW:MenuElement({id = "UseW", name = "AutoW", value = true})
	self.Menu.AutoW:MenuElement({id = "UseWH", name = "Minimum Health", value = 50, min = 0, max = 100, identifier = "%"})

end

function Swain:Tick()
if MyHeroNotReady() then return end
AutoR2()
KillSteal()






local Mode = GetMode()
	if Mode == "Combo" then
		self:Combo()  	
	end
	
	
	
end
 
function Swain:Draw()
  if myHero.dead then return end

  
                                                 
	if self.Menu.Drawing.DrawQ:Value() then
    Draw.Circle(myHero, 725, 1, Draw.Color(225, 225, 0, 10))
	end

	

	if self.Menu.Drawing.DrawE:Value() then
    Draw.Circle(myHero, 850, 1, Draw.Color(255, 225, 0, 10))
	end

	if self.Menu.Drawing.DrawR:Value() then
    Draw.Circle(myHero, 650, 1, Draw.Color(225, 0, 255, 10))
	end




	local textPos = myHero.dir	
	if not FileExist(COMMON_PATH .. "GamsteronPrediction.lua") then
		Draw.Text("GsoPred. installed Press 2x F6", 50, textPos.x + 100, textPos.y - 250, Draw.Color(255, 255, 0, 0))
	end	
	
	local target = GetTarget(3000)
	if target == nil then return end 
	
        if self.Menu.Drawing.Killable:Value() and IsValid(target) then
        local QDmg = getdmg("Q", target, myHero)
        local WDmg = getdmg("W", target, myHero)
        local EDmg = getdmg("E", target, myHero)
        local RDmg = getdmg("R", target, myHero)
        local Dmg = QDmg + WDmg + EDmg + RDmg
		--print(Dmg)
        local hp = (target.health)
            if Ready(_Q) and Ready(_E) and Ready(_R)and Dmg > hp then
			local screenPos = target.pos:To2D()
                Draw.Text("Killable", 28, screenPos.x - 30, screenPos.y, Draw.Color(255, 255, 0, 0))
            end
			
			
        end
end







-- Ult KillSteal --
-- function Swain:KSUlt()
-- local target = GetTarget(550)     	
-- if target == nil then return end
	-- if IsValid(target) then
		-- local Rdmg = getdmg("R", target, myHero) -- Dmg data from DamageLib
		-- if myHero.pos:DistanceTo(target.pos) < 550 and self.Menu.KS.UseR:Value() and Ready(_R) then
			-- local pred = GetGamsteronPrediction(target, RData, myHero)
			-- if target.health < Rdmg and pred.Hitchance >= self.Menu.Pred.PredR:Value() + 1 then  --- target.health < Rdmg ,,,, check target and dmg
				-- Control.CastSpell(HK_R)
			-- end
		-- end
	-- end
-- end


function Swain:Combo()
local target = GetTarget(5000)     	
if target == nil then return end
	if IsValid(target) then
		
		if myHero.pos:DistanceTo(target.pos) <= 725 and Ready(_Q) then
		    local pred = GetGamsteronPrediction(target, QData, myHero)
			if pred.Hitchance >= self.Menu.Pred.PredQ:Value() + 1 then
		Control.CastSpell(HK_Q,target)
		end
		end

		if myHero.pos:DistanceTo(target.pos) <= 5500 and Ready(_W) then
		    local pred = GetGamsteronPrediction(target, WData, myHero)
			if pred.Hitchance >= self.Menu.Pred.PredW:Value() + 1 then
		Control.CastSpell(HK_W,target)
		end
		end
		

		if myHero.pos:DistanceTo(target.pos) <= 850 and self.Menu.Combo.UseE:Value() and Ready(_E) then
			local pred = GetGamsteronPrediction(target, EData, myHero)
			if pred.Hitchance >= self.Menu.Pred.PredE:Value() + 1 then
			Control.CastSpell(HK_E,target)
		end
		end
		
		
			local Rdmg = getdmg("R", target, myHero)
			if myHero.pos:DistanceTo(target.pos) <= 825 and self.Menu.Combo.UseR:Value() and Ready(_R) and myHero:GetSpellData(_R).toggleState == 0 then
				Control.CastSpell(HK_R)
			elseif target.health < Rdmg and Ready(_R) then
			--print("KS")
					Control.CastSpell(HK_R)		
					end
			end			
	end	

function AutoR2()
local target = GetTarget(550)
if target == nil then return end
    if IsValid(target) and myHero.pos:DistanceTo(target.pos) < 550 and Ready(_R) and myHero:GetSpellData(_R).toggleState == 0 then
        if CountEnemiesNear (myHero, 550) >= 2 then
            Control.CastSpell(HK_R)
            return
        end
    end
end

function KillSteal()
	local target = GetTarget(5000)
			
		if target and myHero.pos:DistanceTo(target.pos) < 5000 and IsValid(target) then
		
			local WDmg = getdmg("W", target, myHero)
			local QDmg = getdmg("Q", target, myHero)

			if Ready(_W) and WDmg >= target.health then
						if target.pos2D.onScreen then 		
							Control.CastSpell(HK_W, target) 							
						else	   
							CastSpellMM(HK_W, target.pos, 5500)
						end
			end


				if Ready(_Q) and QDmg >= target.health then
					Control.CastSpell(HK_Q, target)	
				end	
			end
		end
	

			


function OnLoad()
	if table.contains(Heroes, myHero.charName) then
		_G[myHero.charName]()
		LoadUnits()
	end
end
