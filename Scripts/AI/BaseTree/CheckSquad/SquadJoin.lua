function Weight()
	return 100
end

function Execute()
	local Number = GetData("SquadPosition")
	SquadAddMember("Squad", Number, "SquadSim")
end

