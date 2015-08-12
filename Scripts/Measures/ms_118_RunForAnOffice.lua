function Run()
	if not ai_GoInsideBuilding("", "", -1, GL_BUILDING_TYPE_TOWNHALL) then
		StopMeasure()
	end
	
	if not GetHomeBuilding("","HomeBuilding") then
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+4")
		StopMeasure()
	end
	
	if GetNobilityTitle("") < 5 and OfficeGetLevel("destination") > 1 then
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+5")
		StopMeasure()
	end

	if not DynastyIsShadow("") then
		if BuildingGetType("HomeBuilding")~=GL_BUILDING_TYPE_RESIDENCE then
			MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+4")
			StopMeasure()
		end
	end

	if not GetInsideBuilding("","councilbuilding") then
		StopMeasure()
	end

	if not GetSettlement("councilbuilding", "city") then
		StopMeasure()
	end

	if (GetSettlementID("councilbuilding") ~= GetSettlementID("HomeBuilding")) then
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+1",GetID("city"))
		StopMeasure()
	end

	if not HasProperty("councilbuilding","CutsceneAhead") then
		if HasProperty("councilbuilding","CityLevelUpAhead") then
			MsgQuick("", "@L_REPLACEMENTS_FAILURE_MSG_OFFICE_ACTION_IMPOSSIBLE_CITYLEVELUP_+0")
			StopMeasure()
		end
	end
	
	local ChargeCost  = OfficeGetChargeCost("destination")
		
	if DynastyIsPlayer("") then
		if (GetMoney("") < ChargeCost) then
			MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+3")
			StopMeasure()
		end
		if not GetImpactValue("","RunForAnOffice") then
			if OfficeGetLevel("destination")>1 then
				MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+5")
				StopMeasure()
			end
		end
	end

	if not IsGUIDriven() and Rand(100)>25 then
		SimRunForAnOffice("","destination")
		StopMeasure()
	end

	if not GetLocatorByName("councilbuilding", "ApproachUsherPos", "destpos") then
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+0", GetID("city"))
		StopMeasure()
	end
	
	while true do
		if f_BeginUseLocator("","destpos", GL_STANCE_STAND, true) then
			break
		end
		Sleep(2)
	end

	GetDynasty("","SimDynasty")
	if DynastyIsShadow("SimDynasty") then
		if OfficeGetShadowApplicantCount("destination") >= 2 then
			StopMeasure()
		end
		if OfficeGetApplicantCount("destination") >= 2 then
			StopMeasure()
		end
	end	
	
	-- check if there are allready to much votes 
--	local VoteCnt = CityPrepareOfficesToVote("city","OfficeList",false)	
--	if OfficeGetApplicantCount("destination") == 0 then
--		if VoteCnt >= 4 then
--			MsgQuick("", "@L_REPLACEMENTS_FAILURE_MSG_OFFICE_ACTION_IMPOSSIBLE_CITYLEVELUP_+3")
--			StopMeasure()
--		end
--	end
	
	SetData("ReleaseLocator", 1)

	if not BuildingFindSimByProperty("councilbuilding","BUILDING_NPC", 1,"Usher") then
		StopMeasure()
	end

