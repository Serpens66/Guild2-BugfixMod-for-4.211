function Weight()
	GetAliasByID(GetProperty("SIM","destination_ID"),"OfficeSession_Destination")
	local CutsceneID = GetProperty("OfficeSession_Destination","sessioncutszene")
	GetAliasByID(CutsceneID,"CutsceneAlias")

	local TargetArray = {}
	local TargetCount = 1

	local AppList_Count = checkjury_checkenemy_GetDataFromCutscene("CutsceneAlias","AppList_Count")
	local CurrentApplicant
	local UseApplicant
	for UseOffice = 1, AppList_Count, 1 do
		local OfficeTask = checkjury_checkenemy_GetDataFromCutscene("CutsceneAlias","AppList_"..(UseOffice).."_ID")
		local ApplicantCount = checkjury_checkenemy_GetDataFromCutscene("CutsceneAlias","AppList_"..(OfficeTask).."_Count")
		for UseApplicant = 1, ApplicantCount, 1 do
			CurrentApplicant = checkjury_checkenemy_GetDataFromCutscene("CutsceneAlias","AppList_"..(OfficeTask).."_"..(UseApplicant).."_AppID")
			local DipToSim = DynastyGetDiplomacyState(CurrentApplicant,"SIM")
			if DipToSim == DIP_FOE then
				TargetArray[TargetCount] = CurrentApplicant
				TargetCount = TargetCount + 1 
			end
		end
	end

	local DepList_Count = checkjury_checkenemy_GetDataFromCutscene("CutsceneAlias","DepList_Count")
	local CurrentDeplicant
	for UseOffice = 1, DepList_Count, 1 do
		local OfficeTask = checkjury_checkenemy_GetDataFromCutscene("CutsceneAlias","DepList_"..(UseOffice).."_ID")
		CurrentDeplicant = checkjury_checkenemy_GetDataFromCutscene("CutsceneAlias","DepList_"..(OfficeTask).."_DepID")
		local DipToSim = DynastyGetDiplomacyState(CurrentDeplicant,"SIM")
		if DipToSim == DIP_FOE then
			TargetArray[TargetCount] = CurrentApplicant
			TargetCount = TargetCount + 1 
		end
	end
	
	local CurrentTarget
	local MinFavor = 50
	local MaxFavor = 100
	local MaxFavorAlias = -1
	local ModifyFavorJury = -1
	
	local MaxInviters = checkjury_checkenemy_GetDataFromCutscene("CutsceneAlias","Office_Inviters_Count")
	
	for CurrentTarget = 1, TargetCount - 1 , 1 do
		for UseOffice = 0, (MaxInviters-1), 1 do
			CurrentJury = checkjury_checkenemy_GetDataFromCutscene("CutsceneAlias","Office_Inviters_InvID_"..UseOffice)
			if (CurrentJury ~= GetID("SIM")) and (CurrentJury ~= GetID(TargetArray[TargetCount])) then
				local Favor	= GetFavorToSim(CurrentJury,TargetArray[TargetCount])
				if (Favor < MaxFavor) and (Favor > MinFavor) then
					MaxFavor = Favor
					MaxFavorAlias = TargetArray[TargetCount]
					ModifyFavorJury = CurrentJury
				end
			end		
		end		
	end
	
	CopyAlias(TargetArray[TargetCount],"BadTargetSim")
	CopyAlias(CurrentJury,"BadTargetJury")

	return 0
end

function GetDataFromCutscene(CutsceneAlias,Data)
	CutsceneGetData("CutsceneAlias",Data)
	local returnData = GetData(Data)
	return returnData
end

function Execute()

end

