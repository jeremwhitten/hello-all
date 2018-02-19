require ('Inspired')
require ('OpenPredict')
require ('IPrediction')
if FileExist(COMMON_PATH .. "KLib.lua") then
require ('KLib')
libloaded = true
 else
   DownloadFileAsync("https://raw.githubusercontent.com/Lonsemaria/Gos/master/Common/KLib.lua", COMMON_PATH .. "KLib.lua", function() print("<font color=\"#FF0000\"><b> "..Scriptname.."   </b></font><font color=\"#FFFFFF\"> :Hello <font color=\"#FF0000\"><b>"..GetUser().."</b></font> , KLib has been downloaded succesfully. In order to use script , please 2x F6 ")  return end)
end
local loaddac = false
local loadiow = false
Version = "1.32"
LVersion = " 6.4"
Scriptname = "Krystra Mid Series"
Author = "Krystra"
list = "Leblanc , Lissandra , Viktor, Akali, Diana, Yasuo,Zed, Orianna , Twisted Fate "
link = "http://gamingonsteroids.com/topic/10502-beta-stage-krystra-mid-series-leblanc-viktor-lissandra-diana-akali-multi-prediction-orbwalk-support-expert-drawings-and-much-more/"
date = "09.03.2016"
  OnLoad(function()
  function AutoUpdate(data)
  if not libloaded or not libupdated then return end
    if tonumber(data) > tonumber(Version) then
        print("<font color=\"#FF0000\"><b> "..Scriptname.."   </b></font><font color=\"#FFFFFF\"> : New version has been found " .. data) 
        DelayAction(function()  print("<font color=\"#FF0000\"><b> "..Scriptname.."   </b></font><font color=\"#FFFFFF\"> : Downloading update, please wait...") end, 1)
       DelayAction(function() DownloadFileAsync("https://raw.githubusercontent.com/Lonsemaria/Gos/master/Script/KrystraMidBundle.lua", SCRIPT_PATH .. "KrystraMidBundle.lua",
       function() DownloadFileAsync("https://raw.githubusercontent.com/Lonsemaria/Gos/master/Common/welcome.wav", COMMON_PATH .. "Welcome.wav",
        function() print("<font color=\"#FF0000\"><b> "..Scriptname.."   </b></font><font color=\"#FFFFFF\"> : Updated succesfully to ".. data..". Please do 2x F6 to reload." ) return  end) end) end, 3)
    else
        DelayAction(function()   print("<font color=\"#FF0000\"><b> "..Scriptname.."   </b></font><font color=\"#FFFFFF\"> : Hello <font color=\"#FF0000\"><b>"..GetUser().."</b></font> ,  [".. Version.."] version has succesfully loaded, Good luck and don't forget to give a feedback :) ") end, 1.5)
        PlaySound(COMMON_PATH .. "welcome")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/Lonsemaria/Gos/master/Version/midbundle.version", AutoUpdate)
   end)




 local ebuff = false
    class "Viktor"
    function Viktor:__init()
      if not libloaded then return end
      self.W = { delay = 0.50, speed = 750, width = 125, range = 700 , radius = 250 } --AOE true , Col false
      self.E = { delay = 0.25, speed = 1350 , width = 180, range = 1200 } --AOE false , Col false
      self.R = { delay = 0.25, speed = 1000, width = 650, range = 700 , radius = 325 } --AOE true , Col false
      self:LoadMenu()
      AddGapcloseEvent(_W, 100, false,  menu.misc.gapClose)
      self.tsg = TargetSelector(1300,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
        rSpell = IPrediction.Prediction({range = 600, speed = 1000, delay = 0.50, width = 650, type = "circular", name =myHero:GetSpellData(_R).name, collision = false})
        wSpell  = IPrediction.Prediction({range = 700, speed = 750, delay = 0.50, width = 125, type = "circular",name =myHero:GetSpellData(_W).name,  collision = false})
      self.E = {Range1 = 550, Range2 = 700, width = 180, ready}
      self.ERange = self.E.Range1+self.E.Range2
      Last_LevelSpell = 0
      Callback.Add("Load", function() self:onload() end)
      Callback.Add("Tick", function() self:Tick() end)
      Callback.Add("WndMsg", function(Msg, Key) self:WndMsg(Msg, Key) end)
      Callback.Add("Draw", function() self:Draw() end)
      Callback.Add("UpdateBuff", function(unit,buff) self:UpdateBuff(unit,buff) end)
      Callback.Add("RemoveBuff", function(unit,buff) self:RemoveBuff(unit,buff) end)
      Callback.Add("ProcessSpell", function(unit, spell) self:ProcessSpell(unit, spell) end)
    end
    function Viktor:Checks()
      Gtarget = self.tsg:GetTarget()
      if not ValidTarget(Gtarget, 1300) or not menu.targetsel.ts:Value()  then
        target = GetCurrentTarget()
      elseif  ValidTarget(Gtarget, 1300) and not self.selectedTar then
        target = GetCurrentTarget()
      elseif (ValidTarget(Gtarget, 1300) and self.selectedTar) then
        target = self.selectedTar
      end
      mousePos = GetMousePos()
       Activator:Loaditems("ap")
    end
    function Viktor:Tick()
      self:Checks()
      self:Hasebuff()
      Antiafk()
      autolevel()
      skinhack()
      autopot()
      Activator:Useitems("ap")
      if(menu.combo.combokey:Value() )then
        self:combo()
      end
      if(menu.farm.clearkey.lasthitkey:Value() or menu.farm.lasthit.autolasthit:Value() )then
        self:LastHit()
      end
      if(menu.farm.clearkey.laneclearkey:Value())then
        self:LaneClear()
      end
      if(menu.farm.clearkey.jungleclearkey:Value())then
        self:JungleClear()
      end
      if(menu.killsteal.ks:Value() ) then
        self:killsteal()
      end
      if(menu.harass.harasskey:Value() or menu.harass.harasstogle:Value() ) then
        self:harass()
      end
      if menu.instruct:Value() then
        menu.instruct:Value(false)
        PopUp1 = true
      end
    end
    function Viktor:CastQ(unit)
      if IsReady(_Q) then
        CastTargetSpell(unit, _Q)
      end
    end
    function Viktor:CastW(unit)
      if menu.pred.selectpred:Value() == 1 then
        local WPred = GetCircularAOEPrediction(unit, self.W)
        if IsReady(_W) then
          if WPred  and WPred.hitChance >= (menu.pred.hcgeneral.hcop.hcopw:Value()/100) then
            CastSkillShot(_W, WPred.castPos)
          end
        end
      elseif  menu.pred.selectpred:Value() == 2 then
          local HitChance, y = wSpell:Predict(unit)
          if IsReady(_W) and HitChance >= 3 then
            CastSkillShot(_W, y.x, y.y, y.z)
          end
      elseif menu.pred.selectpred:Value() == 3 then
        local wPred = GetPredictionForPlayer(myHeroPos(), unit, GetMoveSpeed(unit), 1350, 500, 700, 125, false, true)
        if IsReady(_W) and wPred.HitChance == 1 then
          CastSkillShot(_W, wPred.PredPos.x, wPred.PredPos.y, wPred.PredPos.z)
        end
      end
    end





    function Viktor:CastE(unit)
      if unit.dead or unit.health == 0 then
        return
      end
      if GetDistance(unit, myHero) > self.E.Range1-5 then
        EStartPos = CircleIntersection(myHero, unit, myHero, self.E.Range1-5)
      else
        EStartPos = Vector(unit.x, unit.y, unit.z)
      end
      local EPred = GetPrediction(unit, self.E)
      if IsReady(_E) then
        if EPred  and EPred.hitChance >= (menu.pred.hcgeneral.hcop.hcope:Value()/100)  then
          CastSkillShot3(_E,EStartPos, EPred.castPos)
        end
      end
    end
    function Viktor:CastR(unit)
      if menu.pred.selectpred:Value() == 1 then
        local WPred = GetPrediction(unit, self.W)
        if IsReady(_R) then
          if WPred  and WPred.hitChance >= (menu.pred.hcgeneral.hcop.hcopr:Value()/100) then
            CastSkillShot(_R, WPred.castPos)
          end
        end
      elseif  menu.pred.selectpred:Value() == 2 then
          local HitChance, y = rSpell:Predict(unit)
          if IsReady(_R) and HitChance >= 3 then
            CastSkillShot(_R, y.x, y.y, y.z)
          end
      elseif menu.pred.selectpred:Value() == 3 then
        local wPred = GetPredictionForPlayer(myHeroPos(), unit, GetMoveSpeed(unit), 1000, 250, 700, 650, false, true)
        if IsReady(_R) and eSpell.HitChance == 1 then
          CastSkillShot(_R, wPred.PredPos.x, wPred.PredPos.y, wPred.PredPos.z)
        end
      end
    end
    function Viktor:CastI(unit)
      local Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
      if Ignite then
        if IsReady(Ignite) then
          CastTargetSpell(unit, Ignite)
        end
      end
    end
    function Viktor:UpdateBuff(unit,buff)
      if unit and unit.isMe then
        if  buff.Name == "viktoreaug" then
          ebuff = true
        end
      end
    end
    function Viktor:Hasebuff()
      for i = 1, myHero.buffCount do
        local buff = myHero:getBuff(i)
        if BuffIsValid(buff) then
          if buff.name:lower():find("viktoreaug") then
            ebuff = true
          end
        end
      end
    end
    function Viktor:RemoveBuff(unit, buff)
      if unit and unit.isMe then
        if  buff.Name == "viktoreaug" then

          ebuff = false
        end
      end
    end
    function Viktor:Draw()
      if menu.other.draw.qdraw:Value() and IsReady(_Q) then
        DrawCircle(myHero.x, myHero.y, myHero.z, 600,  menu.other.width.Qwidth:Value(),0,menu.other.color.Qcolor:Value())
      end

      if menu.other.draw.wdraw:Value() and IsReady(_W) then
        DrawCircle(myHero.x, myHero.y, myHero.z, 700,  menu.other.width.Wwidth:Value(),0, menu.other.color.Wcolor:Value())
      end

      if menu.other.draw.edraw:Value() and IsReady(_E) then
        DrawCircle(myHero.x, myHero.y, myHero.z, 1200,  menu.other.width.Ewidth:Value(),0, menu.other.color.Ecolor:Value())
      end

      if menu.other.draw.rdraw:Value() and IsReady(_R) then
        DrawCircle(myHero.x, myHero.y, myHero.z, 700, menu.other.width.Rwidth:Value(),0, menu.other.color.Rcolor:Value())
      end
      if menu.other.draw.aadraw:Value() then
        DrawCircle(myHero.x, myHero.y, myHero.z, 525, menu.other.width.AAwidth:Value(),0, menu.other.color.AAcolor:Value())
      end
    Global:Commondraw()
      for _, target in pairs(GetEnemyHeroes()) do
        if ValidTarget(target, 15000) then
          if target.visible and not target.dead and menu.other.damage:Value() then
            currLine = 1
            -- DrawLineHPBar2(self:GetMyDmg(target),"",  target, currLine)
            DrawLineHPBar(self:GetMyDmg(target), "Damage " .. math.round(self:GetMyDmg(target)),target,currLine)
            currLine = currLine + 1
            DrawDmgOverHpBar(target,GetCurrentHP(target),0,self:GetMyDmg(target),0xff00ff00)
          end
        end
      end

      if menu.other.targetcal:Value() and not myHero.dead then
        if target and target ~= nil then
          --  local target= GetOrigin(target)
          local drawpos=WorldToScreen(1,target.x, target.y, target.z)
          local comboText,color = self:GetDraws(target)
          if comboText then
            DrawText(comboText,15,drawpos.x-20,drawpos.y-20,color)
          end
        end
      end
    end
    function Viktor:alwaysr()
      if (IsReady(_R) and (myHero.mana / myHero.maxMana > menu.combo.Mana:Value() /100 ) and menu.combo.useR:Value() and menu.combo.combokey:Value() and GetDistance(target)<700 ) then
        self:CastR(target)
      end
    end
    function Viktor:needr()
      if (IsReady(_R) and (myHero.mana / myHero.maxMana > menu.combo.Mana:Value() /100 ) and menu.combo.useR:Value() and menu.combo.combokey:Value() and GetDistance(target)<700 ) then
        local damagewithr =self:GetRDmg(target)+self:GetQDmg(target) +self:GetEDmg(target)
        local damagewithnor = self:GetQDmg(target) +self:GetEDmg(target)
        local health=target.health
        if(health<damagewithr )then
          self:CastR(target)
        end
      end
    end
    function Viktor:killr()
      if (IsReady(_R) and (myHero.mana / myHero.maxMana > menu.combo.Mana:Value() /100 ) and menu.combo.useR:Value() and menu.combo.combokey:Value() and GetDistance(target)<700 ) then
        local dmgR =self:GetRDmg(target)
        local health=target.health
        if(health<dmgR )then
          self:CastR(target)
        end
      end
    end
    function Viktor:ProcessSpell(unit, spell)
       if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and IsReady(_R) then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, self.R.range) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and  menu.misc.interrupt[GetObjectName(unit).."Inter"]:Value() and menu.misc.interrupt.r:Value() then 
         self:CastR(unit)
        end
      end
    end
       if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and IsReady(_W) then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 1000) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and  menu.misc.interrupt[GetObjectName(unit).."Inter"]:Value() and menu.misc.interrupt.w:Value() then 
         self:CastW(unit)
        end
      end
    end
    end
    function Viktor:combo()
      if((IsReady(_Q) and (myHero.mana / myHero.maxMana > menu.combo.Mana:Value() /100 )and GetDistance(target) < 600  and menu.combo.useQ:Value() and menu.combo.combokey:Value()  )) then
        self:CastQ(target)
      end
      if((IsReady(_E) and (myHero.mana / myHero.maxMana > menu.combo.Mana:Value() /100 )and GetDistance(target) < 1200 and menu.combo.useE:Value() and menu.combo.combokey:Value()  ))then
        self:CastE(target)
      end
      if((IsReady(_W) and (myHero.mana / myHero.maxMana > menu.combo.Mana:Value() /100 ) and GetDistance(target) < 700 and menu.combo.useW:Value() and  menu.combo.combokey:Value()  ))then
        self:CastW(target)
      end
      if menu.combo.logic:Value() == 1 then
        self:killr()
      elseif menu.combo.logic:Value() == 2 then
        self:needr()
      elseif menu.combo.logic:Value() == 3 then
        self:alwaysr()
      end

      if(menu.combo.useI:Value() and menu.combo.combokey:Value() )then
        for _, unit in pairs(GetEnemyHeroes()) do
          local dmgI =(50+ ((myHero.level)*20))
          local health=unit.health
          if(health<dmgI and menu.combo.useI:Value() and GetDistance(unit)<600)then
            self:CastI(unit)
          end
        end
      end
    end
    function Viktor:killsteal()
      for _, unit in pairs(GetEnemyHeroes()) do
        local health = unit.health
        local dmgE = self:GetEDmg(unit)
        if(GetDistance(unit)<1200 and  IsReady(_E) and health<dmgE and menu.killsteal.useE:Value() and GetDistance(unit)<700   and menu.killsteal.ks:Value())then
          self:CastE(unit)
        end
        local dmgQ = self:GetQDmg(unit)
        if(GetDistance(unit)<600 and  IsReady(_Q) and health<dmgQ and menu.killsteal.useQ:Value() and menu.killsteal.ks:Value() )then
          self:CastQ(unit)
        end
        local dmgI =(50+ ((myHero.level)*20))
        if(health<dmgI and menu.killsteal.useI:Value() and menu.killsteal.ks:Value() and GetDistance(unit)<600)then
          self:CastI(unit)
        end
        local dmgR =self:GetRDmg(unit)
        if(GetDistance(unit)<700 and  IsReady(_R) and health<dmgR and menu.killsteal.useR:Value() and menu.killsteal.ks:Value() and GetDistance(unit)<700)then
          self:CastR(unit)
        end
      end
    end
    function Viktor:GetQDmg(target)
      if GetCastLevel(myHero, _Q) < 1 then
        return 0
      end
      if IsReady(_Q) then
        local FinalDamage = (20 + (GetCastLevel(myHero, _Q) * 20)  +(GetBonusAP(myHero)*.2) + (GetBonusAP(myHero)*.5))
        return CalcDamage(myHero,target, 0,FinalDamage)
      else
        return 0
      end
    end
    function Viktor:GetQ2Dmg(target)
      if GetCastLevel(myHero, _Q) < 1 then
        return 0
      end
      if IsReady(_Q) then
        local FinalDamage = (20 + (GetCastLevel(myHero, _Q) * 20) + (GetBonusAP(myHero)*.2))
        return CalcDamage(myHero,target, 0,FinalDamage)
      else
        return 0
      end
    end
    function Viktor:GetEDmg(target)
      if GetCastLevel(myHero, _E) < 1 then
        return 0
      end
      if not ebuff and IsReady(_E) then
        local FinalDamage = (25 + (GetCastLevel(myHero, _E) * 45) + (GetBonusAP(myHero)*.7))
        return CalcDamage(myHero,target, 0,FinalDamage)
      elseif ebuff and IsReady(_E) then
        local FinalDamage =(25 + (GetCastLevel(myHero, _E) * 45) + (GetBonusAP(myHero)*.7)) + (25 + (GetCastLevel(myHero, _E) * 45) + (GetBonusAP(myHero)*.7))*0.4
        return CalcDamage(myHero,target, 0,FinalDamage)
      else
        return 0
      end
    end
    function Viktor:GetRDmg(target)
      if GetCastLevel(myHero, _R) < 1 then
        return 0
      end
      if IsReady(_R) then
        local Rdamage = (50 + (GetCastLevel(myHero, _R) * 100) + (GetBonusAP(myHero)*.55))
        local persecond = ( 14*(GetCastLevel(myHero, _R) * 15) + (GetBonusAP(myHero)*.1))
        local FinalDamage = Rdamage + persecond
        return CalcDamage(myHero,target, 0,FinalDamage)
      else
        return 0
      end
    end
    function Viktor:GetMyDmg(target)
      if IsReady(_Q) and IsReady(_R) and IsReady(_E) then
        return self:GetQDmg(target) + self:GetRDmg(target) + self:GetEDmg(target)
      elseif IsReady(_Q)  and IsReady(_R) then
        return self:GetQDmg(target) + self:GetRDmg(target)
      elseif IsReady(_Q)  and IsReady(_E) then
        return self:GetQDmg(target) + self:GetEDmg(target)
      elseif IsReady(_R) and IsReady(_E) then
        return self:GetRDmg(target) +self:GetEDmg(target)
      elseif IsReady(_Q) then
        return self:GetQDmg(target)
      elseif IsReady(_E) then
        return self:GetEDmg(target)
      elseif IsReady(_R) then
        return self:GetRDmg(target)
      elseif IsReady(_Q) and IsReady(_R) then
        return self:GetQDmg(target) + self:GetRDmg(target)
      else
        return 0
      end
    end
    function Viktor:GetDraws(target)
      local qdamage = self:GetQDmg(target)
      local edamage = self:GetEDmg(target)
      local rdamage = self:GetRDmg(target)
      local Idmg=(50+ ((myHero.level)*20))

      if qdamage >target.health then
        return 'Q', GoS.White
      elseif qdamage+ Idmg>target.health then
        return 'Q + Ignite', GoS.White
      elseif edamage >target.health then
        return 'E', GoS.White
      elseif edamage + Idmg>target.health then
        return 'E + Ignite', GoS.White
      elseif rdamage  >target.health then
        return 'R', GoS.White
      elseif rdamage + Idmg>target.health then
        return 'R + Ignite', GoS.White
      elseif rdamage +edamage  >target.health then
        return 'R + E',GoS.White
      elseif rdamage +edamage+ Idmg>target.health then
        return 'R + E + Ignite',GoS.White
      elseif qdamage+edamage>target.health then
        return 'Q + E',GoS.White
      elseif qdamage+rdamage >target.health then
        return 'Q + R',GoS.White
      elseif qdamage+edamage+ Idmg>target.health then
        return 'Q + E + Ignite',GoS.White
      elseif qdamage+rdamage+ Idmg>target.health then
        return 'Q + R + Ignite',GoS.White
      elseif qdamage+edamage+rdamage >target.health then
        return 'Kill with full combo',GoS.White
      elseif qdamage+edamage+rdamage+ Idmg>target.health then
        return 'Full Combo + Ignite',GoS.White
      else
        return "Cant Kill yet", GoS.White
      end
    end
    function Viktor:harass()
      if menu.harass.harasskey:Value() or menu.harass.harasstogle:Value()  then
        if(IsReady(_Q) and (myHero.mana / myHero.maxMana > menu.harass.Mana:Value() /100 ) and GetDistance(target) <= 700 and menu.harass.useQ:Value() ) then
          self:CastQ(target)
        end
        if(IsReady(_E) and (myHero.mana / myHero.maxMana > menu.harass.Mana:Value() /100 ) and GetDistance(target) <= 1200 and menu.harass.useE:Value()  and ValidTarget(target, self.ERange)) then
          self:CastE(target)
        end

      end
    end
    function Viktor:LastHit()
      for _, target in pairs(minionManager.objects) do
        -- print (self:GetEDmg(target))
        if IsObjectAlive(target) and GetTeam(target) == MINION_ENEMY then
          if menu.farm.lasthit.lasthitlogic:Value() == 1 then
            local Qdamage = self:GetQDmg(target)
            if(IsReady(_Q) and menu.farm.lasthit.useQ:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.lasthit.QMana:Value() /100 ) and ValidTarget(target,700)   and Qdamage >= GetCurrentHP(target)) then
              self:CastQ(target)
            end
            local Edamage = self:GetEDmg(target)
            if(IsReady(_E)and menu.farm.lasthit.useE:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.lasthit.EMana:Value() /100 )and  ValidTarget(target,925) and Edamage >= GetCurrentHP(target)) then
              self:CastE(target)
            end
          end
        end
      end
    end
    function Viktor:LaneClear()
      for i, minion in pairs(minionManager.objects) do
        if ValidTarget(minion) and minion ~= nil and GetTeam(minion) == MINION_ENEMY then
          if menu.farm.laneclear.useQ:Value() and ( myHero.mana / myHero.maxMana >= menu.farm.laneclear.QMana:Value() /100 ) and GetDistance(minion) <= 700 then
            self:CastQ(minion)
          end
        end
      end
      if (myHero.mana / myHero.maxMana >=  menu.farm.laneclear.EMana:Value() /100 ) then
        local NumberOfHits = menu.farm.laneclear.ecount:Value()
        if IsReady(_E) then
          if  menu.farm.laneclear.useE:Value()   then
            local BestPos, BestHit =  GetLineFarmPosition(1000 ,180, MINION_ENEMY)
            if BestPos   and  BestHit >= NumberOfHits then
              EStartPos = Vector(myHero) - 475 * (Vector(myHero) - Vector(BestPos)):normalized()
              CastSkillShot3(_E,EStartPos, BestPos)
            end
          end
        end
      end
    end
    function Viktor:JungleClear()
      for i, minion in pairs(minionManager.objects) do
        if ValidTarget(minion) and minion ~= nil and GetTeam(minion) == MINION_JUNGLE then
          if menu.farm.jungleclear.useQ:Value() and ( myHero.mana / myHero.maxMana >= menu.farm.jungleclear.QMana:Value() /100 ) and GetDistance(minion) <= 700 then
            self:CastQ(minion)
          end
        end
      end
      if (myHero.mana / myHero.maxMana >=  menu.farm.jungleclear.EMana:Value() /100 ) then
        local NumberOfHits = 1
        if IsReady(_E) then
          if  menu.farm.jungleclear.useE:Value()   then
            local BestPos, BestHit =  GetLineFarmPosition(1000 ,180, MINION_JUNGLE)
            if BestPos   and  BestHit >= NumberOfHits then
              EStartPos = Vector(myHero) - 475 * (Vector(myHero) - Vector(BestPos)):normalized()
              CastSkillShot3(_E,EStartPos, BestPos)
            end
          end
        end
      end
    end
    function Viktor:WndMsg(Msg, Key)
      if menu.targetsel.ts:Value() then
        if Msg == WM_LBUTTONDOWN then
          local minD = 10
          local starget = nil
          for i, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy) then
              if GetDistance(enemy, mousePos) <= minD or starget == nil then
                minD = GetDistance(enemy, mousePos)
                starget = enemy
              end
            end
          end
          if starget and minD < 150 then
            if self.selectedTar and starget.charName == self.selectedTar.charName then
              self.selectedTar = nil
              print("<font color=\"#FFFFFF\">Target <b>is no loger selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
            else
              self.selectedTar = starget
              print("<font color=\"#FFFFFF\">New target <b>selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
            end
          end
        end
      end
      if Msg == WM_LBUTTONDOWN then
        if PopUp1 then
          PopUp1 = false
        end
      end
    end
    function Viktor:onload()
     findorb()
    end
    function Viktor:LoadMenu()
      menu=MenuConfig( "menu",""..Scriptname.." [" .. myHero.charName.."]")


      menu:Menu("combo",loc_eng[1])
      menu.combo:Key("combokey", loc_eng[81], 32)
      menu.combo:Boolean("useQ", loc_eng[2], true)
      menu.combo:Boolean("useW", loc_eng[3], true)
      menu.combo:Boolean("useE", loc_eng[4], true)
      menu.combo:Boolean("useR", loc_eng[5], true)
      menu.combo:Boolean("useI", loc_eng[6], true)
      menu.combo:DropDown("logic", loc_eng[159],1, {loc_eng[160],loc_eng[217],loc_eng[172] })
      menu.combo:Slider("Mana",loc_eng[8], 10, 10, 100, 1)


      menu:Menu( "harass",loc_eng[9])
      menu.harass:Key("harasskey", loc_eng[83], string.byte("C"))
      menu.harass:Key("harasstogle", loc_eng[164],string.byte("T"))
      menu.harass:Boolean("useQ", loc_eng[10], true)
      menu.harass:Boolean("useE", loc_eng[12], true)
      menu.harass:Slider("Mana",loc_eng[8], 30, 10, 100, 1)

      menu:Menu( "farm",loc_eng[14])

      menu.farm:Menu("laneclear",loc_eng[15])
      menu.farm.laneclear:Boolean("useQ",loc_eng[16],true)
      menu.farm.laneclear:Boolean("useE",loc_eng[18],true)
      menu.farm.laneclear:Slider("ecount",loc_eng[182], 2, 1, 10, 1)
      menu.farm.laneclear:Info("blank", "")
      menu.farm.laneclear:Info("blank", "")
      menu.farm.laneclear:Info("info2", loc_eng[184])
      menu.farm.laneclear:Slider("QMana",loc_eng[185], 30, 10, 100, 1)
      menu.farm.laneclear:Slider("WMana",loc_eng[186], 30, 10, 100, 1)
      menu.farm.laneclear:Slider("EMana",loc_eng[187], 30, 10, 100, 1)


      menu.farm:Menu("jungleclear",loc_eng[20])
      menu.farm.jungleclear:Boolean("useQ",loc_eng[21],true)
      menu.farm.jungleclear:Boolean("useE",loc_eng[23],true)
      menu.farm.jungleclear:Info("blank", "")
      menu.farm.jungleclear:Info("blank", "")
      menu.farm.jungleclear:Info("info2", loc_eng[184])
      menu.farm.jungleclear:Slider("QMana",loc_eng[185], 30, 10, 100, 1)
      menu.farm.jungleclear:Slider("EMana",loc_eng[187], 30, 10, 100, 1)

      menu.farm:Menu("lasthit",loc_eng[25])
      menu.farm.lasthit:Boolean("autolasthit",loc_eng[189],false)
      menu.farm.lasthit:Boolean("useQ",loc_eng[26],true)
      menu.farm.lasthit:Boolean("useE",loc_eng[28],false)
      menu.farm.lasthit:DropDown("lasthitlogic",loc_eng[191], 1, {loc_eng[172],loc_eng[174]})
      menu.farm.lasthit:Info("blank", "")
      menu.farm.lasthit:Info("info2", loc_eng[184])
      menu.farm.lasthit:Slider("QMana",loc_eng[185], 30, 10, 100, 1)
      menu.farm.lasthit:Slider("EMana",loc_eng[186], 30, 10, 100, 1)

      menu.farm:Menu("clearkey",loc_eng[218])
      menu.farm.clearkey:Key("lasthitkey",loc_eng[215], string.byte("X"))
      menu.farm.clearkey:Key("laneclearkey", loc_eng[85], string.byte("V"))
      menu.farm.clearkey:Key("jungleclearkey", loc_eng[86],  string.byte("V"))

      menu:Menu( "killsteal",loc_eng[35])
      menu.killsteal:Boolean("ks",loc_eng[36],true)
      menu.killsteal:Boolean("useQ", loc_eng[37], true)
      menu.killsteal:Boolean("useW", loc_eng[38], true)
      menu.killsteal:Boolean("useE", loc_eng[39], true)
      menu.killsteal:Boolean("useR", loc_eng[40], true)
      menu.killsteal:Boolean("useI", loc_eng[41], true)


Activator:Loadmenu("ap")

      menu:Menu( "misc",loc_eng[92])
      menu.misc:Menu( "gapClose",loc_eng[219])
      menu.misc.gapClose:Boolean("w", loc_eng[220], true)
      menu.misc.gapClose:Info("info3", loc_eng[98] )
      menu.misc:Menu( "skinhack","[" .. myHero.charName.. "] - Skinhack Settings")
      menu.misc.skinhack:Boolean("useskin",loc_eng[54], false)
      menu.misc.skinhack:DropDown('selected' .. myHero.charName .. 'Skin', loc_eng[57]  ,  1, skinMeta[myHero.charName])
      menu.misc:Menu( "autolevel","[" .. myHero.charName.. "] - AutoLevel Settings")
      menu.misc.autolevel:Boolean("uselevel",loc_eng[51], false)
      menu.misc.autolevel:DropDown("logic", loc_eng[52] , 7, {loc_eng[58], loc_eng[59],loc_eng[60],loc_eng[61],loc_eng[62], loc_eng[63], loc_eng[64]  })
      menu.misc:Menu( "antiafk","[" .. myHero.charName.. "] - AntiAFK Settings")
      menu.misc.antiafk:Boolean("useafk",loc_eng[196], false)
      menu.misc:Menu( "interrupt",loc_eng[93])
      menu.misc.interrupt:Boolean("r", loc_eng[97], true)
      menu.misc.interrupt:Boolean("w", loc_eng[95],  true)
      menu.misc.interrupt:Info("info3", loc_eng[98] )
DelayAction(function()
  local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
  for i, spell in pairs(CHANELLING_SPELLS) do
    for _,k in pairs(GetEnemyHeroes()) do
        if spell["Name"] == GetObjectName(k) then
        menu.misc.interrupt:Boolean(GetObjectName(k).."Inter", "On "..GetObjectName(k).." "..(type(spell.Spellslot) == 'number' and str[spell.Spellslot]), true)
        end
    end
  end
end, 0.35)
      Clock = os.clock()


      menu:Menu("other",loc_eng[65])
      --menu.other:Menu("Show Damage On Hp Bar", "HPBAR")
      --menu.other.HPBAR:Boolean("key","ON/OFF",true)
      menu.other:Menu("draw",loc_eng[66])
      menu.other.draw:Boolean("qdraw",loc_eng[67],true)
      menu.other.draw:Boolean("wdraw",loc_eng[68],true)
      menu.other.draw:Boolean("edraw",loc_eng[69],true)
      menu.other.draw:Boolean("rdraw",loc_eng[70],true)
      menu.other.draw:Boolean("aadraw",loc_eng[71],false)
      menu.other:Menu( "color",loc_eng[198])
      menu.other.color:ColorPick("Qcolor", loc_eng[199],{255, 255, 255, 255})
      menu.other.color:ColorPick("Wcolor", loc_eng[200],{255, 255, 255, 255})
      menu.other.color:ColorPick("Ecolor", loc_eng[201],{255, 255, 255, 255})
      menu.other.color:ColorPick("Rcolor", loc_eng[202],{255, 255, 255, 255})
      menu.other.color:ColorPick("E2color", loc_eng[203],{255, 255, 255, 255})
      menu.other.color:ColorPick("AAcolor", loc_eng[204],{255, 255,0,0})
      -- menu.other.color:ColorPick("targetselect", loc_eng[205],{255, 255,0,0})
      menu.other:Menu( "width",loc_eng[206])
      menu.other.width:Slider("Qwidth", loc_eng[210], 1, 1, 10, 1)
      menu.other.width:Slider("Wwidth", loc_eng[211], 1, 1, 10, 1)
      menu.other.width:Slider("Ewidth", loc_eng[212], 1, 1, 10, 1)
      menu.other.width:Slider("Rwidth", loc_eng[213], 1, 1, 10, 1)
      menu.other.width:Slider("AAwidth", loc_eng[209], 1, 1, 10, 1)
      -- menu.other.width:Slider("STwidth", loc_eng[208], 1, 1, 10, 1)
      --menu.other:Menu( "perma",loc_eng[73])
      -- menu.other.perma:Boolean("perma",loc_eng[74],true)
      menu.other:Boolean("target",loc_eng[75],true)
      menu.other:Boolean("damage",loc_eng[214],true)
      menu.other:Boolean("targetcal",loc_eng[76],true)

      menu:Menu("targetsel",loc_eng[77])
      menu.targetsel:Boolean("ts",loc_eng[78], false)

      menu:Menu("orb","Orbwalker Settings")
      menu.orb:Menu( "selectorb","Current Orbwalker :")

      menu:Menu("pred","Prediction Settings")
      menu.pred:DropDown("selectpred","Current Predictions :",   1, {"Open Prediction","IPrediction","Gos Prediction"})
      menu.pred:Menu( "hcgeneral","Hitchance Settings")
      menu.pred.hcgeneral:Menu( "hcop","Open Prediction Hitchance")
      menu.pred.hcgeneral.hcop:Slider("hcopw", "W Hitchance " , 30, 0, 100, 1)
      menu.pred.hcgeneral.hcop:Slider("hcope", "E Hitchance " , 30, 0, 100, 1)
      menu.pred.hcgeneral.hcop:Slider("hcopr", "r Hitchance " , 30, 0, 100, 1)
      menu.pred:Info("blank", "    Currently Open Prediction "   )
      menu.pred:Info("blank", "      is best with this bundle"   )


      menu:Info("infoK","           "..Scriptname.."" )
      menu:Info("infoK","         Script Version:  "..Version.. "  " )
      menu:Info("infoK","   Script was made by  "..Author.. "" )
      menu:Info("infoK","Leauge Of Legends Version: "..LVersion.. "" )
      menu:Boolean("instruct", loc_eng[216], false)

    end

class "Leblanc"
---//==================================================\\---
--|| > Leblanc İnit                          ||--
---\\==================================================//---
local qbuff1 = false
function Leblanc:__init()
        if not libloaded then return end
  self.Q = {  range = 700 }
  self.W = { delay = 0.50, speed = 1300, width = 125, range = 600 , radius = 250 } --AOE true , Col false
  self.E = { delay = 0.25, speed = 1700, width = 55, range = 900 } --AOE false , Col true
  self.RW = { delay = 0.50, speed = 1300, width = 125, range = 600 , radius = 250 } --AOE true , Col false
  self.RE = { delay = 0.25, speed = 1750, width = 55, range = 925 } --AOE false , Col true
    rSpell = IPrediction.Prediction({range = 600, speed = 1300, delay = 0.50, width = 125, type = "linear", name =myHero:GetSpellData(_R).name, collision = false})
    wSpell  = IPrediction.Prediction({range = 600, speed = 1300, delay = 0.50, width = 125, type = "linear",name =myHero:GetSpellData(_W).name,  collision = false})
    eSpell = IPrediction.Prediction({range = 925, speed = 1750, delay = 0.25, width = 55, type = "linear", name =myHero:GetSpellData(_E).name, collision = true})
  self.tse = TargetSelector(925,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
  self.tsg = TargetSelector(950,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
  self:LoadMenu()
  Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
  lastSkin = 0
  Last_LevelSpell = 0
  Callback.Add("Load", function() self:onload() end)
  Callback.Add("Tick", function() self:Tick() end)
  Callback.Add("WndMsg", function(Msg, Key) self:WndMsg(Msg, Key) end)
  Callback.Add("UpdateBuff", function(unit,buff) self:UpdateBuff(unit,buff) end)
  Callback.Add("RemoveBuff", function(unit,buff) self:RemoveBuff(unit,buff) end)
  Callback.Add("Draw", function() self:Draw() end)
  -- Callback.Add("ProcessSpell", function(x,y) self:ProcessSpell(x,y) end)
  --Callback.Add("ProcessSpellComplete", function(x,y) self:ProcessSpellComplete(x,y) end)
end
---//==================================================\\---
--|| > Leblanc Menu                            ||--
---\\==================================================//---
function Leblanc:onload()
  findorb()
end
function Leblanc:LoadMenu()
  menu=MenuConfig("menu",""..Scriptname.." [" .. myHero.charName.."]" )
  menu:Menu("combo",loc_eng[1])
  menu.combo:Boolean("useQ", loc_eng[2], true)
  menu.combo:Boolean("useW", loc_eng[3], true)
  menu.combo:Boolean("useE", loc_eng[4], true)
  menu.combo:Boolean("useR", loc_eng[5], true)
  menu.combo:Boolean("useI", loc_eng[6], true)
  --menu.combo:Boolean("gapclose", "Use W as a gapclose ( Beta )", false)
  menu.combo:DropDown("logic", loc_eng[7],   1, {loc_eng[116], loc_eng[117], loc_eng[118], loc_eng[119] ,"W>R>Q>E","W>Q>R>E","Q>R>W>E","Double Stun",loc_eng[120]})
  menu.combo:Menu( "turnw",loc_eng[121])
  menu.combo.turnw:DropDown("wbackhp", loc_eng[171]  ,  1, {loc_eng[172],loc_eng[173],loc_eng[174]})
  menu.combo.turnw:Slider("hp",loc_eng[104]   , 30, 10, 100, 1)
  menu.combo.turnw:DropDown("wbackcp", loc_eng[176] ,   1, {loc_eng[172],loc_eng[173],loc_eng[174]})
  menu.combo.turnw:DropDown("enemy",loc_eng[175]  ,  1, {loc_eng[130], loc_eng[131] , loc_eng[132],loc_eng[133] })
  menu.combo.turnw:Info("info2", loc_eng[177]   )
  menu.combo.turnw:Boolean("w1",loc_eng[122], false)
  menu.combo.turnw:Boolean("w2",loc_eng[123], false)
  menu.combo.turnw:Boolean("w3",loc_eng[124], false)
  menu.combo.turnw:Boolean("w4",loc_eng[125], false)
  menu.combo.turnw:Boolean("w5",loc_eng[178], false)
  menu.combo.turnw:Boolean("w6",loc_eng[179], false)
  menu.combo.turnw:Boolean("w7"," Q>R>E>W mode ", false)
  menu.combo.turnw:Boolean("w8"," Double Stun mode ", false)
  menu.combo.turnw:Boolean("w9",loc_eng[126], false)
  menu.combo:Slider("delay", "Delay For Double Stun" , 1650, 0, 3000, 1)
  menu.combo:Slider("Mana",loc_eng[8]   , 10, 10, 100, 1)

  menu:Menu( "harass",loc_eng[9])
  menu.harass:DropDown("logic","Harass Logic" ,   1, {"[ Q-W ]","[ Q-E ]","[ W-R ]"})
  menu.harass:Boolean("useQ", loc_eng[10], true)
  menu.harass:Boolean("useW", loc_eng[11], true)
  menu.harass:Boolean("useE", loc_eng[12], true)
  menu.harass:Boolean("useR", loc_eng[13], true)
  menu.harass:Slider("Mana",loc_eng[8]   , 10, 10, 100, 1)

  menu:Menu( "farm",loc_eng[14])

  menu.farm:Menu("laneclear",loc_eng[15])
  menu.farm.laneclear:Boolean("useQ",loc_eng[16], true)
  menu.farm.laneclear:Boolean("useW",loc_eng[17], true)
  menu.farm.laneclear:Slider("wcount",loc_eng[181]   , 2, 1, 10, 1)
  menu.farm.laneclear:Boolean("useR",loc_eng[19], false)
  menu.farm.laneclear:Slider("rcount",loc_eng[183]   , 2, 1, 10, 1)
  menu.farm.laneclear:Info("blank", ""   )
  menu.farm.laneclear:Info("blank", ""   )
  menu.farm.laneclear:Info("info2", loc_eng[184]   )
  menu.farm.laneclear:Slider("QMana",loc_eng[185]   , 30, 10, 100, 1)
  menu.farm.laneclear:Slider("WMana",loc_eng[186]   , 30, 10, 100, 1)
  menu.farm.laneclear:Slider("EMana",loc_eng[187]   , 30, 10, 100, 1)
  menu.farm.laneclear:Slider("RMana",loc_eng[188]   , 30, 10, 100, 1)

  menu.farm:Menu("jungleclear",loc_eng[20])
  menu.farm.jungleclear:Boolean("useQ",loc_eng[21], true)
  menu.farm.jungleclear:Boolean("useW",loc_eng[22], true)
  menu.farm.jungleclear:Boolean("useE",loc_eng[23], true)
  menu.farm.jungleclear:Boolean("useR",loc_eng[24], false)
  menu.farm.jungleclear:Info("blank", ""   )
  menu.farm.jungleclear:Info("blank", ""   )
  menu.farm.jungleclear:Info("info2", loc_eng[184]   )
  menu.farm.jungleclear:Slider("QMana",loc_eng[185]   , 30, 10, 100, 1)
  menu.farm.jungleclear:Slider("WMana",loc_eng[186]   , 30, 10, 100, 1)
  menu.farm.jungleclear:Slider("EMana",loc_eng[187]   , 30, 10, 100, 1)
  menu.farm.jungleclear:Slider("RMana",loc_eng[188]   , 30, 10, 100, 1)

  menu.farm:Menu("lasthit",loc_eng[25])
  menu.farm.lasthit:Boolean("autolasthit",loc_eng[189], false)
  menu.farm.lasthit:Boolean("useQ",loc_eng[26], true)
  menu.farm.lasthit:Boolean("useE",loc_eng[28], true)
  menu.farm.lasthit:DropDown("lasthitlogic",loc_eng[191],   1, {loc_eng[172],loc_eng[174]})
  menu.farm.lasthit:Info("blank", ""   )
  menu.farm.lasthit:Info("blank", ""   )
  menu.farm.lasthit:Info("info2", loc_eng[184]   )
  menu.farm.lasthit:Slider("QMana",loc_eng[185]   , 30, 10, 100, 1)
  menu.farm.lasthit:Slider("EMana",loc_eng[187]   , 30, 10, 100, 1)

  menu:Menu("escape",loc_eng[30])
  menu.escape:Boolean("useW",loc_eng[32], true)
  menu.escape:Boolean("useR",loc_eng[34], false)


  menu:Menu("killsteal",loc_eng[35])
  menu.killsteal:Boolean("ks",loc_eng[36], true)
  menu.killsteal:Boolean("useQ", loc_eng[37], true)
  menu.killsteal:Boolean("useW", loc_eng[38], true)
  menu.killsteal:Boolean("useE", loc_eng[39], true)
  menu.killsteal:Boolean("useR", loc_eng[40], true)
  menu.killsteal:Boolean("useQW", loc_eng[127], true)
  menu.killsteal:Boolean("useI", loc_eng[41], true)

Activator:Loadmenu("ap")

  menu:Menu( "misc",loc_eng[92])
  menu.misc:Menu( "walljump","[" .. myHero.charName.. "] - Wall Jump Settings")
  menu.misc.walljump:Boolean("Draw", "Draw Wall Jump Locations", true)
  menu.misc.walljump:Boolean("Drawr", "Use Range While Drawing", false)
  menu.misc.walljump:Slider("Drawrrange", "Draw Locations If Range >" , 10, 1000, 10000, 1)
  menu.misc.walljump:Info("blank", ""   )
  menu.misc.walljump:Info("blank", "        [Color Settings]"   )
  menu.misc.walljump:ColorPick("fcolor", "Location 1 Color",   {255, 255, 255, 255})
  menu.misc.walljump:ColorPick("f2color", "Location 2 Color",   {255, 255, 255, 255})
  menu.misc:Menu( "skinhack","[" .. myHero.charName.. "] - Skinhack Settings")
  menu.misc.skinhack:Boolean("useskin",loc_eng[54], false)
  menu.misc.skinhack:DropDown('selected' .. myHero.charName .. 'Skin', loc_eng[57]  ,  1, skinMeta[myHero.charName])
  menu.misc:Menu( "autolevel","[" .. myHero.charName.. "] - AutoLevel Settings")
  menu.misc.autolevel:Boolean("uselevel",loc_eng[51], false)
  menu.misc.autolevel:DropDown("logic", loc_eng[52] , 7, {loc_eng[58], loc_eng[59],loc_eng[60],loc_eng[61],loc_eng[62], loc_eng[63], loc_eng[64]  })
  menu.misc:Menu( "antiafk","[" .. myHero.charName.. "] - AntiAFK Settings")
  menu.misc.antiafk:Boolean("useafk",loc_eng[196], false)

  Clock = os.clock()


  menu:Menu("other",loc_eng[65])
  menu.other:Menu( "draw",loc_eng[66])
  menu.other.draw:Boolean("qdraw",loc_eng[67], true)
  menu.other.draw:Boolean("wdraw",loc_eng[68], true)
  menu.other.draw:Boolean("edraw",loc_eng[69], true)
  menu.other.draw:Boolean("rdraw",loc_eng[70], true)
  menu.other.draw:Boolean("aadraw",loc_eng[71], false)
  --menu.other.draw:Boolean("rtdraw",loc_eng[197], false)
  menu.other:Menu( "color", loc_eng[198])
  menu.other.color:ColorPick("Qcolor", loc_eng[199],   {255, 255, 255, 255})
  menu.other.color:ColorPick("Wcolor", loc_eng[200],   {255, 255, 255, 255})
  menu.other.color:ColorPick("Ecolor", loc_eng[201],   {255, 255, 255, 255})
  menu.other.color:ColorPick("Rcolor", loc_eng[202],   {255, 255, 255, 255})
  menu.other.color:ColorPick("E2color", loc_eng[203],   {255, 255, 255, 255})
  menu.other.color:ColorPick("AAcolor", loc_eng[204],   {255, 255,0,0})
  -- menu.other.color:ColorPick("targetselect", loc_eng[205],   {255, 255,0,0})
  menu.other:Boolean("combomode",loc_eng[72], true)
  --menu.other:Menu( "perma",loc_eng[73])
  --menu.other.perma:Boolean("perma",loc_eng[74], true)
  -- menu.other:Boolean("target",loc_eng[75], true)
  menu.other:Boolean("damage",loc_eng[214], true)
  menu.other:Boolean("targetcal",loc_eng[76], true)

  menu:Menu("targetsel",loc_eng[77])
  menu.targetsel:Info("infoK2", ""   )
  menu.targetsel:Info("infoK", ""   )
  menu.targetsel:Boolean("ts",loc_eng[78], false)


  menu:Menu("orb","Orbwalker Settings")
  menu.orb:Menu( "selectorb","Current Orbwalker :")

  menu:Menu("pred","Prediction Settings")
  menu.pred:DropDown("selectpred","Current Predictions :",   1, {"Open Prediction","IPrediction","Gos Prediction"})
  menu.pred:Menu( "hcgeneral","Hitchance Settings")
  menu.pred.hcgeneral:Menu( "hcop","Open Prediction Hitchance")
  menu.pred.hcgeneral.hcop:Slider("hcopw", "W Hitchance " , 30, 0, 100, 1)
  menu.pred.hcgeneral.hcop:Slider("hcope", "E Hitchance " , 30, 0, 100, 1)
  menu.pred.hcgeneral.hcop:Slider("hcopr", "r Hitchance " , 30, 0, 100, 1)
  menu.pred:Info("blank", "    Currently Open Prediction "   )
  menu.pred:Info("blank", "      is best with this bundle"   )


  menu:Menu( "Keys",loc_eng[79])
  menu.Keys:Info("infoK3", loc_eng[80]   )
  menu.Keys:Key("combokey", loc_eng[81], string.byte(" "))
  menu.Keys:Key("onlye", loc_eng[128], string.byte("O"))
  menu.Keys:Key("combomode", loc_eng[129],  string.byte("2"))
  menu.Keys:Info("infoK4", loc_eng[82]   )
  menu.Keys:Key("harasskey", loc_eng[83],    string.byte("C"))
  -- menu.Keys:Boolean("harasstoglekey", "Harass Togle Key",, string.byte("T"))
  menu.Keys:Info("infoK5", loc_eng[84]   )
  menu.Keys:Key("lasthitkey",loc_eng[215],    string.byte("X"))
  menu.Keys:Key("laneclearkey", loc_eng[85],    string.byte("V"))
  menu.Keys:Key("jungleclearkey", loc_eng[86],    string.byte("V"))
  --menu.Keys:Boolean("lasthitkey", "Lasthit Key",    string.byte("X"))
  menu.Keys:Info("infoK6", loc_eng[87]   )
  menu.Keys:Key("escapekey", loc_eng[88],    string.byte("Y"))
  menu.Keys:Key("wallkey", "Wall Jump Key",    string.byte("T"))
  menu.Keys:Info("infoK", "Make Sure That Your Orbwalker"   )
  menu.Keys:Info("infoK2", loc_eng[89]   )

  --menu:Boolean("lang", loc_eng[165]    1, {loc_eng[166], loc_eng[167],loc_eng[168]})
  menu:Info("infoK","           "..Scriptname.."" )
  menu:Info("infoK","         Script Version:  "..Version.. "  " )
  menu:Info("infoK","   Script was made by  "..Author.. "" )
  menu:Info("infoK","Leauge Of Legends Version: "..LVersion.. "" )
  menu:Boolean("instruct", loc_eng[216], false)


end
---//==================================================\\---
--|| > Leblanc Tick                         ||--
---\\==================================================//---
function Leblanc:Tick()
  self:Checks()
  if(menu.Keys.combokey:Value() )then
    self:combo()
  end
  self:autowback()
  if menu.Keys.wallkey:Value() then self:walljump() end
  Antiafk()
  autolevel()
  skinhack()
  autopot()
Activator:Useitems("ap")
  if( menu.Keys.lasthitkey:Value() or menu.farm.lasthit.autolasthit:Value() )then
    self:LastHit()
  end
  if(menu.Keys.onlye:Value()   )then
    self:onlye()
  end
  if(menu.Keys.escapekey:Value() )then
    self:escape()
  end
  if(menu.killsteal.ks:Value() ) then
    self:killsteal()
  end
  if(menu.Keys.harasskey:Value()   ) then
    self:harass()
  end
  if(menu.Keys.laneclearkey:Value() )then
    self:LaneClear()
  end
  if(menu.Keys.jungleclearkey:Value() )then
    self:JungleClear()
  end
  if menu.instruct:Value() then
    menu.instruct:Value(false)
    PopUp1 = true
  end
end
function Leblanc:Checks()
  Gtarget = self.tsg:GetTarget()
  if not ValidTarget(Gtarget, 925) or not menu.targetsel.ts:Value()  then
    target = GetCurrentTarget()
  elseif  ValidTarget(Gtarget, 925) and not self.selectedTar then
    target = GetCurrentTarget()
  elseif (ValidTarget(Gtarget, 925) and self.selectedTar) then
    target = self.selectedTar
  end
  Etarget = self.tse:GetTarget()
  mousePos = GetMousePos()
  Activator:Loaditems("ap")
end
---//==================================================\\---
--|| > Leblanc Drawings                                ||--
---\\==================================================//---
function Leblanc:combomode()
  local drawpos = GetHPBarPos(myHero)
  if menu.combo.logic:Value()  == 1 then
    DrawText("Current Combo Mode: Q>E>W>R", 12, drawpos.x-40, drawpos.y+16, 0xff00ffff) end
    if menu.combo.logic:Value()  == 2 then
      DrawText("Current Combo Mode: Q>R>E>W", 12, drawpos.x-40, drawpos.y+16, 0xff00ffff) end
      if menu.combo.logic:Value()  == 3 then
        DrawText("Current Combo Mode: E>Q>W>R", 12, drawpos.x-40, drawpos.y+16, 0xff00ffff) end
        if menu.combo.logic:Value()  == 4 then
          DrawText("Current Combo Mode: E>W>Q>R", 12, drawpos.x-40, drawpos.y+16, 0xff00ffff) end
          if menu.combo.logic:Value()  == 5 then
            DrawText("Current Combo Mode: W>R>Q>E", 12, drawpos.x-40, drawpos.y+16, 0xff00ffff) end
            if menu.combo.logic:Value()  == 6 then
              DrawText("Current Combo Mode: W>Q>R>E", 12, drawpos.x-40, drawpos.y+16, 0xff00ffff) end
              if menu.combo.logic:Value()  == 7 then
                DrawText("Current Combo Mode: Q>R>W>E", 12, drawpos.x-40, drawpos.y+16, 0xff00ffff) end
                if menu.combo.logic:Value()  == 8 then
                  DrawText("Current Combo Mode: Double Stun", 12, drawpos.x-40, drawpos.y+16, 0xff00ffff) end
                  if menu.combo.logic:Value()  == 9 then
                    DrawText("Current Combo Mode: Random Skill Order", 12, drawpos.x-40, drawpos.y+16, 0xff00ffff) end
                  end
                  function Leblanc:Draw()
                    if menu.other.combomode:Value() then
                      self:combomode()
                    end
                    if menu.misc.walljump.Draw:Value()then
                      if menu.misc.walljump.Drawr:Value() then
                        for k, v in pairs(lbspot) do
                          if GetDistance(v, myHero) < menu.misc.walljump.Drawrrange:Value() then
                            DrawCircle(v.x, v.y, v.z, 100,1,0,menu.misc.walljump.fcolor:Value())
                          end
                        end
                        for k, v in pairs(lbspotend) do
                          if GetDistance(v, myHero) < menu.misc.walljump.Drawrrange:Value() then
                            DrawCircle(v.x, v.y, v.z, 100,1,0, menu.misc.walljump.f2color:Value())
                          end
                        end
                      elseif not menu.misc.walljump.Drawr:Value() then
                        for k, v in pairs(lbspot) do
                          DrawCircle(v.x, v.y, v.z, 100,1,0,menu.misc.walljump.fcolor:Value())
                        end
                        for k, v in pairs(lbspotend) do
                          DrawCircle(v.x, v.y, v.z, 100,1,0, menu.misc.walljump.f2color:Value())
                        end
                      end
                    end

                    if menu.other.draw.qdraw:Value() and IsReady(_Q) then
                      DrawCircle(myHero.x, myHero.y, myHero.z, 650,1,0,menu.other.color.Qcolor:Value())
                    end

                    if menu.other.draw.wdraw:Value() and IsReady(_W) then
                      DrawCircle(myHero.x, myHero.y, myHero.z, 600,1,0,menu.other.color.Wcolor:Value())
                    end

                    if menu.other.draw.edraw:Value() and IsReady(_E) then
                      DrawCircle(myHero.x, myHero.y, myHero.z, 925,1,0,menu.other.color.Ecolor:Value())
                    end

                    if menu.other.draw.rdraw:Value() and IsReady(_R) then
                      DrawCircle(myHero.x, myHero.y, myHero.z, 700,1,0,menu.other.color.Rcolor:Value())
                    end
                    if menu.other.draw.aadraw:Value() then
                      DrawCircle(myHero.x, myHero.y, myHero.z, 550,1,0, menu.other.color.AAcolor:Value())
                    end

                    for _, target in pairs(GetEnemyHeroes()) do
                      if ValidTarget(target, 15000) then
                        if target.visible and not target.dead and menu.other.damage:Value() then
                          currLine = 1
                          -- DrawLineHPBar2(self:GetMyDmg(target),"",  target, currLine)
                          DrawLineHPBar(self:GetMyDmg(target), "Damage " .. math.round(self:GetMyDmg(target)),target,currLine)
                          currLine = currLine + 1
                          DrawDmgOverHpBar(target,GetCurrentHP(target),0,self:GetMyDmg(target),0xff00ff00)
                        end
                      end
                    end
                    if menu.other.targetcal:Value() and not myHero.dead then
                      if target and target ~= nil then
                        --  local target= GetOrigin(target)
                        local drawpos=WorldToScreen(1,target.x, target.y, target.z)
                        local comboText,color = self:GetDraws(target)
                        if comboText then
                          DrawText(comboText,15,drawpos.x-20,drawpos.y-20,color)
                        end
                      end
                    end
                  Global:Commondraw()
                  end
                  ---//==================================================\\---
                  --|| > Leblanc Harass             ||--
                  ---\\==================================================//---
                  function Leblanc:harass()
                    if menu.harass.logic:Value() == 1 then
                      if menu.Keys.harasskey:Value()  and (myHero.mana / myHero.maxMana >=  menu.harass.Mana:Value() /100 )  then
                        self:CastQWH(target)
                      end
                    elseif menu.harass.logic:Value() == 2 then
                      if menu.Keys.harasskey:Value()  and (myHero.mana / myHero.maxMana >=  menu.harass.Mana:Value() /100 )  then
                        self:CastQEH(target)
                      end
                    elseif menu.harass.logic:Value() == 3 then
                      if menu.Keys.harasskey:Value()  and (myHero.mana / myHero.maxMana >=  menu.harass.Mana:Value() /100 )  then
                        self:CastWRH(target)
                      end
                    end
                  end
                  ---//==================================================\\---
                  --|| > Leblanc Wall Jump            ||--
                  ---\\==================================================//---
                  function Leblanc:walljump()
                    if not IsReady(_W) or self:wUsed() then return end
                    for k, loc in pairs(lbspot) do
                      if GetDistance(loc, myHero) < 250 and GetDistance(loc, myHero) > 50 then
                        MoveToXYZ(loc.x, loc.y, loc.z)
                      end
                      if GetDistance(loc, myHero) < 20 and not self:wUsed()  then
                        CastSkillShot(_W, lbspotend[k].x,lbspotend[k].y, lbspotend[k].z)
                        --myHero:MoveTo(lbspotend[k].x, lbspotend[k].z)
                      end
                    end

                    for k, loc in pairs(lbspotend) do
                      if GetDistance(loc, myHero) < 250 and GetDistance(loc, myHero) > 50 then
                        MoveToXYZ(loc.x, loc.y, loc.z)
                      end
                      if GetDistance(loc, myHero) < 20 and not self:wUsed()  then
                        CastSkillShot(_W, lbspot[k].x,lbspot[k].y, lbspot[k].z)
                        --myHero:MoveTo(lbspot[k].x, lbspot[k].z)
                      end
                    end
                  end
                  function Leblanc:escape()
                    if menu.Keys.escapekey:Value()  and menu.escape.useW:Value() and not self:wUsed() then
                      CastSkillShot(_W, mousePos)
                    end
                    if menu.Keys.escapekey:Value()  then
                      self:walk()
                    end
                    if menu.Keys.escapekey:Value()  and menu.escape.useR:Value() and not  self:rUsed() then
                      CastSkillShot(_R, mousePos)
                    end
                  end
                  function Leblanc:walk()
                    MoveToXYZ(mousePos)
                  end
                  function Leblanc:autowback()
                    if GetCastName(myHero,_W) == "LeblancSlideReturn" then
                      if menu.combo.turnw.wbackhp:Value() == 1 and menu.Keys.combokey:Value() then
                        if myHero.health <= (myHero.maxHealth * menu.combo.turnw.hp:Value() / 100) then
                          CastSpell(_W)
                        end
                      end
                    end
                    if GetCastName(myHero,_W) == "LeblancSlideReturn" then
                      if menu.combo.turnw.wbackcp:Value() == 1 and menu.Keys.combokey:Value() then
                        if menu.combo.turnw.enemy:Value() == 1 then
                          if EnemiesAround(myHeroPos() , 550) >= 2 then
                            CastSpell(_W)
                          end
                        elseif menu.combo.turnw.enemy:Value() == 2 then
                          if EnemiesAround(myHeroPos() , 550) >= 3 then
                            CastSpell(_W)
                          end
                        elseif menu.combo.turnw.enemy:Value() == 3 then
                          if EnemiesAround(myHeroPos() , 550) >= 4 then
                            CastSpell(_W)
                          end
                        elseif menu.combo.turnw.enemy:Value() == 4 then
                          if EnemiesAround(myHeroPos() , 550) >= 5 then
                            CastSpell(_W)
                          end
                        end
                      end
                    end
                  end
                  ---//==================================================\\---
                  --|| > Leblanc Clear Settings                 ||--
                  ---\\==================================================//---
                  function Leblanc:LaneClear()
                    for i, minion in pairs(minionManager.objects) do
                      if ValidTarget(minion) and minion ~= nil and GetTeam(minion) == MINION_ENEMY then
                        if menu.Keys.laneclearkey:Value()  and menu.farm.laneclear.useQ:Value() and ( myHero.mana / myHero.maxMana >= menu.farm.laneclear.QMana:Value() /100 ) and GetDistance(minion) <= 700 then
                          self:CastQ(minion)
                        end
                      end
                    end
                    if (myHero.mana / myHero.maxMana >=  menu.farm.laneclear.WMana:Value() /100 ) then
                      local NumberOfHits = menu.farm.laneclear.wcount:Value()
                      if IsReady(_W) then
                        if  menu.farm.laneclear.useW:Value()   then
                          local BestPos, BestHit =  GetFarmPosition(self.W.range, self.W.width, MINION_ENEMY)
                          if BestPos   and  BestHit >= NumberOfHits then
                            CastSkillShot(_W, BestPos)
                          end
                        end
                      end
                    end
                    if (myHero.mana / myHero.maxMana >= menu.farm.laneclear.RMana:Value() /100 ) then
                      local NumberOfHits = menu.farm.laneclear.rcount:Value()
                      if IsReady(_R) then
                        if menu.Keys.laneclearkey:Value()  and menu.farm.laneclear.useR:Value() and GetCastName(myHero,_R) == 'LeblancSlideM'  then
                          local BestPos, BestHit = GetFarmPosition(self.RW.range, self.RW.width, MINION_ENEMY)
                          if BestPos  and BestHit >= NumberOfHits then
                            CastSkillShot(_R, BestPos)
                          end
                        end
                      end
                    end
                  end


                  function Leblanc:LastHit()
                    for _, target in pairs(minionManager.objects) do
                      if IsObjectAlive(target) and GetTeam(target) == MINION_ENEMY then
                        if menu.farm.lasthit.lasthitlogic:Value() == 1 then
                          local Qdamage = self:GetQ2Dmg(target)
                          if(IsReady(_Q) and menu.farm.lasthit.useQ:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.lasthit.QMana:Value() /100 ) and ValidTarget(target,700)   and Qdamage >= GetCurrentHP(target)) then
                            self:CastQ(target)
                          end
                          local Edamage = self:GetE2Dmg(target)
                          if(IsReady(_E)and menu.farm.lasthit.useE:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.lasthit.EMana:Value() /100 )and  ValidTarget(target,925) and Edamage >= GetCurrentHP(target)) then
                            self:CastE(target)
                          end
                        end
                      end
                    end
                  end
                  function Leblanc:UpdateBuff(unit,buff)
                    if unit and unit.team ~= myHero.team and unit.type == myHero.type then
                      if buff.Name:lower():find("leblancchaosorb") then
                        qbuff1 = true
                      end
                    end
                  end
                  function Leblanc:RemoveBuff(unit, buff)
                    if unit and unit.team ~= myHero.team and unit.type == myHero.type then
                      if buff.Name:lower():find("leblancchaosorb") then

                        qbuff1 = false
                      end
                    end
                  end
                  function Leblanc:JungleClear()
                    for i, minion in pairs(minionManager.objects) do
                      if ValidTarget(minion) and minion ~= nil and GetTeam(minion) == MINION_JUNGLE then
                        if menu.Keys.jungleclearkey:Value()  and menu.farm.jungleclear.useQ:Value() and ( myHero.mana / myHero.maxMana >= menu.farm.jungleclear.QMana:Value() /100 ) and GetDistance(minion) <= 700 then
                          self:CastQ(minion)
                        end
                      end
                    end
                    for i, minion in pairs(minionManager.objects) do
                      if ValidTarget(minion) and minion ~= nil and GetTeam(minion) == MINION_JUNGLE then
                        if menu.Keys.jungleclearkey:Value()  and menu.farm.jungleclear.useE:Value() and ( myHero.mana / myHero.maxMana >= menu.farm.jungleclear.EMana:Value() /100 ) and GetDistance(minion) <= 700 then
                          self:CastE(minion)
                        end
                      end
                    end
                    if (myHero.mana / myHero.maxMana >=  menu.farm.jungleclear.WMana:Value() /100 ) then
                      if IsReady(_W) then
                        if  menu.farm.jungleclear.useW:Value()   then
                          local BestPos, BestHit =  GetFarmPosition(self.W.range, self.W.width, MINION_JUNGLE)
                          if BestPos   and  BestHit >= 1 then
                            CastSkillShot(_W, BestPos)
                          end
                        end
                      end
                    end
                    if (myHero.mana / myHero.maxMana >= menu.farm.jungleclear.RMana:Value() /100 ) then
                      if IsReady(_R) then
                        if menu.Keys.jungleclearkey:Value()  and menu.farm.jungleclear.useR:Value() and GetCastName(myHero,_R) == 'LeblancSlideM'  then
                          local BestPos, BestHit = GetFarmPosition(self.RW.range, self.RW.width, MINION_JUNGLE)
                          if BestPos  and BestHit >= 1 then
                            CastSkillShot(_R, BestPos)
                          end
                        end
                      end
                    end
                  end

            ---//==================================================\\---
            --|| > Leblanc Casting    // Basics                    ||--
            ---\\==================================================//---
            function Leblanc:CastQ(unit)
              if IsReady(_Q) then
                CastTargetSpell(unit, _Q)
              end
            end
            function Leblanc:CastW(unit)
              if menu.pred.selectpred:Value() == 1 then
                local WPred = GetCircularAOEPrediction(unit, self.W)
                if IsReady(_W) then
                  if WPred  and WPred.hitChance >= (menu.pred.hcgeneral.hcop.hcopw:Value()/100) then
                    CastSkillShot(_W, WPred.castPos)
                  end
                end
              elseif  menu.pred.selectpred:Value() == 2 then
                  local HitChance, y = wSpell:Predict(unit)
                  if IsReady(_W) and HitChance >= 3 then
                    CastSkillShot(_W, y.x, y.y, y.z)
                  end
              elseif menu.pred.selectpred:Value() == 3 then
                local wPred = GetPredictionForPlayer(myHeroPos(), unit, GetMoveSpeed(unit), 1300, 500, 600, 125, false, true)
                if IsReady(_W) and wPred.HitChance == 1 then
                  CastSkillShot(_W, wPred.PredPos.x, wPred.PredPos.y, wPred.PredPos.z)
                end
              end
            end
            function Leblanc:CastE(unit)
              if menu.pred.selectpred:Value() == 1 then
                local EPred = GetPrediction(unit, self.E)
                if IsReady(_E) then
                  if EPred  and EPred.hitChance >= (menu.pred.hcgeneral.hcop.hcope:Value()/100) and not EPred:mCollision(1) then
                    CastSkillShot(_E, EPred.castPos)
                  end
                end
              elseif  menu.pred.selectpred:Value() == 2 then
                  local HitChance, y = eSpell:Predict(unit)
                  if IsReady(_E) and HitChance >= 3 then
                    CastSkillShot(_E, y.x, y.y, y.z)
                  end
              elseif menu.pred.selectpred:Value() == 3 then
                local wPred = GetPredictionForPlayer(myHeroPos(), unit, GetMoveSpeed(unit), 1750, 250, 925, 55, true, true)
                if IsReady(_W) and wPred.HitChance == 1 then
                  CastSkillShot(_E, wPred.PredPos.x, wPred.PredPos.y, wPred.PredPos.z)
                end
              end
            end
            function Leblanc:CastR(unit)
              if menu.pred.selectpred:Value() == 1 then
                local WPred = GetCircularAOEPrediction(unit, self.W)
                if IsReady(_R) then
                  if WPred  and WPred.hitChance >= (menu.pred.hcgeneral.hcop.hcopr:Value()/100) then
                    CastSkillShot(_R, WPred.castPos)
                  end
                end
              elseif  menu.pred.selectpred:Value() == 2 then
                  local HitChance, y = rSpell:Predict(unit)
                  if IsReady(_R) and HitChance >= 3 then
                    CastSkillShot(_R, y.x, y.y, y.z)
                  end
              elseif menu.pred.selectpred:Value() == 3 then
                local wPred = GetPredictionForPlayer(myHeroPos(), unit, GetMoveSpeed(unit), 1300, 500, 600, 125, false, true)
                if IsReady(_R) and eSpell.HitChance == 1 then
                  CastSkillShot(_R, wPred.PredPos.x, wPred.PredPos.y, wPred.PredPos.z)
                end
              end
            end
            function Leblanc:CastRQ(unit)
              if GetCastName(myHero,_R) == 'LeblancChaosOrbM' then
                if IsReady(_R) then
                  CastTargetSpell(unit, _R)
                end
              end
            end
            function Leblanc:CastRE(unit)
              if menu.pred.selectpred:Value() == 1 then
                local EPred = GetPrediction(unit, self.E)
                if GetCastName(myHero,_R) == 'LeblancSoulShackleM' then
                  if IsReady(_R) then
                    if EPred  and EPred.hitChance >= (menu.pred.hcgeneral.hcop.hcopr:Value()/100) and not EPred:mCollision(1) then
                      CastSkillShot(_R, EPred.castPos)
                    end
                  end
                end
              elseif  menu.pred.selectpred:Value() == 2 then
                  local HitChance, y = rSpell:Predict(target)
                  if IsReady(_R) and HitChance >= 3 then
                    CastSkillShot(_R, y.x, y.y, y.z)
                  end
              elseif menu.pred.selectpred:Value() == 3 then
                local wPred = GetPredictionForPlayer(myHeroPos(), unit, GetMoveSpeed(unit), 1750, 250, 925, 55, true, true)
                if IsReady(_R) and wPred.HitChance == 1 then
                  CastSkillShot(_R, wPred.PredPos.x, wPred.PredPos.y, wPred.PredPos.z)
                end
              end
            end
            function Leblanc:CastI(unit)
              if Ignite then
                if IsReady(Ignite) then
                  CastTargetSpell(unit, Ignite)
                end
              end
            end
            ---//==================================================\\---
            --|| > Leblanc Casting    // Detailed                   ||--
            ---\\==================================================//---

            function Leblanc:CastQE(unit)
              if(GetDistance(target) <= 700 and menu.combo.useQ:Value()and  menu.Keys.combokey:Value()    and IsReady(_Q))then
                self:CastQ(unit)
              end
              if(GetDistance(target) <= 925 and menu.combo.useE:Value() and  menu.Keys.combokey:Value()   and IsReady(_E)) then
                self:CastE(unit)
              end
            end
            function Leblanc:CastEW(unit)
              if(GetDistance(target) <= 925 and menu.combo.useE:Value() and  menu.Keys.combokey:Value()    and IsReady(_E))then
                self:CastE(unit)
              end

              if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value()   and not self:wUsed() and IsReady(_W)) then
                self:CastW(unit)
              end
            end
            function Leblanc:CastEWB(unit)

              if(GetDistance(target) <= 925 and menu.combo.useE:Value() and  menu.Keys.combokey:Value()    and IsReady(_E))then
                self:CastE(unit)
              end

              if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value()  and IsReady(_W)) then
                self:CastW(unit)
              end
            end
            function Leblanc:CastQW(unit)

              if(GetDistance(target) <= 700 and menu.combo.useQ:Value() and  menu.Keys.combokey:Value()    and IsReady(_Q))then
                self:CastQ(unit)
              end

              if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value()   and not self:wUsed() and IsReady(_W)) then
                self:CastW(unit)
              end
            end
            function Leblanc:CastQWB(unit)

              if(GetDistance(target) <= 700 and menu.combo.useQ:Value() and  menu.Keys.combokey:Value()    and IsReady(_Q))then
                self:CastQ(unit)
              end

              if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value()  and IsReady(_W)) then
                self:CastW(unit)
              end
            end
            function Leblanc:CastWE(unit)

              if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value()   and not self:wUsed() and IsReady(_W)) then
                self:CastW(unit)
              end

              if(GetDistance(target) <= 925 and menu.combo.useE:Value() and  menu.Keys.combokey:Value()    and IsReady(_E))then
                self:CastE(unit)
              end
            end
            function Leblanc:CastWEB(unit)

              if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value()  and IsReady(_W)) then
                self:CastW(unit)
              end

              if(GetDistance(target) <= 925 and menu.combo.useE:Value() and  menu.Keys.combokey:Value()    and IsReady(_E))then
                self:CastE(unit)
              end
            end
            function Leblanc:CastQR(unit)


              if(GetDistance(target) <= 700 and menu.combo.useQ:Value() and  menu.Keys.combokey:Value()    and IsReady(_Q))then
                self:CastQ(unit)
              end

              if(GetDistance(target) <= 600  and menu.combo.useR:Value() and  menu.Keys.combokey:Value()   and IsReady(_R)) then
                self:CastRQ(unit)
              end
            end
            function Leblanc:CastWR(unit)

              if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value()    and IsReady(_W)and not self:wUsed())then
                self:CastW(unit)
              end

              if(GetDistance(target) <= 600 and menu.combo.useR:Value() and  menu.Keys.combokey:Value()   and IsReady(_R)) and not self:rUsed()  then
                self:CastR(unit)
              end
            end
            function Leblanc:CastWR2(unit)

              if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value()    and IsReady(_W)and not self:wUsed())then
                self:CastW(unit)
              end

              if(GetDistance(target) <= 600 and menu.combo.useR:Value() and  menu.Keys.combokey:Value()   and IsReady(_R)) then
                self:CastR(unit)
              end
            end
            function Leblanc:CastWQ(unit)

              if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value()    and IsReady(_W)and not self:wUsed())then
                self:CastW(unit)
              end

              if(GetDistance(target) <= 700 and menu.combo.useQ:Value() and  menu.Keys.combokey:Value()   and IsReady(_Q))  then
                self:CastQ(unit)
              end
            end
            function Leblanc:CastRE1(unit)

              if(GetDistance(target) <= 600 and menu.combo.useR:Value() and  menu.Keys.combokey:Value()   and IsReady(_R))   then
                self:CastRQ(unit)
              end

              if(GetDistance(target) <= 925 and menu.combo.useE:Value() and  menu.Keys.combokey:Value()   and IsReady(_E)) then
                self:CastE(unit)
              end
            end
            function Leblanc:CastER(unit)

              if(GetDistance(target) <= 925 and menu.combo.useE:Value() and  menu.Keys.combokey:Value()   and IsReady(_E)) then
                self:CastE(target)
              end

              if(GetDistance(target) <= 600 and menu.combo.useR:Value() and  menu.Keys.combokey:Value()   and GetCastName(myHero,_R) == 'LeblancSoulShackleM' and IsReady(_R))   then
                DelayAction(function() self:CastRE(target)end ,menu.combo.delay:Value()/1000)
              end
            end
            function Leblanc:CastWRB(unit)

              if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value()    and IsReady(_W))then
                self:CastW(unit)
              end

              if(GetDistance(target) <= 600 and menu.combo.useR:Value() and  menu.Keys.combokey:Value()   and IsReady(_R)) and not self:rUsed()  then
                self:CastR(unit)
              end
            end
            function Leblanc:CastWRB2(unit)

              if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value()   and IsReady(_W))then
                self:CastW(unit)
              end

              if(GetDistance(target) <= 600 and menu.combo.use:Value() and  menu.Keys.combokey:Value()   and IsReady(_R)) then
                self:CastR(unit)
              end
            end
            function Leblanc:CastWQB(unit)

              if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value()    and IsReady(_W))then
                self:CastW(unit)
              end

              if(GetDistance(target) <= 700 and menu.combo.useQ:Value() and  menu.Keys.combokey:Value()  and IsReady(_Q))  then
                self:CastQ(unit)
              end
            end
            function Leblanc:CastQWH(unit)

              if(GetDistance(target) <= 700 and menu.harass.useQ:Value() and  menu.Keys.harasskey:Value()  and IsReady(_Q) and IsReady(_W))then
                self:CastQ(unit)
              end

              if(GetDistance(target) <= 600 and menu.harass.useW:Value() and  menu.Keys.harasskey:Value()  and IsReady(_W) and not IsReady(_Q))then
                self:CastW(unit)
              end
            end
            function Leblanc:CastQEH(unit)

              if(GetDistance(target) <= 700 and menu.harass.useQ:Value() and  menu.Keys.harasskey:Value()  and IsReady(_Q) and IsReady(_E))then
                self:CastQ(unit)
              end

              if(GetDistance(target) <= 925 and menu.harass.useE:Value() and  menu.Keys.harasskey:Value() and qbuff1 and IsReady(_E) and not IsReady(_Q))then
                self:CastE(unit)
              end
            end
            function Leblanc:CastWRH(unit)

              if(GetDistance(target) <= 600 and menu.harass.useW:Value() and  menu.Keys.harasskey:Value()  and IsReady(_W) and not self:wUsed() and IsReady(_R))then
                self:CastW(unit)
              end

              if(GetDistance(target) <= 600 and menu.harass.useR:Value() and  menu.Keys.harasskey:Value()  and IsReady(_R) )then
                self:CastR(unit)
              end
              if not IsReady(_R) then
                self:CastW(unit)
              end
            end
            function Leblanc:CastQWK(unit)

              if(GetDistance(target) <= 700 and menu.killsteal.useQW:Value() and  menu.killsteal.ks:Value() and IsReady(_Q))then
                self:CastQ(unit)
              end

              if(GetDistance(target) <= 600 and menu.killsteal.useQW:Value() and not self:wUsed() and menu.killsteal.ks:Value()and IsReady(_W))then
                self:CastW(unit)
              end
            end
            function Leblanc:CastEQ(unit)


              if(GetDistance(target) <= 925 and menu.combo.useE:Value() and  menu.Keys.combokey:Value()    and IsReady(_E))then
                self:CastE(unit)
              end

              if(GetDistance(target) <= 700 and menu.combo.useQ:Value() and  menu.Keys.combokey:Value()   and IsReady(_Q)) then
                self:CastQ(unit)
              end
            end
            ---//==================================================\\---
            --|| > Leblanc Combo                             ||--
            ---\\==================================================//---
            function Leblanc:combo()
              if menu.combo.logic:Value() == 1 and (myHero.mana / myHero.maxMana >= menu.combo.Mana:Value() /100 ) then
                self:comboQEWR()
              end
              if menu.combo.logic:Value() == 2 and (myHero.mana / myHero.maxMana >= menu.combo.Mana:Value() /100 ) then
                self:comboQREW()
              end
              if menu.combo.logic:Value() == 3 and (myHero.mana / myHero.maxMana >= menu.combo.Mana:Value() /100 ) then
                self:comboEQWR()
              end
              if menu.combo.logic:Value() == 4 and (myHero.mana / myHero.maxMana >= menu.combo.Mana:Value() /100 ) then
                --  print "no"
                self:comboEWQR()
              end
              if menu.combo.logic:Value() == 5 and (myHero.mana / myHero.maxMana >= menu.combo.Mana:Value() /100 ) then
                --print "denem1"
                self:comboWRQE()
              end
              if menu.combo.logic:Value() == 6 and (myHero.mana / myHero.maxMana >= menu.combo.Mana:Value() /100 ) then
                self:comboWQRE()
              end
              if menu.combo.logic:Value() == 7 and (myHero.mana / myHero.maxMana >= menu.combo.Mana:Value() /100 ) then
                self:comboQRWE()
              end
              if menu.combo.logic:Value() == 8 and (myHero.mana / myHero.maxMana >= menu.combo.Mana:Value() /100 ) then
                self:comboDB()
              end
              if menu.combo.logic:Value() == 9 and (myHero.mana / myHero.maxMana >= menu.combo.Mana:Value() /100 ) then
                self:randomcombo()
              end
              if(menu.combo.useI:Value() and menu.Keys.combokey:Value()   )then
                for _, unit in pairs(GetEnemyHeroes()) do
                  local dmgI =(50+ ((myHero.level)*20))
                  local health=unit.health
                  if(health<dmgI and menu.combo.useI:Value() and GetDistance(unit)<600)then
                    self:CastI(unit)
                  end
                end
              end
            end
            function Leblanc:comboQEWR()

              if not menu.combo.turnw.w1:Value() then
                if (GetDistance(target) <= 600 )then
                  self:CastQE(target)
                end
                if(GetDistance(target) <= 600 ) and self:QEused() then
                  self:CastWR(target)
                end
              end
              if menu.combo.turnw.w1:Value() then
                if (GetDistance(target) <= 600 )then
                  self:CastQE(target)
                end
                if(GetDistance(target) <= 600 ) and self:QEused() then
                  self:CastWRB(target)
                end
              end
            end
            function Leblanc:comboQREW()

              if not menu.combo.turnw.w2:Value() then
                if (GetDistance(target) <= 600 )then
                  self:CastQR(target)
                end
                if(GetDistance(target) <= 600 ) and self:QRused() then
                  self:CastEW(target)
                end
              end
              if menu.combo.turnw.w2:Value() then
                if (GetDistance(target) <= 600 )then
                  self:CastQR(target)
                end
                if(GetDistance(target) <= 600 ) and self:QRused() then
                  self:CastEWB(target)
                end
              end
            end
            function Leblanc:comboEQWR()

              if not menu.combo.turnw.w3:Value() then
                if (GetDistance(target) <= 600 )then
                  self:CastEQ(target)
                end
                if(GetDistance(target) <= 600 ) and self:EQused() then
                  self:CastWR(target)
                end
              end
              if  menu.combo.turnw.w3:Value() then
                if (GetDistance(target) <= 600 )then
                  self:CastEQ(target)
                end
                if(GetDistance(target) <= 600 ) and self:EQused() then
                  self:CastWRB(target)
                end
              end
            end
            function Leblanc:comboEWQR()

              if not menu.combo.turnw.w4:Value() then
                if (GetDistance(target) <= 600 )then
                  self:CastEW(target)
                end
                if(GetDistance(target) <= 600 ) and self:EWused() then
                  self:CastQR(target)
                end
              end
              if  menu.combo.turnw.w4:Value() then
                if (GetDistance(target) <= 600 )then
                  self:CastEWB(target)
                end
                if(GetDistance(target) <= 600 ) and self:EWused() then
                  self:CastQR(target)
                end
              end
            end
            function Leblanc:comboWRQE()

              if not menu.combo.turnw.w5:Value() then
                if(GetDistance(target) <= 600 )  then
                  self:CastWR2(target)
                end
                if (GetDistance(target) <= 600 ) and self:R2used() then
                  self:CastQE(target)
                end
              end
              if menu.combo.turnw.w5:Value() then
                if(GetDistance(target) <= 600 ) then
                  self:CastWRB2(target)
                end
                if (GetDistance(target) <= 600 ) and self:R2used() then
                  self:CastQE(target)
                end
              end
            end
            function Leblanc:comboWQRE()

              if not menu.combo.turnw.w6:Value() then
                if(GetDistance(target) <= 600 )  then
                  self:CastWQ(target)
                end
                if (GetDistance(target) <= 600 ) and self:Qused()then
                  self:CastRE1(target)
                end
              end
              if menu.combo.turnw.w6:Value() then
                if(GetDistance(target) <= 600 ) then
                  self:CastWQB(target)
                end
                if (GetDistance(target) <= 600 ) and self:Qused()then
                  self:CastRE1(target)
                end
              end
            end
            function Leblanc:comboQRWE()

              if not menu.combo.turnw.w7:Value() then
                if (GetDistance(target) <= 600 )then
                  self:CastQR(target)
                end
                if(GetDistance(target) <= 600 ) and self:QRused() then
                  self:CastWE(target)
                end
              end
              if menu.combo.turnw.w7:Value() then
                if (GetDistance(target) <= 600 )then
                  self:CastQR(target)
                end
                if(GetDistance(target) <= 600 ) and self:QRused() then
                  self:CastWEB(target)
                end
              end
            end
            function Leblanc:comboDB() -- QWER

              if not menu.combo.turnw.w8:Value() then
                if(GetDistance(target) <= 600 )  then
                  self:CastQW(target)
                end
                if (GetDistance(target) <= 600 ) and self:QWused()then
                  self:CastER(target)
                end
              end
              if menu.combo.turnw.w8:Value() then
                if(GetDistance(target) <= 600 ) then
                  self:CastQWB(target)
                end
                if (GetDistance(target) <= 600 ) and self:QWused()then
                  self:CastER(target)
                end
              end
            end
            function Leblanc:randomcombo()
              if menu.combo.turnw.w9:Value() then

                if(GetDistance(target) <= 700 and menu.combo.useQ:Value() and  menu.Keys.combokey:Value()    and IsReady(_Q))then
                  self:CastQ(target)
                end

                if(GetDistance(target) <= 925 and menu.combo.useE:Value() and  menu.Keys.comboke:Value()    and IsReady(_E))then
                  self:CastE(target)
                end
                if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value()    and IsReady(_W))then
                  self:CastW(target)
                end
                if(GetDistance(target) <= 600 and menu.combo.useR:Value() and  menu.Keys.combokey:Value()    and IsReady(_Q))then
                  self:CastR(target)
                end
              end
              if not menu.combo.turnw.w9:Value() then

                if(GetDistance(target) <= 700 and menu.combo.useQ:Value() and  menu.Keys.combokey:Value()    and IsReady(_Q))then
                  self:CastQ(target)
                end


                if(GetDistance(target) <= 925 and menu.combo.useE:Value() and  menu.Keys.combokey:Value()    and IsReady(_E))then
                  self:CastE(target)
                end

                if(GetDistance(target) <= 600 and menu.combo.useW:Value() and  menu.Keys.combokey:Value() and not self:wUsed() and IsReady(_W))then
                  self:CastW(target)
                end
                if(GetDistance(target) <= 600 and menu.combo.useR:Value() and  menu.Keys.combokey:Value()    and IsReady(_Q))then
                  self:CastR(target)
                end
              end
            end
            function Leblanc:onlye()
              if(GetDistance(target) <= 925 and menu.combo.useE:Value() and  menu.Keys.onlye:Value()   and IsReady(_E)) then
                self:CastE(Etarget)
              end
            end
            ---//==================================================\\---
            --|| > Leblanc Damage Checks                      ||--
            ---\\==================================================//---
            function Leblanc:GetQDmg(target)
              if GetCastLevel(myHero, _Q)< 1 then
                return 0
              end
              if IsReady(_Q) then
                local FinalDamage = (30 + (GetCastLevel(myHero, _Q)* 25) + (GetBonusAP(myHero)*.4))
                return CalcDamage(myHero,target, 0,FinalDamage)
              else
                return 0
              end
            end
            function Leblanc:GetQ2Dmg(target)
              if GetCastLevel(myHero, _Q) < 1 then
                return 0
              end
              if IsReady(_Q) then
                local FinalDamage = (30 + (GetCastLevel(myHero, _Q) * 25) + (GetBonusAP(myHero))* .4)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function Leblanc:GetWDmg(target)
              if GetCastLevel(myHero, _W) < 1 then
                return 0
              end
              if IsReady(_W) then
                local FinalDamage = (45 + (GetCastLevel(myHero, _W) * 40) + (GetBonusAP(myHero))* .6)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function Leblanc:GetEDmg(target)
              if GetCastLevel(myHero, _E) < 1 then
                return 0
              end
              if IsReady(_E) then
                local FinalDamage = 2*(15 + (GetCastLevel(myHero, _E) * 25) + (GetBonusAP(myHero))* .5)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function Leblanc:GetE2Dmg(target)
              if GetCastLevel(myHero, _E) < 1 then
                return 0
              end
              if IsReady(_E) then
                local FinalDamage = (15 + (GetCastLevel(myHero, _E) * 25) + (GetBonusAP(myHero))* .5)
                return CalcDamage(myHero,target, 0, FinalDamage)
              else
                return 0
              end
            end
            function Leblanc:GetRDmg(target)
              if GetCastLevel(myHero, _R) < 1 then
                return 0
              end
              if IsReady(_R) and GetCastName(myHero,_R)  == "LeblancSoulShackleM" then
                local FinalDamage = ((GetCastLevel(myHero, _R) * 100) + (GetBonusAP(myHero)) * .6)
                return CalcDamage(myHero,target,0, FinalDamage)
              elseif IsReady(_R) and GetCastName(myHero,_R) == "LeblancSlideM" then
                local FinalDamage = ((GetCastLevel(myHero, _R) * 150) + (GetBonusAP(myHero)) * .9)
                return CalcDamage(myHero,target,0, FinalDamage)
              elseif IsReady(_R) and GetCastName(myHero,_R) == "LeblancChaosOrbM" then
                local FinalDamage = ((GetCastLevel(myHero, _R) * 100) + (GetBonusAP(myHero)) * .6)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function Leblanc:GetMyDmg(target)
              if IsReady(_Q) and IsReady(_W) and IsReady(_R)and IsReady(_E) then
                return self:GetQDmg(target) + self:GetWDmg(target) + self:GetRDmg(target) + self:GetEDmg(target) + self:GetQ2Dmg(target)
              elseif IsReady(_Q) and IsReady(_W) and IsReady(_R)then
                return self:GetQDmg(target) + self:GetWDmg(target) + self:GetRDmg(target) + self:GetQ2Dmg(target)
              elseif IsReady(_Q) and IsReady(_W) and IsReady(_E) then
                return self:GetQDmg(target) + self:GetWDmg(target) + self:GetEDmg(target) + self:GetQ2Dmg(target)
              elseif IsReady(_Q) and IsReady(_R)and IsReady(_E) then
                return self:GetQDmg(target) + self:GetRDmg(target) + self:GetEDmg(target) + self:GetQ2Dmg(target)
              elseif IsReady(_R)and IsReady(_W) and IsReady(_E) then
                return self:GetRDmg(target) + self:GetWDmg(target) + self:GetEDmg(target)
              elseif IsReady(_Q) and IsReady(_W) then
                return self:GetQDmg(target) + self:GetWDmg(target) + self:GetQ2Dmg(target)
              elseif IsReady(_E) and IsReady(_W) then
                return self:GetEDmg(target) + self:GetWDmg(target)
              elseif IsReady(_R)and IsReady(_W) then
                return self:GetRDmg(target) + self:GetWDmg(target)
              elseif IsReady(_Q) and IsReady(_R)then
                return self:GetQDmg(target) + self:GetRDmg(target)+ self:GetQ2Dmg(target)
              elseif IsReady(_E) and IsReady(_R)then
                return self:GetEDmg(target) + self:GetRDmg(target)
              elseif IsReady(_Q) and IsReady(_E) then
                return self:GetQDmg(target) + self:GetEDmg(target) + self:GetQ2Dmg(target)
              elseif IsReady(_R)then
                return self:GetRDmg(target)
              elseif IsReady(_E) then
                return self:GetEDmg(target)
              elseif IsReady(_Q) then
                return self:GetQDmg(target)
              elseif IsReady(_W) then
                return self:GetWDmg(target)
              else
                return 0
              end
            end
            function Leblanc:GetDraws(target)
              local qdamage = self:GetQDmg(target)
              local q2damage =self:GetQ2Dmg(target)
              local wdamage = self:GetWDmg(target)
              local edamage = self:GetEDmg(target)
              local rdamage = self:GetRDmg(target)
              local Idmg=(50+ ((GetLevel(myHero))*20))

              if qdamage >GetCurrentHP(target) then
                return 'Q', GoS.White
              elseif qdamage+ Idmg>GetCurrentHP(target) then
                return 'Q + Ignite', GoS.White
              elseif wdamage >GetCurrentHP(target) then
                return 'W', GoS.White
              elseif wdamage+ Idmg>GetCurrentHP(target) then
                return 'W + Ignite', GoS.White
              elseif edamage >GetCurrentHP(target) then
                return 'E', GoS.White
              elseif edamage + Idmg>GetCurrentHP(target) then
                return 'E + Ignite', GoS.White
              elseif rdamage  >GetCurrentHP(target) then
                return 'R', GoS.White
              elseif rdamage + Idmg>GetCurrentHP(target) then
                return 'R + Ignite', GoS.White
              elseif rdamage +edamage  >GetCurrentHP(target) then
                return 'R + E',GoS.White
              elseif rdamage +edamage+ Idmg>GetCurrentHP(target) then
                return 'R + E + Ignite',GoS.White
              elseif edamage+wdamage >GetCurrentHP(target) then
                return 'E + W',GoS.White
              elseif edamage+wdamage+ Idmg>GetCurrentHP(target) then
                return 'E + W + Ignite',GoS.White
              elseif rdamage+wdamage >GetCurrentHP(target) then
                return 'R + W',GoS.White
              elseif rdamage+wdamage+ Idmg>GetCurrentHP(target) then
                return 'R + W + Ignite',GoS.White
              elseif qdamage+q2damage+wdamage >GetCurrentHP(target) then
                return 'Q + W',GoS.White
              elseif qdamage+q2damage+edamage>GetCurrentHP(target) then
                return 'Q + E',GoS.White
              elseif qdamage+q2damage+rdamage >GetCurrentHP(target) then
                return 'Q + R',GoS.White
              elseif qdamage+q2damage+wdamage+ Idmg>GetCurrentHP(target) then
                return 'Q + W + Ignite',GoS.White
              elseif qdamage+q2damage+edamage+ Idmg>GetCurrentHP(target) then
                return 'Q + E + Ignite',GoS.White
              elseif qdamage+q2damage+rdamage+ Idmg>GetCurrentHP(target) then
                return 'Q + R + Ignite',GoS.White
              elseif qdamage+q2damage+edamage+wdamage >GetCurrentHP(target) then
                return 'Q + W + E',GoS.White
              elseif qdamage+q2damage+rdamage+wdamage >GetCurrentHP(target) then
                return 'Q + W + R',GoS.White
              elseif qdamage+q2damage+edamage+rdamage >GetCurrentHP(target) then
                return 'Q + R + E',GoS.White
              elseif qdamage+q2damage+edamage+wdamage+ Idmg>GetCurrentHP(target) then
                return 'Q + W + E + Ignite',GoS.White
              elseif qdamage+q2damage+wdamage+edamage+rdamage >GetCurrentHP(target) then
                return 'Kill with full combo',GoS.White
              elseif qdamage+q2damage+wdamage+edamage+rdamage+Idmg>GetCurrentHP(target) then
                return 'Full Combo + Ignite',GoS.White
              else
                return "Cant Kill yet", GoS.White
              end
            end
            function Leblanc:killsteal()
              for _, unit in pairs(GetEnemyHeroes()) do
                local health = GetCurrentHP(unit)
                local dmgE = self:GetEDmg(unit)
                if(GetDistance(target) <= self.E.range and  IsReady(_E) and not menu.Keys.combokey:Value()   and health<dmgE and menu.killsteal.useE:Value()   and menu.killsteal.ks:Value())then
                  self:CastE(unit)
                end
                local dmgQ = self:GetQDmg(unit)
                if(GetDistance(target) <= self.Q.range and  IsReady(_Q) and not menu.Keys.combokey:Value()   and health<dmgQ and menu.killsteal.useQ:Value() and menu.killsteal.ks:Value() )then
                  self:CastQ(unit)
                end
                local dmgQW = self:GetQDmg(unit)+self:GetWDmg(unit)
                if(GetDistance(target) <= self.W.range and  health<dmgQ and not menu.Keys.combokey:Value()   and menu.killsteal.useQW:Value() and menu.killsteal.ks:Value() )then
                  self:CastQWK(unit)
                end
                local dmgW = self:GetWDmg(unit)
                if(GetDistance(target) <= self.W.range and  IsReady(_W) and not menu.Keys.combokey:Value() and not self:wUsed()   and health<dmgQ and menu.killsteal.useW:Value() and menu.killsteal.ks:Value() )then
                  self:CastW(unit)
                end
                local dmgI =(50+ ((myHero.level)*20))
                if(health<dmgI and menu.killsteal.useI:Value() and menu.killsteal.ks:Value() and GetDistance(unit)<600)then
                  self:CastI(unit)
                end
                local dmgR =self:GetRDmg(unit)
                if(GetDistance(target) <= 600 and  IsReady(_R) and not menu.Keys.combokey:Value()   and health<dmgR and menu.killsteal.useR:Value() and menu.killsteal.ks:Value() )then
                  self:CastR(unit)
                end
              end
            end
            ---//==================================================\\---
            --|| > Leblanc Used Checks                          ||--
            ---\\==================================================//---
            function Leblanc:wUsed()
              if GetCastName(myHero,_W) == "LeblancSlideReturn" then
                return true
              else
                return false
              end
            end
            function Leblanc:rUsed()
              if GetCastName(myHero,_R) == "LeblancSlideM" then
                return false
              else
                return true
              end
            end
            function Leblanc:R2used()
              local leblancQ =  CanUseSpell(myHero, _R) == ONCOOLDOWN
              if (leblancQ ) then
                return true
              else
                return false
              end
            end
            function Leblanc:QEused()
              local leblancQ = IsReady(_Q)
              local leblancE = IsReady(_E)
              if (leblancQ and leblancE) then
                return false
              else
                return true
              end
            end
            function Leblanc:WRused()
              local leblancQ = IsReady(_W)
              local leblancE = IsReady(_R)
              if (leblancQ and leblancE) then
                return false
              else
                return true
              end
            end
            function Leblanc:WQused()
              local leblancQ = IsReady(_W)
              local leblancE = IsReady(_Q)
              if (leblancQ and leblancE) then
                return false
              else
                return true
              end
            end
            function Leblanc:Qused()
              local leblancE = IsReady(_Q)
              if ( leblancE) then
                return false
              else
                return true
              end
            end
            function Leblanc:EQused()
              local leblancW = IsReady(_E)
              local leblancE = IsReady(_Q)
              if (leblancW and leblancE) then
                return false
              else
                return true
              end
            end
            function Leblanc:EWused()
              local leblancW = IsReady(_E)
              local leblancE = IsReady(_W)
              if (leblancW and leblancE) then
                return false
              else
                return true
              end
            end
            function Leblanc:QRused()
              local leblancW = IsReady(_Q)
              local leblancE = IsReady(_R)
              if (leblancW and leblancE) then
                return false
              else
                return true
              end
            end
            function Leblanc:QWused()
              local leblancW = IsReady(_Q)
              local leblancE = IsReady(_W)
              if (leblancW and leblancE) then
                return false
              else
                return true
              end
            end
            function Leblanc:WndMsg(Msg, Key)
              if menu.Keys.combomode:Value() then
                menu.combo.logic:Value((menu.combo.logic:Value() + 1))
                menu.Keys.combomode:Value(false)
                if menu.combo.logic:Value() > 9 then menu.combo.logic:Value(1) end
              end
              if menu.targetsel.ts:Value() then
                if Msg == WM_LBUTTONDOWN then
                  local minD = 10
                  local starget = nil
                  for i, enemy in ipairs(GetEnemyHeroes()) do
                    if ValidTarget(enemy) then
                      if GetDistance(enemy, mousePos) <= minD or starget == nil then
                        minD = GetDistance(enemy, mousePos)
                        starget = enemy
                      end
                    end
                  end
                  if starget and minD < 150 then
                    if self.selectedTar and starget.charName == self.selectedTar.charName then
                      self.selectedTar = nil
                      print("<font color=\"#FFFFFF\">Target <b>is no loger selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
                    else
                      self.selectedTar = starget
                      print("<font color=\"#FFFFFF\">New target <b>selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
                    end
                  end
                end
              end
              if Msg == WM_LBUTTONDOWN then
                if PopUp1 then
                  PopUp1 = false
                end
              end
            end
            class "Diana"
            local abuff = false
            ---//==================================================\\---
            --|| > Diana Starts                         ||--
            ---\\==================================================//---
            function Diana:__init()
                    if not libloaded then return end
              self.Q = { delay = 0.25, speed = 2000 ,width = 75, range = 830  } --aoe false, Col false, lınear
              self.W = {range = 200  }
              self.E = {range = 350  }
              self.R = {range = 825  }
                qSpell = IPrediction.Prediction({range = 830, speed = 2000, delay = 0.25, width = 75, type = "linear", name =myHero:GetSpellData(_Q).name, collision = false})
              self.tsg = TargetSelector(1000,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
              Last_LevelSpell = 0
              self:LoadMenu()
              Callback.Add("Load", function() self:onload() end)
              Callback.Add("Tick", function() self:Tick() end)
              Callback.Add("UpdateBuff", function(unit,buff) self:UpdateBuff(unit,buff) end)
              Callback.Add("RemoveBuff", function(unit,buff) self:RemoveBuff(unit,buff) end)
              Callback.Add("WndMsg", function(Msg, Key) self:WndMsg(Msg, Key) end)
              Callback.Add("Draw", function() self:Draw() end)
              Callback.Add("ProcessSpell", function(unit, spell) self:ProcessSpell(unit, spell) end)
              --Callback.Add("ProcessSpellComplete", function(x,y) self:ProcessSpellComplete(x,y) end)
            end
            function Diana:onload()
              findorb()
            end
            function Diana:LoadMenu()
              menu=MenuConfig("menu",""..Scriptname.." [" .. myHero.charName.."]" )

              menu:Menu( "combo",loc_eng[1])
              menu.combo:Boolean("useQ", loc_eng[2], true)
              menu.combo:Boolean("useW", loc_eng[3], true)
              menu.combo:Boolean("useE", loc_eng[4], true)
              menu.combo:Boolean("useR", loc_eng[5], true)
              menu.combo:Boolean("useI", loc_eng[6], true)
              menu.combo:Slider("Mana",loc_eng[8], 10, 10, 100, 1)
              --menu.combo:Boolean("logicgap", "Use QR to gapclose",1, {"Only if target Killable", "Always" , "Never" })
              menu.combo:DropDown("logic", loc_eng[7],1, {loc_eng[139], loc_eng[140] , loc_eng[141] })


              menu:Menu( "harass",loc_eng[9])
              menu.harass:Boolean("useQ", loc_eng[10], true)
              menu.harass:Boolean("useW", loc_eng[11], true)
              menu.harass:Boolean("useE", loc_eng[12], true)
              menu.harass:Slider("Mana",loc_eng[8], 10, 10, 100, 1)


              menu:Menu( "farm",loc_eng[14])

              menu.farm:Menu("laneclear",loc_eng[15])
              menu.farm.laneclear:Boolean("useQ",loc_eng[16],true)
              menu.farm.laneclear:Slider("qcount",loc_eng[180], 2, 1, 10, 1)
              menu.farm.laneclear:Boolean("useW",loc_eng[17],true)
              menu.farm.laneclear:Slider("wcount",loc_eng[181], 2, 1, 10, 1)
              menu.farm.laneclear:Info("blank","" )
              menu.farm.laneclear:Info("blank", "")
              menu.farm.laneclear:Info("info2", loc_eng[184])
              menu.farm.laneclear:Slider("QMana",loc_eng[185], 30, 10, 100, 1)
              menu.farm.laneclear:Slider("WMana",loc_eng[186], 30, 10, 100, 1)

              menu.farm:Menu("jungleclear",loc_eng[20])
              menu.farm.jungleclear:Boolean("useQ",loc_eng[21],true)
              menu.farm.jungleclear:Boolean("useW",loc_eng[22],true)
              menu.farm.jungleclear:Boolean("useE",loc_eng[23],true)
              menu.farm.jungleclear:Boolean("useR",loc_eng[24],true)
              menu.farm.jungleclear:Info("blank","" )
              menu.farm.jungleclear:Info("blank","" )
              menu.farm.jungleclear:Info("info2", loc_eng[184])
              menu.farm.jungleclear:Slider("QMana",loc_eng[185], 30, 10, 100, 1)
              menu.farm.jungleclear:Slider("WMana",loc_eng[186], 30, 10, 100, 1)
              menu.farm.jungleclear:Slider("EMana",loc_eng[187], 30, 10, 100, 1)
              menu.farm.jungleclear:Slider("RMana",loc_eng[188], 30, 10, 100, 1)

              menu.farm:Menu("lasthit",loc_eng[25])
              menu.farm.lasthit:Boolean("autolasthit",loc_eng[189],false)
              menu.farm.lasthit:Boolean("useQ",loc_eng[26],true)
              menu.farm.lasthit:DropDown("lasthitlogic",loc_eng[191],1, {loc_eng[172],loc_eng[174]})
              menu.farm.lasthit:Info("blank", "")
              menu.farm.lasthit:Info("blank", "")
              menu.farm.lasthit:Info("info2", loc_eng[184])
              menu.farm.lasthit:Slider("QMana",loc_eng[185], 30, 10, 100, 1)

              menu:Menu( "killsteal",loc_eng[35])
              menu.killsteal:Boolean("ks",loc_eng[36],true)
              menu.killsteal:Boolean("useQ", loc_eng[37], true)
              menu.killsteal:Boolean("useR", loc_eng[40], true)
              menu.killsteal:Boolean("useI", loc_eng[41], true)

              --[[  menu:Menu("Escape Settings","escape")
              menu.escape:Boolean("useR","Use R Minion To Escape",true)
              menu.escape:Boolean("useQR","Use QR Minion To Escape",true)]]
 Activator:Loadmenu("ap")

              menu:Menu("misc",loc_eng[92])
              menu.misc:Menu( "interrupt",loc_eng[93])
              menu.misc.interrupt:Boolean("r", loc_eng[96], true)
              menu.misc.interrupt:Info("info3", loc_eng[98])
      DelayAction(function()
  local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
  for i, spell in pairs(CHANELLING_SPELLS) do
    for _,k in pairs(GetEnemyHeroes()) do
        if spell["Name"] == GetObjectName(k) then
        menu.misc.interrupt:Boolean(GetObjectName(k).."Inter", "On "..GetObjectName(k).." "..(type(spell.Spellslot) == 'number' and str[spell.Spellslot]), true)
        end
    end
  end
end, 0.35)

              menu.misc:Menu( "skinhack","[" .. myHero.charName.. "] - Skinhack Settings")
              menu.misc.skinhack:Boolean("useskin",loc_eng[54], false)
              menu.misc.skinhack:DropDown('selected' .. myHero.charName .. 'Skin', loc_eng[57]  ,  1, skinMeta[myHero.charName])
              menu.misc:Menu( "autolevel","[" .. myHero.charName.. "] - AutoLevel Settings")
              menu.misc.autolevel:Boolean("uselevel",loc_eng[51], false)
              menu.misc.autolevel:DropDown("logic", loc_eng[52] , 7, {loc_eng[58], loc_eng[59],loc_eng[60],loc_eng[61],loc_eng[62], loc_eng[63], loc_eng[64]  })
              menu.misc:Menu( "antiafk","[" .. myHero.charName.. "] - AntiAFK Settings")
              menu.misc.antiafk:Boolean("useafk",loc_eng[196], false)

              menu.misc:Boolean("emax", "Use E if distance > 280", true)
              --menu.misc:Boolean("useW", "Auto W skill if enemy attacks.", true)
              Clock = os.clock()
              menu:Menu("other",loc_eng[66])
              --menu.other:Menu("Show Damage On Hp Bar", "HPBAR")
              --menu.other.HPBAR:Boolean("key","ON/OFF",true)
              menu.other:Menu( "draw",loc_eng[66])
              menu.other.draw:Boolean("qdraw",loc_eng[67],true)
              menu.other.draw:Boolean("wdraw",loc_eng[68],true)
              menu.other.draw:Boolean("edraw",loc_eng[69],true)
              menu.other.draw:Boolean("rdraw",loc_eng[70],true)
              menu.other.draw:Boolean("aadraw",loc_eng[71],false)
              menu.other:Menu( "color",loc_eng[198])
              menu.other.color:ColorPick("Qcolor", loc_eng[199],{255, 255, 255, 255})
              menu.other.color:ColorPick("Wcolor", loc_eng[200],{255, 255, 255, 255})
              menu.other.color:ColorPick("Ecolor", loc_eng[201],{255, 255, 255, 255})
              menu.other.color:ColorPick("Rcolor", loc_eng[202],{255, 255, 255, 255})
              menu.other.color:ColorPick("AAcolor", loc_eng[204],{255, 255,0,0})
              -- menu.other.color:ColorPick("targetselect", loc_eng[205],{255, 255,0,0})
              menu.other:Menu( "width",loc_eng[206])
              menu.other.width:Slider("Qwidth", loc_eng[210],  1, 1, 10, 1)
              menu.other.width:Slider("Wwidth", loc_eng[211],  1, 1, 10, 1)
              menu.other.width:Slider("Ewidth", loc_eng[212],  1, 1, 10, 1)
              menu.other.width:Slider("Rwidth", loc_eng[213],  1, 1, 10, 1)
              menu.other.width:Slider("AAwidth", loc_eng[209], 1, 1, 10, 1)
              -- menu.other.width:Slider("STwidth", loc_eng[208], 1, 1, 10, 1)
              menu.other:Boolean("target",loc_eng[75],true)
              menu.other:Boolean("damage",loc_eng[214],true)
              menu.other:Boolean("targetcal",loc_eng[76],true)
              --          menu.other:Menu( "perma",loc_eng[73])
              -- menu.other.perma:Boolean("perma",loc_eng[74],true)

              menu:Menu("targetsel",loc_eng[77])
              menu.targetsel:Boolean("ts",loc_eng[78],false)

              menu:Menu("orb","Orbwalker Settings")
              menu.orb:Menu( "selectorb","Current Orbwalker :")


              menu:Menu("pred","Prediction Settings")
              menu.pred:DropDown("selectpred","Current Predictions :",   1, {"Open Prediction","IPrediction","Gos Prediction"})
              menu.pred:Menu( "hcgeneral","Hitchance Settings")
              menu.pred.hcgeneral:Menu( "hcop","Open Prediction Hitchance")
              menu.pred.hcgeneral.hcop:Slider("hcopq", "Q Hitchance " , 30, 0, 100, 1)
              menu.pred:Info("blank", "    Currently Open Prediction "   )
              menu.pred:Info("blank", "      is best with this bundle"   )


              menu:Menu( "Keys",loc_eng[79])
              menu.Keys:Info("infoK3", loc_eng[80])
              menu.Keys:Key("combokey", loc_eng[81],string.byte(" "))
              menu.Keys:Info("infoK4", loc_eng[82])
              menu.Keys:Key("harasskey", loc_eng[83],string.byte("C"))
              menu.Keys:Key("autoq", loc_eng[91], string.byte("T"))
              menu.Keys:Info("infoK5", loc_eng[84])
              menu.Keys:Key("laneclearkey", loc_eng[85],string.byte("V"))
              menu.Keys:Key("jungleclearkey", loc_eng[86],string.byte("V"))
              menu.Keys:Key("lasthitkey",loc_eng[215],string.byte("X"))
              menu.Keys:Info("infoK6", loc_eng[87])
              menu.Keys:Key("escapekey", loc_eng[88],string.byte("Y"))
              --menu.Keys:Boolean("lasthitkey", "Lasthit Key",string.byte("X"))
              menu.Keys:Info("infoK","" )
              menu.Keys:Info("infoK2", loc_eng[89])

              menu:Info("infoK","           "..Scriptname.."" )
              menu:Info("infoK","         Script Version:  "..Version.. "  " )
              menu:Info("infoK","   Script was made by  "..Author.. "" )
              menu:Info("infoK","Leauge Of Legends Version: "..LVersion.. "" )
              menu:Boolean("instruct", loc_eng[216], false)
            end
            function Diana:Draw()
              if menu.other.draw.qdraw:Value() and IsReady(_Q) then
                DrawCircle(myHero.x, myHero.y, myHero.z, 830,  menu.other.width.Qwidth:Value(),0,menu.other.color.Qcolor:Value())
              end

              if menu.other.draw.wdraw:Value() and IsReady(_W) then
                DrawCircle(myHero.x, myHero.y, myHero.z, 200,  menu.other.width.Wwidth:Value(),0, menu.other.color.Wcolor:Value())
              end

              if menu.other.draw.edraw:Value() and IsReady(_E) then
                DrawCircle(myHero.x, myHero.y, myHero.z, 350,  menu.other.width.Ewidth:Value(),0, menu.other.color.Ecolor:Value())
              end

              if menu.other.draw.rdraw:Value() and IsReady(_R) then
                DrawCircle(myHero.x, myHero.y, myHero.z, 825, menu.other.width.Rwidth:Value(),0, menu.other.color.Rcolor:Value())
              end
              if menu.other.draw.aadraw:Value() then
                DrawCircle(myHero.x, myHero.y, myHero.z, 125, menu.other.width.AAwidth:Value(),0, menu.other.color.AAcolor:Value())
              end
            Global:Commondraw()
                  for _, target in pairs(GetEnemyHeroes()) do
                    if ValidTarget(target, 15000) then
                      if target.visible and not target.dead and menu.other.damage:Value() then
                        currLine = 1
                        -- DrawLineHPBar2(self:GetMyDmg(target),"",  target, currLine)
                        DrawLineHPBar(self:GetMyDmg(target), "Damage " .. math.round(self:GetMyDmg(target)),target,currLine)
                        currLine = currLine + 1
                        DrawDmgOverHpBar(target,GetCurrentHP(target),0,self:GetMyDmg(target),0xff00ff00)
                      end
                    end
                  end
                  if menu.other.targetcal:Value() and not myHero.dead then
                    if target and target ~= nil then
                      --  local target= GetOrigin(target)
                      local drawpos=WorldToScreen(1,target.x, target.y, target.z)
                      local comboText,color = self:GetDraws(target)
                      if comboText then
                        DrawText(comboText,15,drawpos.x-20,drawpos.y-20,color)
                      end
                    end
                  end
                end
                function Diana:Checks()
                  Gtarget = self.tsg:GetTarget()
                  if not ValidTarget(Gtarget, 925) or not menu.targetsel.ts:Value()  then
                    target = GetCurrentTarget()
                  elseif  ValidTarget(Gtarget, 925) and not self.selectedTar then
                    target = GetCurrentTarget()
                  elseif (ValidTarget(Gtarget, 925) and self.selectedTar) then
                    target = self.selectedTar
                  end
                  mousePos = GetMousePos()
                   Activator:Loaditems("ap")
                end
                function Diana:Tick()
                  self:Checks()
                  self:autoq()
                  Antiafk()
                  autolevel()
                  skinhack()
                  autopot()
       Activator:Useitems("ap")
                  if(menu.Keys.jungleclearkey:Value() )then
                    self:JungleClear()
                  end
                  if(menu.Keys.combokey:Value() and menu.combo.logic:Value() == 1 )then
                    self:combo1()
                  end
                  if(menu.Keys.lasthitkey:Value() or menu.farm.lasthit.autolasthit:Value() )then
                    self:LastHit()
                  end
                  if menu.instruct then
                    menu.instruct = false
                    PopUp1 = true
                  end
                  if(menu.Keys.combokey:Value() and menu.combo.logic:Value() == 2 )then
                    self:combo2()
                  end
                  if(menu.Keys.combokey:Value() and menu.combo.logic:Value() == 3 )then
                    self:combo3()
                  end
                  if(menu.Keys.laneclearkey:Value() )then
                    self:LaneClear()
                  end
                  if(menu.killsteal.ks:Value() ) then
                    self:killsteal()
                  end
                  if(menu.Keys.harasskey:Value()  ) then
                    self:harass()
                  end
                  if(menu.Keys.escapekey:Value() )then
                    self:escape()
                  end
                end
                function Diana:CastQ(unit)
                  if menu.pred.selectpred:Value() == 1 then
                    local QPred = GetPrediction(unit, self.Q)
                    if IsReady(_Q) then
                      if QPred  and QPred.hitChance >= (menu.pred.hcgeneral.hcop.hcopq:Value()/100) then
                        CastSkillShot(_Q, QPred.castPos)
                      end
                    end
                  elseif menu.pred.selectpred:Value() == 2 then
                      local HitChance, y = qSpell:Predict(unit)
                      if IsReady(_Q) and HitChance >= 3 then
                        CastSkillShot(_Q, y.x, y.y, y.z)
                      end
                  elseif menu.pred.selectpred:Value() == 3 then
                    local qPred = GetPredictionForPlayer(myHeroPos(), unit, GetMoveSpeed(unit), 2000, 250, 830, 75, false, true)
                    if IsReady(_Q) and qPred.HitChance == 1 then
                      CastSkillShot(_Q, qPred.PredPos.x, qPred.PredPos.y, qPred.PredPos.z)
                    end
                  end
                end
                function Diana:CastW(unit)
                  if IsReady(_W) then
                    CastTargetSpell(unit, _W)
                  end
                end

                function Diana:CastE(unit)
                  if IsReady(_E) then
                    CastTargetSpell(unit, _E)
                  end
                end

                function Diana:CastR(unit)
                  if IsReady(_R) then
                    CastTargetSpell(unit, _R)
                  end
                end
                function Diana:CastI(unit)
                  if Ignite then
                    if IsReady(Ignite) then
                      CastTargetSpell(unit, Ignite)
                    end
                  end
                end
                function Diana:killsteal()
                  for _, unit in pairs(GetEnemyHeroes()) do
                    local health = unit.health
                    local dmgQ = self:GetQDmg(unit)
                    if(GetDistance(target) <= self.Q.range and  IsReady(_Q) and health<dmgQ and menu.killsteal.useQ:Value() and menu.killsteal.ks:Value() )then
                      self:CastQ(unit)
                    end
                    local dmgI =(50+ ((myHero.level)*20))
                    if(health<dmgI and menu.killsteal.useI:Value() and menu.killsteal.ks:Value() and GetDistance(unit)<600)then
                      self:CastI(unit)
                    end
                    local dmgR =self:GetRDmg(unit)
                    if(GetDistance(target) <= self.R.range and  IsReady(_R) and health<dmgR and menu.killsteal.useR:Value() and menu.killsteal.ks:Value() and GetDistance(unit)<550)then
                      self:CastR(unit)
                    end
                  end
                end
                function Diana:ProcessSpell(unit, spell)
                  if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and IsReady(_E) then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 1000) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and  menu.misc.interrupt[GetObjectName(unit).."Inter"]:Value() and menu.misc.interrupt.r:Value() then 
         self:CastE(unit)
        end
      end
    end
                end
                function Diana:UpdateBuff(unit,buff)
                  if unit and unit.team ~= myHero.team and unit.type == myHero.type then
                    if buff.Name == "dianamoonlight" then

                      abuff = true
                    end
                  end
                end
                function Diana:RemoveBuff(unit, buff)
                  if unit and unit.team ~= myHero.team and unit.type == myHero.type then
                    if buff.Name == "dianamoonlight" then

                      abuff = false
                    end
                  end
                end
                function Diana:walk()
                  MoveToXYZ(mousePos)
                end
                function Diana:escape()
                  if menu.Keys.escapekey  then
                    self:walk()
                  end
                end
                function Diana:harass()
                  if(GetDistance(target) <= self.Q.range and menu.harass.useQ:Value() and  menu.Keys.harasskey:Value()  and IsReady(_Q))then
                    self:CastQ(target)
                  end
                  if(GetDistance(target) <= self.W.range  and menu.harass.useW:Value() and  menu.Keys.harasskey:Value()  and IsReady(_W))then
                    self:CastW(target)
                  end
                  if(GetDistance(target) <= self.E.range  and menu.harass.useE:Value() and  menu.Keys.harasskey:Value()  and IsReady(_E))then
                    self:CastE(target)
                  end
                end
                function Diana:autoq()
                  if(GetDistance(target) <= self.Q.range and menu.Keys.autoq:Value() and  IsReady(_Q))then
                    self:CastQ(target)
                  end
                end
                function Diana:GetQDmg(target)
                  if GetCastLevel(myHero, _Q) < 1 then
                    return 0
                  end
                  if IsReady(_Q) then
                    local FinalDamage = (25 + (GetCastLevel(myHero, _Q) * 35) + (GetBonusAP(myHero))*.7)
                    return CalcDamage(myHero,target,0, FinalDamage)
                  else
                    return 0
                  end
                end
                function Diana:GetWDmg(target)
                  if GetCastLevel(myHero, _W) < 1 then
                    return 0
                  end
                  if IsReady(_W) then
                    local FinalDamage = 3*(10 + (GetCastLevel(myHero, _W) * 12) + (GetBonusAP(myHero))* .2)
                    return CalcDamage(myHero,target,0, FinalDamage)
                  else
                    return 0
                  end
                end
                function Diana:GetRDmg(target)
                  if GetCastLevel(myHero, _R) < 1 then
                    return 0
                  end
                  if IsReady(_R) then
                    local FinalDamage = (40 + (GetCastLevel(myHero, _R) * 60) + (GetBonusAP(myHero))* .6)
                    return CalcDamage(myHero,target,0, FinalDamage)
                  else
                    return 0
                  end
                end
                function Diana:GetMyDmg(target)
                  if IsReady(_Q) and IsReady(_R) and IsReady(_W) then
                    return self:GetQDmg(target) + self:GetRDmg(target) + self:GetWDmg(target)
                  elseif IsReady(_Q)  and IsReady(_R) then
                    return self:GetQDmg(target) + self:GetRDmg(target)
                  elseif IsReady(_Q)  and IsReady(_W) then
                    return self:GetQDmg(target) + self:GetWDmg(target)
                  elseif IsReady(_R) and IsReady(_W) then
                    return self:GetRDmg(target) +self:GetWDmg(target)
                  elseif IsReady(_Q) then
                    return self:GetQDmg(target)
                  elseif IsReady(_W) then
                    return self:GetWDmg(target)
                  elseif IsReady(_R) then
                    return self:GetRDmg(target)
                  elseif IsReady(_Q) and IsReady(_R) then
                    return self:GetQDmg(target) + self:GetRDmg(target)
                  else
                    return 0
                  end
                end
                function Diana:GetDraws(target)
                  local qdamage = self:GetQDmg(target)
                  local wdamage = self:GetWDmg(target)
                  local rdamage = self:GetRDmg(target)
                  local Idmg=(50+ ((myHero.level)*20))

                  if qdamage >target.health then
                    return 'Q', GoS.White
                  elseif qdamage+ Idmg>target.health then
                    return 'Q + Ignite', GoS.White
                  elseif wdamage >target.health then
                    return 'W', GoS.White
                  elseif wdamage + Idmg>target.health then
                    return 'W + Ignite', GoS.White
                  elseif rdamage  >target.health then
                    return 'R', GoS.White
                  elseif rdamage + Idmg>target.health then
                    return 'R + Ignite', GoS.White
                  elseif rdamage +wdamage  >target.health then
                    return 'R + W',GoS.White
                  elseif rdamage +wdamage+ Idmg>target.health then
                    return 'R + W + Ignite',GoS.White
                  elseif qdamage+wdamage>target.health then
                    return 'Q + W',GoS.White
                  elseif qdamage+rdamage >target.health then
                    return 'Q + R',GoS.White
                  elseif qdamage+wdamage+ Idmg>target.health then
                    return 'Q + W + Ignite',GoS.White
                  elseif qdamage+rdamage+ Idmg>target.health then
                    return 'Q + R + Ignite',GoS.White
                  elseif qdamage+wdamage+rdamage >target.health then
                    return 'Kill with full combo',GoS.White
                  elseif qdamage+wdamage+rdamage+ Idmg>target.health then
                    return 'Full Combo + Ignite',GoS.White
                  else
                    return "Cant Kill yet", GoS.White
                  end
                end
          function Diana:CastRQ(unit)
            if(GetDistance(target) <= self.Q.range and menu.combo.useQ:Value()  and  menu.Keys.combokey:Value()    and IsReady(_Q))then
              self:CastQ(target)
            end
            if(GetDistance(target) <= self.R.range and menu.combo.useR:Value()  and  menu.Keys.combokey:Value()    and IsReady(_R)) then
              DelayAction(function()self:CastR(target) end, 0.5)
            end
          end
          function Diana:CastQR(unit)

            if(GetDistance(target) <= self.Q.range and menu.combo.useQ:Value()  and  menu.Keys.combokey:Value()     and IsReady(_Q))then
              self:CastQ(minion)
            end
            if(GetDistance(target) <= self.R.range and menu.combo.useR:Value()  and abuff and  menu.Keys.combokey:Value()    and IsReady(_R)) then
              self:CastR(minion)
            end
          end
          function Diana:combo1()
            self:CastRQ(target)
            if(GetDistance(target) <= self.W.range  and menu.combo.useW:Value()  and  menu.Keys.combokey:Value()   and IsReady(_W) and not IsReady(_Q))then
              self:CastW(target)
            end
            if menu.misc.emax:Value()  then
              if(GetDistance(target) <= self.E.range  and menu.combo.useE:Value()  and GetDistance(target)>280 and menu.Keys.combokey:Value()   and IsReady(_E))then
                self:CastE(target)
              end
            elseif not menu.misc.emax:Value()  then
              if(GetDistance(target) <= self.E.range  and menu.combo.useE:Value()  and  menu.Keys.combokey:Value()   and IsReady(_E))then
                self:CastE(target)
              end
            end
            if(menu.combo.useI:Value()  and menu.Keys.combokey:Value()  )then
              for _, unit in pairs(GetEnemyHeroes()) do
                local dmgI =(50+ ((myHero.level)*20))
                local health=unit.health
                if(health<dmgI and menu.combo.useI:Value()  and GetDistance(unit)<600)then
                  self:CastI(unit)
                end
              end
            end
          end
          function Diana:combo2()
            if(GetDistance(target) <= self.Q.range and menu.combo.useQ:Value()  and  menu.Keys.combokey:Value()   and IsReady(_Q))then
              self:CastQ(target)
            end
            if(GetDistance(target) <= self.R.range and menu.combo.useR:Value()  and abuff and  menu.Keys.combokey:Value()   and not IsReady(_Q) and IsReady(_R))then
              self:CastR(target)
            end
            if(GetDistance(target) <= self.W.range  and menu.combo.useW:Value()  and  menu.Keys.combokey:Value()   and IsReady(_W))then
              self:CastW(target)
            end
            if menu.misc.emax:Value()  then
              if(GetDistance(target) <= self.E.range  and menu.combo.useE:Value()  and GetDistance(target)>280 and menu.Keys.combokey:Value()   and IsReady(_E)  )then
                self:CastE(target)
              end
            elseif not menu.misc.emax:Value()  then
              if(GetDistance(target) <= self.E.range  and menu.combo.useE:Value()  and  menu.Keys.combokey:Value()   and IsReady(_E))then
                self:CastE(target)
              end
            end
            if(menu.combo.useI:Value()  and menu.Keys.combokey:Value() )then
              for _, unit in pairs(GetEnemyHeroes()) do
                local dmgI =(50+ ((myHero.level)*20))
                local health=unit.health
                if(health<dmgI and menu.combo.useI:Value()  and GetDistance(unit)<600)then
                  self:CastI(unit)
                end
              end
            end
          end
          function Diana:combo3()
            if(GetDistance(target) <= self.Q.range and menu.combo.useQ:Value()  and  menu.Keys.combokey:Value()   and IsReady(_Q))then
              self:CastQ(target)
            end
            if(GetDistance(target) <= self.W.range  and menu.combo.useW:Value()  and  menu.Keys.combokey:Value()   and IsReady(_W))then
              self:CastW(target)
            end
            if(GetDistance(target) <= self.R.range and menu.combo.useR:Value()  and  menu.Keys.combokey:Value()   and not IsReady(_Q) and IsReady(_R))then
              self:CastR(target)
            end
            if menu.misc.emax:Value()  then
              if(GetDistance(target) <= self.E.range  and menu.combo.useE:Value()  and GetDistance(target)>280 and menu.Keys.combokey:Value()   and IsReady(_E) )then
                self:CastE(target)
              end
            elseif not menu.misc.emax:Value()  then
              if(GetDistance(target) <= self.E.range  and menu.combo.useE:Value()  and  menu.Keys.combokey:Value()   and IsReady(_E))then
                self:CastE(target)
              end
            end
            if(menu.combo.useI:Value()  and menu.Keys.combokey:Value() )then
              for _, unit in pairs(GetEnemyHeroes()) do
                local dmgI =(50+ ((myHero.level)*20))
                local health=unit.health
                if(health<dmgI and menu.combo.useI:Value()  and GetDistance(unit)<600)then
                  self:CastI(unit)
                end
              end
            end
          end
          function Diana:JungleClear()
            for i, minion in pairs(minionManager.objects) do
              if ValidTarget(minion) and minion ~= nil and GetTeam(minion) == MINION_ENEMY then
                if menu.farm.jungleclear.useW:Value() and ( myHero.mana / myHero.maxMana >= menu.farm.jungleclear.WMana:Value() /100 ) and GetDistance(minion) <= 200 then
                  self:CastW(minion)
                end
              end
            end
            local NumberOfHits = menu.farm.laneclear.qcount:Value()
            if NumberOfHits >= 1 and #minionManager.objects >= NumberOfHits then
              if menu.farm.jungleclear.useQ:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.jungleclear.QMana:Value() /100 )  then
                local BestPos, BestHit =  GetLineFarmPosition(self.Q.range, self.Q.width, MINION_ENEMY)
                if BestPos  and  BestHit >= NumberOfHits then
                  CastSkillShot(_Q, BestPos)
                end
              end
            end
          end
          function Diana:LastHit()
            for _, target in pairs(minionManager.objects) do
              if IsObjectAlive(target) and GetTeam(target) == MINION_ENEMY then
                if menu.farm.lasthit.lasthitlogic:Value() == 1 then
                  local Qdamage = self:GetQDmg(target)
                  if(IsReady(_Q) and menu.farm.lasthit.useQ:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.lasthit.QMana:Value() /100 ) and ValidTarget(target,700)   and Qdamage >= GetCurrentHP(target)) then
                    self:CastQ(target)
                  end
                end
              end
            end
          end
          function Diana:LaneClear()
            for i, minion in pairs(minionManager.objects) do
              if ValidTarget(minion) and minion ~= nil and GetTeam(minion) == MINION_ENEMY then
                if  menu.farm.laneclear.useW:Value() and ( myHero.mana / myHero.maxMana >= menu.farm.laneclear.WMana:Value() /100 ) and GetDistance(minion) <= 200 then
                  self:CastW(minion)
                end
              end
            end
            local NumberOfHits = menu.farm.laneclear.qcount:Value()
            if NumberOfHits >= 1 and #minionManager.objects >= NumberOfHits then
              if menu.farm.laneclear.useQ:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.laneclear.QMana:Value() /100 )  then
                local BestPos, BestHit =  GetLineFarmPosition(self.Q.range, self.Q.width, MINION_ENEMY)
                if BestPos and  BestHit >= NumberOfHits then
                  CastSkillShot(_Q, BestPos)
                end
              end
            end
          end
          function Diana:WndMsg(Msg, Key)
            if menu.targetsel.ts:Value() then
              if Msg == WM_LBUTTONDOWN then
                local minD = 10
                local starget = nil
                for i, enemy in ipairs(GetEnemyHeroes()) do
                  if ValidTarget(enemy) then
                    if GetDistance(enemy, mousePos) <= minD or starget == nil then
                      minD = GetDistance(enemy, mousePos)
                      starget = enemy
                    end
                  end
                end
                if starget and minD < 150 then
                  if self.selectedTar and starget.charName == self.selectedTar.charName then
                    self.selectedTar = nil
                    print("<font color=\"#FFFFFF\">Target <b>is no loger selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
                  else
                    self.selectedTar = starget
                    print("<font color=\"#FFFFFF\">New target <b>selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
                  end
                end
              end
            end
            if Msg == WM_LBUTTONDOWN then
              if PopUp1 then
                PopUp1 = false
              end
            end
          end
          class "Lissandra"

          function Lissandra:__init()
                  if not libloaded then return end
            self.Q = { delay = 0.25, speed = math.huge ,width = 20, range = 725 } --aoe false, Col false, lınear
            self.W = { range = 450 }
            self.E = { delay = 0.25, speed = math.huge ,width = 110, range = 1050 } --aoe false, Col false, lınear
            self.R = { range = 550 }
              eSpell = IPrediction.Prediction({range = 1050, speed =  math.huge, delay = 0.25, width = 110, type = "linear", name =myHero:GetSpellData(_E).name, collision = false})
              qSpell = IPrediction.Prediction({range = 725, speed = math.huge, delay = 0.25, width = 20, type = "linear", name =myHero:GetSpellData(_Q).name, collision = true})
            self:LoadMenu()
            AddGapcloseEvent(_W, 450, false,  menu.misc.gapClose1.gapClose1w)
            -- AddGapcloseEvent(_R, 550, true,  menu.misc.gapClose1.gapClose1r)
            self.tsg = TargetSelector(1200,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
           Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
            Last_LevelSpell = 0
            spells = {}
            spells.q = { rangeMax = 925}
            global_ticks = 0
            Callback.Add("Load", function() self:onload() end)
            Callback.Add("Tick", function() self:Tick() end)
            Callback.Add("WndMsg", function(Msg, Key) self:WndMsg(Msg, Key) end)
            Callback.Add("Draw", function() self:Draw() end)
            Callback.Add("ProcessSpell", function(unit, spell) self:ProcessSpell(unit, spell) end)
            --Callback.Add("ProcessSpellComplete", function(x,y) self:ProcessSpellComplete(x,y) end)
          end
          function  Lissandra:Checks()
            Gtarget = self.tsg:GetTarget()
            if not ValidTarget(Gtarget, 1200) or not menu.targetsel.ts:Value()  then
              target = GetCurrentTarget()
            elseif  ValidTarget(Gtarget, 1200) and not self.selectedTar then
              target = GetCurrentTarget()
            elseif (ValidTarget(Gtarget, 1200) and self.selectedTar) then
              target = self.selectedTar
            end
            mousePos = GetMousePos()
             Activator:Loaditems("ap")
          end
          function Lissandra:Tick()
            self:Checks()
            Antiafk()
            autolevel()
            skinhack()
            autopot()
        Activator:Useitems("ap")
            self:autoR()
            self:autoq()
            if(menu.Keys.combokey:Value() )then
              self:combo()
            end
            if(menu.Keys.jungleclearkey:Value() )then
              self:JungleClear()
            end
            if(menu.Keys.laneclearkey:Value() )then
              self:LaneClear()
            end
            if(menu.Keys.combokeyr:Value() )then
              self:engagewithr()
            end
            if(menu.Keys.lasthitkey:Value() or menu.farm.lasthit.autolasthit:Value() )then
              self:LastHit()
            end
            if(menu.Keys.escapekey:Value())then
              self:escape()
            end
            if(menu.killsteal.ks:Value() ) then
              self:killsteal()
            end
            if(menu.Keys.harasskey:Value() or menu.Keys.harasstoglekey:Value()  ) then
              self:harass()
            end
            if menu.instruct:Value() then
              menu.instruct:Value(false)
              PopUp1 = true
            end
          end
          function Lissandra:Draw()
            if menu.other.draw.qdraw:Value() and IsReady(_Q) then
              DrawCircle(myHero.x, myHero.y, myHero.z, 725,  menu.other.width.Qwidth:Value(),0,menu.other.color.Qcolor:Value())
            end

            if menu.other.draw.wdraw:Value() and IsReady(_W) then
              DrawCircle(myHero.x, myHero.y, myHero.z, 450,  menu.other.width.Wwidth:Value(),0, menu.other.color.Wcolor:Value())
            end

            if menu.other.draw.edraw:Value() and IsReady(_E) then
              DrawCircle(myHero.x, myHero.y, myHero.z, 1050,  menu.other.width.Ewidth:Value(),0, menu.other.color.Ecolor:Value())
            end

            if menu.other.draw.rdraw:Value() and IsReady(_R) then
              DrawCircle(myHero.x, myHero.y, myHero.z, 550, menu.other.width.Rwidth:Value(),0, menu.other.color.Rcolor:Value())
            end
            if menu.other.draw.aadraw:Value() then
              DrawCircle(myHero.x, myHero.y, myHero.z, 550, menu.other.width.AAwidth:Value(),0, menu.other.color.AAcolor:Value())
            end
Global:Commondraw()
              for _, target in pairs(GetEnemyHeroes()) do
                if ValidTarget(target, 15000) then
                  if target.visible and not target.dead and menu.other.damage:Value() then
                    currLine = 1
                    -- DrawLineHPBar2(self:GetMyDmg(target),"",  target, currLine)
                    DrawLineHPBar(self:GetMyDmg(target), "Damage " .. math.round(self:GetMyDmg(target)),target,currLine)
                    currLine = currLine + 1
                    DrawDmgOverHpBar(target,GetCurrentHP(target),0,self:GetMyDmg(target),0xff00ff00)
                  end
                end
              end

              if menu.other.targetcal:Value() and not myHero.dead then
                if target and target ~= nil then
                  --  local target= GetOrigin(target)
                  local drawpos=WorldToScreen(1,target.x, target.y, target.z)
                  local comboText,color = self:GetDraws(target)
                  if comboText then
                    DrawText(comboText,15,drawpos.x-20,drawpos.y-20,color)
                  end
                end
              end
            end
            function Lissandra:CastQ(unit)
              if menu.pred.selectpred:Value() == 1 then
                local QPred = GetPrediction(unit, self.Q)
                if IsReady(_Q) then
                  if QPred  and QPred.hitChance >= 0.25 then
                    CastSkillShot(_Q, QPred.castPos)
                  end
                end
              elseif menu.pred.selectpred:Value() == 2 then
                  local HitChance, y = qSpell:Predict(unit)
                  if IsReady(_Q) and HitChance >= 3 then
                    CastSkillShot(_Q, y.x, y.y, y.z)
                  end
              elseif menu.pred.selectpred:Value() == 3 then
                local qPred = GetPredictionForPlayer(myHeroPos(), unit, GetMoveSpeed(unit), math.huge, 250, 725, 20, false, true)
                if IsReady(_Q) and qPred.HitChance == 1 then
                  CastSkillShot(_Q, qPred.PredPos.x, qPred.PredPos.y, qPred.PredPos.z)
                end
              end
            end
            function Lissandra:CastW(unit)
              if IsReady(_W) and ValidTarget(unit,450) then
                CastSpell(_W)
              end
            end

            function Lissandra:CastE(unit)
              if menu.pred.selectpred:Value() == 1 then
                local EPred = GetPrediction(unit, self.E)
                if IsReady(_E) then
                  if EPred  and EPred.hitChance >= 0.25 then
                    CastSkillShot(_E, EPred.castPos)
                  end
                end
              elseif menu.pred.selectpred:Value() == 2 then
                  local HitChance, y = eSpell:Predict(unit)
                  if IsReady(_Q) and HitChance >= 3 then
                    CastSkillShot(_E, y.x, y.y, y.z)
                  end
              elseif menu.pred.selectpred:Value() == 3 then
                local ePred = GetPredictionForPlayer(myHeroPos(), unit, GetMoveSpeed(unit), math.huge, 250, 725, 20, false, true)
                if IsReady(_Q) and ePred.HitChance == 1 then
                  CastSkillShot(_E, ePred.PredPos.x, ePred.PredPos.y, ePred.PredPos.z)
                end
              end
            end

            function Lissandra:CastR(unit)
              if IsReady(_R) then
                CastTargetSpell(unit, _R)
              end
            end
            function Lissandra:CastRS(unit)
              if IsReady(_R) then
                CastSpell(_R)
              end
            end

            function Lissandra:CastI(unit)
              if Ignite then
                if IsReady(Ignite) then
                  CastTargetSpell(unit, Ignite)
                end
              end
            end
            function Lissandra:autoR()
              if ( menu.skilllogic.Rlogic.enableautoR:Value() and (menu.skilllogic.Rlogic.Rlogic:Value() == 2 or menu.skilllogic.Rlogic.Rlogic:Value() == 1)) then
                if myHero.health <= (myHero.maxHealth * menu.skilllogic.Rlogic.autoR:Value() / 100) then
                  self:CastRS(myHero)
                end
              end
            end

            function Lissandra:engagewithr()
              if menu.Keys.combokeyr:Value() then
                self:walk()
              end
              if(IsReady(_Q) and (myHero.mana / myHero.maxMana >=  menu.combo.Mana:Value() /100 )and GetDistance(target) <= self.Q.range  and menu.combo.use:Value() and menu.Keys.combokeyr:Value()  )then
                self:CastQ(target)
              end

              if(IsReady(_E) and (myHero.mana / myHero.maxMana >=  menu.combo.Mana:Value() /100 )and GetDistance(target) <= self.E.range and menu.combo.useE:Value() and menu.Keys.combokeyr:Value() )then
                local Ticker = GetTickCount()
                if (global_ticks + 2000) < Ticker then
                  if (IsReady(_E)) then
                    CastSkillShot(_E, target.x,target.y, target.z)
                    global_ticks = Ticker
                    DelayAction(function() CastSpell(_E) end, 1.5)
                  end
                end
              end

              if(IsReady(_W) and (myHero.mana / myHero.maxMana >=  menu.combo.Mana:Value() /100 ) and GetDistance(target) <= self.W.range and menu.combo.useW:Value() and  menu.Keys.combokeyr:Value()  )then
                self:CastW(target)
              end

              if(IsReady(_R) and (myHero.mana / myHero.maxMana >=  menu.combo.Mana:Value() /100 ) and GetDistance(target) <= self.R.range and menu.combo.useR:Value() and  menu.Keys.combokeyr:Value() )then
                self:CastR(target)
              end
            end
            function Lissandra:combo()

              if(IsReady(_Q) and (myHero.mana / myHero.maxMana >=  menu.combo.Mana:Value() /100 )and GetDistance(target) <= self.Q.range  and menu.combo.useQ:Value() and menu.Keys.combokey:Value()  )then
                self:CastQ(target)
              end

              if(menu.skilllogic.Elogic.combo:Value() == 1 and  (myHero.mana / myHero.maxMana >=  menu.combo.Mana:Value() /100 )and menu.combo.useE:Value() and menu.Keys.combokey:Value()  )then
                local Ticker = GetTickCount()
                if (global_ticks + 2000) < Ticker then
                  if (IsReady(_E) and GetDistance(target) <= self.E.range) then
                    CastSkillShot(_E, target.x,target.y, target.z)
                    global_ticks = Ticker
                    DelayAction(function() CastSpell(_E) end, 1.5)
                  end
                end
              end
              if(menu.skilllogic.Elogic.combo:Value() == 2 and (myHero.mana / myHero.maxMana >=  menu.combo.Mana:Value() /100 ) and menu.combo.useE:Value() and menu.Keys.combokey:Value()  )then
                local Ticker = GetTickCount()
                if (global_ticks + 2000) < Ticker then
                  if (IsReady(_E) and GetDistance(target) <= self.E.range) then
                    CastSkillShot(_E, target.x,target.y, target.z)
                    global_ticks = Ticker
                    DelayAction(function() CastSpell(_E) end, 2)
                  end
                end
              end

              if(IsReady(_W) and (myHero.mana / myHero.maxMana >=  menu.combo.Mana:Value() /100 ) and GetDistance(target) <= self.W.range and menu.combo.useW:Value() and  menu.Keys.combokey:Value()   )then
                self:CastW(target)
              end
              if(menu.skilllogic.Rlogic.Rlogic:Value() == 3 or menu.skilllogic.Rlogic.Rlogic:Value() == 1 and IsReady(_R) and (myHero.mana / myHero.maxMana >=  menu.combo.Mana:Value() /100 ) and menu.combo.useR:Value() and menu.Keys.combokey:Value()  )then
                for _, unit in pairs(GetEnemyHeroes()) do
                  local dmgR =self:GetRDmg(target)
                  local health=unit.health
                  if(health<dmgR and menu.combo.useR:Value() and GetDistance(unit)<550)then
                    self:CastR(target)
                  elseif (menu.skilllogic.Rlogic.Rlogic:Value() == 2 and  myHero.health <= (myHero.maxHealth * menu.skilllogic.Rlogic.autoR:Value() / 100)) then
                    self:CastRS(myHero)
                  end
                end
              end

              if(menu.combo.useI:Value()  and menu.Keys.combokey:Value()   )then
                for _, unit in pairs(GetEnemyHeroes()) do
                  local dmgI =(50+ ((myHero.level)*20))
                  local health=unit.health
                  if(health<dmgI and menu.combo.useI:Value()  and GetDistance(unit)<600)then
                    self:CastI(unit)
                  end
                end
              end
            end
            function Lissandra:autow()
              if menu.misc.autow.use:Value()  then
                if menu.misc.autow.enemycount:Value()  == 1 then
                  if EnemiesAround(myHeroPos() , 435) >= 2 then
                    self:CastW()
                  end
                elseif menu.misc.autow.enemycount:Value()  == 2 then
                  if EnemiesAround(myHeroPos() , 435) >= 3 then
                    self:CastW()
                  end
                elseif menu.misc.autow.enemycoun:Value()  == 3 then
                  if EnemiesAround(myHeroPos() , 435) >= 4 then
                    self:CastW()
                  end
                elseif menu.misc.autow.enemycount:Value()  == 4 then
                  if EnemiesAround(myHeroPos() , 435) >= 5 then
                    self:CastW()
                  end
                end
              end
            end

            function Lissandra:ProcessSpell(unit, spell)
       if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and IsReady(_R) then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 1000) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and  menu.misc.interrupt[GetObjectName(unit).."Inter"]:Value() and menu.misc.interrupt.r:Value() then 
         self:CastR(unit)
        end
      end
    end
            end
            function Lissandra:GetQDmg(target)
              if GetCastLevel(myHero, _Q) < 1 then
                return 0
              end
              if IsReady(_Q) then
                local FinalDamage = (40 + (GetCastLevel(myHero, _Q) * 30) + (GetBonusAP(myHero))*.65)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function Lissandra:GetWDmg(target)
              if GetCastLevel(myHero, _W) < 1 then
                return 0
              end
              if IsReady(_W) then
                local FinalDamage = (30 + (GetCastLevel(myHero, _W) * 40) + (GetBonusAP(myHero))* .4)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function Lissandra:GetEDmg(target)
              if GetCastLevel(myHero, _E) < 1 then
                return 0
              end
              if IsReady(_E) then
                local FinalDamage = (25 + (GetCastLevel(myHero, _E) * 45) + (GetBonusAP(myHero))* .6)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function Lissandra:GetRDmg(target)
              if GetCastLevel(myHero, _R) < 1 then
                return 0
              end
              if IsReady(_R) then
                local FinalDamage = (50 + (GetCastLevel(myHero, _R) * 100) + (GetBonusAP(myHero))* .7)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function Lissandra:GetMyDmg(target)
              if IsReady(_Q) and IsReady(_W) and IsReady(_R) and IsReady(_E) then
                return self:GetQDmg(target) + self:GetWDmg(target) + self:GetRDmg(target) + self:GetEDmg(target)
              elseif IsReady(_Q) and IsReady(_W) and IsReady(_R) then
                return self:GetQDmg(target) + self:GetWDmg(target) + self:GetRDmg(target)
              elseif IsReady(_Q) and IsReady(_W) and IsReady(_E) then
                return self:GetQDmg(target) + self:GetWDmg(target) + self:GetEDmg(target)
              elseif IsReady(_Q) and IsReady(_R) and IsReady(_E) then
                return self:GetQDmg(target) + self:GetRDmg(target) + self:GetEDmg(target)
              elseif IsReady(_R) and IsReady(_W) and IsReady(_E) then
                return self:GetRDmg(target) + self:GetWDmg(target) + self:GetEDmg(target)
              elseif IsReady(_Q) and IsReady(_W) then
                return self:GetQDmg(target) + self:GetWDmg(target)
              elseif IsReady(_E) and IsReady(_W) then
                return self:GetEDmg(target) + self:GetWDmg(target)
              elseif IsReady(_R) and IsReady(_W) then
                return self:GetRDmg(target) + self:GetWDmg(target)
              elseif IsReady(_Q) and IsReady(_R) then
                return self:GetQDmg(target) + self:GetRDmg(target)
              elseif IsReady(_E) and IsReady(_R) then
                return self:GetEDmg(target) + self:GetRDmg(target)
              elseif IsReady(_Q) and IsReady(_E) then
                return self:GetQDmg(target) + self:GetEDmg(target)
              elseif IsReady(_R) then
                return self:GetRDmg(target)
              elseif IsReady(_E) then
                return self:GetEDmg(target)
              elseif IsReady(_Q) then
                return self:GetQDmg(target)
              elseif IsReady(_W) then
                return self:GetWDmg(target)
              else
                return 0
              end
            end
            function Lissandra:GetDraws(target)
              local qdamage = self:GetQDmg(target)
              local wdamage = self:GetWDmg(target)
              local edamage = self:GetEDmg(target)
              local rdamage = self:GetRDmg(target)
              local Idmg=(50+ ((myHero.level)*20))

              if qdamage >target.health then
                return 'Q', GoS.White
              elseif qdamage+ Idmg>target.health then
                return 'Q + Ignite', GoS.White
              elseif wdamage >target.health then
                return 'W', GoS.White
              elseif wdamage+ Idmg>target.health then
                return 'W + Ignite', GoS.White
              elseif edamage >target.health then
                return 'E', GoS.White
              elseif edamage + Idmg>target.health then
                return 'E + Ignite', GoS.White
              elseif rdamage  >target.health then
                return 'R', GoS.White
              elseif rdamage + Idmg>target.health then
                return 'R + Ignite', GoS.White
              elseif rdamage +edamage  >target.health then
                return 'R + E',GoS.White
              elseif rdamage +edamage+ Idmg>target.health then
                return 'R + E + Ignite',GoS.White
              elseif edamage+wdamage >target.health then
                return 'E + W',GoS.White
              elseif edamage+wdamage+ Idmg>target.health then
                return 'E + W + Ignite',GoS.White
              elseif rdamage+wdamage >target.health then
                return 'R + W',GoS.White
              elseif rdamage+wdamage+ Idmg>target.health then
                return 'R + W + Ignite',GoS.White
              elseif qdamage+wdamage >target.health then
                return 'Q + W',GoS.White
              elseif qdamage+edamage>target.health then
                return 'Q + E',GoS.White
              elseif qdamage+rdamage >target.health then
                return 'Q + R',GoS.White
              elseif qdamage+wdamage+ Idmg>target.health then
                return 'Q + W + Ignite',GoS.White
              elseif qdamage+edamage+ Idmg>target.health then
                return 'Q + E + Ignite',GoS.White
              elseif qdamage+rdamage+ Idmg>target.health then
                return 'Q + R + Ignite',GoS.White
              elseif qdamage+edamage+wdamage >target.health then
                return 'Q + W + E',GoS.White
              elseif qdamage+rdamage+wdamage >target.health then
                return 'Q + W + R',GoS.White
              elseif qdamage+edamage+rdamage >target.health then
                return 'Q + R + E',GoS.White
              elseif qdamage+edamage+wdamage+ Idmg>target.health then
                return 'Q + W + E + Ignite',GoS.White
              elseif qdamage+wdamage+edamage+rdamage >target.health then
                return 'Kill with full combo',GoS.White
              elseif qdamage+wdamage+edamage+rdamage+Idmg>target.health then
                return 'Full Combo + Ignite',GoS.White
              else
                return "Cant Kill yet", GoS.White
              end
            end
            function Lissandra:killsteal()
              for _, unit in pairs(GetEnemyHeroes()) do
                local health = unit.health
                local dmgE = self:GetEDmg(unit)
                if(GetDistance(unit) <= self.E.range and  IsReady(_E) and health<dmgE and menu.killsteal.useE:Value()    and menu.killsteal.ks:Value() )then
                  local Ticker = GetTickCount()
                  if (global_ticks + 2000) < Ticker then
                    if (IsReady(_E) and GetDistance(unit) <= self.E.range) then
                      CastSkillShot(_E, unit.x,unit.y, unit.z)
                      global_ticks = Ticker
                      DelayAction(function() CastSpell(_E) end, 2)
                    end
                  end
                end
                local dmgQ = self:GetQDmg(unit)
                if(GetDistance(target) <= self.Q.range and  IsReady(_Q) and health<dmgQ and menu.killsteal.useQ:Value()  and menu.killsteal.ks:Value()  )then
                  self:CastQ(unit)
                end
                local dmgW = self:GetWDmg(unit)
                if(GetDistance(target) <= self.W.range and  IsReady(_W) and health<dmgQ and menu.killsteal.useW:Value()  and menu.killsteal.ks:Value()  )then
                  self:CastW(unit)
                end
                local dmgI =(50+ ((myHero.level)*20))
                if(health<dmgI and menu.killsteal.useI:Value()  and menu.killsteal.ks:Value()  and GetDistance(unit)<600)then
                  self:CastI(unit)
                end
                local dmgR =self:GetRDmg(unit)
                if(GetDistance(target) <= self.R.range and  IsReady(_R) and health<dmgR and menu.killsteal.useR:Value()  and menu.killsteal.ks:Value()  and GetDistance(unit)<550)then
                  self:CastR(unit)
                end
              end
            end
            -- burda kaldım ------------------------------------------------------------------
            function Lissandra:escape()
              local Ticker = GetTickCount()
              if (global_ticks + 2000) < Ticker then
                if menu.Keys.escapekey:Value()  and menu.escape.useE:Value()   then
                  if (myHero:CanUseSpell(_E) == READY ) then
                    CastSkillShot(_E,mousePos.x,mousePos.y,mousePos.z)
                    global_ticks = Ticker
                    DelayAction(function() CastSpell(_E) end, 1.5)
                  end
                end
              end
              if menu.Keys.escapekey:Value()  then
                self:walk()
              end
              if menu.Keys.escapekey:Value()  and menu.escape.useW:Value()  and GetDistance(target) <= self.W.range then
                CastSkillShot(_W,target)
              end
            end
            function Lissandra:walk()
              MoveToXYZ(mousePos)
            end
            function Lissandra:harass()

              if menu.Keys.harasskey:Value() or menu.Keys.harasstoglekey:Value() then
                if(IsReady(_Q) and (myHero.mana / myHero.maxMana >=  menu.harass.Mana:Value() /100 ) and GetDistance(target) <= self.Q.range and menu.harass.useQ:Value() ) then
                  self:CastQ(target)
                end
              end
              if menu.Keys.harasskey:Value() or menu.Keys.harasstoglekey:Value() then
                if(IsReady(_W) and (myHero.mana / myHero.maxMana >=  menu.harass.Mana:Value() /100 ) and GetDistance(target) <= self.W.range and menu.harass.useW:Value() ) then
                  self:CastW(target)
                end
              end
              if menu.Keys.harasskey:Value() or menu.Keys.harasstoglekey:Value()  then
                if(menu.skilllogic.Elogic.harass:Value() == 1  and (myHero.mana / myHero.maxMana >=  menu.harass.Mana:Value() /100 )  and menu.harass.useE:Value() ) then
                  local Ticker = GetTickCount()
                  if (global_ticks + 2000) < Ticker then
                    if (myHero:CanUseSpell(_E) == READY and GetDistance(target) <= self.E.range) then
                      CastSkillShot(_E, target.x,target.y, target.z)
                      global_ticks = Ticker
                      DelayAction(function() CastSpell(_E) end, 2)
                    end
                  end
                end
              end
              if menu.Keys.harasskey:Value() or menu.Keys.harasstoglekey:Value()  then
                if(menu.skilllogic.Elogic.harass:Value() == 2 and   (myHero.mana / myHero.maxMana >=  menu.harass.Mana:Value() /100 )  and menu.harass.useE:Value() ) then
                  local Ticker = GetTickCount()
                  if (global_ticks + 2000) < Ticker then
                    if (myHero:CanUseSpell(_E) == READY and GetDistance(target) <= self.E.range) then
                      CastSkillShot(_E, target.x,target.y, target.z)
                      global_ticks = Ticker
                      DelayAction(function() CastSpell(_E) end, 1.5)
                    end
                  end
                end
              end
            end
            function Lissandra:LastHit()
              for _, target in pairs(minionManager.objects) do
                if IsObjectAlive(target) and GetTeam(target) == MINION_ENEMY then
                  if menu.farm.lasthit.lasthitlogic:Value() == 1 then
                    local Qdamage = self:GetQDmg(target)
                    if(IsReady(_Q) and menu.farm.lasthit.useQ:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.lasthit.QMana:Value() /100 ) and ValidTarget(target,725)  and Qdamage >= GetCurrentHP(target)) then
                      self:CastQ(target)
                    end
                    local Wdamage = self:GetWDmg(target)
                    if(IsReady(_W) and menu.farm.lasthit.useW:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.lasthit.WMana:Value()/100 )and  ValidTarget(target,450)  and Wdamage >= GetCurrentHP(target)) then
                      self:CastW(target)
                    end
                  end
                end
              end
            end
            function Lissandra:LaneClear()
              for i, minion in pairs(minionManager.objects) do
                if ValidTarget(minion) and minion ~= nil and GetTeam(minion) == MINION_ENEMY then
                  local NumberOfHits = menu.farm.laneclear.wcount:Value()
                  if menu.Keys.laneclearkey:Value()  and menu.farm.laneclear.useW:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.laneclear.WMana:Value() /100 ) and GetDistance(minion) <= 450 then
                    self:CastW(minion)
                  end
                end
              end
              if (myHero.mana / myHero.maxMana >=  menu.farm.laneclear.QMana:Value() /100 ) then
                local NumberOfHits = menu.farm.laneclear.qcount:Value()
                if IsReady(_Q) then
                  if  menu.farm.laneclear.useQ:Value()   then
                    local BestPos, BestHit =  GetLineFarmPosition(self.Q.range, self.Q.width, MINION_ENEMY)
                    if BestPos   and  BestHit >= NumberOfHits then
                      CastSkillShot(_Q, BestPos)
                    end
                  end
                end
              end
              if (myHero.mana / myHero.maxMana >=  menu.farm.laneclear.EMana:Value() /100 ) then
                local NumberOfHits = menu.farm.laneclear.ecount:Value()
                if menu.farm.laneclear.useE:Value()   then
                  local BestPos, BestHit = GetLineFarmPosition(self.E.range, self.E.width, MINION_ENEMY)
                  if BestPos and  BestHit >= NumberOfHits then
                    local Ticker = GetTickCount()
                    if (global_ticks + 2000) < Ticker then
                      if (myHero:CanUseSpell(_E) == READY ) then
                        CastSkillShot(_E, BestPos)
                        global_ticks = Ticker
                        DelayAction(function() CastSpell(_E) end, 2)
                      end
                    end
                  end
                end
              end
            end
            function Lissandra:autoq()

              if(IsReady(_Q) and (myHero.mana / myHero.maxMana >=  menu.harass.Mana:Value() /100 )  and menu.harass.autoq:Value() ) then
                self:CastQ(target)
              end
            end
            function Lissandra:JungleClear()
              for i, minion in pairs(minionManager.objects) do
                if ValidTarget(minion) and minion ~= nil and GetTeam(minion) == MINION_JUNGLE then
                  local NumberOfHits = 1
                  if menu.farm.jungleclear.useW:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.jungleclear.WMana:Value() /100 ) and GetDistance(minion) <= 450 then
                    self:CastW(minion)
                  end
                end
              end
              if (myHero.mana / myHero.maxMana >=  menu.farm.jungleclear.QMana:Value() /100 ) then
                local NumberOfHits = 1
                if IsReady(_Q) then
                  if  menu.farm.jungleclear.useQ:Value()   then
                    local BestPos, BestHit =  GetFarmPosition(self.Q.range, self.Q.width, MINION_JUNGLE)
                    if BestPos  and  BestHit >= NumberOfHits then
                      CastSkillShot(_Q, BestPos)
                    end
                  end
                end
              end
              if (myHero.mana / myHero.maxMana >=  menu.farm.jungleclear.EMana:Value() /100 ) then
                local NumberOfHits = 1
                if menu.farm.jungleclear.useE:Value()   then
                  local BestPos, BestHit = GetLineFarmPosition(self.E.range, self.E.width, MINION_JUNGLE)
                  if BestPos  and  BestHit >= NumberOfHits then
                    local Ticker = GetTickCount()
                    if (global_ticks + 2000) < Ticker then
                      if (myHero:CanUseSpell(_E) == READY ) then
                        CastSkillShot(_E, BestPos)
                        global_ticks = Ticker
                        DelayAction(function() CastSpell(_E) end, 2)
                      end
                    end
                  end
                end
              end
            end
            function Lissandra:onload()
              findorb()
            end
            function Lissandra:LoadMenu()
              menu=MenuConfig("menu",""..Scriptname.." [" .. myHero.charName.."]" )

              menu:Menu("combo",loc_eng[1])
              menu.combo:Boolean("useQ", loc_eng[2], true)
              menu.combo:Boolean("useW", loc_eng[3], true)
              menu.combo:Boolean("useE", loc_eng[4], true)
              menu.combo:Boolean("useR", loc_eng[5], true)
              menu.combo:Boolean("useI", loc_eng[6], true)
              menu.combo:Slider("Mana",loc_eng[8], 10, 10, 100, 1)

              menu:Menu( "harass",loc_eng[9])
              menu.harass:Boolean("useQ", loc_eng[10], true)
              menu.harass:Boolean("useW", loc_eng[11], false)
              menu.harass:Boolean("useE", loc_eng[12], true)
              menu.harass:Boolean("autoq", loc_eng[91], false)
              menu.harass:Slider("Mana",loc_eng[8], 30, 10, 100, 1)

              menu:Menu("skilllogic",loc_eng[99])
              menu.skilllogic:Menu( "Elogic",loc_eng[102])
              menu.skilllogic.Elogic:DropDown("combo", loc_eng[143], 2, {loc_eng[145], loc_eng[146] })
              menu.skilllogic.Elogic:DropDown("harass", loc_eng[144], 1, {loc_eng[146], loc_eng[145] })
              menu.skilllogic.Elogic:Info("blank", "")
              menu.skilllogic.Elogic:Info("infoE", loc_eng[154])
              menu.skilllogic:Menu( "Rlogic",loc_eng[103])
              menu.skilllogic.Rlogic:DropDown("Rlogic", loc_eng[155], 1, {loc_eng[149], loc_eng[150], loc_eng[151] })
              menu.skilllogic.Rlogic:Boolean("enableautoR", loc_eng[152], true)
              menu.skilllogic.Rlogic:Slider("autoR", loc_eng[153],  10, 0, 100, 1)
              menu.skilllogic.Rlogic:Info("infoR2", "")
              menu.skilllogic.Rlogic:Boolean("infoR", loc_eng[156])

              menu:Menu("escape",loc_eng[30])
              menu.escape:Boolean("useW",loc_eng[32],true)
              menu.escape:Boolean("useE",loc_eng[33],true)

              menu:Menu( "farm",loc_eng[14])

              menu.farm:Menu("laneclear",loc_eng[15])
              menu.farm.laneclear:Boolean("useQ",loc_eng[16],true)
              menu.farm.laneclear:Slider("qcount",loc_eng[180], 2, 1, 10, 1)
              menu.farm.laneclear:Boolean("useW",loc_eng[17],true)
              menu.farm.laneclear:Slider("wcount",loc_eng[181], 2, 1, 10, 1)
              menu.farm.laneclear:Boolean("useE",loc_eng[18],true)
              menu.farm.laneclear:Slider("ecount",loc_eng[182], 2, 1, 10, 1)
              menu.farm.laneclear:Info("blank", "")
              menu.farm.laneclear:Info("blank", "")
              menu.farm.laneclear:Info("info2", loc_eng[184])
              menu.farm.laneclear:Slider("QMana",loc_eng[185], 30, 10, 100, 1)
              menu.farm.laneclear:Slider("WMana",loc_eng[186], 30, 10, 100, 1)
              menu.farm.laneclear:Slider("EMana",loc_eng[187], 30, 10, 100, 1)

              menu.farm:Menu("jungleclear",loc_eng[20])
              menu.farm.jungleclear:Boolean("useQ",loc_eng[21],true)
              menu.farm.jungleclear:Boolean("useW",loc_eng[22],true)
              menu.farm.jungleclear:Boolean("useE",loc_eng[23],true)
              menu.farm.jungleclear:Info("blank", "")
              menu.farm.jungleclear:Info("blank", "")
              menu.farm.jungleclear:Info("info2", loc_eng[184])
              menu.farm.jungleclear:Slider("QMana",loc_eng[185], 30, 10, 100, 1)
              menu.farm.jungleclear:Slider("WMana",loc_eng[186], 30, 10, 100, 1)
              menu.farm.jungleclear:Slider("EMana",loc_eng[187], 30, 10, 100, 1)

              menu.farm:Menu("lasthit",loc_eng[25])
              menu.farm.lasthit:Boolean("autolasthit",loc_eng[189],false)
              menu.farm.lasthit:Boolean("useQ",loc_eng[26],true)
              menu.farm.lasthit:Boolean("useW",loc_eng[27],true)
              menu.farm.lasthit:DropDown("lasthitlogic",loc_eng[191], 1, {loc_eng[172],loc_eng[190],loc_eng[174]})
              menu.farm.lasthit:Info("blank", "")
              menu.farm.lasthit:Info("blank", "")
              menu.farm.lasthit:Info("info2", loc_eng[184])
              menu.farm.lasthit:Slider("QMana",loc_eng[185], 30, 10, 100, 1)
              menu.farm.lasthit:Slider("WMana",loc_eng[186], 30, 10, 100, 1)


              menu:Menu( "killsteal",loc_eng[35])
              menu.killsteal:Boolean("ks",loc_eng[36],true)
              menu.killsteal:Boolean("useQ", loc_eng[37], true)
              menu.killsteal:Boolean("useW", loc_eng[38], true)
              menu.killsteal:Boolean("useE", loc_eng[39], true)
              menu.killsteal:Boolean("useR", loc_eng[40], true)
              menu.killsteal:Boolean("useI", loc_eng[41], true)

Activator:Loadmenu("ap")

              menu:Menu( "misc",loc_eng[92])
              menu.misc:Menu( "gapClose1",loc_eng[219])
              menu.misc.gapClose1:Menu( "gapClose1w","Gap Close - W Settings")
              menu.misc.gapClose1.gapClose1w:Info("info3", loc_eng[98] )
              menu.misc:Menu("interrupt",loc_eng[93])
              menu.misc.interrupt:Boolean("r", loc_eng[97], true)
              menu.misc.interrupt:Info("info3", loc_eng[98])
DelayAction(function()
  local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
  for i, spell in pairs(CHANELLING_SPELLS) do
    for _,k in pairs(GetEnemyHeroes()) do
        if spell["Name"] == GetObjectName(k) then
        menu.misc.interrupt:Boolean(GetObjectName(k).."Inter", "On "..GetObjectName(k).." "..(type(spell.Spellslot) == 'number' and str[spell.Spellslot]), true)
        end
    end
  end
end, 0.35)
              menu.misc:Menu( "autow","[" .. myHero.charName.. "] - Auto W Settings")
              menu.misc.autow:Boolean("use", loc_eng[223], true)
              menu.misc.autow:DropDown("enemycount", loc_eng[224], 1, {loc_eng[130], loc_eng[131] , loc_eng[132],loc_eng[133] })
              menu.misc:Menu( "skinhack","[" .. myHero.charName.. "] - Skinhack Settings")
              menu.misc.skinhack:Boolean("useskin",loc_eng[54], false)
              menu.misc.skinhack:DropDown('selected' .. myHero.charName .. 'Skin', loc_eng[57]  ,  1, skinMeta[myHero.charName])
              menu.misc:Menu( "autolevel","[" .. myHero.charName.. "] - AutoLevel Settings")
              menu.misc.autolevel:Boolean("uselevel",loc_eng[51], false)
              menu.misc.autolevel:DropDown("logic", loc_eng[52] , 7, {loc_eng[58], loc_eng[59],loc_eng[60],loc_eng[61],loc_eng[62], loc_eng[63], loc_eng[64]  })
              menu.misc:Menu( "antiafk","[" .. myHero.charName.. "] - AntiAFK Settings")
              menu.misc.antiafk:Boolean("useafk",loc_eng[196], false)
              Clock = os.clock()


              menu:Menu("other",loc_eng[65])
              --menu.other:Menu("Show Damage On Hp Bar", "HPBAR")
              --menu.other.HPBAR:Boolean("key","ON/OFF",true)
              menu.other:Menu("draw",loc_eng[66])
              menu.other.draw:Boolean("qdraw",loc_eng[67],true)
              menu.other.draw:Boolean("wdraw",loc_eng[68],true)
              menu.other.draw:Boolean("edraw",loc_eng[69],true)
              menu.other.draw:Boolean("rdraw",loc_eng[70],true)
              menu.other.draw:Boolean("aadraw",loc_eng[71],false)
              menu.other:Menu( "color",loc_eng[198])
              menu.other.color:ColorPick("Qcolor", loc_eng[199],{255, 255, 255, 255})
              menu.other.color:ColorPick("Wcolor", loc_eng[200],{255, 255, 255, 255})
              menu.other.color:ColorPick("Ecolor", loc_eng[201],{255, 255, 255, 255})
              menu.other.color:ColorPick("Rcolor", loc_eng[202],{255, 255, 255, 255})
              menu.other.color:ColorPick("E2color", loc_eng[203],{255, 255, 255, 255})
              menu.other.color:ColorPick("AAcolor", loc_eng[204],{255, 255,0,0})
              --  menu.other.color:ColorPick("targetselect", loc_eng[205],{255, 255,0,0})
              menu.other:Menu( "width",loc_eng[206])
              menu.other.width:Slider("Qwidth", loc_eng[210], 1, 1, 10, 1)
              menu.other.width:Slider("Wwidth", loc_eng[211], 1, 1, 10, 1)
              menu.other.width:Slider("Ewidth", loc_eng[212], 1, 1, 10, 1)
              menu.other.width:Slider("Rwidth", loc_eng[213], 1, 1, 10, 1)
              menu.other.width:Slider("AAwidth", loc_eng[209], 1, 1, 10, 1)
              --  menu.other.width:Slider("STwidth", loc_eng[208], 6, 1, 10, 1)
              --menu.other:Menu( "perma",loc_eng[73])
              -- menu.other.perma:Boolean("perma",loc_eng[74],true)
              menu.other:Boolean("target",loc_eng[75],true)
              menu.other:Boolean("damage",loc_eng[214],true)
              menu.other:Boolean("targetcal",loc_eng[76],true)

              menu:Menu("targetsel",loc_eng[77])
              menu.targetsel:Boolean("ts",loc_eng[78], false)

              menu:Menu("orb","Orbwalker Settings")
              menu.orb:Menu( "selectorb","Current Orbwalker :")

              menu:Menu("pred","Prediction Settings")
              menu.pred:DropDown("selectpred","Current Predictions :",   1, {"Open Prediction","IPrediction","Gos Prediction"})
              menu.pred:Menu( "hcgeneral","Hitchance Settings")
              menu.pred.hcgeneral:Menu( "hcop","Open Prediction Hitchance")
              menu.pred.hcgeneral.hcop:Slider("hcopq", "Q Hitchance " , 30, 0, 100, 1)
              menu.pred.hcgeneral.hcop:Slider("hcope", "E Hitchance " , 30, 0, 100, 1)
              menu.pred:Info("blank", "    Currently Open Prediction "   )
              menu.pred:Info("blank", "      is best with this bundle"   )

              menu:Menu( "Keys",loc_eng[79])
              menu.Keys:Info("infoK3", loc_eng[80])
              menu.Keys:Key("combokey", loc_eng[81], string.byte(" "))
              menu.Keys:Key("combokeyr", loc_eng[170], string.byte("U"))
              menu.Keys:Info("infoK4", loc_eng[82])
              menu.Keys:Key("harasskey", loc_eng[83], string.byte("C"))
              menu.Keys:Key("harasstoglekey", loc_eng[164], string.byte("T"))
              menu.Keys:Info("infoK5", loc_eng[84])
              menu.Keys:Key("laneclearkey", loc_eng[85], string.byte("V"))
              menu.Keys:Key("jungleclearkey", loc_eng[86], string.byte("V"))
              menu.Keys:Key("lasthitkey",loc_eng[215], string.byte("X"))
              --menu.Keys:Boolean("lasthitkey", "Lasthit Key", string.byte("X"))
              menu.Keys:Info("infoK6", loc_eng[87])
              menu.Keys:Key("escapekey", loc_eng[88], string.byte("Y"))
              menu.Keys:Info("infoK", "")
              menu.Keys:Info("infoK2", loc_eng[89])

              menu:Info("infoK","           "..Scriptname.."" )
              menu:Info("infoK","         Script Version:  "..Version.. "  " )
              menu:Info("infoK","   Script was made by  "..Author.. "" )
              menu:Info("infoK","Leauge Of Legends Version: "..LVersion.. "" )
              menu:Boolean("instruct", loc_eng[216], false)

            end

      function Lissandra:WndMsg(Msg, Key)
        if menu.targetsel.ts:Value() then
          if Msg == WM_LBUTTONDOWN then
            local minD = 10
            local starget = nil
            for i, enemy in ipairs(GetEnemyHeroes()) do
              if ValidTarget(enemy) then
                if GetDistance(enemy, mousePos) <= minD or starget == nil then
                  minD = GetDistance(enemy, mousePos)
                  starget = enemy
                end
              end
            end
            if starget and minD < 150 then
              if self.selectedTar and starget.charName == self.selectedTar.charName then
                self.selectedTar = nil
                print("<font color=\"#FFFFFF\">Target <b>is no loger selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
              else
                self.selectedTar = starget
                print("<font color=\"#FFFFFF\">New target <b>selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
              end
            end
          end
        end
        if Msg == WM_LBUTTONDOWN then
          if PopUp1 then
            PopUp1 = false
          end
        end
      end

      local Qbuff = false
      class "Akali"
      function Akali:__init()
              if not libloaded then return end
        self.Q = {  range = 600 }
        self.E = {  range = 315 }
        self.R = { range = 700  }
        self:LoadMenu()
        Last_LevelSpell = 0
        AddGapcloseEvent(_W, 100, false,  menu.misc.gapClose)
        self.tsg = TargetSelector(925,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
        Callback.Add("Tick", function() self:Tick() end)
        Callback.Add("Load", function() self:onload() end)
        Callback.Add("WndMsg", function(Msg, Key) self:WndMsg(Msg, Key) end)
        Callback.Add("Draw", function() self:Draw() end)
        Callback.Add("UpdateBuff", function(unit,buff) self:UpdateBuff(unit,buff) end)
        Callback.Add("RemoveBuff", function(unit,buff) self:RemoveBuff(unit,buff) end)
      end
      function  Akali:Checks()
        Gtarget = self.tsg:GetTarget()
        if not ValidTarget(Gtarget, 925) or not menu.targetsel.ts:Value()  then
          target = GetCurrentTarget()
        elseif  ValidTarget(Gtarget, 925) and not self.selectedTar then
          target = GetCurrentTarget()
        elseif (ValidTarget(Gtarget, 925) and self.selectedTar) then
          target = self.selectedTar
        end
        mousePos = GetMousePos()
         Activator:Loaditems("hybrid")

      end
      function Akali:Tick()
        self:Checks()
        autopot()
        self:autoq()
        self:Autostealth()
        Antiafk()
        autolevel()
        skinhack()
       Activator:Useitems("hybrid")
        if menu.Keys.autoq:Value() then
          self:autoq()
        end
        if(menu.Keys.combokey:Value()  and menu.skilllogic.Rlogic.logic:Value()  == 1 )then
          self:combo()
        end
        if(menu.Keys.combokey:Value()  and menu.skilllogic.Rlogic.logic:Value()  == 2 )then
          self:combo2()
        end
        if(menu.Keys.jungleclearkey:Value() )then
          self:JungleClear()
        end
        if(menu.killsteal.ks:Value() ) then
          self:killsteal()
        end
        if(menu.Keys.lasthitkey:Value() or menu.farm.lasthit.autolasthit:Value() )then
          self:LastHit()
        end
        if(menu.Keys.laneclearkey:Value() )then
          self:LaneClear()
        end
        if(menu.Keys.harasskey:Value()  ) then
          self:harass()
        end
        if(menu.Keys.escapekey:Value() )then
          self:escape()
        end
        if menu.instruct:Value() then
          menu.instruct:Value(false)
          PopUp1 = true
        end
      end
      function Akali:Draw()
        if menu.other.draw.qdraw:Value() and IsReady(_Q) then
          DrawCircle(myHero.x, myHero.y, myHero.z, 600,  menu.other.width.Qwidth:Value(),0,menu.other.color.Qcolor:Value())
        end

        if menu.other.draw.wdraw:Value() and IsReady(_W) then
          DrawCircle(myHero.x, myHero.y, myHero.z, 700,  menu.other.width.Wwidth:Value(),0, menu.other.color.Wcolor:Value())
        end

        if menu.other.draw.edraw:Value() and IsReady(_E) then
          DrawCircle(myHero.x, myHero.y, myHero.z, 325,  menu.other.width.Ewidth:Value(),0, menu.other.color.Ecolor:Value())
        end

        if menu.other.draw.rdraw:Value() and IsReady(_R) then
          DrawCircle(myHero.x, myHero.y, myHero.z, 700, menu.other.width.Rwidth:Value(),0, menu.other.color.Rcolor:Value())
        end
        if menu.other.draw.aadraw:Value() then
          DrawCircle(myHero.x, myHero.y, myHero.z, 125, menu.other.width.AAwidth:Value(),0, menu.other.color.AAcolor:Value())
        end
         Global:Commondraw()
            for _, target in pairs(GetEnemyHeroes()) do
              if ValidTarget(target, 15000) then
                if target.visible and not target.dead and menu.other.damage:Value() then
                  currLine = 1
                  -- DrawLineHPBar2(self:GetMyDmg(target),"",  target, currLine)
                  DrawLineHPBar(self:GetMyDmg(target), "Damage " .. math.round(self:GetMyDmg(target)),target,currLine)
                  currLine = currLine + 1
                  DrawDmgOverHpBar(target,GetCurrentHP(target),0,self:GetMyDmg(target),0xff00ff00)
                end
              end
            end

            if menu.other.targetcal:Value() and not myHero.dead then
              if target and target ~= nil then
                --  local target= GetOrigin(target)
                local drawpos=WorldToScreen(1,target.x, target.y, target.z)
                local comboText,color = self:GetDraws(target)
                if comboText then
                  DrawText(comboText,15,drawpos.x-20,drawpos.y-20,color)
                end
              end
            end
          end
          function Akali:CastQ(unit)
            if IsReady(_Q) then
              CastTargetSpell(unit, _Q)
            end
          end

          function Akali:CastW(unit)
            if IsReady(_W) then
              CastSpell(_W)
            end
          end

          function Akali:CastE(unit)
            if IsReady(_E) then
              CastSpell(_E)
            end
          end

          function Akali:CastR(unit)
            if IsReady(_R) then
              CastTargetSpell(unit, _R)
            end
          end
          function Akali:CastI(unit)
            local Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
            if Ignite then
              if IsReady(Ignite) then
                CastTargetSpell(unit, Ignite)
              end
            end
          end
          function Akali:combo()
            if(GetDistance(target) <= self.Q.range and menu.combo.useQ:Value() and  menu.Keys.combokey:Value()  and IsReady(_Q))then
              self:CastQ(target)
            end
            if(GetDistance(target) <= self.R.range and menu.combo.useR:Value() and Qbuff and  menu.Keys.combokey:Value() and not IsReady(_Q) and IsReady(_R))then
              self:CastR(target)
            end
            if(GetDistance(target) <= self.E.range and GetDistance(target)<315 and menu.combo.useE:Value() and  menu.Keys.combokey:Value()  and IsReady(_E))then
              self:CastE(target)
            end
            if(menu.combo.useI:Value() and menu.Keys.combokey:Value()  )then
              for _, unit in pairs(GetEnemyHeroes()) do
                local dmgI =(50+ ((myHero.level)*20))
                local health=unit.health
                if(health<dmgI and menu.combo.useI:Value() and GetDistance(unit)<600)then
                  self:CastI(unit)
                end
              end
            end
          end
          function Akali:combo2()
            if(GetDistance(target) <= self.Q.range and menu.combo.useQ:Value() and  menu.Keys.combokey:Value()  and IsReady(_Q))then
              self:CastQ(target)
            end
            if(GetDistance(target) <= self.R.range and menu.combo.useR:Value() and  menu.Keys.combokey:Value()  and not IsReady(_Q) and IsReady(_R))then
              self:CastR(target)
            end
            if(GetDistance(target) <= self.E.range  and menu.combo.useE:Value() and  menu.Keys.combokey:Value()  and IsReady(_E))then
              self:CastE(target)
            end
            if(menu.combo.useI:Value() and menu.Keys.combokey:Value() )then
              for _, unit in pairs(GetEnemyHeroes()) do
                local dmgI =(50+ ((myHero.level)*20))
                local health=unit.health
                if(health<dmgI and menu.combo.useI:Value() and GetDistance(unit)<600)then
                  self:CastI(unit)
                end
              end
            end
          end
          function Akali:harass()
            if(GetDistance(target) <= self.Q.range and menu.harass.useQ:Value() and  menu.Keys.harasskey:Value()  and IsReady(_Q))then
              self:CastQ(target)
            end
            if(GetDistance(target) <= self.E.range  and menu.harass.useE:Value() and  menu.Keys.harasskey:Value()  and IsReady(_E))then
              self:CastE(target)
            end
          end
          function Akali:JungleClear()
            for i, minion in pairs(minionManager.objects) do
              if ValidTarget(minion) and minion ~= nil and  GetTeam(minion) == MINION_JUNGLE then
                if menu.Keys.jungleclearkey:Value()  and menu.farm.jungleclear.useQ:Value()  and (myHero.mana / myHero.maxMana >=  menu.farm.jungleclear.QMana:Value()  /100 ) and GetDistance(minion) <= self.Q.range then
                  self:CastQ(minion)
                end

                if menu.Keys.jungleclearkey:Value()  and menu.farm.jungleclear.useE:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.jungleclear.EMana:Value()  /100 ) and GetDistance(minion) <= self.E.range then
                  self:CastE(minion)
                end
                if menu.Keys.jungleclearkey:Value()  and menu.farm.jungleclear.useR:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.jungleclear.RMana:Value()  /100 ) and GetDistance(minion) <= self.E.range then
                  self:CastR(minion)
                end
              end
            end
          end
          function Akali:LastHit()
            for _, target in pairs(minionManager.objects) do
              if IsObjectAlive(target) and GetTeam(target) == MINION_ENEMY then
                if menu.farm.lasthit.lasthitlogic:Value() == 1 then
                  local Qdamage = self:GetQDmg(target)
                  if(IsReady(_Q) and menu.farm.lasthit.useQ:Value()  and (myHero.mana / myHero.maxMana >=  menu.farm.lasthit.QMana:Value() /100 ) and ValidTarget(target,self.Q.range)   and Qdamage >= GetCurrentHP(target)) then
                    self:CastQ(target)
                  end
                  local Edamage = self:GetEDmg(target)
                  if(IsReady(_E) and menu.farm.lasthit.useE:Value()  and (myHero.mana / myHero.maxMana >=  menu.farm.lasthit.EMana:Value() /100 )and  ValidTarget(target,self.E.range)  and Edamage >= GetCurrentHP(target)) then
                    self:CastE(target)
                  end
                end
              end
            end
          end
          function Akali:LaneClear()
            for i, minion in pairs(minionManager.objects) do
              if ValidTarget(minion) and minion ~= nil and  GetTeam(minion) == MINION_ENEMY then
                if menu.Keys.laneclearkey:Value()  and menu.farm.laneclear.useQ:Value()  and (myHero.mana / myHero.maxMana >=  menu.farm.laneclear.QMana:Value()  /100 ) and GetDistance(minion) <= self.Q.range then
                  self:CastQ(minion)
                end
                local NumberOfHits = menu.farm.laneclear.ecount:Value()
                if NumberOfHits >= 1 and #minionManager.objects >= NumberOfHits then
                  if menu.Keys.laneclearkey:Value()  and menu.farm.laneclear.useE:Value() and (myHero.mana / myHero.maxMana >=  menu.farm.laneclear.EMana:Value()  /100 ) and GetDistance(minion) <= self.E.range then
                    self:CastE(minion)
                  end
                end
              end
            end
          end
          function Akali:UpdateBuff(unit,buff)
            if unit and unit.team ~= myHero.team and unit.type == myHero.type then
              if buff.Name == "AkaliMota" then
                Qbuff = true
              end
            end
          end
          function Akali:RemoveBuff(unit, buff)
            if unit and unit.team ~= myHero.team and unit.type == myHero.type then
              if buff.Name == "AkaliMota" then

                Qbuff = false
              end
            end
          end
          function Akali:walk()
            MoveToXYZ(mousePos)
          end
          function Akali:escape()
            if menu.Keys.escapekey:Value()  and menu.escape.useW:Value() then
              CastSkillShot(_W, GetMousePos())
            end
            if menu.Keys.escapekey:Value()  then
              self:walk()
            end
            for i, minion in pairs(minionManager.objects) do
              if IsReady(_R) then
                if ValidTarget(minion) and minion ~= nil and GetTeam(minion) == MINION_ENEMY then
                  if menu.Keys.escapekey:Value()and menu.escape.useR:Value() then
                    if GetDistance(minion, GetMousePos()) < 250 then
                      CastTargetSpell(minion, _R)
                    end
                  end
                end
              end
            end
          end

    function Akali:autoq()
      if(GetDistance(target) <= self.Q.range and menu.Keys.autoq:Value() and  IsReady(_Q))then
        self:CastQ(target)
      end
    end
    function Akali:GetQDmg(target)
      if GetCastLevel(myHero, _Q) < 1 then
        return 0
      end
      if IsReady(_Q) then
        local FinalDamage = (15 + (GetCastLevel(myHero, _Q) * 20) + (GetBonusAP(myHero))*.4)
        return CalcDamage(myHero,target,FinalDamage, 0)
      else
        return 0
      end
    end
    function Akali:GetQ2Dmg(target)
      if GetCastLevel(myHero, _Q) < 1 then
        return 0
      end
      if IsReady(_Q) then
        local FinalDamage = (20 + (GetCastLevel(myHero, _Q) * 25) + (GetBonusAP(myHero))*.5)
        return CalcDamage(myHero,target,0, FinalDamage)
      else
        return 0
      end
    end
    function Akali:GetEDmg(target)
      if GetCastLevel(myHero, _E) < 1 then
        return 0
      end
      if IsReady(_E) then
        local FinalDamage = (5 + (GetCastLevel(myHero, _E) * 25) + ((GetBonusAP(myHero))*.4)+(myHero.totalDamage) *0.6)
        return CalcDamage(myHero,target,FinalDamage, 0)
      else
        return 0
      end
    end
    function Akali:GetRDmg(target)
      if GetCastLevel(myHero, _R) < 1 then
        return 0
      end
      if IsReady(_R) then
        local FinalDamage = (25 + (GetCastLevel(myHero, _R) * 75) + (GetBonusAP(myHero))* .5)
        return CalcDamage(myHero,target, FinalDamage,0)
      else
        return 0
      end
    end
    function Akali:GetMyDmg(target)
      if IsReady(_Q) and IsReady(_R) and IsReady(_E) then
        return self:GetQDmg(target) + self:GetRDmg(target) + self:GetEDmg(target) +self:GetQ2Dmg(target)
      elseif IsReady(_Q)  and IsReady(_R) then
        return self:GetQDmg(target) + self:GetRDmg(target) +self:GetQ2Dmg(target)
      elseif IsReady(_Q)  and IsReady(_E) then
        return self:GetQDmg(target) + self:GetEDmg(target) +self:GetQ2Dmg(target)
      elseif IsReady(_R) and IsReady(_E) then
        return self:GetRDmg(target) +self:GetEDmg(target)
      elseif IsReady(_Q) then
        return self:GetQDmg(target)
      elseif IsReady(_E) then
        return self:GetEDmg(target)
      elseif IsReady(_R) then
        return self:GetRDmg(target)
      elseif IsReady(_Q) and IsReady(_R) then
        return self:GetQDmg(target) + self:GetRDmg(target)+self:GetQ2Dmg(target)
      else
        return 0
      end
    end
    function Akali:GetDraws(target)
      local Qdmg  = self:GetQDmg(target)
      local Qdmg2 =self:GetQ2Dmg(target)
      local Edmg = self:GetEDmg(target)
      local Rdmg = self:GetRDmg(target)
      local Idmg=(50+ ((GetLevel(myHero))*20))

      if Qdmg > GetCurrentHP(target) then
        return 'Q', GoS.White
      elseif Qdmg+Idmg>GetCurrentHP(target) then
        return 'Q + Ignite', GoS.White
      elseif Edmg>GetCurrentHP(target) then
        return 'E', GoS.White
      elseif Edmg+Idmg>GetCurrentHP(target) then
        return 'E + Ignite', GoS.White
      elseif Rdmg>GetCurrentHP(target) then
        return 'R', GoS.White
      elseif Rdmg+Idmg>GetCurrentHP(target) then
        return 'R + Ignite', GoS.White
      elseif Qdmg+Edmg>GetCurrentHP(target) then
        return 'Q + E',GoS.White
      elseif Qdmg+Rdmg>GetCurrentHP(target) then
        return 'Q + R',GoS.White
      elseif Qdmg+Edmg+Idmg>GetCurrentHP(target) then
        return 'Q + E + Ignite',GoS.White
      elseif Qdmg+Rdmg+Idmg>GetCurrentHP(target) then
        return 'Q + R + Ignite',GoS.White
      elseif Qdmg+Edmg+Rdmg+Idmg>GetCurrentHP(target) then
        return 'Q + R + E + Ignite',GoS.White
      elseif Qdmg+Rdmg+Edmg >GetCurrentHP(target) then
        return 'Q + R + E',GoS.White
      elseif Qdmg+Qdmg2 > GetCurrentHP(target) then
        return 'Q + Q2', GoS.White
      elseif Qdmg+Idmg+Qdmg2>GetCurrentHP(target) then
        return 'Q + Q2 + Ignite', GoS.White
      elseif Edmg>GetCurrentHP(target) then
        return 'E', GoS.White
      elseif Edmg+Idmg>GetCurrentHP(target) then
        return 'E + Ignite', GoS.White
      elseif Rdmg>GetCurrentHP(target) then
        return 'R', GoS.White
      elseif Rdmg+Idmg>GetCurrentHP(target) then
        return 'R + Ignite', GoS.White
      elseif Qdmg+Edmg+Qdmg2>GetCurrentHP(target) then
        return 'Q + Q2 + E',GoS.White
      elseif Qdmg+Rdmg+Qdmg2>GetCurrentHP(target) then
        return 'Q + Q2 + R',GoS.White
      elseif Qdmg+Edmg+Idmg+Qdmg2>GetCurrentHP(target) then
        return 'Q + Q2 + E + Ignite',GoS.White
      elseif Qdmg+Rdmg+Idmg+Qdmg2>GetCurrentHP(target) then
        return 'Q + Q2 + R + Ignite',GoS.White
      elseif Qdmg+Edmg+Rdmg+Idmg+Qdmg2>GetCurrentHP(target) then
        return 'Full Combo + Ignite',GoS.White
      elseif Qdmg+Rdmg+Edmg+Qdmg2 >GetCurrentHP(target) then
        return 'Kill with full combo',GoS.White
      else
        return "Cant Kill yet", GoS.White
      end
    end
    function Akali:killsteal()
      for _, unit in pairs(GetEnemyHeroes()) do
        local health = unit.health
        local dmgE = self:GetEDmg(unit)
        if(GetDistance(target) <= self.E.range and  IsReady(_E) and health<dmgE and menu.killsteal.useE:Value()   and menu.killsteal.ks:Value())then
          self:CastE(unit)
        end
        local dmgQ = self:GetQDmg(unit)
        if(GetDistance(target) <= self.Q.range and  IsReady(_Q) and health<dmgQ and menu.killsteal.useQ:Value() and menu.killsteal.ks:Value() )then
          self:CastQ(unit)
        end
        local dmgI =(50+ ((GetLevel(myHero))*20))
        if(health<dmgI and menu.killsteal.useI:Value() and menu.killsteal.ks:Value() and GetDistance(unit)<600)then
          self:CastI(unit)
        end
        local dmgR =self:GetRDmg(unit)
        if(GetDistance(target) <= self.R.range and  IsReady(_R) and health<dmgR and menu.killsteal.useR:Value() and menu.killsteal.ks:Value() and GetDistance(unit)<550)then
          self:CastR(unit)
        end
      end
    end
    function Akali:Autostealth()
      if menu.skilllogic.Wlogic.useW:Value() and menu.skilllogic.Wlogic.useWen:Value() then
        if menu.skilllogic.Wlogic.useWe:Value() == 1 then
          if EnemiesAround(myHeroPos() , 900) >= 2 then
            self:CastW(myHeroPos())
          end
        elseif menu.skilllogic.Wlogic.useWe:Value() == 2 then
          if EnemiesAround(myHeroPos() , 900) >= 3 then
            self:CastW(myHeroPos())
          end
        elseif menu.skilllogic.Wlogic.useWe:Value() == 3 then
          if EnemiesAround(myHeroPos() , 900) >= 4 then
            self:CastW(myHeroPos())
          end
        elseif menu.skilllogic.Wlogic.useWe:Value() == 4 then
          if EnemiesAround(myHeroPos() , 900) >= 5 then
            self:CastW(myHeroPos())
          end
        end
      end
      if menu.skilllogic.Wlogic.useWhp:Value() and menu.skilllogic.Wlogic.useW:Value() then
        if myHero.health <= (myHero.maxHealth * menu.skilllogic.Wlogic.hp:Value() / 100) then
          self:CastW(unit)
        end
      end
    end
    function Akali:onload()
      findorb()
    end
    function Akali:LoadMenu()
      menu=MenuConfig( "menu",""..Scriptname.." [" .. myHero.charName.."]")


      menu:Menu("combo",loc_eng[1])
      menu.combo:Boolean("useQ", loc_eng[2], true)
      menu.combo:Boolean("useE", loc_eng[4], true)
      menu.combo:Boolean("useR", loc_eng[5], true)
      menu.combo:Boolean("useI", loc_eng[6], true)
      menu.combo:Slider("Mana","Energy Manager", 10, 10, 100, 1)



      menu:Menu( "harass",loc_eng[9])
      menu.harass:Boolean("useQ", loc_eng[10], true)
      menu.harass:Boolean("useE", loc_eng[12], true)
      menu.harass:Slider("Mana","Energy Manager", 30, 10, 100, 1)

      menu:Menu("skilllogic",loc_eng[99])
      menu.skilllogic:Menu( "Wlogic",loc_eng[101])
      menu.skilllogic.Wlogic:Boolean("useW", loc_eng[138],true)
      menu.skilllogic.Wlogic:Boolean("useWhp", loc_eng[137], false)
      menu.skilllogic.Wlogic:Slider("hp",loc_eng[104], 30, 10, 100, 1)
      menu.skilllogic.Wlogic:Boolean("useWen", loc_eng[136], false)
      menu.skilllogic.Wlogic:DropDown("useWe", loc_eng[136], 1, {loc_eng[130], loc_eng[131] , loc_eng[132],loc_eng[133] })
      menu.skilllogic:Menu( "Rlogic",loc_eng[103])
      menu.skilllogic.Rlogic:DropDown("logic", loc_eng[103], 1, {loc_eng[134], loc_eng[135]})

      menu:Menu( "farm",loc_eng[14])

      menu.farm:Menu("laneclear",loc_eng[15])
      menu.farm.laneclear:Boolean("useQ",loc_eng[16],true)
      menu.farm.laneclear:Boolean("useE",loc_eng[18],true)
      menu.farm.laneclear:Slider("ecount",loc_eng[182], 2, 1, 10, 1)
      menu.farm.laneclear:Info("blank", "")
      menu.farm.laneclear:Info("blank", "")
      menu.farm.laneclear:Info("info2", "           [Energy Manager]")
      menu.farm.laneclear:Slider("QMana","Q skill Energy Manager", 30, 10, 100, 1)
      menu.farm.laneclear:Slider("EMana","E skill Energy Manager", 30, 10, 100, 1)

      menu.farm:Menu("jungleclear",loc_eng[20])
      menu.farm.jungleclear:Boolean("useQ",loc_eng[21],true)
      menu.farm.jungleclear:Boolean("useE",loc_eng[23],true)
      menu.farm.jungleclear:Boolean("useR",loc_eng[24],false)
      menu.farm.jungleclear:Info("blank", "")
      menu.farm.jungleclear:Info("blank", "")
      menu.farm.jungleclear:Info("info2", "           [Energy Manager]")
      menu.farm.jungleclear:Slider("QMana","Q skill Energy Manager", 30, 10, 100, 1)
      menu.farm.jungleclear:Slider("EMana","E skill Energy Manager", 30, 10, 100, 1)
      menu.farm.jungleclear:Slider("RMana","R skill Energy Manager", 30, 10, 100, 1)

      menu.farm:Menu("lasthit",loc_eng[25])
      menu.farm.lasthit:Boolean("autolasthit",loc_eng[189],false)
      menu.farm.lasthit:Boolean("useQ",loc_eng[26],true)
      menu.farm.lasthit:Boolean("useE",loc_eng[28],true)
      menu.farm.lasthit:DropDown("lasthitlogic",loc_eng[191], 1, {loc_eng[172],loc_eng[174]})
      menu.farm.lasthit:Info("blank", "")
      menu.farm.lasthit:Info("info2", "           [Energy Manager]")
      menu.farm.lasthit:Slider("QMana","Q skill Energy Manager", 30, 10, 100, 1)
      menu.farm.lasthit:Slider("EMana","E skill Energy Manager", 30, 10, 100, 1)


      menu:Menu( "killsteal",loc_eng[35])
      menu.killsteal:Boolean("ks",loc_eng[36],true)
      menu.killsteal:Boolean("useQ", loc_eng[37], true)
      menu.killsteal:Boolean("useW", loc_eng[38], true)
      menu.killsteal:Boolean("useE", loc_eng[39], true)
      menu.killsteal:Boolean("useR", loc_eng[40], true)
      menu.killsteal:Boolean("useI", loc_eng[41], true)

      menu:Menu("escape",loc_eng[30])
      menu.escape:Boolean("useW",loc_eng[32],true)
      menu.escape:Boolean("useR",loc_eng[34],false)

Activator:Loadmenu("hybrid")

      menu:Menu( "misc",loc_eng[92])
      menu.misc:Menu( "gapClose",loc_eng[219])
      menu.misc.gapClose:Boolean("w", loc_eng[220], true)
      menu.misc.gapClose:Info("info3", loc_eng[98] )
      menu.misc:Menu( "skinhack","[" .. myHero.charName.. "] - Skinhack Settings")
      menu.misc.skinhack:Boolean("useskin",loc_eng[54], false)
      menu.misc.skinhack:DropDown('selected' .. myHero.charName .. 'Skin', loc_eng[57]  ,  1, skinMeta[myHero.charName])
      menu.misc:Menu( "autolevel","[" .. myHero.charName.. "] - AutoLevel Settings")
      menu.misc.autolevel:Boolean("uselevel",loc_eng[51], false)
      menu.misc.autolevel:DropDown("logic", loc_eng[52] , 7, {loc_eng[58], loc_eng[59],loc_eng[60],loc_eng[61],loc_eng[62], loc_eng[63], loc_eng[64]  })
      menu.misc:Menu( "antiafk","[" .. myHero.charName.. "] - AntiAFK Settings")
      menu.misc.antiafk:Boolean("useafk",loc_eng[196], false)


      Clock = os.clock()

      menu:Menu("other",loc_eng[65])
      menu.other:Menu("draw",loc_eng[66])
      menu.other.draw:Boolean("qdraw",loc_eng[67],true)
      menu.other.draw:Boolean("wdraw",loc_eng[68],true)
      menu.other.draw:Boolean("edraw",loc_eng[69],true)
      menu.other.draw:Boolean("rdraw",loc_eng[70],true)
      menu.other.draw:Boolean("aadraw",loc_eng[71],false)
      menu.other:Menu( "color",loc_eng[198])
      menu.other.color:ColorPick("Qcolor", loc_eng[199],{255, 255, 255, 255})
      menu.other.color:ColorPick("Wcolor", loc_eng[200],{255, 255, 255, 255})
      menu.other.color:ColorPick("Ecolor", loc_eng[201],{255, 255, 255, 255})
      menu.other.color:ColorPick("Rcolor", loc_eng[202],{255, 255, 255, 255})
      menu.other.color:ColorPick("E2color", loc_eng[203],{255, 255, 255, 255})
      menu.other.color:ColorPick("AAcolor", loc_eng[204],{255, 255,0,0})
      menu.other:Menu( "width",loc_eng[206])
      menu.other.width:Slider("Qwidth", loc_eng[210], 1, 1, 10, 1)
      menu.other.width:Slider("Wwidth", loc_eng[211], 1, 1, 10, 1)
      menu.other.width:Slider("Ewidth", loc_eng[212], 1, 1, 10, 1)
      menu.other.width:Slider("Rwidth", loc_eng[213], 1, 1, 10, 1)
      menu.other.width:Slider("AAwidth", loc_eng[209], 1, 1, 10, 1)
      menu.other:Boolean("target",loc_eng[75],true)
      menu.other:Boolean("damage",loc_eng[214],true)
      menu.other:Boolean("targetcal",loc_eng[76],true)

      menu:Menu("targetsel",loc_eng[77])
      menu.targetsel:Boolean("ts",loc_eng[78], false)

      menu:Menu("orb","Orbwalker Settings")
      menu.orb:Menu( "selectorb","Current Orbwalker :")

      menu:Menu("pred","Prediction Settings")
      menu.pred:Info("blank", " No skillshot available "   )

      menu:Menu( "Keys",loc_eng[79])
      menu.Keys:Info("infoK3", loc_eng[80])
      menu.Keys:Key("combokey", loc_eng[81], string.byte(" "))
      menu.Keys:Info("infoK4", loc_eng[82])
      menu.Keys:Key("harasskey", loc_eng[83], string.byte("C"))
      menu.Keys:Key("autoq", loc_eng[91],string.byte("T"))
      menu.Keys:Info("infoK5", loc_eng[84])
      menu.Keys:Key("laneclearkey", loc_eng[85], string.byte("V"))
      menu.Keys:Key("jungleclearkey", loc_eng[86], string.byte("V"))
      menu.Keys:Key("lasthitkey",loc_eng[215], string.byte("X"))      menu.Keys:Info("infoK6", loc_eng[87])
      menu.Keys:Key("escapekey", loc_eng[88], string.byte("Y"))
      menu.Keys:Info("infoK", "")
      menu.Keys:Info("infoK2", loc_eng[89])

      menu:Info("infoK","           "..Scriptname.."" )
      menu:Info("infoK","         Script Version:  "..Version.. "  " )
      menu:Info("infoK","   Script was made by  "..Author.. "" )
      menu:Info("infoK","Leauge Of Legends Version: "..LVersion.. "" )
      menu:Boolean("instruct", loc_eng[216], false)

    end

    function Akali:WndMsg(Msg, Key)
      if menu.targetsel.ts:Value() then
        if Msg == WM_LBUTTONDOWN then
          local minD = 10
          local starget = nil
          for i, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy) then
              if GetDistance(enemy, mousePos) <= minD or starget == nil then
                minD = GetDistance(enemy, mousePos)
                starget = enemy
              end
            end
          end
          if starget and minD < 150 then
            if self.selectedTar and starget.charName == self.selectedTar.charName then
              self.selectedTar = nil
              print("<font color=\"#FFFFFF\">Target <b>is no loger selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
            else
              self.selectedTar = starget
              print("<font color=\"#FFFFFF\">New target <b>selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
            end
          end
        end
      end
      if Msg == WM_LBUTTONDOWN then
        if PopUp1 then
          PopUp1 = false
        end
      end
    end
   

class "Yasuo"
local hase = false
local estack = {}
local rangeQ = false
local espin = false
local knockedup = 0
local startTime = 0
local egap = false
function Yasuo:__init()
        if not libloaded then return end
self.Q = { delay = 0.25, speed = math.huge ,width = 40, range = 475  } --aoe false, Col false, lınear
self.Q3 = { delay = 0.25, speed = 1200 ,width = 120, range = 900 } --aoe false, Col false, lınear
self.W = { range = 400  }
self.E = { range = 475 }
self.R = { range = 1200  }
Last_LevelSpell = 0
self.tsg = TargetSelector(1300,TARGET_LESS_CAST_PRIORITY,DAMAGE_PHYSICAL,true,false)
  q3Spell = IPrediction.Prediction({range = 900, speed =  math.huge, delay = 0.25, width = 120, type = "linear", name =myHero:GetSpellData(_Q).name, collision = false})
  qSpell = IPrediction.Prediction({range = 475, speed = math.huge, delay = 0.25, width = 40, type = "linear", name =myHero:GetSpellData(_Q).name, collision = false})
Callback.Add("Tick", function() self:Tick() end)
Callback.Add("Load", function() self:onload() end)
Callback.Add("WndMsg", function(Msg, Key) self:WndMsg(Msg, Key) end)
Callback.Add("Draw", function() self:Draw() end)
Callback.Add("UpdateBuff", function(unit,buff) self:UpdateBuff(unit,buff) end)
Callback.Add("RemoveBuff", function(unit,buff) self:RemoveBuff(unit,buff) end)
Callback.Add("ProcessSpell", function(unit, spell) self:ProcessSpell(unit, spell) end)
Callback.Add("CreateObj", function(obj) self:CreateObj(obj) end)
Callback.Add("DeleteObj", function(obj) self:DeleteObj(obj) end)
--Callback.Add("SpellCast", function(castProc) self:SpellCast(castProc) end)
self:LoadMenu()
end
function Yasuo:onload()
findorb()
end
function Yasuo:LoadMenu()
menu=MenuConfig("menu",""..Scriptname.." [" .. myHero.charName.."]" )
menu:Menu("combo",loc_eng[1])
menu.combo:Boolean("useQ", loc_eng[2], true)
menu.combo:Boolean("useQ3", "Use Q3 in combo", true)
menu.combo:Boolean("useE", loc_eng[4], true)
menu.combo:Boolean("useR", loc_eng[5], true)
menu.combo:Slider("minr","Minimum Enemy for using R"   , 1, 1, 5, 1)
menu.combo:Boolean("useI", loc_eng[6], true)

menu:Menu( "harass",loc_eng[9])
menu.harass:Boolean("useQ", loc_eng[10], true)
menu.harass:Boolean("useQ3", " Harass With Q3", true)
menu.harass:Boolean("useQ3a", " Auto Harass With Q3", false)

menu:Menu( "farm",loc_eng[14])

menu.farm:Menu("laneclear",loc_eng[15])
menu.farm.laneclear:Boolean("useQ",loc_eng[16], true)
menu.farm.laneclear:Boolean("useQ3","Use Q3 on Laneclear", true)
menu.farm.laneclear:Slider("q3count","Minimum minion to Q3 >" , 2, 1, 10, 1)
menu.farm.laneclear:Boolean("useE",loc_eng[18], true)
menu.farm.laneclear:DropDown("elogic","E logic for Laneclear",   2, {"Always Use","Only for lasthit"})


menu.farm:Menu("jungleclear",loc_eng[20])
menu.farm.jungleclear:Boolean("useQ",loc_eng[21], true)
menu.farm.jungleclear:Boolean("useQ3","Use Q3 on JungleClear", true)
menu.farm.jungleclear:Boolean("useE",loc_eng[23], true)


menu.farm:Menu("lasthit",loc_eng[25])
menu.farm.lasthit:Boolean("autolasthit",loc_eng[189], false)
menu.farm.lasthit:Boolean("useQ",loc_eng[26], true)
menu.farm.lasthit:Boolean("useE",loc_eng[28], true)
menu.farm.lasthit:DropDown("lasthitlogic",loc_eng[191],   1, {loc_eng[172],loc_eng[174]})

menu:Menu("escape",loc_eng[30])
menu.escape:Boolean("useE",loc_eng[33], true)


menu:Menu("killsteal",loc_eng[35])
menu.killsteal:Boolean("ks",loc_eng[36], true)
menu.killsteal:Boolean("useQ", loc_eng[37], true)
menu.killsteal:Boolean("useQ3", "Steal With Q3", true)
menu.killsteal:Boolean("useE", loc_eng[39], true)
menu.killsteal:Boolean("useI", loc_eng[41], true)

Activator:Loadmenu("ad")

menu:Menu( "misc",loc_eng[92])
menu.misc:Menu( "autowall","[" .. myHero.charName.. "] - Auto Wall Settings")
menu.misc.autowall:Boolean("useW", "Use Auto Wall", true)
menu.misc.autowall:Info("blank", "> Skillshots"   )
DelayAction(function()  for i = 1, heroManager.iCount,1 do
  local hero = heroManager:getHero(i)
  if hero.team ~= myHero.team then
    if Champions[hero.charName] ~= nil then
      for index, skillshot in pairs(Champions[hero.charName].skillshots) do
        if skillshot.blockable == true then
          menu.misc.autowall:Boolean(skillshot.spellName, hero.charName .. " - " .. skillshot.name, true)
        end
      end
    end
  end
end
end, 0.2)

menu.misc:Menu( "autoulti","[" .. myHero.charName.. "] - Auto Ulti Settings")
menu.misc.autoulti:Boolean("useR", "Use Auto R", true)
menu.misc.autoulti:Slider("minr", "Minimum enemy to auto R" , 3, 1, 5, 1)
menu.misc.autoulti:Info("blank", ""   )
menu.misc.autoulti:Info("blank", "> Advanced Settings"   )
menu.misc.autoulti:Boolean("checkhp", "Check our health", true)
menu.misc.autoulti:Slider("checkhpslider", "Only use R if our health >% " , 40, 0, 100, 1)

menu.misc:Menu( "turretdive","[" .. myHero.charName.. "] - Turret Dive Settings")
menu.misc.turretdive:Boolean("use", "Use Turret Dive Settings", true)
menu.misc.turretdive:DropDown("turretdivelogic","Turret Dive Mode",   1, {"Normal Mode","Krystra Mode"})
menu.misc.turretdive:Boolean("Drawturret", "Draw Turret Range", false)
menu.misc.turretdive:Info("blank", ""   )
menu.misc.turretdive:Info("blank", "Normal Mode Settings >"   )
menu.misc.turretdive:Slider("normalmode", "Minimum Number of Ally Minions" , 3, 1, 8, 1)
menu.misc.turretdive:Slider("health", "Do not dive if my health > % ", 30, 0, 100, 1)
menu.misc.turretdive:Info("blank", ""   )
menu.misc.turretdive:Info("blank", "Krystra Mode Settings >"   )
menu.misc.turretdive:Slider("krystramode", "Minimum Number of Ally Minions" , 3, 1, 8, 1)
menu.misc.turretdive:Slider("krystramode2", "Minimum Number of Ally Champions" , 2, 1, 4, 1)
menu.misc.turretdive:Slider("health1", "Do not dive if my health > % ", 30, 0, 100, 1)

menu.misc:Menu( "Gapclose","[" .. myHero.charName.. "] - Gap Close Settings")
menu.misc.Gapclose:Boolean("UseEGap", "Use E to GapClose", true)
menu.misc.Gapclose:Slider("DistanceToE", "Min Distance for GapClose", 300, 300, 2000, 1)

menu.misc:Menu( "walljump","[" .. myHero.charName.. "] - Wall Jump Settings")
menu.misc.walljump:Boolean("Draw", "Draw Wall Jump Locations", true)
menu.misc.walljump:Boolean("Drawr", "Use Range While Drawing", false)
menu.misc.walljump:Slider("Drawrrange", "Draw Locations If Range >" , 10, 1000, 10000, 1)
menu.misc.walljump:Info("blank", ""   )
menu.misc.walljump:Info("blank", "        [Color Settings]"   )
menu.misc.walljump:ColorPick("fcolor", "Location Color",   {255, 255, 255, 255})
--menu.misc.walljump:ColorPick("f2color", "Location 2 Color",   {255, 255, 255, 255})
--menu.misc.walljump:DropDown("walljumplogic","Priority to gain vision",   1, {"Ward","Wall"})

menu.misc:Menu( "interrupt",loc_eng[93])
menu.misc.interrupt:Boolean("r", "Interrupt with Q3 Skill", true)
menu.misc.interrupt:Info("info3", loc_eng[98])
DelayAction(function()
  local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
  for i, spell in pairs(CHANELLING_SPELLS) do
    for _,k in pairs(GetEnemyHeroes()) do
        if spell["Name"] == GetObjectName(k) then
        menu.misc.interrupt:Boolean(GetObjectName(k).."Inter", "On "..GetObjectName(k).." "..(type(spell.Spellslot) == 'number' and str[spell.Spellslot]), true)
        end
    end
  end
end, 0.35)
menu.misc:Menu( "autoq","[" .. myHero.charName.. "] - Auto Q Settings")
menu.misc.autoq:Boolean("useQ", "Use Auto Q to minion ( Stack )", false)
menu.misc.autoq:DropDown("autoqlogic","Auto Q Logic",   1, {"Always use","Only if enemy away"})

menu.misc:Menu( "skinhack","[" .. myHero.charName.. "] - Skinhack Settings")
menu.misc.skinhack:Boolean("useskin",loc_eng[54], false)
menu.misc.skinhack:DropDown('selected' .. myHero.charName .. 'Skin', loc_eng[57]  ,  1, skinMeta[myHero.charName])
menu.misc:Menu( "autolevel","[" .. myHero.charName.. "] - AutoLevel Settings")
menu.misc.autolevel:Boolean("uselevel",loc_eng[51], false)
menu.misc.autolevel:DropDown("logic", loc_eng[52] , 7, {loc_eng[58], loc_eng[59],loc_eng[60],loc_eng[61],loc_eng[62], loc_eng[63], loc_eng[64]  })
menu.misc:Menu( "antiafk","[" .. myHero.charName.. "] - AntiAFK Settings")
menu.misc.antiafk:Boolean("useafk",loc_eng[196], false)

Clock = os.clock()


menu:Menu("other",loc_eng[65])
menu.other:Menu( "draw",loc_eng[66])
menu.other.draw:Boolean("qdraw",loc_eng[67], true)
menu.other.draw:Boolean("wdraw",loc_eng[68], true)
menu.other.draw:Boolean("q3draw","Q3 Skill Drawings", true)
menu.other.draw:Boolean("edraw",loc_eng[69], true)
menu.other.draw:Boolean("rdraw",loc_eng[70], true)
menu.other.draw:Boolean("aadraw",loc_eng[71], false)
--menu.other.draw:Boolean("rtdraw",loc_eng[197], false)
menu.other:Menu( "color", loc_eng[198])
menu.other.color:ColorPick("Qcolor", loc_eng[199],   {255, 255, 255, 255})
menu.other.color:ColorPick("Wcolor", loc_eng[200],   {255, 255, 255, 255})
menu.other.color:ColorPick("Q3color", "Q3 Color",   {255, 255, 255, 255})
menu.other.color:ColorPick("Ecolor", loc_eng[201],   {255, 255, 255, 255})
menu.other.color:ColorPick("Rcolor", loc_eng[202],   {255, 255, 255, 255})
menu.other.color:ColorPick("AAcolor", loc_eng[204],   {255, 255,0,0})
-- menu.other.color:ColorPick("targetselect", loc_eng[205],   {255, 255,0,0})
-- menu.other:Boolean("target",loc_eng[75], true)
menu.other:Boolean("q3draw","Draw Remaining Q3 time", true)
menu.other:Boolean("damage",loc_eng[214], true)
menu.other:Boolean("targetcal",loc_eng[76], true)

menu:Menu("targetsel",loc_eng[77])
menu.targetsel:Boolean("ts",loc_eng[78], true)


menu:Menu("hum","Humanizer Settings")
menu.hum:Info("blank", " > R Skillshot Humanizer"   )
menu.hum:Boolean("userc","Humanizer for combo", false)
menu.hum:DropDown("dtcombo","Delay Type :",   1, {"Use Constant Delay","Use Random Delay"})
menu.hum:Slider("delayrc", "Delay for Combo Mode" , 200, 1, 650, 1)
menu.hum:Boolean("usera","Humanizer for Auto Ulti", false)
menu.hum:DropDown("dtauto","Delay Type :",   1, {"Use Constant Delay","Use Random Delay"})
menu.hum:Slider("delayra", "Delay for Auto Ulti" , 200, 1, 650, 1)
menu.hum:Info("blank", ""   )
menu.hum:Info("blank", "> Windwall Humanizer"   )
menu.hum:Boolean("useR", "Use Humanizer", false)
menu.hum:DropDown("dtwall","Delay Type :",   1, {"Use Constant Delay","Use Random Delay"})
menu.hum:Slider("delay", "Set delay for auto wall" , 200, 1, 500, 1)


menu:Menu("orb","Orbwalker Settings")
menu.orb:Menu( "selectorb","Current Orbwalker :")

menu:Menu("pred","Prediction Settings")
menu.pred:DropDown("selectpred","Current Predictions :",   1, {"Open Prediction","IPrediction","Gos Prediction"})
menu.pred:Menu( "hcgeneral","Hitchance Settings")
menu.pred.hcgeneral:Menu( "hcop","Open Prediction Hitchance")
menu.pred.hcgeneral.hcop:Slider("hcopq", "Q Hitchance " , 30, 0, 100, 1)
menu.pred.hcgeneral.hcop:Slider("hcopq3", "Q3 Hitchance " , 30, 0, 100, 1)
menu.pred:Info("blank", "    Currently Open Prediction "   )
menu.pred:Info("blank", "      is best with this bundle"   )


menu:Menu( "Keys",loc_eng[79])
menu.Keys:Info("infoK3", loc_eng[80]   )
menu.Keys:Key("combokey", loc_eng[81], string.byte(" "))
menu.Keys:Key("onlye", loc_eng[128], string.byte("O"))
menu.Keys:Key("combomode", loc_eng[129],  string.byte("2"))
menu.Keys:Info("infoK4", loc_eng[82]   )
menu.Keys:Key("harasskey", loc_eng[83],    string.byte("C"))
-- menu.Keys:Boolean("harasstoglekey", "Harass Togle Key",, string.byte("T"))
menu.Keys:Info("infoK5", loc_eng[84]   )
menu.Keys:Key("lasthitkey",loc_eng[215],    string.byte("X"))
menu.Keys:Key("laneclearkey", loc_eng[85],    string.byte("V"))
menu.Keys:Key("jungleclearkey", loc_eng[86],    string.byte("V"))
--menu.Keys:Boolean("lasthitkey", "Lasthit Key",    string.byte("X"))
menu.Keys:Info("infoK6", loc_eng[87]   )
menu.Keys:Key("escapekey", loc_eng[88],    string.byte("Y"))
menu.Keys:Key("wallkey", "Wall Jump Key",    string.byte("T"))
menu.Keys:Info("infoK", "Make Sure That Your Orbwalker"   )
menu.Keys:Info("infoK2", loc_eng[89]   )

--menu:Boolean("lang", loc_eng[165]    1, {loc_eng[166], loc_eng[167],loc_eng[168]})
menu:Boolean("instruct", loc_eng[216], false)
menu:Info("infoK","              [ Script Info ]" )
menu:Info("infoK",""..Scriptname.."" )
menu:Info("infoK","Script Version:  "..Version.. "  " )
menu:Info("infoK","Script was made by  "..Author.. "" )
menu:Info("infoK","Leauge Of Legends Version: "..LVersion.. "" )

end
function Yasuo:UpdateBuff(unit,buff)
if unit and unit.isMe and buff and buff.Name == "YasuoDashScalar" then
  estack[GetNetworkID(unit)] = buff.Count
end
if unit and unit.team == myHero.team and unit.type == myHero.type then
  if buff.Name == "YasuoQ3W" then
    rangeQ = true
    startTime = os.clock() + 10
  end
end
end
function Yasuo:RemoveBuff(unit,buff)
if unit and unit.isMe and buff and buff.Name == "YasuoDashScalar" then
  estack[GetNetworkID(unit)] = 0
end
if unit and unit.team == myHero.team and unit.type == myHero.type then
  if buff.Name == "YasuoQ3W" then
    rangeQ = false
  end
end

function Yasuo:Hasebuff(target)
  for i = 1, target.buffCount do
    local buff = target:getBuff(i)
    if BuffIsValid(buff) then
      if buff.name:lower():find("YasuoDashWrapper") then
        hase = true
      end
    end
  end
end
end
function Yasuo:getstacks(unit)
return (estack[GetNetworkID(unit)] or 0)
end
function Yasuo:Draw()
if menu.misc.walljump.Draw:Value()then
  if menu.misc.walljump.Drawr:Value() then
    for k, v in pairs(yasuospot) do
      if GetDistance(v, myHero) < menu.misc.walljump.Drawrrange:Value() then
        DrawCircle(v.x, v.y, v.z, 100,1,0,menu.misc.walljump.fcolor:Value())
      end
    end
    for k, v in pairs(yasuospotend) do
      if GetDistance(v, myHero) < menu.misc.walljump.Drawrrange:Value() then
        -- DrawCircle(v.x, v.y, v.z, 100,1,0, menu.misc.walljump.f2color:Value())
      end
    end
  elseif not menu.misc.walljump.Drawr:Value() then
    for k, v in pairs(yasuospot) do
      DrawCircle(v.x, v.y, v.z, 100,1,0,menu.misc.walljump.fcolor:Value())
    end
    for k, v in pairs(yasuospotend) do
      -- DrawCircle(v.x, v.y, v.z, 100,1,0, menu.misc.walljump.f2color:Value())
    end
  end
end
if menu.misc.turretdive.Drawturret:Value() then
  for _, i in pairs(GetTurrets()) do
    if i and i.team ~= myHero.team then
      if mPos3D(myHero.x, myHero.z, i.x, i.z, 950) then
        DrawCircle(i.x, i.y, i.z, i.range ,1,0, 0xFFFF0000)
      else
        DrawCircle(i.x, i.y, i.z, i.range ,1,0, GoS.White)
      end
    end
  end
end
if not q3ready then
  if menu.other.draw.qdraw:Value() and IsReady(_Q) then
    DrawCircle(myHero.x, myHero.y, myHero.z, 475,1,0,menu.other.color.Qcolor:Value())
  end
elseif  q3ready then
  if menu.other.draw.q3draw:Value() and IsReady(_Q) then
    DrawCircle(myHero.x, myHero.y, myHero.z, 900,1,0,menu.other.color.Q3color:Value())
  end
end


if menu.other.draw.wdraw:Value() and IsReady(_W) then
  DrawCircle(myHero.x, myHero.y, myHero.z, 400,1,0,menu.other.color.Wcolor:Value())
end

if menu.other.draw.edraw:Value() and IsReady(_E) then
  DrawCircle(myHero.x, myHero.y, myHero.z, 475,1,0,menu.other.color.Ecolor:Value())
end

if menu.other.draw.rdraw:Value() and IsReady(_R) then
  DrawCircle(myHero.x, myHero.y, myHero.z, 1200,1,0,menu.other.color.Rcolor:Value())
end
if menu.other.draw.aadraw:Value() then
  DrawCircle(myHero.x, myHero.y, myHero.z, 175,1,0, menu.other.color.AAcolor:Value())
end

for _, target in pairs(GetEnemyHeroes()) do
  if ValidTarget(target, 15000) then
    if target.visible and not target.dead and menu.other.damage:Value() then
      currLine = 1
      -- DrawLineHPBar2(self:GetMyDmg(target),"",  target, currLine)
      DrawLineHPBar(self:GetMyDmg(target), "Damage " .. math.round(self:GetMyDmg(target)),target,currLine)
      currLine = currLine + 1
      DrawDmgOverHpBar(target,GetCurrentHP(target),0,self:GetMyDmg(target),0xff00ff00)
    end
  end
end
if menu.other.targetcal:Value() and not myHero.dead then
  if target and target ~= nil then
    --  local target= GetOrigin(target)
    local drawpos=WorldToScreen(1,target.x, target.y, target.z)
    local comboText,color = self:GetDraws(target)
    if comboText then
      DrawText(comboText,15,drawpos.x-20,drawpos.y-20,color)
    end
  end
end
if  GetCastName(myHero,_Q)  == "YasuoQ3W"  then
  if  menu.other.q3draw:Value() and not myHero.dead then
    local drawpos=WorldToScreen(1,myHero.x, myHero.y, myHero.z)
    DrawText("Storm Duration :"..math.round(startTime - os.clock(), 2).."s",15,drawpos.x,drawpos.y,GoS.White)
  end
end
Global:Commondraw()
end
---//==================================================\\---
--|| > Yasuo Tick                         ||--
---\\==================================================//---
function Yasuo:Checks()
Gtarget = self.tsg:GetTarget()
if not ValidTarget(Gtarget, 925) or not menu.targetsel.ts:Value()  then
  target = GetCurrentTarget()
elseif  ValidTarget(Gtarget, 925) and not self.selectedTar then
  target = GetCurrentTarget()
elseif (ValidTarget(Gtarget, 925) and self.selectedTar) then
  target = self.selectedTar
end
q3ready = GetCastName(myHero,_Q)  == "YasuoQ3W"
mousePos = GetMousePos()
Activator:Loaditems("ad")
end
function Yasuo:Tick()
self:Checks()
Antiafk()
if( menu.Keys.lasthitkey:Value() or menu.farm.lasthit.autolasthit:Value() )then
  self:LastHit()
end
if(menu.Keys.jungleclearkey:Value() )then
  self:JungleClear()
end
if(menu.Keys.laneclearkey:Value() )then
  self:LaneClear()
end
autolevel()
skinhack()
autopot()
Activator:Useitems("ad")
if menu.Keys.escapekey:Value() then
  self:escape()
end
if menu.Keys.wallkey:Value() then
  self:walljump()
end
if menu.harass.useQ3a:Value() then
  self:autoharass()
end
if divelogic(target) == true then
  if menu.Keys.combokey:Value() then
    self:Combo()
  end
  self:autoR()
end
if menu.Keys.harasskey:Value() then
  self:harass()
end
if menu.killsteal.ks:Value() then
  self:killsteal()
end
if menu.instruct:Value() then
  menu.instruct:Value(false)
  PopUp1 = true
end
if menu.misc.autoq.useQ:Value() then
  self:autoQ()
end
end
function Yasuo:autoQ()
if  GetCastName(myHero,_Q)  == "YasuoQ3W"  then return end
for i, minion in pairs(minionManager.objects) do
  if  GetTeam(minion) == MINION_ENEMY then
    if ValidTarget(minion) and minion ~= nil then
      if IsReady(_Q) then
        if menu.misc.autoq.autoqlogic:Value() == 1 then
          if  menu.farm.laneclear.useQ:Value()  and GetDistance(minion) <= 475 then
            self:CastQ(minion)
          end
        elseif menu.misc.autoq.autoqlogic:Value() == 2 then
          if not IsInDistance(target,900) then
            if  menu.farm.laneclear.useQ:Value()  and GetDistance(minion) <= 475 then
              self:CastQ(minion)
            end
          end
        end
      end
    end
  end
end
end
function Yasuo:autoR()
--if divelogic(target) == false then return end
if menu.misc.autoulti.useR:Value() then
  if(GetDistance(target) <= self.R.range  and IsReady(_R))then
    if menu.misc.autoulti.checkhp:Value() then
      if (myHero.health / myHero.maxHealth >= menu.misc.autoulti.checkhpslider:Value() /100 ) then
        if knockedup >=  menu.misc.autoulti.minr:Value() then
          if menu.hum.usera:Value() then
            if menu.hum.dtauto:Value() == 1 then
              DelayAction(function ()  self:CastR() end, menu.hum.delayra:Value()/1000)
            elseif menu.hum.dtauto:Value() == 2 then
              DelayAction(function ()  self:CastR() end,  math.random(0.200,0.650))
            end
          end
          if not menu.hum.usera:Value() then
            self:CastR()

          end
        end
      end
    end
  end
end
if menu.misc.autoulti.useR:Value() then
  if(GetDistance(target) <= self.R.range  and IsReady(_R))then
    if knockedup >=  menu.misc.autoulti.minr:Value() then
      if menu.hum.usera:Value() then
        if menu.hum.dtauto:Value() == 1 then
          DelayAction(function ()  self:CastR() end, menu.hum.delayra:Value()/1000)
        elseif menu.hum.dtauto:Value() == 2 then
          DelayAction(function ()  self:CastR() end,  math.random(0.200,0.650))
        end
      end
      if not menu.hum.usera:Value() then
        self:CastR()

      end
    end
  end
end
end
function Yasuo:autoharass()
if(GetDistance(target) <= self.Q3.range and menu.harass.useQ3:Value() and IsReady(_Q) ) then
  self:CastQ3(target)
end
end
function Yasuo:harass()
if  GetCastName(myHero,_Q)  == "YasuoQ3W"  then
  if(GetDistance(target) <= self.Q3.range and menu.harass.useQ3:Value()  and IsReady(_Q))then
    self:CastQ3(target)
  end
else
  if(GetDistance(target) <= self.Q.range and menu.harass.useQ:Value()  and IsReady(_Q))then
    self:CastQ(target)
  end
end
end

function Yasuo:Combo()
if  GetCastName(myHero,_Q)  == "YasuoQ3W"  then
  if(GetDistance(target) <= self.Q3.range and menu.combo.useQ3:Value()  and  not egap  and IsReady(_Q))then
    self:CastQ3(target)
  end
else
  if(GetDistance(target) <= self.Q.range and menu.combo.useQ:Value()  and IsReady(_Q))then
    self:CastQ(target)
  end
end
if(GetDistance(target) <= self.E.range  and menu.combo.useE:Value()   and IsReady(_E))then
  self:CastE(target)
end
if menu.combo.useR:Value() then
  if(GetDistance(target) <= self.R.range  and IsReady(_R))then
    if knockedup >= menu.combo.minr:Value() then
      if menu.hum.userc:Value() then
        if menu.hum.dtcombo:Value() == 1 then
          DelayAction(function ()  self:CastR() end, menu.hum.delayrc:Value()/1000)
        elseif  menu.hum.dtcombo:Value() == 2 then
          DelayAction(function ()  self:CastR() end,  math.random(0.200,0.650))
        end
      end
      if not menu.hum.userc:Value() then
        self:CastR()
      end
    end
  end
end
self:egap(target)
if(menu.combo.useI:Value() and menu.Keys.combokey:Value()  )then
  for _, unit in pairs(GetEnemyHeroes()) do
    local dmgI =(50+ ((myHero.level)*20))
    local health=unit.health
    if(health<dmgI and menu.combo.useI:Value() and GetDistance(unit)<600)then
      self:CastI(unit)
    end
  end
end
end
function Yasuo:egap(unit)
local TargetDistance = GetDistance(unit)
if menu.misc.Gapclose.UseEGap:Value() then
  if TargetDistance >= menu.misc.Gapclose.DistanceToE:Value() then
    -- mPos = ClosestMinion(unit,MINION_ENEMY)
    mPos= self:getNearestMinion(unit)
    if IsReady(_E) and mPos then
      CastTargetSpell(mPos, _E)
          egap = true
          DelayAction(function ()   egap = false end, 1)
    end
  end
end
end
function Yasuo:killsteal()
-- if divelogic(target) == false then return end
for _, unit in pairs(GetEnemyHeroes()) do
  local health = unit.health
  local dmgE = self:GetEDmg(unit)
  if(GetDistance(target) <= self.E.range and  IsReady(_E) and health<dmgE and menu.killsteal.useE:Value()   and menu.killsteal.ks:Value())then
    self:CastE(unit)
  end
  local dmgQ = self:GetQDmg(unit)
  if(GetDistance(target) <= self.Q.range and  IsReady(_Q) and health<dmgQ and menu.killsteal.useQ:Value() and menu.killsteal.ks:Value() )then
    self:CastQ(unit)
  end
  local dmgQ3 =self:GetQDmg(unit)
  if  GetCastName(myHero,_Q)  == "YasuoQ3W"  then
    if(GetDistance(target) <= self.Q3.range and  IsReady(_R) and health<dmgQ3 and menu.killsteal.useQ3:Value() and menu.killsteal.ks:Value())then
      self:CastQ3(unit)
    end
  end
  local dmgI =(50+ ((GetLevel(myHero))*20))
  if(health<dmgI and menu.killsteal.useI:Value() and menu.killsteal.ks:Value() and GetDistance(unit)<600)then
    self:CastI(unit)
  end
end
end
function Yasuo:escape()
if menu.Keys.escapekey:Value()  then
  mPos = self:getNearestMinion(mousePos)
  if menu.escape.useE:Value()  then
    if  IsReady(_E) and mPos then
      CastTargetSpell(mPos, _E)
    else
      MoveToXYZ(mousePos)
    end
  end
end
end
function Yasuo:walljump()
for k, loc in pairs(yasuospot) do
  if GetDistance(loc, myHero) < 250 and GetDistance(loc, myHero) > 50  then
    MoveToXYZ(loc.x, loc.y, loc.z)
  end
  if GetDistance(loc, myHero) < 50 and IsReady(_W)  then
    CastSkillShot(_W, yasuospotend[k].x,yasuospotend[k].y, yasuospotend[k].z)
  end
end
for i, minion in pairs(minionManager.objects) do
  if ValidTarget(minion) and minion ~= nil and GetTeam(minion) == MINION_JUNGLE then
    if IsReady(_E) and not IsReady(_W)  then
      self:CastE(minion)
    end
  end
end
end
function Yasuo:CastQ(unit)
if menu.pred.selectpred:Value() == 1 then
  local QPred = GetPrediction(unit, self.Q)
  if IsReady(_Q) then
    if QPred  and QPred.hitChance >= (menu.pred.hcgeneral.hcop.hcopq:Value()/100) then
      CastSkillShot(_Q, QPred.castPos)
    end
  end
elseif menu.pred.selectpred:Value() == 2 then
    local HitChance, y = qSpell:Predict(unit)
    if IsReady(_Q) and HitChance >= 3 then
      CastSkillShot(_Q, y.x, y.y, y.z)
    end
elseif menu.pred.selectpred:Value() == 3 then
  local qPred = GetPredictionForPlayer(myHeroPos(), unit, GetMoveSpeed(unit), math.huge, 250, 475, 40, false, true)
  if IsReady(_Q) and qPred.HitChance == 1 then
    CastSkillShot(_Q, qPred.PredPos.x, qPred.PredPos.y, qPred.PredPos.z)
  end
end
end
function Yasuo:CastQ3(unit)
if GetCastName(myHero,_Q)  == "YasuoQ3W"  then
  if menu.pred.selectpred:Value() == 1 then
    local QPred = GetPrediction(unit, self.Q3)
    if IsReady(_Q) then
      if QPred  and QPred.hitChance >= (menu.pred.hcgeneral.hcop.hcopq3:Value()/100) then
        CastSkillShot(_Q, QPred.castPos)
      end
    end
  elseif menu.pred.selectpred:Value() == 2 then
      local HitChance, y = q3Spell:Predict(unit)
      if IsReady(_Q) and HitChance >= 3 then
        CastSkillShot(_Q, y.x, y.y, y.z)
      end
  elseif menu.pred.selectpred:Value() == 3 then
    local qPred = GetPredictionForPlayer(myHeroPos(), unit, GetMoveSpeed(unit), math.huge, 250, 900, 120, false, true)
    if IsReady(_Q) and qPred.HitChance == 1 then
      CastSkillShot(_Q, qPred.PredPos.x, qPred.PredPos.y, qPred.PredPos.z)
    end
  end
end
end
function Yasuo:CastE(unit)
if IsReady(_E) then
  CastTargetSpell(unit, _E)
end
end
function Yasuo:CastR(unit)
if IsReady(_R) then
  CastSpell(_R)
end
end
function Yasuo:CastI(unit)
local Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
if Ignite then
  if IsReady(Ignite) then
    CastTargetSpell(unit, Ignite)
  end
end
end
function Yasuo:CreateObj(obj)
if not obj then return end
if obj and (obj.name=="Yasuo_base_R_indicator_beam.troy" or obj.name=="Yasuo_Skin02_R_indicator_beam.troy") then
  knockedup = knockedup + 1
end
end

function Yasuo:DeleteObj(obj)
if not obj then return end
if obj and (obj.name=="Yasuo_base_R_indicator_beam.troy" or obj.name=="Yasuo_Skin02_R_indicator_beam.troy") then
  knockedup = knockedup - 1
end
end

function Yasuo:LaneClear()
for i, minion in pairs(minionManager.objects) do
  if  GetTeam(minion) == MINION_ENEMY then
    if ValidTarget(minion) and minion ~= nil then
      if IsReady(_Q) then
        if  menu.farm.laneclear.useQ:Value()  and GetDistance(minion) <= 475 then
          self:CastQ(minion)
        end
      end
      if not UnderTurret(self:eEndPos(minion), true) then
        if menu.farm.laneclear.elogic:Value() == 1 then
          if  menu.farm.laneclear.useE:Value() and IsReady(_E) and GetDistance(minion) <= 475 then
            self:CastE(minion)
          end
        elseif menu.farm.laneclear.elogic:Value() == 2 then
          local edmg = self:GetEDmg(minion)
          if  menu.farm.laneclear.useE:Value() and IsReady(_E) and GetDistance(minion) <= 475 and edmg >= minion.health then
            self:CastE(minion)
          end
        end
      end
    end
  end
end
if GetCastName(myHero,_Q)  == "YasuoQ3W"  then
  local NumberOfHits = menu.farm.laneclear.q3count:Value()
  if IsReady(_Q) then
    if  menu.farm.laneclear.useQ3:Value()   then
      local BestPos, BestHit =  GetLineFarmPosition(self.Q3.range, self.Q3.width, MINION_ENEMY)
      if BestPos   and  BestHit >= NumberOfHits then
        CastSkillShot(_Q, BestPos)
      end
    end
  end
end

end


function Yasuo:LastHit()
for _, target in pairs(minionManager.objects) do
  if GetTeam(target) == MINION_ENEMY then
    if IsObjectAlive(target) then
      if menu.farm.lasthit.lasthitlogic:Value() == 1 then
        local Qdamage = self:GetQDmg(target)
        if(IsReady(_Q) and menu.farm.lasthit.useQ:Value() and ValidTarget(target,475)   and Qdamage >= GetCurrentHP(target)) then
          self:CastQ(target)
        end
        local Edamage = self:GetEDmg(target)
        if(IsReady(_E)and menu.farm.lasthit.useE:Value() and  ValidTarget(target,475) and Edamage >= GetCurrentHP(target)) then
          self:CastE(target)
        end
      end
    end
  end
end
end
function Yasuo:JungleClear()
for i, minion in pairs(minionManager.objects) do
  if  GetTeam(minion) == MINION_JUNGLE then
    if ValidTarget(minion) and minion ~= nil then
      if IsReady(_Q) then
        if  menu.farm.jungleclear.useQ:Value()  and GetDistance(minion) <= 475 then
          self:CastQ(minion)
        end
      end
      if IsReady(_E) then
        if  menu.farm.jungleclear.useE:Value()  and GetDistance(minion) <= 475 then
          self:CastE(minion)
        end
      end
    end
  end
end
if GetCastName(myHero,_Q)  == "YasuoQ3W"  then
  if IsReady(_Q) then
    if  menu.farm.jungleclear.useQ3:Value()   then
      local BestPos, BestHit =  GetLineFarmPosition(self.Q3.range, self.Q3.width, MINION_JUNGLE)
      if BestPos   and  BestHit >= 1 then
        CastSkillShot(_Q, BestPos)
      end
    end
  end
end
end



function Yasuo:GetQDmg(target)
if GetCastLevel(myHero, _Q)< 1 then
  return 0
end
if IsReady(_Q) then
  local FinalDamage = ((GetCastLevel(myHero, _Q)* 20) + (myHero.totalDamage) )
  return CalcDamage(myHero,target, FinalDamage,0)
else
  return 0
end
end
function Yasuo:GetEDmg(target)
local elvl = GetCastLevel(myHero, _E)
if GetCastLevel(myHero, _E) < 1 then
  return 0
end
if IsReady(_E) then
  if self:getstacks(myHero) == 0 then
    basedamage = {70, 90, 110, 130, 150}
  elseif self:getstacks(myHero) == 1 then
    basedamage = {87.5, 112.5, 137.5, 142.5, 187.5}
  elseif self:getstacks(myHero) == 2 then
    basedamage = {105, 135, 165, 195, 225}
  end
  local FinalDamage =((basedamage[elvl] + (GetBonusAP(myHero))* .6))
  return CalcDamage(myHero,target,0, FinalDamage)
else
  return 0
end
end
function Yasuo:GetRDmg(target)
if GetCastLevel(myHero, _R) < 1 then
  return 0
end
if IsReady(_R) then
  local FinalDamage = (100+ (GetCastLevel(myHero, _R)) + (myHero.totalDamage)*1.5 )
  return CalcDamage(myHero,target, FinalDamage,0)
else
  return 0
end
end
function Yasuo:GetMyDmg(target)
if IsReady(_Q) and IsReady(_R) and IsReady(_E) then
  return self:GetQDmg(target) + self:GetRDmg(target) + self:GetEDmg(target)
elseif IsReady(_Q)  and IsReady(_E) then
  return self:GetQDmg(target) + self:GetEDmg(target)
elseif IsReady(_R) and IsReady(_E) then
  return self:GetRDmg(target) +self:GetEDmg(target)
elseif IsReady(_Q) then
  return self:GetQDmg(target)
elseif IsReady(_E) then
  return self:GetEDmg(target)
elseif IsReady(_R) then
  return self:GetRDmg(target)
elseif IsReady(_Q) and IsReady(_R) then
  return self:GetQDmg(target) + self:GetRDmg(target)
else
  return 0
end
end
function Yasuo:GetDraws(target)
local qdamage = self:GetQDmg(target)
local edamage = self:GetEDmg(target)
local rdamage = self:GetRDmg(target)
local Idmg=(50+ ((myHero.level)*20))

if qdamage >target.health then
  return 'Q', GoS.White
elseif qdamage+ Idmg>target.health then
  return 'Q + Ignite', GoS.White
elseif edamage >target.health then
  return 'E', GoS.White
elseif edamage + Idmg>target.health then
  return 'E + Ignite', GoS.White
elseif rdamage  >target.health then
  return 'R', GoS.White
elseif rdamage + Idmg>target.health then
  return 'R + Ignite', GoS.White
elseif rdamage +edamage  >target.health then
  return 'R + E',GoS.White
elseif rdamage +edamage+ Idmg>target.health then
  return 'R + E + Ignite',GoS.White
elseif qdamage+edamage>target.health then
  return 'Q + E',GoS.White
elseif qdamage+rdamage >target.health then
  return 'Q + R',GoS.White
elseif qdamage+edamage+ Idmg>target.health then
  return 'Q + E + Ignite',GoS.White
elseif qdamage+rdamage+ Idmg>target.health then
  return 'Q + R + Ignite',GoS.White
elseif qdamage+edamage+rdamage >target.health then
  return 'Kill with full combo',GoS.White
elseif qdamage+edamage+rdamage+ Idmg>target.health then
  return 'Full Combo + Ignite',GoS.White
else
  return "Cant Kill yet", GoS.White
end
end
function Yasuo:ProcessSpell(unit, spell)
       if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and q3ready then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 1000) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and  menu.misc.interrupt[GetObjectName(unit).."Inter"]:Value() and menu.misc.interrupt.r:Value() then 
         self:CastQ3(unit)
        end
      end
    end
if  menu.misc.autowall.useW:Value() then

  if unit and unit ~= nil and spell then
    if unit.team ~= myHero.team and string.find(spell.name, "Basic") == nil then
      if Champions[unit.charName] ~= nil then
        skillshot = Champions[unit.charName].skillshots[spell.name]
        if  skillshot ~= nil and skillshot.blockable == true then
          range = skillshot.range
          if not spell.startPos then
            spell.startPos.x = unit.x
            spell.startPos.z = unit.z
          end
          if GetDistance(spell.startPos) <= range then
            if GetDistance(spell.endPos) <= 475 then
              if IsReady(_W) and menu.misc.autowall[spell.name]:Value() then
                if menu.hum.useR:Value() then
                  DelayAction(function ()
                  CastSkillShot(_W, unit.x,unit.y, unit.z)
                  end, menu.hum.delay:Value()/1000)
                elseif not menu.hum.useR:Value() then
                  CastSkillShot(_W, unit.x,unit.y, unit.z)
                end
              end
            end
          end
        end
      end
    end
  end
end
end
function Yasuo:getNearestMinion(unit)

local closestMinion = nil
local nearestDistance = 0

for index, minion in pairs(minionManager.objects) do
  if IsObjectAlive(minion) and GetTeam(minion) == MINION_ENEMY then
    if minion ~= nil and minion.valid and string.find(minion.name,"Minion_") == 1 and minion.team ~= myHero.team and minion.dead == false then
      if GetDistance(minion) <= self.E.range then
        if GetDistance(self:eEndPos(minion), unit) < GetDistance(unit) and nearestDistance < GetDistance(minion) then
          nearestDistance = GetDistance(minion)
          closestMinion = minion
        end
      end
    end
  end
end
for index, minion in pairs(minionManager.objects) do
  if IsObjectAlive(minion) and GetTeam(minion) == MINION_JUNGLE then
    if minion ~= nil and minion.valid and minion.dead == false then
      if GetDistance(minion) <= self.E.range then
        if GetDistance(self:eEndPos(minion), unit) < GetDistance(unit) and nearestDistance < GetDistance(minion) then
          nearestDistance = GetDistance(minion)
          closestMinion = minion
        end
      end
    end
  end
end
for i = 1, heroManager.iCount, 1 do
  local minion = heroManager:getHero(i)
  if ValidTarget(minion, self.E.range) then
    if GetDistance(minion) <= self.E.range then
      if GetDistance(self:eEndPos(minion), unit) < GetDistance(unit) and nearestDistance < GetDistance(minion) then
        nearestDistance = GetDistance(minion)
        closestMinion = minion
      end
    end
  end
end
return closestMinion
end
function Yasuo:eEndPos(unit)

if unit ~= nil then
  if GetDistance(myHero,unit) < 410 then
    dashPointT = myHero + (Vector(unit) - myHero):normalized() * 485
  else
    dashPointT = myHero + (Vector(unit) - myHero):normalized() * (GetDistance(myHero,unit) + 65)
  end
  return dashPointT
end
end
function Yasuo:WndMsg(Msg, Key)
if menu.targetsel.ts:Value() then
if Msg == WM_LBUTTONDOWN then
  local minD = 10
  local starget = nil
  for i, enemy in ipairs(GetEnemyHeroes()) do
    if ValidTarget(enemy) then
      if GetDistance(enemy, mousePos) <= minD or starget == nil then
        minD = GetDistance(enemy, mousePos)
        starget = enemy
      end
    end
  end
  if starget and minD < 150 then
    if self.selectedTar and starget.charName == self.selectedTar.charName then
      self.selectedTar = nil
      print("<font color=\"#FFFFFF\">Target <b>is no loger selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
    else
      self.selectedTar = starget
      print("<font color=\"#FFFFFF\">New target <b>selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
    end
  end
end
end
if Msg == WM_LBUTTONDOWN then
if PopUp1 then
  PopUp1 = false
end
end
end
local ultused = false
local eStacks = false
local pickcard= false
class "TwistedFate"
function TwistedFate:__init()
        if not libloaded then return end
  self.Q = { delay = 0.25, speed = 1000 ,radius = 40, range = 1450  }
    self.W = { delay = 0.25, speed = 1000 , range = 525  }
self.R = { range = 5500  }
Last_LevelSpell = 0
 Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
self.tsg = TargetSelector(1600,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
self.tshp = TargetSelector(1600,TARGET_LOW_HP_PRIORITY,DAMAGE_MAGIC,true,false)
self.ts1 = TargetSelector(525,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
qSpell = IPrediction.Prediction({range = 1450, speed = 1000, delay = 0.25, width = 40, type = "linear", name =myHero:GetSpellData(_Q).name, collision = false})
global_ticks = 0
            self.blue ="BlueCardLock"
            self.yellow = "GoldCardLock"
          self.red = "RedCardLock"
Callback.Add("Tick", function() self:Tick() end)
Callback.Add("Load", function() self:onload() end)
Callback.Add("WndMsg", function(Msg, Key) self:WndMsg(Msg, Key) end)
Callback.Add("Draw", function() self:Draw() end)
  Callback.Add("UpdateBuff", function(unit,buff) self:UpdateBuff(unit,buff) end)
  Callback.Add("RemoveBuff", function(unit,buff) self:RemoveBuff(unit,buff) end)
Callback.Add("ProcessSpell", function(unit, spell) self:ProcessSpell(unit, spell) end)
Callback.Add("CreateObj", function(obj) self:CreateObj(obj) end)
Callback.Add("DeleteObj", function(obj) self:DeleteObj(obj) end)
self:LoadMenu()
end
 function TwistedFate:Checks()
                  Gtarget = self.tsg:GetTarget()
                   Hptarget = self.tshp:GetTarget()
                      Etarget = self.ts1:GetTarget()
  if not ValidTarget(Gtarget, 925) or not menu.targetsel.ts:Value()  then
    target = GetCurrentTarget()
  elseif  ValidTarget(Gtarget, 925) and not self.selectedTar then
    target = GetCurrentTarget()
  elseif (ValidTarget(Gtarget, 925) and self.selectedTar) then
    target = self.selectedTar
  end
                  mousePos = GetMousePos()
                   Activator:Loaditems("ap")
                end
function TwistedFate:Tick()
  self:Checks()
  Antiafk()
  autolevel()
   self:ulti()
  skinhack()
  autopot()
  self:autoq()
Activator:Useitems("ap")
  self:escape()
  if menu.Keys.bluecard:Value() then
        self:CastW(self.blue)
      end
        if menu.Keys.redcard:Value() then
        self:CastW(self.red)
      end
        if menu.Keys.yellowcard:Value() then
        self:CastW(self.yellow)
      end
  if( menu.Keys.lasthitkey:Value() or menu.farm.lasthit.autolasthit:Value() )then
    self:LastHit()
  end
  if(menu.Keys.combokey:Value() )then
    self:Combo()
  end
  if(menu.Keys.harasskey:Value()   ) then
    self:harass()
  end
    if(menu.killsteal.ks:Value() ) then
    self:killsteal()
  end
    if(menu.Keys.laneclearkey:Value() )then
    self:LaneClear()
  end
  if(menu.Keys.jungleclearkey:Value() )then
    self:JungleClear()
  end
 if menu.instruct:Value() then
          menu.instruct:Value(false)
          PopUp1 = true
        end
          self:blockaa()
  end
  function TwistedFate:CardUsed(spell)
 if myHero:GetSpellData(_W).name == spell then 
  return true 
else 
  return false
end
  end
  function TwistedFate:Combo()
    if not  (myHero.mana / myHero.maxMana >=  menu.combo.Mana:Value() /100 ) then return end

if menu.combo.card:Value() == 1 then
  combocard= "BlueCardLock"
  elseif menu.combo.card:Value() == 2 then
  combocard= "RedCardLock"
     elseif menu.combo.card:Value() == 3 then
  combocard= "GoldCardLock"
     end

   if( IsReady(_W) and  GetDistance(target) <= 850 and menu.combo.useW:Value()  )then
      if  menu.combo.useblue:Value() and (myHero.mana / myHero.maxMana <=  menu.combo.bluemana:Value() /100 )  then
                self:CastW(self.blue)
                 AttackUnit(Gtarget)  
            elseif not  menu.combo.useblue:Value() or (myHero.mana / myHero.maxMana  >=   menu.combo.bluemana:Value() /100 )  then
               self:CastW(combocard)
                 AttackUnit(Gtarget) 
             end
              end
if menu.combo.qmode:Value() == 1  then
  if ValidTarget(Gtarget,1600) and IsReady(_Q) and menu.combo.useQ:Value() then
    if IsImmobile(target) or (  CanUseSpell(myHero, _W) == ONCOOLDOWN and GetCastLevel(myHero, _W) >= 1) then
      self:CastQ(target)
    end
  end
  elseif menu.combo.qmode:Value() == 2 then
      if ValidTarget(Gtarget,1600) and IsReady(_Q) and menu.combo.useQ:Value() then
         if IsImmobile(target) then
             self:CastQ(target)
    end
  end
  elseif menu.combo.qmode:Value() == 3 then
    if IsReady(_Q) and menu.combo.useQ:Value() then
         self:CastQ(target)
       end
     end

  end
     function TwistedFate:ProcessSpell(unit, spell)
                 if unit.isMe and spell.name == "Gate" then 
                  ultused = true
                       DelayAction(function()   ultused = false end, 2)
                end

                      if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and IsReady(_W) then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 1000) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and  menu.misc.interrupt[GetObjectName(unit).."Inter"]:Value() and menu.misc.interrupt.r:Value() then 
                         self:CastW(self.yellow)
                              AttackUnit(unit) 
        end
      end
    end
               if unit.type == myHero.type and unit.team ~= myHero.team and isAGapcloserUnit[unit.charName] and GetDistance(unit) < 1000 and spell ~= nil then     
    if spell.name == (type(isAGapcloserUnit[unit.charName].spell) == 'number' and unit:GetSpellData(isAGapcloserUnit[unit.charName].spell).name or isAGapcloserUnit[unit.charName].spell) and menu.misc.gapClose1.gapClose1w[unit.charName] then
      if spell.target ~= nil and spell.target.name == myHero.name or isAGapcloserUnit[unit.charName].spell == 'blindmonkqtwo' then
           if self:CardUsed(self.yellow) == true then
                              AttackUnit(unit) 
      end
    end
  end
  end
                end
   function TwistedFate:LaneClear()
    if menu.farm.laneclear.card:Value() == 1 then
  lanecard= "BlueCardLock"
  elseif menu.farm.laneclear.card:Value() == 2 then
  lanecard= "RedCardLock"
     elseif menu.farm.laneclear.card:Value() == 3 then
  lanecard= "GoldCardLock"
     end
    if not ValidTarget(ClosestMinion(GetOrigin(myHero), MINION_ENEMY),  1000) then return end
 for i, minion in pairs(minionManager.objects) do
                      if ValidTarget(minion, 1000)  and GetTeam(minion) == MINION_ENEMY then
                         if IsReady(_W) then
if menu.farm.laneclear.useW:Value() and (myHero.mana / myHero.maxMana >= menu.farm.laneclear.WMana:Value() /100 ) then
          local Wpred = GetPrediction(minion, self.W)
  if MinionsAround(Wpred.castPos, 100, MINION_ENEMY) >=menu.farm.laneclear.reddis:Value() and menu.farm.laneclear.usered:Value() then
    if Wpred then
     self:CastW(self.red)
   end
else
   self:CastW(lanecard)
 end
end
end
end
end
                  if IsReady(_Q) then
                    if (myHero.mana / myHero.maxMana >= menu.farm.laneclear.QMana:Value() /100 ) then
                      local NumberOfHits = menu.farm.laneclear.qcount:Value()
                        if menu.Keys.laneclearkey:Value()  and menu.farm.laneclear.useQ:Value()  then
                          local BestPos, BestHit = GetLineFarmPosition(self.Q.range, 40, MINION_ENEMY)
                          if BestPos  and BestHit >= NumberOfHits then
                            CastSkillShot(_Q, BestPos)
                          end
                        end
                      end
                    end
                  end
function TwistedFate:LastHit()
        if not ValidTarget(ClosestMinion(GetOrigin(myHero), MINION_ENEMY),  1000) then return end
      if menu.farm.lasthit.card:Value() == 1 then
  lasthitcard= "BlueCardLock"
  elseif menu.farm.lasthit.card:Value() == 2 then
  lasthitcard= "RedCardLock"
     elseif menu.farm.lasthit.card:Value() == 3 then
  lasthitcard= "GoldCardLock"
     end
for _, target in pairs(minionManager.objects) do
  if GetTeam(target) == MINION_ENEMY then
    if IsObjectAlive(target) then
      if menu.farm.lasthit.lasthitlogic:Value() == 1 then
            local Qdamage = self:GetQDmg(target)
        if(IsReady(_Q) and menu.farm.lasthit.useQ:Value() and ValidTarget(target,self.Q.range)   and Qdamage >= GetCurrentHP(target)) then
          self:CastQ(target)
        end
        local Wdamage = self:GetWDmg(target)
        if(IsReady(_W) and menu.farm.lasthit.useW:Value() and  ValidTarget(target,525) and (target.health / target.maxHealth < 40 /100 )) then
                    self:CastW(lasthitcard)
         if Wdamage >= GetCurrentHP(target) then
             AttackUnit(target)  
           end
        end
      end
    end
  end
end
end
function TwistedFate:JungleClear()
      if not ValidTarget(ClosestMinion(GetOrigin(myHero), MINION_JUNGLE),  1000) then return end
      if menu.farm.jungleclear.card:Value() == 1 then
  jlanecard= "BlueCardLock"
  elseif menu.farm.jungleclear.card:Value() == 2 then
  jlanecard= "RedCardLock"
     elseif menu.farm.jungleclear.card:Value() == 3 then
  jlanecard= "GoldCardLock"
     end
for i, minion in pairs(minionManager.objects) do
                      if ValidTarget(minion, 1000)  and GetTeam(minion) ==  MINION_JUNGLE then
                         if IsReady(_W) then
if menu.farm.jungleclear.useW:Value() and (myHero.mana / myHero.maxMana >= menu.farm.jungleclear.WMana:Value() /100 ) then
          local Wpred = GetPrediction(minion, self.W)
  if MinionsAround(Wpred.castPos, 100, MINION_JUNGLE) >=menu.farm.jungleclear.reddis:Value() and menu.farm.jungleclear.usered:Value() then
    if Wpred then
     self:CastW(self.red)
   end
else
   self:CastW(lanecard)
 end
end
end
end
end
                  if IsReady(_Q) then
                    if (myHero.mana / myHero.maxMana >= menu.farm.jungleclear.QMana:Value() /100 ) then
                      local NumberOfHits = 1
                        if menu.Keys.jungleclearkey:Value()  and menu.farm.jungleclear.useQ:Value()  then
                          local BestPos, BestHit = GetLineFarmPosition(self.Q.range, 40,MINION_JUNGLE)
                          if BestPos  and BestHit >= NumberOfHits then
                            CastSkillShot(_Q, BestPos)
                          end
                        end
                      end
                    end
                  end
                          function TwistedFate:UpdateBuff(unit,buff)
                   if unit.isMe and buff.Name == "pickacard_tracker" then
                    pickcard= true
                  end
                  end
                  function TwistedFate:RemoveBuff(unit, buff)
                      if unit.isMe and buff.Name == "pickacard_tracker" then
                    pickcard= false
                  end
                  end
  function TwistedFate:CreateObj(obj)
if not obj then return end
  if obj and obj.name == "Cardmaster_stackready.troy" then
  eStacks = "Stacked"
  end
end

function TwistedFate:DeleteObj(obj)
if not obj then return end
  if obj and obj.name == "Cardmaster_stackready.troy" then
  eStacks = false
  end
end

    function TwistedFate:autoq()
      if not  menu.harass.useautoq:Value() then return end
               if ValidTarget(target,1450) and IsReady(_Q) and menu.harass.useQ:Value() and  (myHero.mana / myHero.maxMana >=  menu.harass.WMana:Value() /100 )  then
                      self:CastQ(target)
    end
    end
  function TwistedFate:harass()
    if menu.harass.card:Value() == 1 then
  harasscard= "BlueCardLock"
  elseif menu.harass.card:Value() == 2 then
  harasscard= "RedCardLock"
     elseif menu.harass.card:Value() == 3 then
  harasscard= "GoldCardLock"
     end
 if(IsReady(_W) and  GetDistance(target) <= 650 and menu.harass.useW:Value() and  (myHero.mana / myHero.maxMana >=  menu.harass.WMana:Value() /100 )  )then
                self:CastW(harasscard)
                  AttackUnit(Gtarget)  
              end

               if ValidTarget(target,1600) and IsReady(_Q) and menu.harass.useQ:Value() and  (myHero.mana / myHero.maxMana >=  menu.harass.QMana:Value() /100 )  then
                      self:CastQ(target)
    end
  end
    function TwistedFate:CastQ(unit)
              if menu.pred.selectpred:Value() == 1 then
                local QPred = GetLinearAOEPrediction(unit, self.Q)
                if IsReady(_Q) then
                  if QPred  and QPred.hitChance >= (menu.pred.hcgeneral.hcop.hcopq:Value()/100) then
                    CastSkillShot(_Q, QPred.castPos)
                  end
                end
              elseif menu.pred.selectpred:Value() == 2 then
                  local HitChance, y = qSpell:Predict(unit)
                  if IsReady(_Q) and HitChance >= 3 then
                    CastSkillShot(_Q, y.x, y.y, y.z)
                  end
              elseif menu.pred.selectpred:Value() == 3 then
                local qPred = GetPredictionForPlayer(myHeroPos(), unit, GetMoveSpeed(unit), 1000, 250, 1450, 40, false, true)
                if IsReady(_Q) and qPred.HitChance == 1 then
                  CastSkillShot(_Q, qPred.PredPos.x, qPred.PredPos.y, qPred.PredPos.z)
                end
              end
            end
              function TwistedFate:CastI(unit)
    if Ignite then
      if IsReady(Ignite) then
        CastTargetSpell(unit, Ignite)
      end
    end
  end
            function TwistedFate:CastW(spell)
               if IsReady(_W) then
                 if myHero:GetSpellData(_W).name == spell then
                CastSpell(_W)
              end
             if myHero:GetSpellData(_W).name == "PickACard"  then
                local Ticker = GetTickCount()
      if (global_ticks + 6000) < Ticker then
                   CastSpell(_W)
        global_ticks = Ticker
        DelayAction(function()   CastSpell(_W) end, 6)
      end
             end
            end
          end
           function TwistedFate:ulti()
            if menu.combo.UseR:Value() then
             if ultused then
     self:CastW(self.yellow)
    end
    if menu.combo.instaaa:Value() then
    if ultused and ValidTarget(Gtarget, 525) then
        AttackUnit(Gtarget)
      end
    end
           end
         end
          function TwistedFate:blockaa()
          if  menu.combo.blockaa:Value() then
            if pickcard then
              if DAC then
                DAC:AttacksEnabled(false)
                elseif IOW then
                  IOW.attacksEnabled= false
                end
              else
                   if DAC then
                DAC:AttacksEnabled(true)
                elseif IOW then
                  IOW.attacksEnabled = true
                end
end
end
end
                function TwistedFate:onload()
  findorb()
end
  function TwistedFate:Draw()
        if menu.other.draw.qdraw:Value() and IsReady(_Q) then
          DrawCircle(myHero.x, myHero.y, myHero.z, 1450,  menu.other.width.Qwidth:Value(),0,menu.other.color.Qcolor:Value())
        end
        if menu.other.draw.rdraw:Value() and IsReady(_R) then
          DrawCircle(myHero.x, myHero.y, myHero.z, 5500, menu.other.width.Rwidth:Value(),0, menu.other.color.Rcolor:Value())
        end
        if menu.other.draw.aadraw:Value() then
          DrawCircle(myHero.x, myHero.y, myHero.z, 525, menu.other.width.AAwidth:Value(),0, menu.other.color.AAcolor:Value())
        end
Global:Commondraw()
            for _, target in pairs(GetEnemyHeroes()) do
              if ValidTarget(target, 15000) then
                if target.visible and not target.dead and menu.other.damage:Value() then
                  currLine = 1
                  -- DrawLineHPBar2(self:GetMyDmg(target),"",  target, currLine)
                  DrawLineHPBar(self:GetMyDmg(target), "Damage " .. math.round(self:GetMyDmg(target)),target,currLine)
                  currLine = currLine + 1
                  DrawDmgOverHpBar(target,GetCurrentHP(target),0,self:GetMyDmg(target),0xff00ff00)
                end
              end
            end

            if menu.other.targetcal:Value() and not myHero.dead then
              if target and target ~= nil then
                --  local target= GetOrigin(target)
                local drawpos=WorldToScreen(1,target.x, target.y, target.z)
                local comboText,color = self:GetDraws(target)
                if comboText then
                  DrawText(comboText,15,drawpos.x-20,drawpos.y-20,color)
                end
              end
            end
          end
           function TwistedFate:GetQDmg(target)
              if GetCastLevel(myHero, _Q) < 1 then
                return 0
              end
              if IsReady(_Q) then
                local FinalDamage = (15 + (GetCastLevel(myHero, _Q) * 45) + (GetBonusAP(myHero))*.65)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function TwistedFate:GetWDmg(target)
              if GetCastLevel(myHero, _W) < 1 then
                return 0
              end
                if self:CardUsed(self.blue) and IsReady(_W)  then
                local FinalDamage = (20 + (GetCastLevel(myHero, _W) * 20) + (GetBonusAP(myHero))* .5)+ (myHero.totalDamage) 
                return CalcDamage(myHero,target,0, FinalDamage)
              elseif self:CardUsed(self.red)and IsReady(_W)  then
                local FinalDamage = (15 + (GetCastLevel(myHero, _W) * 15) + (GetBonusAP(myHero))* .5)+ (myHero.totalDamage) 
                return CalcDamage(myHero,target,0, FinalDamage)
                   elseif self:CardUsed(self.red)and IsReady(_W)  then
                local FinalDamage = (7.5 + (GetCastLevel(myHero, _W) * 7.5) + (GetBonusAP(myHero))* .5)+ (myHero.totalDamage) 
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
                  function TwistedFate:GetW2Dmg(target)
              if GetCastLevel(myHero, _W) < 1 then
                return 0
              end
                if  IsReady(_W)  then
       local FinalDamage = (15 + (GetCastLevel(myHero, _W) * 15) + (GetBonusAP(myHero))* .5)+ (myHero.totalDamage) 
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function TwistedFate:GetEDmg(target)
              if GetCastLevel(myHero, _E) < 1 or not eStacks then
                return 0
              end
              if IsReady(_E) then
                local FinalDamage = (25 + (GetCastLevel(myHero, _E) * 45) + (GetBonusAP(myHero))* .6)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function TwistedFate:GetMyDmg(target)
            if IsReady(_Q) and IsReady(_W) and IsReady(_E) then
        return self:GetQDmg(target) + self:GetWDmg(target) + self:GetEDmg(target)
      elseif IsReady(_Q)  and IsReady(_W) then
        return self:GetQDmg(target) + self:GetWDmg(target) 
      elseif IsReady(_Q)  and IsReady(_E) then
        return self:GetQDmg(target) + self:GetEDmg(target) 
      elseif IsReady(_W) and IsReady(_E) then
        return self:GetWDmg(target) +self:GetEDmg(target)
      elseif IsReady(_Q) then
        return self:GetQDmg(target)
      elseif IsReady(_E) then
        return self:GetEDmg(target)
      elseif IsReady(_W) then
        return self:GetWDmg(target)
      elseif IsReady(_Q) and IsReady(_W) then
        return self:GetQDmg(target) + self:GetWDmg(target)
      else
        return 0
      end
    end
            function TwistedFate:GetDraws(target)
          local qdamage = self:GetQDmg(target)
      local edamage = self:GetEDmg(target)
      local rdamage = self:GetWDmg(target)
      local Idmg=(50+ ((myHero.level)*20))

      if qdamage >target.health then
        return 'Q', GoS.White
      elseif qdamage+ Idmg>target.health then
        return 'Q + Ignite', GoS.White
      elseif edamage >target.health then
        return 'E', GoS.White
      elseif edamage + Idmg>target.health then
        return 'E + Ignite', GoS.White
      elseif rdamage  >target.health then
        return 'W', GoS.White
      elseif rdamage + Idmg>target.health then
        return 'W + Ignite', GoS.White
      elseif rdamage +edamage  >target.health then
        return 'W + E',GoS.White
      elseif rdamage +edamage+ Idmg>target.health then
        return 'W + E + Ignite',GoS.White
      elseif qdamage+edamage>target.health then
        return 'Q + E',GoS.White
      elseif qdamage+rdamage >target.health then
        return 'Q + W',GoS.White
      elseif qdamage+edamage+ Idmg>target.health then
        return 'Q + E + Ignite',GoS.White
      elseif qdamage+rdamage+ Idmg>target.health then
        return 'Q + W + Ignite',GoS.White
      elseif qdamage+edamage+rdamage >target.health then
        return 'Kill with full combo',GoS.White
      elseif qdamage+edamage+rdamage+ Idmg>target.health then
        return 'Full Combo + Ignite',GoS.White
      else
        return "Cant Kill yet", GoS.White
      end
    end
    function TwistedFate:escape()
  if menu.Keys.escapekey:Value()  then
  if menu.escape.useW:Value()  then
    if  IsReady(_W) and ValidTarget(Gtarget,525) then
      self:CastW(self.yellow)
      AttackUnit(Etarget)
end
end
      MoveToXYZ(mousePos)
end
end
     function TwistedFate:killsteal()
      if Hptarget ~= nil then
        local health = Hptarget.health
        local dmgW = self:GetWDmg(Hptarget)
        if(GetDistance(Hptarget)<525 and  IsReady(_W) and health<dmgW and menu.killsteal.useW:Value()  and menu.killsteal.ks:Value())then
          self:CastW(self.yellow)
        end
        local dmgQ = self:GetQDmg(Hptarget)
        if(GetDistance(Hptarget)<1450 and  IsReady(_Q) and health<dmgQ and menu.killsteal.useQ:Value() and menu.killsteal.ks:Value() )then
          self:CastQ(Hptarget)
        end
        local dmgI =(50+ ((myHero.level)*20))
        if(health<dmgI and menu.killsteal.useI:Value() and menu.killsteal.ks:Value() and GetDistance(Hptarget)<600)then
          self:CastI(Hptarget)
        end
      end
    end
function TwistedFate:LoadMenu()
     menu=MenuConfig("menu",""..Scriptname.." [" .. myHero.charName.."]" )

              menu:Menu( "combo",loc_eng[1])
              menu.combo:Boolean("useQ", loc_eng[2], true)
              menu.combo:DropDown("qmode","Q logic for combo ;",1, {"Smart","Stunned"," Always"})
              menu.combo:Boolean("useW", loc_eng[3], true)
             menu.combo:DropDown("card","Select Card Type ;",3, {"Blue Card","Red Card","Yellow Card"})
              menu.combo:Info("blank", " Extra Settings")
             -- menu.combo:Boolean("usered", "Red Card if hit x enemies", true)
              --menu.combo:Slider("reddis","Red Card x enemies", 3, 2, 5, 1)
              menu.combo:Boolean("UseR", "Gold card while ultimate", true)
              menu.combo:Boolean("instaaa", "Insta AA after ultimate", true)
              menu.combo:Boolean("blockaa", "Block AA in card selection", true)
              menu.combo:Boolean("useblue", "Use Blue Card if Mana <= % ", true)
              menu.combo:Slider("bluemana","Use Blue Card if Mana <= % ", 20, 10, 100, 1)
              menu.combo:Boolean("useI", loc_eng[6], true)
              menu.combo:Slider("Mana",loc_eng[8], 10, 10, 100, 1)


              menu:Menu( "harass",loc_eng[9])
              menu.harass:Boolean("useautoq", "Use Auto Q Harass", false)
              menu.harass:Boolean("useQ", loc_eng[10], true)
              menu.harass:Slider("QMana","Use Q if Mana Percent => % ", 30, 10, 100, 1)
              menu.harass:Boolean("useW", loc_eng[11], false)
              menu.harass:DropDown("card","Select Card Type ;",1, {"Blue Card","Red Card","Yellow Card"})
              menu.harass:Slider("WMana","Use W if Mana Percent => % ", 30, 10, 100, 1)
        


              menu:Menu( "farm",loc_eng[14])

              menu.farm:Menu("laneclear",loc_eng[15])
              menu.farm.laneclear:Boolean("useQ",loc_eng[16],true)
              menu.farm.laneclear:Slider("qcount",loc_eng[180], 2, 1, 10, 1)
              menu.farm.laneclear:Boolean("useW",loc_eng[17],true)
              menu.farm.laneclear:DropDown("card","Select Card Type ;",1, {"Blue Card","Red Card","Yellow Card"})
              menu.farm.laneclear:Info("blank","" )
               menu.farm.laneclear:Boolean("usered", "Red Card if hit x minions", true)
               menu.farm.laneclear:Slider("reddis","Red Card x minions", 3, 2, 5, 1)
              menu.farm.laneclear:Info("info2", loc_eng[184])
              menu.farm.laneclear:Slider("QMana",loc_eng[185], 30, 10, 100, 1)
              menu.farm.laneclear:Slider("WMana",loc_eng[186], 30, 10, 100, 1)

              menu.farm:Menu("jungleclear",loc_eng[20])
              menu.farm.jungleclear:Boolean("useQ",loc_eng[21],true)
              menu.farm.jungleclear:Boolean("useW",loc_eng[22],true)
              menu.farm.jungleclear:DropDown("card","Select Card Type ;",1, {"Blue Card","Red Card","Yellow Card"})
              menu.farm.jungleclear:Info("blank","" )
                   menu.farm.jungleclear:Boolean("usered", "Red Card if hit x minions", true)
               menu.farm.jungleclear:Slider("reddis","Red Card x minions", 3, 2, 5, 1)
              menu.farm.jungleclear:Info("info2", loc_eng[184])
              menu.farm.jungleclear:Slider("QMana",loc_eng[185], 30, 10, 100, 1)
              menu.farm.jungleclear:Slider("WMana",loc_eng[186], 30, 10, 100, 1)

              menu.farm:Menu("lasthit",loc_eng[25])
              menu.farm.lasthit:Boolean("autolasthit",loc_eng[189],false)
              menu.farm.lasthit:Boolean("useQ",loc_eng[26],false)
              menu.farm.lasthit:Boolean("useW",loc_eng[27],true)
             menu.farm.lasthit:DropDown("card","Select Card Type ;",1, {"Blue Card","Red Card","Yellow Card"})             
              menu.farm.lasthit:DropDown("lasthitlogic",loc_eng[191],1, {loc_eng[172],loc_eng[174]})
              menu.farm.lasthit:Info("blank", "")
              menu.farm.lasthit:Info("blank", "")
              menu.farm.lasthit:Info("info2", loc_eng[184])
              menu.farm.lasthit:Slider("QMana",loc_eng[185], 30, 10, 100, 1)
              menu.farm.lasthit:Slider("WMana",loc_eng[186], 30, 10, 100, 1)

              menu:Menu( "killsteal",loc_eng[35])
              menu.killsteal:Boolean("ks",loc_eng[36],true)
              menu.killsteal:Boolean("useQ", loc_eng[37], true)
              menu.killsteal:Boolean("useW", loc_eng[38], true)
              menu.killsteal:Boolean("useI", loc_eng[41], true)

                  menu:Menu("escape",loc_eng[30])
      menu.escape:Boolean("useW",loc_eng[32],true)

          Activator:Loadmenu("ap")


              menu:Menu("misc",loc_eng[92])
              menu.misc:Menu( "interrupt",loc_eng[93])
              menu.misc.interrupt:Boolean("r", loc_eng[95], true)
              menu.misc.interrupt:Info("info3", loc_eng[98])
          DelayAction(function()
  local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
  for i, spell in pairs(CHANELLING_SPELLS) do
    for _,k in pairs(GetEnemyHeroes()) do
        if spell["Name"] == GetObjectName(k) then
        menu.misc.interrupt:Boolean(GetObjectName(k).."Inter", "On "..GetObjectName(k).." "..(type(spell.Spellslot) == 'number' and str[spell.Spellslot]), true)
        end
    end
  end
end, 0.35)

              menu.misc:Menu( "gapClose1",loc_eng[219])
              menu.misc.gapClose1:Menu( "gapClose1w","Gap Close - W Settings")
              menu.misc.gapClose1.gapClose1w:Info("info3", loc_eng[98] )
          DelayAction(function()    for _, enemy in pairs(GetEnemyHeroes()) do
      if isAGapcloserUnit[enemy.charName] ~= nil then
        menu.misc.gapClose1.gapClose1w:Boolean(enemy.charName, enemy.charName .. " - " .. enemy:GetSpellData(isAGapcloserUnit[enemy.charName].spell).name,true)
      end
    end
        end, 0.3)

              menu.misc:Menu( "skinhack","[" .. myHero.charName.. "] - Skinhack Settings")
              menu.misc.skinhack:Boolean("useskin",loc_eng[54], false)
              menu.misc.skinhack:DropDown('selected' .. myHero.charName .. 'Skin', loc_eng[57]  ,  1, skinMeta[myHero.charName])
              menu.misc:Menu( "autolevel","[" .. myHero.charName.. "] - AutoLevel Settings")
              menu.misc.autolevel:Boolean("uselevel",loc_eng[51], false)
              menu.misc.autolevel:DropDown("logic", loc_eng[52] , 7, {loc_eng[58], loc_eng[59],loc_eng[60],loc_eng[61],loc_eng[62], loc_eng[63], loc_eng[64]  })
              menu.misc:Menu( "antiafk","[" .. myHero.charName.. "] - AntiAFK Settings")
              menu.misc.antiafk:Boolean("useafk",loc_eng[196], false)

              Clock = os.clock()
                menu:Menu("other",loc_eng[65])
              menu.other:Menu( "draw",loc_eng[66])
              menu.other.draw:Boolean("qdraw",loc_eng[67],true)
              menu.other.draw:Boolean("rdraw",loc_eng[70],true)
              menu.other.draw:Boolean("aadraw",loc_eng[71],false)
              menu.other:Menu( "color",loc_eng[198])
              menu.other.color:ColorPick("Qcolor", loc_eng[199],{255, 255, 255, 255})
              menu.other.color:ColorPick("Rcolor", loc_eng[202],{255, 255, 255, 255})
              menu.other.color:ColorPick("AAcolor", loc_eng[204],{255, 255,0,0})
              -- menu.other.color:ColorPick("targetselect", loc_eng[205],{255, 255,0,0})
              menu.other:Menu( "width",loc_eng[206])
              menu.other.width:Slider("Qwidth", loc_eng[210],  1, 1, 10, 1)
              menu.other.width:Slider("Rwidth", loc_eng[213],  1, 1, 10, 1)
              menu.other.width:Slider("AAwidth", loc_eng[209], 1, 1, 10, 1)
              -- menu.other.width:Slider("STwidth", loc_eng[208], 1, 1, 10, 1)
             -- menu.other:Boolean("target",loc_eng[75],true)
              --menu.other:Boolean("minimap","Draw R range ( Minimap )",true)
              menu.other:Boolean("damage",loc_eng[214],true)
              menu.other:Boolean("targetcal",loc_eng[76],true)
              --          menu.other:Menu( "perma",loc_eng[73])
              -- menu.other.perma:Boolean("perma",loc_eng[74],true)

              menu:Menu("targetsel",loc_eng[77])
              menu.targetsel:Boolean("ts",loc_eng[78],false)

              menu:Menu("orb","Orbwalker Settings")
              menu.orb:Menu( "selectorb","Current Orbwalker :")


              menu:Menu("pred","Prediction Settings")
              menu.pred:DropDown("selectpred","Current Predictions :",   1, {"Open Prediction","IPrediction","Gos Prediction"})
              menu.pred:Menu( "hcgeneral","Hitchance Settings")
              menu.pred.hcgeneral:Menu( "hcop","Open Prediction Hitchance")
              menu.pred.hcgeneral.hcop:Slider("hcopq", "Q Hitchance " , 30, 0, 100, 1)
              menu.pred:Info("blank", "    Currently Open Prediction "   )
              menu.pred:Info("blank", "      is best with this bundle"   )


              menu:Menu( "Keys",loc_eng[79])
              menu.Keys:Info("infoK3", loc_eng[80])
              menu.Keys:Key("combokey", loc_eng[81],string.byte(" "))
              menu.Keys:Info("infoK4", loc_eng[82])
              menu.Keys:Key("harasskey", loc_eng[83],string.byte("C"))
              menu.Keys:Info("infoK5", loc_eng[84])
              menu.Keys:Key("laneclearkey", loc_eng[85],string.byte("V"))
              menu.Keys:Key("jungleclearkey", loc_eng[86],string.byte("V"))
              menu.Keys:Key("lasthitkey",loc_eng[215],string.byte("X"))
              menu.Keys:Info("infoK6", loc_eng[87])
              menu.Keys:Key("escapekey", loc_eng[88],string.byte("Y"))
              --menu.Keys:Boolean("lasthitkey", "Lasthit Key",string.byte("X"))
              menu.Keys:Info("infoK","    [Card Key Settings]" )
              menu.Keys:Key("bluecard", "Select Blue Card",string.byte("7"))
              menu.Keys:Key("redcard", "Select Red Card",string.byte("8"))
              menu.Keys:Key("yellowcard", "Select Yellow Card",string.byte("9"))

              menu.Keys:Info("infoK2", loc_eng[89])

              menu:Info("infoK","           "..Scriptname.."" )
              menu:Info("infoK","         Script Version:  "..Version.. "  " )
              menu:Info("infoK","   Script was made by  "..Author.. "" )
              menu:Info("infoK","Leauge Of Legends Version: "..LVersion.. "" )
              menu:Boolean("instruct", loc_eng[216], false)



    end
     function TwistedFate:WndMsg(Msg, Key)
      if menu.targetsel.ts:Value() then
        if Msg == WM_LBUTTONDOWN then
          local minD = 10
          local starget = nil
          for i, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy) then
              if GetDistance(enemy, mousePos) <= minD or starget == nil then
                minD = GetDistance(enemy, mousePos)
                starget = enemy
              end
            end
          end
          if starget and minD < 150 then
            if self.selectedTar and starget.charName == self.selectedTar.charName then
              self.selectedTar = nil
              print("<font color=\"#FFFFFF\">Target <b>is no loger selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
            else
              self.selectedTar = starget
              print("<font color=\"#FFFFFF\">New target <b>selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
            end
          end
        end
      end
      if Msg == WM_LBUTTONDOWN then
        if PopUp1 then
          PopUp1 = false
        end
      end
    end
class "Orianna"
function Orianna:__init()
        if not libloaded then return end
  self.Q = { delay = 0.25, speed = 1200 ,radius = 175, range = 1700  }
self.W = { range = 1050, radius = 225 }
self.E = { range = 1100 }
self.R = { range = 315 ,radius = 325 }
Last_LevelSpell = 0
 Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
self.tsg = TargetSelector(1350,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
self.tshp = TargetSelector(1350,TARGET_LOW_HP_PRIORITY,DAMAGE_MAGIC,true,false)
qSpell = IPrediction.Prediction({range = 825, speed = 1200, delay = 0.25, width = 160, type = "linear", name =myHero:GetSpellData(_Q).name, collision = false})
Callback.Add("Tick", function() self:Tick() end)
Callback.Add("Load", function() self:onload() end)
Callback.Add("WndMsg", function(Msg, Key) self:WndMsg(Msg, Key) end)
Callback.Add("Draw", function() self:Draw() end)
  Callback.Add("UpdateBuff", function(unit,buff) self:UpdateBuff(unit,buff) end)
Callback.Add("ProcessSpell", function(unit, spell) self:ProcessSpell(unit, spell) end)
self:LoadMenu()
 self.Ball = myHero
end
  function Orianna:onload()
    findorb()
  end
function Orianna:Checks()
  Gtarget = self.tsg:GetTarget()
    Hptarget = self.tshp:GetTarget()
  if not ValidTarget(Gtarget, 925) or not menu.targetsel.ts:Value()  then
    target = GetCurrentTarget()
  elseif  ValidTarget(Gtarget, 925) and not self.selectedTar then
    target = GetCurrentTarget()
  elseif (ValidTarget(Gtarget, 925) and self.selectedTar) then
    target = self.selectedTar
  end
  mousePos = GetMousePos()
   Activator:Loaditems("ap")
  if myHero.dead then
  
    if self.Ball ~= myHero then
      self.Ball = myHero
    end
    
    return
  end
end
 function Orianna:Tick()
self:Checks()
if menu.Keys.combokey:Value() then
    self:Combo()
  end
    if(menu.Keys.harasskey:Value()   ) then
    self:harass()
  end
    if(menu.Keys.escapekey:Value() )then
    self:escape()
  end
  if(menu.killsteal.ks:Value() ) then
    self:killsteal()
  end
  if( menu.Keys.lasthitkey:Value() or menu.farm.lasthit.autolasthit:Value() )then
  self:LastHit()
end
if(menu.Keys.jungleclearkey:Value() )then
  self:JungleClear()
end
if(menu.Keys.laneclearkey:Value() )then
  self:LaneClear()
end
    Antiafk()
  autolevel()
  skinhack()
  autopot()
Activator:Useitems("ap")
  self:auto()
  self:autoq()
  end
  function Orianna:auto()
    if not  menu.misc.auto.use:Value() then return end
    if   menu.misc.auto.useW:Value() then
       local num =  menu.misc.auto.wcount:Value()
          if EnemiesAround(self.Ball, 235) >= num then
       self:CastW(target)
     end
   end
    if   menu.misc.auto.useR:Value() then
       local num =  menu.misc.auto.rcount:Value()
          if EnemiesAround(self.Ball, self.R.range) >= num then
       self:CastR(target)
     end
   end
  if menu.instruct:Value() then
    menu.instruct:Value(false)
    PopUp1 = true
  end
  end
  function Orianna:autoq()
    if not  menu.harass.useautoq:Value() then return end
      if(GetDistance(target) <= 825  and (myHero.mana / myHero.maxMana >=  menu.harass.QMana:Value()  /100 )  and IsReady(_Q))then
          self:CastQ(Gtarget)
        end
  end
  function Orianna:harass()
     if(GetDistance(target) <= 825 and menu.harass.useQ:Value() and (myHero.mana / myHero.maxMana >=  menu.harass.QMana:Value()  /100 )  and IsReady(_Q))then
          self:CastQ(Gtarget)
        end
         if not  self.Ball ~= myHero then
         if(GetDistance(target) <= self.W.range  and menu.harass.useW:Value() and (myHero.mana / myHero.maxMana >=  menu.harass.WMana:Value()  /100 )   and IsReady(_W))then
              if self:ValidTargetNear(target, self.W.radius, self.Ball) then
              self:CastW(target)
            end
          end
            elseif self.Ball ~= myHero then
                         if(GetDistance(target) <= self.W.range  and menu.harass.useW:Value() and (myHero.mana / myHero.maxMana >=  menu.harass.WMana:Value()  /100 )   and IsReady(_W))then
                                if self:ValidTargetNear(target, self.W.radius, self.Ball) then
             DelayAction(function()  self:CastW(target)  end, 0.25)
            end
                       end
          end
  end
  function Orianna:Combo()
  if(ValidTarget(target, 825)  and menu.combo.useQ:Value()   and IsReady(_Q))then
          self:CastQ(Gtarget)
        end
        if not  self.Ball ~= myHero then
         if(GetDistance(target) <= self.W.range  and menu.combo.useW:Value()   and IsReady(_W))then
              if self:ValidTargetNear(target, self.W.radius, self.Ball) then
              self:CastW(target)
            end
          end
            elseif self.Ball ~= myHero then
                         if(GetDistance(target) <= self.W.range  and menu.combo.useW:Value()   and IsReady(_W))then
                                if self:ValidTargetNear(target, self.W.radius, self.Ball) then
             DelayAction(function()  self:CastW(target)  end, 0.25)
            end
                       end
          end
           if menu.combo.useE:Value() == 1 then
          if (myHero.mana / myHero.maxMana >=   menu.combo.emana:Value()  /100 ) then
          if not IsReady(_W) then
if(GetDistance(target) <= self.E.range  and IsReady(_E))then
  local x, y, z = VectorPointProjectionOnLineSegment(mousePos, GetOrigin(target), Vector(self.Ball))
    if z and GetDistance(x, self.Ball) < 80 then
      if( self:GetEDmg(target) >target.health ) then
                self:CastE(myHero)
              end
            end
          end
          end
        end
          elseif menu.combo.useE:Value() == 2 then
                      if (myHero.mana / myHero.maxMana >=   menu.combo.emana:Value()  /100 ) then
          if not IsReady(_W) then
if(GetDistance(target) <= self.E.range  and IsReady(_E))then
  local x, y, z = VectorPointProjectionOnLineSegment(mousePos, GetOrigin(target), Vector(self.Ball))
    if z and GetDistance(x, self.Ball) < 80 then
                self:CastE(myHero)
              end
            end
          end
          end
        end
 
                if(GetDistance(target,self.Ball) <= self.R.range and menu.combo.useR:Value() and IsReady(_R))then
                  if self:ValidTargetNear(target, self.R.radius, self.Ball) then
                  if menu.combo.rlogic:Value() == 1 then
       if not (( IsReady(_Q) and self:GetQDmg(target) >target.health ) or  ( IsReady(_W) and self:GetWDmg(target) >target.health ) or  ( IsReady(_Q) and IsReady(_W) and  self:GetQDmg(target)+self:GetWDmg(target) >target.health )) then 
       if self:GetRDmg(target) >target.health then
              self:CastR(target)
            end
          end
          elseif menu.combo.rlogic:Value() == 2 then
              if self:GetRDmg(target) >target.health then
                    self:CastR(target)
                  end
                  elseif menu.combo.rlogic:Value() == 3 then
                             self:CastR(target)
                  end
                end
                  if menu.combo.useRM:Value() then
          local num =  menu.combo.rcount:Value()
          if EnemiesAround(self.Ball, self.R.range) >= num then
       self:CastR(target)
        end
        end
      end
end
  function Orianna:LaneClear()
    if not ValidTarget(ClosestMinion(GetOrigin(myHero), MINION_ENEMY),  1000) then return end
 for i, minion in pairs(minionManager.objects) do
                      if ValidTarget(minion, 1000)  and GetTeam(minion) == MINION_ENEMY then
                    if (myHero.mana / myHero.maxMana >=  menu.farm.laneclear.WMana:Value() /100 ) then
                      if IsReady(_W) then
                        if  menu.farm.laneclear.useW:Value()   then
                          if MinionsAround(self.Ball, 250, MINION_ENEMY) >=menu.farm.laneclear.wcount:Value() and self.Ball~= myHero then
                          self:CastW(minion) 
                          end
                        end
                      end
                  end
                end
              end

                  if IsReady(_Q) then
                    if (myHero.mana / myHero.maxMana >= menu.farm.laneclear.QMana:Value() /100 ) then
                      local NumberOfHits = menu.farm.laneclear.qcount:Value()
                        if menu.Keys.laneclearkey:Value()  and menu.farm.laneclear.useQ:Value()  then
                          local BestPos, BestHit = GetFarmPosition(self.Q.range, 160, MINION_ENEMY)
                          if BestPos and BestHit and BestHit >= NumberOfHits then
                            CastSkillShot(_Q, BestPos)
                          end
                        end
                      end
                    end
                  end
                  function Orianna:JungleClear()
      if not ValidTarget(ClosestMinion(GetOrigin(myHero), MINION_JUNGLE),  1000) then return end
 for i, minion in pairs(minionManager.objects) do
                      if ValidTarget(minion, 1000) and minion ~= nil and GetTeam(minion) == MINION_JUNGLE then
                   if (myHero.mana / myHero.maxMana >=  menu.farm.jungleclear.WMana:Value() /100 ) then
                      if IsReady(_W) then
                        if  menu.farm.jungleclear.useW:Value()   then
                          if MinionsAround(self.Ball, 250, MINION_JUNGLE) >=1 then
                          self:CastW(minion) 
                          end
                        end
                      end
                  end
                end
              end

                  if IsReady(_Q) then
                    if (myHero.mana / myHero.maxMana >= menu.farm.jungleclear.QMana:Value() /100 ) then
                        if  menu.farm.jungleclear.useQ:Value()  then
                          local BestPos, BestHit = GetFarmPosition(self.Q.range, 160, MINION_JUNGLE)
                          if BestPos and BestHit and BestHit >= 1 then
                            CastSkillShot(_Q, BestPos)
                          end
                        end
                      end
                    end
                  end
                  function Orianna:LastHit()
for _, target in pairs(minionManager.objects) do
  if GetTeam(target) == MINION_ENEMY then
    if IsObjectAlive(target) then
      if menu.farm.lasthit.lasthitlogic:Value() == 1 then
        local Qdamage = self:GetQDmg(target)
        if(IsReady(_Q) and menu.farm.lasthit.useQ:Value() and ValidTarget(target,self.Q.range)   and Qdamage >= GetCurrentHP(target)) then
          self:CastQ(target)
        end
      end
    end
  end
end
end
function Orianna:Draw()
    if menu.other.draw.qdraw:Value() and IsReady(_Q) then
          DrawCircle(myHero.x, myHero.y, myHero.z, 825,  menu.other.width.Qwidth:Value(),0,menu.other.color.Qcolor:Value())
        end

        if menu.other.draw.wdraw:Value() and IsReady(_W) then
          DrawCircle(myHero.x, myHero.y, myHero.z, 825,  menu.other.width.Wwidth:Value(),0, menu.other.color.Wcolor:Value())
        end

        if menu.other.draw.edraw:Value() and IsReady(_E) then
          DrawCircle(myHero.x, myHero.y, myHero.z, 1100,  menu.other.width.Ewidth:Value(),0, menu.other.color.Ecolor:Value())
        end

        if menu.other.draw.rdraw:Value() and IsReady(_R) then
          DrawCircle(myHero.x, myHero.y, myHero.z, 1100, menu.other.width.Rwidth:Value(),0, menu.other.color.Rcolor:Value())
        end
        if menu.other.draw.aadraw:Value() then
          DrawCircle(myHero.x, myHero.y, myHero.z, 525, menu.other.width.AAwidth:Value(),0, menu.other.color.AAcolor:Value())
        end

        if menu.other.circleball.enable:Value() then
        if self.Ball ~= myHero then
 DrawCircle(self.Ball.x, self.Ball.y, self.Ball.z, 125, menu.other.circleball.ballwidth:Value(),0, menu.other.circleball.ballcolor:Value())
end
end
     if menu.other.circleball.enable:Value() then
          if self.Ball ~= myHero then
if  menu.other.circleball.circleballs.draww:Value() then
 DrawCircle(self.Ball.x, self.Ball.y, self.Ball.z, 250, menu.other.circleball.ballwidth:Value(),0, menu.other.circleball.circleballs.ballcolorw:Value())
end
if menu.other.circleball.circleballs.drawr:Value() then
   DrawCircle(self.Ball.x, self.Ball.y, self.Ball.z, 325, menu.other.circleball.ballwidth:Value(),0, menu.other.circleball.circleballs.ballcolorr:Value())
 end
end
end
Global:Commondraw()
    for _, target in pairs(GetEnemyHeroes()) do
      if ValidTarget(target, 15000) then
        if target.visible and not target.dead and menu.other.damage:Value() then
          currLine = 1
          -- DrawLineHPBar2(self:GetMyDmg(target),"",  target, currLine)
          DrawLineHPBar(self:GetMyDmg(target), "Damage " .. math.round(self:GetMyDmg(target)),target,currLine)
          currLine = currLine + 1
          DrawDmgOverHpBar(target,GetCurrentHP(target),0,self:GetMyDmg(target),0xff00ff00)
        end
      end
    end

    if menu.other.targetcal:Value() and not myHero.dead then
      if target and target ~= nil then
        --  local target= GetOrigin(target)
        local drawpos=WorldToScreen(1,target.x, target.y, target.z)
        local comboText,color = self:GetDraws(target)
        if comboText then
          DrawText(comboText,15,drawpos.x-20,drawpos.y-20,color)
        end
      end
    end
  end
function Orianna:AddRange(unit)
  return unit.boundingRadius
end

function Orianna:TrueRange(enemy)
  return myHero.range+self:AddRange(myHero)+self:AddRange(enemy)
end
  function Orianna:CastI(unit)
    if Ignite then
      if IsReady(Ignite) then
        CastTargetSpell(unit, Ignite)
      end
    end
  end
  function Orianna:CastQ(unit)
      if self.Ball and self.Ball ~=nil  then
    if menu.pred.selectpred:Value() == 1 then
      local QPred = GetPrediction(unit, self.Q, self.Ball)
      if IsReady(_Q) then
        if QPred  and QPred.hitChance >= (menu.pred.hcgeneral.hcop.hcopq:Value()/100) then
          CastSkillShot(_Q, QPred.castPos)
        end
      end
    elseif menu.pred.selectpred:Value() == 2 then
        local HitChance, y = qSpell:Predict(unit)
        if IsReady(_Q) and HitChance >= 3 then
          CastSkillShot(_Q, y.x, y.y, y.z)
        end
    elseif menu.pred.selectpred:Value() == 3 then
      local qPred = GetPredictionForPlayer(self.Ball, unit, GetMoveSpeed(unit), 1200, 250, 825, 160, false, true)
      if IsReady(_Q) and qPred.HitChance == 1 then
        CastSkillShot(_Q, qPred.PredPos.x, qPred.PredPos.y, qPred.PredPos.z)
      end
    end
end
end
    function Orianna:CastW( unit)
   if GetDistance(unit,self.Ball) <= self.W.range then
    if IsReady(_W) then
      CastSpell(_W)
    end
end
  end
   function Orianna:CastE(unit)
            if IsReady(_E) then
              CastTargetSpell(unit, _E)
            end
          end
          function Orianna:GiveE(unit)
            if unit.dead then
    return
  end
    CastTargetSpell(unit, _E)
end
    function Orianna:CastR(unit)
  if GetDistance(unit,self.Ball) <= self.R.range then
    if IsReady(_R) then
      CastSpell(_R)
    end
end
  end
  function Orianna:GetQDmg(target)
              if GetCastLevel(myHero, _Q) < 1 then
                return 0
              end
              if IsReady(_Q) then
                local FinalDamage = (30 + (GetCastLevel(myHero, _Q) * 30) + (GetBonusAP(myHero))*.5)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function Orianna:GetWDmg(target)
              if GetCastLevel(myHero, _W) < 1 then
                return 0
              end
              if IsReady(_W) then
                local FinalDamage =  (25 + (GetCastLevel(myHero, _Q) * 45) + (GetBonusAP(myHero))*.7)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function Orianna:GetEDmg(target)
              if GetCastLevel(myHero, _E) < 1 then
                return 0
              end
              if IsReady(_E) then
                local FinalDamage = (30 + (GetCastLevel(myHero, _W) * 30) + (GetBonusAP(myHero))* .3)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function Orianna:GetRDmg(target)
              if GetCastLevel(myHero, _R) < 1 then
                return 0
              end
              if IsReady(_R) then
                local FinalDamage = (75 + (GetCastLevel(myHero, _R) * 75) + (GetBonusAP(myHero))* .7)
                return CalcDamage(myHero,target,0, FinalDamage)
              else
                return 0
              end
            end
            function Orianna:GetMyDmg(target)
              if IsReady(_Q) and IsReady(_W) and IsReady(_R) and IsReady(_E) then
                return self:GetQDmg(target) + self:GetWDmg(target) + self:GetRDmg(target) + self:GetEDmg(target)
              elseif IsReady(_Q) and IsReady(_W) and IsReady(_R) then
                return self:GetQDmg(target) + self:GetWDmg(target) + self:GetRDmg(target)
              elseif IsReady(_Q) and IsReady(_W) and IsReady(_E) then
                return self:GetQDmg(target) + self:GetWDmg(target) + self:GetEDmg(target)
              elseif IsReady(_Q) and IsReady(_R) and IsReady(_E) then
                return self:GetQDmg(target) + self:GetRDmg(target) + self:GetEDmg(target)
              elseif IsReady(_R) and IsReady(_W) and IsReady(_E) then
                return self:GetRDmg(target) + self:GetWDmg(target) + self:GetEDmg(target)
              elseif IsReady(_Q) and IsReady(_W) then
                return self:GetQDmg(target) + self:GetWDmg(target)
              elseif IsReady(_E) and IsReady(_W) then
                return self:GetEDmg(target) + self:GetWDmg(target)
              elseif IsReady(_R) and IsReady(_W) then
                return self:GetRDmg(target) + self:GetWDmg(target)
              elseif IsReady(_Q) and IsReady(_R) then
                return self:GetQDmg(target) + self:GetRDmg(target)
              elseif IsReady(_E) and IsReady(_R) then
                return self:GetEDmg(target) + self:GetRDmg(target)
              elseif IsReady(_Q) and IsReady(_E) then
                return self:GetQDmg(target) + self:GetEDmg(target)
              elseif IsReady(_R) then
                return self:GetRDmg(target)
              elseif IsReady(_E) then
                return self:GetEDmg(target)
              elseif IsReady(_Q) then
                return self:GetQDmg(target)
              elseif IsReady(_W) then
                return self:GetWDmg(target)
              else
                return 0
              end
            end
            function Orianna:GetDraws(target)
              local qdamage = self:GetQDmg(target)
              local wdamage = self:GetWDmg(target)
              local edamage = self:GetEDmg(target)
              local rdamage = self:GetRDmg(target)
              local Idmg=(50+ ((myHero.level)*20))

              if qdamage >target.health then
                return 'Q', GoS.White
              elseif qdamage+ Idmg>target.health then
                return 'Q + Ignite', GoS.White
              elseif wdamage >target.health then
                return 'W', GoS.White
              elseif wdamage+ Idmg>target.health then
                return 'W + Ignite', GoS.White
              elseif edamage >target.health then
                return 'E', GoS.White
              elseif edamage + Idmg>target.health then
                return 'E + Ignite', GoS.White
              elseif rdamage  >target.health then
                return 'R', GoS.White
              elseif rdamage + Idmg>target.health then
                return 'R + Ignite', GoS.White
              elseif rdamage +edamage  >target.health then
                return 'R + E',GoS.White
              elseif rdamage +edamage+ Idmg>target.health then
                return 'R + E + Ignite',GoS.White
              elseif edamage+wdamage >target.health then
                return 'E + W',GoS.White
              elseif edamage+wdamage+ Idmg>target.health then
                return 'E + W + Ignite',GoS.White
              elseif rdamage+wdamage >target.health then
                return 'R + W',GoS.White
              elseif rdamage+wdamage+ Idmg>target.health then
                return 'R + W + Ignite',GoS.White
              elseif qdamage+wdamage >target.health then
                return 'Q + W',GoS.White
              elseif qdamage+edamage>target.health then
                return 'Q + E',GoS.White
              elseif qdamage+rdamage >target.health then
                return 'Q + R',GoS.White
              elseif qdamage+wdamage+ Idmg>target.health then
                return 'Q + W + Ignite',GoS.White
              elseif qdamage+edamage+ Idmg>target.health then
                return 'Q + E + Ignite',GoS.White
              elseif qdamage+rdamage+ Idmg>target.health then
                return 'Q + R + Ignite',GoS.White
              elseif qdamage+edamage+wdamage >target.health then
                return 'Q + W + E',GoS.White
              elseif qdamage+rdamage+wdamage >target.health then
                return 'Q + W + R',GoS.White
              elseif qdamage+edamage+rdamage >target.health then
                return 'Q + R + E',GoS.White
              elseif qdamage+edamage+wdamage+ Idmg>target.health then
                return 'Q + W + E + Ignite',GoS.White
              elseif qdamage+wdamage+edamage+rdamage >target.health then
                return 'Kill with full combo',GoS.White
              elseif qdamage+wdamage+edamage+rdamage+Idmg>target.health then
                return 'Full Combo + Ignite',GoS.White
              else
                return "Cant Kill yet", GoS.White
              end
            end
 function Orianna:LoadMenu()
     menu=MenuConfig("menu",""..Scriptname.." [" .. myHero.charName.."]" )

              menu:Menu( "combo",loc_eng[1])
              menu.combo:Boolean("useQ", loc_eng[2], true)
              menu.combo:Boolean("useW", loc_eng[3], true)
              menu.combo:DropDown("useE","E logic for combo ;",1, {"If Target Killable","Always"," Never"})
              menu.combo:Slider("emana","Use E if Mana Percent => % ", 10, 10, 100, 1)
              menu.combo:Info("blank", " R Settings")
              menu.combo:Boolean("useR", "Use R  For Single Target", true)
              menu.combo:DropDown("rlogic","R logic (Single Target) ;",1, {"Smart","If Target Killable","Always"})
              menu.combo:Boolean("useRM", "Use R  For Multiple Target", true)
              menu.combo:Slider("rcount","Use R Min Count", 3, 2, 5, 1)
              menu.combo:Boolean("useI", loc_eng[6], true)
              menu.combo:Slider("Mana",loc_eng[8], 10, 10, 100, 1)


              menu:Menu( "harass",loc_eng[9])
              menu.harass:Boolean("useautoq", "Use Auto Q Harass", false)
              menu.harass:Boolean("useQ", loc_eng[10], true)
              menu.harass:Slider("QMana","Use Q if Mana Percent => % ", 30, 10, 100, 1)
              menu.harass:Boolean("useW", loc_eng[11], true)
              menu.harass:Slider("WMana","Use W if Mana Percent => % ", 30, 10, 100, 1)
        


              menu:Menu( "farm",loc_eng[14])

              menu.farm:Menu("laneclear",loc_eng[15])
              menu.farm.laneclear:Boolean("useQ",loc_eng[16],true)
              menu.farm.laneclear:Slider("qcount",loc_eng[180], 2, 1, 10, 1)
              menu.farm.laneclear:Boolean("useW",loc_eng[17],true)
              menu.farm.laneclear:Slider("wcount",loc_eng[181], 2, 1, 10, 1)
              menu.farm.laneclear:Info("blank","" )
              menu.farm.laneclear:Info("blank", "")
              menu.farm.laneclear:Info("info2", loc_eng[184])
              menu.farm.laneclear:Slider("QMana",loc_eng[185], 30, 10, 100, 1)
              menu.farm.laneclear:Slider("WMana",loc_eng[186], 30, 10, 100, 1)

              menu.farm:Menu("jungleclear",loc_eng[20])
              menu.farm.jungleclear:Boolean("useQ",loc_eng[21],true)
              menu.farm.jungleclear:Boolean("useW",loc_eng[22],true)
              menu.farm.jungleclear:Info("blank","" )
              menu.farm.jungleclear:Info("blank","" )
              menu.farm.jungleclear:Info("info2", loc_eng[184])
              menu.farm.jungleclear:Slider("QMana",loc_eng[185], 30, 10, 100, 1)
              menu.farm.jungleclear:Slider("WMana",loc_eng[186], 30, 10, 100, 1)

              menu.farm:Menu("lasthit",loc_eng[25])
              menu.farm.lasthit:Boolean("autolasthit",loc_eng[189],false)
              menu.farm.lasthit:Boolean("useQ",loc_eng[26],true)
              menu.farm.lasthit:DropDown("lasthitlogic",loc_eng[191],1, {loc_eng[172],loc_eng[174]})
              menu.farm.lasthit:Info("blank", "")
              menu.farm.lasthit:Info("blank", "")
              menu.farm.lasthit:Info("info2", loc_eng[184])
              menu.farm.lasthit:Slider("QMana",loc_eng[185], 30, 10, 100, 1)

              menu:Menu( "killsteal",loc_eng[35])
              menu.killsteal:Boolean("ks",loc_eng[36],true)
              menu.killsteal:Boolean("useQ", loc_eng[37], true)
              menu.killsteal:Boolean("useW", loc_eng[38], true)
              menu.killsteal:Boolean("useE", loc_eng[39], true)
              menu.killsteal:Boolean("useR", loc_eng[40], true)
              menu.killsteal:Boolean("useI", loc_eng[41], true)

                  menu:Menu("escape",loc_eng[30])
      menu.escape:Boolean("useE",loc_eng[33],true)

Activator:Loadmenu("ap")



              menu:Menu("misc",loc_eng[92])
                       menu.misc:Menu( "auto","[" .. myHero.charName.. "] - Auto Settings")
            menu.misc.auto:Boolean("use", "Use Auto Settings", false)
              menu.misc.auto:Boolean("useW", "Use W (Multiple Target)", false)
             menu.misc.auto:Slider("wcount", "Use W Minimum Count",  3, 2, 5, 1) 
           menu.misc.auto:Boolean("useR", "Use R (Multiple Target)", false)
             menu.misc.auto:Slider("rcount", "Use R Minimum Count",  3, 2, 5, 1) 
              menu.misc:Menu( "interrupt",loc_eng[93])
              menu.misc.interrupt:Boolean("r", loc_eng[97], true)
              menu.misc.interrupt:Info("info3", loc_eng[98])
    DelayAction(function()
  local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
  for i, spell in pairs(CHANELLING_SPELLS) do
    for _,k in pairs(GetEnemyHeroes()) do
        if spell["Name"] == GetObjectName(k) then
        menu.misc.interrupt:Boolean(GetObjectName(k).."Inter", "On "..GetObjectName(k).." "..(type(spell.Spellslot) == 'number' and str[spell.Spellslot]), true)
        end
    end
  end
end, 0.35)

              menu.misc:Menu( "skinhack","[" .. myHero.charName.. "] - Skinhack Settings")
              menu.misc.skinhack:Boolean("useskin",loc_eng[54], false)
              menu.misc.skinhack:DropDown('selected' .. myHero.charName .. 'Skin', loc_eng[57]  ,  1, skinMeta[myHero.charName])
              menu.misc:Menu( "autolevel","[" .. myHero.charName.. "] - AutoLevel Settings")
              menu.misc.autolevel:Boolean("uselevel",loc_eng[51], false)
              menu.misc.autolevel:DropDown("logic", loc_eng[52] , 7, {loc_eng[58], loc_eng[59],loc_eng[60],loc_eng[61],loc_eng[62], loc_eng[63], loc_eng[64]  })
              menu.misc:Menu( "antiafk","[" .. myHero.charName.. "] - AntiAFK Settings")
              menu.misc.antiafk:Boolean("useafk",loc_eng[196], false)

              Clock = os.clock()
              menu:Menu("other",loc_eng[65])
              --menu.other:Menu("Show Damage On Hp Bar", "HPBAR")
              --menu.other.HPBAR:Boolean("key","ON/OFF",true)
              menu.other:Menu( "draw",loc_eng[66])
               menu.other:Menu( "circleball","Circle for Ball")
                              menu.other.circleball:Menu( "circleballs","Ball Skill Ranges")
                  menu.other.circleball.circleballs:Boolean("draww","Draw W Range", false)
                     menu.other.circleball.circleballs:Boolean("drawr","Draw W Range", false)
                        menu.other.circleball.circleballs:ColorPick("ballcolorw", "W Color",   {255, 255, 255, 255})
                                      menu.other.circleball.circleballs:ColorPick("ballcolorr", "R color",   {255, 255, 255, 255})
              menu.other.circleball:Boolean("enable","Enable", true)
             menu.other.circleball:ColorPick("ballcolor", "Color",   {255, 255, 255, 255})
              menu.other.circleball:Slider("ballwidth", "Width", 1, 1, 10, 1)
              menu.other.draw:Boolean("qdraw",loc_eng[67],true)
              menu.other.draw:Boolean("wdraw",loc_eng[68],true)
              menu.other.draw:Boolean("edraw",loc_eng[69],true)
              menu.other.draw:Boolean("rdraw",loc_eng[70],true)
              menu.other.draw:Boolean("aadraw",loc_eng[71],false)
              menu.other:Menu( "color",loc_eng[198])
              menu.other.color:ColorPick("Qcolor", loc_eng[199],{255, 255, 255, 255})
              menu.other.color:ColorPick("Wcolor", loc_eng[200],{255, 255, 255, 255})
              menu.other.color:ColorPick("Ecolor", loc_eng[201],{255, 255, 255, 255})
              menu.other.color:ColorPick("Rcolor", loc_eng[202],{255, 255, 255, 255})
              menu.other.color:ColorPick("AAcolor", loc_eng[204],{255, 255,0,0})
              -- menu.other.color:ColorPick("targetselect", loc_eng[205],{255, 255,0,0})
              menu.other:Menu( "width",loc_eng[206])
              menu.other.width:Slider("Qwidth", loc_eng[210],  1, 1, 10, 1)
              menu.other.width:Slider("Wwidth", loc_eng[211],  1, 1, 10, 1)
              menu.other.width:Slider("Ewidth", loc_eng[212],  1, 1, 10, 1)
              menu.other.width:Slider("Rwidth", loc_eng[213],  1, 1, 10, 1)
              menu.other.width:Slider("AAwidth", loc_eng[209], 1, 1, 10, 1)
              -- menu.other.width:Slider("STwidth", loc_eng[208], 1, 1, 10, 1)
              menu.other:Boolean("target",loc_eng[75],true)
              menu.other:Boolean("damage",loc_eng[214],true)
              menu.other:Boolean("targetcal",loc_eng[76],true)
              --          menu.other:Menu( "perma",loc_eng[73])
              -- menu.other.perma:Boolean("perma",loc_eng[74],true)

              menu:Menu("targetsel",loc_eng[77])
              menu.targetsel:Boolean("ts",loc_eng[78],false)

              menu:Menu("orb","Orbwalker Settings")
              menu.orb:Menu( "selectorb","Current Orbwalker :")


              menu:Menu("pred","Prediction Settings")
              menu.pred:DropDown("selectpred","Current Predictions :",   1, {"Open Prediction","IPrediction","Gos Prediction"})
              menu.pred:Menu( "hcgeneral","Hitchance Settings")
              menu.pred.hcgeneral:Menu( "hcop","Open Prediction Hitchance")
              menu.pred.hcgeneral.hcop:Slider("hcopq", "Q Hitchance " , 30, 0, 100, 1)
              menu.pred:Info("blank", "    Currently Open Prediction "   )
              menu.pred:Info("blank", "      is best with this bundle"   )


              menu:Menu( "Keys",loc_eng[79])
              menu.Keys:Info("infoK3", loc_eng[80])
              menu.Keys:Key("combokey", loc_eng[81],string.byte(" "))
              menu.Keys:Info("infoK4", loc_eng[82])
              menu.Keys:Key("harasskey", loc_eng[83],string.byte("C"))
              menu.Keys:Key("autoq", loc_eng[91], string.byte("T"))
              menu.Keys:Info("infoK5", loc_eng[84])
              menu.Keys:Key("laneclearkey", loc_eng[85],string.byte("V"))
              menu.Keys:Key("jungleclearkey", loc_eng[86],string.byte("V"))
              menu.Keys:Key("lasthitkey",loc_eng[215],string.byte("X"))
              menu.Keys:Info("infoK6", loc_eng[87])
              menu.Keys:Key("escapekey", loc_eng[88],string.byte("Y"))
              --menu.Keys:Boolean("lasthitkey", "Lasthit Key",string.byte("X"))
              menu.Keys:Info("infoK","" )
              menu.Keys:Info("infoK2", loc_eng[89])

              menu:Info("infoK","           "..Scriptname.."" )
              menu:Info("infoK","         Script Version:  "..Version.. "  " )
              menu:Info("infoK","   Script was made by  "..Author.. "" )
              menu:Info("infoK","Leauge Of Legends Version: "..LVersion.. "" )
              menu:Boolean("instruct", loc_eng[216], false)



    end
      function Orianna:escape()
    if menu.Keys.escapekey:Value()  then
  if menu.escape.useE:Value()  then
    if  IsReady(_E) and GetDistance(target) <= 525  then
      self:CastE(myHero)
    else
      MoveToXYZ(mousePos)
    end
  end
end
end
 function Orianna:killsteal()
   if Hptarget ~= nil then
                local health = GetCurrentHP(Hptarget)
                local dmgQ = self:GetQDmg(Hptarget)
                if(GetDistance(Hptarget) <= self.Q.range and  IsReady(_Q) and not menu.Keys.combokey:Value()   and health<dmgQ and menu.killsteal.useQ:Value() and menu.killsteal.ks:Value() )then
                  self:CastQ(Hptarget)
                end
                local dmgW = self:GetWDmg(Hptarget)
           if( self:ValidTargetNear(Hptarget, self.W.radius, self.Ball)  and  IsReady(_W) and not menu.Keys.combokey:Value()  and health<dmgQ and menu.killsteal.useW:Value() and menu.killsteal.ks:Value() )then
                  self:CastW(Hptarget)
                end
                local dmgI =(50+ ((myHero.level)*20))
                if(health<dmgI and menu.killsteal.useI:Value() and menu.killsteal.ks:Value() and GetDistance(Hptarget)<600)then
                  self:CastI(Hptarget)
                end
                local dmgR =self:GetRDmg(Hptarget)
                if(self:ValidTargetNear(Hptarget, self.R.range, self.Ball) and  IsReady(_R) and not menu.Keys.combokey:Value()   and health<dmgR and menu.killsteal.useR:Value() and menu.killsteal.ks:Value() )then
                  self:CastR(Hptarget)
                end
              end
                  end
    function  Orianna:ProcessSpell(unit, spell)
    if unit == myHero then
      if unit and spell then
        if spell.name == "OrianaIzunaCommand" then
    self.Ball = Vector(spell.endPos)
  elseif spell.name == "OrianaRedactCommand" then
    self.Ball = spell.target
  end
  end
end
       if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and IsReady(_R) then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 1000) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and  menu.misc.interrupt[GetObjectName(unit).."Inter"]:Value() and menu.misc.interrupt.r:Value() then 
         self:CastR(unit)
        end
      end
    end
            end
    function Orianna:UpdateBuff(unit,buff)
                    if unit and unit.team == myHero.team and unit.type == myHero.type then
                      if  buff.Name == "orianaghostself" then
                         self.Ball = myHero
                      end
                    end
                  end
    function Orianna:ValidTargetNear(object, distance, from)
  return object ~= nil and object.valid and object.team ~= myHero.team and object.visible and not object.dead  and GetDistanceSqr(object, from) <= distance*distance
end
    function Orianna:WndMsg(Msg, Key)
      if menu.targetsel.ts:Value() then
        if Msg == WM_LBUTTONDOWN then
          local minD = 10
          local starget = nil
          for i, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy) then
              if GetDistance(enemy, mousePos) <= minD or starget == nil then
                minD = GetDistance(enemy, mousePos)
                starget = enemy
              end
            end
          end
          if starget and minD < 150 then
            if self.selectedTar and starget.charName == self.selectedTar.charName then
              self.selectedTar = nil
              print("<font color=\"#FFFFFF\">Target <b>is no loger selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
            else
              self.selectedTar = starget
              print("<font color=\"#FFFFFF\">New target <b>selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
            end
          end
        end
      end
      if Msg == WM_LBUTTONDOWN then
        if PopUp1 then
          PopUp1 = false
        end
      end
    end
class "Zed"
local GR = 0
local Wdmgp = false
local Rdmgp = false
local Rbuff = false
local GW = 0
local startTime = 0
local startTimer = 0
local wgapclose = false
function Zed:__init()
        if not libloaded then return end
  self.Q = { delay = 0.25, speed = 1700 ,width = 50, range = 900  }
self.W = { range = 700  ,speed = 1750 ,width = 250 }
self.E = { range = 290  }
self.R = { range = 625   }
Last_LevelSpell = 0
global_ticks = 0
 Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
self.tsg = TargetSelector(1100,TARGET_LESS_CAST_PRIORITY,DAMAGE_PHYSICAL,true,false)
qSpell = IPrediction.Prediction({range = 900, speed = 1700, delay = 0.25, width = 50, type = "linear", name =myHero:GetSpellData(_Q).name, collision = false})
Callback.Add("Tick", function() self:Tick() end)
Callback.Add("Load", function() self:onload() end)
Callback.Add("WndMsg", function(Msg, Key) self:WndMsg(Msg, Key) end)
Callback.Add("Draw", function() self:Draw() end)
Callback.Add("UpdateBuff", function(unit,buff) self:UpdateBuff(unit,buff) end)
Callback.Add("RemoveBuff", function(unit,buff) self:RemoveBuff(unit,buff) end)
Callback.Add("ProcessSpell", function(unit, spell) self:ProcessSpell(unit, spell) end)
--Callback.Add("CreateObj", function(obj) self:CreateObj(obj) end)
--Callback.Add("DeleteObj", function(obj) self:DeleteObj(obj) end)
self:LoadMenu()
end
function Zed:Checks()
Gtarget = self.tsg:GetTarget()
if not ValidTarget(Gtarget, 925) or not menu.targetsel.ts:Value()  then
target = GetCurrentTarget()
elseif  ValidTarget(Gtarget, 925) and not self.selectedTar then
target = GetCurrentTarget()
elseif (ValidTarget(Gtarget, 925) and self.selectedTar) then
target = self.selectedTar
end
mousePos = GetMousePos()
Blg = GetItemSlot(myHero,3144) > 0 and GetItemSlot(myHero,3144) or nil
Yahu = GetItemSlot(myHero,3142) > 0 and GetItemSlot(myHero,3142) or nil
Tia = GetItemSlot(myHero,3077) > 0 and GetItemSlot(myHero,3077) or nil
Rhyd = GetItemSlot(myHero,3074) > 0 and GetItemSlot(myHero,3074) or nil
Thyd = GetItemSlot(myHero,3053) > 0 and GetItemSlot(myHero,3053) or nil
Btk = GetItemSlot(myHero,3153) > 0 and GetItemSlot(myHero,3153) or nil
Rand = GetItemSlot(myHero,3143) > 0 and GetItemSlot(myHero,3143) or nil
Qss = GetItemSlot(myHero,3140) > 0 and GetItemSlot(myHero,3140) or GetItemSlot(myHero,3139) > 0 and GetItemSlot(myHero,3139) or nil
end
function Zed:Tick()
self:Checks()
self:clearitems()
if(menu.Keys.combokey:Value()  and (myHero.mana / myHero.maxMana >=  menu.combo.Mana:Value()  /100 ) )then
  if divelogic(target) == true then
self:Combo()
end
end
if menu.Keys.combokey:Value() then
self:comboitems()
end
if menu.Keys.harasskey:Value() then
  self:harass()
end
if( menu.Keys.lasthitkey:Value() or menu.farm.lasthit.autolasthit:Value() )then
    self:LastHit()
  end
   if(menu.Keys.laneclearkey:Value() )then
    self:LaneClear()
  end
  if(menu.Keys.jungleclearkey:Value() )then
    self:JungleClear()
  end
if menu.harass.autoharass.useQ:Value() then
  self:Autoq()
end
if menu.Keys.escapekey:Value() then
  self:escape()
end
if menu.harass.autoharass.useE:Value() then
  self:Autoe()
end
if menu.harass.autoharass.use:Value() then
  self:Autoharass()
end
if menu.killsteal.ks:Value() then
  self:killsteal()
end
if menu.instruct:Value() then
menu.instruct:Value(false)
PopUp1 = true
end
Antiafk()
autolevel()
skinhack()
autopot()
end
function Zed:combomode()
local drawpos = GetHPBarPos(myHero)
if   menu.combo.rlogic:Value()  == 1 then
DrawText("Current Combo Mode: Line", 12, drawpos.x, drawpos.y+16, 0xff00ffff) end
if menu.combo.rlogic:Value()   == 2 then
  DrawText("Current Combo Mode Rectangle", 12, drawpos.x, drawpos.y+16, 0xff00ffff) end
  if menu.combo.rlogic:Value()   == 3 then
    DrawText("Current Combo Mode: Mouse Position", 12, drawpos.x, drawpos.y+16, 0xff00ffff) end
  end
  function Zed:Draw()
    if menu.other.combomode:Value() then
      self:combomode()
    end
    if menu.other.draw.qdraw:Value() and IsReady(_Q) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 900,  1,0,menu.other.color.Qcolor:Value())
    end

    if menu.other.draw.wdraw:Value() and IsReady(_W) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 700,  1,0, menu.other.color.Wcolor:Value())
    end

    if menu.other.draw.edraw:Value() and IsReady(_E) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 290,  1,0, menu.other.color.Ecolor:Value())
    end

    if menu.other.draw.rdraw:Value() and IsReady(_R) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 625, 1,0, menu.other.color.Rcolor:Value())
    end
    if menu.other.draw.aadraw:Value() then
      DrawCircle(myHero.x, myHero.y, myHero.z, 125, 1,0, menu.other.color.AAcolor:Value())
    end
    if Wpos and Wpos ~= nil then
      if  menu.other.circlew.enable:Value() then
        DrawCircle(Wpos.x, Wpos.y, Wpos.z, 125, menu.other.circlew.Wwidth:Value(),0, menu.other.circlew.Wcolor:Value())
      end
    end
    if Rpos and Rpos ~= nil then
      if  menu.other.circler.enable:Value() then
        DrawCircle(Rpos.x, Rpos.y, Rpos.z, 125, menu.other.circler.Wwidth:Value(),0, menu.other.circler.Wcolor:Value())
      end
    end
if   menu.other.circlew.enable:Value() then
  if  menu.other.circlew.timer:Value()  then
       if Wpos and Wpos ~= nil then
    local drawpos=WorldToScreen(1,Wpos.x, Wpos.y, Wpos.z)
    DrawText("Shadow Duration :"..math.round(startTime - os.clock(), 2).."s",15,drawpos.x,drawpos.y,GoS.White)
  end
end
end

if menu.misc.turretdive.Drawturret:Value() then
  for _, i in pairs(GetTurrets()) do
    if i and i.team ~= myHero.team then
      if mPos3D(myHero.x, myHero.z, i.x, i.z, 950) then
        DrawCircle(i.x, i.y, i.z, i.range ,1,0, 0xFFFF0000)
      else
        DrawCircle(i.x, i.y, i.z, i.range ,1,0, GoS.White)
      end
    end
  end
end

if  menu.other.circler.enable:Value() then
  if  menu.other.circler.timer:Value()  then
    if Rpos and Rpos ~= nil then
    local drawpos=WorldToScreen(1,Rpos.x, Rpos.y, Rpos.z)
    DrawText("Shadow Duration :"..math.round(startTimer - os.clock(), 2).."s",15,drawpos.x,drawpos.y,GoS.White)
  end
end
end
 Global:Commondraw()
    for _, target in pairs(GetEnemyHeroes()) do
      if ValidTarget(target, 15000) then
        if target.visible and not target.dead and menu.other.damage:Value() then
          currLine = 1
          -- DrawLineHPBar2(self:GetMyDmg(target),"",  target, currLine)
          DrawLineHPBar(self:GetMyDmg(target), "Damage " .. math.round(self:GetMyDmg(target)),target,currLine)
          currLine = currLine + 1
          DrawDmgOverHpBar(target,GetCurrentHP(target),0,self:GetMyDmg(target),0xff00ff00)
        end
      end
    end

    if menu.other.targetcal:Value() and not myHero.dead then
      if target and target ~= nil then
        --  local target= GetOrigin(target)
        local drawpos=WorldToScreen(1,target.x, target.y, target.z)
        local comboText,color = self:GetDraws(target)
        if comboText then
          DrawText(comboText,15,drawpos.x-20,drawpos.y-20,color)
        end
      end
    end
  end
  function Zed:buffcheck()
    if GotBuff(target, "zedrtargetmark")== 1 then
      return true
    else
      return false
    end
  end
  function Zed:UpdateBuff(unit,buff)
    if unit and unit.team ~= myHero.team and unit.type == myHero.type then
      if buff.Name:lower():find("zedulttargetmark") then
        Rbuff = true
      end
    end
  end
  function Zed:RemoveBuff(unit, buff)
    if unit and unit.team ~= myHero.team and unit.type == myHero.type then
      if buff.Name:lower():find("zedulttargetmark") then
        Rbuff = false
      end
    end
  end
  function Zed:Autoq()
        if(GetDistance(target) <= self.Q.range and menu.harass.useQ:Value()   and IsReady(_Q))then
          self:CastQ(target)
        end
  end
   function Zed:Autoe()
     if(menu.harass.useE:Value()  and IsReady(_E))then
      self:CastE()
    end
  end
  function Zed:escape()
    if menu.Keys.escapekey:Value()  then
  if menu.escape.useW:Value()  then
    if  IsReady(_W)  then
      CastSkillShot(_W, mousePos)
    else
      MoveToXYZ(mousePos)
    end
  end
end
end
  function Zed:Autoharass()
       if not (myHero.mana / myHero.maxMana >=  menu.harass.Mana:Value()  /100 ) then return end
           local Wposition =   GetOrigin(myHero) + (Vector(target) - GetOrigin(myHero)):normalized() * 700
    if  menu.harass.autoharass.harasslogic:Value() == 1 then
      if IsReady(_W) and IsReady(_Q) then
      if(GetDistance(target) <= self.W.range and menu.harass.useW:Value() and  IsReady(_W))then
      self:CastW( Wposition)
      end
 if  Wpos~= nil and target~= nil then
      if(GetDistance(target) <= self.Q.range and menu.harass.useQ:Value()   and IsReady(_Q))then
        DelayAction(function ()  self:CastWQ(target) end, 0.2)
      end
    end
  end
elseif menu.harass.autoharass.harasslogic:Value() == 2 then
    if IsReady(_W) and IsReady(_Q)and IsReady(_E) then
  if(GetDistance(target) <= self.W.range and menu.harass.useW:Value() and  IsReady(_W))then
      self:CastW( Wposition)
      end
      if  Wpos~= nil and target~= nil then
      if(GetDistance(target) <= self.Q.range and menu.harass.useQ:Value()   and IsReady(_Q))then
        DelayAction(function ()  self:CastWQ(target) end, 0.2)
      end
    end
     if(menu.harass.useE:Value()  and IsReady(_E))then
      self:CastE()
    end
  end
    elseif menu.harass.autoharass.harasslogic:Value() == 3 then
          if IsReady(_W) and IsReady(_E) then
      if(GetDistance(target) <= self.W.range and menu.harass.useW:Value() and  IsReady(_W))then
      self:CastW( Wposition)
      end
      if(menu.harass.useE:Value()  and IsReady(_E))then
      self:CastE()
    end
  end
end
  end
  function Zed:harass()
   if not (myHero.mana / myHero.maxMana >=  menu.harass.Mana:Value()  /100 ) then return end
      if(GetDistance(target) <= self.W.range and menu.harass.useW:Value() and  IsReady(_W))then
        local Wposition =   GetOrigin(myHero) + (Vector(target) - GetOrigin(myHero)):normalized() * 700
      self:CastW( Wposition)
      end

      if  Wpos~= nil and target~= nil then
      if(GetDistance(target) <= self.Q.range and menu.harass.useQ:Value()   and IsReady(_Q))then
        self:CastWQ(target)
      end
    else
      if not IsReady(_W) then
        if(GetDistance(target) <= self.Q.range and menu.harass.useQ:Value()   and IsReady(_Q))then
          self:CastQ(target)
        end
      end
    end
    if(menu.harass.useE:Value()  and IsReady(_E))then
      self:CastE()
    end

  end
  function Zed:LaneClear()
    if not ValidTarget(ClosestMinion(GetOrigin(myHero), MINION_ENEMY),  1000) then return end
 for i, minion in pairs(minionManager.objects) do
                      if ValidTarget(minion, 1000)  and GetTeam(minion) == MINION_ENEMY then
                         if  not Wpos~= nil then
                        if MinionsAround(myHero, 290, MINION_ENEMY) >= menu.farm.laneclear.ecount:Value() then
                        if menu.farm.laneclear.useE:Value() and ( myHero.mana / myHero.maxMana >= menu.farm.laneclear.EMana:Value() /100 )  then
                             CastSpell(_E)
                        end
                      end
                    elseif Wpos~= nil then
 if MinionsAround(Wpos, 290, MINION_ENEMY) >= menu.farm.laneclear.ecount:Value() then
                        if menu.farm.laneclear.useE:Value() and ( myHero.mana / myHero.maxMana >= menu.farm.laneclear.EMana:Value() /100 )  then
                             CastSpell(_E)
                        end
                      end
                    end
                    if (myHero.mana / myHero.maxMana >=  menu.farm.laneclear.WMana:Value() /100 ) then
                      if IsReady(_W) then
                        if  menu.farm.laneclear.useW:Value()   then
                           local Wposition =   Vector(minion)
                          self:CastW( Wposition) 
                          end
                        end
                      end
                               end
                  end
                  if IsReady(_Q) then
                    if (myHero.mana / myHero.maxMana >= menu.farm.laneclear.QMana:Value() /100 ) then
                      local NumberOfHits = menu.farm.laneclear.qcount:Value()
                        if menu.Keys.laneclearkey:Value()  and menu.farm.laneclear.useQ:Value()  then
                          local BestPos, BestHit = GetLineFarmPosition(self.Q.range, self.Q.width, MINION_ENEMY)
                          if BestPos  and BestHit >= NumberOfHits then
                            CastSkillShot(_Q, BestPos)
                          end
                        end
                      end
                    end
                  end
function Zed:LastHit()
  for _, target in pairs(minionManager.objects) do
  if GetTeam(target) == MINION_ENEMY then
   local QPred = GetPrediction(target, self.Q)
   if QPred:mCollision(1) then
    qdamage123 =self:GetQ2Dmg(target)
  else
    qdamage123 =self:GetQDmg(target)
  end
end
end
for _, target in pairs(minionManager.objects) do
  if GetTeam(target) == MINION_ENEMY then
    if IsObjectAlive(target) then
      if menu.farm.lasthit.lasthitlogic:Value() == 1 then
        if(IsReady(_Q) and menu.farm.lasthit.useQ:Value() and ValidTarget(target,900)   and qdamage123 >= GetCurrentHP(target)) then
          self:CastQ(target)
        end
        local Edamage = self:GetEDmg(target)
        if(IsReady(_E)and menu.farm.lasthit.useE:Value() and  ValidTarget(target,290) and Edamage >= GetCurrentHP(target)) then
   CastSpell(_E)
        end
      end
    end
  end
end
end
function Zed:JungleClear()
      if not ValidTarget(ClosestMinion(GetOrigin(myHero), MINION_JUNGLE),  1000) then return end
 for i, minion in pairs(minionManager.objects) do
                      if ValidTarget(minion, 1000) and minion ~= nil and GetTeam(minion) == MINION_JUNGLE then
                        if menu.farm.jungleclear.useE:Value() and ( myHero.mana / myHero.maxMana >= menu.farm.jungleclear.EMana:Value() /100 ) and GetDistance(minion) <= 290 then
                             CastSpell(_E)
                        end
                    if (myHero.mana / myHero.maxMana >=  menu.farm.jungleclear.WMana:Value() /100 ) then
                      if IsReady(_W) then
                        if  menu.farm.jungleclear.useW:Value()   then
                           local Wposition =   Vector(minion)
                       self:CastW( Wposition) 
                          end
                        end
                      end
                    if (myHero.mana / myHero.maxMana >= menu.farm.jungleclear.QMana:Value() /100 ) then
                      local NumberOfHits = menu.farm.laneclear.qcount:Value()
                      if IsReady(_Q) then
                        if menu.Keys.laneclearkey:Value()  and menu.farm.jungleclear.useQ:Value()  then
                          local BestPos, BestHit = GetLineFarmPosition(self.Q.range, self.Q.width, MINION_JUNGLE)
                          if BestPos  and BestHit >= 1 then
                            CastSkillShot(_Q, BestPos)
                          end
                        end
                      end
                    end
                  end
         end
                  end

  function Zed:Combo()

    if  Rpos~= nil and target~= nil then
      if  menu.combo.rlogic:Value() == 1 then
        Wcastpos = (Vector(target)+ (Vector(target)  - Rpos):normalized() * 600)
      elseif menu.combo.rlogic:Value() == 2 then
        Wcastpos = (Vector(target)+ (Vector(target)  - Rpos):normalized() * 350):perpendicular()
      elseif menu.combo.rlogic:Value() == 3 then
        Wcastpos = mousePos
      end
    end
    if IsReady(_R) then
      if(GetDistance(target) <= 615 and menu.combo.useR:Value())then
        self:CastR(target)
      end
    end

    if self:buffcheck()== true then
      if(GetDistance(target) <= self.W.range and menu.combo.useW:Value()  and IsReady(_W))then
        if  Rpos~= nil and target~= nil then
          DelayAction(function ()  self:CastW(Wcastpos) end, 0.2)
        end
      end
    elseif self:buffcheck()== false then
      if(GetDistance(target) <= self.W.range and menu.combo.useW:Value() and  IsReady(_W))then
                 if not menu.combo.secondw:Value() then
                          local Wposition =   GetOrigin(myHero) + (Vector(target) - GetOrigin(myHero)):normalized() * 700
          DelayAction(function ()  self:CastW(Wposition) end, 0.21)
        elseif menu.combo.secondw:Value() then
           DelayAction(function ()    CastSkillShot(_W, target) end, 0.21)
         end
      end
    end

    if  Wpos~= nil and target~= nil then
      if(GetDistance(target) <= self.Q.range and menu.combo.useQ:Value()   and IsReady(_Q))then
        self:CastWQ(target)
      end
    else
      if not IsReady(_W) then
        if(GetDistance(target) <= self.Q.range and menu.combo.useQ:Value()   and IsReady(_Q))then
          self:CastQ(target)
        end
      end
    end

    if(menu.combo.useE:Value()  and IsReady(_E))then
      self:CastE()
    end
    if(menu.combo.useI:Value() and menu.Keys.combokey:Value()  )then
      for _, unit in pairs(GetEnemyHeroes()) do
        local dmgI =(50+ ((myHero.level)*20))
        local health=unit.health
        if(health<dmgI and menu.combo.useI:Value() and GetDistance(unit)<600)then
          self:CastI(unit)
        end
      end
    end

 if IsReady(_W) then
  if menu.combo.wgap:Value() then
   if not IsInDistance(target,850) and  ValidTarget(target,1250)  and menu.combo.useW:Value() then
     local Wposition =   GetOrigin(myHero) + (Vector(target) - GetOrigin(myHero)):normalized() * 700 
       CastSkillShot(_W, Wposition)
       wgapclose = true
       DelayAction(function ()  wgapclose = false end, 5)
      end
    end
    end

if  menu.item.yahu.yahug:Value() then
  if Yahu and IsReady(Yahu) and IsInDistance(target, menu.item.yahu.yahud:Value()) then
    if  wgapclose  then
     DelayAction(function ()CastTargetSpell(target, Yahu)end, 0.35)
end
end
end

if    menu.combo.turnback.swaphp:Value()  then
  if  (myHero.health / myHero.maxHealth <=  menu.combo.turnback.currenthp:Value() /100 ) then
  if (IsInDistance(target,900)  and menu.combo.useW:Value()  and IsReady(_W))then
    self:CastW2(myHero.pos)
        end
      end
    end
  end
  function Zed:comboitems()
        if menu.combo.useitem:Value() then
 if IsReady(_R)  then
    if    Wpos ~= nil and Rpos ~= nil and  GetCastName(myHero,_R)  == "zedr2" then
if  menu.item.bg.usebg:Value()   then
if Blg and IsReady(Blg) and ValidTarget(target, 550 ) then
     DelayAction(function ()CastTargetSpell(target, Blg)end, 0.35)
end
end

if  menu.item.yahu.yahuc:Value()   then
if Yahu and IsReady(Yahu) and ValidTarget(target, 550 ) then
     DelayAction(function ()CastTargetSpell(target, Yahu)end, 0.35)
end
end

if menu.item.tiamat.usetiac:Value()  then
if Tia and IsReady(Tia) and ValidTarget(target, 300) and GetDistance(target) <= 300 then
     DelayAction(function ()CastSpell(Tia)end, 0.35)
end
end

if menu.item.Rhydra.userhc:Value() then
if Rhyd and IsReady(Rhyd) and ValidTarget(target, 300) and GetDistance(target) <= 300 then
     DelayAction(function ()CastSpell(Rhyd)end, 0.35)
end
end

if menu.item.thydra.useth:Value() then
if Thyd and IsReady(Thyd) and ValidTarget(target, 300) and GetDistance(target) <= 300 then
    DelayAction(function () CastSpell(Thyd)end, 0.35)
end
end


if menu.item.btk.usebtk:Value()  then
if Btk and IsReady(Btk) and ValidTarget(target, 550 ) then
    DelayAction(function () CastTargetSpell(target, Btk)end, 0.35)
end
end


if menu.item.randuin.userand:Value() then
if Rand and IsReady(Rand) and EnemiesAround(myHero, 450 )>= menu.item.randuin.minrand:Value() then
    DelayAction(function () CastSpell(Rand)end, 0.35)
end
end
end
end
end
if not IsReady(_R) then
if  menu.item.bg.usebg:Value()  then
if Blg and IsReady(Blg) and ValidTarget(target, 550 ) then
  DelayAction(function () CastTargetSpell(target, Blg)end, 0.35)
end
end

if  menu.item.yahu.yahuc:Value()   then
if Yahu and IsReady(Yahu) and ValidTarget(target, 550 ) then
     DelayAction(function ()CastTargetSpell(target, Yahu)end, 0.35)
end
end

if menu.item.tiamat.usetiac:Value()  then
if Tia and IsReady(Tia) and ValidTarget(target, 300) and GetDistance(target) <= 300 then
   DelayAction(function () CastSpell(Tia)end, 0.35)
end
end

if menu.item.Rhydra.userhc:Value()  then
if Rhyd and IsReady(Rhyd) and ValidTarget(target, 300) and GetDistance(target) <= 300 then
  DelayAction(function () CastSpell(Rhyd)end, 0.35)
end
end

if menu.item.thydra.useth:Value()  then
if Thyd and IsReady(Thyd) and ValidTarget(target, 300) and GetDistance(target) <= 300 then
  DelayAction(function ()CastSpell(Thyd)end, 0.35)
end
end


if menu.item.btk.usebtk:Value()   then
if Btk and IsReady(Btk) and ValidTarget(target, 550 ) then
   DelayAction(function ()CastTargetSpell(target, Btk)end, 0.35)
end
end


if menu.item.randuin.userand:Value()  then
if Rand and IsReady(Rand) and EnemiesAround(myHero, 450 )>= menu.item.randuin.minrand:Value() then
   DelayAction(function ()CastSpell(Rand)end, 0.35)
end
end
end
end
function Zed:clearitems()
if menu.item.tiamat.usetiacl:Value() and ( menu.Keys.laneclearkey:Value() or menu.Keys.jungleclearkey:Value() ) then
if Tia and IsReady(Tia) then
  if menu.item.tiamat.tiamatlogic:Value() == 1 and MinionsAround(myHero, 400, MINION_ENEMY) >=1 then
    CastSpell(Tia)
  elseif menu.item.tiamat.tiamatlogic:Value() == 2 then
    if MinionsAround(myHero, 400, MINION_ENEMY) >=menu.item.tiamat.mintia:Value() then
      CastSpell(Tia)
    end
  end
end
end

if menu.item.Rhydra.userhcl:Value() and ( menu.Keys.laneclearkey:Value() or menu.Keys.jungleclearkey:Value() ) then
if Rhyd and IsReady(Rhyd) then
  if menu.item.Rhydra.Rhydralogic:Value() == 1 and MinionsAround(myHero, 400, MINION_ENEMY) >=1  then
    CastSpell(Rhyd)
  elseif menu.item.Rhydra.Rhydralogic:Value() == 2 then
    if MinionsAround(myHero, 400 , MINION_ENEMY) >=menu.item.Rhydra.minrhydra:Value() then
      CastSpell(Rhyd)
    end
  end
end
end

if menu.item.thydra.usethl:Value() and ( menu.Keys.laneclearkey:Value() or menu.Keys.jungleclearkey:Value() ) then
if Thyd and IsReady(Thyd) then
  if menu.item.thydra.Thydralogic:Value() == 1 and MinionsAround(myHero, 400, MINION_ENEMY) >=1  then
    CastSpell(Thyd)
  elseif menu.item.thydra.Thydralogic:Value() == 2 then
    if MinionsAround(myHero, 400, MINION_ENEMY) >=menu.item.thydra.minthydra:Value() then
      CastSpell(Thyd)
    end
  end
end
end

end
  function  Zed:ProcessSpell(unit, spell)
    if unit == myHero then
      if unit and spell then
        if spell.name:lower():find("zedw") then
          Wpos = Vector(spell.endPos)
          wdt = 5
          Wdmgp = true
            startTime = os.clock() + 5
        elseif spell.name:lower():find("zedw2") then
          Wpos = Vector(spell.startPos)
        end

        if spell.name:lower():find("zedr") then
          Rpos = Vector(spell.startPos)
          rdt = 7.5
  Rdmgp = true
  startTimer = os.clock() + 7.5
        elseif spell.name:lower():find("zedr2") then
          Rpos = GetOrigin(myHero)
        end
      end
    end
    local R = GetTickCount()
    if (GR + 10) < R then
      if rdt == 7.5 then
        DelayAction(function()
        rdt = nil
        Rpos = nil
        Rdmgp = false
        startTimer = 0
        end, rdt)
      end
      GR = R
    end

    local W = GetTickCount()
    if (GW + 10) < W then
      if wdt == 5 then
        DelayAction(function()
        wdt = nil
        Wpos = nil
           Wdmgp = false
           startTime = 0
        end, wdt)
      end
      GW = W
    end
  end
  function Zed:CastQ(unit)
    if menu.pred.selectpred:Value() == 1 then
      local QPred = GetPrediction(unit, self.Q)
      if IsReady(_Q) then
        if QPred  and QPred.hitChance >= (menu.pred.hcgeneral.hcop.hcopq:Value()/100) then
          CastSkillShot(_Q, QPred.castPos)
        end
      end
    elseif menu.pred.selectpred:Value() == 2 then
        local HitChance, y = qSpell:Predict(unit)
        if IsReady(_Q) and HitChance >= 3 then
          CastSkillShot(_Q, y.x, y.y, y.z)
        end
    elseif menu.pred.selectpred:Value() == 3 then
      local qPred = GetPredictionForPlayer(myHeroPos(), unit, GetMoveSpeed(unit), 1700, 250, 900, 50, false, true)
      if IsReady(_Q) and qPred.HitChance == 1 then
        CastSkillShot(_Q, qPred.PredPos.x, qPred.PredPos.y, qPred.PredPos.z)
      end
    end
  end
  function Zed:CastWQ(unit)
    if Wpos and Wpos ~=nil  then
      if menu.pred.selectpred:Value() == 1 then
        local QPred = GetPrediction(unit, self.Q , Wpos)
        local QPred2 = GetPrediction(unit, self.Q )
        if IsReady(_Q) then
          if QPred  and QPred.hitChance >= (menu.pred.hcgeneral.hcop.hcopq:Value()/100) and QPred2 and QPred2.hitChance >= (menu.pred.hcgeneral.hcop.hcopq:Value()/100)  then
            CastSkillShot(_Q, QPred.castPos)
          end
        end
      elseif menu.pred.selectpred:Value() == 2 then
          local HitChance, y = qSpell:Predict(unit)
          if IsReady(_Q) and HitChance >= 3 then
            CastSkillShot(_Q, y.x, y.y, y.z)
          end
      elseif menu.pred.selectpred:Value() == 3 then
        local qPred = GetPredictionForPlayer(Wpos, unit, GetMoveSpeed(unit), 1700, 250, 900, 50, false, true)
        if IsReady(_Q) and qPred.HitChance == 1 then
          CastSkillShot(_Q, qPred.PredPos.x, qPred.PredPos.y, qPred.PredPos.z)
        end
      end
    end
  end
  function Zed:CastRQ(unit)
    if Rpos and Rpos ~=nil  then
      if menu.pred.selectpred:Value() == 1 then
        local QPred = GetPrediction(unit, self.Q, Rpos)
        if IsReady(_Q) then
          if QPred  and QPred.hitChance >= (menu.pred.hcgeneral.hcop.hcopq:Value()/100) then
            CastSkillShot(_Q, QPred.castPos)
          end
        end
      elseif menu.pred.selectpred:Value() == 2 then
          local HitChance, y = qSpell:Predict(unit)
          if IsReady(_Q) and HitChance >= 3 then
            CastSkillShot(_Q, y.x, y.y, y.z)
          end
      elseif menu.pred.selectpred:Value() == 3 then
        local qPred = GetPredictionForPlayer(Rpos, unit, GetMoveSpeed(unit), 1700, 250, 900, 50, false, true)
        if IsReady(_Q) and qPred.HitChance == 1 then
          CastSkillShot(_Q, qPred.PredPos.x, qPred.PredPos.y, qPred.PredPos.z)
        end
      end
    end
  end
  function Zed:CastW( pos)
    if  GetCastName(myHero,_W)  == "ZedW2" then return end
    if IsReady(_W) then
      local Ticker = GetTickCount()
      if (global_ticks + 6000) < Ticker then
        CastSkillShot(_W, pos)
        global_ticks = Ticker
        DelayAction(function()   CastSkillShot(_W, pos) end, 6)
      end
    end
  end
  function Zed:CastW2( pos)
    if GetCastName(myHero,_W)  == "ZedW2" then
      if IsReady(_W) then
        CastSkillShot(_W, pos)
      end
    end
  end
  function Zed:CastE()
    if IsReady(_E) then
      if Rpos and  Rpos ~=nil  then
        if GetDistance(Rpos, target) <= self.E.range then
          CastSpell(_E)
        end
      end
    end
    if IsReady(_E) then
      if Wpos and Wpos ~=nil  then
        if GetDistance(Wpos, target) <= self.E.range then
          CastSpell(_E)
        end
      end
    end
    if IsReady(_E) then
      if GetDistance(target) <= self.E.range then
        CastSpell(_E)
      end
    end
  end
  function Zed:CastR(unit)
    if GetCastName(myHero,_R)  == "ZedR" then
      if IsReady(_R) then
        CastTargetSpell(unit, _R)
      end
    end
  end
  function Zed:CastR2(unit)
    if GetCastName(myHero,_R)  == "ZedR2" then
      if IsReady(_R) then
        CastTargetSpell(unit, _R)
      end
    end
  end
  function Zed:CastI(unit)
    if Ignite then
      if IsReady(Ignite) then
        CastTargetSpell(unit, Ignite)
      end
    end
  end
  function Zed:onload()
    findorb()
  end
  function Zed:GetQ2Dmg(target)
    if GetCastLevel(myHero, _Q)< 1 then
                return 0
              end
              if IsReady(_Q) then
                local FinalDamage = (17.5 + (GetCastLevel(myHero, _Q)* 20) +GetBonusDmg(myHero)*0.5)
                return CalcDamage(myHero,target, FinalDamage,0)
              else
                return 0
              end
            end
  function Zed:GetQDmg(target)
    if GetCastLevel(myHero, _Q)< 1 then
      return 0
    end
    if IsReady(_Q) then
      if Wdmgp then
        local FinalDamage = (35 + (GetCastLevel(myHero, _Q)* 40) +  GetBonusDmg(myHero)) + (17.5 + (GetCastLevel(myHero, _Q)* 20) +GetBonusDmg(myHero)*0.5)
        return CalcDamage(myHero,target, FinalDamage,0)
      elseif Rdmgp then
        local FinalDamage = (35 + (GetCastLevel(myHero, _Q)* 40) +  GetBonusDmg(myHero)) + (17.5 + (GetCastLevel(myHero, _Q)* 20) +GetBonusDmg(myHero)*0.5)
        return CalcDamage(myHero,target, FinalDamage,0)
      elseif (Wdmgp and Rdmgp) then
        local FinalDamage = (35 + (GetCastLevel(myHero, _Q)* 40) +  GetBonusDmg(myHero)) + (17.5 + (GetCastLevel(myHero, _Q)* 20) +GetBonusDmg(myHero)*0.5)*2
        return CalcDamage(myHero,target, FinalDamage,0)
      elseif not (Wdmgp and Rdmgp) then
        local FinalDamage = (35 + (GetCastLevel(myHero, _Q)* 40) +  GetBonusDmg(myHero))
        return CalcDamage(myHero,target, FinalDamage,0)
          end
      else
        return 0
      end
    end
    function Zed:GetEDmg(target)
      if GetCastLevel(myHero, _E) < 1 then
        return 0
      end
      if IsReady(_E) then
        local FinalDamage = ( 30+ (GetCastLevel(myHero, _E) * 30) +  (GetBonusDmg(myHero))*0.8)
        return CalcDamage(myHero,target,FinalDamage, 0)
      else
        return 0
      end
    end
    local ratio = {0.20, 0.225, 0.25, 0.275, 0.30}
    function Zed:GetRDmg(target)
  local rlvl = GetCastLevel(myHero, _R)
      if GetCastLevel(myHero, _R) < 1 then
        return 0
      end
      if IsReady(_R) then
        local edmg =self:GetEDmg(target)
        local qdmg =self:GetQDmg(target)
        local dmggive = edmg + qdmg
        local FinalDamage = (myHero.totalDamage) + (dmggive * ratio[rlvl])
        return CalcDamage(myHero,target, FinalDamage,0)
      else
        return 0
      end
    end
function Zed:GetMyDmg(target)
if IsReady(_Q) and IsReady(_R) and IsReady(_E) then
  return self:GetQDmg(target) + self:GetRDmg(target) + self:GetEDmg(target)
elseif IsReady(_Q)  and IsReady(_E) then
  return self:GetQDmg(target) + self:GetEDmg(target)
elseif IsReady(_R) and IsReady(_E) then
  return self:GetRDmg(target) +self:GetEDmg(target)
elseif IsReady(_Q) then
  return self:GetQDmg(target)
elseif IsReady(_E) then
  return self:GetEDmg(target)
elseif IsReady(_R) then
  return self:GetRDmg(target)
elseif IsReady(_Q) and IsReady(_R) then
  return self:GetQDmg(target) + self:GetRDmg(target)
else
  return 0
end
end
function Zed:GetDraws(target)
local qdamage = self:GetQDmg(target)
local edamage = self:GetEDmg(target)
local rdamage = self:GetRDmg(target)
local Idmg=(50+ ((myHero.level)*20))

if qdamage >target.health then
  return 'Q', GoS.White
elseif qdamage+ Idmg>target.health then
  return 'Q + Ignite', GoS.White
elseif edamage >target.health then
  return 'E', GoS.White
elseif edamage + Idmg>target.health then
  return 'E + Ignite', GoS.White
elseif rdamage  >target.health then
  return 'R', GoS.White
elseif rdamage + Idmg>target.health then
  return 'R + Ignite', GoS.White
elseif rdamage +edamage  >target.health then
  return 'R + E',GoS.White
elseif rdamage +edamage+ Idmg>target.health then
  return 'R + E + Ignite',GoS.White
elseif qdamage+edamage>target.health then
  return 'Q + E',GoS.White
elseif qdamage+rdamage >target.health then
  return 'Q + R',GoS.White
elseif qdamage+edamage+ Idmg>target.health then
  return 'Q + E + Ignite',GoS.White
elseif qdamage+rdamage+ Idmg>target.health then
  return 'Q + R + Ignite',GoS.White
elseif qdamage+edamage+rdamage >target.health then
  return 'Kill with full combo',GoS.White
elseif qdamage+edamage+rdamage+ Idmg>target.health then
  return 'Full Combo + Ignite',GoS.White
else
  return "Cant Kill yet", GoS.White
end
end
    function Zed:killsteal()
      for _, unit in pairs(GetEnemyHeroes()) do
        local health = GetCurrentHP(unit)
        local dmgE = self:GetEDmg(unit)
        if(GetDistance(target) <= self.E.range and  IsReady(_E) and not menu.Keys.combokey:Value()   and health<dmgE and menu.killsteal.useE:Value()   and menu.killsteal.ks:Value())then
          self:CastE(unit)
        end
        local dmgQ = self:GetQDmg(unit)
        if(GetDistance(target) <= self.Q.range and  IsReady(_Q) and not menu.Keys.combokey:Value()   and health<dmgQ and menu.killsteal.useQ:Value() and menu.killsteal.ks:Value() )then
          self:CastQ(unit)
        end
        local dmgI =(50+ ((myHero.level)*20))
        if(health<dmgI and menu.killsteal.useI:Value() and menu.killsteal.ks:Value() and GetDistance(unit)<600)then
          self:CastI(unit)
        end
      end
    end
    function Zed:LoadMenu()
      menu=MenuConfig("menu",""..Scriptname.." [" .. myHero.charName.."]" )
      menu:Menu("combo",loc_eng[1])
      menu.combo:Menu( "turnback","W/R Turn back settings")
      menu.combo.turnback:Boolean("targetdied", "Turn Back if target died.", false)
      menu.combo.turnback:Boolean("swaphp", "Swap W/R if my hp % <=", false)
      menu.combo.turnback:Slider("currenthp","Swap W/R if my hp % <= "  , 10, 10, 100, 1)
      menu.combo:Boolean("useQ", loc_eng[2], true)
      menu.combo:Boolean("useW", loc_eng[3], true)
      menu.combo:Boolean("useE", loc_eng[4], true)
      menu.combo:Boolean("useR", loc_eng[5], true)
      menu.combo:DropDown("rlogic", "Combo Logic",   1, {"Use Line Mode", "Use Rectangle Mode", "Use Mouse Position"})
      menu.combo:Boolean("useI", loc_eng[6], true)
      menu.combo:Info("blank", ""   )
      menu.combo:Info("blank", "Extra Settings"   )
       menu.combo:Boolean("secondw", "Use second W to Chase", false)
      menu.combo:Boolean("useitem", "Use Items After R", true)
      menu.combo:Boolean("wgap", "Use W to Gap Close", false)
      menu.combo:Slider("Mana","Energy Manager %"   , 10, 10, 100, 1)

      menu:Menu( "harass",loc_eng[9])
      menu.harass:Menu( "autoharass","Auto Harass Settings")
      menu.harass.autoharass:Boolean("use", "Use Special Auto Harass", false)
      menu.harass.autoharass:DropDown("harasslogic", "Special harass Mode",   1, {"QW", "QWE", "WE"})
      menu.harass.autoharass:Boolean("useQ", "Use Auto Q Harass", false)
      menu.harass.autoharass:Boolean("useE", "Use Auto E Harass", false)
      menu.harass:Boolean("useQ", loc_eng[10], true)
      menu.harass:Boolean("useW", loc_eng[11], true)
      menu.harass:Boolean("useE", loc_eng[12], true)
      menu.harass:Slider("Mana","Energy Manager %"  , 10, 10, 100, 1)

      menu:Menu( "farm",loc_eng[14])

      menu.farm:Menu("laneclear",loc_eng[15])
      menu.farm.laneclear:Boolean("useQ",loc_eng[16], true)
      menu.farm.laneclear:Slider("qcount",loc_eng[180]   , 2, 1, 10, 1)
      menu.farm.laneclear:Boolean("useW",loc_eng[17], false)
      menu.farm.laneclear:Boolean("useE",loc_eng[18], false)
      menu.farm.laneclear:Slider("ecount",loc_eng[182]   , 2, 1, 10, 1)
      menu.farm.laneclear:Info("blank", ""   )
      menu.farm.laneclear:Info("blank", ""   )
      menu.farm.laneclear:Info("info2", "           [Energy Manager]"  )
      menu.farm.laneclear:Slider("QMana","Q Skill Energy Manager  %"   , 30, 10, 100, 1)
      menu.farm.laneclear:Slider("WMana","W Skill Energy Manager  %"    , 30, 10, 100, 1)
      menu.farm.laneclear:Slider("EMana","E Skill Energy Manager  %"   , 30, 10, 100, 1)

      menu.farm:Menu("jungleclear",loc_eng[20])
      menu.farm.jungleclear:Boolean("useQ",loc_eng[21], true)
      menu.farm.jungleclear:Boolean("useW",loc_eng[22], true)
      menu.farm.jungleclear:Boolean("useE",loc_eng[23], true)
      menu.farm.jungleclear:Info("blank", ""   )
      menu.farm.jungleclear:Info("blank", ""   )
      menu.farm.jungleclear:Info("info2", "           [Energy Manager]"  )
      menu.farm.jungleclear:Slider("QMana","Q Skill Energy Manager  %"  , 30, 10, 100, 1)
      menu.farm.jungleclear:Slider("WMana","W Skill Energy Manager  %"    , 30, 10, 100, 1)
      menu.farm.jungleclear:Slider("EMana","E Skill Energy Manager  %"    , 30, 10, 100, 1)


      menu.farm:Menu("lasthit",loc_eng[25])
      menu.farm.lasthit:Boolean("autolasthit",loc_eng[189], false)
      menu.farm.lasthit:Boolean("useQ",loc_eng[26], true)
      menu.farm.lasthit:Boolean("useE",loc_eng[28], true)
      menu.farm.lasthit:DropDown("lasthitlogic",loc_eng[191],   1, {loc_eng[172],loc_eng[174]})
      menu.farm.lasthit:Info("blank", ""   )
      menu.farm.lasthit:Info("blank", ""   )
      menu.farm.lasthit:Info("info2", "           [Energy Manager]"   )
      menu.farm.lasthit:Slider("QMana","Q Skill Energy Manager  %"   , 30, 10, 100, 1)
      menu.farm.lasthit:Slider("EMana","E Skill Energy Manager  %"   , 30, 10, 100, 1)

      menu:Menu("escape",loc_eng[30])
      menu.escape:Boolean("useW",loc_eng[32],true)

      menu:Menu("killsteal",loc_eng[35])
      menu.killsteal:Boolean("ks",loc_eng[36], true)
      menu.killsteal:Boolean("useQ", loc_eng[37], true)
      menu.killsteal:Boolean("useE", loc_eng[39], true)
      menu.killsteal:Boolean("useI", loc_eng[41], true)

      menu:Menu( "item",loc_eng[42])
      menu.item:Menu( "autopot",loc_eng[192])
      menu.item.autopot:Boolean("enableautopothp", loc_eng[193], false)
      menu.item.autopot:Slider("autopothp", loc_eng[194] , 10, 0, 100, 1)
      menu.item:Menu( "tiamat","Tiamat Settings")
      menu.item.tiamat:Boolean("usetiac", "Use Tiamat in combo",  false)
      menu.item.tiamat:Boolean("usetiacl", "Use Tiamat in clear",  false)
      menu.item.tiamat:DropDown("tiamatlogic","Tiamat logic for clear",   1, {"Always","Depends on Minion Count"})
      menu.item.tiamat:Slider("mintia","Minimum Minion to Tiamat"   , 1, 1, 6, 1)
      menu.item:Menu( "Rhydra","Ravenous Hydra Settings")
      menu.item.Rhydra:Boolean("userhc", "Use Ravenous Hydra in combo ",  false)
      menu.item.Rhydra:Boolean("userhcl", "Use Ravenous Hydra in clear ",  false)
      menu.item.Rhydra:DropDown("Rhydralogic","Ravenous Hydra logic for clear",   1, {"Always","Depends on Minion Count"})
      menu.item.Rhydra:Slider("minrhydra","Minimum Minion to Ravenous Hydra"   , 1, 1, 6, 1)
      menu.item:Menu( "thydra","Titanic Hydra Settings")
      menu.item.thydra:Boolean("useth", "Use Titanic Hydra in combo",  false)
      menu.item.thydra:Boolean("usethl", "Use Titanic Hydra in clear",  false)
      menu.item.thydra:DropDown("Thydralogic","Titanic Hydra logic for clear",   1, {"Always","Depends on Minion Count"})
      menu.item.thydra:Slider("minthydra","Minimum Minion to Titanic Hydra"   , 1, 1, 6, 1)
      menu.item:Menu( "bg","Bilgewater Settings")
      menu.item.bg:Boolean("usebg", loc_eng[46],  false)
             menu.item:Menu( "yahu","Youmuu's Ghostblade Settings")
      menu.item.yahu:Boolean("yahuc", "Use in combo" ,  false)
       menu.item.yahu:Boolean("yahug", "Use after gapclose" ,  false)
              menu.item.yahu:Slider("yahud","Minimum distance ( Gap close )"   , 550, 100, 1000, 1)
      menu.item:Menu( "btk","Blade of the Ruined King Settings")
      menu.item.btk:Boolean("usebtk", "Use Blade of the Ruined King",  false)
      menu.item:Menu( "randuin","Randuin's Omen Settings")
      menu.item.randuin:Boolean("userand", "Use Randuin's Omen",  false)
      menu.item.randuin:Slider("minrand","Minimum Enemy to Randuin's Omen"   , 1, 1, 5, 1)
      menu.item:Menu( "qss","QSS settings")
      menu.item.qss:Boolean("useqss", "Use QSS",  false)

      menu:Menu( "misc",loc_eng[92])
      --menu.misc:Menu( "autowall","[" .. myHero.charName.. "] - Evade Settings")
     -- menu.misc:Menu( "antigap","[" .. myHero.charName.. "] - Anti Gap Closer Settings")
      --menu.misc.antigap:Info("info3", loc_eng[98] )
      menu.misc:Menu( "turretdive","[" .. myHero.charName.. "] - Turret Dive Settings")
      menu.misc.turretdive:Boolean("use", "Use Turret Dive Settings", false)
      menu.misc.turretdive:DropDown("turretdivelogic","Turret Dive Mode",   1, {"Normal Mode","Krystra Mode"})
      menu.misc.turretdive:Boolean("Drawturret", "Draw Turret Range", false)
      menu.misc.turretdive:Info("blank", ""   )
      menu.misc.turretdive:Info("blank", "Normal Mode Settings >"   )
      menu.misc.turretdive:Slider("normalmode", "Minimum Number of Ally Minions" , 3, 1, 8, 1)
      menu.misc.turretdive:Slider("health", "Do not dive if my health > % ", 30, 0, 100, 1)
      menu.misc.turretdive:Info("blank", ""   )
      menu.misc.turretdive:Info("blank", "Krystra Mode Settings >"   )
      menu.misc.turretdive:Slider("krystramode", "Minimum Number of Ally Minions" , 3, 1, 8, 1)
      menu.misc.turretdive:Slider("krystramode2", "Minimum Number of Ally Champions" , 2, 1, 4, 1)
      menu.misc.turretdive:Slider("health1", "Do not dive if my health > % ", 30, 0, 100, 1)
      menu.misc:Menu( "skinhack","[" .. myHero.charName.. "] - Skinhack Settings")
      menu.misc.skinhack:Boolean("useskin",loc_eng[54], false)
      menu.misc.skinhack:DropDown('selected' .. myHero.charName .. 'Skin', loc_eng[57]  ,  1, skinMeta[myHero.charName])
      menu.misc:Menu( "autolevel","[" .. myHero.charName.. "] - AutoLevel Settings")
      menu.misc.autolevel:Boolean("uselevel",loc_eng[51], false)
      menu.misc.autolevel:DropDown("logic", loc_eng[52] , 7, {loc_eng[58], loc_eng[59],loc_eng[60],loc_eng[61],loc_eng[62], loc_eng[63], loc_eng[64]  })
      menu.misc:Menu( "antiafk","[" .. myHero.charName.. "] - AntiAFK Settings")
      menu.misc.antiafk:Boolean("useafk",loc_eng[196], false)

      Clock = os.clock()


      menu:Menu("other",loc_eng[65])
      menu.other:Menu( "circlew","Circle for W Shadow")
      menu.other.circlew:Boolean("enable","Enable", true)
      menu.other.circlew:Boolean("timer","Draw Shadow Time", true)
      menu.other.circlew:ColorPick("Wcolor", "Color",   {255, 255, 255, 255})
      menu.other.circlew:Slider("Wwidth", "Width", 1, 1, 10, 1)
      menu.other:Menu( "circler","Circle for R Shadow")
      menu.other.circler:Boolean("enable","Enable", true)
      menu.other.circler:Boolean("timer","Draw Shadow Time", true)
      menu.other.circler:ColorPick("Wcolor", "Color",   {255, 255, 255, 255})
      menu.other.circler:Slider("Wwidth", "Width", 1, 1, 10, 1)
      menu.other:Menu( "draw",loc_eng[66])
      menu.other.draw:Boolean("qdraw",loc_eng[67], true)
      menu.other.draw:Boolean("wdraw",loc_eng[68], true)
      menu.other.draw:Boolean("edraw",loc_eng[69], true)
      menu.other.draw:Boolean("rdraw",loc_eng[70], true)
      menu.other.draw:Boolean("aadraw",loc_eng[71], false)
      menu.other:Menu( "color", loc_eng[198])
      menu.other.color:ColorPick("Qcolor", loc_eng[199],   {255, 255, 255, 255})
      menu.other.color:ColorPick("Wcolor", loc_eng[200],   {255, 255, 255, 255})
      menu.other.color:ColorPick("Ecolor", loc_eng[201],   {255, 255, 255, 255})
      menu.other.color:ColorPick("Rcolor", loc_eng[202],   {255, 255, 255, 255})
      menu.other.color:ColorPick("AAcolor", loc_eng[204],   {255, 255,0,0})
      menu.other:Boolean("combomode",loc_eng[72], true)
      menu.other:Boolean("damage",loc_eng[214], true)
      menu.other:Boolean("targetcal",loc_eng[76], true)

      menu:Menu("targetsel",loc_eng[77])
      menu.targetsel:Boolean("ts",loc_eng[78], false)


      menu:Menu("orb","Orbwalker Settings")
      menu.orb:Menu( "selectorb","Current Orbwalker :")

      menu:Menu("pred","Prediction Settings")
      menu.pred:DropDown("selectpred","Current Predictions :",   1, {"Open Prediction","IPrediction","Gos Prediction"})
      menu.pred:Menu( "hcgeneral","Hitchance Settings")
      menu.pred.hcgeneral:Menu( "hcop","Open Prediction Hitchance")
      menu.pred.hcgeneral.hcop:Slider("hcopq", "Q Hitchance " , 30, 0, 100, 1)
      menu.pred:Info("blank", "    Currently Open Prediction "   )
      menu.pred:Info("blank", "      is best with this bundle"   )


      menu:Menu( "Keys",loc_eng[79])
      menu.Keys:Info("infoK3", loc_eng[80]   )
      menu.Keys:Key("combokey", loc_eng[81], string.byte(" "))
      menu.Keys:Key("combomode", loc_eng[129],  string.byte("2"))
      menu.Keys:Info("infoK4", loc_eng[82]   )
      menu.Keys:Key("harasskey", loc_eng[83],    string.byte("C"))
      -- menu.Keys:Boolean("harasstoglekey", "Harass Togle Key",, string.byte("T"))
      menu.Keys:Info("infoK5", loc_eng[84]   )
      menu.Keys:Key("lasthitkey",loc_eng[215],    string.byte("X"))
      menu.Keys:Key("laneclearkey", loc_eng[85],    string.byte("V"))
      menu.Keys:Key("jungleclearkey", loc_eng[86],    string.byte("V"))
      --menu.Keys:Boolean("lasthitkey", "Lasthit Key",    string.byte("X"))
      menu.Keys:Info("infoK6", loc_eng[87]   )
      menu.Keys:Key("escapekey", loc_eng[88],    string.byte("Y"))
      menu.Keys:Info("infoK", "Make Sure That Your Orbwalker"   )
      menu.Keys:Info("infoK2", loc_eng[89]   )

      --menu:Boolean("lang", loc_eng[165]    1, {loc_eng[166], loc_eng[167],loc_eng[168]})
      menu:Info("infoK","           "..Scriptname.."" )
      menu:Info("infoK","         Script Version:  "..Version.. "  " )
      menu:Info("infoK","   Script was made by  "..Author.. "" )
      menu:Info("infoK","Leauge Of Legends Version: "..LVersion.. "" )
      menu:Boolean("instruct", loc_eng[216], false)


    end
    function Zed:WndMsg(Msg, Key)
      if menu.Keys.combomode:Value() then
        menu.combo.rlogic:Value((menu.combo.rlogic:Value() + 1))
        menu.Keys.combomode:Value(false)
        if menu.combo.rlogic:Value() > 3 then menu.combo.rlogic:Value(1) end
      end
      if menu.targetsel.ts:Value() then
        if Msg == WM_LBUTTONDOWN then
          local minD = 10
          local starget = nil
          for i, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy) then
              if GetDistance(enemy, mousePos) <= minD or starget == nil then
                minD = GetDistance(enemy, mousePos)
                starget = enemy
              end
            end
          end
          if starget and minD < 150 then
            if self.selectedTar and starget.charName == self.selectedTar.charName then
              self.selectedTar = nil
              print("<font color=\"#FFFFFF\">Target <b>is no loger selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
            else
              self.selectedTar = starget
              print("<font color=\"#FFFFFF\">New target <b>selected.</b>:<font color=\"#D3649F\"><b> "..starget.charName.." </b></font>")
            end
          end
        end
      end
      if Msg == WM_LBUTTONDOWN then
if PopUp1 then
  PopUp1 = false
end
end
    end
 
  if _G[GetObjectName(myHero)] then
    _G[GetObjectName(myHero)]()
    -- DelayAction(function() print("<font color=\"#FF0000\"><b> "..Scriptname.." - </b></font><font color=\"#FFFFFF\"> Skin Hack currently disabled until the next update") end, 14)
  else
    print("<font color=\"#FF0000\"><b> "..Scriptname.." - </b></font><font color=\"#CBF6FF\"> :This champion is not supported. Currently supported champions are: "..list.." " )
    print("<font color=\"#FF0000\"><b> "..Scriptname.." - </b></font><font color=\"#CBF6FF\">Feel free to check my forum topic and ask a new champion or give feedback")
    print("<font color=\"#FF0000\"><b> "..Scriptname.." - </b></font><font color=\"#CBF6FF\">"..link.."")
  end
