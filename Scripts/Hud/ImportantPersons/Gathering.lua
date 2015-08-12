

function ImportantPersonsAddDynMemberToSection(DynastyReference, Section)

	local iQuantity = DynastyGetMemberCount(DynastyReference)
	for iCount=0, iQuantity-1 do
		if DynastyGetMember(DynastyReference, iCount, "dynAlias") then
			SetImportantPersonToSection(GetID("dynAlias"), Section, GetDynastyID(""))
		end
	end
end


function ImportantPersonsDiplomacyFilter(DiplState, Section)
	
	GetDynasty("", "dynasty")
	local iCount = ScenarioGetObjects("Dynasty", 99, "Dynasties")
	
	if iCount==0 then
		return
	end

	for dyn=0, iCount-1 do
		Alias = "Dynasties"..dyn
		if not (GetID(Alias)==GetID("dynasty")) then
			if DynastyGetDiplomacyState("dynasty", Alias)==DiplState then
				gathering_ImportantPersonsAddDynMemberToSection(Alias, Section)
			end
		end
	end
end


function ImportantPersonsSetupSections()
	-- family
	CreateImportantPersonSection("Family", "@L_IMPORTANTPERSONS_TOPICS_+0")
	CreateImportantPersonSection("CourtLover", "@L_IMPORTANTPERSONS_TOPICS_+1")
	CreateImportantPersonSection("Liaison", "@L_IMPORTANTPERSONS_TOPICS_+2")
	
	-- cutscenes
	CreateImportantPersonSection("DuellGegner", "@L_IMPORTANTPERSONS_TOPICS_+5")
	CreateImportantPersonSection("ProcessMember", "@L_IMPORTANTPERSONS_TOPICS_+6")
	CreateImportantPersonSection("OfficeSession", "@L_IMPORTANTPERSONS_TOPICS_+7")
	
	-- gunst
	CreateImportantPersonSection("TopCandidates", "@L_IMPORTANTPERSONS_TOPICS_+11")
	CreateImportantPersonSection("Alliance", "@L_IMPORTANTPERSONS_TOPICS_+3")
	CreateImportantPersonSection("Nap", "@L_IMPORTANTPERSONS_TOPICS_+9")
	CreateImportantPersonSection("Neutral", "@L_IMPORTANTPERSONS_TOPICS_+10")
	CreateImportantPersonSection("Enemies", "@L_IMPORTANTPERSONS_TOPICS_+4")
	

end



function ImportantPersonsGather_Family()
	
	GetDynasty("", "dynasty")
	local iCount = DynastyGetFamilyMemberCount("dynasty")
	local iIndex
	local iCIndex
	
	local iChildCount
	
	local SimArray
	
	for iIndex = 0, iCount-1 do
		if DynastyGetFamilyMember("dynasty", iIndex, "member") then
			if IsPartyMember("member") then
				SetImportantPersonToSection(GetID("member"), "Family", GetDynastyID(""))
				iChildCount = SimGetChildCount("member")
				for iCIndex = 0, iChildCount-1 do
					if SimGetChild("member", iCIndex, "child") then
						SetImportantPersonToSection(GetID("child"), "Family", GetDynastyID(""))
					end
				end
			end
		end
	end
end


function ImportantPersonsGather_CourtLover()
	
	if SimGetCourtLover("", "courtlover") then
		SetImportantPersonToSection(GetID("courtlover"), "CourtLover"..GetID(""), GetDynastyID(""))
	end
end



function ImportantPersonsGather_TopTenCLs()

--	local iPartners = Find("", "__F((Object.GetObjectsOfWorld(Sim))AND(Object.CanBeCourted()))","Partner", -1)

--	if iPartners==0 then
--		return
--	end

--	local iIndex
--	local iSubIndex
--	local PartAlias
--	local ValueAlias
	
--	local ValueArray
--	local PartArray
	
--	for iIndex = 0, iPartners-1 do
--		PartAlias = "Partner"..iIndex
--		ValueArray[iIndex] = GetMoney(PartAlias) + SimGetMaxOfficeLevel(PartAlias)*1000
	
--		for iSubIndex = 0, iIndex do
--			
--			if ValueArray[iIndex] < 
--		
--		end

	
--	end
end





function ImportantPersonsGather_Liaison()
	
	if SimGetLiaison("", "courtlover") then
		SetImportantPersonToSection(GetID("courtlover"), "Liaison"..GetDynastyID(""), GetDynastyID(""))
	end
end


function ImportantPersonsGather_OfficeSession()
	
	--ClearImportantPersonSection("OfficeSession")

	GetDynasty("", "dynasty")
	local Members = DynastyGetMemberCount("dynasty")
	local PeopleTbl = {}	   
	local Size = 0
	for i=0,Members-1 do
		if(DynastyGetMember("dynasty",i,"member")) then
			if(GetOfficeByApplicant("member","office"))then
				-- add the voters
				local VoterCnt = OfficePrepareSessionMembers("office","voterlist",1)
				for i=0,VoterCnt - 1 do
					ListGetElement("voterlist",i,"voter")
					local ID = GetID("voter")
					if not (gathering_OfficeMemberExists(PeopleTbl,Size,ID))then
						PeopleTbl[Size] = ID
						Size = Size + 1
						SetImportantPersonToSection(ID, "OfficeSession", GetDynastyID(""))
					end					
				end
				
				-- add the applicants
				local MemberID = GetID("member")
				local ApplicantCnt = OfficePrepareSessionMembers("office","applicantlist",2)
				for i=0,ApplicantCnt - 1 do
					ListGetElement("applicantlist",i,"applicant")
					local ID = GetID("applicant")
					if not (ID == MemberID) then
						if not(gathering_OfficeMemberExists(PeopleTbl,Size,ID)) then
							PeopleTbl[Size] = ID
							Size = Size + 1
							SetImportantPersonToSection(ID, "OfficeSession", GetDynastyID(""))
						end
					end
				end
				
			end
		end
	end
