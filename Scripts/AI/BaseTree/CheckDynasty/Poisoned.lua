function Weight()
	if GetImpactValue("","poisoned")>0 then
		if GetProperty("", "poisoned")>1 then
			return 50
		end
	end
	
	return 0
end


function Execute()
	if GetImpactValue("","poisoned")>0 then
		if GetProperty("", "poisoned")>1 then
			MeasureRun("SIM", "", "UseAntidote")
		end
	end
end

