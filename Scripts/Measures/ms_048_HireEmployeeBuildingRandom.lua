function Run()

	local Button1 = "@B[B,@L_HPFZ_EINSTELLEN_+0]"
	local Button2 = "@B[N,@L_HPFZ_EINSTELLEN_+1]"
	local Button3 = "@B[M,@L_HPFZ_EINSTELLEN_+2]"
	
	local Worker2Exists = FindWorker("","worker",3)
	if Worker2Exists ~= "" then
		Button2 = ""
	end
	
	local Worker3Exists = FindWorker("","worker",5)
	if Worker3Exists ~= "" then
		Button3 = ""
	end		

	local auswahl = MsgNews("","","@P"..
					Button1..
					Button2..
					Button3,
					ms_048_hireemployeebuildingrandom_DecideFirst,
					"intrigue",
					-1,
					"@L_GENERAL_MEASURES_HIRE_HEAD_+0",
					"@L_HPFZ_MEASURES_HIRE_ZUSATZ_+0")

	-- added by FH:
	-- prevents game from freezing
	if auswahl == "C" then
		return
	end
	
	local DesiredLevel = 1
	if auswahl == "N" then
		DesiredLevel = 3
	elseif auswahl == "M" then
		DesiredLevel = 5
	end
		
    local arbeiter = FindWorker("", "RandWorker",DesiredLevel)
    if arbeiter~="" then
        chr_OutputHireError("RandWorker", "", arbeiter)
        return
	end
	local Handsel = SimGetHandsel("RandWorker", "")
	if BuildingHasUpgrade("",716) == true then
		Handsel = Handsel + 4900
	
	elseif BuildingHasUpgrade("",604) == true then
		Handsel = Handsel + 2400
	end
	
	if BuildingGetType("") == 111 then
		Handsel = Handsel + 4900
	end
	
	SetData("Hands",Handsel)
	local Level		= SimGetLevel("RandWorker")
	SetData("Lvl",Level)
	local Salary	= SimGetWage("RandWorker")
	SetData("Saly",Salary)
    local XP        = GetDatabaseValue("CharLevels", Level-1, "xp")  -- XP which was needed for the current level
    SetData("XPP",XP)
    
	-- PATCH TODO
	if HasProperty("RandWorker", "courted") then
		StopMeasure()
	end
	
	ms_048_hireemployeebuildingrandom_DecideYou()
		--[[
        if auswahl	== "B" then
		    if Level < 4 then
			    ms_048_hireemployeebuildingrandom_DecideYou()
				if GetData("Entscheid") == 1 then
				    break
				else
				    suche = suche + 1
				end
			else
			    suche = suche + 1
			end
		elseif auswahl == "N" then
		    if Level >= 4 and Level < 8 then
			    ms_048_hireemployeebuildingrandom_DecideYou()
				if GetData("Entscheid") == 1 then
				    break
				else
				    suche = suche + 1
				end
			else
			    suche = suche + 1
			end
		elseif auswahl == "M" then
		    if Level >= 8 then
			    ms_048_hireemployeebuildingrandom_DecideYou()
				if GetData("Entscheid") == 1 then
				    break
				else
				    suche = suche + 1
				end
			else
			    suche = suche + 1
			end
		end
		if suche == 6 then
		    MsgQuick("","@L_HPFZ_HIRERANDOM_FEHLER_+0")
		    StopMeasure()
        end
	end]]
	
	if BuildingGetType("") == 2 then
	    ms_048_hireemployeebuildingrandom_CheckSoeldner()
	elseif BuildingGetType("") == 111 then
	    ms_048_hireemployeebuildingrandom_CheckLeibwache()
	end	
	
end
		
function DecideYou()

	SetData("Entscheid",0)
	local handsels = GetData("Hands")
	local levels = GetData("Lvl")
	local salarys = GetData("Saly")
    local xp = GetData("XPP")
	
	if BuildingGetOwner("","BOwner") then
		if GetMoney("BOwner")<handsels then
			MsgQuick("", "@L_GENERAL_MEASURES_FAILURES_+14", handsels, GetID("RandWorker"))
				StopMeasure()
		end
	end
	
	local result = MsgNews("","RandWorker","@P"..
					"@B[O,@LJa_+0]"..
					"@B[C,@LNein_+0]",
					ms_048_hireemployeebuildingrandom_Decide,
					"intrigue",
					-1,
					"@L_GENERAL_MEASURES_HIRE_HEAD_+0",
					"@L_GENERAL_MEASURES_HIRE_BODY_+0",
					GetID("RandWorker"), handsels, levels, salarys)
					
	if result == "C" then
		AddImpact("RandWorker", "NoRandomHire", 1, 4)
		return
	end

