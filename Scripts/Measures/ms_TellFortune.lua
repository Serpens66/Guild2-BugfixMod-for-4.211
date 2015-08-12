function Run()

	if not ai_GetWorkBuilding("", 102, "Juggler") then
		StopMeasure() 
		return
	end

	local	TimeOut
	TimeOut = GetData("TimeOut")
	if TimeOut then
		TimeOut = GetGametime() + TimeOut
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOuti = mdata_GetTimeOut(MeasureID)
  SetMeasureRepeat(TimeOuti)	
	
	while true do	
		if TimeOut then
			if TimeOut < GetGametime() then
				break
			end
		end		

		local zielloc = Rand(50)+20
		if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,zielloc) then
			StopMeasure()
		end		
			
		GetPosition("","MovePos")
		GfxAttachObject("fortunetisch", "city/Stuff/fortunetable.nif")
		GfxSetPositionTo("fortunetisch", "MovePos")	
		SetProperty("","Signal","JugglerFortune")
		CommitAction("kurios", "", "")
		
		local duration = mdata_GetDuration(MeasureID)
		local EndTime = GetGametime() + duration
		SetRepeatTimer("", GetMeasureRepeatName(), 1)
		
		while GetGametime() < EndTime do
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_friendly",1)
			else
				PlaySound3DVariation("","CharacterFX/female_friendly",1)
			end
		  local beweg = Rand(4)
			if beweg == 0 then
		    MsgSayNoWait("Owner","_REN_MEASURE_TELLFORTUNE_SPRUCH_+0")
		    PlayAnimation("","manipulate_middle_twohand")
			elseif beweg == 1 then
		    MsgSayNoWait("Owner","_REN_MEASURE_TELLFORTUNE_SPRUCH_+1")
		    PlayAnimation("","manipulate_middle_low_r")
			elseif beweg == 2 then
		    MsgSayNoWait("Owner","_REN_MEASURE_TELLFORTUNE_SPRUCH_+2")
		    PlayAnimation("","manipulate_middle_low_r")
			else
		    MsgSayNoWait("Owner","_REN_MEASURE_TELLFORTUNE_SPRUCH_+3")
		    PlayAnimation("","point_at")
			end
			Sleep(4)
		end
		GfxDetachAllObjects()
		StopAction("kurios", "")
		RemoveProperty("","Signal")
	end
	
	StopMeasure()
end

function CleanUp()

  GfxDetachAllObjects()
	--MoveSetActivity("","")
	StopAnimation("")
	StopAction("kurios", "")
	RemoveProperty("","Signal")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
