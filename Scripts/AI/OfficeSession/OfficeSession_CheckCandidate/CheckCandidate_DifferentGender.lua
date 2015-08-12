function Weight()
	GetSettlement("SIM","SimSetle")
	CityGetRandomBuilding("SimSetle", -1, GL_BUILDING_TYPE_TOWNHALL, nil, nil, nil, "Office_Destination")
--	GetAliasByID(GetProperty("SIM","destination_ID"),"Office_Destination")

	local MaxFavor = 51
	local MinFavor = 15
	local ModifyFavorJury = -1
	local CountDiffGender = 0
	local CountDiffGenderTotal = 0

	GetSettlement("SIM","OSCCDG_Settlement")
	local NumOfVotes = CityPrepareOfficesToVote("OSCCDG_Settlement","OfficeList",false)

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

	for i = 0, (MaxInviters-1), 1 do
		CurrentJury = JuryArray[i]
		if (CurrentJury ~= GetID("SIM")) then
			GetInsideBuilding("SIM","InsideBuilding")
			if (GetID("Office_Destination") == GetID("InsideBuilding")) then
				GetAliasByID(CurrentJury,"OS_CurrentJury")
				GetInsideBuilding("OS_CurrentJury","InsideBuilding_Jury")
				if (GetID("Office_Destination") == GetID("InsideBuilding_Jury")) then
					local Favor	= GetFavorToSim("OS_CurrentJury","SIM")
					if SimGetGender("OS_CurrentJury") ~= SimGetGender("SIM") then
						CountDiffGenderTotal = CountDiffGenderTotal + 1
						if (Favor < MaxFavor) or (checkcandidate_differentgender_IamTheLeader(GetID("SIM")) == false) then
							if (Favor > MinFavor) then
								if SimGetGender("OS_CurrentJury") ~= SimGetGender("SIM") then
									CountDiffGender = CountDiffGender + 1
									MinFavor = Favor
									ModifyFavorJury = "OS_CurrentJury"
								end
							end
						end
					end
				end
			end
		end
	end

	if (ModifyFavorJury ~= -1) then
		local HavePerfume = GetItemCount("SIM", "Perfume",INVENTORY_STD)
		local HavePoem = GetItemCount("SIM", "Poem",INVENTORY_STD)

		local CharismaSkill = GetSkillValue("SIM", CHARISMA)
		local MinimumFavor = 45 - (CharismaSkill*3)
		local CanFlirt = 999
		if (GetFavorToSim("OS_CurrentJury", "SIM") >= MinimumFavor) then
			CanFlirt = GetMeasureRepeat("SIM", "Flirt")
		end

		local RethoricSkill = GetSkillValue("SIM", RHETORIC)
		local MinimumFavor = 45 - (RethoricSkill*2)
		local CanCompliment = 999
		if (GetFavorToSim("OS_CurrentJury", "SIM") >= MinimumFavor) then
			CanCompliment = GetMeasureRepeat("SIM", "MakeACompliment")
		end

		if (CountDiffGenderTotal > 1) then
			if (HavePerfume > 0) and (GetMeasureRepeat("SIM", "UsePerfume") <= 0) then
				SetData("Div_GenItemToUse","UsePerfume")
				SetData("Div_GenVictim",0)
				return -1
			elseif (HavePoem > 0) and (GetMeasureRepeat("SIM", "UsePoem") <= 0) then
				SetData("Div_GenItemToUse","UsePoem")
				SetData("Div_GenVictim","OS_CurrentJury")
				return -1
			end
		elseif (CountDiffGenderTotal == 1) then
			if (HavePoem > 0) and (GetMeasureRepeat("SIM", "UsePoem") <= 0) then
				SetData("Div_GenItemToUse","UsePoem")
				SetData("Div_GenVictim","OS_CurrentJury")
				return -1
			elseif (HavePerfume > 0) and (GetMeasureRepeat("SIM", "UsePerfume") <= 0) then
				SetData("Div_GenItemToUse","UsePerfume")
				SetData("Div_GenVictim",0)
				return -1
			elseif (CanFlirt <= 0) then
				SetData("Div_GenItemToUse","Flirt")
				SetData("Div_GenVictim","OS_CurrentJury")
				return -1
			elseif (CanCompliment <= 0) then
				SetData("Div_GenItemToUse","MakeACompliment")
				SetData("Div_GenVictim","OS_CurrentJury")
				return -1
			end
		end
	end
	return 0
end

function IamTheLeader(simid)
	if not HasProperty("SIM","AIMode") then
		return true
	end

	GetSettlement("SIM","OSCCDG_Settlement")
	local NumOfVotes = CityPrepareOfficesToVote("OSCCDG_Settlement","OfficeList",false)

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

			local FavApp = checkcandidate_differentgender_GetFavoriteApplicantToVoter(OfficeArray[i], Voter)

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
	if GetData("Div_GenVictim") ~= 0 then
		MeasureRun("SIM", GetData("Div_GenVictim"), GetData("Div_GenItemToUse"))
	else
		MeasureRun("SIM", nil, "UsePerfume",true)
	end
end

