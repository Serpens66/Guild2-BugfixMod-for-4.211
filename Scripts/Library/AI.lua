-- -----------------------
-- StartBuildingAction  
--
-- 
-- -----------------------
function StartBuildingAction(FirstSim, SecondSim, BuildingClass, BuildingType, BuildingAlias)

	local	IsOk1
	local IsOk2
	local BuildingAlias1
	local BuildingAlias2
	
	IsOk1, BuildingAlias1 = ai_CheckInsideBuilding(FirstSim, BuildingClass, BuildingType, BuildingAlias)
	IsOk2, BuildingAlias2 = ai_CheckInsideBuilding(SecondSim, BuildingClass, BuildingType, BuildingAlias)
	
	if not BuildingAlias then
		if BuildingAlias1 then
			BuildingAlias = BuildingAlias1
		else
			BuildingAlias = BuildingAlias2
		end
	end
	
	if not BuildingAlias then
		if not GetNearestSettlement(FirstSim, "__SBA_City") then
			return false
		end
	
		if not CityGetRandomBuilding("__SBA_City", BuildingClass, BuildingType, -1, -1, FILTER_IGNORE, "__SBA_BUILDING") then
			return false
		end
		
		BuildingAlias = "__SBA_BUILDING"
	end
	
	if not IsOk1 and IsOk2 then
		if not BlockChar(SecondSim) then
			return false
		end
		
		if not f_MoveTo(FirstSim, BuildingAlias) then
			return false
		end
		
	elseif not IsOk2 then
		if not BlockChar(SecondSim) then
			return false
		end

		if not f_MoveToBuildingAction(FirstSim, SecondSim, -1, 200) then
			return false
		end

		if not f_FollowNoWait(SecondSim, FirstSim, GL_MOVESPEED_MOVE, 100) then
			return false
		end
		
		if not f_MoveTo(FirstSim, BuildingAlias) then
			return false
		end
	else
		if not BlockChar(SecondSim) then
			return false
		end
	end	
	
	return true
end

-- -----------------------
-- CheckInsideBuilding
-- -----------------------
function CheckInsideBuilding(SimAlias, BuildingClass, BuildingType, BuildingAlias)

	local InsideAlias = "__CIB_BUILDING_"..GetID(SimAlias)
	
	if not GetInsideBuilding(SimAlias, InsideAlias) then
		return false, nil
	end
	
	if BuildingAlias then
		if GetID(InsideAlias)==GetID(BuildingAlias) then
			return true, BuildingAlias
		end
		return false, BuildingAlias
	end
		
	if BuildingClass and BuildingClass~=-1 then
		if (BuildingGetClass(InsideAlias )~=BuildingClass) then
			return false, nil
		end
	end
	
	if BuildingType and BuildingType~=-1 then
		if (BuildingGetType(InsideAlias )~=BuildingType) then
			return false, nil
		end
	end
	
	return true, InsideAlias
end

function GoInsideBuilding(SimAlias, CityObject, BuildingClass, BuildingType, BuildingAlias)

	local	IsOk
	local	InsideAlias
	local CityID = -1
	
	if AliasExists(CityObject) then
		GetSettlement(CityObject, "__GIB_City")
	else
		GetSettlement(SimAlias, "__GIB_City")
	end
	
	IsOk, InsideAlias = ai_CheckInsideBuilding(SimAlias, BuildingClass, BuildingType, BuildingAlias)
	if IsOk then
		if GetSettlementID(InsideAlias)==GetID("__GIB_City") then
			CopyAlias(InsideAlias, BuildingAlias)
			return true
		end
	end

	if not BuildingAlias then
		BuildingAlias = "__GIB_Build"
	end

	if not AliasExists(BuildingAlias) then
		if not CityGetRandomBuilding("__GIB_City", BuildingClass, BuildingType, -1, -1, FILTER_IGNORE, BuildingAlias) then
			return false
		end
	end
	
	if GetInsideBuildingID(SimAlias) == GetID(BuildingAlias) then
		return true
	end
	
	return f_WeakMoveTo(SimAlias, BuildingAlias)
end

