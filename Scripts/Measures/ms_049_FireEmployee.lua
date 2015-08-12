function Run()
	if GetHomeBuilding("", "Home") then
		f_MoveToNoWait("", "Home")
	else
		ExitCurrentBuilding("")
	end
	
-- new function
	SimGetWorkingPlace("", "workbuilding")
	chr_CalculateBuildingBonus("","workbuilding","fire")

	if SimGetProfession("") == 18 then
	    ms_049_fireemployee_FireSoeldner()
	elseif SimGetProfession("") == 74 then
	    ms_049_fireemployee_FireLeibwache()
	end
	
	IncrementXP("",-10000)
	SetSkillValue("",1,1)
	SetSkillValue("",2,1)
	SetSkillValue("",3,1)
	SetSkillValue("",4,1)
	SetSkillValue("",5,1)
	SetSkillValue("",6,1)
	SetSkillValue("",7,1)
	SetSkillValue("",8,1)
	SetSkillValue("",9,1)
	SetSkillValue("",10,1)
	
	Fire("")
	SimResetBehavior("")
end

function FireSoeldner()

	if BuildingHasUpgrade("workbuilding",716) == true then
	    RemoveItems("",73,1,INVENTORY_EQUIPMENT)
		RemoveItems("",74,1,INVENTORY_EQUIPMENT)
		RemoveItems("",89,1,INVENTORY_EQUIPMENT)
    elseif BuildingHasUpgrade("workbuilding",604) == true then
	    RemoveItems("",70,1,INVENTORY_EQUIPMENT)
		RemoveItems("",71,1,INVENTORY_EQUIPMENT)
		RemoveItems("",69,1,INVENTORY_EQUIPMENT)
	end

end

function FireLeibwache()

	    RemoveItems("",73,1,INVENTORY_EQUIPMENT)
		RemoveItems("",74,1,INVENTORY_EQUIPMENT)
		RemoveItems("",69,1,INVENTORY_EQUIPMENT)

end