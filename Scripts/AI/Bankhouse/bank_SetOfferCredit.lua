function Weight()
	if not SimGetWorkingPlace("SIM","MyBank") then
		return 0
	end

	if not SimCanWorkHere("SIM", "MyBank") then
		return 0
	end		

	if GetInsideBuildingID("SIM") ~= GetID("MyBank") then
		return 0
	end

	if not GetSettlement("SIM","City") then
		return 0
	end
	
	if not HasProperty("MyBank", "KreditKonto") then
		return 0
	else
		local Kredit = GetProperty("MyBank", "KreditKonto")
		if Kredit < 0 then
			return 0
		end
	end
	
	local count = BuildingGetWorkerCount("MyBank")
	if count < 2 then
		return 0
	end

	local TryTime
	if HasProperty("MyBank", "OfferStartTime") then
		TryTime = GetProperty("MyBank", "OfferStartTime") + 4
		if TryTime < GetGametime() then
			return 0
		end
	end

	local Hour = math.mod(GetGametime(), 24)
	if IsDynastySim("SIM")  then
		if (Hour < 3) or (Hour > 20) then
			return -1
		else
			return 0
		end
	else
		if not HasProperty("MyBank", "OfferCreditNow") and (Rand(20) > 15) then
			return -1
		else
			return 0
		end
	end


end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", Rand(4)+4)
	MeasureStart("Measure", "SIM", "MyBank", "OfferCredit")
end
