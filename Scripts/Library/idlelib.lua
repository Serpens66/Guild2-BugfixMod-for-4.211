-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching
end

-- -----------------------
-- GetActivity
-- The main acivity facor
-- 0 = no activity, 100 = full activity of the sims
-- -----------------------
function GetActivity()
	if not GetSettlement("","MyCity") then
		return 0
	end

	local CityLevel = CityGetLevel("MyCity")
	local res = 0
	
	if CityLevel<=2 then
		res = 100
	elseif CityLevel==3 then
		res = 90
	elseif CityLevel==4 then
		res = 80
	elseif CityLevel==5 then
		res = 70
	else
		res = 60
	end
	if (HasProperty("","SchuldenGeb")) and (res<80) then
		res = 80
	end

	return res
end

-- -----------------------
-- CheckWeather
-- -----------------------
function CheckWeather()
	local RainValue = Weather_GetValue(0)
	local CloudValue = Weather_GetValue(1)
	local WindValue = Weather_GetValue(3)
	
	local Weather = (RainValue*7) + CloudValue + (WindValue*2) --0(good) - 10(bad)
	local Activity = 0
	if Weather <=1  then		--sun is shining, everything is allright
		Activity = 100
	elseif Weather <=3 then	--cloudy sky
		Activity = 70
	elseif Weather <=7 then	--rain or snow
		Activity = 35
	else				--stormy weather, bah
		Activity = 10
	end
	
	if Rand(100) < Activity then
		return true
	else
		return false
	end
end

-- -----------------------
-- Sleep
-- -----------------------
function Sleep(SleepStart, SleepEnd)
	MsgDebugMeasure("Sleeping...")
	if not GetHomeBuilding("", "HomeBuilding") then
		Sleep(Gametime2Realtime(1))
		return false
	end

	if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
		if not f_MoveTo("", "HomeBuilding", GL_MOVESPEED_RUN) then
			Sleep(3)
			StopMeasure()
		end
	end

	if GetLocatorByName("HomeBuilding", "Bed1", "SleepPosition") then
		if not f_BeginUseLocator("", "SleepPosition", GL_STANCE_LAY, true) then
			RemoveAlias("SleepPosition")
			if IsDynastySim("") then
				if GetHPRelative("")<1 then
					GetSettlement("","MyCity")
					if CityGetRandomBuilding("MyCity", GL_BUILDING_CLASS_PUBLIC, 32, -1, -1, FILTER_IGNORE, "Destination") then
						if f_MoveTo("","Destination") then
							MeasureRun("","Destination","Linger",true)
							return
						end
					end
				else
					return
				end
			end
		end
	end
	
	local SleepTime = Gametime2Realtime(EN_RECOVERFACTOR_HOME/60)
	local	ContinueSleeping = true
	SetState("",STATE_SLEEPING,true)
	while ContinueSleeping do
	
		ContinueSleeping = false
		
		Sleep(SleepTime)

		if GetHPRelative("") < 1 then
			ModifyHP("", 1)
			ContinueSleeping = true
		end
		
		local time = math.mod(GetGametime(),24)
		if time>SleepStart or time<SleepEnd then
			ContinueSleeping = true
		end
		Sleep(1)
	end
	SetState("",STATE_SLEEPING,false)
	if AliasExists("SleepPosition") then
		f_EndUseLocatorNoWait("", "SleepPosition", GL_STANCE_STAND)
		RemoveAlias("SleepPosition")
	end
end

