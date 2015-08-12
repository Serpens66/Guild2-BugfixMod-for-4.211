function Weight()
	GetSettlement("SIM","SimSetle")
	CityGetRandomBuilding("SimSetle", -1, GL_BUILDING_TYPE_TOWNHALL, nil, nil, nil, "Office_Destination")
--	GetAliasByID(GetProperty("SIM","destination_ID"),"Office_Destination")

	local MaxFavor = 51
	local MinFavor = 0
	local ModifyFavorJury = -1
	local ThreatJury = -1

	GetSettlement("SIM","OSCCG_Settlement")
	local NumOfVotes = CityPrepareOfficesToVote("OSCCG_Settlement","OfficeList",false)

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

	SetData("General_Victim",0)
	for i = 0, MaxInviters - 1 do
		CurrentJury = JuryArray[i]
		if (CurrentJury ~= GetID("SIM")) then
			GetInsideBuilding("SIM","InsideBuilding")
			if (GetID("Office_Destination") == GetID("InsideBuilding")) then
				GetAliasByID(CurrentJury,"OS_CurrentJury")
				GetInsideBuilding("OS_CurrentJury","InsideBuilding_Jury")
				if (GetID("Office_Destination") == GetID("InsideBuilding_Jury")) then
					local Favor	= GetFavorToSim("OS_CurrentJury","SIM")
					if (GetEvidenceValues("SIM","OS_CurrentJury") > 0) then
						ThreatJury = 1
						SetData("ThreatVictim","OS_CurrentJury")
						SetData("TVictimID","OS_CurrentJury")
					end
					if (Favor < MaxFavor) or (checkcandidate_general_IamTheLeader(GetID("SIM")) == false) then
						if (Favor > MinFavor) then
							MinFavor = Favor
							ModifyFavorJury = "OS_CurrentJury"
							SetData("General_Victim",ModifyFavorJury)
							SetData("TVictimID","OS_CurrentJury")
						end
					end
				end
			end
		end
	end

	if (ModifyFavorJury ~= -1) then
		local CanBribe = GetMeasureRepeat("SIM", "BribeCharacter")
		local CanGaze = GetMeasureRepeat("SIM", "UncannyGlare")
		local HavePoem = GetItemCount("SIM", "Poem",INVENTORY_STD)
		local CanThreat = GetMeasureRepeat("SIM", "ThreatCharacter")
		if (CanBribe <= 0) and (HasProperty(GetData("TVictimID"),"BribedBy") == false) then
			SetData("ActionToDo","BribeCharacter")
			return 70
		elseif (CanGaze <= 0) and (GetImpactValue("SIM","UncannyGlare")==1) then
			SetData("ActionToDo","UncannyGlare")
			return 70
		elseif (CanThreat <= 0)and (ThreatJury == 1) then
			SetData("ActionToDo","ThreatCharacter")
			SetData("General_Victim",GetData("ThreatVictim"))
			return 70
		elseif (HavePoem > 0) and (GetMeasureRepeat("SIM", "UsePoem") <= 0) then
			SetData("ActionToDo","UsePoem")
			return 70
		end
	end
	return 0
end

function IamTheLeader(simid)
	if not HasProperty("SIM","AIMode") then
		return true
	end
	
	GetSettlement("SIM","OSCCG_Settlement")
	local NumOfVotes = CityPrepareOfficesToVote("OSCCG_Settlement","OfficeList",false)	

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


	local CurrentWinner = -1
	local CurrentWinnerFav = -1
	for i = 0, OfficeArrayCount -1 do
		for Voter = 0, JuryArrayCount - 1 do
			local JurryID = JuryArray[Voter]
			GetAliasByID(JurryID,"OS_CurrentVoter")
			local FavApp = checkcandidate_general_GetFavoriteApplicantToVoter(OfficeArray[i], Voter)
			
			if GetAliasByID(FavApp,"ExisitingSim") then
				local Fav = GetFavorToSim("OS_CurrentVoter","ExisitingSim") + GetImpactValue("ExisitingSim","CutsceneFavor")
				if (Fav > CurrentWinnerFav) then
					CurrentWinner = FavApp
					CurrentWinnerFav = Fav
				end
			end
		end
	end

	if (simid == CurrentWinner) then
		return true
	end
	return false
end

function GetFavoriteApplicantToVoter(OfficeID,VoterNum)
	GetAliasByID(OfficeID,"OS_CurrentOffice")
	local VoterCnt = officesession_GetVoters("OS_CurrentOffice","Voter")
	local AppCnt = officesession_OfficeGetApplicants("OS_CurrentOffice","Applicant")
	
	local AppsArray = {}
	local MaxFavor = 50
	local FavoriteApplicant= -1

	for Applicant = 0, AppCnt - 1 do
		if(AliasExists("Voter"..VoterNum) == true ) then
			local Fav = GetFavorToSim("Voter"..VoterNum,"Applicant"..Applicant) + GetImpactValue("Applicant"..Applicant,"CutsceneFavor")
			if Fav > MaxFavor then
				MaxFavor = Fav
				FavoriteApplicant = GetID("Applicant"..Applicant)
			end
		end
	end
	return FavoriteApplicant
end

function Execute()
	MeasureRun("SIM", GetData("General_Victim"), GetData("ActionToDo"))
end

