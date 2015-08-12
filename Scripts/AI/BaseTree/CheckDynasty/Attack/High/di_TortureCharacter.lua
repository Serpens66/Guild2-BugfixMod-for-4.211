function Weight()

	if GetImpactValue("SIM", "TortureCharacter")==0 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "TortureCharacter")>0 then
		return 0
	end

	if not GetSettlement("SIM", "CityAlias") then
		return 0
	end
	
	local NumServant = CityGetServantCount("CityAlias", GL_PROFESSION_PRISONGUARD)
	if not CityGetServant("CityAlias", Rand(NumServant), GL_PROFESSION_PRISONGUARD, "dito_Servant") then
		return 0
	end
		
	return 100
end

function Execute()
	MeasureRun("dito_Servant", "Victim", "TortureCharacter")
end