function StartInteraction(FirstPerson, TargetPerson, ReactionDistance, ActionDistance, CommandFunction, bForceNoErrorOnBlock)
	if not TargetPerson or not GetID(TargetPerson) then
		return
	end

	if IsType(TargetPerson, "Building") then
		GetOutdoorMovePosition(FirstPerson, TargetPerson, "_SI__MoveToPosition")
		local RetVal = f_MoveTo(FirstPerson, "_SI__MoveToPosition", GL_MOVESPEED_RUN, ActionDistance)
		if not (RetVal) then
			return false
		end
		AlignTo(FirstPerson, TargetPerson)
		Sleep(0.7)
		return true
	end

	local Distance
	local success = false
	-- timeout 8 hours
	local timeout = GetGametime() + 8

	ReactionDistance = ReactionDistance * 1.5

	while success == false do
	
		if not f_Follow(FirstPerson,TargetPerson,GL_MOVESPEED_RUN,ReactionDistance, true) then
			if not bForceNoErrorOnBlock then		
				return false
			end
		end
	
		if CommandFunction then
			success = SendCommandNoWait(TargetPerson, CommandFunction)
		else
			success = BlockChar(TargetPerson)
		end
			
		if not success then
		  -- check for timeout
		  local curGametime = GetGametime()
		  if timeout < GetGametime() then
			  if not bForceNoErrorOnBlock then
					if IsType(TargetPerson,"Building") then
						if IsPartyMember(FirstPerson) then
							MsgQuick(FirstPerson,"@L_GENERAL_MEASURES_FAILURES_+1", GetID(TargetPerson))
						end
					else
						if IsPartyMember(FirstPerson) then
							MsgQuick(FirstPerson,"@L_GENERAL_MEASURES_FAILURES_+0", GetID(TargetPerson), GetID(FirstPerson))
						end
					end
					return false
				end
			end
			
			if not bForceNoErrorOnBlock then
				Sleep(1)
			end
		end
	end
	
	-- move to destinaton
	if not (f_MoveTo(FirstPerson,TargetPerson, GL_MOVESPEED_WALK, ActionDistance)) then
		return false
	end
	
	if not (bForceNoErrorOnBlock) then
		AlignTo(FirstPerson, TargetPerson)
		AlignTo(TargetPerson, FirstPerson)
	end

	Sleep(1.0)
	
	return true
end

function ShowMoveError(result) 

	if result == NIL then
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+2")
	end

	if result == GL_MOVERESULT_ERROR_NOT_ENTERABLE then  
		if AliasExists("Destination") then
			if GetState("",STATE_FIGHTING) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_FIGHTING")
			elseif GetState("Destination",STATE_LEVELINGUP) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_LEVELUP")
			elseif GetState("Destination",STATE_BUILDING) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_BUILDING")
			elseif GetState("Destination",STATE_BURNING) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_BURNING")
			--elseif GetState("Destination",STATE_CONTAMINATED) then
				--MsgQuick("","@L_NEWSTUFF_NOENTER_CONTAMINATED")
			elseif GetState("Destination",STATE_CUTSCENE) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_SESSION")
			elseif GetState("Destination",STATE_DEAD) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_DEAD")
			elseif (GetHPRelative("Destination")<=0.2) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_CRITICALDAMAGE")
			--elseif (SimGetProfession("")==GL_PROFESSION_MYRMIDON) then
			--	MsgMeasure("","@L_NEWSTUFF_NOENTER_NOFIGHTERS")
			--MsgQuick("","@L_NEWSTUFF_NOENTER_CLOSED")
			else
				MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+3",GetID(""))
			end
		else
			MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+3",GetID(""))
		end
	elseif result == GL_MOVERESULT_ERROR_MOVEMENT_ABORTED then
		--MsgMeasure("", "@LMOVE_OVERHEAD_CANNOT_REACH_TARGET@T%1SN: Bewegungsabbruch.")
	elseif result == GL_MOVERESULT_ERROR_NOT_ENTERABLE_ILLEGAL_DEST then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+4",GetID(""))
	elseif result == GL_MOVERESULT_ERROR_TRANSITION_FAILED then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+5",GetID(""))	
	elseif result == GL_MOVERESULT_ERROR_TARGET_GONE then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+6",GetID(""))
	elseif result == GL_MOVERESULT_ERROR_TARGET_INACCESSIBLE then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+7",GetID(""))		
	elseif result == GL_MOVERESULT_ERROR_TARGET_UNREACHABLE then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+8",GetID(""))		
	elseif result == GL_MOVERESULT_ERROR_NOT_INITIALIZED then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+9",GetID(""))				
	elseif result == GL_MOVERESULT_ERROR_UNKNOWN_PATHFINDER then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+10",GetID(""))	
	else
		--strange things
		--	feedback_OverheadFadeText("", "@LMOVE_OVERHEAD_CANNOT_REACH_TARGET@T%1SN: Es wurde ein MoveTask unterbrochen der den Zustand IDLE hatte?!", false)
		--elseif result == GL_MOVERESULT_TARGET_REACHED then
		--	feedback_OverheadFadeText("", "@LMOVE_OVERHEAD_CANNOT_REACH_TARGET@T%1SN: Habe Ziel erreicht, aber es wurde Fehlerbehandlung aufgerufen?!", false)
		--else
	
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+11")
		
		--end
	end
	Sleep(1)	
