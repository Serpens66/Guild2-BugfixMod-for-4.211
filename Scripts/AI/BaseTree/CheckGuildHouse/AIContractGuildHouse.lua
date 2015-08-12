function Weight()

	if GetSettlement("SIM", "City") then
		if (gameplayformulas_CheckPublicBuilding("City", GL_BUILDING_TYPE_BANK)[1]>0) then
			if not CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "Guildhouse") then
				return 0
			end
		else
			return 0
		end
	else
		return 0
	end

	if HasProperty("Guildhouse", "ContractCount") and (GetProperty("Guildhouse", "ContractCount")>0) then
		if HasProperty("Guildhouse", "ContractClass") then
			if (SimGetClass("SIM")==GetProperty("Guildhouse", "ContractClass")) then
				if chr_GetAlderman()==GetID("SIM") then
					return 30
				elseif chr_CheckGuildMaster("SIM","Guildhouse") then
					return 30
				else
					return 10
				end
			end
		end
	end

	return 0
end

function Execute()
	SetRepeatTimer("dynasty", "IAContractGuildHouse", 4)
	MeasureCreate("Measure")
	MeasureRun("SIM", "Guildhouse", "ContractGuildHouse")
end
