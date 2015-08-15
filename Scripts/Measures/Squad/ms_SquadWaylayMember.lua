function Run()

	Sleep(0.5)
	MeasureSetNotRestartable()
	local	Member = GetData("Member")
	if not Member or Member==-1 then
		return
	end
	
	if not SquadGet("", "Squad") then
		return
	end
	
	if not SquadGetMeetingPlace("Squad", "Destination") then
		return
	end
	
	if not SimGetWorkingPlace("","MyRobbercamp") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_ROBBER)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"MyRobbercamp")
		else
			StopMeasure()
		end
	end
		
	local	ToDo
	local	Success
	SetData("InventoryFull",0)
	local	IdleStep = 3
    SetData("Tarnung",0)	
	
	while true do
		
		ToDo = ms_squadwaylaymember_WhatToDo()
		Success = false
		
		if HasProperty("","Plunder") then
			local victim = GetProperty("","Plunder")
			GetAliasByID(victim,"Victim")
			if AliasExists("Victim") then
				ToDo = "plunder"
			end
		end
		
		if ToDo=="return" then
			if GetData("InventoryFull")==1 then
				Success = ms_squadwaylaymember_Wait(IdleStep)
				IdleStep = IdleStep + 1
			else
				Success = ms_squadwaylaymember_ReturnToBase()
			end
			if not Success then
				SetData("InventoryFull",1)
			end
		elseif ToDo=="wait" then
			Success = ms_squadwaylaymember_Wait(IdleStep)
			IdleStep = IdleStep + 1
		elseif ToDo=="attack" then
			Success = ms_squadwaylaymember_Attack()
		elseif ToDo=="plunder" then
			Success = ms_squadwaylaymember_Plunder()
		end
		
		if not Success then
			Sleep(4)
		end
		
	end
end

function Wait(IdleStep)

		if HasProperty("Squad", "PrimaryTarget") then
			RemoveProperty("Squad", "PrimaryTarget")
		end
		
		-- normal wait behavior
		local	Distance = GetDistance("", "Destination")
		if Distance > 500 then
			local Range = Rand(400)
			if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,Range) then
				return
			end		
		end
		
		if (IdleStep>2) then
			if GetData("InevntoryFull")==0 then
				ms_squadwaylaymember_IdleStuff()
				IdleStep = 0
			end
		end
		
		
		local	ItemId
		local	Found
		local RemainingSpace
		local Removed 
		
		local Count = InventoryGetSlotCount("", INVENTORY_STD)
		for i=0,Count-1 do
			ItemId, Found = InventoryGetSlotInfo("", i, INVENTORY_STD)
			if ItemId and ItemId>0 and Found>0 then
				RemainingSpace	= GetRemainingInventorySpace("MyRobbercamp",ItemId)
				if Found < RemainingSpace then
					SetData("InventoryFull",0)
					return true
				end
			end
		end
		
    GetPosition("","standPos")
	PlayAnimationNoWait("","crouch_down")
	Sleep(1)
	if GetData("Tarnung") == 0 then
	    if Rand(2) == 0 then
            GfxAttachObject("tarn","Outdoor/Bushes/bush_09_big.nif")
	    else
	        GfxAttachObject("tarn","Outdoor/Bushes/bush_10_big.nif")
	    end
	    GfxSetPositionTo("tarn","standPos")
		SetData("Tarnung",1)
	end
		
		SetState("", STATE_HIDDEN, true)
		
		SetProperty("", "WaylayReady", 1)
		Sleep(1 + Rand(20)*0.1)
		RemoveProperty("", "WaylayReady")
end

function IdleStuff()
	if Rand(3)==0 then
		PlayAnimationNoWait("","sentinel_idle")
	elseif Rand(3)==1 then
		CarryObject("","Handheld_Device/ANIM_telescope.nif",false)
		PlayAnimation("","scout_object")
		CarryObject("","",false)
	end
	GfxSetRotation("",0,Rand(360),0,false)
end

