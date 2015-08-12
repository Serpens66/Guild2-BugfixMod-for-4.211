function Weight()
	if GetMeasureRepeat("dynasty", "WinBelievers") > 0 then
		return 0
	end
	
	if not ReadyToRepeat("dynasty", "AI_WinBelievers") then
		return 0
	end	
	
	if not SimGetWorkingPlace("SIM", "Church") then
		return 0
	end
	
	if BuildingGetLevel("Church") < 2 then
		return 0
	end
	
	if BuildingGetProducerCount("Church", PT_MEASURE, "WinBelievers") > 0 then
		return 0
	end
	
	local Hour = math.mod(GetGametime(), 24)
	local	Last = BuildingGetWorkingEnd("church") - 2
	if Hour > Last or Hour<10 then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("dynasty", "AI_WinBelievers", 24)
	SetProperty("SIM", "SpecialMeasureId", -MeasureGetID("WinBelievers"))
end

