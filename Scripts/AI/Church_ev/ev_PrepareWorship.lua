function Weight()
	if GetMeasureRepeat("SIM", "PrepareWorship") > 0 then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM", "Church") then
		return 0
	end
	
	if BuildingGetProducerCount("Church", PT_MEASURE, "PrepareWorship") > 0 then
		return 0
	end

	local Hour = math.mod(GetGametime(), 24)
	if Hour > 19  then
		return 100
	end
	
	if Hour >= 10  and Hour < 13 then
		return 100
	end
	
	return 0
end

function Execute()
	SetProperty("SIM", "SpecialMeasureId", -MeasureGetID("PrepareWorship"))
end

