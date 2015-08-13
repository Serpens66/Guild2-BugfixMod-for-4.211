function Run() -- fixed by Serp, after hiring, the sim won't loose his level.

	local Error = SimCanBeHired("", "Destination")
	if Error~="" then
		chr_OutputHireError("", "Destination", Error)
		return
	end
	
	-- PATCH TODO -- Courtlovers cannot be hired anymore
	if HasProperty("", "courted") then	
		StopMeasure()
	end

	if GetDynastyID("")>0 then
		chr_OutputHireError("", "Destination", "NoWorker")
		return
	end

	local Handsel = SimGetHandsel("", "Destination")
	local Level		= SimGetLevel("")
	local Salary	= SimGetWage("")
    local XP        = GetDatabaseValue("CharLevels", Level-1, "xp")  -- XP which was needed for the current level
    local Name      = GetName("")

	local result = MsgNews("Destination","","@P"..
					"@B[O,@LJa_+0]"..
					"@B[C,@LNein_+0]",
					nil,
					"intrigue",
					-1,
					"@L_GENERAL_MEASURES_HIRE_HEAD_+0",
					"@L_GENERAL_MEASURES_HIRE_BODY_+0",
					GetID(""), Handsel, Level, Salary)
					
	if result == "C" then
		AddImpact("", "NoRandomHire", 1, 4)
		return
	end

	if BuildingGetType("Destination") == 2 then
		ms_048_hireemployee_CheckSoeldner("")
	elseif BuildingGetType("Destination") == 111 then
	  ms_048_hireemployee_CheckLeibwache("")
	end	

	if GetImpactValue("","Sickness")>0 then
		diseases_Sprain("",false)
		diseases_Cold("",false)
		diseases_Influenza("",false)
		diseases_BurnWound("",false)
		diseases_Pox("",false)
		diseases_Pneumonia("",false)
		diseases_Blackdeath("",false)
		diseases_Fracture("",false)
		diseases_Caries("",false)
	end
    SetState("",STATE_SICK,false)

	MoveSetActivity("","")
	chr_CalculateBuildingBonus("","Destination","hire")
    
    local params = ""..Name..","..XP  --  put the parameters in a string  (an array does not work -.-) , and seperate them in the GiveXPBack function
    CreateScriptcall( "GiveBack", 0.005, "Measures/ms_048_HireEmployee.lua", "GiveXPBack", "", -1, params) -- use scriptcall, because this function is stopped after SimHire
    
    local	Error = SimHire("", "Destination",true) -- I think after hiring, the sim is replaced with another sim with same name and so on, but level 1.
    -- and the script measure is stopped about some miliseconds after SimHire, because the calling object gets removed!!! So with luck, you can call one function after it (the sound), but not more.
	if Error~="" then
		chr_OutputHireError("", "Destination", Error)
		return
	else
        PlaySound("Effects/moneybag_to_hand+0.wav",1)
	end
end

function CheckSoeldner()
	if BuildingHasUpgrade("Destination",716) == true then
	  RemoveItems("",61,1,INVENTORY_EQUIPMENT)
	  AddItems("",73,1,INVENTORY_EQUIPMENT)
		AddItems("",74,1,INVENTORY_EQUIPMENT)
		AddItems("",89,1,INVENTORY_EQUIPMENT)	
	elseif BuildingHasUpgrade("Destination",604) == true then
	  RemoveItems("",61,1,INVENTORY_EQUIPMENT)
	  AddItems("",70,1,INVENTORY_EQUIPMENT)
		AddItems("",71,1,INVENTORY_EQUIPMENT)
		AddItems("",69,1,INVENTORY_EQUIPMENT)
	end
end

function CheckLeibwache()
	  RemoveItems("",61,1,INVENTORY_EQUIPMENT)
	  AddItems("",73,1,INVENTORY_EQUIPMENT)
		AddItems("",74,1,INVENTORY_EQUIPMENT)
		AddItems("",69,1,INVENTORY_EQUIPMENT)	
		ForbidMeasure("", "ToggleInventory", EN_BOTH)
end

-- is called via the following in the HireEmployee script, because after SimHire the script is stopped, but we need to add back the XP.
-- local params = ""..Name..","..XP  --  put the parameters in a string  (an array does not work -.-) , and seperate them in the GiveXPBack function
-- CreateScriptcall( "GiveBack", 0.005, "Library/helpfuncs.lua", "GiveXPBack", "", -1, params)
function GiveXPBack(argstring)
    local args = helpfuncs_mysplit(argstring,",") -- uses the helpfuncs script in libary, created by Serp (which also needs an entry in stdafx.lua)
    local Name = args[1]
    local XP = args[2]
    ScenarioGetObjectByName("cl_Sim",Name,"Sim")
    IncrementXPQuiet("Sim",XP) -- after hiring, the sim looses all his XP, so we give it back
end