end

function MultiMoveTo(...)
	-- always alternating Owner and Target

	local speed = arg[1]
	local range = arg[2]

	--count args
	local argoffset = 2
	local number = argoffset
	while arg[number+1]~=nil do
		number = number + 2
	end
	-- ignore the first args 
	number = number - argoffset
	number  = number / 2

	--start moving
	local steps
	local pos
	local MMResultName
	local objectarray = {}
	for steps = 0, number-1 do
		pos = argoffset + 1 + steps*2
		MMResultName = "mmresult_"..pos
		f_MoveToNoWait(arg[pos], arg[pos+1], speed, MMResultName, range)
		--copy objects to new array
		objectarray[steps] = MMResultName
	end
		
	while (number > 0) do
		-- check results of the objects
		for steps = 0, number-1 do
			local result = GetData(objectarray[steps])
			if ( result == GL_MOVERESULT_TARGET_REACHED) then
				--copy to end
				objectarray[steps] = objectarray[number-1]
				--shorten list
				number = number-1
			elseif (  result ~= nil ) then
				if (result > GL_MOVERESULT_ERROR_UNKNOWN) then
					return false
				end
			end				
		end
		Sleep(0.50)
	end
	return true 
end

function Transfer(Executer, Buyer, BuyerInv, Seller, SellerInv, Item, ItemCount)
	local ErrorNumber, Done = Transfer(Executer, Buyer, BuyerInv, Seller, SellerInv, Item, ItemCount)
	if ErrorNumber ~=TRANSFER_SUCCESS then
		ai_TransferError(ErrorNumber, Buyer, Seller, Item, ItemCount)
		return Done
	end
	return Done
end

function TransferError(ErrorNumber, BuyerAlias, SellerAlias, ItemId, ItemCount)

	if ErrorNumber==TRANSFER_SUCCESS then
		return
	end

	local TransferErrorList= 
	{
		[TRANSFER_RESULT_UNKNOWN] = "Unknown Error";
		[TRANSFER_ERROR_ILLEGAL] = "Illegal";
		[TRANSFER_ERROR_NO_MARKET] = "No market";
		[TRANSFER_ERROR_ILLEGAL_ITEM] = "Illegal item";
		[TRANSFER_ERROR_OUT_OF_RANGE] = "Out of range";
		[TRANSFER_ERROR_ILLEGAL_EXECUTER] = "Illegal executer";
		[TRANSFER_ERROR_NO_ITEM_AT_SOURCE] = "No item at source";
		[TRANSFER_ERROR_NO_SPACE_AT_DEST] = "No space at destination";
		[TRANSFER_ERROR_ACCESS_DENIED] = "Access denied";
		[TRANSFER_ERROR_NOT_COMPLETE_TRANSFER] = "not enough items for a complete transfer";
		[TRANSFER_ERROR_NOT_ENOUGH_MONEY] = "not enough money";
		[TRANSFER_ERROR_INVALID_ITEM] = "Invalid item"
	}
	
	local Text = TransferErrorList[ErrorNumber]
	if Text then
		local	BuyerName = "(unknown)"
		if AliasExists(BuyerAlias) then
			BuyerName = GetName(BuyerAlias)
		end

		local	SellerName = "(unknown)"
		if AliasExists(SellerAlias) then
			SellerName = GetName(SellerAlias)
		end
		
		local	ItemName = ItemGetName(ItemId)
		if not ItemName then
			ItemName = "(unknown)"
		end
		
		if not ItemCount then
			ItemCount = -1
		end
	end
