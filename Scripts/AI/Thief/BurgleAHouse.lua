function Weight() 

	local Time = math.mod(GetGametime(), 24)
	if not (Time>20 or Time<6) then
		return 0
	end

	local Count = Find("","__F((Object.GetObjectsByRadius(Building)==5000)NOT(Object.BelongsToMe())AND NOT(Object.IsClass(0))AND NOT(Object.IsClass(3))AND NOT(Object.IsClass(5))AND NOT(Object.IsClass(7))AND NOT(Object.IsType(1))AND(Object.ActionAdmissible())AND NOT(Object.HasImpact(Unantastbar))AND NOT(Object.GetState(building)))","Build", -1)
	if Count==0 then
		return 0
	end

	local i = 0
	local found = false
	local DynID = GetDynastyID("dynasty")

	while true do

		if i==Count then
			break
		end

		if not GetImpactValue("Build"..i,"buildingburgledtoday") then	
			if BuildingGetOwner("Build"..i,"BuildingOwner") then
				if DynastyGetDiplomacyState("SIM", "BuildingOwner")<=DIP_NEUTRAL then
					found = true
					break
				end
			end
		end

		i = i + 1
	end

	if found==true then
		CopyAlias("Build"..i, "BurgleHouse")
		return 100
	end
	
	return 0
end

function Execute()
	local DynID = GetDynastyID("dynasty")

	if not HasProperty("BurgleHouse","ScoutedBy"..DynID) and Rand(100) > 30 then
		MeasureRun("SIM","BurgleHouse","ScoutAHouse")
		return
	end
	
	MeasureRun("SIM","BurgleHouse","BurgleAHouse")
	return
end

