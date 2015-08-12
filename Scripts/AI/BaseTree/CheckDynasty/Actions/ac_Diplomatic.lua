function Weight()
	if not ReadyToRepeat("dynasty", "ai_modifyfavor") then
		return 0
	end
	
--	local Time = ScenarioGetTimePlayed()
--	if Time < 16 then
--		local Mod = math.mod(GetID("dynasty"), 16)
--		if Time <  Mod then
--			return 0
--		end
--	end
	
	if not DynastyGetRandomVictim("SIM", 0, "VictimDynasty") then
		return 0
	end

	local Count = DynastyGetMemberCount("VictimDynasty")
	local VictimNo = Rand(Count)
	if not (DynastyGetMember("VictimDynasty", VictimNo, "Victim")) then
		return 0
	end		

	if ai_AICheckAction()==true then
		return 50
	else
		return 0
	end
end

function Execute()
	SetRepeatTimer("dynasty", "ai_modifyfavor", 12)
	AIExecutePlan("SIM", "Favor", "SIM", "SIM", "dynasty", "dynasty","VictimDynasty", "VictimDynasty", "Victim", "Victim" )
end
