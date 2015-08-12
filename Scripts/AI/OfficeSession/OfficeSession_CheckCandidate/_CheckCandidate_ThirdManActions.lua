function Weight()
	if AliasExists("Office_ThirdManTarget") == false then
		return 0
	end

	GetAliasByID(GetProperty("SIM","cutscene_destination_ID"),"CutsceneAlias")
	GetAliasByID(GetProperty("SIM","destination_ID"),"Office_Destination")

	local MaxFavor = 100
	local MinFavor = 51
	local ModifyFavorJury = -1

	local MaxInviters = checkcandidate_differentgender_GetDataFromCutscene("CutsceneAlias","Office_Inviters_Count")
	
	for UseOffice = 0, (MaxInviters-1), 1 do
		CurrentJury = checkcandidate_differentgender_GetDataFromCutscene("CutsceneAlias","Office_Inviters_InvID_"..UseOffice)
		if (CurrentJury ~= GetID("SIM")) then
			GetInsideBuilding("SIM","InsideBuilding")
			if (GetID("Office_Destination") == GetID("InsideBuilding")) then
				GetAliasByID(CurrentJury,"OS_CurrentJury")
				local Favor	= GetFavorToSim("OS_CurrentJury","Office_ThirdManTarget")
				if (Favor < MaxFavor) and (Favor > MinFavor) then
					MaxFavor = Favor
					ModifyFavorJury = "OS_CurrentJury"
					SetData("ThirdManVictim","OS_CurrentJury")
				end
			end
		end
	end
	
	if (ModifyFavorJury ~= -1) then
		local CanDeliver = GetMeasureRepeat("SIM", "DeliverTheFalseGauntlet")
		local HaveFlower = GetItemCount("SIM", "FlowerOfDiscord",INVENTORY_STD)
		if (HaveFlower > 0) and (GetMeasureRepeat("SIM", "UseFlowerOfDiscord") <= 0) then
			SetData("ActionToDo","UseFlowerOfDiscord")
			return 70
		elseif (CanDeliver <= 0) and (GetImpactValue("SIM","DeliverTheFalseGauntlet")==1) then
			SetData("ActionToDo","DeliverTheFalseGauntlet")
			return 70
		end
	end
	return 0
end

function GetDataFromCutscene(CutsceneAlias,Data)
	CutsceneGetData("CutsceneAlias",Data)
	local returnData = GetData(Data)
	return returnData
end

function Execute()
--	MeasureRun("SIM", "Office_ThirdManTarget", "Use"..GetData("ItemToUse"),true)
	
	MeasureCreate("Measure")
	MeasureAddAlias("Measure","Believer",GetData("ThirdManVictim"),false)
	MeasureStart("Measure","SIM","Office_ThirdManTarget",GetData("ActionToDo"))	
end

