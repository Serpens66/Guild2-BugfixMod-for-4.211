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

	local count = BuildingGetWorkerCount("MyBank")
	if count < 2 then 
		return 0
	end

	--spam filter
	if IsDynastySim("SIM") then
		return 0
	end

	local Waittime = GetGametime() + 1
	local Ntime = GetGametime()
	if HasProperty("MyBank", "AIDecideNow") then
--		if DynastyIsPlayer("SIM") then
--			GetLocalPlayerDynasty("Player")
--			MsgQuick("Player", "@L alredy thinking")
--			Sleep(1)
--		end
		return 0
	else
		SetProperty("MyBank", "AIDecideNow", 1)
		if HasProperty("MyBank", "AIWtime") then
			local Gtime = GetProperty("MyBank", "AIWtime")
			if Ntime < Gtime then
--				if DynastyIsPlayer("SIM") then
--					GetLocalPlayerDynasty("Player")
--					MsgQuick("Player", "@L Not in Time")
--					Sleep(1)
--				end
				if HasProperty("MyBank", "AIDecideNow") then
					RemoveProperty("MyBank", "AIDecideNow")
					return 0
				end
			else
				SetProperty("MyBank", "AIWtime", Waittime)
			end
		else
			SetProperty("MyBank", "AIWtime", Waittime)
		end
		if HasProperty("MyBank", "AIDecideNow") then
			RemoveProperty("MyBank", "AIDecideNow")
			return -1
		end
	end
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", Rand(6)+2)
	MeasureStart("Measure", "SIM", "MyBank", "OrderCredit")
end
