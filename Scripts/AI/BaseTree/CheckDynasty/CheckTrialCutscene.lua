function Weight()
	if (HasProperty("SIM","trial_destination_ID") == false) then
		return 0
	end

	if not GetAliasByID(GetProperty("SIM","trial_destination_ID"),"CutsceneAlias") then
		RemoveProperty("SIM","trial_destination_ID")
		return 0
	end

	local judge = checktrialcutscene_GetDataFromCutscene("CutsceneAlias","judge")
	local accuser = checktrialcutscene_GetDataFromCutscene("CutsceneAlias","accuser")
	local accused = checktrialcutscene_GetDataFromCutscene("CutsceneAlias","accused")
	local assessor1 = checktrialcutscene_GetDataFromCutscene("CutsceneAlias","assessor1")
	local assessor2 = checktrialcutscene_GetDataFromCutscene("CutsceneAlias","assessor2")
	
	local TargetArray = {judge,accuser,accused,assessor1,assessor2}
	local TargetCount = 5
	
	local MaxFavor = 51
	local MinFavor = 0
	local ModifyFavorJury = -1
	local CountDiffGender = 0
	local CountDiffGenderTotal = 0
	local ModifyRhetoric = 0	
	
	for UseTarget = 1, TargetCount do
		local CurrentJury
		CurrentJury = TargetArray[UseTarget]
		if (CurrentJury ~= GetID("SIM")) then
			GetAliasByID(CurrentJury,"TA_CurrentJury")
			local Favor	= GetFavorToSim("TA_CurrentJury","SIM")
			if SimGetGender("TA_CurrentJury") ~= SimGetGender("SIM") then
				CountDiffGenderTotal = CountDiffGenderTotal + 1
			end
			if (Favor < MaxFavor) and (Favor > MinFavor) then
				if CheckSkill("SIM",RHETORIC, GetSkillValue("TA_CurrentJury",EMPATHY)) == false then
					ModifyRhetoric = 1
				end	
				if SimGetGender("TA_CurrentJury") ~= SimGetGender("SIM") then
					CountDiffGender = CountDiffGender + 1
				end
				MinFavor = Favor
				ModifyFavorJury = "TA_CurrentJury"
			end
		end
	end
	
	if (GetItemCount("SIM","FragranceOfHoliness") == 0) and (ai_CanBuyItem("SIM","FragranceOfHoliness",1) > 0) then
		SetData("TM_Artefact","FragranceOfHoliness")
		return -10
	end
	if (ModifyFavorJury ~= -1) then
		if (CountDiffGender > 0) then
			if CountDiffGenderTotal >= 2 then
				if (GetItemCount("SIM","Perfume") == 0) and (ai_CanBuyItem("SIM","Perfume",1) > 0) then
					SetData("TM_Artefact","Perfume")
					return -10
				end
			end
			if (GetItemCount("SIM","Poem") == 0) and (ai_CanBuyItem("SIM","Poem",1) > 0) then
				SetData("TM_Artefact","Poem")
				return -10
			end
		end
		if (ModifyRhetoric > 0) then
			if (GetItemCount("SIM","AboutTalents1") == 0) and (ai_CanBuyItem("SIM","AboutTalents1",1) > 0) then
				SetData("TM_Artefact","AboutTalents1")
				return -10
			end
			if (GetItemCount("SIM","AboutTalents2") == 0) and (ai_CanBuyItem("SIM","AboutTalents2",1) > 0) then
				SetData("TM_Artefact","AboutTalents2")
				return -10
			end
		end
		if (GetItemCount("SIM","LetterFromRome") == 0) and (ai_CanBuyItem("SIM","LetterFromRome",1) > 0) then
			SetData("TM_Artefact","LetterFromRome")
			return -10
		end
		if (GetItemCount("SIM","FlowerOfDiscord") == 0) and (ai_CanBuyItem("SIM","FlowerOfDiscord",1) > 0) then
			SetData("TM_Artefact","FlowerOfDiscord")
			return -10
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
	MeasureAddData("Measure", "ItemToBuy", GetData("TM_Artefact"))
	MeasureStart("Measure", "SIM", nil, "AIBuyItem")
--	ai_BuyItem("SIM",GetData("TM_Artefact"),1)
end



