if GetObjectName(GetMyHero()) ~= "Rammus" then return end

require('DamageLib')

local RammusMenu = Menu("Rammus", "Rammus")
RammusMenu:SubMenu("Combo", "Combo")
RammusMenu.Combo:KeyBinding("comboKey", "Combo Key", 32)
RammusMenu.Combo:Boolean("Q", "Use Q", true)
RammusMenu.Combo:Boolean("W", "Use W", true)
RammusMenu.Combo:Boolean("E", "Use E", true)
RammusMenu.Combo:Boolean("R", "Use R", true)

RammusMenu:Menu("Harass", "Harass")
RammusMenu.Harass:KeyBinding("harassKey", "Harass Key", string.byte("C"))
RammusMenu.Harass:Boolean("Q", "Use Q", true)
RammusMenu.Harass:Boolean("E", "Use E", true)
RammusMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

RammusMenu:Menu("JungleClear", "JungleClear")
RammusMenu.JungleClear:KeyBinding("jungleclearKey", "JungleClear Key", string.byte("V"))
RammusMenu.JungleClear:Boolean("Q", "Use Q", true)
RammusMenu.JungleClear:Boolean("E", "Use E", true)
RammusMenu.JungleClear:Boolean("W", "Use W", true)

RammusMenu:SubMenu("Skinhack", "Skinhack")
RammusMenu.Skinhack:Slider("hs", "Skin Order", 0,0,7)


OnDraw(function()
		SkinChanger()
	end)

function SkinChanger()
	HeroSkinChanger(myHero, RammusMenu.Skinhack.hs:Value())
end

OnTick(function (myHero)
	 
	local target = GetCurrentTarget()
	
	if KeyIsDown(RammusMenu.Combo.comboKey:Key()) then
	
		if RammusMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target,500) then
			CastTargetSpell(target, _Q)
		end
		
		if RammusMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target,325) then
			CastTargetSpell(target, _E)
		end
		
		if RammusMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target,300) then
			CastSpell(_W)
		end
		
		if RammusMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target,300) then
			CastSpell(_R)
		end
	end
	
	for i,mobs in pairs(minionManager.objects) do
		if KeyIsDown(RammusMenu.JungleClear.jungleclearKey:Key()) then
		
			if RammusMenu.JungleClear.W:Value() and Ready(_W) and ValidTarget(mobs,300) then
			CastSpell(_W)
			end
			
			if RammusMenu.JungleClear.Q:Value() and Ready(_Q) and ValidTarget(mobs,500) then
			CastSpell(_Q)
			end
			
			if RammusMenu.JungleClear.E:Value() and Ready(_E) and ValidTarget(mobs,300) then
			CastSpell(_E)
			end
		end
	end
	
	for i,enemy in pairs(GetEnemyHeroes()) do
		if RammusMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target,300) then
			CastSpell(_R)
		end
	end
		
	
	
end)

print("Toxic Rammus Loaded, Have Fun "..GetUser().."!")
print("If JG, start W, then Q, then E,")
print("LVL order is W,Q,E,E,W,R")