end

function OfficeMemberExists(MemberList,MemberListSize,MemberID)
	for i=0,MemberListSize - 1 do
		if(MemberList[i] == MemberID) then
			return true
		end
	end
	
	return false
end



function ImportantPersonsGather_ProcessMember()
	
	--ClearImportantPersonSection("ProcessMember")

	local PSimID0 = -1
	local PSimID1 = -1
	local PSimID2 = -1

	GetDynasty("", "dynasty")
	local Members = DynastyGetMemberCount("dynasty")
	if (Members>=1) and DynastyGetMember("dynasty",0,"member")~=-1 then
		PSimID0 = GetID("member")
	end
	if (Members>=2) and DynastyGetMember("dynasty",1,"member")~=-1 then
		PSimID1 = GetID("member")
	end
	if (Members>=3) and DynastyGetMember("dynasty",2,"member")~=-1 then
		PSimID2 = GetID("member")
	end

	ListAllCutscenes("cutscene_list")
	local i
	local NumCutscenes = ListSize("cutscene_list")
	for i=0,NumCutscenes-1 do
		ListGetElement("cutscene_list",i,"cutscene")
		if GetID("cutscene")~=-1 then
			local idx = 0
			local PeopleTbl = {}	   

			if CopyAliasFromCutscene("accuser","cutscene","sim") then
				idx = idx + 1 
				PeopleTbl[idx] = GetID("sim")
			end
			if CopyAliasFromCutscene("accused","cutscene","sim") then
				idx = idx + 1 
				PeopleTbl[idx] = GetID("sim")
			end
			if CopyAliasFromCutscene("judge","cutscene","sim") then
				idx = idx + 1 
				PeopleTbl[idx] = GetID("sim")
			end
			if CopyAliasFromCutscene("assessor1","cutscene","sim") then
				idx = idx + 1 
				PeopleTbl[idx] = GetID("sim")
			end
			if CopyAliasFromCutscene("assessor2","cutscene","sim") then
				idx = idx + 1 
				PeopleTbl[idx] = GetID("sim")
			end
		
			local IsRelevant = false
			for i = 1,idx do
				if PeopleTbl[i]~=-1 and (PeopleTbl[i]==PSimID0 or PeopleTbl[i]==PSimID1 or PeopleTbl[i]==PSimID2) then
					PeopleTbl[i] = -1
					IsRelevant = true
				end
			end
			if (IsRelevant) then
				for i=1,idx do
					local PersonID = PeopleTbl[i]
					if PersonID~=-1 then
						SetImportantPersonToSection(PersonID, "ProcessMember", GetDynastyID(""))
					end
				end
			end
		end
	end
end

function ImportantPersonsGather_DuellGegner()
	--ClearImportantPersonSection("DuellGegner")

	local PSimID0 = -1
	local PSimID1 = -1
	local PSimID2 = -1

	GetDynasty("", "dynasty")
	local Members = DynastyGetMemberCount("dynasty")
	if (Members>=1) and DynastyGetMember("dynasty",0,"member")~=-1 then
		PSimID0 = GetID("member")
	end
	if (Members>=2) and DynastyGetMember("dynasty",1,"member")~=-1 then
		PSimID1 = GetID("member")
	end
	if (Members>=3) and DynastyGetMember("dynasty",2,"member")~=-1 then
		PSimID2 = GetID("member")
	end

	ListAllCutscenes("cutscene_list")
	local i
	local NumCutscenes = ListSize("cutscene_list")
	for i=0,NumCutscenes-1 do
		ListGetElement("cutscene_list",i,"cutscene")
		if GetID("cutscene")~=-1 then
			local idx = 0
			local PeopleTbl = {}	   

			if CopyAliasFromCutscene("challenger","cutscene","sim") then
				idx = idx + 1 
				PeopleTbl[idx] = GetID("sim")
			end
			if CopyAliasFromCutscene("challenged","cutscene","sim") then
				idx = idx + 1 
				PeopleTbl[idx] = GetID("sim")
			end
		
			local IsRelevant = false
			for i = 1,idx do
				if PeopleTbl[i]~=-1 and (PeopleTbl[i]==PSimID0 or PeopleTbl[i]==PSimID1 or PeopleTbl[i]==PSimID2) then
					PeopleTbl[i] = -1
					IsRelevant = true
				end
			end
			if (IsRelevant) then
				for i=1,idx do
					local PersonID = PeopleTbl[i]
					if PersonID~=-1 then
						SetImportantPersonToSection(PersonID, "DuellGegner", GetDynastyID(""))
					end
				end
			end
		end
	end
end




function GetDataFromCutscene(CutsceneAlias, Data)
	if CutsceneGetData(CutsceneAlias,Data) then
		local returnData = GetData(Data)
		return returnData
	end
	return nil
end



function ImportantPersonsGather_Alliance()

	gathering_ImportantPersonsDiplomacyFilter(DIP_ALLIANCE, "Alliance")
end


function ImportantPersonsGather_Nap()

	gathering_ImportantPersonsDiplomacyFilter(DIP_NAP, "Nap")
end

function ImportantPersonsGather_Neutral()

	gathering_ImportantPersonsDiplomacyFilter(DIP_NEUTRAL, "Neutral")
end

function ImportantPersonsGather_Enemies()

	gathering_ImportantPersonsDiplomacyFilter(DIP_FOE, "Enemies")
end