-- -----------------------
-- ThiefIdle
-- -----------------------
function ThiefIdle(Workbuilding)
	SimGetWorkingPlace("", "WorkingPlace")
	local WhatToDo = Rand(5)
	if WhatToDo == 0 then
		if GetFreeLocatorByName("WorkingPlace", "Chair",1,4, "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_SIT, true) then
				RemoveAlias("ChairPos")
				return
			end
			while true do
				local WhatToDo2 = Rand(4)
				if WhatToDo2 == 0 then
					Sleep(10) 
				elseif WhatToDo2 == 1 then
					return
				elseif WhatToDo2 == 2 then
					PlayAnimation("","sit_talk")
				else
					PlayAnimation("","sit_laugh")					
				end
				Sleep(1)
			end
		end
	elseif WhatToDo == 1 then
		if GetLocatorByName("WorkingPlace", "Chair_Cellwatch", "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_SIT, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation("","sit_laugh")
			Sleep(Rand(12)+1)
		end
	elseif WhatToDo == 2 then
		if GetLocatorByName("WorkingPlace", "Fistfight", "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_STAND, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation("","point_at")
			PlayAnimation("","fistfight_in")
			PlayAnimation("","fistfight_punch_01")
			PlayAnimation("","fistfight_punch_05")
			PlayAnimation("","fistfight_punch_02")
			PlayAnimation("","fistfight_punch_06")
			PlayAnimation("","fistfight_punch_03")
			PlayAnimation("","fistfight_punch_07")
			PlayAnimation("","fistfight_punch_04")
			PlayAnimation("","fistfight_punch_08")
			PlayAnimation("","fistfight_out")
		end
	elseif WhatToDo == 3 then
		if GetLocatorByName("WorkingPlace", "Pickpocket", "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_STAND, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation("","pickpocket")
		end
	else
		if GetLocatorByName("WorkingPlace", "Cell_Outside", "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_STAND, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation("","sentinel_idle")
		end
	end
end

-- -----------------------
-- RobberIdle
-- -----------------------
function RobberIdle(Workbuilding)
	SimGetWorkingPlace("", "WorkingPlace")
	GetLocatorByName("WorkingPlace", "Entry1", "WaitingPos")
	
	if GetDistance("", "WaitingPos") > 115 then
		local dist = Rand(100)+10	
		f_MoveTo("Sim","WaitingPos",GL_MOVESPEED_RUN, dist)
	end

	Sleep(5)
end

-- -----------------------
-- GoHome
-- -----------------------
function GoHome()
	MsgDebugMeasure("Going Home")
	if not GetHomeBuilding("", "HomeBuilding") then
		Sleep(Gametime2Realtime(1))
		return
	end
	
	if SimIsCourting("") and not GetState("",STATE_BLACKDEATH) then
		return
	end

	if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
		if GetImpactValue("","Sickness")>0 then
			f_MoveTo("", "HomeBuilding", GL_MOVESPEED_WALK)
		else
			f_MoveTo("", "HomeBuilding", GL_MOVESPEED_RUN)
		end
	end
	Sleep(Rand(15)+30)
	
	if Rand(300)==37 then
		if BuildingGetLevel("HomeBuilding") < 3 then
			SetState("HomeBuilding",STATE_BURNING,true)
		elseif Rand(100)<10 then
			SetState("HomeBuilding",STATE_BURNING,true)
		end
	end
	
	while GetState("",STATE_BLACKDEATH) do
		Sleep(5)
	end
end

-- -----------------------
-- DoNothing
-- -----------------------
function DoNothing()
	MsgDebugMeasure("I'm really bored")
	local ThingsToDo = Rand(4)
	if ThingsToDo == 0 then
		PlayAnimation("","cogitate")
	elseif ThingsToDo == 1 then
		CarryObject("", "Handheld_Device/ANIM_Pretzel.nif", false)
		PlayAnimationNoWait("","eat_standing")
		Sleep(6)
		CarryObject("","",false)
		Sleep(Rand(5)+3)
	elseif ThingsToDo == 2 then
		CarryObject("", "Handheld_Device/ANIM_beaker.nif", false)
		PlayAnimationNoWait("","use_potion_standing")
		Sleep(6)
		CarryObject("","",false)
		Sleep(Rand(5)+3)
	else
	    if GetInsideBuilding("","drinne") == false then
	        CarryObject("","Handheld_Device/ANIM_besen.nif", false)
	        PlayAnimation("","hoe_in")	
	        for i=0,5 do
		        local waite = PlayAnimationNoWait("","hoe_loop")
		        Sleep(0.5)
		        PlaySound3DVariation("","Locations/herbs",1.0)
		        Sleep(waite-0.5)
	        end
		    PlayAnimation("","hoe_out")
		    CarryObject("","",false)
        end		
	end
	Sleep(Rand(10)+5)
end

-- -----------------------
-- GoToRandomPosition
-- -----------------------
function GoToRandomPosition()
	MsgDebugMeasure("Walking around...")
	local offset 	= math.mod(GetID("Owner"), 30) * 0.1
	local class
	if GetSettlement("", "City") then
		local	RandVal = Rand(7)
		if RandVal<2 then
			class = GL_BUILDING_CLASS_MARKET
		elseif RandVal<4 then
			class = GL_BUILDING_CLASS_PUBLIC
		else
			class = GL_BUILDING_CLASS_WORKSHOP
		end
		
		if CityGetRandomBuilding("City", class, -1, -1, -1, FILTER_IGNORE, "Destination") then
			if GetOutdoorMovePosition("", "Destination", "MoveToPosition") then
				f_MoveTo("","MoveToPosition", GL_MOVESPEED_WALK, 400+offset*15)
			end
		end
	end
end

-- -----------------------
-- ForceAFight
-- -----------------------
function ForceAFight(Enemy)
	if BattleIsFighting(Enemy) then
		return
	end
	MsgDebugMeasure("Force a Fight")
	SimStopMeasure(Enemy)
	StopAnimation(Enemy) 
	MoveStop(Enemy)
	AlignTo("",Enemy)
	AlignTo(Enemy,"")
	Sleep(1)
	PlayAnimationNoWait("","threat")
	PlayAnimation(Enemy,"insult_character")
	SetProperty(Enemy,"Berserker",1)
	SetProperty("","Berserker",1)
	BattleJoin("",Enemy,false,false)
end

-- -----------------------
-- SitDown
-- -----------------------
function SitDown()
	MsgDebugMeasure("Sit down and enjoy the season")
	local season = GetSeason()
	local Distance = Rand(10000)+1000
	if season == EN_SEASON_SPRING or season == EN_SEASON_SUMMER or season == EN_SEASON_AUTUMN then
		if GetSettlement("", "City") then
			if CityGetRandomBuilding("City", GL_BUILDING_CLASS_PUBLIC, 32, -1, -1, FILTER_IGNORE, "Destination") then
				local Stance = 2
				--0=sitground, 1=sitbench, 2=stand
				if GetFreeLocatorByName("Destination","idle_Sit",1,5,"SitPos") then
					f_BeginUseLocator("","SitPos",GL_STANCE_SITBENCH,true)
					Stance = 1
					if GetLocatorByName("Destination","campfire","CampFirePos") then
						if GetImpactValue("Destination","torch")==0 then
							AddImpact("Destination","torch",1,1)
							GfxStartParticle("Campfire","particles/Campfire2.nif","CampFirePos",3)
							--GfxStartParticle("Camplight","Lights/candle_M_01.nif","CampFirePos",6)		
						end
					end
				elseif GetFreeLocatorByName("Destination","idle_SitGround",1,5,"SitPos") then
					Stance = 0
					f_BeginUseLocator("","SitPos",GL_STANCE_SITGROUND,true)
				elseif GetFreeLocatorByName("Destination","idle_Stand",1,5,"SitPos") then
					Stance = 2
					f_BeginUseLocator("","SitPos",GL_STANCE_STAND,true)
				end
				local EndTime = GetGametime()+1
				while GetGametime() < EndTime do				
					if Stance == 1 then
						Sleep(2)
						local AnimTime = 0
						local idx = Rand(3)
						if idx == 0 then
							PlaySound3DVariation("","CharacterFX/male_anger",1)
							PlayAnimation("","bench_sit_offended")
						elseif idx == 1 then
							PlaySound3DVariation("","CharacterFX/male_amazed",1)
							PlayAnimation("","bench_sit_talk_short")
						else
							PlaySound3DVariation("","CharacterFX/male_neutral",1)
							PlayAnimation("","bench_talk")						
						end
					end
					Sleep(Rand(10)+10)
				end
				if GetImpactValue("Destination","torch")==0 then
					GfxStopParticle("Campfire")
					--GfxStopParticle("Camplight")
				end
				
				f_EndUseLocator("","SitPos",GL_STANCE_STAND)
				
				Sleep(6)
			end
		end
	else
		if Rand(100)>50 then
			local FightPartners = Find("", "__F((Object.GetObjectsByRadius(Sim)==2500)AND NOT(Object.HasDynasty()))","FightPartner", -1)
			if FightPartners>0 then
				idlelib_SnowballBattle("FightPartner")
				return
			end
		end
	end
end

-- -----------------------
-- Graveyard
-- -----------------------
function Graveyard()
	MsgDebugMeasure("Cry around at the Graveyard")
	if GetSettlement("", "City") then
		if not CityGetRandomBuilding("City", -1, 98, -1, -1, FILTER_IGNORE, "Destination") then
			return
		end
		if GetState("Destination",2) == true then
		    return
		end
		if GetState("Destination",5) == true then
		    return
		end
		if not f_MoveTo("","Destination", GL_MOVESPEED_RUN, Rand(40)+120) then
		    return
		end
		MoveSetStance("",GL_STANCE_KNEEL)
		Sleep(Rand(10)+5)
		PlayAnimation("","knee_pray")
		Sleep(Rand(12)+6)
		MoveSetStance("",GL_STANCE_STAND)
		SatisfyNeed("",4,0.2)
		if BuildingGetOwner("Destination","Sitzer") then
			CreditMoney("Destination",Rand(5)+1,"tip")
		end
		Sleep(6)
	end
end

-- -----------------------
-- GetCorn
-- -----------------------
function GetCorn()
	MsgDebugMeasure("Get Corn from the farm")
	if GetSettlement("", "City") then
		if CityGetRandomBuilding("City", -1, 3, -1, -1, FILTER_IGNORE, "Destination") then
			if not f_MoveTo("","Destination") then
				return
			end
			if not GetHomeBuilding("", "HomeBuilding") then	
				return
			end
			if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
				Sleep(2)
				
				local Carry = 0
				if GetItemCount("Destination","Wheat",INVENTORY_SELL)>0 then
					--if Transfer(nil,"",INVENTORY_STD,"Destination",INVENTORY_SELL,"Wheat",1) then
						Carry = 1
					--end
				end
				if Carry == 1 then
					MoveSetActivity("","carry")
					Sleep(2)
					CarryObject("","Handheld_Device/ANIM_Bag.nif",false)	
					if not f_MoveTo("", "HomeBuilding") then
						MoveSetActivity("","")
					    CarryObject("","",false)
						return
					end
					MoveSetActivity("","")
					CarryObject("","",false)
				else
					if not f_MoveTo("", "HomeBuilding") then
						return
					end
				end
				
			end
			Sleep(Rand(10)+5)
		end
	end
end

-- -----------------------
-- CollectWater
-- -----------------------
function CollectWater()
	MsgDebugMeasure("Collecting Water from a Well")
	if GetSettlement("", "City") then
		if FindNearestBuilding("", -1,24,-1,false, "Destination") then
			if not f_MoveTo("","Destination", GL_MOVESPEED_RUN, 170) then
				return
			end
			PlayAnimationNoWait("","manipulate_middle_low_r")
			Sleep(2)
			if (GetImpactValue("Destination","polluted")>0) then
				if Rand(100)>70 then
					diseases_Pox("",true)
				else
					diseases_Fever("",true)
				end
			end
			
			if not GetHomeBuilding("", "HomeBuilding") then	
				return
			end
			if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
				PlaySound3DVariation("","measures/putoutfire",1)
				CarryObject("Owner", "Handheld_Device/ANIM_Bucket.nif", false)
				Sleep(3)
				if not f_MoveTo("", "HomeBuilding", GL_MOVESPEED_WALK) then
					return
				end
				CarryObject("","",false)
			end
			Sleep(Rand(10)+5)
		end
	end
end

-- -----------------------
-- BuySomething
-- -----------------------
function BuySomethingAtTheMarket(art)
	MsgDebugMeasure("Buying Stuff at the Market")
	if GetSettlement("", "City") then
		local Market = Rand(5)+1
		if CityGetRandomBuilding("City", 5,14,Market,-1, FILTER_IGNORE, "Destination") then
			if not f_MoveTo("","Destination",GL_WALKSPEED_RUN, 200) then
				return
			end
			PlayAnimation("","cogitate")
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_neutral",1)
			else
				PlaySound3DVariation("","CharacterFX/female_neutral",1)
			end
			Sleep(Rand(5)+2)

			if not GetHomeBuilding("", "HomeBuilding") then	
				return
			end
			if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
				MoveSetActivity("","carry")
				Sleep(2)
				local Amount = 1
				if SimGetGender("")==GL_GENDER_MALE then
					Amount = 2
				end
					if art == 1 then
					    SatisfyNeed("",1,0.5)
					else
					    SatisfyNeed("",7,0.5)
					end
				
				local Choice = Rand(6)
				local Ware
				if Choice == 0 then
					Ware = "Handheld_Device/ANIM_holzscheite.nif"
				elseif Choice == 1 then
					Ware = "Handheld_Device/ANIM_Boxvegetable.nif"
				elseif Choice == 2 then
					Ware = "Handheld_Device/ANIM_Breadbasket.nif"
				elseif Choice == 3 then
					Ware = "Handheld_Device/ANIM_Barrel.nif"
				elseif Choice == 4 then
				    Ware = "Handheld_Device/ANIM_Bottlebox.nif"
				else
				    Ware = "Handheld_Device/ANIM_Tailorbasket.nif"
				end
				PlaySound3DVariation("","Effects/digging_box",1)
				CarryObject("",Ware,false)	
				if not f_MoveTo("", "HomeBuilding") then
				    MoveSetActivity("","")
				    CarryObject("","",false)
					return
				end
				MoveSetActivity("","")
				CarryObject("","",false)
				
			end
			Sleep(Rand(10)+5)
		end
	end
end
-- -----------------------
-- SnowballBattle
-- -----------------------
function SnowballBattle(Target)
	if not AliasExists(Target) then
		return
	end
	MsgDebugMeasure("Throwing Snowballs...")
	AlignTo("",Target)
	Sleep(1.7)
	PlayAnimationNoWait("","manipulate_bottom_r")
	Sleep(1.5)
	SimStopMeasure(Target)
	MoveStop(Target)
	StopAnimation(Target)
	
	CarryObject("", "Handheld_Device/ANIM_snowball.nif", false)
	Sleep(1)
	PlayAnimationNoWait("", "throw")
	Sleep(1.8)
	CarryObject("", "" ,false)
	local fDuration = ThrowObject("", Target, "Handheld_Device/ANIM_snowball.nif",0.1,"snowball",0,150,0)
	Sleep(fDuration)
	GetPosition(Target,"ParticleSpawnPos")
	
	StartSingleShotParticle("particles/snowball.nif", "ParticleSpawnPos",1,5)
	AlignTo(Target,"")
	Sleep(0.7)
	PlayAnimation(Target,"threat")
end

-- -----------------------
-- GoTownhall
-- -----------------------
function GoTownhall()
	MsgDebugMeasure("Watching, whats going on in the townhall")
	if GetSettlement("", "City") then
		if CityGetRandomBuilding("City", 3,23,-1,-1, FILTER_IGNORE, "Destination") then
			if f_MoveTo("","Destination") then
			    if not GetFreeLocatorByName("Destination","Wait",1,8,"SitPos") then
				    f_Stroll("",300,10)
				    return
			    end
				-- if not f_MoveTo("","SitPos") then
					-- f_Stroll("",300,10)
				    -- return
				-- end
			    if f_BeginUseLocator("","SitPos",GL_STANCE_SITBENCH,true) then
					local anim = { "bench_talk","bench_talk_short","bench_talk_offended" }
					Sleep(Rand(5)+10)
					PlayAnimation("",anim[Rand(3)+1])
				    Sleep(Rand(5)+15)
					f_EndUseLocator("","SitPos",GL_STANCE_STAND)
					f_Stroll("",300,10)
					if Rand(3) == 1 then
						f_ExitCurrentBuilding("")
						idlelib_GoToRandomPosition()
					end
					return
				else
				    f_Stroll("",300,10)
				    return
			    end
			end			
		end
	end
end

-- -----------------------
-- Illness
-- -----------------------
function Illness()
	MsgDebugMeasure("Buying HerbTea or Blanket")
	if GetSettlement("", "City") then
		CityGetLocalMarket("City","Market")
		--buy herbtea
		if GetImpactValue("","Caries")==1 then
			if CityGetRandomBuilding("City", 5,14,-1,-1, FILTER_IGNORE, "Destination") then
				f_MoveTo("","Destination", GL_MOVESPEED_RUN, 100)
				Transfer(nil,nil,INVENTORY_STD,"Market",INVENTORY_STD,"HerbTea",1)
			end
		--or blanket
		elseif  GetImpactValue("","Fever")==1 or GetImpactValue("","Cold")==1 then
			if CityGetRandomBuilding("City", 5,14,-1,-1, FILTER_IGNORE, "Destination") then
				f_MoveTo("","CampPos", GL_MOVESPEED_RUN, 100)
				Transfer(nil,nil,INVENTORY_STD,"Market",INVENTORY_STD,"Blanket",1)
			end
		-- soap
        else
			if CityGetRandomBuilding("City", 5,14,-1,-1, FILTER_IGNORE, "Destination") then
				f_MoveTo("","CampPos", GL_MOVESPEED_RUN, 100)
				Transfer(nil,nil,INVENTORY_STD,"Market",INVENTORY_STD,"Soap",1)
			end		
		end
		PlayAnimation("","talk")
		Sleep(Rand(5)+2)
	    if Rand(100) > 60 then
            if GetImpactValue("","Cold")==1 then
                diseases_Cold("",false)
	        elseif GetImpactValue("","Caries")==1 then
	            diseases_Caries("",false)
	        elseif GetImpactValue("","BurnWound")==1 then
	            diseases_BurnWound("",false)
	        end
	    end
		idlelib_GoHome()
	end
end

-- -----------------------
-- CheckInsideStore
-- -----------------------
function CheckInsideStore()

  local store = Rand(5)
	GetSettlement("", "City")
	local Wares = {}

	if store == 0 then
		Wares = {"Barleybread","Cookie","Wheatbread","Candy","BreadRoll","CreamPie"}
		local Choice = Wares[(Rand(6)+1)]
		if not CityGetRandomBuilding("City",2,6,-1,-1,FILTER_HAS_DYNASTY,"backerei") then
		    return
		end
        --GetLocatorByName("backerei", "BreadsSale", "KaufPos")
		if not f_MoveTo("","backerei",GL_MOVESPEED_RUN,Rand(50)) then
		    return
		end
		local prodNam = ItemGetLabel(Choice,true)
		if GetItemCount("backerei", Choice, INVENTORY_SELL)>0 then
	    if Rand(2) == 0 then
		    PlayAnimationNoWait("","manipulate_middle_twohand")
		    MsgSay("","@L_HPFZ_IDLELIB_GETFOOD_SPRUCH_+0",prodNam)
	    else
		    MsgSayNoWait("","@L_HPFZ_IDLELIB_GETFOOD_SPRUCH_+1",prodNam)
		    CarryObject("", "Handheld_Device/ANIM_Pretzel.nif", false)
		    PlayAnimationNoWait("","eat_standing")
		    Sleep(6)
		    CarryObject("","",false)
	    end
			Transfer(nil,nil,INVENTORY_STD,"backerei",INVENTORY_SELL,Choice,(Rand(5)+1))
		else
			PlayAnimationNoWait("","propel")
			if Rand(2) == 0 then
				MsgSay("","@L_HPFZ_IDLELIB_GETFOOD_SPRUCH_+2",prodNam)
			else
				MsgSay("","@L_HPFZ_IDLELIB_GETFOOD_SPRUCH_+3",prodNam)
			end
			if BuildingGetOwner("backerei","Cheffi") then
			    chr_ModifyFavor("","Cheffi",-5)
			end
		end
		SatisfyNeed("", 1, 0.15)
	elseif store == 1 then
		Wares = {"FarmersClothes","CitizensClothes","NoblesClothes"}
		local Choice = Wares[(Rand(3)+1)]
		if not CityGetRandomBuilding("City",2,9,-1,-1,FILTER_HAS_DYNASTY,"schneiderei") then
			return
		end
    --GetLocatorByName("schneiderei", "Hallstand_01_2", "KaufPos")
		if not f_MoveTo("","schneiderei",GL_MOVESPEED_RUN,Rand(50)) then
			return
		end
		local prodNam = ItemGetLabel(Choice,true)
		if GetItemCount("schneiderei", Choice, INVENTORY_SELL)>0 then
			PlayAnimationNoWait("","manipulate_middle_twohand")
			if Rand(2) == 0 then
			  MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+0",prodNam)
			else
				MsgSayNoWait("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+1",prodNam)
			end
			Transfer(nil,nil,INVENTORY_STD,"schneiderei",INVENTORY_SELL,Choice,(Rand(5)+1))
		else
			PlayAnimationNoWait("","propel")
			if Rand(2) == 0 then
			  MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+2",prodNam)
			else
				MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+3",prodNam)
			end
			if BuildingGetOwner("schneiderei","Cheffi") then
				chr_ModifyFavor("","Cheffi",-5)
			end
		end
		SatisfyNeed("", 7, 0.15)
	elseif store == 2 then
		Wares = {"Torch","BuildMaterial","WalkingStick","CrossOfProtection","RubinStaff"}
		local Choice = Wares[(Rand(5)+1)]
		if not CityGetRandomBuilding("City",2,8,-1,-1,FILTER_HAS_DYNASTY,"tischler") then
		    return
		end
        --GetLocatorByName("tischler", "SawDust1", "KaufPos")
		if not f_MoveTo("","tischler",GL_MOVESPEED_RUN,Rand(50)) then
		    return
		end
		local prodNam = ItemGetLabel(Choice,true)
		if GetItemCount("tischler", Choice, INVENTORY_SELL)>0 then
			PlayAnimationNoWait("","manipulate_middle_twohand")
			if Rand(2) == 0 then
			    MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+0",prodNam)
			else
				MsgSayNoWait("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+1",prodNam)
			end
			Transfer(nil,nil,INVENTORY_STD,"tischler",INVENTORY_SELL,Choice,(Rand(5)+1))
		else
			PlayAnimationNoWait("","propel")
			if Rand(2) == 0 then
			    MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+2",prodNam)
			else
				MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+3",prodNam)
			end
			if BuildingGetOwner("tischler","Cheffi") then
			    chr_ModifyFavor("","Cheffi",-5)
			end
		end		
		SatisfyNeed("", 7, 0.15)
	elseif store == 3 then
		Wares = {"Tool","SilverRing","GoldChain","GemRing"}
		local Choice = Wares[(Rand(4)+1)]
		if not CityGetRandomBuilding("City",2,7,-1,-1,FILTER_HAS_DYNASTY,"schmied") then
		    return
		end
        --GetLocatorByName("schmied", "Anvil", "KaufPos")
		if not f_MoveTo("","schmied",GL_MOVESPEED_RUN,Rand(50)) then
		    return
		end
		local prodNam = ItemGetLabel(Choice,true)
		if GetItemCount("schmied", Choice, INVENTORY_SELL)>0 then
			PlayAnimationNoWait("","manipulate_middle_twohand")
			if Rand(2) == 0 then
			    MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+0",prodNam)
			else
				MsgSayNoWait("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+1",prodNam)
			end
			Transfer(nil,nil,INVENTORY_STD,"schmied",INVENTORY_SELL,Choice,(Rand(5)+1))
		else
			PlayAnimationNoWait("","propel")
			if Rand(2) == 0 then
			    MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+2",prodNam)
			else
				MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+3",prodNam)
			end
			if BuildingGetOwner("schmied","Cheffi") then
			    chr_ModifyFavor("","Cheffi",-5)
			end
		end		
		SatisfyNeed("", 7, 0.15)
	else
		Wares = {"bust","statue"}
		local Choice = Wares[(Rand(2)+1)]
		if not CityGetRandomBuilding("City",2,110,-1,-1,FILTER_HAS_DYNASTY,"smetz") then
		    return
		end
        --GetLocatorByName("smetz", "Propel", "KaufPos")
		if not f_MoveTo("","smetz",GL_MOVESPEED_RUN,Rand(50)) then
		    return
		end
		local prodNam = ItemGetLabel(Choice,true)
		if GetItemCount("smetz", Choice, INVENTORY_SELL)>0 then
			PlayAnimationNoWait("","manipulate_middle_twohand")
			if Rand(2) == 0 then
			    MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+0",prodNam)
			else
				MsgSayNoWait("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+1",prodNam)
			end
			Transfer(nil,nil,INVENTORY_STD,"smetz",INVENTORY_SELL,Choice,(Rand(5)+1))
		else
			PlayAnimationNoWait("","propel")
			if Rand(2) == 0 then
			    MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+2",prodNam)
			else
				MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+3",prodNam)
			end
			if BuildingGetOwner("smetz","Cheffi") then
			    chr_ModifyFavor("","Cheffi",-5)
			end
		end			
		SatisfyNeed("", 7, 0.15)
	end

end

-- -----------------------
-- GoToTavern
-- -----------------------
function GoToTavern()
	local DistanceBest = -1
	local Attractivity
	local Distance
	
	MsgDebugMeasure("Have some drink in a Tavern")
	if GetSettlement("", "City") then

		local stage = GetData("#MusicStage")
		if stage~=nil and GetAliasByID(stage,"stageobj") then
			BuildingGetCity("stageobj","stageCity")
			if GetID("City")==GetID("stageCity") and (Rand(100)>39) then
				if BuildingGetType("stageobj")==GL_BUILDING_TYPE_PIRAT then
					idlelib_GoToDivehouse()
					return
				end
			end
		end

		local NumTaverns = CityGetBuildings("City",2,4,-1,-1,FILTER_HAS_DYNASTY,"Tavern")
		if NumTaverns > 0 then
			
			for i=0,NumTaverns-1 do
				Attractivity	= GetImpactValue("Tavern"..i,"Attractivity")
				
				if HasProperty("Tavern"..i,"Versengold") then
					Attractivity = Attractivity + 1
				end
				
				Distance = GetDistance("","Tavern"..i)
				
				if Distance == -1 then
					Distance = 50000
				end
				
				Distance = Distance / (0.5 + Attractivity)
				if DistanceBest==-1 or Distance<DistanceBest then
					CopyAlias("Tavern"..i,"Destination")
					DistanceBest = Distance
				end
			end
		end
		
		if not f_MoveTo("","Destination") then
			return
		end

		if Rand(4)==0 then
			if HasProperty("Destination","Versengold") then
				MeasureRun("", nil, "CheerMusicians")
			else
				idlelib_KissMeHonza()
			end
		end
		
		local SimFilter = "__F((Object.GetObjectsByRadius(Sim) == 10000))"
		local NumSims = Find("", SimFilter,"Sim", -1)
		if NumSims > 30 then
			f_ExitCurrentBuilding("")
			idlelib_GoToRandomPosition()
			return
		end
		
		if IsDynastySim("") then
			if not GetFreeLocatorByName("Destination","SitRich",1,5,"SitPos") then
				f_Stroll("",150,2)
				return
			end
			if not f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true) then
				return
			end			
		else
			if not GetFreeLocatorByName("Destination","SitInn",1,12,"SitPos") then
				f_Stroll("",150,2)
				return
			end
			if not f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true) then
				return
			end
		end
		
		local Hour = math.mod(GetGametime(), 24)
		local verweile = 0
		local basicvalue = 1

		if Hour > 6 and Hour < 20 then
	    verweile = Rand(3)+2
		else
	    verweile = Rand(6)+2
		end
		if HasProperty("Destination","DanceShow") then
	    verweile = verweile + 3
		end
		if HasProperty("Destination","ServiceActive") then
	    verweile = verweile + 2
		end
		if HasProperty("Destination","Versengold") then
			basicvalue = basicvalue + 1
	    verweile = verweile + 3
		end
		
		while verweile > 0 do

			if HasProperty("Destination","Versengold") and Rand(10)>7 then
				f_EndUseLocator("","SitPos",GL_STANCE_STAND)
				MeasureRun("", nil, "CheerMusicians")
			end
		
			local AnimTime
			local AnimType = Rand(3)
			PlaySound3DVariation("","Locations/tavern_people",1)
			if SimGetNeed("", 8) >  SimGetNeed("", 1) then
				AnimTime = PlayAnimationNoWait("","sit_drink")
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
				Sleep(1)
				PlaySound3DVariation("","CharacterFX/drinking",1)
				Sleep(AnimTime-1.5)
				CarryObject("","",false)
				if SimGetGender("")==GL_GENDER_MALE then
					PlaySound3DVariation("","CharacterFX/male_belch",1)
				else
					PlaySound3DVariation("","CharacterFX/female_belch",1)
				end
				SatisfyNeed("", 8, 0.1)
				Sleep(1.5)
			else
				PlayAnimation("","sit_eat")
				SatisfyNeed("", 1, 0.1)
			end
			
			if AnimType == 0 then
				PlayAnimation("","sit_talk")
			elseif AnimType == 1 then
				AnimTime = PlayAnimationNoWait("","sit_cheer")
				Sleep(1)
				PlaySound3D("","Locations/tavern/cheers_01.wav",1)
				CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
				Sleep(1)
				PlaySound3DVariation("","CharacterFX/drinking",1)
				Sleep(AnimTime-1.5)
				CarryObject("","",false)
				Sleep(1.5)
			else
				PlayAnimationNoWait("","sit_laugh")
				Sleep(2)
				if Rand(2)==0 then
					PlaySound3D("","Locations/tavern/laugh_01.wav",1)
				else
					PlaySound3D("","Locations/tavern/laugh_02.wav",1)
				end
				Sleep(5)	
			end
			
			if SimGetNeed("", 8) > 0.3 or  SimGetNeed("", 1) > 0.3 then
				local NumItems = 1
				if HasProperty("Destination","DanceShow") then
					NumItems = 2
				end
				
				local Items, needo
				if SimGetNeed("", 8) >  SimGetNeed("", 1) then
				  Items = { "SmallBeer", "WheatBeer" }
					needo = 8
				else
				  Items = { "GrainPap", "RoastBeef" }
					needo = 1
				end
				
				local Choice = Items[Rand(2)+1]	
				if GetItemCount("Destination", Choice, INVENTORY_SELL)>0 then
					Transfer(nil, nil, INVENTORY_STD, "Destination", INVENTORY_SELL, Choice, NumItems)
					SatisfyNeed("", needo, 0.3)
					if HasProperty("Destination","ServiceActive") then
						local TavernLevel = BuildingGetLevel("Destination")
						local TavernAttractivity = GetImpactValue("Destination", "Attractivity")
						local Tip = math.floor(TavernLevel * (10 + (Rand(20)+1) * (TavernAttractivity + basicvalue)))
						CreditMoney("Destination",Tip,"tip")
					end
				end
			end

			verweile = verweile - 1
		end
		f_EndUseLocator("","SitPos",GL_STANCE_STAND)

		local Hour = math.mod(GetGametime(), 24)
		if Hour > 21 or Hour < 4 then
			if Rand(100) > 80 then
				--LoopAnimation("","idle_drunk",10)
				AddImpact("","totallydrunk",1,6)
				AddImpact("","MoveSpeed",0.7,6)
				SetState("",STATE_TOTALLYDRUNK,true)
				StopMeasure()
			end
		end
	end
end

-- -----------------------
-- UseCocotte
-- -----------------------
function UseCocotte()

	MsgDebugMeasure("Search a cocotte to fullfill your need")
	-- search cocotte in range
	
	local CocottsCnt = Find("","__F((Object.GetObjectsByRadius(Sim)==20000) AND (Object.GetProfession() == 30) AND (Object.Property.CocotteProvidesLove == 1) AND (Object.Property.CocotteHasClient == 0) AND (Object.HasDifferentSex()))","Cocotte", -1)
	if(CocottsCnt == 0) then
		Sleep(Rand(10)+5)
		return false
	end

	-- go to random cocotte
	ChangeAlias("Cocotte"..Rand(CocottsCnt),"Target")
	if AliasExists("Target") then
		MeasureCreate("UseLaborOfLove")
		MeasureStart("UseLaborOfLove","","Target","UseLaborOfLove",true)
	end
end

-- -----------------------
-- KissMeHonza
-- -----------------------
function KissMeHonza()
	if HasProperty("","KissMeHoney") then
		local Musician = GetProperty("","KissMeHoney")
		if GetAliasByID(Musician,"Musician") then
			if not HasProperty("Musician","Moving") and not HasProperty("Musician","KissMe") and (GetDistance("","Musician")<6001) then
				SetProperty("Musician","KissMe",GetID(""))

				if f_MoveTo("", "Musician", GL_MOVESPEED_RUN, 500) then
					if not HasProperty("Musician","Moving") and not HasProperty("Musician","MusicStage") then
						
						while true do
							if not HasProperty("Musician","KissMe") or HasProperty("Musician","Moving") or HasProperty("Musician","MusicStage") then
								RemoveProperty("","KissMeHoney")
								SatisfyNeed("", 2, 0.2)
								IncrementXP("", 15)
								break
							end
							if Rand(100)<5 then
								local AnimTime = PlayAnimationNoWait("","giggle")
								Sleep(1)
								MsgSay("",GetName("Musician"))
								Sleep(AnimTime)
							else
								Sleep(3)
							end
						end
						
					end
				else
					RemoveProperty("","KissMeHoney")
					RemoveProperty("Musician","KissMe")
				end
			else
				RemoveProperty("","KissMeHoney")
			end
		else
			RemoveProperty("","KissMeHoney")
		end
	end
end

-- -----------------------
-- RepairHome
-- -----------------------
function RepairHome(Building)
	if not AliasExists(Building) then
		return
	end

	MsgDebugMeasure("Buying Buildmaterial at the Market")
	if not GetSettlement("", "City") then
		return
	end
	local Market = Rand(5)+1
	if not CityGetRandomBuilding("City", 5,14,Market,-1, FILTER_IGNORE, "Destination") then
		return
	end
	if not f_MoveTo("","Destination",GL_WALKSPEED_RUN, 200) then
		return
	end
	GetOutdoorMovePosition("",Building,"WorkPos2")
	if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID(Building) then
	
		if Rand(100)<50 then
			Transfer(nil,nil,INVENTORY_STD,"Destination",INVENTORY_STD,"BuildMaterial",1)
		else
			Transfer(nil,nil,INVENTORY_STD,"Destination",INVENTORY_STD,"Tool",1)
		end
		
		MoveSetActivity("","carry")
		Sleep(2)
		CarryObject("","Handheld_Device/ANIM_holzscheite.nif",false)

		if not f_MoveTo("", "WorkPos2",GL_WALKSPEED_RUN, 200) then
			return
		end
		MoveSetActivity("","")
		Sleep(2)
		CarryObject("","",false)
	end
	MsgDebugMeasure("Repairing My Home")
	if not GetFreeLocatorByName(Building,"bomb",1,3,"WorkPos",true) then
		return
	end
	
	if not f_BeginUseLocator("","WorkPos",GL_STANCE_STAND,true) then
		if not f_MoveTo("","WorkPos2") then
			return
		end
	end
	AlignTo("",Building)
	Sleep(0.7)
	SetContext("","rangerhut")
	CarryObject("","Handheld_Device/Anim_Hammer.nif", false)
	PlayAnimation("","chop_in")
	local RepairPerTick = GetMaxHP(Building)/400
	for i=0,20 do
		PlayAnimation("","chop_loop")
		ModifyHP(Building,RepairPerTick,false)
	end
	f_EndUseLocator("","WorkPos",GL_STANCE_STAND)
	PlayAnimation("","chop_out")
	CarryObject("","",false)
		
	
end

-- -----------------------
-- MyrmidonIdle
-- -----------------------
function MyrmidonIdle(Workbuilding)
	SimGetWorkingPlace("", "WorkingPlace")
	if GetFreeLocatorByName("WorkingPlace", "backroom_sit_",1,3, "ChairPos") then
		if not f_BeginUseLocator("", "ChairPos", GL_STANCE_SIT, true) then
			RemoveAlias("ChairPos")
			return
		end
		while true do
			local WhatToDo2 = Rand(4)
			if WhatToDo2 == 0 then
				Sleep(10) 
			elseif WhatToDo2 == 1 then
				Sleep(Rand(20)+4)
			elseif WhatToDo2 == 2 then
				PlayAnimation("","sit_talk")
			else
				PlayAnimation("","sit_laugh")					
			end
			Sleep(1)
		end
	end
	Sleep(3)
end

-- -----------------------
-- VisitDoc
-- -----------------------
function VisitDoc(HospitalID)
	local DistanceBest = -1
	local Attractivity
	local Distance

	if gameplayformulas_CheckMoneyForTreatment("")==0 then
		if GetInsideBuilding("","CurrentBuilding") then
			if BuildingGetType("CurrentBuilding") == GL_BUILDING_TYPE_HOSPITAL then
				f_ExitCurrentBuilding("")
			end
		end
		return
	end

	if GetInsideBuilding("","CurrentBuilding") then
		if BuildingGetType("CurrentBuilding") == GL_BUILDING_TYPE_HOSPITAL then
			if HasProperty("","WaitingForTreatment") then
				return
			end
		end
		GetSettlement("CurrentBuilding","City")

	elseif not GetNearestSettlement("", "City") then
		return
	end
	
	if HospitalID then
		GetAliasByID(HospitalID,"Destination")
	else
		RemoveAlias("Destination")
	end

	if not AliasExists("Destination") then	

		local NumHospitals = CityGetBuildings("City",2,37,-1,-1,FILTER_HAS_DYNASTY,"Hospital")
		if NumHospitals == 0 then
			return
		end
			
		local	IgnoreID
	
		if HasProperty("", "IgnoreHospital") then
			local Time = GetProperty("", "IgnoreHospitalTime")
			if Time < GetGametime() then
				RemoveProperty("", "IgnoreHospital")
				RemoveProperty("", "IgnoreHospitalTime")
			else
				IgnoreID = GetProperty("", "IgnoreHospital")
			end
		end
		
		for i=0,NumHospitals-1 do
		
			if IgnoreID and IgnoreID == GetID("Hospital"..i) then
				Distance = -1
			else
				Attractivity = GetImpactValue("Hospital"..i,"Attractivity")		
				Attractivity = Attractivity + ((BuildingGetLevel("Hospital"..i) -1) / 2)
				Distance			= GetDistance("","Hospital"..i)
				if Distance > 0 then
					Distance = Distance / (0.5 + Attractivity)
				end
			end
			
			local MinLevel = 1
			
			if GetImpactValue("","Sprain")==1 then
				MinLevel = 1
			elseif GetImpactValue("","Cold")==1 then
				MinLevel = 1
			elseif GetImpactValue("","Influenza")==1 then
				MinLevel = 2
			elseif GetImpactValue("","BurnWound")==1 then
				MinLevel = 2
			elseif GetImpactValue("","Pox")==1 then
				MinLevel = 2
			elseif GetImpactValue("","Pneumonia")==1 then
				MinLevel = 3
			elseif GetImpactValue("","Blackdeath")==1 then
				MinLevel = 3
			elseif GetImpactValue("","Fracture")==1 then
				MinLevel = 3
			elseif GetImpactValue("","Caries")==1 then
				MinLevel = 3
			end
			
			if BuildingGetLevel("Hospital"..i) < MinLevel then
				Distance = -1
			end

			
			if Distance>=0 and (DistanceBest==-1 or Distance<DistanceBest) then
				CopyAlias("Hospital"..i,"Destination")
				DistanceBest = Distance
			end
		end
				
		if DistanceBest==-1 then
			if GetHomeBuilding("", "HomeBuilding") and GetFreeLocatorByName("HomeBuilding", "Bed",1,3, "SleepPosition") then
				MeasureRun("",nil,"GoToSleep")
				return
			end
		end
	end
		
	if not f_MoveTo("","Destination") then
		return
	end
	
	--go home if there are too much sick sims
	if not DynastyIsPlayer("") then
		local SickSimFilter = "__F((Object.GetObjectsByRadius(Sim) == 10000) AND (Object.Property.WaitingForTreatment==1))"
		local NumSickSims = Find("", SickSimFilter,"SickSim", -1)
		if NumSickSims > 10 then
			f_ExitCurrentBuilding("")
			return
		end
	end
	
	if GetFreeLocatorByName("Destination", "bench",1,6, "BenchPos") then
		f_BeginUseLocator("","BenchPos",GL_STANCE_SITBENCH,true)
	end
	
	if ((GetImpactValue("","Sickness")>0) or (GetHP("") < GetMaxHP(""))) then
		RemoveOverheadSymbols("")
		
		SetProperty("","WaitingForTreatment",1)
		local Waittime = GetGametime() + 3
		while GetGametime()<Waittime do
			if HasProperty("", "StartTreat") then
				Sleep(25)
			else
				Sleep(Rand(10)+1*5)
				if AliasExists("BenchPos") then
					if (LocatorGetBlocker("BenchPos") ~= GetID("")) then
						if GetFreeLocatorByName("Destination", "bench",1,6, "BenchPos") then
							f_BeginUseLocator("","BenchPos",GL_STANCE_SITBENCH,true)
						end
					end
				else
					if GetFreeLocatorByName("Destination", "bench",1,6, "BenchPos") then
						f_BeginUseLocator("","BenchPos",GL_STANCE_SITBENCH,true)
					end
				end
			end
		end
		RemoveProperty("","WaitingForTreatment")
	end
	
	--go home if you were not treated
	if not DynastyIsPlayer("") then
		f_ExitCurrentBuilding("")
		idlelib_GoToRandomPosition()
		return
	end
end

-- -----------------------
-- ChangeReligion
-- -----------------------
function ChangeReligion(FinalReligion)
	MsgDebugMeasure("Changing my religion")
	if not AliasExists("MyCity") then
		AddImpact("","WasInChurch",1,4)
		return
	end
	local ChurchType = 19
	if FinalReligion == RELIGION_CATHOLIC then
		ChurchType = 20
	end
	if not CityGetRandomBuilding("MyCity",-1,ChurchType,2,-1,FILTER_IGNORE,"Church") then
		AddImpact("","WasInChurch",1,4)
		return
	end
	if not f_MoveTo("","Church") then
		AddImpact("","WasInChurch",1,4)
		return
	end
	MeasureRun("","Church","ChangeFaith",true)
	return
	
end

-- -----------------------
-- GoToDivehouse
-- -----------------------
function GoToDivehouse()
	local DistanceBest = -1
	local Attractivity
	local Distance
	
	MsgDebugMeasure("Have some drink in a Divehouse")
	if GetSettlement("", "City") then

		local stage = GetData("#MusicStage")
		if stage~=nil and GetAliasByID(stage,"stageobj") then
			BuildingGetCity("stageobj","stageCity")
			if GetID("City")==GetID("stageCity") and (Rand(100)>39) then
				if BuildingGetType("stageobj")==GL_BUILDING_TYPE_TAVERN then
					idlelib_GoToTavern()
					return
				end
			end
		end

		local NumTaverns = CityGetBuildings("City",2,36,-1,-1,FILTER_HAS_DYNASTY,"Divehouse")
		if NumTaverns > 0 then
			
			for i=0,NumTaverns-1 do
				Attractivity	= GetImpactValue("Divehouse"..i,"Attractivity")

				if HasProperty("Divehouse"..i,"Versengold") then
					Attractivity = Attractivity + 1.5
				end

				Distance = GetDistance("","Divehouse"..i)
				
				if Distance == -1 then
					Distance = 50000
				end
				
				Distance = Distance / (0.5 + Attractivity)
				if DistanceBest==-1 or Distance<DistanceBest then
					CopyAlias("Divehouse"..i,"Destination")
					DistanceBest = Distance
				end
			end
		end

		if DistanceBest==-1 then
			-- not exist Divehouse
			SatisfyNeed("", 8, 0.5)
			SatisfyNeed("", 2, 0.5)
			return
		end
		
		if not f_MoveTo("","Destination") then
			return
		end

		if GetState("Destination",STATE_BUILDING) then
			return
		end

		if Rand(5)==0 then
			if HasProperty("Destination","Versengold") then
				MeasureRun("", nil, "CheerMusicians")
			else
				idlelib_KissMeHonza()
			end
		end
		
		local SimFilter = "__F((Object.GetObjectsByRadius(Sim) == 1000))"
		local NumSims = Find("", SimFilter,"Sim", -1)
		if NumSims > 30 then
			f_ExitCurrentBuilding("")
			idlelib_GoToRandomPosition()
			return
		end
				
		local lokalPos = 0
		
		if Rand(3) == 0 then
	    if GetFreeLocatorByName("Destination","Bar",1,4,"StehPos") then
		    f_BeginUseLocator("","StehPos",GL_STANCE_STAND,true)
				lokalPos = 1
			else
		    if GetFreeLocatorByName("Destination","appeal",1,4,"StehPos") then
			    f_BeginUseLocator("","StehPos",GL_STANCE_STAND,true)
					lokalPos = 1
				else
			    local posPlatz = Rand(3)
					if posPlatz == 0 then
	          GetFreeLocatorByName("Destination","Sit",1,4,"SitPos")
					elseif posPlatz == 1 then
				    GetFreeLocatorByName("Destination","Sit",5,7,"SitPos")
					else
				    GetFreeLocatorByName("Destination","Sit",8,11,"SitPos")
					end
	        if not f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true) then
		        return
	        end
		    end
			end
		else
	    local posPlatz = Rand(3)
			if posPlatz == 0 then
		    if not GetFreeLocatorByName("Destination","Sit",1,4,"SitPos") then
			    f_Stroll("",150,2) 
			    return
				end
	    elseif posPlatz == 1 then
				if not GetFreeLocatorByName("Destination","Sit",5,7,"SitPos") then
			    f_Stroll("",150,2) 
			    return				
				end
			else
				if not GetFreeLocatorByName("Destination","Sit",8,11,"SitPos") then
					f_Stroll("",150,2) 
				  return			
				end
			end
			if not f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true) then
				return
			end
    end			
		
		local Hour = math.mod(GetGametime(), 24)
		local verweile = 0
		local basicvalue = 1

		if Hour > 6 and Hour < 20 then
			verweile = Rand(2)+3
		else
		  verweile = Rand(4)+4
		end
		if HasProperty("Destination","DanceShow") then
		  verweile = verweile + 3
		end
		if HasProperty("Destination","ServiceActive") then
		  verweile = verweile + 2
		end
		if HasProperty("Destination","Versengold") then
			basicvalue = basicvalue + 1
		  verweile = verweile + 3
		end

    local simstand = SimGetRank("")
    local grundBetrag = 0

		if HasProperty("Destination","ServiceActive") then
	    if simstand == 0 or simstand == 1 then
	    	grundBetrag = Rand(3)+5
	    elseif simstand == 2 then
	      grundBetrag = Rand(5)+5
	    elseif simstand == 3 then
	      grundBetrag = Rand(3)+10
	    elseif simstand == 4 then
	      grundBetrag = Rand(5)+15
	    elseif simstand == 5 then
	      grundBetrag = Rand(10)+20
	    end				
		else
      if simstand == 0 or simstand == 1 then
	      grundBetrag = 5
      elseif simstand == 2 then
        grundBetrag = 5
      elseif simstand == 3 then
        grundBetrag = 10
      elseif simstand == 4 then
        grundBetrag = 15
      elseif simstand == 5 then
        grundBetrag = 20
      end
		end
		if HasProperty("Destination","Versengold") then
	    grundBetrag = grundBetrag + 15
		end
		
		while verweile > 0 do

			if HasProperty("Destination","Versengold") and Rand(10)>7 then
				if lokalPos == 0 then
					f_EndUseLocator("","SitPos",GL_STANCE_STAND)
				else
					f_EndUseLocator("","StandPos",GL_STANCE_STAND)
				end
				MeasureRun("", nil, "CheerMusicians")
			end
		
			local AnimTime
			local AnimType = Rand(4)
			if AnimType == 0 then
		    if lokalPos == 0 then
			    AnimTime = PlayAnimationNoWait("","sit_drink")
			    Sleep(1)
			    CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
				else
			    AnimTime = PlayAnimationNoWait("","use_potion_standing")
			    Sleep(1)
			    CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
				end
				CreditMoney("Destination",grundBetrag,"Offering")
				Sleep(1)
				PlaySound3DVariation("","CharacterFX/drinking",1)
				Sleep(AnimTime-1.5)
				CarryObject("","",false)
				PlaySound3DVariation("","CharacterFX/nasty",1)
				Sleep(1.5)
			elseif AnimType == 1 then
		    if lokalPos == 0 then
			    PlayAnimation("","sit_talk")
				else
			    PlayAnimation("","talk")
				end
			elseif AnimType == 2 then
		    if lokalPos == 0 then
			    AnimTime = PlayAnimationNoWait("","sit_cheer")
			    Sleep(1)
			    PlaySound3D("","Locations/tavern/cheers_01.wav",1)
			    CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
				else
			    AnimTime = PlayAnimationNoWait("","cheer_01")
			    Sleep(1)
			    PlaySound3D("","Locations/tavern/cheers_01.wav",1)
			    CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
				end
				CreditMoney("Destination",grundBetrag,"Offering")
				Sleep(1)
				PlaySound3DVariation("","CharacterFX/drinking",1)
				Sleep(AnimTime-1.5)
				CarryObject("","",false)
				Sleep(1.5)
			elseif AnimType == 3 then
		    if lokalPos == 0 then
			    PlayAnimationNoWait("","sit_laugh")
				else
			    PlayAnimationNoWait("","laud_02")
				end
				Sleep(2)
				if Rand(2)==0 then
					PlaySound3D("","Locations/tavern/laugh_01.wav",1)
				else
					PlaySound3D("","Locations/tavern/laugh_02.wav",1)
				end
				Sleep(2)
			end
			SatisfyNeed("", 8, 0.1)
			
--			if SimGetNeed("", 8) > 0.2 then
				local NumItems = Rand(2)+1
				if HasProperty("Destination","DanceShow") then
					NumItems = Rand(3)+2
				end
				local	Items = { "SmallBeer", "WheatBeer", "PiratenGrog", "Schadelbrand" }
				local Choice = Items[Rand(4)+1]	
				if GetItemCount("Destination", Choice, INVENTORY_SELL)>0 then
					if Choice == "PiratenGrog" or Choice == "Schadelbrand" then
						RemoveItems("Destination",Choice,NumItems,INVENTORY_SELL)
						if Choice == "PiratenGrog" then
							CreditMoney("Destination",20,"Offering")
						else
							CreditMoney("Destination",50,"Offering")
						end
					else
						Transfer(nil, nil, INVENTORY_STD, "Destination", INVENTORY_SELL, Choice, NumItems)
					end
--					SatisfyNeed("", 8, 0.3)
					if HasProperty("Destination","ServiceActive") then
						local TavernLevel = BuildingGetLevel("Destination")
						local TavernAttractivity = GetImpactValue("Destination", "Attractivity")	

						local Tip = math.floor(TavernLevel * (10 + (Rand(20)+1) * (TavernAttractivity + basicvalue)))
						CreditMoney("Destination",Tip,"tip")
					end
				end
--			end
			verweile = verweile - 1
		end
		if lokalPos == 0 then
		    f_EndUseLocator("","SitPos",GL_STANCE_STAND)
		else
		    f_EndUseLocator("","StandPos",GL_STANCE_STAND)
		end
		
		local Hour = math.mod(GetGametime(), 24)
		if Hour > 21 or Hour < 4 then
			if Rand(100) > 70 then
				AddImpact("","totallydrunk",1,6)
				AddImpact("","MoveSpeed",0.7,6)
				SetState("",STATE_TOTALLYDRUNK,true)
				StopMeasure()
			end
		end
	end
end

-- -----------------------
-- TakeACredit
-- -----------------------
function TakeACredit()
	if HasProperty("","ProTCBank") then
		return
	end
	SetProperty("","ProTCBank",1)
	local DistanceBest = -1
	local Attractivity
	local Distance

	if GetSettlement("", "City") then
		local NumBankhouses = CityGetBuildings("City",2,43,-1,-1,FILTER_HAS_DYNASTY,"Bank")
		if NumBankhouses > 0 then
			if HasProperty("", "IgnoreBank") then
				local Time = GetProperty("", "IgnoreBankTime")
				local IgnoreID
				if Time < GetGametime() then
					RemoveProperty("", "IgnoreBank")
					RemoveProperty("", "IgnoreBankTime")
				else
					IgnoreID = GetProperty("", "IgnoreBank")
				end
			end
			for i=0,NumBankhouses-1 do
				if IgnoreID and IgnoreID == GetID("Bank"..i) then
					Distance = -1
				else
					Attractivity	= GetImpactValue("Bank"..i,"Attractivity")
					Distance	= GetDistance("","Bank"..i)
					if Distance == -1 then
						Distance = 50000
					end
					CopyAlias("Bank"..i,"TmpPointer")
					if HasProperty("TmpPointer","OfferCreditNow") then
						Attractivity = Attractivity + 0.15
					end
					if HasProperty("TmpPointer","KreditKonto") then
						Distance = Distance / (0.5 + Attractivity)
						if DistanceBest==-1 or Distance<DistanceBest then
							CopyAlias("Bank"..i,"Destination")
							DistanceBest = Distance
						end
					end
					RemoveAlias("TmpPointer")
				end
			end
		end
		if (DistanceBest==-1) or (AliasExists("Destination")==false) or (BuildingGetType("Destination")~=43) then
			-- bank not exist
			SatisfyNeed("", 9, 1)
			return
		end
		if f_MoveTo("","Destination") then
			if not GetLocatorByName("Destination","Wait4","SitPos") then
				if not GetLocatorByName("Destination","Wait3","SitPos") then
					if not GetFreeLocatorByName("Destination","Wait",1,4,"SitPos") then
						return
					else
						if not HasProperty("Destination","BankKundschaft") then
							SetProperty("Destination","BankKundschaft",1)
						end	
					end
				else
					if not HasProperty("Destination","BankKundschaft") then
						SetProperty("Destination","BankKundschaft",2)
					end						
				end
			else
				if not HasProperty("Destination","BankKundschaft") then
					SetProperty("Destination","BankKundschaft",2)
				end
			end
			
			local coinCheckEnd = false
			if not f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true) then
				if idlelib_BuySomeCoin(1) == "c" then
					while true do
						local WaitSimFilter = "__F(	(Object.GetObjectsByRadius(Sim) == 5000) AND (Object.Property.WaitForCredit==1) AND NOT (Object.Property.StartSay==1)	)"
						local NumWaitSims = Find("", WaitSimFilter,"WaitSim", -1)
						if NumWaitSims < 4 then
							SetProperty("", "WaitForCredit", 1)
							if f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true) then
								break
							else
								local BehaviourRand = Rand(5)
								local AnimTime
								if BehaviourRand == 0 then
									AnimTime = PlayAnimation("","cogitate")
								elseif BehaviourRand == 1 then
									if NumWaitSims == 2 then
										local myID = GetID("")
										local OtherID
										for i=0, NumWaitSims do
											OtherID = GetID("WaitSim"..i)
											if myID ~= OtherID then
												CopyAlias("WaitSim"..i,"OtherSim")
												break
											end
										end
										if AliasExists("OtherSim") then
											SetProperty("", "StartSay", 1)
											SetProperty("OtherSim", "StartSay", 1)
											f_MoveTo("","OtherSim",GL_MOVESPEED_WALK,100)
											AlignTo("","OtherSim")
											AlignTo("OtherSim","")
											Sleep(1.5)
											AnimTime = PlayAnimationNoWait("","talk")
											if SimGetGender("")==GL_GENDER_MALE then
												PlaySound3DVariation("","CharacterFX/male_neutral",1)
											else
												PlaySound3DVariation("","CharacterFX/female_neutral",1)
											end
										end
									end
								end
								Sleep(AnimTime)
								if HasProperty("", "StartSay") then
									RemoveProperty("", "StartSay")
								end
								if AliasExists("OtherSim") then
									if HasProperty("OtherSim", "StartSay") then
										RemoveProperty("OtherSim", "StartSay")
									end
								end
							end
						else
							coinCheckEnd = true
							break
						end
					end
					if HasProperty("", "WaitForCredit") then
						RemoveProperty("", "WaitForCredit")
					end
				else
					coinCheckEnd = true
				end
			end

			if not coinCheckEnd then
				if HasProperty("", "WaitForCredit") then
					RemoveProperty("", "WaitForCredit")
				end
				if HasProperty("Destination","KreditKonto") then
					if HasProperty("Destination","OfferCreditNow") then
						local kreditMeng = GetProperty("Destination","KreditKonto")
						if kreditMeng == 0 then
							f_EndUseLocator("","SitPos",GL_STANCE_STAND)
							f_MoveTo("","Destination")
							idlelib_BuySomeCoin()
						else
							local anim = { "sit_talk","sit_talk_02" }
							local dowhat = PlayAnimationNoWait("",anim[Rand(2)+1])
							MsgSayNoWait("","@L_MEASURE_IDLE_TAKECREDIT_SPRUCH")

							local schuldner = SimGetRank("")
							local lev = SimGetLevel("")

							local hmuch = 0
							if kreditMeng >	8000 then  
								hmuch = (lev*40)+(80*((schuldner*2.5)+Rand(9)+1))
							else
								hmuch = (lev*35)+((kreditMeng/100) * ((schuldner*2)+Rand(8)+1))
								if hmuch < 50 then
									hmuch = 50
								end
							end

							local PlaceIs = SimGetWorkingPlaceID("")
							if lev == 1 and not IsDynastySim("") and PlaceIs == -1 then
								hmuch = 30
							end
							if kreditMeng < hmuch then
								hmuch = kreditMeng
							end
							hmuch = math.floor(hmuch)

							kreditMeng = kreditMeng - hmuch
							SetProperty("","SchuldenGeb",GetID("Destination"))
							SetProperty("","SchuldenMeng",hmuch)
							SetProperty("", "TimeBank", GetGametime()+4)

							SetProperty("Destination","KreditKonto",kreditMeng)

							SatisfyNeed("", 9, 1)

							if BuildingGetOwner("Destination","Glaubiger") then
								chr_ModifyFavor("","Glaubiger",4)					
							end

							Sleep(dowhat)
							f_EndUseLocator("","SitPos",GL_STANCE_STAND)
						end
					else

						f_EndUseLocator("","SitPos",GL_STANCE_STAND)
						f_MoveTo("","Destination")
						idlelib_BuySomeCoin()
					end
				else

					f_EndUseLocator("","SitPos",GL_STANCE_STAND)
					f_MoveTo("","Destination")
					idlelib_BuySomeCoin()
				end
			end
		end			
	end
	f_ExitCurrentBuilding("")
	if AliasExists("Destination") then
		RemoveProperty("Destination","BankKundschaft")
	end
	RemoveProperty("","ProTCBank")
	idlelib_GoToRandomPosition()
