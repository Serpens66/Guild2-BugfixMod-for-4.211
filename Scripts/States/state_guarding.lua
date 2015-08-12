function Init()
	SetStateImpact("no_hire")
	SetStateImpact("no_fire")
	SetStateImpact("no_measure_start")
	SetStateImpact("no_idle")
	--SetStateImpact("no_control")
	SetStateImpact("no_cancel_button")
	SetStateImpact("no_action")
	SetStateImpact("no_measure_attach")
end

function Run()

	local iVictimBuildingID = GetProperty("", "RobberProtecting")
	if (GetAliasByID(iVictimBuildingID, "VictimBuilding") == false) then
		return
	end

	local duration = 6
	local EndTime = GetGametime() + duration
	
	local fSingleMoney = GetProperty("","TotalMoney")
	SpendMoney("VictimBuilding", fSingleMoney, "Misc",true)
	chr_RecieveMoney("", fSingleMoney, "Misc")
	
	while GetGametime() < EndTime do

		if (GetState("", STATE_DEAD) or GetState("", STATE_UNCONSCIOUS)) then
			return
		end

	    if not SimGetWorkingPlace("","MyRobberCamp") then
		    break
	    end
		
	    local locId = Rand(4)+1
	        if GetFreeLocatorByName("VictimBuilding", "Walledge",locId,4, "WachPos") then
		        f_BeginUseLocator("", "WachPos", GL_STANCE_STAND, true)

			    local WhatToDo2 = Rand(3)
			    if WhatToDo2 == 0 then
				    Sleep(8) 
			    elseif WhatToDo2 == 1 then
				    PlayAnimationNoWait("","sentinel_idle")
			    else
				    CarryObject("","",false)
		            CarryObject("","Handheld_Device/ANIM_telescope.nif",false)
		            PlayAnimation("","scout_object")
		            CarryObject("","",false)					
			    end
				f_EndUseLocator("", "WachPos", GL_STANCE_STAND)
		    end
		Sleep(3)

	end
	
end


function CleanUp()

	if HasProperty("","TotalMoney") then
		RemoveProperty("","TotalMoney")
	end
	
	local iVictimBuildingID = GetProperty("", "RobberProtecting")
	if HasProperty("","RobberProtecting") then
		RemoveProperty("","RobberProtecting")
	end
	local result = GetAliasByID(iVictimBuildingID, "VictimBuilding")
	if (result == false) then
		return
	end	
	
	if HasProperty("VictimBuilding","RobberProtected")then
	    RemoveProperty("VictimBuilding","RobberProtected")
	end

end