--	--cutscene cam
	SetData("CutsceneCleared", 0)
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","Usher")
	CutsceneCameraCreate("cutscene","")
	camera_CutsceneBothLock("cutscene", "")

	PlayAnimationNoWait("","talk")
	MsgSay("","@L_SESSION_ADDON_RunForAnOffice")
	-- MsgMeasure("","You charge somebody(debug)")

	--WalkTo Scribe locator

	-- der sim erzeugt ein settlementevent mit alias "trial"
	-- das event erhält automatisch einen termin, und eine guildworldID.

	camera_CutsceneBothLockCam("cutscene", "Usher", "Far_HUpYRight")
	
	local APPLICANTS = 2
	-- search through all offices and check if I am allready an applicant
	CityPrepareOfficesToVote("city","OfficeList",false)
	local Size = ListSize("OfficeList")
	SimGetOffice("","SimOffice")
	local MyOfficeID = GetID("SimOffice")
	for i=Size-1,0,-1 do
		ListGetElement("OfficeList", i,"Office")
		if not(MyOfficeID == GetID("Office")) then
			OfficePrepareSessionMembers("Office","ApplicantList",APPLICANTS)
			local AppSize = ListSize("ApplicantList")
			for j=0,AppSize,1 do
				ListGetElement("ApplicantList",j,"ListSim")
				if(GetID("ListSim") == GetID("")) then
					MsgQuick("", "@L_GET_OFFICE_FAILURES_+0", GetID(""))
					StopMeasure()
				end
			end
		end		
	end
	

	if not HasProperty("councilbuilding","CutsceneAhead") then
		if HasProperty("councilbuilding","CityLevelUpAhead") then
			MsgQuick("", "@L_REPLACEMENTS_FAILURE_MSG_OFFICE_ACTION_IMPOSSIBLE_CITYLEVELUP_+0")
			StopMeasure()
		end
	end
	if SimRunForAnOffice("","destination") then
		if DynastyIsPlayer("") then
			SpendMoney("",ChargeCost,"CostAdministration")
			-- PATCH_TODO Money for city treasure?
		end

		PlayAnimationNoWait("Usher",ms_118_runforanoffice_getRandomTalk())
		MsgSay("Usher","@L_PRIVILEGES_118_RUNFORANOFFICE_COMMENT_TOWN_CLERK")
		StopAnimation("Usher")
		-- erzeugt ein event (GuildObject mit ID mit dem alias "trial", Current Sim charges "Destination")
		-- event wird in
		StopAnimation("")
	else
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+2", GetID("city"))
	end
	DestroyCutscene("cutscene")
	SetData("CutsceneCleared", 1)
	
	StopAnimation("")
	
	if(GetLocatorByName("councilbuilding", "LookAtBoardPos", "LookAtBoardPos")) then
		f_MoveTo("","LookAtBoardPos")
	end	
	f_StrollNoWait("",250,1)
end

function getRandomTalk()
	local TargetArray = {"sit_talk_short","sit_talk","sit_talk_02"}
	local TargetCount = 3
	return TargetArray[Rand(TargetCount)+1]
end

function CleanUp()
	if GetData("CutsceneCleared")==0 then
		DestroyCutscene("cutscene")
	end
	if GetData("ReleaseLocator")==1 then
		f_EndUseLocatorNoWait("","destpos", GL_STANCE_STAND)
	end
end

