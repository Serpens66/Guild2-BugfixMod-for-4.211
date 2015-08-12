function Weight()
	if (HasProperty("SIM","cutscene_destination_ID") == false) then
		return 0
	end

	if not GetAliasByID(GetProperty("SIM","cutscene_destination_ID"),"CutsceneAlias") then
		RemoveProperty("SIM","cutscene_destination_ID")
		return 0
	end

	local TargetArray = {}
	local TargetCount = 1

	local MaxFavor = 51
	local MinFavor = 0
	local ModifyFavorJury = -1
	local CountDiffGender = 0
	local CountDiffGenderTotal = 0
	local ModifyRhetoric = 0

	local MaxInviters = checkcutscene_GetDataFromCutscene("CutsceneAlias","Office_Inviters_Count")
	if not MaxInviters or MaxInviters<0 then
		return 0
	end
	
	for UseOffice = 0, (MaxInviters-1), 1 do
		local CurrentJury
		CurrentJury = checkcutscene_GetDataFromCutscene("CutsceneAlias","Office_Inviters_InvID_"..UseOffice)
		if (CurrentJury ~= GetID("SIM")) then
			GetAliasByID(CurrentJury,"OS_CurrentJury")
			local Favor	= GetFavorToSim("OS_CurrentJury","SIM")
			if SimGetGender("OS_CurrentJury") ~= SimGetGender("SIM") then
				CountDiffGenderTotal = CountDiffGenderTotal + 1
			end
			if (Favor < MaxFavor) and (Favor > MinFavor) then
				if CheckSkill("SIM",RHETORIC, GetSkillValue("OS_CurrentJury",EMPATHY)) == false then
					ModifyRhetoric = 1
				end	
				if SimGetGender("OS_CurrentJury") ~= SimGetGender("SIM") then
					CountDiffGender = CountDiffGender + 1
				end
				MinFavor = Favor
				ModifyFavorJury = "OS_CurrentJury"
			end
		end
	end

	if (ModifyFavorJury ~= -1) then
		if (CountDiffGender > 0) then
			if CountDiffGenderTotal >= MaxInviters / 2 then
				if (GetItemCount("SIM","Perfume") == 0) and (ai_CanBuyItem("SIM","Perfume",1) > 0) then
					SetData("OS_Artefact","Perfume")
					return -10
				end
			else
				if (GetItemCount("SIM","GoldChain") == 0) and (ai_CanBuyItem("SIM","GoldChain",1) > 0) then
					SetData("OS_Artefact","GoldChain")
					return -10
				elseif (GetItemCount("SIM","GemRing") == 0) and (ai_CanBuyItem("SIM","GemRing",1) > 0) then
					SetData("OS_Artefact","GemRing")
					return -10
				elseif (GetItemCount("SIM","RubinStaff") == 0) and (ai_CanBuyItem("SIM","RubinStaff",1) > 0) then
					SetData("OS_Artefact","RubinStaff")
					return -10
				elseif (GetItemCount("SIM","SilverRing") == 0) and (ai_CanBuyItem("SIM","SilverRing",1) > 0) then
					SetData("OS_Artefact","SilverRing")
					return -10
				elseif (GetItemCount("SIM","OakwoodRing") == 0) and (ai_CanBuyItem("SIM","OakwoodRing",1) > 0) then
					SetData("OS_Artefact","OakwoodRing")
					return -10
				end
			end
			if (GetItemCount("SIM","Poem") == 0) and (ai_CanBuyItem("SIM","Poem",1) > 0) then
				SetData("OS_Artefact","Poem")
				return -10
			end
		end
		if (ModifyRhetoric > 0) then
			if (GetItemCount("SIM","AboutTalents1") == 0) and (ai_CanBuyItem("SIM","AboutTalents1",1) > 0) then
				SetData("OS_Artefact","AboutTalents1")
				return -10
			end
			if (GetItemCount("SIM","AboutTalents2") == 0) and (ai_CanBuyItem("SIM","AboutTalents2",1) > 0) then
				SetData("OS_Artefact","AboutTalents2")
				return -10
			end
		end
		if (GetItemCount("SIM","LetterFromRome") == 0) and (ai_CanBuyItem("SIM","LetterFromRome",1) > 0) then
			SetData("OS_Artefact","LetterFromRome")
			return -10
		end
		if (GetItemCount("SIM","FlowerOfDiscord") == 0) and (ai_CanBuyItem("SIM","FlowerOfDiscord",1) > 0) then
			SetData("OS_Artefact","FlowerOfDiscord")
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
	MeasureAddData("Measure", "ItemToBuy", GetData("OS_Artefact"))
	MeasureStart("Measure", "SIM", nil, "AIBuyItem")

--	ai_BuyItem("SIM",GetData("OS_Artefact"),1)
end