end

function CanBuyItem(SimAlias, Item, Count, CityAlias, PlaceAlias)

	if not Count then
		Count = 1
	end
	
	if not PlaceAlias then
		PlaceAlias = "__AI_CBI_PLACE"
	end
	
	if not CityAlias then
		CityAlias = "__AI_CBI_CITY"
	end

	if not CanAddItems(SimAlias, Item, Count, INVENTORY_STD) then
		return -1
	end
	
	if not GetNearestSettlement(SimAlias, CityAlias) then
		return -1
	end
	
	local Price = CityGetSeller(CityAlias, SimAlias, Item, 1, PlaceAlias)

	return Price
end


function BuyItem(SimAlias, Item, ItemCount)

	if not ItemCount then
		ItemCount = 1
	end
	
	local PlaceAlias 	= "__AI_CBI_PLACE"
	local CityAlias 	= "__AI_CBI_CITY"
	local Price 			= ai_CanBuyItem(SimAlias, Item, ItemCount, CityAlias, AliasName)
	
	if Price<0 then
		return false
	end
	
	local	MoveToPos		= "__AI_CBI_MoveTo"
	local	eInv
	
	if IsType(PlaceAlias , "Building") then
		GetOutdoorMovePosition(SimAlias, PlaceAlias, MoveToPos)
		eInv = INVENTORY_SELL
	elseif IsType(PlaceAlias, "Market") then
		CityGetNearestBuilding(CityAlias, SimAlias, -1, GL_BUILDING_TYPE_MARKET, -1, -1, FILTER_IGNORE, MoveToPos)
		eInv = INVENTORY_STD
	end
	
	if not AliasExists(MoveToPos) then
		return false
	end
	
	if not f_MoveTo(SimAlias, MoveToPos) then
		return false
	end
	
	local Done = ai_Transfer(SimAlias, SimAlias, INVENTORY_STD, PlaceAlias, eInv, Item, ItemCount)
	return (Done >= ItemCount)
end

function CreateMutex(BaseAlias)
	local	PropertyName = "_MUTEX_"..SystemGetMeasureName()
	if HasProperty(BaseAlias, PropertyName) then
		return false
	end
	SetProperty(BaseAlias, PropertyName, GetID(""))
	return true
end

function CheckMutex(BaseAlias, MeasureName)
	local	PropertyName = "_MUTEX_"..MeasureName
	if HasProperty(BaseAlias, PropertyName) then
		return false
	end
	return true
end


function ReleaseMutex(BaseAlias)
	local	PropertyName = "_MUTEX_"..SystemGetMeasureName()
	local	Value = GetProperty(BaseAlias, PropertyName)
	
	if not Value or Value~=GetID("") then
		return fals
	end
	RemoveProperty(BaseAlias, PropertyName)
end

function IsDeploymentInProgress(SimAlias)

	local CurrentDeplicant
	local OfficeTask
	local	SimID = GetID(SimAlias)
	local Alias
	
	ListAllCutscenes("cutscene_list")
	local NumCutscenes = ListSize("cutscene_list")
	for iCutscene=0,NumCutscenes-1 do
		if ListGetElement("cutscene_list",iCutscene,"my_cutscene") and GetID("my_cutscene")~=-1 then
	
			local DepList_Count
			CutsceneGetData("my_cutscene","DepList_Count")
			DepList_Count = GetData("DepList_Count")
			
			if DepList_Count~=nil then
				for UseOffice = 1, DepList_Count, 1 do

					Alias = "DepList_"..(UseOffice).."_ID"
					CutsceneGetData("my_cutscene",Alias)
					OfficeTask  = GetData(Alias)

					Alias = "DepList_"..(OfficeTask).."_DepID"
					CutsceneGetData("my_cutscene",Alias)
					CurrentDeplicant = GetData(Alias)

					if CurrentDeplicant == SimID then
						return true
					end
					
				end
			end
		end
	end
	return false
end

function GetPower(SimAlias)

	local	WeaponDamage 	= SimGetWeaponDamage(SimAlias)
	local Damage		= gameplayformulas_GetDamage(SimAlias, WeaponDamage)
	local	Defence	 	= gameplayformulas_GetArmorValue(SimAlias)
	
	return Damage, Defence
