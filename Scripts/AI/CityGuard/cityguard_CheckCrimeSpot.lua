function Weight()
	if GetCrimeLocation("SIM", "CCS_Location") then
		return 100
	end
	return 0
end

function Execute()
	if IsType("CCS_Location", "cl_Sim") then
		MeasureRun("SIM", "CCS_Location", "EscortCharacterOrTransportIdle")
		return
	end
	
	MeasureRun("SIM", "CCS_Location", "CheckLocation")
end
