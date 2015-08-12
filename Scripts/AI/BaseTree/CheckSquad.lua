function Weight()
	local Number = DynastyFindSquad("dynasty", "Squad")
	if Number<0 then
		return 0
	end
	local Profession	= SquadGetProfession("Squad", Number)
	
	if DynastyFindIdleWorker("dynasty", Profession, 45, "SquadSim") then
		SetData("SquadPosition", Number)
		return 1000
	end
	
	return 0
end

function Execute()
end

