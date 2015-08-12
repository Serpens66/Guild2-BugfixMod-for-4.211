function Run()

	if not BuildingGetCity("","City") then
		StopMeasure()
	end

	local SprainInfected = 0
	local ColdInfected = 0
	local InfluenzaInfected = 0
	local BurnWoundInfected = 0
	local PoxInfected = 0
	local PneumoniaInfected = 0
	local BlackdeathInfected = 0
	local FractureInfected = 0
	local CariesInfected = 0

	local SpainItemCnt = GetItemCount("", "Bandage")
	local ColdItemCnt = GetItemCount("", "Bandage")
	local InfluenzaItemCnt = GetItemCount("", "Medicine")
	local BurnWoundItemCnt = GetItemCount("", "Medicine")
	local PoxItemCnt = GetItemCount("", "Medicine")
	local PneumoniaItemCnt = GetItemCount("", "PainKiller")
	local BlackdeathItemCnt = GetItemCount("", "PainKiller")
	local FractureItemCnt = GetItemCount("", "PainKiller")
	local CariesItemCnt = GetItemCount("", "PainKiller")

	if HasProperty("City","SprainInfected") then
		SprainInfected = GetProperty("City","SprainInfected")
	end
	if HasProperty("City","ColdInfected") then
		ColdInfected = GetProperty("City","ColdInfected")
	end
	if HasProperty("City","InfluenzaInfected") then
		InfluenzaInfected = GetProperty("City","InfluenzaInfected")
	end
	if HasProperty("City","BurnWoundInfected") then
		BurnWoundInfected = GetProperty("City","BurnWoundInfected")
	end
	if HasProperty("City","PoxInfected") then
		PoxInfected = GetProperty("City","PoxInfected")
	end
	if HasProperty("City","PneumoniaInfected") then
		PneumoniaInfected = GetProperty("City","PneumoniaInfected")
	end
	if HasProperty("City","BlackdeathInfected") then
		BlackdeathInfected = GetProperty("City","BlackdeathInfected")
	end
	if HasProperty("City","FractureInfected") then
		FractureInfected = GetProperty("City","FractureInfected")
	end
	if HasProperty("City","CariesInfected") then
		CariesInfected = GetProperty("City","CariesInfected")
	end

	MsgBoxNoWait("dynasty", "", "@L_MEASURE_showdiseasedpeople_HEAD_+0",
						"@L_MEASURE_showdiseasedpeople_BODY_+0",
						GetID("City"), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Sprain_NAME_+0", SprainInfected, SpainItemCnt, ItemGetLabel("Bandage",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Cold_NAME_+0", ColdInfected, ColdItemCnt, ItemGetLabel("Bandage",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Influenza_NAME_+0", InfluenzaInfected, InfluenzaItemCnt, ItemGetLabel("Medicine",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_BurnWound_NAME_+0", BurnWoundInfected, BurnWoundItemCnt, ItemGetLabel("Medicine",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Pox_NAME_+0", PoxInfected, PoxItemCnt, ItemGetLabel("Medicine",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Fracture_NAME_+0", FractureInfected, FractureItemCnt, ItemGetLabel("PainKiller",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Caries_NAME_+0", CariesInfected, CariesItemCnt, ItemGetLabel("PainKiller",false),
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Pneumonia_NAME_+0", PneumoniaInfected, PneumoniaItemCnt, ItemGetLabel("PainKiller",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Blackdeath_NAME_+0", BlackdeathInfected, BlackdeathItemCnt, ItemGetLabel("PainKiller",false)) 

end
