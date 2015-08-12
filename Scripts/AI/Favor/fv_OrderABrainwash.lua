function Weight()

	if GetImpactValue("SIM", "OrderABrainwash")==0 then
		return 0
	end

	if GetMeasureRepeat("SIM", "OrderABrainwash")>0 then
		return 0
	end
	
	if GetFavorToDynasty("dynasty", "VictimDynasty") > 20 then
		return 0
	end
	
	if not GetSettlement("SIM", "CityAlias") then
		return 0
	end
	
	local NumServant = CityGetServantCount("CityAlias", GL_PROFESSION_PRISONGUARD)
	if not CityGetServant("CityAlias", Rand(NumServant), GL_PROFESSION_PRISONGUARD, "fv_OAB") then
		return 0
	end
	
	return 100
end

function Execute()
	MeasureRun("fv_OAB", "Victim", "OrderABrainwash")
end
