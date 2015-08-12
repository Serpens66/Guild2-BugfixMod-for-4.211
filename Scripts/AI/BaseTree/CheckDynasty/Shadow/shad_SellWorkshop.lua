function Weight()
	if not DynastyIsShadow("SIM") then
		return 0
	end
	
	local ForSale = (SimGetOfficeID("SIM")==-1)
	
	if not DynastyGetRandomBuilding("SIM", GL_BUILDING_CLASS_WORKSHOP, -1, "sd_Workshop") then
		return 0
	end
	
	if BuildingGetForSale("sd_Workshop")==ForSale then
		return 0
	end
	
	local buildingcount = 0
	local Count = DynastyGetBuildingCount2("SIM")
	local Type
	for l=0,Count-1 do
		if DynastyGetBuilding2("SIM", l, "Check") then
			Type = BuildingGetClass("Check")
			if Type~=GL_BUILDING_CLASS_LIVINGROOM and Type~=GL_BUILDING_CLASS_RESOURCE then
				buildingcount = buildingcount + 1
			end
		end
	end	
	
	if buildingcount < 2 then
		return 0
	end
	
	if GetMoney("SIM") > 3000 then
		return 0
	elseif GetMoney("SIM") > 1000 then
		return 15
	end
		
	return 30
	
end

function Execute()

	if BuildingGetForSale("sd_Workshop") then
		BuildingSetForSale("sd_Workshop", false)
		SetState("sd_Workshop", STATE_SELLFLAG, false)
	else
		BuildingSetForSale("sd_Workshop", true)
		SetState("sd_Workshop", STATE_SELLFLAG, true)
	end

--[[	if BuildingGetForSale("sd_Workshop") then
		BuildingSetForSale("sd_Workshop", false)
		SetState("sd_Workshop", STATE_SELLFLAG, false)
	end	
	]]
end

