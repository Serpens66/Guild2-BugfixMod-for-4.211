function AIInitPressProtMoneyVictim()

    GetDynasty("Destination", "VictimDyn")
	local w = BuildingGetLevel("Destination")
	local p = 500 * w
	local kivermog = GetMoney("VictimDyn")
    if ((kivermog / 100) * 50) < p then
	    return "C"
	end

	if Rand(100) > 20 then
		return "O"
	else
		return "C"
	end

end

function Run()
	
	if not GetDynasty("Destination", "VictimDyn") then 
		StopMeasure()
	end

    if DynastyGetDiplomacyState("","VictimDyn")<DIP_NEUTRAL then
	    MsgQuick("","@L_MEASURE_OFFERBUILDINGPROTECTION_FAIL_+0")
	    StopMeasure()
	end
	
	if HasProperty("Destination", "RobberProtected") then
		MsgQuick("","@L_MEASURE_OFFERBUILDINGPROTECTION_FAIL_+1")
		StopMeasure()
	end
	
	if not SimGetWorkingPlace("","MyRobberCamp") then
		StopMeasure()
	end
	
	if not BuildingGetOwner("MyRobberCamp","MrRobber") then
		StopMeasure()
	end
		
	local wert = BuildingGetLevel("Destination")
	local preis = 500 * wert
	
	if GetMoney("VictimDyn") < preis then
	    MsgQuick("","@L_MEASURE_OFFERBUILDINGPROTECTION_FAIL_+2")
	    StopMeasure()
	end
	
	--move to house
	if not GetOutdoorMovePosition("", "Destination", "DoorPos") then
		StopMeasure()
	end
	if not f_MoveTo("", "DoorPos", GL_MOVESPEED_RUN) then
		StopMeasure()
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local iMyDynID = GetDynastyID("")
	local iVictimID = GetID("Destination")
	SetProperty("Destination", "RobberProtected", iMyDynID)


		BuildingGetOwner("MyRobbercamp","MrRobber")
		BuildingGetOwner("Destination","MrProtectionMoney")
		local OwnerID = GetID("MrRobber")

		--waits for 1 hour
		local result = MsgNews("Destination","Destination","@P"..
				"@B[O,@L_MEASURE_OFFERBUILDINGPROTECTION_SAY_+0]"..
				"@B[C,@L_MEASURE_OFFERBUILDINGPROTECTION_SAY_+1]",
				ms_offerbuildingprotection_AIInitPressProtMoneyVictim,"default",1,
				"@L_MEASURE_OFFERBUILDINGPROTECTION_HEAD_+0",
				"@L_MEASURE_OFFERBUILDINGPROTECTION_BODY_+0", 
				GetID("MrRobber"),GetID("Destination"), preis)
		if result=="O" then
			--wants to pay
			feedback_MessageCharacter("",
				"@L_MEASURE_OFFERBUILDINGPROTECTION_HEAD_+1",
				"@L_MEASURE_OFFERBUILDINGPROTECTION_BODY_+1",
				GetID("Destination"), preis)
      	    SetMeasureRepeat(TimeOut)
			SetProperty("","TotalMoney",preis)
			SetProperty("", "RobberProtecting", iVictimID)
			SetState("", 44, true)
			--MeasureRun("","Destination","ProtectBuilding")
			StopMeasure()
		else
			--doesnt wanna pay
			feedback_MessageCharacter("",
				"@L_MEASURE_OFFERBUILDINGPROTECTION_HEAD_+2",
				"@L_MEASURE_OFFERBUILDINGPROTECTION_BODY_+2",
				GetID("MrProtectionMoney"), GetID("Destination"))
			-- cancel measure
			RemoveProperty("Destination","RobberProtected")
			SetMeasureRepeat(TimeOut)
			StopMeasure()
		end

end

function CleanUp()

end

function GetOSHData(MeasureID)
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",12)
end