function WhatToDo()

	local	Total = 0
	local Count = InventoryGetSlotCount("", INVENTORY_STD)
	if Count>0 then
		for i=0,Count-1 do
			local ItemId
			local	SlotCount 
			
			ItemId, SlotCount = InventoryGetSlotInfo("", i, INVENTORY_STD)
			if ItemId and ItemId>0 then
				Total = Total + SlotCount
			end
		end
	end
	
	if Total>0 then
		return "return"
	end

	if not HasProperty("Squad", "PrimaryTarget") then
		local Target = ms_squadwaylaymember_Scan("")
		if Target then
			return "attack"
		end
		return "wait"
	end
	
	local	TargetID = GetProperty("Squad", "PrimaryTarget")
	if TargetID < 1 then
		return "wait"
	end	
	
	if not GetAliasByID(TargetID, "Victim") then
		return "wait"
	end
	
	if chr_GetBootyCount("Victim", INVENTORY_STD) <= 0 then
		return "wait"
	end
	
	if GetState("Victim", STATE_ACTIVE_ESCORT) then
		return "attack"
	end
	
	if IsType("Victim","Sim") then
		if not(GetState("Victim",STATE_UNCONSCIOUS)) then
			if not(GetState("Victim",STATE_DEAD)) then
				return "wait"
			end
		end
	else
		-- cart part
		if CartGetOperator("Victim", "Operator") then
			if not GetState("Operator", STATE_DRIVERATTACKED) then
				return "wait"
			end
		end
	end
	
	return "plunder"
end

function ReturnToBase()

	local TransitionTime
	TransitionTime = MoveSetActivity("","carry")
	Sleep(2)
	CarryObject("", "Handheld_Device/ANIM_Bag.nif", false)

	Sleep(TransitionTime - 2)

	GetOutdoorMovePosition("","MyRobbercamp","MovePos")

	if not f_MoveTo("","MovePos") then
		return false
	end

	local	ItemId
	local	Found
	local RemainingSpace
	local Removed 

	local Count = InventoryGetSlotCount("", INVENTORY_STD)
	for i=0,Count-1 do
		ItemId, Found = InventoryGetSlotInfo("", i, INVENTORY_STD)
		if ItemId and ItemId>0 and Found>0 then
			RemainingSpace	= GetRemainingInventorySpace("MyRobbercamp",ItemId)
			if Found > RemainingSpace then
				MsgQuick("MyRobbercamp","@L_GENERAL_INFORMATION_INVENTORY_INVENTORY_FULL_+1",GetID("MyRobbercamp"),ItemGetLabel(ItemId,false))
				-- added by Napi
				RemoveItems("",ItemId, Found, INVENTORY_STD) --1
				RemoveItems("",ItemId, Found, INVENTORY_STD) --2
				RemoveItems("",ItemId, Found, INVENTORY_STD) --3
				RemoveItems("",ItemId, Found, INVENTORY_STD) --4
				RemoveItems("",ItemId, Found, INVENTORY_STD) --5
				
				TransitionTime = MoveSetActivity("","")
				Sleep(2)
				CarryObject("","",false)
				Sleep(TransitionTime - 2)
				
				--SquadDestroy("Squad")
				return false
			end
			Removed		= RemoveItems("", ItemId, RemainingSpace)
			if Removed>0 then
				AddItems("MyRobbercamp", ItemId, Removed)
			end
			
		end
	end
	TransitionTime = MoveSetActivity("","")
	Sleep(2)
	CarryObject("","",false)
	Sleep(TransitionTime - 2)
	return true
end


function Attack()

  GfxDetachAllObjects()
	SetData("Tarnung",0)
	SetState("", STATE_HIDDEN, false)

	CommitAction("attackcart", "", "Victim")
	
	SetProperty("Squad","PrimaryTarget",GetID("Victim"))
	
	if IsType("Victim","Cart") then
		SetState("Victim", STATE_ACTIVE_ESCORT, true)
		if GetImpactValue("Victim","messagesent")==0 then
			GetPosition("Victim","ParticleSpawnPos")
			PlaySound3D("Victim","fire/Explosion_01.wav", 1.0)
			StartSingleShotParticle("particles/Explosion.nif", "ParticleSpawnPos", 1,5)
			
			AddImpact("Victim","messagesent",1,3)
			feedback_MessageMilitary("Victim",
				"@L_ROBBER_135_WAYLAYFORBOOTY_VICTIM_HEAD_+0",
				"@L_ROBBER_135_WAYLAYFORBOOTY_VICTIM_BODY_+0")
		
		end
		if CartGetOperator("Victim", "Operator") then
			SetState("Operator", STATE_DRIVERATTACKED, true)
		end
		
		SetProperty("","Plunder",GetID("Victim"))
	end
end