end

function CheckForces(Agressor, Victim, Radius)

	if not Radius then
		Radius = 1000
	end

	local FoundCount
	local	AgressorID 		= GetDynastyID(Agressor)
	local	Alias
	local	Add
	local	Att
	local	Def
	
	local SuspectFilter = "__F((Object.GetObjectsByRadius(Sim) == "..Radius..")AND(Object.IsClass(4)))"
	FoundCount = Find(Victim,SuspectFilter,"Suspect",-1)
	
	local	DefAttack = 0
	local	DefArmor = 0
	local	DefCount = 0
	local DefTotal = 0
	
	for Count=0,FoundCount-1 do
		Alias = "Suspect"..Count
		Add = false
		if DynastyGetDiplomacyState(Alias, Victim)==DIP_ALLIANCE then --target has supporters from alliance
			Add = true
		elseif GetDynastyID(Alias)<1 and (SimGetProfession(Alias)==GL_PROFESSION_ELITEGUARD or SimGetProfession(Alias)==GL_PROFESSION_CITYGUARD) then
			Add = true
		end
		
		if Add then
			Att, Def = ai_GetPower(Alias)
			
			DefCount = DefCount + 1
			DefArmor	= DefArmor + Def
			DefAttack = DefAttack + Att
			DefTotal 	= DefTotal + GetHP(Alias)
		end
	end
	
	local AttackerFilter = "__F((Object.GetObjectsByRadius(Sim) == "..Radius..")AND(Object.IsClass(4)))"
	FoundCount = Find(Agressor,AttackerFilter,"Attacker",-1)

	local	AttCount 	= 0
	local AttArmor	= 0
	local AttAttack = 0
	local AttTotal 	= 0
	
	for Count=0,FoundCount-1 do
		Alias = "Attacker"..Count
		Add = false
		if GetDynastyID(Alias)==AgressorID then
			Add = true
		end
		
		if Add then
			Att, Def = ai_GetPower(Alias)
			
			AttCount 	= AttCount + 1
			AttArmor	= AttArmor + Def
			AttAttack = AttAttack + Att
			AttTotal 	= AttTotal + GetHP(Alias)
		end
		
	end
	
	if IsType(Agressor, "Sim") then
		Att, Def = ai_GetPower(Agressor)
		AttCount 	= AttCount + 1
		AttArmor	= AttArmor + Def
		AttAttack = AttAttack + Att
		AttTotal 	= AttTotal + GetHP(Agressor)
	end
	
	if IsType(Victim, "Sim") then
		Att, Def = ai_GetPower(Victim)
		DefCount 	= DefCount + 1
		DefArmor	= DefArmor + Def
		DefAttack = DefAttack + Att
		DefTotal 	= DefTotal + GetHP(Victim)
	end
	
	if IsType(Victim, "Cart") then
		local	Escort = CartGetEscortCount(Victim)
		if Escort>0 then
			Att	= 23
			Def = 10
			DefCount 	= DefCount + Escort
			DefArmor	= DefArmor + Def*Escort
			DefAttack = DefAttack + Att*Escort
			DefTotal 	= DefTotal + 100*Escort
		end
	end	
		
	if DefCount> 0 then
		DefArmor = DefArmor / DefCount
		DefAttack = DefAttack / DefCount
	end

	if AttCount> 0 then
		AttArmor = AttArmor / AttCount
		AttAttack = AttAttack / AttCount
	end
	
	DefAttack 	= DefCount*(DefAttack - DefAttack * AttArmor * 0.01)
	AttAttack 	= AttCount*(AttAttack - AttAttack * DefArmor * 0.01)
	
	if DefAttack<1 then
		DefAttack = 1
	end
	
	if AttAttack<1 then
		AttAttack = 1
	end
		
	return DefTotal/AttAttack, AttTotal/DefAttack
end

