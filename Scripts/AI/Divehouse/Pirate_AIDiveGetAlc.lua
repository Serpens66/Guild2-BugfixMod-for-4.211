function Weight()

	if not SimGetWorkingPlace("SIM","Divehouse") then
		return 0
	end

    if GetItemCount("Divehouse", "PiratenGrog", INVENTORY_STD) > 100 then
		return 0
	end
	
    if GetItemCount("Divehouse", "Schadelbrand", INVENTORY_STD) > 100 then
	    return 0
	end

    if GetItemCount("Divehouse", "SmallBeer", INVENTORY_STD) > 100 then
		return 0
	end
	
    if GetItemCount("Divehouse", "WheatBeer", INVENTORY_STD) > 100 then
	    return 0
	end

	BuildingGetCity("Divehouse","checkTown")
    if not CityGetRandomBuilding("checkTown",5,14,-1,-1,FILTER_IGNORE,"Markt") then
	    return 0
	else
	    if GetItemCount("Markt", 42, INVENTORY_STD) < 6 and GetItemCount("Markt", 44, INVENTORY_STD) < 6 then
	        return 0
	    end
	end
	
	return 100
end

function Execute()
	local smbeer
	local wbeer
	BuildingGetCity("Divehouse","checkTown")
    CityGetRandomBuilding("checkTown",5,14,-1,-1,FILTER_IGNORE,"Markt")
	smbeer = GetItemCount("Markt", 42, INVENTORY_STD)
	wbeer = GetItemCount("Markt", 44, INVENTORY_STD)
	if smbeer > 5 then
	    Transfer(nil, "Divehouse", INVENTORY_SELL, "Markt", INVENTORY_STD, 42, Rand(smbeer)+5)
	elseif wbeer > 5 then
	    Transfer(nil, "Divehouse", INVENTORY_SELL, "Markt", INVENTORY_STD, 44, Rand(wbeer)+5)
	else
	    return
	end
end

