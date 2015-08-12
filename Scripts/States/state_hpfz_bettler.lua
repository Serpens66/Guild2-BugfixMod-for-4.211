function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_control")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_start")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_action")
	SetStateImpact("no_enter")
	SetStateImpact("no_cancel_button")
	MoveSetActivity("","sick")
	BaseFE("", "sad", 1.0, -1)
end

function Run()
	MeasureRun("","","WerdeBettler",true)
	while true do
		Sleep(Rand(2)+5)
	end
end

function CleanUp()
	MoveSetActivity("","")
	FadeOutFE("","sad",1.0,-1)
end

