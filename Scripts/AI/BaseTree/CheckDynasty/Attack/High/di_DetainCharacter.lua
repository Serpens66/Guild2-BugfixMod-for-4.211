function Weight()

	if SimGetOfficeLevel("SIM") < 1 then
		return 0
	end

	if GetImpactValue("SIM", "DetainCharacter")==0 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "DetainCharacter")>0 then
		return 0
	end

	if not GetSettlement("SIM", "CityAlias") then
		return 0
	end
	
	if GetEvidenceAlignmentSum("SIM","Victim") <= 0 then
		return 0
	end
	
	if not ai_CheckMutex("CityAlias", "DetainCharacter") then
		return 0
	end

	local NumServant = CityGetServantCount("CityAlias", GL_PROFESSION_CITYGUARD)
	if not CityGetServant("CityAlias", Rand(NumServant), GL_PROFESSION_CITYGUARD, "dide_Servant") then
		return 0
	end

	if not GetState("dide_Servant", STATE_IDLE) then
		return 0
	end

	return 100
end

function Execute()
	MeasureRun("dide_Servant", "Victim", "DetainCharacter")
end
