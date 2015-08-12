function Run()

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
	
	MoveSetActivity("","")
	chr_CalculateBuildingBonus("","Destination","hire")
	
	local	Error = SimHire("", "Destination")
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
