function Init()
		
	if not GetDynasty("Destination", "VictimDyn") then 
		return
	end
	
	--check if other dynasty blocks the house
	if HasProperty("Destination", "RobberProtected") then
		--Feedback here
		local iCurrentRobberID = GetProperty("Destination", "RobberProtected")
		local iMyDynID = GetDynastyID("")
		GetAliasByID(iCurrentRobberID,"CurrentRobberAlias")
		if (iMyDynID ~= iCurrentRobberID) then
			MsgQuick("","@L_ROBBER_134_PRESSPROTECTIONMONEY_PROTECTED",GetID("CurrentRobberAlias"))
			StopMeasure()
		end
	end
end

function AIInitPressProtMoneyVictim()
	if Rand(100) > 20 then
		return "O"
	else
		return "C"
	end
end

function AIInitPressProtMoneyOffender()
	return "O"
end


function Run()

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not GetDynasty("Destination", "VictimDyn") then 
		StopMeasure()
	end
	
	if not SimGetWorkingPlace("","MyRobberCamp") then
		StopMeasure()
	end
	
	if not BuildingGetOwner("MyRobberCamp","MrRobber") then
		StopMeasure()
	end
	local fRobberShare = 4
	local fTotalRobberCnt = GetData("_MEMBER_CNT")
	if not fTotalRobberCnt then
		fTotalRobberCnt = 1
	end
		
	-- insert the money stuff here - potential income for this time e.g.	
	local fTotalMoney = math.floor((BuildingGetLevel("Destination") * 250+(BuildingGetValue("Destination")*0.02))*(1+GetSkillValue("MrRobber",SHADOW_ARTS)*0.02))
	if BuildingGetType("Destination") == GL_BUILDING_TYPE_MINE then
		fTotalMoney = fTotalMoney+500
	end
	if GetMoney("VictimDyn")<fTotalMoney then
		fTotalMoney = GetMoney("VictimDyn")
	end
	
	--for the ai
	if DynastyIsAI("MrRobber") then
		if fTotalMoney < 400 then
			StopMeasure()
		end
	end
	
	if fTotalMoney < 250 then
		fTotalMoney = 250
	end
	
	SetProperty("","TotalMoney",fTotalMoney)
	
	--ask for action
	local ActionDecision = MsgNews("MrRobber","Destination","@P"..
					"@B[O,@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_ACTOR_BTN_+0]"..
					"@B[C,@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_ACTOR_BTN_+1]",
					ms_134_pressprotectionmoney_AIInitPressProtMoneyOffender,
					"intrigue",
					0,
					"@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_ACTOR_HEAD_+0",
					"@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_ACTOR_BODY_+0",
					fTotalMoney, GetID("Destination"))

	if ActionDecision=="C" then
		StopMeasure()
	end	
	
	--move to house
	if not GetOutdoorMovePosition("", "Destination", "DoorPos") then
		StopMeasure()
	end
	if not f_MoveTo("", "DoorPos", GL_MOVESPEED_RUN) then
		StopMeasure()
	end

	-- has already protected this house?
	--local iCurrentProtID = GetProperty("", "RobberProtecting")
	--local bRestarted = (iCurrentProtID ~= -1) and (iVictimID == iCurrentProtID)

	local iVictimID = GetID("Destination")
	local iCurrentRobberCnt = GetProperty("Destination", "RobberCnt")
	if (iCurrentRobberCnt == NIL) then
		iCurrentRobberCnt = 0
		local iMyDynID = GetDynastyID("")
		SetProperty("Destination", "RobberProtected", iMyDynID)
	end	
	iCurrentRobberCnt = iCurrentRobberCnt+1
	SetProperty("Destination", "RobberCnt", iCurrentRobberCnt)

	-- check if i am the first to ask
	if (iCurrentRobberCnt == 1) then
	
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
		BuildingGetOwner("MyRobbercamp","MrRobber")
		BuildingGetOwner("Destination","MrProtectionMoney")
		local OwnerID = GetID("MrRobber")
	
		fRobberShare = fRobberShare * fTotalRobberCnt
	
		--waits for 1 hour
		local result = MsgNews("Destination","Destination","@P"..
				"@B[O,@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_VICTIM_BTN_+0]"..
				"@B[C,@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_VICTIM_BTN_+1]",
				ms_134_pressprotectionmoney_AIInitPressProtMoneyVictim,"default",1,
				"@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_VICTIM_HEAD_+0",
				"@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_VICTIM_BODY_+0", 
				GetID("MrRobber"),GetID("Destination"), fTotalMoney)
		if result=="O" then
			--wants to pay
			feedback_MessageCharacter("",
				"@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_ACTOR_POS_ANSWER_HEAD_+0",
				"@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_ACTOR_POS_ANSWER_BODY_+0",
				GetID("Destination"), fTotalMoney)
			
			--force dynasty relations to neutral
			DynastySetMinDiplomacyState("", "Destination", DIP_NEUTRAL, OwnerID, fMeasureDuration)
			DynastyForceCalcDiplomacy("")
			DynastyForceCalcDiplomacy("Destination")
			SetProperty("", "RobberProtecting", iVictimID)
			SetState("", STATE_ROBBERGUARD, true)
			StopMeasure()
		else
			--doesnt wanna pay
			feedback_MessageCharacter("",
				"@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_ACTOR_NEG_ANSWER_HEAD_+0",
				"@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_ACTOR_NEG_ANSWER_BODY_+0",
				GetID("MrProtectionMoney"), GetID("Destination"))
			-- cancel measure
			RemoveProperty("Destination","RobberProtected")
			SetMeasureRepeat(TimeOut)
			MeasureRun("","Destination","PlunderBuilding")
			StopMeasure()
		end
	end
end

function CleanUp()
	if not GetState("",STATE_ROBBERGUARD) then
		if HasProperty("","TotalMoney") then
			RemoveProperty("","TotalMoney")
		end
		if HasProperty("Destination","RobberCnt") then
			RemoveProperty("Destination","RobberCnt")
		end
	end
end

function GetOSHData(MeasureID)
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",12)
end

