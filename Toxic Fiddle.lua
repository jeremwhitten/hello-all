if GetObjectName(GetMyHero()) ~= "Fiddlesticks" then return end

require('Inspired')

local FiddleMenu = Menu("Fiddle", "Fiddle")
FiddleMenu:SubMenu("Combo", "Combo")
FiddleMenu.Combo:Boolean("Q", "Use Q", true)
FiddleMenu.Combo:Boolean("W", "Use W", true)
FiddleMenu.Combo:Boolean("E", "Use E", true)
FiddleMenu.Combo:Boolean("R", "Use R", true)

FiddleMenu:Menu("Harass", "Harass")
FiddleMenu.Harass:Boolean("Q", "Use Q", true)
FiddleMenu.Harass:Boolean("W", "Use W", true)
FiddleMenu.Harass:Boolean("E", "Use E", true)

OnTick(function (myHero)

	local target = GetCurrentTarget()

	if IOW:Mode() == "Combo" then

		if FiddleMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 800) then
			CastSpell(_R)
		end

		if FiddleMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 575) then
			CastTargetSpell(target, _W)
		end

		if FiddleMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 575) then
			CastTargetSpell(target, _Q)
		end

		if FiddleMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 750) then
			CastTargetSpell(target, _E)
		end
	end
end)



print("FiddleSticks, By: Poptart loaded. Have Fun")