end

-- -----------------------
-- ReturnACredit
-- -----------------------
function ReturnACredit()
-- ******** THANKS TO KINVER ********
	if HasProperty("","ProRCBank") then
		return
	end
	SetProperty("","ProRCBank",1)
	if not HasProperty("","SchuldenGeb") then
		return false
	end
	local bankID = GetProperty("","SchuldenGeb")
	if GetAliasByID(bankID,"Destination") then
		if f_MoveTo("","Destination") then
		    local playTime = PlayAnimationNoWait("","use_object_standing")
			CarryObject("Destination","Handheld_Device/ANIM_Smallsack.nif",false)
			Sleep(1)
			MsgSayNoWait("","@L_MEASURE_IDLE_RETURNCREDIT_SPRUCH")
			PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)

			if BuildingGetOwner("Destination","Glaubiger") then
				chr_ModifyFavor("","Glaubiger",-3)					
			end

			local schuld = GetProperty("","SchuldenMeng")
			BuildingGetOwner("Destination","Glaubiger")
			local zinsA = GetSkillValue("Glaubiger",BARGAINING)
			local zinsB = GetSkillValue("Glaubiger",SECRET_KNOWLEDGE)
			local schuldner = SimGetRank("")
			local lev = SimGetLevel("")
			local knowhow = 1.5*(zinsA + zinsB)

			if schuldner <= 1 then
				knowhow=knowhow+3
			elseif schuldner == 2 then
				knowhow=knowhow+4
			elseif schuldner == 3 then
				knowhow=knowhow+6
			elseif schuldner == 4 then
				knowhow=knowhow+8
			else
				knowhow=knowhow+10
			end

			local hecost = (schuld/100) * (knowhow + (lev/2))
			local mecost = 45+(knowhow)+(lev*2)
			local ecost = math.max(hecost,mecost)
			ecost = math.floor(ecost)

			local PlaceIs = SimGetWorkingPlaceID("")
			if PlaceIs ~= -1 then
				ecost = ecost + knowhow
			end
			
			if not HasProperty("Destination","KreditKonto") then
				bankkonto = schuld + ecost
				CreditMoney("Destination",bankkonto,"tip")
			else
				local bankkonto = GetProperty("Destination","KreditKonto") + schuld
				SetProperty("Destination","KreditKonto",bankkonto)
				CreditMoney("Destination",ecost,"tip")
			end

			if HasProperty("","SchuldenMeng") then
				RemoveProperty("","SchuldenMeng")
			end
			if HasProperty("","SchuldenGeb") then
				RemoveProperty("","SchuldenGeb")
			end
			if HasProperty("", "TimeBank") then
				RemoveProperty("", "TimeBank")
			end
			Sleep(playTime-1)
			f_ExitCurrentBuilding("")

			idlelib_GoToRandomPosition()
			return true
		end
	end
	f_ExitCurrentBuilding("")
	RemoveProperty("","ProRCBank")
	idlelib_GoToRandomPosition()
	return false
