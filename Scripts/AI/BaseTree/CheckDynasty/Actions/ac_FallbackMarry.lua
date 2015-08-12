function Weight()
	-- Allow Shadows to marry
	--if DynastyIsShadow("SIM") then
	--	return 0
	--end
	
	if SimGetDeadSpouseCount("SIM")>0 then
		-- dont force if the sim was married bevor
		return 0
	end
	
	if SimGetAge("SIM") < 35 then
		return 0
	end
	
	if SimGetSpouse("SIM", "Spouse") then
		return 0
	end

	if SimGetCourtLover("SIM", "Beloved") then
		return 0
	end
	
--	if not ReadyToRepeat("SIM", "AI_FBMarry") then
--		return 0
--	end
	SetRepeatTimer("SIM", "AI_FBMarry", 0.1)
	
	if not GetSettlement("SIM", "FB_City") then
		return 0
	end
	
	local	Selection
	local BestValue = 9999
	local Partners = Find("SIM", "__F((Object.GetObjectsFromCity(Sim))AND NOT(Object.GetState(townnpc))AND NOT(Object.HasDynasty()))","Partner", -1)

	if Partners>0 then
		for Lauf=0,Partners-1 do
			Alias = "Partner"..Lauf

			if SimCanStartCourtLover("SIM", Alias) then
				Value = SimGetAge(Alias) - SimGetAge("SIM")
				if Value<0 then
					Value = -Value
				end
				
				if not Selection or Value < BestValue then
					Selection = Alias
					BestValue = Value
				end
			end
		end
	end
	
	if Selection then
		CopyAlias(Selection, "FBMarry")
		return -1
	end

	return 0
end

function Execute()
	SimMarry("SIM", "FBMarry")
end

