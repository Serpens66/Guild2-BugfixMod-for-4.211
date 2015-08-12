function Weight()
	if SimGetGender("SIM")==GL_GENDER_MALE then
		return 0
	end

	if not SimGetSpouse("SIM", "Spouse") then
		return 0
	end

	--[[if DynastyIsShadow("SIM") then
		if SimGetOfficeLevel("SIM")<3 and SimGetOfficeLevel("Spouse")<3 then
			return 0
		end
	end]]
	
	if not GetHomeBuilding("SIM", "home") then
		return 0
	end
	
	if DynastyGetBuildingCount("SIM", 1, 2) < 1 then
		return 0
	end

	if GetStateImpact("Spouse", "no_control") then
		return 0
	end
	
	if SimGetBehavior("Spouse")=="CheckPresession" or SimGetBehavior("Spouse")=="CheckTrial" then
		return 0
	end

	local Count = SimGetChildCount("SIM")
	local MaxChilds = 2 + math.mod(GetID("SIM"), 3)
	
	if SimGetChildCount("SIM") < MaxChilds then
		return 100
	end

	return 0
end

function Execute()
	if not SimGetSpouse("SIM", "Spouse") then
		return
	end
	
	if ModifyFavorToSim("SIM", "Spouse",5)<70 then
		-- try to boost the favor to the partner
		local Measure
		local	Count = 0
		local Arr
		local Court

		Arr = {}

		for Measure=0,7 do
			Court = CourtingId2Measure(Measure)
			if GetMeasureRepeat("SIM", Court, "Spouse")<=0 then
				Arr[Count] = Court
				Count = Count + 1
			end
		end

		if Count==0 then
			return
		end

		local MeasureName = Arr[Rand(Count)]
		if MeasureName~="" then
			MeasureRun("SIM", "Spouse", MeasureName)
		end
		return
	end
	
	SetRepeatTimer("SIM", "AI_CohabitWithCharacter", 4)
	MeasureRun("SIM", "Spouse", "CohabitWithCharacter")
end