end

-- -----------------------
-- BeADrunkChamp
-- -----------------------
function BeADrunkChamp()

	if GetSettlement("", "City") then
		if CityGetRandomBuilding("City", 2,36,-1,-1, FILTER_HAS_DYNASTY, "Destination") then
			if f_MoveTo("","Destination") then
		    if not GetFreeLocatorByName("Destination","Bar",1,4,"StehPos") then
			    f_Stroll("",300,10)
			    return
		    end
		    if not f_BeginUseLocator("","StehPos",GL_STANCE_STAND,true) then
			    return
				else
	        Sleep(1)
			    local dowas = PlayAnimationNoWait("","clink_glasses")
			    Sleep(1)
			    CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
			    Sleep(dowas-2)
          if SimGetGender("") == 1 then
            PlaySound3DVariation("","CharacterFX/male_belch",1)
          else
            PlaySound3DVariation("","CharacterFX/female_belch",1)
          end
			    CarryObject("","",false)
					CreditMoney("Destination",Rand(90)+10,"tip")
					local newwinner = GetName("")
					if HasProperty("Destination","BestDrunkPlayer") then
				    local altpoint = GetProperty("Destination","BestDrunkPoints")
						if altpoint > 90 then
					    return
						else
						  RemoveProperty("Destination","BestDrunkPlayer")
							RemoveProperty("Destination","BestDrunkPoints")
					    local bonus = {2,5,10}
					    local newpoints = altpoint + bonus[Rand(3)+1]
              SetProperty("Destination","BestDrunkPlayer",newwinner)
	            SetProperty("Destination","BestDrunkPoints",newpoints)
						end
					else
						local bonus = {10,30,50}
						local newpoints = bonus[Rand(3)+1]
	          SetProperty("Destination","BestDrunkPlayer",newwinner)
		        SetProperty("Destination","BestDrunkPoints",newpoints)
          end
					f_EndUseLocator("","StandPos",GL_STANCE_STAND)
			  end
			end			
		end
	end