function Plunder()

  GfxDetachAllObjects()
	SetData("Tarnung",0)
	SetState("", STATE_HIDDEN, false)

	if not f_MoveTo("", "Victim", GL_MOVESPEED_RUN, 100) then
		return false
	end
	
	if GetID("Victim")~=GetProperty("Squad", "PrimaryTarget") then
		return false
	end
	
	if IsType("Victim","Cart") then
		if CartGetOperator("Victim", "Operator") then
			if not GetState("Operator", STATE_DRIVERATTACKED) then
				PlayAnimation("","cheer_02")
				return false
			end
		end
	end
	
	SetProperty("","DontLeave", 1)
	StopAction("attackcart", "")
	CommitAction("plunder", "", "Victim")
	Sleep(2)
	
	if IsType("Victim","Sim") then
		local Money = 0.1*GetMoney("Victim")
		chr_RecieveMoney("Dynasty",Money,"IncomeRobbers")
		--for the mission
		mission_ScoreCrime("Dynasty",Money)
		SpendMoney("Victim",Money,"CostRobbers")
		ItemValue = Plunder("", "Victim",10)
		if ItemValue > 0 then
		--for the mission
			mission_ScoreCrime("Dynasty",ItemValue)
		end
	elseif IsType("Victim","Cart") then
		ItemValue = Plunder("", "Victim",10)
		if ItemValue > 0 then
			--for the mission
			mission_ScoreCrime("Dynasty",ItemValue)
		end
	end
	
	StopAction("plunder", "")
	RemoveProperty("","DontLeave")
	RemoveProperty("","Plunder")

	return true
end

function Scan(Member)
	
	-- constants
	local MinBooty = 50
	local BootyRadius = 1000
	local RobberRadius = 1000
	
	local Count
	local BootyFilterSim = "__F((Object.GetObjectsByRadius(Sim) == "..BootyRadius..")AND NOT(Object.BelongsToMe())AND(Object.ActionAdmissible()))"
	local BootyFilterCart = "__F((Object.GetObjectsByRadius(Cart) == "..BootyRadius..")AND NOT(Object.BelongsToMe())AND NOT(Object.HasImpact(Invisible))AND(Object.ActionAdmissible()))"

	-- waylay on sims deactivated
	local NumVictimSims = 0 -- Find("Destination",BootyFilterSim,"VictimSim", -1)
	local NumVictimCarts = Find("Destination",BootyFilterCart,"VictimCart", -1)
	local NumOwnRobbers = SquadGetMemberCount("")
	local Attack = 0
	
	if NumVictimSims <= 0 and NumVictimCarts <= 0 then --booty sims found
		return
	end

	local CurrentTargetValue = 0
	local MaxTargetValue = 0
	local	Num
	local	TargetAlias
	
	for check=0,1 do
		if check==0 then
			--check the booty from the sims
			Num = NumVictimSims
			TargetAlias = "VictimSim"
		else
		--check the booty from the carts
			Num = NumVictimCarts
			TargetAlias = "VictimCart"
		end
		
		for FoundObject=0,Num-1 do
			if DynastyGetDiplomacyState("Dynasty",TargetAlias..FoundObject)<=DIP_NEUTRAL then --no attack agreement, no booty
				CurrentTargetValue = chr_GetBootyCount(TargetAlias..FoundObject,INVENTORY_STD)
				if (CurrentTargetValue > MaxTargetValue) then
					CopyAlias(TargetAlias..FoundObject,"Victim")
					MaxTargetValue = CurrentTargetValue
				end
			end
		end
	end
		
	--check if booty is enough
	Sleep(0.7)
		
	if MaxTargetValue < MinBooty then
		return
	end
	
	--check the forces
	
	local	Att
	local	Def
	Att, Def = ai_CheckForces(Member, "Victim", BootyRadius)
	
	Attack = false

	if Def>0 then

		local	Quote = Att / Def
	
		--we are more, so attack 'em
		if Quote < 0.5 then
			Attack = true
		elseif Quote > 2 then
			Attack = false
		else
			Attack =  (MaxTargetValue > MinBooty + 1500*Quote)
		end
	end
	
	if not Attack then
		return
	end
		
	--start attack

	AlignTo("","Victim")
	Sleep(1)
	
	return "Victim"
end

function CleanUp()
	StopAction("plunder", "")
	CarryObject("","",false)
	RemoveProperty("", "WaylayReady")
	GfxDetachAllObjects()
	SetState("", STATE_HIDDEN, false)
	StopAnimation("")
	MoveSetActivity("","")
	if not HasProperty("","DontLeave") then
		SquadRemoveMember("", true)
		if AliasExists("Squad") then
			if SquadGetMemberCount("Squad", true)<1 then
				SquadDestroy("Squad")
			end
		end
	else
		RemoveProperty("","DontLeave")
	end

	if not GetState("",STATE_FIGHTING) then
		if HasProperty("","Plunder") then
			local victim = GetProperty("","Plunder")
			GetAliasByID(victim,"Victim")
			if AliasExists("Victim") then
				if not IsType("Victim","Sim") then
					if CartGetOperator("Victim", "Operator") then
						if GetState("Operator",STATE_DRIVERATTACKED) then
							SetState("Operator", STATE_DRIVERATTACKED, false)
						end
					end
				end
			end
			RemoveProperty("","Plunder")
		end
	end

end

