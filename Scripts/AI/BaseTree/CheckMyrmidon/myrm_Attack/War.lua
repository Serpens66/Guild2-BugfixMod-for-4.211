function Weight()
	if IsDynastySim("SIM") then
		return 0
	end
	
	if GetRound() < 1 then
		return 0
	end
	
	if not DynastyGetRandomVictim("SIM", 30, "WAR_VICTIM") then
		return 0
	end
	
--	if DynastyGetDiplomacyState("SIM", "WAR_VICTIM") > DIP_NEUTRAL then
--		return 0
--	end

	local Count = DynastyGetMemberCount("WAR_VICTIM")
	if Count<1 then
		return 0
	end
	
	if not DynastyGetMember("WAR_VICTIM", Rand(Count), "WAR_SIM") then
		return 0
	end
	
	if not CanBeControlled("WAR_SIM", "WAR_VICTIM") then
		return 0
	end
	
	return 100
end

function Execute()
	SquadCreate("SIM", "SquadWar", "WAR_SIM", "SquadWarMember", "SquadWarMember")
end

