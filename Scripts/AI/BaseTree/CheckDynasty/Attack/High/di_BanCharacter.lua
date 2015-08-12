function Weight()

	if GetImpactValue("SIM", "BanCharacter")==0 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "BanCharacter")>0 then
		return 0
	end
	
	if SimGetOffice("Victim","Office") then
		if OfficeGetLevel("Office")>=6 then
			return 0
		end
	end
	
	return 100
end

function Execute()
	MeasureRun("SIM", "Victim", "BanCharacter")
end

