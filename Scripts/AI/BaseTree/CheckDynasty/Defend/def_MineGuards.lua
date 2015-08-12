function Weight()

	local Difficulty = ScenarioGetDifficulty()
	
	if Difficulty <2 then
		return 0
	end
	
	if not DynastyGetRandomBuilding("SIM", -1, 12, "Mine") then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "MineGuards")>0 then
		return 0
	end
	
	return 100
end

function Execute()
	MeasureRun("SIM", nil, "MineGuards")
end

