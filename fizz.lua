if GetObjectName(GetMyHero()) ~= "Fizz" then return end

require("Inspired)

local FizzMenu = Menu("Fizz", "Fizz")
FizzMenu:SubMenu("Combo", "Combo")
FizzMenu.Combo:Boolean("Q", "Use Q", true)
FizzMenu.Combo:Boolean("W", "Use W", true)
FizzMenu.Combo:Boolean("E", "Use E", true)
FizzMenu.Combo:Boolean("R", "Use R", true)

OnTick(function (MyHero)

	local target = GetCurrentTarget()
	
	if IOW:Mode() == "Combo" then

		if FizzMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 1275) then
		local targetPos = GetOrigin(target)
		CastSkillShot(_R, targetPos)
		end

		if FizzMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 400) then
		Cast(_E,Etarget)
		end

		if FizzMenu.Combo.W:Value() and Ready(_W)
		Cast(_E)
		end

		if FizzMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 550) then
		Cast(_Q,Qtarget)
		end
	end
end)

print("Fizz loaded")
		
