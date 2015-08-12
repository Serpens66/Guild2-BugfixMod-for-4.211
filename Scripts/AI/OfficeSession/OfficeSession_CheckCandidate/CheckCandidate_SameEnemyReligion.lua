function Weight()
	if AliasExists("Office_LetterTarget") == false then
		return 0
	end

	GetSettlement("SIM","SimSetle")
	CityGetRandomBuilding("SimSetle", -1, GL_BUILDING_TYPE_TOWNHALL, nil, nil, nil, "Office_Destination")
--	GetAliasByID(GetProperty("SIM","destination_ID"),"Office_Destination")

	local MaxFavor = 100
	local MinFavor = 51
	local ModifyFavorJury = 0

	GetSettlement("SIM","OSCCSR_Settlement")
	local NumOfVotes = CityPrepareOfficesToVote("OSCCSR_Settlement","OfficeList",false)

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
			GetInsideBuilding("SIM","InsideBuilding")
			if (GetID("Office_Destination") == GetID("InsideBuilding")) then
				GetAliasByID(CurrentJury,"OS_CurrentJury")
				GetInsideBuilding("OS_CurrentJury","InsideBuilding_Jury")
				if (GetID("Office_Destination") == GetID("InsideBuilding_Jury")) then
					local Favor	= GetFavorToSim("OS_CurrentJury","Office_LetterTarget")
					if (Favor < MaxFavor) and (Favor > MinFavor) then
						if (SimGetReligion("OS_CurrentJury") == SimGetReligion("Office_LetterTarget")) then
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
	MeasureRun("SIM", "Office_LetterTarget", "Use"..GetData("ItemToUse"),true)
end

