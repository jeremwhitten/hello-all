require("common.log")

local Meta = {
  Name = "ToxicEvelynn",
  Version = "1.0.0",
  ChampionName = "Evelynn"
}

module(Meta.Name, package.seeall, log.setup)
clean.module(Meta.Name, package.seeall, log.setup)

local CoreEx = _G.CoreEx
local Libs   = _G.Libs

local Menu = Libs.NewMenu
local _SDK = _G.CoreEx
local Game          = CoreEx.Game
local Input         = CoreEx.Input
local Enums         = CoreEx.Enums
local Renderer      = CoreEx.Renderer
local ObjManager    = _SDK.ObjectManager
local EventManager  = CoreEx.EventManager
local Vector        = CoreEx.Geometry.Vector
local Player = ObjManager.Player

local TargetSelector   = Libs.TargetSelector
local Spell            = Libs.Spell
local Orbwalker        = Libs.Orbwalker
local DamageLib        = Libs.DamageLib
local HealthPred = _G.Libs.HealthPred

local Events     = Enums.Events
local SpellSlots = Enums.SpellSlots
local HitChance  = Enums.HitChance

local LocalPlayer = ObjManager.Player.AsHero

-- Check if we are using the right champion
if LocalPlayer.CharName ~= Meta.ChampionName then return false end

local HitChanceList = { "Collision", "OutOfRange", "VeryLow", "Low", "Medium", "High", "VeryHigh", "Dashing", "Immobile" }

-- UTILS --
local Utils = {}

function Utils.IsGameAvailable()
  -- Is game available to automate stuff
  return not (
    Game.IsChatOpen()  or
    Game.IsMinimized() or
    LocalPlayer.IsDead
  )
end

function Utils.IsInRange(From, To, Min, Max)
  local Distance = From:Distance(To)
  return Distance >= Min and Distance <= Max
end

function Utils.IsValidTarget(Target)
  return Target.IsTargetable and Target.IsAlive
end

local function ValidMinion(minion)
	return minion and minion.IsTargetable and minion.MaxHealth > 6 -- check if not plant or shroom
end

function Utils.LoadMenu()
  Menu.RegisterMenu(Meta.Name, Meta.Name, function ()
    
    Menu.NewTree("Q", "[Q] Hate Spike", function()
      Menu.NewTree("ComboQ", "Combo", function()
          Menu.Checkbox("ComboUseQ", "Enabled", true)
      end)      
    end)

    Menu.NewTree("EveWave", "Waveclear", function ()
		Menu.Checkbox("Wave.CastQ","Cast Q",true)
		Menu.Slider("Wave.CastQHC", "Q Min. Hit Count", 1, 0, 10, 1)
	end)
    --Menu.NewTree("W", "[W] Surround Sound", function()
    --Menu.NewTree("AutoW", "Auto", function()
    --   Menu.Checkbox("AutoUseWAlly", "Enabled Heal", true)
    --   Menu.Slider("AutoWHealth", "HP %", 50, 0, 100, 1)
    -- end)
    --nd)
    Menu.NewTree("E", "[E] Whiplash", function()
      Menu.NewTree("ComboE", "Combo", function()
          Menu.Checkbox("ComboUseE", "Enabled", true)
          Menu.Dropdown("ComboHitChanceE", "Hitchance", 6, HitChanceList)
      end)
    end)
    Menu.NewTree("R", "[R] Last Caress", function()
      Menu.NewTree("ComboR", "Combo", function()
          Menu.Checkbox("AutoUseR", "Enabled", true)
          Menu.Dropdown("ComboHitChanceR", "Hitchance", 6, HitChanceList)
      end)
    end)
    Menu.NewTree("EveDrawing", "Drawing", function ()
		Menu.Checkbox("Drawing.DrawQ","Draw Q Range",true)
		Menu.ColorPicker("Drawing.DrawQColor", "Draw Q Color", 0xEF476FFF)
		Menu.Checkbox("Drawing.DrawE","Draw E Range",true)
		Menu.ColorPicker("Drawing.DrawEColor", "Draw E Color", 0x06D6A0FF)
		Menu.Checkbox("Drawing.DrawR","Draw R Range",true)
		Menu.ColorPicker("Drawing.DrawRColor", "Draw R Color", 0xFFD166FF)
	end)
  end)
end

-- CHAMPION SPELLS --
local Champion  = {}

local spells = {
	Q = Spell.Skillshot({
		Slot = Enums.SpellSlots.Q,
		Range = 800,
        Speed = 2400,
        Radius = 60,
        EffectRadius = 60,
        Delay = 0.25,
        Collisions = {Minions = true, WindWall = true},
        UseHitbox = true,
        Type = "Linear",
	}),
	W = Spell.Targeted({
		Slot = Enums.SpellSlots.W,
		Range = 1100,
        Delay = 0.25
	}),
	E = Spell.Targeted({
		Slot = Enums.SpellSlots.E,
        Range = 300,
	}),
	R = Spell.Skillshot({
        Slot = Enums.SpellSlots.R,
		Range = 450,
        Speed = math.huge,
        Radius = 150,
        Delay = 0.35,
        UseHitbox = true,
        Type = "Linear",
	}),
}


