function Weight()
	if not FindNearestBuilding("SIM", -1, GL_BUILDING_TYPE_WEDDINGCHAPEL, -1, false, "WeddingChapel") then
		return 0
	end
	
	if SimGetAge("SIM")<30 then
		return 0
	end
	
	local time = math.mod(GetGametime(),24)
	if time > 20 or time < 6 then
		return 0
	end

--	local Count = SimGetChildCount("SIM")
--	local MaxChilds = 3

--	if SimGetGender("SIM")==GL_GENDER_MALE then
--		if SimGetSpouse("SIM", "Spouse") then
--			if (SimGetAge("Spouse")>40) then
--				if Count < MaxChilds then
--					return 100
--				end
--			end
--		end
--	else
	--	if SimGetSpouse("SIM", "Spouse") then
	--		if (SimGetAge("Spouse")>55) then
	--			if Count < MaxChilds then
	--				return 100
	--			end
	--		end
	--	end
	--end
	local Count = SimGetChildCount("SIM")

	if SimGetSpouse("SIM", "Spouse") then
	
		if Count == 0 and SimGetChildCount("Spouse")==0 then
			return 100
		end

	else
	
	return 0
	end
end

function Execute()
	MeasureRun("SIM", "WeddingChapel", "AdoptOrphan")
end