function GetNearestDynastyBuilding(Owner,BuildingClass,BuildingType)
	if not GetDynasty(Owner,"BuildingDynasty") then
		return false
	end
	local NumBuildings = DynastyGetBuildingCount("BuildingDynasty",BuildingClass,BuildingType)
	if NumBuildings <= 0 then
		return false
	end
	if GetInsideBuilding(Owner,"CurrentBuilding") then
		GetOutdoorMovePosition(Owner,"CurrentBuilding","CurrentPosition")
	else
		GetPosition(Owner,"CurrentPosition")
	end
	local CurrentDistance = 0
	local OldDistance = 500000
	for i=0,NumBuildings do
		if DynastyGetRandomBuilding("BuildingDynasty",BuildingClass,BuildingType,"RandomBuilding") then
			if GetOutdoorMovePosition(Owner,"RandomBuilding","MovePos") then
				CurrentDistance = GetDistance("CurrentPosition","MovePos")
			end
			if CurrentDistance < OldDistance then
				CopyAlias("RandomBuilding","NextBuilding")
				OldDistance = CurrentDistance
			end
		end		
	end
	if AliasExists("NextBuilding") then
		return "NextBuilding"
	else
		return false
	end	
end

function GetWorkBuilding(SimAlias, BuildingType, BuildAlias)
	if AliasExists(SimAlias) then
		if not IsPartyMember(SimAlias) then
			return SimGetWorkingPlace(SimAlias, BuildAlias)
		end
	
		if GetInsideBuilding(SimAlias, BuildAlias) then
			if BuildingGetType(BuildAlias)==BuildingType then
				if SimCanWorkHere(SimAlias, BuildAlias) then
					return true
				end
			end
		end
		
		local Count = DynastyGetBuildingCount2(SimAlias)
		for l=0,Count-1 do
			if DynastyGetBuilding2(SimAlias, l, BuildAlias) then
				if BuildingGetType(BuildAlias)==BuildingType then
					if SimCanWorkHere(SimAlias, BuildAlias) then
						return true
					end
				end
			end
		end
	end
	
	return false
end

function HasAccessToItem(SimAlias, ItemName)
	if GetItemCount(SimAlias, ItemName, INVENTORY_STD)>0 then
		return true
	end
	
	if GetItemCount(SimAlias, ItemName, INVENTORY_EQUIPMENT)>0 then
		return true
	end
	
	if SimGetWorkingPlace(SimAlias, "aihati_Place") then
	
		if GetItemCount("aihati_Place", ItemName, INVENTORY_STD)>0 then
			return true
		end
		
		if GetItemCount("aihati_Place", ItemName, INVENTORY_SELL)>0 then
			return true
		end
		
	end
	
	return false
end


function CheckTitleVSJewellery(SimAlias, ItemLevel, ModVal)

	local ReturnValue = 0
	local Title = GetNobilityTitle(SimAlias, false)
	local Level = SimGetLevel(SimAlias)
	
	if Title==ItemLevel then
		ReturnValue = ModVal
	elseif Title<ItemLevel then
		ReturnValue = ModVal - Title - (ItemLevel * 2)
	elseif Title>ItemLevel then
		if ItemLevel>4 then
			ReturnValue = ModVal
		else
			ReturnValue = ModVal - ItemLevel - (Title * 2)
		end
	end

	if ReturnValue==nil then
		return 0
	end

	if ReturnValue>0 then
		return ReturnValue
	else
		return 0
	end
end


function AICheckAction()

	local check = false
	local Difficulty = ScenarioGetDifficulty()
	local Round = GetRound()
	
	if Difficulty == 0 then
		if Round > 3 then
			check = true
		end
	elseif Difficulty == 1 then
		if Round > 2 then
			check = true
		end
	elseif Difficulty == 2 then
		if Round > 1 then
			check = true
		end
	elseif Difficulty == 3 then
		if Round > 0 then
			check = true
		end
	else
		check = true
	end

	return check
end

-------------------------------------------------------
-- Check Priority Functions
-------------------------------------------------------

