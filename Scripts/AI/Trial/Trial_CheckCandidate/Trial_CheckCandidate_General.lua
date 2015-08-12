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

	local MaxFavor = 51
	local MinFavor = 0
	local ModifyFavorJury = -1
	local CountDiffGender = 0
	local CountDiffGenderTotal = 0
	
	SetData("Victim",0)
	for UseTarget = 1, TargetCount do
		CurrentJury = TargetArray[UseTarget]
		if (CurrentJury ~= GetID("SIM")) then
			GetAliasByID(CurrentJury,"TA_CurrentJury")
			if (DynastyIsPlayer("TA_CurrentJury") == false) then
				GetInsideBuilding("","InsideBuilding")
				if (GetID("trial_destination_ID") == GetID("InsideBuilding")) then
					local Favor	= GetFavorToSim("TA_CurrentJury","SIM")
					if (GetEvidenceValues("SIM","TA_CurrentJury") > 0) then
						ThreatJury = 1
						GetAliasByID(CurrentJury,"TA_GeneralVictim")
						ModifyFavorJury = "TA_GeneralVictim"
						SetData("General_Victim",ModifyFavorJury)
					end
					if (Favor < MaxFavor) and (Favor > MinFavor) then
						MinFavor = Favor
						GetAliasByID(CurrentJury,"TA_GeneralVictim")
						ModifyFavorJury = "TA_GeneralVictim"
						SetData("General_Victim",ModifyFavorJury)
					end
				end
			end
		end
	end

	if (ModifyFavorJury ~= -1) then
		local CanBribe = GetMeasureRepeat("SIM", "BribeCharacter")
		local CanGaze = GetMeasureRepeat("SIM", "UncannyGlare")
		local CanThreat = GetMeasureRepeat("SIM", "ThreatCharacter")
		if CanBribe <= 0 then
			SetData("ActionToDo","BribeCharacter")
			return 70
		elseif (CanGaze <= 0) and (GetImpactValue("SIM","UncannyGlare")==1) then
			SetData("ActionToDo","UncannyGlare")
			return 70
		elseif (CanThreat <= 0)and (ThreatJury == 1) then
			SetData("ActionToDo","ThreatCharacter")
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
	MeasureRun("SIM", GetData("General_Victim"), GetData("ActionToDo"))
end

