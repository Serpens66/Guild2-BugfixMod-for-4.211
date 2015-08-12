-- ******** THANKS TO KINVER ********
function Weight()

	if not SimGetWorkingPlace("SIM", "Divehouse") then
		return 0
	end

	if not SimCanWorkHere("SIM", "Divehouse") then
		return 0
	end

	if HasProperty("Divehouse", "ServiceActive") then
		return 0			
	end

	local TryTime
	if HasProperty("Divehouse", "ServiceStartTime") then
		TryTime = GetProperty("Divehouse", "ServiceStartTime") + 4
		if TryTime < GetGametime() then
			return 0
		end
	end

	if HasProperty("Divehouse", "GoToService") then
		return 0			
	end

	return 100
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", Rand(3)+2)
	MeasureStart("Measure", "SIM", "Divehouse", "AssignToServiceDivehouse")
end