--	if GetDynastyID("RandWorker")>0 then
--		chr_OutputHireError("RandWorker", "", "NoWorker")
--	end

	Error = SimHire("RandWorker", "",true)
	chr_OutputHireError("RandWorker", "", Error)

    IncrementXPQuiet("RandWorker",xp)	      -- XP back to previous value
	if Error == "" then
		PlaySound("Effects/moneybag_to_hand+0.wav",1)
		if BuildingHasUpgrade("",716) == true then
			SpendMoney("BOwner",4900,"misc")
		elseif BuildingHasUpgrade("",604) then
			SpendMoney("BOwner",2400,"misc")
		end
		if BuildingGetType("")==111 then
			SpendMoney("BOwner",4900,"misc")
		end
		SetData("Entscheid",1)
		if DynastyIsShadow("") == true or DynastyIsAI("") == true then
		    if BuildingGetLevel("") == 1 then  
			  local lvlset = (Rand(2)+1)   -- 1 or 2
				SetProperty("RandWorker","Level",lvlset)
			elseif BuildingGetLevel("") == 2 then
			  local lvlset = (Rand(2)+3) -- 3 or 4
				SetProperty("RandWorker","Level",lvlset)
			else
			  local lvlset = (Rand(2)+5)  -- 5 or 6
				SetProperty("RandWorker","Level",lvlset)
			end
		end
	end
	if GetImpactValue("RandWorker","Sickness")>0 then
		diseases_Sprain("RandWorker",false)
		diseases_Cold("RandWorker",false)
		diseases_Influenza("RandWorker",false)
		diseases_BurnWound("RandWorker",false)
		diseases_Pox("RandWorker",false)
		diseases_Pneumonia("RandWorker",false)
		diseases_Blackdeath("RandWorker",false)
		diseases_Fracture("RandWorker",false)
		diseases_Caries("RandWorker",false)
	end
	SetState("RandWorker",STATE_SICK,false)
	
	MoveSetActivity("","")
	SimGetWorkingPlace("RandWorker", "workbuilding")
	chr_CalculateBuildingBonus("RandWorker","","hire")
end

function DecideFirst()
    if BuildingGetLevel("") == 1 then
	    return "B"
	elseif BuildingGetLevel("") == 2 then
        return "N"
	else
	    return "M"
	end
end

function Decide()
	return "O"
end

function CheckSoeldner()

	if BuildingHasUpgrade("",716) == true then
		RemoveItems("RandWorker",61,1,INVENTORY_EQUIPMENT)
		AddItems("RandWorker",73,1,INVENTORY_EQUIPMENT)
		AddItems("RandWorker",74,1,INVENTORY_EQUIPMENT)
		AddItems("RandWorker",89,1,INVENTORY_EQUIPMENT)
--		ForbidMeasure("RandWorker", "ToggleInventory", EN_BOTH) 		
	elseif BuildingHasUpgrade("",604) == true then
		RemoveItems("RandWorker",61,1,INVENTORY_EQUIPMENT)
		AddItems("RandWorker",70,1,INVENTORY_EQUIPMENT)
		AddItems("RandWorker",71,1,INVENTORY_EQUIPMENT)
		AddItems("RandWorker",69,1,INVENTORY_EQUIPMENT)
--		ForbidMeasure("RandWorker", "ToggleInventory", EN_BOTH) 
	end

end

function CheckLeibwache()

		RemoveItems("RandWorker",61,1,INVENTORY_EQUIPMENT)
		AddItems("RandWorker",73,1,INVENTORY_EQUIPMENT)
		AddItems("RandWorker",74,1,INVENTORY_EQUIPMENT)
		AddItems("RandWorker",69,1,INVENTORY_EQUIPMENT)	
--		ForbidMeasure("RandWorker", "ToggleInventory", EN_BOTH) 
end