end

-- -----------------------
-- BeADiceChamp
-- -----------------------
function BeADiceChamp()

	if GetSettlement("", "City") then
		if CityGetRandomBuilding("City", 2,36,-1,-1, FILTER_HAS_DYNASTY, "Destination") then
			if f_MoveTo("","Destination") then
			    if not GetFreeLocatorByName("Destination","DiceCEO",-1,-1,"StandPos") then
				    f_Stroll("",300,10)
				    return
			    end
			  if not f_BeginUseLocator("Owner","StandPos",GL_STANCE_STAND,true) then
					return
				else
	        Sleep(1)
          PlaySound3D("","measures/shake_dices/shake_dices+0.wav", 1.0)
          local wfallen = PlayAnimationNoWait("","manipulate_middle_low_r")
          Sleep(wfallen-1)
          PlaySound3D("","measures/throw_dices/throw_dices+0.wav", 1.0)
					CreditMoney("Destination",Rand(20)+5,"tip")
					local newwinner = GetName("")
					local bonus
					if HasProperty("Destination","BestDicePlayer") then
					  local altpoint = GetProperty("Destination","BestDicePott")
						bonus = { 2, 5, 10 }
						local neuPott = altpoint + ((altpoint / 100) * bonus[Rand(3)+1])
						RemoveProperty("Destination","BestDicePlayer")
						RemoveProperty("Destination","BestDicePott")

	        	SetProperty("Destination","BestDicePlayer",newwinner)
		        SetProperty("Destination","BestDicePott",neuPott)
					else
						bonus = {50,300,700}
						local newpoints = Rand(300) + bonus[Rand(3)+1]
	          SetProperty("Destination","BestDicePlayer",newwinner)
		        SetProperty("Destination","BestDicePott",newpoints)
          end
					f_EndUseLocator("","StandPos",GL_STANCE_STAND)
			  end
			end			
		end
	end
