function GetWorld()
	return ""
end

-- this function is called directly after the world is loaded
-- use this function for creating dynasties and sim's
-- on success return nothing or a empty string
-- on error return the error message

function Prepare()
	SetTime(EN_SEASON_SPRING,1400, 8, 0)
	return true
end

function CreateShadowDynasty(Number, City, NewDynastyAlias)

	local PrimTypes = { GL_BUILDING_TYPE_MINE, GL_BUILDING_TYPE_RANGERHUT, GL_BUILDING_TYPE_HOSPITAL, GL_BUILDING_TYPE_FARM, GL_BUILDING_TYPE_TAVERN, -1 }
	local	Protos = { GL_BUILDING_TYPE_BAKERY, GL_BUILDING_TYPE_SMITHY, GL_BUILDING_TYPE_JOINERY, GL_BUILDING_TYPE_TAILORING, GL_BUILDING_TYPE_ROBBER, 
									 GL_BUILDING_TYPE_ALCHEMIST_SHOP, GL_BUILDING_TYPE_CHURCH_EV, GL_BUILDING_TYPE_CHURCH_CATH, GL_BUILDING_TYPE_CASTLE, GL_BUILDING_TYPE_THIEF, 
									 GL_BUILDING_TYPE_PIRAT, GL_BUILDING_TYPE_BANKHOUSE, GL_BUILDING_TYPE_FRIEDHOF, GL_BUILDING_TYPE_GAUKLER, GL_BUILDING_TYPE_MILL, 
									 GL_BUILDING_TYPE_FRUITFARM, GL_BUILDING_TYPE_STONEMASON }
	local	Pos
	local Count = 0
	local y = 0
	local CityLevel = CityGetLevel(City)
	
	if CityLevel<=2 then
		y = 0
	elseif CityLevel==3 then
		y = 1
	elseif CityLevel==4 then
		y = 2
	elseif CityLevel==5 then
		y = 3
	else
		y = 3
	end
	
	for x=0,y do
		if not AliasExists("WorkingHut") then
			local Start = Rand(5)+1
			Pos = Start
			while PrimTypes[Pos] do
				Count = CityGetBuildingCount(City, -1, PrimTypes[Pos], -1, -1, FILTER_HAS_DYNASTY)
				if Count > 0 then
					break
				elseif CityGetRandomBuilding(City, -1, PrimTypes[Pos], -1, -1, FILTER_NO_DYNASTY, "WorkingHut") then
					break
				end
				Pos = Pos + 1
				if Pos > 5 then
					Pos = 1
				end
				if Pos == Start then
					break
				end
			end
		end
	
		if not AliasExists("WorkingHut") or Count>0 then
			local Start = Rand(17)+1
			Pos = Start
			while Protos[Pos] do
				if CityGetRandomBuilding(City, -1, Protos[Pos], -1, -1, FILTER_NO_DYNASTY, "WorkingHut") then
					break
				end
				Pos = Pos + 1
				if Pos > 17 then
					Pos = 1
				end
				if Pos == Start then
					break
				end
			end
		end

		if not AliasExists("WorkingHut") then
			return "no WorkingHut found for shadow dynasty on startup"
		end
		
		local Class = BuildingGetCharacterClass("WorkingHut")
		if Class == -1 then
			return "Illegal character class for building "..GetName("WorkingHut")
		end
		local	Gender = Rand(2)
		
		if not DynastyCreate(-1, false, 0, NewDynastyAlias, true) then
			return "cannot create the dynasty"
		end
		
		if not BossCreate("WorkingHut", Gender, Class, 5, "boss") then
			return "unable to create boss of the dynasty"
		end
		
		local Religion = BuildingGetReligion("WorkingHut")
		if Religion~=RELIGION_NONE then
			SimSetReligion("boss", Religion)
		end
		
		DynastyAddMember(NewDynastyAlias, "boss")
		if not BuildingBuy("WorkingHut", "boss", BM_STARTUP) then
			return "unable to buy the building for the dynasty"
		end
		
		SetHomeBuilding("boss", "WorkingHut")
	
		local Difficulty = ScenarioGetDifficulty()
		local	Fame
		local	ImpFame
		local	NobLevel
		local	XP
		local StartMoney
	
		if Difficulty == 0 then
			NobLevel = Rand(2)+2
			XP = Rand(100)*8 + 2200
			StartMoney = 2500
			Fame = Rand(2)
			ImpFame = Rand(2)
		elseif Difficulty == 1 then
			NobLevel = Rand(1)+3
			XP = Rand(100)*8 + 2700
			StartMoney = 3000
			Fame = Rand(5)+1
			ImpFame = Rand(5)+1
		elseif Difficulty == 2 then
			NobLevel = Rand(2)+3
			XP = Rand(100)*8 + 3200
			StartMoney = 3500
			Fame = Rand(10)+2
			ImpFame = Rand(10)+2
		elseif Difficulty == 3 then
			NobLevel = Rand(3)+3
			XP = Rand(100)*8 + 3700
			StartMoney = 4000
			Fame = Rand(15)+3
			ImpFame = Rand(15)+3
		else
			NobLevel = Rand(3)+4
			XP = Rand(100)*8 + 4200
			StartMoney = 4500
			Fame = Rand(20)+3
			ImpFame = Rand(20)+3
		end
		
		if AliasExists("Office") then
			SimSetOffice("boss", "Office")
			NobLevel = NobLevel + math.floor(OfficeGetLevel("Office")*0.5)
			
			if BossCreate("WorkingHut", 1 - SimGetGender("boss"), SimGetClass("boss"), 5, "Spouse") then
				SimMarry("boss", "Spouse")
			end
	-- PATCH_TODO
			DynastyAddMember(NewDynastyAlias, "Spouse")
			IncrementXP("Spouse", XP)
			XP = XP + OfficeGetLevel("Office")*1000
			SimCreate(SimGetGender("boss"), "WorkingHut", "WorkingHut", "Shadowchild")
			if SimGetGender("boss")==GL_GENDER_MALE then
				SimSetFamily("Shadowchild", "Spouse", "")
			else
				SimSetFamily("Shadowchild", "", "Spouse")
			end
			if GetHomeBuilding("boss", "Residence") then
				SetHomeBuilding("Shadowchild", "Residence")
			end
			DoNewBornStuff("Shadowchild")
			SimSetAge("Shadowchild", Rand(5)+4)
			SimSetBehavior("Shadowchild", "Childness")
			SetState("Shadowchild", STATE_CHILD, true)
		end

		SetNobilityTitle("boss", NobLevel, true)
		IncrementXP("boss", XP)
		CreditMoney("boss", StartMoney, "GameStart")
		chr_SimAddFame("boss",Fame)
		chr_SimAddImperialFame("boss",ImpFame)

	end
	
	return ""
