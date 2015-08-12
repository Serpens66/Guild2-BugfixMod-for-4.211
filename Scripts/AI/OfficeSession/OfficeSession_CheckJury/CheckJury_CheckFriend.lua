function Weight()
	GetAliasByID(GetProperty("SIM","destination_ID"),"OfficeSession_Destination")
	local CutsceneID = GetProperty("OfficeSession_Destination","sessioncutszene")
	GetAliasByID(CutsceneID,"CutsceneAlias")

	local MaxInviters = checkjury_checkfriend_GetDataFromCutscene("CutsceneAlias","Office_Inviters_Count")
	local VoterAlias = checkjury_checkfriend_GetDataFromCutscene("CutsceneAlias","Office_Inviters_InvID_"..Rand(MaxInviters-1))

	local AppList_Count = checkjury_checkfriend_GetDataFromCutscene("CutsceneAlias","AppList_Count")
	local CurrentApplicant
	local UseApplicant
	for UseOffice = 1, AppList_Count, 1 do
		local OfficeTask = checkjury_checkfriend_GetDataFromCutscene("CutsceneAlias","AppList_"..(UseOffice).."_ID")
		local ApplicantCount = checkjury_checkfriend_GetDataFromCutscene("CutsceneAlias","AppList_"..(OfficeTask).."_Count")
		for UseApplicant = 1, ApplicantCount, 1 do
			CurrentApplicant = checkjury_checkfriend_GetDataFromCutscene("CutsceneAlias","AppList_"..(OfficeTask).."_"..(UseApplicant).."_AppID")
			local DipToSim = DynastyGetDiplomacyState(CurrentApplicant,"SIM")
			if DipToSim == DIP_ALLIANCE then
				return 100
			end
		end
	end
	
	local DepList_Count = checkjury_checkfriend_GetDataFromCutscene("CutsceneAlias","DepList_Count")
	local CurrentDeplicant
	for UseOffice = 1, DepList_Count, 1 do
		local OfficeTask = checkjury_checkfriend_GetDataFromCutscene("CutsceneAlias","DepList_"..(UseOffice).."_ID")
		CurrentDeplicant = checkjury_checkfriend_GetDataFromCutscene("CutsceneAlias","DepList_"..(OfficeTask).."_DepID")
		GetAliasByID(CurrentDeplicant,"OS_CF_Current")
		local DipToSim = DynastyGetDiplomacyState("OS_CF_Current","")
		if DipToSim == DIP_ALLIANCE then
			return 100
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

end

