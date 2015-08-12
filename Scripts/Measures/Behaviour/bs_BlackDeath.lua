function Run()

	if GetState("Owner", STATE_BLACKDEATH) then
		return ""
	end

	SetData("Distance", 1000)
	return "SeeBlackDeath"
	
end

