function Weight()

	if not GetSettlement("SIM", "Settlement") then
		return 0
	end
	
	-- 2 = EN_OFFICETYPE_SHERIFF
	if GetOfficeTypeHolder("Settlement", 2, "Office") then
		if DynastyIsPlayer("Office") then
			return 0
		end
	end
	return 100
end

function Execute()
	MeasureRun("SIM", nil, "CheckLocation")
end