local function GetRDmg(Target)
  local Level = spells.R:GetLevel()
  local BaseDamage = ({ 250, 375, 500 })[Level]
  local BonusDamage = LocalPlayer.FlatPhysicalDamageMod + (LocalPlayer.FlatMagicalDamageMod * 0.5)
  local TotalDamage = BaseDamage + BonusDamage
  return DamageLib.CalculatePhysicalDamage(LocalPlayer, Target, TotalDamage)
end

-- CHAMPION LOGICS --
Champion.Logic = {}

function Champion.Logic.Q(Target, Enable)
  local Q = spells.Q
  
  if
    Enable and
    Target and
    Q:IsReady() and
    Q:IsInRange(Target)
  then
    return Q:Cast(Target)
  end

  return false
end
function Champion.Logic.W(Target, Enable)
  local W = spells.W
  
  if
    Enable and
    Target and
    W:IsReady() and
    W:IsInRange(Target)
  then
    return W:Cast(Target)
  end

  return false
end
function Champion.Logic.E(Target, Enable)
  local E = spells.E
  
  if
    Enable and
    Target and
    E:IsReady() and
    E:IsInRange(Target)
  then
    return E:Cast(Target)
  end

  return false
end

local function CastR(target)
	if spells.R:IsReady() then
		if spells.R:Cast(target) then
			return
		end
	end
end

local function Waveclear()

	local pPos, pointsQ, pointsE = Player.Position, {}, {}	
	-- Jungle Minions
	if #pointsQ == 0 then
		for k, v in pairs(ObjManager.Get("neutral", "minions")) do
			local minion = v.AsAI
			if ValidMinion(minion) then
				local posQ = minion:FastPrediction(spells.Q.Delay)
				if posQ:Distance(pPos) < spells.Q.Range then
					table.insert(pointsQ, posQ)
				end    
			end
		end
	end
	
	local bestPosQ, hitCountQ = spells.Q:GetBestLinearCastPos(pointsQ)
	if bestPosQ and hitCountQ >= Menu.Get("Wave.CastQHC")
		and spells.Q:IsReady() and Menu.Get("Wave.CastQ") then
		spells.Q:Cast(bestPosQ)
    end
end

local function ChampCombo()
  if Champion.Logic.Q(spells.Q:GetTarget(), Menu.Get("ComboUseQ")) then return true end
  if Champion.Logic.E(spells.E:GetTarget(), Menu.Get("ComboUseE")) then return true end  
end

local function AutoRKS()

	if not spells.R:IsReady() then return end

	local enemies = ObjManager.Get("enemy", "heroes")
	local myPos, rRange = Player.Position, (spells.R.Range + Player.BoundingRadius)

	for handle, obj in pairs(enemies) do        
		local hero = obj.AsHero        
		if hero and hero.IsTargetable then
			local dist = myPos:Distance(hero.Position)
			local healthPred = HealthPred.GetHealthPrediction(hero, spells.R.Delay)
			if dist <= rRange and GetRDmg(hero) > healthPred and Menu.Get("AutoUseR") then
				CastR(hero) -- R KS
			end
		end		
	end	
end

-- CALLBACKS --
local Callbacks = {}


function Callbacks.OnTick()
  -- Get current orbwalker mode
  local OrbwalkerMode = Orbwalker.GetMode()

  if OrbwalkerMode == "Combo" then
  ChampCombo()
  end
  -- Call it
  if OrbwalkerMode == "Waveclear" then
  Waveclear()
  end

  AutoRKS()
  return false
end

local function OnDraw()	

	-- Draw Q Range
	if Player:GetSpell(SpellSlots.Q).IsLearned and Menu.Get("Drawing.DrawQ") then 
		Renderer.DrawCircle3D(Player.Position, spells.Q.Range, 30, 1.0, Menu.Get("Drawing.DrawQColor"))
	end
	-- Draw W Range
	if Player:GetSpell(SpellSlots.E).IsLearned and Menu.Get("Drawing.DrawE") then
		Renderer.DrawCircle3D(Player.Position, spells.E.Range, 30, 1.0, Menu.Get("Drawing.DrawEColor"))
	end
	-- Draw R Range
	if Player:GetSpell(SpellSlots.R).IsLearned and Menu.Get("Drawing.DrawR") then 
		Renderer.DrawCircle3D(Player.Position, spells.R.Range, 30, 1.0, Menu.Get("Drawing.DrawRColor"))
	end

end
-- ENTRYPOINT --
function OnLoad()
  -- Load Menu
  Utils.LoadMenu()
  -- Register callback for func available in champion object
  for EventName, EventId in pairs(Events) do
    if Events[EventName] then
        EventManager.RegisterCallback(EventId, Callbacks[EventName])
		EventManager.RegisterCallback(Enums.Events.OnDraw, OnDraw)
    end
  end

  return true
end
