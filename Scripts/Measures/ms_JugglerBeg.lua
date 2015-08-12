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

		local MeasureID = GetCurrentMeasureID("")
		local duration = mdata_GetDuration(MeasureID)	
		local EndTime = GetGametime() + duration
		local uprogramm = 1
		
		if BuildingHasUpgrade("Juggler", 813) == true then
		    uprogramm = 2
		end
		
		if BuildingHasUpgrade("Juggler", 831) == true then
		    uprogramm = 3
		end
		
		if BuildingHasUpgrade("Juggler", 829) == true then
		    uprogramm = 4
		end
		
		CommitAction("beg", "", "")
    SetRepeatTimer("", GetMeasureRepeatName(), 1)
		
		while GetGametime() < EndTime do
      local modus = Rand(uprogramm)
			local dauer = Rand(5)+5
			if modus == 0 then
                local Fasel = Rand(3)
                if Fasel == 0 then
                    MsgSayNoWait("Owner","_REN_MEASURE_BEG_SPRUCH_+0")
                elseif Fasel == 1 then
                    MsgSayNoWait("Owner","_REN_MEASURE_BEG_SPRUCH_+1")
                elseif Fasel == 2 then
                    MsgSayNoWait("Owner","_REN_MEASURE_BEG_SPRUCH_+2")
                end			
	            if SimGetGender("") == 1 then
				    PlaySound3DVariation("","CharacterFX/male_friendly",1)
					if dauer < 7 then
		                PlayAnimation("","talk_positive")
					else
					    PlayAnimation("","talk_2")
					end
				else
				    PlaySound3DVariation("","CharacterFX/female_joy_loop",1)
				    PlayAnimation("","dance_female_"..Rand(2)+1)
	      end			
			elseif modus == 1 then
        local AnimTime = PlayAnimationNoWait("","play_instrument_01_in")
        Sleep(1)
        CarryObject("","Handheld_Device/ANIM_Flute.nif",false)
        Sleep(AnimTime-1)
		    LoopAnimation("","play_instrument_01_loop",dauer)
        AnimTime = PlayAnimationNoWait("","play_instrument_01_out")
        Sleep(1.5)
        CarryObject("","",false)
        Sleep(AnimTime-1)			
			elseif modus == 2 then
        local AnimTime = PlayAnimationNoWait("","play_instrument_03_in")
        Sleep(1)
        CarryObject("","Handheld_Device/ANIM_laute.nif",true)
        Sleep(AnimTime-1)
		    LoopAnimation("","play_instrument_03_loop",dauer)
        AnimTime = PlayAnimationNoWait("","play_instrument_03_out")
        Sleep(1.5)
        CarryObject("","",true)
        Sleep(AnimTime-1)			
			else
        local AnimTime = PlayAnimationNoWait("","play_instrument_02_in")
        Sleep(1)
        CarryObject("","Handheld_Device/ANIM_Drumstick.nif",false)
        CarryObject("","Handheld_Device/ANIM_Drum.nif",true)
        Sleep(AnimTime-1)
		    LoopAnimation("","play_instrument_02_loop",dauer)
        AnimTime = PlayAnimationNoWait("","play_instrument_02_out")
        Sleep(1.5)
        CarryObject("","",false)
        CarryObject("","",true)
        Sleep(AnimTime-1)			
			end
	    Sleep(4)
	    IncrementXPQuiet("",5)
    end
		StopAction("beg", "")
	end
	
	StopMeasure()
end

function CleanUp()
	CarryObject("", "", false)
	CarryObject("","",true)
	--MoveSetActivity("","")
	StopAnimation("")
	StopAction("beg", "")
end