end

-- -----------------------
-- LeibwacheIdle
-- -----------------------
function LeibwacheIdle(Workbuilding)
	SimGetWorkingPlace("", "WorkingPlace")
	while true do
	  if Rand(2) == 0 then
	    if GetFreeLocatorByName("WorkingPlace", "GuardPos",1,4, "WachPos") then
		    if not f_BeginUseLocator("", "WachPos", GL_STANCE_STAND, true) then
			    RemoveAlias("WachPos")
			  	return
		    end
			  if Rand(2) == 0 then
					Sleep(10) 
			  else
					PlayAnimationNoWait("","sentinel_idle")
			  end
			else
				f_Stroll("",300,10)
			end
		else	
	    if GetFreeLocatorByName("WorkingPlace", "Walledge",1,4, "WachPos") then
		  	if not f_BeginUseLocator("", "WachPos", GL_STANCE_STAND, true) then
			  	RemoveAlias("WachPos")
			    return
		    end
			  local WhatToDo2 = Rand(3)
			  if WhatToDo2 == 0 then
					Sleep(10) 
			  elseif WhatToDo2 == 1 then
				  PlayAnimationNoWait("","sentinel_idle")
			  else
				  CarryObject("","",false)
		      CarryObject("","Handheld_Device/ANIM_telescope.nif",false)
		      PlayAnimation("","scout_object")
		      CarryObject("","",false)					
			  end
			else
			  f_Stroll("",300,10)
		  end
    end
    Sleep(3)
		f_EndUseLocator("", "WachPos", GL_STANCE_STAND)
	end

