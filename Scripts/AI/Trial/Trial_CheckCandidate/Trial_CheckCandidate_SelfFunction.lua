function Weight()
	if (SimGetCutscene("SIM","MyCutscene")) then
		return 0
	end
	GetAliasByID(GetProperty("SIM","trial_destination_ID"),"CutsceneAlias")

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
	local ModifyRhetoric = 0

	for UseTarget = 1, TargetCount do
		CurrentJury = TargetArray[UseTarget]
		if (CurrentJury ~= GetID("SIM")) then
			GetAliasByID(CurrentJury,"TA_CurrentJury")
			if (DynastyIsPlayer("TA_CurrentJury") == false) then
				local Favor	= GetFavorToSim("TA_CurrentJury","SIM")
				if (Favor < MaxFavor) then
					if CheckSkill("SIM",RHETORIC, GetSkillValue("TA_CurrentJury",EMPATHY)) == false then
						ModifyRhetoric = 1
						break
					end
				end
			end
		end
	end

	local HaveAT1 = GetItemCount("SIM", "AboutTalents1",INVENTORY_STD)
	local HaveAT2 = GetItemCount("SIM", "AboutTalents2",INVENTORY_STD)
	local HaveHoly2 = GetItemCount("SIM", "FragranceOfHoliness",INVENTORY_STD)
	if (HaveHoly2 > 0) and (GetMeasureRepeat("SIM", "UseFragranceOfHoliness") <= 0) then
		SetData("Self_ItemToUse","UseFragranceOfHoliness")
		return -50
	end	
	if (ModifyRhetoric == 1) then
		if (HaveAT1 > 0) and (GetMeasureRepeat("SIM", "UseAboutTalents1") <= 0) then
			SetData("Self_ItemToUse","UseAboutTalents1")
			return 80
		elseif (HaveAT2 > 0) and (GetMeasureRepeat("SIM", "UseAboutTalents2") <= 0) then
			SetData("Self_ItemToUse","UseAboutTalents2")
			return 80
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
	MeasureRun("SIM", nil, GetData("Self_ItemToUse"),true)
end

