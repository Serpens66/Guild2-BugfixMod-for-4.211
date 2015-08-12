function Weight()
	if ai_AICheckAction()==false then
		return 0
	end

	local Favor = GetFavorToSim("dynasty", "Victim")
	local Difficulty = ScenarioGetDifficulty()
	local RetVal = 40 + (Difficulty * 15) - Favor
	if RetVal<0 then
		RetVal = 0
	elseif RetVal>100 then
		RetVal = 100
	end
	
	return RetVal
end

function Execute()
end

