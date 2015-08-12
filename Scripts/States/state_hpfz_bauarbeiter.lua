function Init()
    SetState("", STATE_LOCKED, false)
	SetStateImpact("no_idle")
	SetStateImpact("no_control")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_start")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_action")
	SetStateImpact("no_enter")
	SetStateImpact("no_cancel_button")
end

function Run()
    local arbeit, beweg, dauer, altPos, bremsPos
    local ArbeitsPlatz = GetData("DasGebaeude")
	while true do
		arbeit = Rand(3)
		SetContext("","rangerhut")
		if arbeit == 0 then
	        CarryObject("","Handheld_Device/Anim_Hammer.nif", false)
	        PlayAnimation("","hammer_in")
		    dauer = (Rand(16) + 10)
		    LoopAnimation("","hammer_loop",dauer)
		    PlayAnimation("","hammer_out")		
		elseif arbeit == 1 then
	        CarryObject("","Handheld_Device/ANIM_Chisel.nif", false)
	        PlayAnimation("","knee_work_in")
		    dauer = (Rand(16) + 10)
		    LoopAnimation("","knee_work_loop",dauer)
		    PlayAnimation("","knee_work_out")
        elseif arbeit == 2 then		
	        CarryObject("","Handheld_Device/Anim_Hammer.nif", false)
	        PlayAnimation("","chop_in")
		    dauer = (Rand(16) + 10)
		    LoopAnimation("","chop_loop",dauer)
		    PlayAnimation("","chop_out")		
		end
		
	    GetPosition("","ArbeitsPos")
        GetLocatorByName(ArbeitsPlatz,"walledge2","MatPos")
		bremsPos = Rand(40)
		f_MoveTo("","MatPos",nil, bremsPos)		
		beweg = Rand(3)
		if beweg == 0 then
		    MoveSetActivity("","carry")
		    Sleep(2)
            CarryObject("","Handheld_Device/ANIM_Bag.nif",false)
		elseif beweg == 1 then
		    MoveSetActivity("","carry")
		    Sleep(2)
            CarryObject("","Handheld_Device/ANIM_Woodlog.nif",false)
		elseif beweg == 2 then
		    MoveSetActivity("","carry")
		    Sleep(2)
            CarryObject("","Handheld_Device/ANIM_holzscheite.nif",false)
		end
		
		if not f_MoveTo("","ArbeitsPos") then
			SimBeamMeUp("", "ArbeitsPos", false)
		end
	    AlignTo("",ArbeitsPlatz)
		Sleep(0.7)
		MoveSetActivity("","")
		Sleep(2)
        CarryObject("","",false)	
	end
end

function CleanUp()
    FindNearestBuilding("",1,1,-1,false,"BauUnterkunft")
	if not f_MoveTo("","BauUnterkunft",GL_MOVESPEED_RUN) then
		SimBeamMeUp("", "BauUnterkunft", false)
	end
	InternalDie("")
	InternalRemove("")
end
