function Run()
	if GetImpactValue("","spying") == 1 then
		return ""
	end
	
	if SimGetProfession("Owner")==GL_PROFESSION_CITYGUARD then
		CopyAlias("Actor", "Destination")
		return "InspectArea"
	end
	
	if SimGetProfession("Owner")==GL_PROFESSION_MYRMIDON then

		-- it's a mercenary, so check if this a mercenary from a friend dynasty

		if GetDynasty("Actor", "ActorDynasty") and GetDynasty("Owner", "OwnerDynasty") then
			if DynastyGetDiplomacyState("ActorDynasty","OwnerDynasty") == DIP_ALLIANCE then
				CopyAlias("Actor", "Destination")
				return "InspectArea"
			end
		end
	end

	return ""
end
