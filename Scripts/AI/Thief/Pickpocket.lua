function Weight()
	local Time = math.mod(GetGametime(), 24)
	if Time<6 and Time>22 then	
		return 0
	end
	
	if not GetSettlement("SIM", "City") then
		return 0
	end
	
	if not CityFindCrowdedPlace("City", "SIM", "pick_pos") then
		return 0
	end
	
	return 100
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", 2)
	MeasureStart("Measure", "SIM", "pick_pos", "PickpocketPeople")
end