end

function CreateDynasty(ID, SpawnPoint, IsPlayer, PeerID, PlayerDescLabel)

	local DynastyAlias	= "NewDynasty"

	if not AliasExists(SpawnPoint) then
		return "invalid spawn point"
	end
	
	local PlayerDescNode = nil
	local CityName = nil

	if PlayerDescLabel~=nil then
		local PlayerDescPath = "\\Application\\Game\\PlayerDesc"..PlayerDescLabel
		PlayerDescNode = FindNode(PlayerDescPath)
	end
	
	if IsPlayer then
		if not PlayerCreate(nil, "boss") then
			return "unable to create player character"
		end	
	else
		if not BossCreate(nil, 0, 0, -1, "boss") then
			return "unable to create boss of the dynasty"
		end
	end	
	
	if not DynastyCreate(ID, IsPlayer, PeerID, DynastyAlias, false) then
		return "cannot create the dynasty "..ID
	end
	
	if(CityName == nil) then
		CityName = ""
	end
	
	local	CityAlias
	local	Section
	local BeamPos
	
	Section 	= "INIT-"
	if IsPlayer then
		Section = Section .. "PLAYER-"
	else
		Section = Section .. "AI-"
	end
	
	Section = Section .. ScenarioGetDifficulty()
	
	local HasResidence 	= GetSettingNumber(Section, "HasResidence", 0)
	local	Workshops 		= GetSettingNumber(Section, "Workshops", 0)
	local Money 		= GetSettingNumber(Section, "Money", 5000)
	local	Married 		= GetSettingNumber(Section, "Married", 0)
	local Childs		= GetSettingNumber(Section, "Childs", 0)
	
	CityAlias	= "CityName"
	CityName = ""
	
	-- get city name from playerdescnode
	if PlayerDescNode~=nil then
		CityName = PlayerDescNode:GetValueString("City")
	end
	
	if IsPlayer then
		if CityName and CityName~="" then
			ScenarioGetObjectByName("Settlement", CityName, CityAlias)
		end

		if not AliasExists(CityAlias) then
			CityName = GetSettingString("ENDLESS", "City", "")
			if CityName~="" then
				ScenarioGetObjectByName("Settlement", CityName, CityAlias)
			end
		end
	end

	if HasResidence or Workshops > 0 then
		if not AliasExists(CityAlias) then
			-- find a good start city for the dynasty
			
			local CityCount = ScenarioGetObjects("Settlement", 10, "CityList")
			local	cc
			local	FreeWorkshops
			local	FreeResidences
			local Total = 0
			local	BestTotal = 0
			local	BestCity
			for cc=0,CityCount-1 do
				FreeResidences	= CityGetBuildingCount( "CityList"..cc, nil, GL_BUILDING_TYPE_RESIDENCE, 1, -1, FILTER_IS_BUYABLE)
				FreeWorkshops	= CityGetBuildingCount( "CityList"..cc, GL_BUILDING_CLASS_WORKSHOP, nil, 1, -1, FILTER_IS_BUYABLE)
				
				
				if FreeResidences > 4  then 
					FreeResidences = 4
				end
				if FreeWorkshops > 4  then 
					FreeWorkshops = 4
				end
				
				Total = FreeResidences + FreeWorkshops
				
				if Total == BestTotal then
					BestTotal = BestTotal - Rand(2)
				end
				
				if Total > BestTotal then
					BestTotal = Total
					BestCity	= "CityList"..cc
				end
			end
			
			if BestCity then
				CopyAlias(BestCity, CityAlias)
			else
				if not ScenarioGetRandomObject("Settlement", CityAlias) then
					HasResidence = 0
					Workshops 	= 0
				end
			end
		end
	end	
	
	if HasResidence==1 then
		if not CityGetRandomBuilding(CityAlias, nil, GL_BUILDING_TYPE_RESIDENCE, 1, -1, FILTER_IS_BUYABLE, "Residence") then
			local Proto = ScenarioFindBuildingProto(nil, GL_BUILDING_TYPE_RESIDENCE, 1, -1)
			if Proto and Proto~=-1 then
				if not CityBuildNewBuilding(CityAlias, Proto, nil, "Residence") then
					return "unable to create main residence"
				end
			end
		end
	end
	

	if not IsPlayer then
		-- find a good character class for the new boss
		if Workshops>0 then
			local	Good = {}
			local	Medium = {}
			local	GoodCount = 0
			local MediumCount = 0
			for Class = GL_CLASS_PATRON, GL_CLASS_CHISELER do
				local Count = CityGetBuildingCountForCharacter(CityAlias, Class, RELIGION_NONE, true)
				if Count >= Workshops then
					Good[GoodCount] = Class
					GoodCount = GoodCount + 1
				elseif Count > 0 then
					Medium[MediumCount] = Class
					MediumCount = MediumCount + 1
				end
			end

			local Class		
			if GoodCount > 0 then
				Class = Good[ Rand(GoodCount) ]
			elseif MediumCount>0 then
				Class = Medium[ Rand(MediumCount) ]
			end
		
			if Class then
				SimSetClass("boss", Class)
			end
		end

	end
	
	if not DynastyAddMember(DynastyAlias, "boss") then
		return "unable to add the first member to the dynasty"
	end
	
	local 	H4x0r = GetSettingNumber("DEBUG", "InitialTitle", 0)
	if (H4x0r > 0) then
		SetNobilityTitle("boss", H4x0r)
	end		
	
	if AliasExists("Residence") then
		BuildingBuy("Residence", "boss", BM_STARTUP)
		GetOutdoorMovePosition("boss", "Residence", "BeamPos")
		BeamPos = "BeamPos"
	else
		if GetOutdoorMovePosition("boss", SpawnPoint, "Position") then
			BeamPos = "Position"
		else
			BeamPos = SpawnPoint
		end
	end
	SimBeamMeUp("boss", BeamPos)
	
	local Class = SimGetClass("boss")
	while Workshops>0 do
		if not DynastyFindNewBuilding("boss", BM_STARTUP, "WorkShop") then
			local Proto = ScenarioFindBuildingProtoForCharacter("boss", 1, -1)
			if Proto and Proto~=-1 then
				local BuildingPrice = BuildingGetPriceProto(Proto)
				if BuildingPrice>0 then
					CreditMoney(DynastyAlias, BuildingPrice, "GameStart")
				end
			end
		end
		Workshops = Workshops - 1
	end
	
	if Married == 1 then
		if BossCreate(nil, 1 - SimGetGender("boss"), SimGetClass("boss"), -1, "spouse") then
			SimBeamMeUp("spouse", BeamPos)
			SimMarry("boss", "spouse")
		end
	end
	
	-- init mission
	local PlayerDescNode = nil

	if PlayerDescLabel~=nil then
		local PlayerDescPath = "\\Application\\Game\\PlayerDesc"..PlayerDescLabel
		PlayerDescNode = FindNode(PlayerDescPath)
	end

	if PlayerDescNode~=nil then

		local Team
		local Success
		
		Success, Team = PlayerDescNode:GetValueInt("Team", 0)
		if Team and Team>0 then
			DynastySetTeam(DynastyAlias, Team)
		end
		
		SetProperty(DynastyAlias,"PlayerDesc",PlayerDescLabel)
		local MissionType = PlayerDescNode:GetValueInt("MissionType")
		local MissionSubtype = PlayerDescNode:GetValueInt("MissionSubType")
	
	
		if (MissionType==0) then			-- ausloeschung
			StartMission("Mission_DeathMatch",DynastyAlias)
		elseif (MissionType==1) then		-- timelimit
			StartMission("Mission_TimeLimit",DynastyAlias)
		elseif (MissionType==2)  then		-- common goal 
			if (MissionSubtype==0) then
				StartMission("Mission_MakeMoney",DynastyAlias)
			elseif (MissionSubtype==1) then
				StartMission("Mission_Office",DynastyAlias)
			elseif (MissionSubtype==2) then
				StartMission("Mission_Acuss",DynastyAlias)
			elseif (MissionSubtype==3) then
				StartMission("Mission_Criminal",DynastyAlias)
			end
		elseif (MissionType==4) then
			StartMission("Mission_Endless",DynastyAlias)
		end
	end

	CreditMoney(DynastyAlias, Money, "GameStart")

	local ChildAge = 0

	if not IsPlayer then
		local Difficulty = ScenarioGetDifficulty()
		local XP
		local StartMoney
		local	Fame
		local	ImpFame
		local Age = 18
		
		if Difficulty == 0 then
			XP = 0
			StartMoney = 0
			Fame = 0
			ImpFame = 0
			Age = Rand(20)+Age
			ChildAge = ChildAge + 2
		elseif Difficulty == 1 then
			XP = Rand(100)*5 + 100
			StartMoney = 500
			Fame = Rand(5)+1
			ImpFame = Rand(5)+1
			Age = Rand(15)+Age
			ChildAge = ChildAge + 4
		elseif Difficulty == 2 then
			XP = Rand(100)*5 + 500
			StartMoney = 1000
			Fame = Rand(8)+2
			ImpFame = Rand(8)+2
			if Childs==0 then
				Childs=Rand(2)
			end
			Age = Rand(10)+Age
			ChildAge = Rand(2) + ChildAge + 6
		elseif Difficulty == 3 then
			XP = Rand(100)*5 + 1000
			StartMoney = 1500
			Fame = Rand(15)+3
			ImpFame = Rand(15)+3
			if Childs==0 then
				Childs=Rand(2)+1
			end
			Age = Rand(5)+Age
			ChildAge = Rand(6) + ChildAge + 6
		else
			XP = Rand(100)*5 + 1500
			StartMoney = 2000
			Fame = Rand(20)+3
			ImpFame = Rand(20)+3
			if Childs==0 then
				Childs=Rand(2)+2
			end
			Age = Rand(5)+Age
			ChildAge = Rand(8) + ChildAge + 6
		end

		local BossAge = Rand(5)+Age
		local SpouseAge = Rand(5)+Age

		if (BossAge-16-ChildAge)<0 then
			BossAge = BossAge + (-1*(BossAge-16-ChildAge))
		end
		if (SpouseAge-16-ChildAge)<0 then
			SpouseAge = SpouseAge + (-1*(SpouseAge-16-ChildAge))
		end

		SimSetAge("boss", BossAge)
		if Married == 1 then
			SimSetAge("spouse", SpouseAge)
		end

		IncrementXP("boss", XP)
		CreditMoney("boss", StartMoney, "GameStart")
		chr_SimAddFame("boss",Fame)
		chr_SimAddImperialFame("boss",ImpFame)
	end
	
	if Childs>0 then
		if AliasExists("Residence") then
			local	ch
			for ch=0,Childs-1 do
				SimCreate(8, "Residence", "Residence", "NewBorn"..ch)
				SimSetFamily("NewBorn"..ch, "boss", "spouse")
				
				if (ChildAge-ch)<0 then
					SimSetAge("NewBorn"..ch, (ChildAge-ch))
				else
					SimSetAge("NewBorn"..ch, 1)
				end
			end
		end
	end

	return ""
