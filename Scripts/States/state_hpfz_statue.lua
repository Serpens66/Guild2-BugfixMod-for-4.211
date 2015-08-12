function Init()
end

function Run()
    CommitAction("statuenreaktion","","")
    while true do
		if GetState("",STATE_FIGHTING) == true then
		    StopAction("","statuenreaktion")
			break
		elseif GetState("",STATE_LEVELINGUP) == true then
		    StopAction("","statuenreaktion")
			break
		else
		    Sleep(5)
		end
		Sleep(5)
	end
	StopMeasure()
end

function CleanUp()
    SetState("",STATE_HPFZ_STATUE,false)
end
