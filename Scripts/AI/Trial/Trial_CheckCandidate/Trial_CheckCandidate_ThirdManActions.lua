function Weight()
	GetAliasByID(GetProperty("SIM","trial_destination_ID"),"CutsceneAlias")
	GetAliasByID(GetProperty("SIM","trial_destination_ID"),"trial_destination_ID")

	local CutsceneID = GetProperty("CutsceneAlias","NextCutsceneID")
	GetAliasByID(CutsceneID,"CutsceneAlias")

	local judge = trial_checkcandidate_differentgender_GetDataFromCutscene("CutsceneAlias","judge")
	local accuser = trial_checkcandidate_differentgender_GetDataFromCutscene("CutsceneAlias","accuser")
	local accused = trial_checkcandidate_differentgender_GetDataFromCutscene("CutsceneAlias","accused")
	local assessor1 = trial_checkcandidate_differentgender_GetDataFromCutscene("CutsceneAlias","assessor1")
	local assessor2 = trial_checkcandidate_differentgender_GetDataFromCutscene("CutsceneAlias","assessor2")
	
	if (accuser ~= GetID("SIM")) then
		GetAliasByID(accuser,"Trial_ThirdManTarget")
	else
		GetAliasByID(accused,"Trial_ThirdManTarget")
	end

	local TargetArray = {judge,accuser,accused,assessor1,assessor2}
	local TargetCount = 5

	local MaxFavor = 100
	local MinFavor = 51
	local ModifyFavorJury = -1

	for UseTarget = 1, TargetCount do
		CurrentJury = TargetArray[UseTarget]
		if (CurrentJury ~= GetID("SIM")) then
			GetAliasByID(CurrentJury,"TA_CurrentJury")
			if (DynastyIsPlayer("TA_CurrentJury") == false) then
				GetInsideBuilding("","InsideBuilding")
				if (GetID("trial_destination_ID") == GetID("InsideBuilding")) then
					local Favor	= GetFavorToSim("TA_CurrentJury","Trial_ThirdManTarget")
					if (Favor < MaxFavor) and (Favor > MinFavor) then
						MaxFavor = Favor
						ModifyFavorJury = "TA_CurrentJury"
						SetData("Victim",ModifyFavorJury)
					end
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
	MeasureCreate("Measure")
	MeasureAddAlias("Measure","Believer",GetData("Victim"),false)
	MeasureStart("Measure","SIM","Trial_ThirdManTarget",GetData("ActionToDo"))	
end

