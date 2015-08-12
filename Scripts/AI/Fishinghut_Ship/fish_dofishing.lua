function Weight()
	if not GetHomeBuilding("", "Hut") then
		return 0
	end

	local	maxcount
	local	count
	local	level

	count			= GetItemCount("Hut", "Herring", INVENTORY_STD)
	maxcount	= InventoryGetSlotSize("Hut", "Herring", INVENTORY_STD) - 10
	if count < maxcount then
		if ResourceFind("Hut","Herring","Resource", true) then
			return 100
		end
	end
	
	level			= BuildingGetLevel("Hut")
	
	if level<2 then
		return 0
	end
	
	count			= GetItemCount("Hut", "Salmon", INVENTORY_STD)
	maxcount	= InventoryGetSlotSize("Hut", "Salmon", INVENTORY_STD) - 10
	if count < maxcount then
		if ResourceFind("Hut","Salmon","Resource", true) then
			return 100
		end
	end
	
	return 0
	
end

function Execute()
	MeasureRun("", "Resource", "Fishing")
end
