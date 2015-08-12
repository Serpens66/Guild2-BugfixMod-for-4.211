function Weight()

	if GetMeasureRepeat("SIM", "InsultCharacter")>0 then
		return 0
	end
	
	if GetNobilityTitle("SIM")<6 then
		return 0
	end
	
	if SimGetClass("SIM")~=GL_CLASS_CHISELER then
		return 0
	end
	
	if SimGetClass("VICTIM")==GL_CLASS_CHISELER then
		return 0
	end

	return 50
end

function Execute()
	MeasureRun("SIM","VICTIM","InsultCharacter")
end