end

function CreateComputerDynasty(Number, SpawnPoint)
	return defaultcampaign_CreateDynasty(Number, SpawnPoint, false, -1)
end


-- this function is called, after the init of the scenario is finished.
function Start()
	defaultcampaign_SetupDiplomacy()
end

function SetupDiplomacy()

	local	CityCount = ScenarioGetObjects("Settlement", 99, "Cities")
	local DynCount 	= ScenarioGetObjects("Dynasty", 99, "DynList")
	if CityCount==0 or DynCount==0 then
		return
	end
	
	local CityID
	local	Count
	
	for dyn=0,DynCount-1 do
		if DynastyGetBuilding2("DynList"..dyn, 0, "Home"..dyn) then
			SetData("CityID"..dyn, GetSettlementID("Home"..dyn))
		else
			SetData("CityID"..dyn, -1)
		end
	end
	
	
	for CityNo=0,CityCount-1 do
	
		CityID 	= GetID("Cities"..CityNo)
		Count 	= 0
		
		for dyn=0,DynCount-1 do
			if GetData("CityID"..dyn)==CityID then
				CopyAlias("DynList"..dyn, "Dynasties"..Count)
				Count = Count + 1
			end
		end
		
		local FoeCount = math.floor((Count+1)/4)
		local FriendCount = math.floor((Count+1)/3)
		local Alias
		
		for dyn=0,Count-1 do
		
			Alias = "Dynasties"..dyn
			
			local Friends = defaultcampaign_GetStateCount(Alias, DIP_NAP, Count)
			local Foes = defaultcampaign_GetStateCount(Alias, DIP_FOE, Count)
			
			while Friends<FriendCount or Foes<FoeCount do
			
				if Friends<FriendCount then
					Friend = defaultcampaign_FindDynasty(DIP_NAP, FriendCount, dyn+1, Count, Friends==0)
					if Friend then
						DynastySetDiplomacyState(Alias, Friend, DIP_NAP)
					end
					Friends = Friends + 1
				end
	
				if Foes<FoeCount then
					Foe = defaultcampaign_FindDynasty(DIP_FOE, FoeCount, dyn+1, Count, Foes==0 )
					if Foe then
						DynastySetDiplomacyState(Alias, Foe, DIP_FOE)
					end
					Foes = Foes + 1
				end
			end
		end
		
	end
	
