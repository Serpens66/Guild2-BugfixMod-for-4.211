function Weight()
	if not SimGetWorkingPlace("SIM", "Place") then
		return 0
	end

	local	Remaining = BuildingGetFreeBudget("Place")
	if Remaining < 100 then
		return 0
	end

	return 100
end

function Execute()
	SetProperty("SIM", "SpecialMeasureId", -MeasureGetID("CheckOutfit"))
end