function CalcNextDynastyGoal(DynastyAlias)
	if HasProperty(DynastyAlias, "Priority1") and GetProperty(DynastyAlias, "Priority1") ~= "none" then
		return
	end
	
	SetProperty(DynastyAlias, "Priority1", "none")
	
	if not HasProperty(DynastyAlias, "LastPriority1") then
		SetProperty(DynastyAlias, "LastPriority1", "none")
	end
	
	local LastPriority = GetProperty(DynastyAlias, "LastPriority1")
	
	
	local BuildingValue = ai_CalcBuildingGoal(DynastyAlias)
	local TitleValue = ai_CalcTitleGoal(DynastyAlias)
	local LevelUpValue = ai_CalcBuildingLevelGoal(DynastyAlias)
	ai_CalcItemBudget(DynastyAlias)
	local Value = BuildingValue
	local NextPriority  = "workshop"
	
	if TitleValue > Value then
		Value = TitleValue
		NextPriority = "title"
	end
	if LevelUpValue > Value then
		Value = LevelUpValue
		NextPriority = "leveluphome"
	end
	
	-- DEBUG START
	if not DynastyIsShadow(DynastyAlias) then
		DynastyGetMemberRandom(DynastyAlias, "member")
		local Name = SimGetLastname("member")
		LogMessage("@DynastyPrioritySystem "..Name..": "..NextPriority)
	end
	-- DEBUG END
	SetProperty(DynastyAlias, "Priority1", NextPriority)
	
	local Round = GetRound()
	if not HasProperty(DynastyAlias, "ItemBudget"..Round) then
		ai_CalcItemBudget(DynastyAlias)
	end
end

function CalcBuildingGoal(DynastyAlias)
	local Money = GetMoney(DynastyAlias)
	local WorkBuildingCount = DynastyGetBuildingCount(DynastyAlias, GL_BUILDING_CLASS_WORKSHOP)
	local BestNumberOfWorkshops = ai_GetBestNumberOfWorkshops(DynastyAlias)
	local Difference = BestNumberOfWorkshops - WorkBuildingCount
	
	return 50 + Difference * 10
end

function CalcTitleGoal(DynastyAlias)
	DynastyGetMemberRandom(DynastyAlias, "member")
	local Wealth = SimGetWealth("member")
	local Title = GetNobilityTitle("member")
	local Cost = GetDatabaseValue("NobilityTitle", Title+1, "price")
	if Cost == nil or Cost == "" then
		return 0
	end
	if Title < 4 then
		return 100
	elseif Title < 5 then
		if Wealth < 10000 then
			return 10
		end
		return 100	
	elseif Title < 6 then
		if Wealth < 25000 then
			return 10
		end
		return 100
	elseif Title < 7 then
		if Wealth < 70000 then
			return 10
		end
		return 90
	elseif Title < 8 then
		if Wealth < 150000 then
			return 10
		end
		return 90		
	elseif Title < 9 then
		if Wealth < 300000 then
			return 10
		end
		return 90
	else
		if Wealth < 700000 then
			return 0
		end
		return 70
	end
end

function CalcBuildingLevelGoal(DynastyAlias)
	local Value = 60
	DynastyGetMemberRandom(DynastyAlias, "member")
	GetHomeBuilding("member", "home")
	local HomeBuildingLevel = BuildingGetLevel("home")
	local Title = GetNobilityTitle("member")
	local Wealth = SimGetWealth("member")
	Value = Rand(10) + Value - HomeBuildingLevel*10 + 4*Title
	if Wealth > 100000 then
		Value = Value + 20
	elseif Wealth > 40000 then
		Value = Value + 10
	end
	
	return Value
end

function GetBestNumberOfWorkshops(DynastyAlias)
	DynastyGetMemberRandom(DynastyAlias, "member")
	local Title = GetNobilityTitle("member")
	local MaxNumber = GetMaxWorkshopCount(DynastyAlias)
	local BestNumber = 1
	if Title < 4 then
		BestNumber = 2
	elseif Title == 5 then
		BestNumber = 3
	elseif Title == 6 then
		BestNumber = 4
	else
		BestNumber = 7
	end
	
	return BestNumber
end

function CalcItemBudget(DynastyAlias)
	local Budget = GetMoney(DynastyAlias) * 0.25
	local Round = GetRound()
	if HasProperty(DynastyAlias, "ItemBudget"..Round) then
		return
	end
	
	if Round > 0 and HasProperty(DynastyAlias, "ItemBudget"..Round-1) then
		RemoveProperty(DynastyAlias, "ItemBudget"..Round-1)
	end
	
	if Budget < 100 then
		SetProperty(DynastyAlias, "ItemBudget"..Round, 0)
	else
		SetProperty(DynastyAlias, "ItemBudget"..Round, Budget)
	end
end
