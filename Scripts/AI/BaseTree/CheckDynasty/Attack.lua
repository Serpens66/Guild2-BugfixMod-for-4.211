function Weight()

	if DynastyIsShadow("SIM") then
		return 0
	end

	local Difficulty = ScenarioGetDifficulty()
	local maxFav     = Difficulty * 7
	local roundMod   = 0

	if Difficulty == 0 then
		roundMod = 8
	elseif Difficulty == 1 then
		roundMod = 6
	elseif Difficulty == 2 then
		roundMod = 4
	elseif Difficulty == 3 then
		roundMod = 3
	else
		roundMod = 2
	end

	if GetRound() >= roundMod then

		if not DynastyGetRandomVictim("SIM", maxFav, "VictimDynasty") then
			return 0
		end
	
		local Count = DynastyGetMemberCount("VictimDynasty")
		local Value = Count
		if not DynastyIsAI("VictimDynasty") then
			Value = Value + (Difficulty * 2)
		end
		
		local VictimNo = Rand(Count)
		if not (DynastyGetMember("VictimDynasty", VictimNo, "Victim")) then
			return 0
		end		
	
		-- if gameplayformulas_CheckDistance("","Victim")==0 then
			-- return 0
		-- end
		if Value > 60 then
			Value = 60
		end
	
		if ai_AICheckAction()==true then
			return 10*Value
		else
			return 0
		end

	else
		return 0
	end

end

function Execute()
end
