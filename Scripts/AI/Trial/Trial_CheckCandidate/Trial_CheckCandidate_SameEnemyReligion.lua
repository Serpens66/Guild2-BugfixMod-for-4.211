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

	local TargetArray = {judge,accuser,accused,assessor1,assessor2}
	local TargetCount = 5
	
	local MaxFavor = 100
	local MinFavor = 51
	local ModifyFavorJury = 0
	
	if (accuser ~= GetID("SIM")) then
		GetAliasByID(accuser,"Trial_LetterTarget")
	else
		GetAliasByID(accused,"Trial_LetterTarget")
	end	
	
	for UseTarget = 1, TargetCount do
		CurrentJury = TargetArray[UseTarget]
		if (CurrentJury ~= GetID("SIM")) then
			GetAliasByID(CurrentJury,"TA_CurrentJury")
			if (DynastyIsPlayer("TA_CurrentJury") == false) then
				GetInsideBuilding("","InsideBuilding")
				if (GetID("trial_destination_ID") == GetID("InsideBuilding")) then
					local Favor	= GetFavorToSim("TA_CurrentJury","Trial_LetterTarget")
					if (Favor < MaxFavor) and (Favor > MinFavor) then
						if (SimGetReligion("TA_CurrentJury") == SimGetReligion("Trial_LetterTarget")) then
							ModifyFavorJury = ModifyFavorJury + 1
						end
					end
				end
			end
		end
	end
	
	if (ModifyFavorJury > 0) then
		local HaveLetter = GetItemCount("SIM", "LetterFromRome",INVENTORY_STD)
		if (HaveLetter > 1) and (GetMeasureRepeat("SIM", "UseLetterFromRome") <= 0) then
			SetData("ItemToUse","LetterFromRome")
			if (ModifyFavorJury == MaxInviters) then
				return 100
			elseif (ModifyFavorJury >= MaxInviters/2) and (ModifyFavorJury > 1) then
				return 80
			else
				return 50
			end
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
	MeasureRun("SIM", "Trial_LetterTarget", "Use"..GetData("ItemToUse"),true)
end

