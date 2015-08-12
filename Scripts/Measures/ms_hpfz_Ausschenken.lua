function Run()

	if not ai_GetWorkBuilding("", 4, "Wirtshaus") then
		StopMeasure() 
		return
	end

	if not GetInsideBuilding("", "CurrentBuilding") then
		return
	end

	MeasureSetStopMode(STOP_NOMOVE)
	
	if BuildingGetAISetting("CurrentBuilding", "Produce_Selection") > 0 then

		if not GetSettlement("CurrentBuilding", "City") then
			return
		end

		if CityFindCrowdedPlace("City", "", "Destination")==0 then
			return
		end
				
		if BuildingGetType("CurrentBuilding") ~= GL_BUILDING_TYPE_TAVERN then
			return
		end
		
		local ItemCountWheatbeer = GetItemCount("CurrentBuilding", "WheatBeer") + GetItemCount("CurrentBuilding", "WheatBeer", INVENTORY_SELL)
		local ItemCountSmallbeer = GetItemCount("CurrentBuilding", "SmallBeer") + GetItemCount("CurrentBuilding", "SmallBeer", INVENTORY_SELL)
		
		if ItemCountWheatbeer < 1 and ItemCountSmallbeer < 1 then
			return
		end
		
		local ItemType = "WheatBeer"
		
		if ItemCountWheatbeer < ItemCountSmallbeer then
			ItemType = "SmallBeer"
		end
		
		local ItemCount = Rand(10)+5
		if ItemCount > GetItemCount("CurrentBuilding", ItemType) + GetItemCount("CurrentBuilding", ItemType, INVENTORY_SELL) then
			ItemCount = GetItemCount("CurrentBuilding", ItemType) + GetItemCount("CurrentBuilding", ItemType, INVENTORY_SELL)
		end
		
		if ItemCount > GetRemainingInventorySpace("", ItemType) then
			ItemCount = GetRemainingInventorySpace("", ItemType)
		end
		
		if ItemCount == 0 then
			return
		end
		
		AddItems("", ItemType, ItemCount)

		ItemCount = ItemCount - RemoveItems("CurrentBuilding", ItemType, ItemCount)
		ItemCount = ItemCount - RemoveItems("CurrentBuilding", ItemType, ItemCount, INVENTORY_SELL)
	end		
	
	if GetItemCount("", "WheatBeer")<1 and GetItemCount("", "SmallBeer")<1 then
		MsgSay("","_HPFZ_AUSSCHENKEN_FEHLER_+1")
		StopMeasure()
	end

	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetMeasureRepeat(TimeOut)
	
	while GetItemCount("", "WheatBeer")>0 or GetItemCount("", "SmallBeer")>0 do

		if not f_MoveTo("","Destination") then
			StopMeasure()
		end
		
		local EndTime = GetGametime() + duration
	
	    GetPosition("","MovePos")
	    GfxAttachObject("wein1", "city/Stuff/workbarrel.nif")
	    GfxSetPositionTo("wein1", "MovePos")	

		CommitAction("ausschenken", "", "")

		while GetGametime() < EndTime do
		
			if GetItemCount("", "WheatBeer")<1 and GetItemCount("", "SmallBeer")<1 then
		        MsgSay("","_HPFZ_AUSSCHENKEN_FEHLER_+1")
				break
			end
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_jolly",1)
			else
				PlaySound3DVariation("","CharacterFX/female_jolly",1)
			end
            CarryObject("", "Handheld_Device/ANIM_beaker.nif", false)
			PlayAnimation("","manipulate_middle_twohand")
	        CarryObject("", "", false)
			PlayAnimation("","preach")
			Sleep( 1 + 0.1*Rand(20) )
		end
		GfxDetachAllObjects()
		StopAction("ausschenken", "")
	end
	f_MoveTo("", "CurrentBuilding")
	StopMeasure()
end

function CleanUp()
	CarryObject("", "", false)
    GfxDetachAllObjects()
	StopAnimation("")
	StopAction("ausschenken", "")
end

function GetOSHData(MeasureID)
	--can be used again in:
	--OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