end

-- -----------------------
-- DinnerAtEstate
-- -----------------------
function DinnerAtEstate()

	if DynastyGetRandomBuilding("",8,111,"Schlossie") then
	  if not GetState("Schlossie",STATE_BURNING) and not GetState("Schlossie",STATE_FIGHTING) then
	    if f_MoveTo("","Schlossie") then
        if GetFreeLocatorByName("Schlossie", "Sit",2,12, "DoDinner") then
          if not f_BeginUseLocator("", "DoDinner", GL_STANCE_SIT, true) then
            RemoveAlias("DoDinner")
            return
          end
					local duration = Rand(2)+1
          local CurrentTime = GetGametime()
          local EndTime = CurrentTime + duration
					local AnimTime, dinner
          local CurrentHP = GetHP("")
          local MaxHP = GetMaxHP("")
          local ToHeal = MaxHP - CurrentHP
          local HealPerTic = ToHeal / (duration * 12)	
					while GetGametime()<EndTime do
					  dinner = Rand(4)
						if dinner == 0 then
		          AnimTime = PlayAnimationNoWait("","sit_drink")
		          Sleep(1)
		          CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
		          Sleep(1)
		          PlaySound3DVariation("","CharacterFX/drinking",1)
		          Sleep(AnimTime-1.5)
		          CarryObject("","",false)
		          if SimGetGender("")==GL_GENDER_MALE then
		            PlaySound3DVariation("","CharacterFX/male_belch",1)
		          else
		            PlaySound3DVariation("","CharacterFX/female_belch",1)
		          end
		          SatisfyNeed("", 8, 0.2)
		          Sleep(1.5)
			      elseif dinner == 1 then
							if Rand(2) == 0 then
		            PlayAnimation("","sit_eat")
		            SatisfyNeed("", 1, 0.2)
							else
						    PlayAnimation("","sit_talk")
							end
	          elseif dinner == 2 then			
	            AnimTime = PlayAnimationNoWait("","sit_cheer")
	            Sleep(1)
	            PlaySound3D("","Locations/tavern/cheers_01.wav",1)
	            CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
	            Sleep(1)
	            PlaySound3DVariation("","CharacterFX/drinking",1)
	            Sleep(AnimTime-1.5)
	            CarryObject("","",false)
	            Sleep(1.5)
	          else
	            PlayAnimationNoWait("","sit_laugh")
	            Sleep(2)
	            if Rand(2)==0 then
		            PlaySound3D("","Locations/tavern/laugh_01.wav",1)
	            else
		            PlaySound3D("","Locations/tavern/laugh_02.wav",1)
	            end
	            Sleep(5)					
				    end
						
					  if GetHP("") < MaxHP then
				    	ModifyHP("", HealPerTic,false)
		        end
					end
					f_EndUseLocator("", "DoDinner", GL_STANCE_STAND)
		    end
		  end
		end
	end
	Sleep(2)

