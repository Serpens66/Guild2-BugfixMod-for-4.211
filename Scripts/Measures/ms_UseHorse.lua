function Init()
end

function Run()		
	local IsBuilding = false
	if IsType("Destination","Building") and BuildingCanBeEntered("Destination","") then
		IsBuilding = true
	end
	
	local costs = 0.5 * GetDistance("","Destination")
	
	local DecisionBtns = "@B[1,@L_USE_HORSE_DECISION_BUTTON_+0]@B[0,@L_USE_HORSE_DECISION_BUTTON_+1]"
	
	if costs > GetMoney("") then
		DecisionBtns = "@B[0,@L_USE_HORSE_DECISION_BUTTON_+2]"
	end
	
	local Result = MsgBox("","", "@P"..
		DecisionBtns,
		"@L_USE_HORSE_DECISION_HEAD_+0",
		"@L_USE_HORSE_DECISION_BODY_+0",
		GetID(""), costs)
		
	if Result ~= 1 then
		SetProperty("","aborted",1)
		StopMeasure()
	end
	SetProperty("","aborted",0)
	
	if not SpendMoney("", costs, "travelling") then
		MsgQuick("", "@L_USE_HORSE_FAILURE_+1")
		StopMeasure()
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)
	-- SetMeasureRepeat(TimeUntilRepeat)
	
	Mount("")
	-- MoveSetActivity("","ride")
	SetState("", STATE_RIDING, true)
	
	GetVehicle("","Horse")

	PlaySound3DVariation("","Animals/Horse/whinny",1)
	
	if IsBuilding then 
		if not GetOutdoorMovePosition("", "Destination", "Target") then
			CopyAlias("Destination","Target")
		end
	else
		CopyAlias("Destination","Target")
	end
	
	if not f_MoveTo("Horse", "Target", GL_MOVESPEED_RUN, 15) then
	--if not f_MoveTo("", "Target", GL_MOVESPEED_RUN, 15) then
		StopMeasure()
	end
	Sleep(5)
	
	-- MoveSetActivity("","")
	Unmount("")
	SetState("", STATE_RIDING, false)
	
	if IsBuilding then
		f_MoveTo("","Destination")
	end
end

function CleanUp()
	if HasProperty("","aborted") and GetProperty("","aborted") == 0 then
		Sleep(1)
		MoveSetActivity("","")
		Unmount("")
		SetState("", STATE_RIDING, false)
		local refunds = 0.25 * GetDistance("","Destination")
		if refunds > 1000 then
			CreditMoney("", refunds, "")
			MsgQuick("","@L_USE_HORSE_CANCEL_+0",GetID(""),refunds)
		end
		RemoveProperty("","aborted")
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
