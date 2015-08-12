function Weight()
	if GetImpactValue("SIM", "RoyalGuard")==0 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "RoyalGuard")>0 then
		return 0
	end
	
	if not DynastyGetRandomBuilding("VictimDynasty", GL_BUILDING_CLASS_WORKSHOP, -1, "VictimWorkshop") then
		return 0
	end
	
	return 100
end

function Execute()
	MeasureRun("SIM", "VictimWorkshop", "RoyalGuard")
end

