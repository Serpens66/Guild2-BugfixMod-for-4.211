function Weight()

	if GetImpactValue("SIM", "UncannyGlare")==0 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "UncannyGlare")>0 then
		return 0
	end

	if gameplayformulas_CheckDistance("","Victim")==0 then
		return 0
	end

	return 50
end

function Execute()
	MeasureRun("SIM", "Victim", "UncannyGlare")
end

