function Weight()
	if not DynastyGetRandomVictim("SIM", 45, "VictimDynasty") then
		return 0
	end

	local Count = DynastyGetMemberCount("VictimDynasty")
	local VictimNo = Rand(Count)
	if Count < 3 then
		return 0
	end
	if not (DynastyGetMember("VictimDynasty", VictimNo, "Victim")) then
		return 0
	end		

	if ai_AICheckAction()==true then
		return 30
	else
		return 0
	end
end

function Execute()
end
