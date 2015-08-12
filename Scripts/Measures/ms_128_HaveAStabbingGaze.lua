-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_128_HaveAStabbingGaze"
----
----	with this privilege the office bearer can decrease the victims 
----	rhetoric by 3
----	
----
-------------------------------------------------------------------------------

function Run()
	if (GetState("", STATE_CUTSCENE)) then
		ms_128_haveastabbinggaze_Cutscene()
	else
		ms_128_haveastabbinggaze_Normal()
	end
end


function Normal()

	--how far the Destination can be to start this action
	local MaxDistance = 3000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 120
	--time before privilege can be used again
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	--favorloss of destination to owner
	local favorloss = 5
	MeasureSetNotRestartable()
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	
	Sleep(0.5)
	PlayAnimationNoWait("","threat")
	Sleep(1)
	PlayAnimation("Destination","appal")
	
	SetRepeatTimer("", GetMeasureRepeatName2("UncannyGlare"), TimeOut)
	
	AddImpact("Destination","rhetoric",-3,duration)
	chr_ModifyFavor("Destination","",-favorloss)
	feedback_OverheadSkill("Destination", "@L_ARTEFACTS_OVERHEAD_+1", false, 
			"@L_TALENTS_rhetoric_ICON_+0", "@L_TALENTS_rhetoric_NAME_+0", 3)

	MsgNewsNoWait("Destination","","","intrigue",-1,
		"@L_PRIVILEGES_128_HAVEASTABBINGGAZE_MESSAGE_HEAD_+0",
		"@L_PRIVILEGES_128_HAVEASTABBINGGAZE_MESSAGE_BODY_+0",GetID(""),GetID("Destination"))
	Sleep(1)
	
	feedback_OverheadComment("Destination",	"@L$S[2006] %1n", false, false, favorloss)
	Sleep(1)
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()
end



function Cutscene()

	if SimGetCutscene("","cutscene") then
		CutsceneSetMeasureLockTime("cutscene", 2.0)
	end
	
	Sleep(1)
	
	--how far the Destination can be to start this action
	local MaxDistance = 3000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 120
	--time before privilege can be used again
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	--time the rhetoric is down
	local duration = mdata_GetDuration(MeasureID)
	--favorloss of destination to owner
	local favorloss = 5
	MeasureSetNotRestartable()
	--run to destination and start action at MaxDistance
--	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
--		StopMeasure()
--	end
	
	
	SetRepeatTimer("", GetMeasureRepeatName2("UncannyGlare"), TimeOut)
	
	AddImpact("Destination","rhetoric",-3,duration)
	chr_ModifyFavor("Destination","",-favorloss)
	
	if SimGetCutscene("","cutscene") then
		CutsceneCallUnscheduled("cutscene", "UpdatePanel")
		Sleep(0.1)
	else
		return
	end	
		
	feedback_OverheadSkill("Destination", "@L_ARTEFACTS_OVERHEAD_+1", false, 
			"@L_TALENTS_rhetoric_ICON_+0", "@L_TALENTS_rhetoric_NAME_+0", 3)

	MsgNewsNoWait("Destination","","","intrigue",-1,
		"@L_PRIVILEGES_128_HAVEASTABBINGGAZE_MESSAGE_HEAD_+0",
		"@L_PRIVILEGES_128_HAVEASTABBINGGAZE_MESSAGE_BODY_+0",GetID(""),GetID("Destination"))
	Sleep(1)
	
	feedback_OverheadComment("Destination",	"@L$S[2006] %1n", false, false, favorloss)
	Sleep(1)
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()
end

function CleanUp()

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

