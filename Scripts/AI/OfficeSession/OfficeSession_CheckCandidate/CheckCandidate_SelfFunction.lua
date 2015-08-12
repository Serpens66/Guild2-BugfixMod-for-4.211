function Weight()
	if (SimGetCutscene("SIM","MyCutscene")) then
		return 0
	end
	GetSettlement("SIM","SimSetle")
	CityGetRandomBuilding("SimSetle", -1, GL_BUILDING_TYPE_TOWNHALL, nil, nil, nil, "Office_Destination")
--	GetAliasByID(GetProperty("SIM","destination_ID"),"Office_Destination")

	local MaxFavor = 51
	local ModifyRhetoric = 0

	GetSettlement("SIM","OSCCSF_Settlement")
	local NumOfVotes = CityPrepareOfficesToVote("OSCCSF_Settlement","OfficeList",false)

--	Put all Voters into one Array

	local OfficeArray = {}
	local OfficeArrayCount = 0

--	Collect All Officetaks the SIM is involved to (as an applicant or defender of his own office
	for i=0,NumOfVotes - 1 do
		ListGetElement("OfficeList",i,"OfficeToCheck")

	    local AppCnt = officesession_OfficeGetApplicants("OfficeToCheck","Applicant")
	    if(AppCnt > 0) then
	    	for j=0,AppCnt - 1 do
	    		local AppAliasID = GetID("Applicant"..j)
	    		local OfficeAliasID = GetID("OfficeToCheck")
	    		local ExistsInList = false
	    		for k=0,OfficeArrayCount - 1 do
	    			if OfficeArray[k] == OfficeAliasID then
	    				ExistsInList = true
	    				break
	    			end
	    		end
	    		if ExistsInList == false then
	    			if(AppAliasID == GetID("SIM")) then
		    			OfficeArray[OfficeArrayCount] = OfficeAliasID
		    			OfficeArrayCount = OfficeArrayCount + 1
		    		end
		    	end
	    	end
	    end
	end

--	Now Collect allJury Members that are involved in the office tasks where the SIM is

	local JuryArray = {}
	local JuryArrayCount = 0

	for i = 0, OfficeArrayCount - 1 do
		GetAliasByID(OfficeArray[i],"OS_CurrentOffice")

	    local VoterCnt = officesession_GetVoters("OS_CurrentOffice","Voter")
	    if(VoterCnt > 0) then
	    	for j=0,VoterCnt - 1 do
	    		local VoterAliasID = GetID("Voter"..j)
	    		local ExistsInList = false
	    		for k=0,JuryArrayCount - 1 do
	    			if JuryArray[k] == VoterAliasID then
	    				ExistsInList = true
	    				break
	    			end
	    		end
	    		if ExistsInList == false then
	    			JuryArray[JuryArrayCount] = VoterAliasID
	    			JuryArrayCount = JuryArrayCount + 1
	    		end
	    	end
	    end
	end

	local MaxInviters = JuryArrayCount

	for i = 0, MaxInviters - 1 do
		CurrentJury = JuryArray[i]
		if (CurrentJury ~= GetID("SIM")) then
			GetAliasByID(CurrentJury,"OS_CurrentJury")
			local Favor	= GetFavorToSim("OS_CurrentJury","SIM")
			if (Favor < MaxFavor) then
				if CheckSkill("SIM",RHETORIC, GetSkillValue("OS_CurrentJury",EMPATHY)) == false then
					ModifyRhetoric = 1
					break
				end
			end
		end
	end
	
	local HaveAT1 = GetItemCount("SIM", "AboutTalents1",INVENTORY_STD)
	local HaveAT2 = GetItemCount("SIM", "AboutTalents2",INVENTORY_STD)
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

