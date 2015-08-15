function Run()

	local MaxDistance = 1000
	local ActionDistance = 50
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil, true) then
		StopMeasure()
	end
	
	
	
	feedback_OverheadActionName("Destination")
	PlayAnimation("","watch_for_guard")
	if GetImpactValue("Destination","REVOLT")==0 then
		CommitAction("rob", "", "Destination", "Destination")
	end
	PlayAnimation("","manipulate_bottom_r")
	local Booty = Plunder("", "Destination",1)
	SetMeasureRepeat(TimeOut)
	if Booty > 0 then
		--for the mission
		mission_ScoreCrime("",Booty)
		feedback_MessageCharacter("","@L_BATTLE_FIGHTROB_MSG_SUCCESS_OWNER_HEAD_+0",
						"@L_BATTLE_FIGHTROB_MSG_SUCCESS_OWNER_BODY_+0",GetID("Destination"))
		MsgNewsNoWait("Destination","","","intrigue",-1,
						"@L_BATTLE_FIGHTROB_MSG_SUCCESS_VICTIM_HEAD_+0",
						"@L_BATTLE_FIGHTROB_MSG_SUCCESS_VICTIM_BODY_+0",GetID("Destination"),GetID(""))
		chr_GainXP("",GetData("BaseXP"))
	else
		local Level = SimGetLevel("Destination")
		local MoneyToSteal = Level*50+Level*(Rand(100))
		CreditMoney("",MoneyToSteal,"IncomeRobber")
		chr_GainXP("",GetData("BaseXP"))
		mission_ScoreCrime("",MoneyToSteal)
		--MsgQuick("","@L_BATTLE_FIGHTROB_FAILED_+0",GetID("Destination"))
	end
	Sleep(2)
	
	StopAction("rob", "")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

