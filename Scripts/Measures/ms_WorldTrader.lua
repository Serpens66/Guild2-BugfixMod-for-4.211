function Run()	
	GetScenario("scenario")
	if not HasProperty("scenario", "static") then
		local CartType = CartGetType("")
	
		if CartType == EN_CT_MERCHANTMAN_BIG or CartType == EN_CT_MERCHANTMAN_SMALL then
			SetData("TraderType", 0)	-- Free tradership
		else
			SetData("TraderType", 1)	-- Free tradercart
		end
		
		if not ms_worldtrader_SetupFreeTrader() then
			return
		end
		
		while true do
			RemoveData("Source")
			
			ms_worldtrader_GotoSource()
			ms_worldtrader_SetTarget()		
			while ms_worldtrader_BuyThreeMostNeededGoods() ~= 1 do
				Sleep(20)
			end
			ms_worldtrader_GotoTarget()
			ms_worldtrader_SellGoods()
		end
	end
end

function SetupFreeTrader()
	local Type = GetData("TraderType")
	local Count = ScenarioGetObjects("Settlement", 20, "City")
	if Count==0 then
		return false
	end
	
	local LandSourceCount = 0
	local WaterSourceCount = 0
	local LandTargetCount = 0
	local WaterTargetCount = 0
	
	for l=0,Count-1 do
		Alias = "City"..l
		if CityIsKontor(Alias) then
			if CityGetRandomBuilding(Alias, -1, GL_BUILDING_TYPE_KONTOR, -1, -1, FILTER_IGNORE, "Source1"..LandSourceCount) and not BuildingGetWaterPos("Source1"..LandSourceCount, true, "WaterPos") then
				SetData("Source1"..LandSourceCount..INVENTORY_SELL,1)
				LandSourceCount = LandSourceCount + 1
			elseif CityGetRandomBuilding(Alias, -1, GL_BUILDING_TYPE_KONTOR, -1, -1, FILTER_IGNORE, "Source0"..WaterSourceCount) and BuildingGetWaterPos("Source0"..WaterSourceCount, true, "WaterPos") then
				SetData("Source0"..WaterSourceCount..INVENTORY_SELL,1)
				WaterSourceCount = WaterSourceCount + 1
			end
		else
			if CityGetRandomBuilding(Alias, -1, GL_BUILDING_TYPE_MARKET, -1, -1, FILTER_IGNORE, "Target1"..LandTargetCount) then
				LandTargetCount = LandTargetCount + 1
			end
			if CityGetRandomBuilding(Alias, -1, GL_BUILDING_TYPE_HARBOR, -1, -1, FILTER_IGNORE, "Target0"..WaterTargetCount) then
				WaterTargetCount = WaterTargetCount + 1
			end
		end
	end
	
	if Type == 1 and (LandTargetCount==0 or LandSourceCount==0) then
		return false
	end
	
	if Type == 0 and (WaterTargetCount==0 or WaterSourceCount==0) then
		return false
	end
	
	if Type == 0 then
		SetData("SourceCount", WaterSourceCount)
		SetData("TargetCount", WaterTargetCount)
	else
		SetData("SourceCount", LandSourceCount)
		SetData("TargetCount", LandTargetCount)	
	end
	
	return true
end

function SetTarget()
	local Type = GetData("TraderType")
	local TargetCount = GetData("TargetCount")
	local CurrentTarget = GetData("Target")
	local NewTarget = "Target"..Type..Rand(TargetCount)
	
	while CurrentTarget == NewTarget and TargetCount > 1 do
		NewTarget = "Target"..Type..Rand(TargetCount)
		Sleep(1)
	end
	
	SetData("Target", NewTarget)
end

function GotoTarget()
	local Target = GetData("Target")
	local AltTarget = GetData("Source")
	
	while not (GetImpactValue(AltTarget, "TradingRoutePlundered") == 0) do
		Sleep(10)
	end

	
	if not f_MoveTo("", Target, GL_MOVESPEED_RUN) then
		return false
	end

	return true
