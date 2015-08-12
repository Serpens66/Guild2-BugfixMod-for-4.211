function Weight()
	if GetFavorToDynasty("dynasty", "VictimDynasty") > 30 then
		return 0
	end
	
	if GetImpactValue("SIM", "CurryFavor")==0 then
		return 0
	end

	if GetMeasureRepeat("SIM", "CurryFavor")>0 then
		return 0
	end

	return 100
end

function Execute()
	MeasureRun("SIM", "Victim", "CurryFavor")
end
