function Weight()
	GetAliasByID(GetProperty("SIM","destination_ID"),"OfficeSession_Destination")
	local CutsceneID = GetProperty("OfficeSession_Destination","sessioncutszene")
	GetAliasByID(CutsceneID,"CutsceneAlias")
	
	local WhoAmI = officesession_checkjury_GetCutscenePossition()
	
	if GetInsideBuilding("SIM","InsideBuilding") then
		if (GetID("OfficeSession_Destination") == GetID("InsideBuilding")) then

--			Check who the Sim is in the Session, in fact that he can be in the jury and/or run for an office and/or be deselected. 1/2/4 System

--			if you are in the jury do this
			if ((WhoAmI == 1) or (WhoAmI == 3) or (WhoAmI == 5) or (WhoAmI == 7)) then
				return 95
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

function GetCutscenePossition()
	GetAliasByID(GetProperty("SIM","destination_ID"),"OfficeSession_Destination")
	local CutsceneID = GetProperty("OfficeSession_Destination","sessioncutszene")
	GetAliasByID(CutsceneID,"CutsceneAlias")
	
	local Iam = 0
	local UseOffice
	
	local MaxInviters = officesession_checkjury_GetDataFromCutscene("CutsceneAlias","Office_Inviters_Count")
	for UseOffice = 0, (MaxInviters-1), 1 do
		CurrentJury = officesession_checkjury_GetDataFromCutscene("CutsceneAlias","Office_Inviters_InvID_"..UseOffice)
		if CurrentJury == GetID("SIM") then
			Iam = Iam + 1
			break
		end		
	end
	
	local DepList_Count = officesession_checkjury_GetDataFromCutscene("CutsceneAlias","DepList_Count")
	local CurrentDeplicant
	for UseOffice = 1, DepList_Count, 1 do
		local OfficeTask = officesession_checkjury_GetDataFromCutscene("CutsceneAlias","DepList_"..(UseOffice).."_ID")
		CurrentDeplicant = officesession_checkjury_GetDataFromCutscene("CutsceneAlias","DepList_"..(OfficeTask).."_DepID")
		if CurrentDeplicant == GetID("SIM") then
			Iam = Iam + 2
			break
		end
	end
	
	local AppList_Count = officesession_checkjury_GetDataFromCutscene("CutsceneAlias","AppList_Count")
	local CurrentApplicant
	local UseApplicant
	for UseOffice = 1, AppList_Count, 1 do
		local OfficeTask = officesession_checkjury_GetDataFromCutscene("CutsceneAlias","AppList_"..(UseOffice).."_ID")
		local ApplicantCount = officesession_checkjury_GetDataFromCutscene("CutsceneAlias","AppList_"..(OfficeTask).."_Count")
		for UseApplicant = 1, ApplicantCount, 1 do
			CurrentApplicant = officesession_checkjury_GetDataFromCutscene("CutsceneAlias","AppList_"..(OfficeTask).."_"..(UseApplicant).."_AppID")
			if CurrentApplicant == GetID("SIM") then
				Iam = Iam + 4
				break
			end
		end
	end	
	return 	Iam
end

function Execute()
	
end

