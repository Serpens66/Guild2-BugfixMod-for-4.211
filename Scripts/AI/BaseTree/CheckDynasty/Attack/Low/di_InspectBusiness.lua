function Weight()

	local Hour = math.mod(GetGametime(), 24)
	if Hour<8 or Hour>16 then
		return 0
	end

	if GetImpactValue("SIM", "InspectBusiness")==0 then
		return 0
	end
	
	if GetImpactValue("dynasty","BeeingInspected")==1 then
		return 0
	end	

	if GetMeasureRepeat("SIM", "InspectBusiness")>0 then
		return 0
	end

	if not GetSettlement("SIM", "CityAlias") then
		return 0
	end

	local NumServant = CityGetServantCount("CityAlias", GL_PROFESSION_INSPECTOR)
	if not CityGetServant("CityAlias", Rand(NumServant), GL_PROFESSION_INSPECTOR, "diib_Servant") then
		return 0
	end

	if not GetState("diib_Servant", STATE_IDLE) then
		return 0
	end
	
	for trys=0,5 do
	
		if DynastyGetRandomBuilding("VictimDynasty",2,-1,"diib_Target") then
			if GetSettlementID("diib_Target") == GetSettlementID("SIM") then
				return 100
			end
		end

	end

	return 0
end

function Execute()
	MeasureRun("diib_Servant","diib_Target","InspectBusiness")
end

