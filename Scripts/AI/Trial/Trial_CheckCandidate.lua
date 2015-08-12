function Weight()
	if (HasProperty("SIM","trial_destination_ID") == false) then
		return 0
	end

	if not GetAliasByID(GetProperty("SIM","trial_destination_ID"),"Trial_Destination") then
		RemoveProperty("SIM","trial_destination_ID")
		return 0
	end

	if HasProperty("Trial_Destination","NextCutsceneID") then
		local CutsceneID = GetProperty("Trial_Destination","NextCutsceneID")

		if CutsceneID==nil then
			RemoveProperty("Trial_Destination","NextCutsceneID")
			return 0
		end

		if not GetAliasByID(CutsceneID,"CutsceneAlias") then
			return 0
		end
	else
		return 0
	end
	
	if GetInsideBuilding("SIM","InsideBuilding") then
		if (GetID("Trial_Destination") == GetID("InsideBuilding")) then
			local accuser = trial_checkcandidate_GetDataFromCutscene("CutsceneAlias","accuser")
			local accused = trial_checkcandidate_GetDataFromCutscene("CutsceneAlias","accused")
			
			if GetID("SIM") == accused then
				return 100
			end
			if GetID("SIM") == accuser then
				return 100
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
end