end

function CheckBank()
-- ******** THANKS TO KINVER ********
	if not HasProperty("","SchuldenGeb") then
		return idlelib_TakeACredit()
	else
		return idlelib_ReturnACredit()
	end
end

function BuySomeCoin(SplitNumber)
	local bankID=GetID("CurrentBuilding")
	GetAliasByID(bankID,"Destination")
	if BuildingGetOwner("Destination","Glaubiger") then
		local zinsA = GetSkillValue("Glaubiger",BARGAINING)
		local percent = 50 + (zinsA * 3)
		if Rand(100) < percent then
			local Items = { "Goldlowmed", "Goldmedhigh", "Goldveryhigh" }
			local Choice
			local schuldner = SimGetRank("")
			local lrand = Rand(100)
			if schuldner <= 1 then
				Choice=1
			elseif schuldner == 2 then
				if lrand > 75 then
					Choice=2
				else
					Choice=1
				end
			elseif schuldner == 3 then
				if lrand > 85 then
					Choice=3
				elseif lrand > 30 and lrand < 84 then
					Choice=2
				else
					Choice=1
				end
			elseif schuldner == 4 then
				if lrand > 85 then
					Choice=2
				elseif  lrand > 30 and lrand < 84 then
					Choice=3
				else
					Choice=1
				end
			else
				if lrand > 25 then
					Choice=3
				else
					Choice=2
				end
			end
			Choice=Items[Choice]
			if GetItemCount("Destination", Choice, INVENTORY_SELL)>0 then
				CarryObject("Destination","Handheld_Device/ANIM_Smallsack.nif",false)
				local playTime = PlayAnimationNoWait("","use_object_standing")
				local prodNam = ItemGetLabel(Choice,true)
				if Rand(2) == 0 then
					MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+0",prodNam)
				else
					MsgSayNoWait("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+1",prodNam)
				end
				Transfer(nil, nil, INVENTORY_STD, "Destination", INVENTORY_SELL, Choice, 1)
				PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)
	
				if BuildingGetOwner("Destination","Glaubiger") then
					chr_ModifyFavor("","Glaubiger",1)					
				end
				Sleep(playTime-1)
			else
				if SplitNumber then
					return "c"
				else
					if BuildingGetOwner("Destination","Glaubiger") then
						chr_ModifyFavor("","Glaubiger",-1)					
					end
					SetProperty("", "IgnoreBank", "Destination")
					SetProperty("", "IgnoreBankTime", GetGametime()+36)
				end
			end
		end
	end

	SatisfyNeed("", 9, 1)
end
