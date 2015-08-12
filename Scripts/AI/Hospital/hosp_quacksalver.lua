function Weight()
	
	if DynastyIsAI("SIM") then
		if SimGetOfficeLevel("SIM")>=1 then
			return 0
		end
	end
	
	if GetMeasureRepeat("SIM", "Quacksalver") > 0 then
		return 0
	end
	
	if GetState("SIM",STATE_DUEL) then
		return 0
	end
	
	if not ai_HasAccessToItem("SIM", "MiracleCure") then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM", "Hospital") then
		return 0
	end
	
	if BuildingGetProducerCount("Hospital", PT_MEASURE, "Quacksalver") > 0 then
		return 0
	end

	if GetItemCount("SIM", "MiracleCure")>5 then
		return 100
	elseif GetItemCount("Hospital", "MiracleCure", INVENTORY_STD) > 5 then
		return 100
	elseif GetItemCount("Hospital", "MiracleCure", INVENTORY_SELL) > 5 then
		return 100
	end

	return 0
end

function Execute()
	SetProperty("SIM", "SpecialMeasureId", -MeasureGetID("Quacksalver"))
end