end

function GotoSource()
	-- get random kontor and go back
	-- target: the city the cart comes from
	local Type = GetData("TraderType")
	local SourceCount = GetData("SourceCount")
	if not SourceCount then
		return false
	end
	
	local Source = "Source"..Type..Rand(SourceCount)
	local AltTarget = GetData("Target")

	SetData("Source", Source)

	if not f_MoveTo("", Source, GL_MOVESPEED_RUN) then
		return false
	end

	return true
end

function BuyThreeMostNeededGoods()
	local Target = GetData("Target")
	local Level = CityGetLevel(Target)
	local Resources = {
		"Charcoal", 
		"Wool", 
		"Herring", 
		"Salmon", 
		"Iron", 
		"Holzzapfen",
		"Beschlag",
		"Silver", 
		"BarleyFlour",
		"WheatFlour",
		"Oakwood", 
		"Pinewood", 
		"Leather", 
		"Honey", 
		"Fruit"	}

	local ResourceCount = 15
	local MostNeededItems = {1,0,0}
	local MostNeededValues = {0, 0, 0}
	local Buystring = ""
	local BoughtSomething = 0
	
	-- randomize the start so all resources get bought
	local Start = Rand(ResourceCount)+1
	
	MostNeededValues[1] = ms_worldtrader_CheckItem(Level, "Pinewood", 2, 4)
	local End = ResourceCount+Start
	for i=Start,End do
		local Index = math.mod(i,ResourceCount)+1
		local ItemValue = ms_worldtrader_CheckItem(Level, Resources[Index], 10, 20)
		if ItemValue > MostNeededValues[1] then 
			MostNeededItems[3] = MostNeededItems[2]
			MostNeededItems[2] = MostNeededItems[1]
			MostNeededItems[1] = Index
			MostNeededValues[3] = MostNeededValues[2]
			MostNeededValues[2] = MostNeededValues[1]
			MostNeededValues[1] = ItemValue
			BoughtSomething = 1
		elseif ItemValue > MostNeededValues[2] then
			MostNeededItems[3] = MostNeededItems[2]
			MostNeededItems[2] = Index
			MostNeededValues[3] = MostNeededValues[2]
			MostNeededValues[2] = ItemValue
		elseif ItemValue > MostNeededValues[3] then
			MostNeededItems[3] = Index
			MostNeededValues[3] = ItemValue
		end
	end
	
	for j=1,3 do
		if MostNeededItems[j] ~= 0 then
		
			local index = MostNeededItems[j]
			AddItems("", Resources[index] , MostNeededValues[j], INVENTORY_STD)

		end
	end
	return BoughtSomething
end

function CheckItem(CityLevel, Item, MinCount, MaxCount)
	local Wanted = 0
	Wanted = MinCount + math.floor( (Rand(5) + MaxCount - MinCount)*(CityLevel+2)/5)
	
	local Count = GetItemCount(GetData("Target"), Item, INVENTORY_STD)
	if Count < Wanted then
		return (Wanted - Count)
	end
	
	return 0
end

function SellGoods()
	Sleep(1)

	local Slots = InventoryGetSlotCount("", INVENTORY_STD)
	local ItemId
	local ItemCount
	local Target = GetData("Target")
	
	for Number = Slots-1, 0, -1 do
		ItemId, ItemCount = InventoryGetSlotInfo("", Number, InventoryType)
		if ItemId and ItemCount then
			--Transfer("", Target, INVENTORY_STD, "", INVENTORY_STD, ItemId, ItemCount)
			AddItems(Target, ItemId, 1.5*ItemCount, INVENTORY_STD)
			RemoveItems("", ItemId, ItemCount, INVENTORY_STD)
			local ItemName = GetDatabaseValue("Items", ItemId, "name")
		end
	end
	Sleep(1)
end

function CleanUp()
end