end

function InitCameraPosition()

	if GetLocalPlayerDynasty("LocalPlayer") then
		if DynastyGetMember("LocalPlayer", 0, "Boss") then
			local Rotation = 180
			if GetHomeBuilding("Boss", "Home") then
				Rotation = GetRotation("Boss", "home") + 90
			end
			CameraTerrainSetPos("Boss", 1200, Rotation)
		end
	end
end

function FindDynasty(DipState, MaxState, StartNo, EndNo, FirstOfType)
	local DynNo
	local	Found
	local	Count = 0
	for DynNo=StartNo, EndNo-1 do
		if DynastyGetDiplomacyState("Dynasties"..(StartNo-1), "Dynasties"..DynNo)==DIP_NEUTRAL then
			if defaultcampaign_GetStateCount("Dynasties"..DynNo, DipState, EndNo) < MaxState then
				Count = Count + 1
				if Rand(100) <= 100/Count then
					Found = "Dynasties"..DynNo
					if FirstOfType and GetSettlementID("Dynasties"..(StartNo-1)) == GetSettlementID("Dynasties"..DynNo) then
						return Found
					end
				end
			end
		end
	end
	return Found
end

function GetStateCount(DynAlias, DipState, EndNo)
	local Count = 0
	local i
	local	Alias

	for i=0,EndNo-1 do
		Alias = "Dynasties"..i
		if Alias~=DynAlias then
			if DynastyGetDiplomacyState(DynAlias, Alias)==DipState then
				Count = Count + 1
			end
		end
	end
	
	return Count
end

-- this function is called right bevor starting the frames
function GameStart()
	defaultcampaign_InitiateGodModule()
end

function InitiateGodModule()
	local NumCities = ScenarioGetObjects("Settlement",10,"City")
	if NumCities > 0 then
		for i=0,NumCities-1 do
			if CityGetRandomBuilding("City"..i,GL_BUILDING_CLASS_PUBLICBUILDING,GL_BUILDING_TYPE_TOWNHALL,-1,-1,FILTER_IGNORE,"Townhall") then
				GetPosition("Townhall","TownhallPos")
				Position2GuildObject("TownhallPos","CityGodModule")
				local CityID = GetID("City"..i)
				SetProperty("CityGodModule","CityID",CityID)
				MeasureRun("CityGodModule",nil,"CityControl",true)
			end
		end
	end	
end

