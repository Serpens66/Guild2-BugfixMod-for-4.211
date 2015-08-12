function Run()
	if not ai_GoInsideBuilding("", "", -1, GL_BUILDING_TYPE_TOWNHALL) then
		return
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	if not GetSettlement("","city") then
		StopMeasure()
	end
	if not GetInsideBuilding("","Townhall") then
		StopMeasure()
	end
	GetSettlement("Townhall","city2")
	if not GetID("city")==GetID("city2") then
		StopMeasure()
	end

	local Level = CityGetLevel("city")
	local CityTreasure = GetMoney("city")
	local CityUpgradeCost = gameplayformulas_GetCityUpgradeCost(Level)
	local citylabel = CityLevel2Label(Level)
	local nomorelvlup = false

	if Level>4 then
		-- secure that only one city can be the imperial capital in the scenario
		local	ImperialId = ScenarioGetImperialCapitalId()
		if (ImperialId>0 and ImperialId~=nil) or Level==6 then
			nomorelvlup=true
		end
	end

	local citizens = ms_levelupcity_GetValue(Level)[2]

	if nomorelvlup==true then
		MsgBoxNoWait("",false,
			"@L_MEASURE_LEVELUPCITY_HEAD_+0",
			"@L_MEASURE_LEVELUPCITY_BODY_+5",GetID("city"),citylabel)
			
	elseif HasProperty("city","LevelUpPaid") and GetProperty("city","LevelUpPaid")==1 then
		GetScenario("scenario")
		local mapid = GetProperty("scenario", "mapid")
		local scenarioname = GetDatabaseValue("maps", mapid, "lordship")
		local lordid = gameplayformulas_GetDatabaseIdByName("Lordship", scenarioname)
		local lordlabel = "@L_SCENARIO_LORD_"..GetDatabaseValue("maps", mapid, "lordship").."_+1"
		MsgBoxNoWait("",false,
			"@L_MEASURE_LEVELUPCITY_HEAD_+0",
			"@L_MEASURE_LEVELUPCITY_BODY_+4", GetID("city"),citylabel,lordlabel)
	
	elseif HasProperty("city","LevelUpCity") and GetProperty("city","LevelUpCity")==1 then
		if CityTreasure<CityUpgradeCost then
			MsgBoxNoWait("",false,
				"@L_MEASURE_LEVELUPCITY_HEAD_+0",
				"@L_MEASURE_LEVELUPCITY_BODY_+0", GetID("city"), CityUpgradeCost, citylabel)
		else
			local Result = MsgNews("",false,"@P"..
						"@B[1,@L_REPLACEMENTS_BUTTONS_JA_+0]"..
						"@B[C,@L_REPLACEMENTS_BUTTONS_NEIN_+0]",
						ms_levelupcity_AIDecision,  --AIFunc
						"default", --MessageClass
						2, --TimeOut
						"@L_MEASURE_LEVELUPCITY_HEAD_+0",
						"@L_MEASURE_LEVELUPCITY_BODY_+1", GetID("city"), CityUpgradeCost, citylabel)

			if Result==1 then
				local	ImperialId = ScenarioGetImperialCapitalId()
				if Level==5 then
					if (ImperialId<1 or ImperialId==nil) then
						ScenarioSetImperialCapital("city")
						SetProperty("city","ImperialCapital",1)
						SetProperty("city","LevelUpPaid",1)
						SpendMoney("city",CityUpgradeCost,"LevelUpPaid")
						SetMeasureRepeat(TimeOut)
					end
				else
					SetProperty("city","LevelUpPaid",1)
					SpendMoney("city",CityUpgradeCost,"LevelUpPaid")
					SetMeasureRepeat(TimeOut)
				end
			end
		end
	
	else
		if CityTreasure<CityUpgradeCost then
			MsgBoxNoWait("",false,
				"@L_MEASURE_LEVELUPCITY_HEAD_+0",
				"@L_MEASURE_LEVELUPCITY_BODY_+2", GetID("city"), CityUpgradeCost, citylabel, citizens)
		else
			MsgBoxNoWait("",false,
				"@L_MEASURE_LEVELUPCITY_HEAD_+0",
				"@L_MEASURE_LEVELUPCITY_BODY_+3", GetID("city"), citylabel, citizens)
		end
	end
end

function GetValue(Level)
	if Level==2 then
		return {0, 80}
	elseif Level==3 then
		return {90, 130}
	elseif Level==4 then
		return {140, 200}
	elseif Level==5 then
		return {200, 300}
	elseif Level==6 then
		return {260, 99999}
	end
end

function AIDecision()
	return 1
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

