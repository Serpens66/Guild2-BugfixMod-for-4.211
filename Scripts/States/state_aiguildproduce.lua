function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_control")
	SetStateImpact("no_hire")
	SetStateImpact("no_enter")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_measure_start")
	SetStateImpact("NoCameraJump")
end

function Run()
	if GetHomeBuilding("", "Home") then
		if f_MoveTo("", "Home", GL_MOVESPEED_RUN) then
			local Plan
			local Object
			local ProduceTime
			local ItemName1
			local ItemCount1
			local ItemName2
			local ItemCount2
			local ItemName3
			local ItemCount3
			if SimGetClass("")==1 then
				Plan = "WorkingPlanPatron1"
				Object = "BarrelBrewerBeer"
				ProduceTime = 240 - (GetSkillValue("",CRAFTSMANSHIP) * 18)
				ItemName1 = "Honey"
				ItemCount1 = 1
				ItemName2 = "Wheat"
				ItemCount2 = 1
				ItemName3 = "SmallBeer"
				ItemCount3 = 1
			elseif SimGetClass("")==2 then
				Plan = "WorkingPlanArtisan1"
				Object = "ChurchBell"
				ProduceTime = 240 - (GetSkillValue("",CRAFTSMANSHIP) * 18)
				ItemName1 = "iron"
				ItemCount1 = 1
				ItemName2 = "silver"
				ItemCount2 = 1
				ItemName3 = "Tool"
				ItemCount3 = 1
			elseif SimGetClass("")==3 then
				Plan = "WorkingPlanScholar1"
				Object = "Almanac"
				ProduceTime = 240 - (GetSkillValue("",SECRET_KNOWLEDGE) * 18)
				ItemName1 = "Pinewood"
				ItemCount1 = 1
				ItemName2 = "Oakwood"
				ItemCount2 = 1
				ItemName3 = "Leather"
				ItemCount3 = 1
			elseif SimGetClass("")==4 then
				Plan = "WorkingPlanChiseler1"
				Object = "PoisonDagger"
				ProduceTime = 240 - (GetSkillValue("",SHADOW_ARTS) * 18)
				ItemName1 = "Silver"
				ItemCount1 = 1
				ItemName2 = "Tool"
				ItemCount2 = 1
				ItemName3 = "Dagger"
				ItemCount3 = 1
			end

			if GetItemCount("",Plan)==0 then
				StopMeasure()
			end

			local ItemID1 = ItemGetID(ItemName1)
			local	Price1 = math.floor(ItemGetBasePrice(ItemID1))
			local ItemID2 = ItemGetID(ItemName2)
			local	Price2 = math.floor(ItemGetBasePrice(ItemID2))
			local ItemID3 = ItemGetID(ItemName3)
			local	Price3 = math.floor(ItemGetBasePrice(ItemID3))

			if (Price1<1) or (Price2<1) or (Price3<1) then
				StopMeasure()
			end

			if not SpendMoney("", Price1+Price2+Price3, "GuildItem", false) then
				StopMeasure()
			end

			SetState("",STATE_LOCKED,true)
			local percent = ProduceTime / 100
			LoopAnimation("","use_object_standing",-1)
			for i=1,100 do
				Sleep(percent)
			end
			StopAnimation("")
			if RemoveItems("",Plan,1) then
				AddItems("",Object,1)
			end
			IncrementXP("", 50)
			SetState("",STATE_LOCKED,false)
		end
	end
end

function CleanUp()
	SetState("",STATE_LOCKED,false)
	SetState("",STATE_AIGUILDPRODUCE,false)
end