--[[function Run()
	if not ai_GoInsideBuilding("", "", -1, GL_BUILDING_TYPE_TOWNHALL) then
		StopMeasure()
	end
	
	if not GetHomeBuilding("","HomeBuilding") then
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+4")
		StopMeasure()
	end
	
	if GetNobilityTitle("") < 5 and OfficeGetLevel("destination") > 1 then
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+5")
		StopMeasure()
	end

	if not DynastyIsShadow("") then
		if BuildingGetType("HomeBuilding")~=GL_BUILDING_TYPE_RESIDENCE then
			MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+4")
			StopMeasure()
		end
	end

	if not GetInsideBuilding("","councilbuilding") then
		StopMeasure()
	end

	if not GetSettlement("councilbuilding", "city") then
		StopMeasure()
	end

	if (GetSettlementID("councilbuilding") ~= GetSettlementID("HomeBuilding")) then
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+1",GetID("city"))
		StopMeasure()
	end

	if not HasProperty("councilbuilding","CutsceneAhead") then
		if HasProperty("councilbuilding","CityLevelUpAhead") then
			MsgQuick("", "@L_REPLACEMENTS_FAILURE_MSG_OFFICE_ACTION_IMPOSSIBLE_CITYLEVELUP_+0")
			StopMeasure()
		end
	end
	
	local ChargeCost  = OfficeGetChargeCost("destination")
		
	if DynastyIsPlayer("") then
		if (GetMoney("") < ChargeCost) then
			MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+3")
			StopMeasure()
		end
		if not GetImpactValue("","RunForAnOffice") then
			if OfficeGetLevel("destination")>1 then
				MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+5")
				StopMeasure()
			end
		end
	end

	if not IsGUIDriven() and Rand(100)>25 then
		SimRunForAnOffice("","destination")
		StopMeasure()
	end

	if not GetLocatorByName("councilbuilding", "ApproachUsherPos", "destpos") then
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+0", GetID("city"))
		StopMeasure()
	end
	
	while true do
		if f_BeginUseLocator("","destpos", GL_STANCE_STAND, true) then
			break
		end
		Sleep(2)
	end

	GetDynasty("","SimDynasty")
	if DynastyIsShadow("SimDynasty") then
		if OfficeGetShadowApplicantCount("destination") >= 2 then
			StopMeasure()
		end
		if OfficeGetApplicantCount("destination") >= 2 then
			StopMeasure()
		end
	end	
	
	-- check if there are allready to much votes 
--	local VoteCnt = CityPrepareOfficesToVote("city","OfficeList",false)	
--	if OfficeGetApplicantCount("destination") == 0 then
--		if VoteCnt >= 4 then
--			MsgQuick("", "@L_REPLACEMENTS_FAILURE_MSG_OFFICE_ACTION_IMPOSSIBLE_CITYLEVELUP_+3")
--			StopMeasure()
--		end
--	end
	
	SetData("ReleaseLocator", 1)

	if not BuildingFindSimByProperty("councilbuilding","BUILDING_NPC", 1,"Usher") then
		StopMeasure()
	end

--	--cutscene cam
	SetData("CutsceneCleared", 0)
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","Usher")
	CutsceneCameraCreate("cutscene","")
	camera_CutsceneBothLock("cutscene", "")

	PlayAnimationNoWait("","talk")
	MsgSay("","@L_SESSION_ADDON_RunForAnOffice")
	-- MsgMeasure("","You charge somebody(debug)")

	--WalkTo Scribe locator

	-- der sim erzeugt ein settlementevent mit alias "trial"
	-- das event erhält automatisch einen termin, und eine guildworldID.

	camera_CutsceneBothLockCam("cutscene", "Usher", "Far_HUpYRight")
	
	local APPLICANTS = 2
	-- search through all offices and check if I am allready an applicant
	CityPrepareOfficesToVote("city","OfficeList",false)
	local Size = ListSize("OfficeList")
	SimGetOffice("","SimOffice")
	local MyOfficeID = GetID("SimOffice")
	for i=Size-1,0,-1 do
		ListGetElement("OfficeList", i,"Office")
		if not(MyOfficeID == GetID("Office")) then
			OfficePrepareSessionMembers("Office","ApplicantList",APPLICANTS)
			local AppSize = ListSize("ApplicantList")
			for j=0,AppSize,1 do
				ListGetElement("ApplicantList",j,"ListSim")
				if(GetID("ListSim") == GetID("")) then
					MsgQuick("", "@L_GET_OFFICE_FAILURES_+0", GetID(""))
					StopMeasure()
				end
			end
		end		
	end
	

	if not HasProperty("councilbuilding","CutsceneAhead") then
		if HasProperty("councilbuilding","CityLevelUpAhead") then
			MsgQuick("", "@L_REPLACEMENTS_FAILURE_MSG_OFFICE_ACTION_IMPOSSIBLE_CITYLEVELUP_+0")
			StopMeasure()
		end
	end
	if SimRunForAnOffice("","destination") then
		if DynastyIsPlayer("") then
			SpendMoney("",ChargeCost,"CostAdministration")
			-- PATCH_TODO Money for city treasure?
		end
		PlayAnimationNoWait("Usher",ms_118_runforanoffice_getRandomTalk())
		MsgSay("Usher","@L_PRIVILEGES_118_RUNFORANOFFICE_COMMENT_TOWN_CLERK")
		StopAnimation("Usher")
		-- erzeugt ein event (GuildObject mit ID mit dem alias "trial", Current Sim charges "Destination")
		-- event wird in
		StopAnimation("")
	else
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+2", GetID("city"))
	end
	DestroyCutscene("cutscene")
	SetData("CutsceneCleared", 1)
	
	StopAnimation("")
	
	if(GetLocatorByName("councilbuilding", "LookAtBoardPos", "LookAtBoardPos")) then
		f_MoveTo("","LookAtBoardPos")
	end	
	f_StrollNoWait("",250,1)
end

function getRandomTalk()
	local TargetArray = {"sit_talk_short","sit_talk","sit_talk_02"}
	local TargetCount = 3
	return TargetArray[Rand(TargetCount)+1]
end

function CleanUp()
	if GetData("CutsceneCleared")==0 then
		DestroyCutscene("cutscene")
	end
	if GetData("ReleaseLocator")==1 then
		f_EndUseLocatorNoWait("","destpos", GL_STANCE_STAND)
	end
end
--]]