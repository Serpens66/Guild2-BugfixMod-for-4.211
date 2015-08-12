-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_001_MakeEvocation"
----
----	with this measure the alchimist is able to make an evocation
----
-------------------------------------------------------------------------------


function Run()
	if not GetInsideBuilding("", "Building") then
		StopMeasure()
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	local	Slots = InventoryGetSlotCount("", INVENTORY_STD)
	local	Number
	local	ItemId
	local	ItemCount
	local	NumItems = 0
	local	ItemName = {}
	local	ItemLabel = {}
	local 	btn = ""
	local	added = {}
	local	ItemTexture
	
	--count all items, remove duplicates
	for Number = 0, Slots-1 do
		ItemId, ItemCount = InventoryGetSlotInfo("", Number, InventoryType)
		if ItemId and ItemId>0 and ItemCount then
			if ItemGetType(ItemId) == 8 then	--gathering item
				if not added[ItemId] then
					
					added[ItemId] = true
				
					--create labels for replacements
					ItemName[NumItems] = ItemId 
					ItemTextureName = ItemGetName(ItemId)
					ItemTexture = "Hud/Items/Item_"..ItemTextureName..".tga"
					btn = btn.."@B[A"..NumItems..",,%"..1+NumItems.."l,"..ItemTexture.."]"
					ItemLabel[NumItems] = ""..ItemGetLabel(ItemName[NumItems],true)
					NumItems = NumItems + 1
	
				end
			end
		end
	end
	SetData("NumItems",NumItems)
	
	local Result
	if Slots > 0 and NumItems > 0 then				
		Result = InitData("@P"..btn,
				ms_001_makeevocation_AIDecide,  --AIFunc
				"@L_MEASURE_MakeEvocation_NAME_+0",
				"",
				ItemLabel[0],ItemLabel[1],
				ItemLabel[2],ItemLabel[3],
				ItemLabel[4],ItemLabel[5])
				
		
	else
		MsgQuick("","@L_ALCHEMIST_001_MAKEEVOCATION_FAILURES_+0")
		StopMeasure()
	end
	
	if Result == "C" then
		StopMeasure()
	end
	
	--check the item
	local ItemIndex
	if Result == "A0" then
		ItemIndex = 0
	elseif Result == "A1" then
		ItemIndex = 1
	elseif Result == "A2" then
		ItemIndex = 2
	elseif Result == "A3" then
		ItemIndex = 3
	elseif Result == "A4" then
		ItemIndex = 4
	else
		ItemIndex = 5
	end

	--make sure there's room in inventory with item removed. If not, put item back and end measure.
	RemoveItems("",ItemName[ItemIndex],1,INVENTORY_STD)
	local HasRoom = 0
	Slots = InventoryGetSlotCount("", INVENTORY_STD)
	for Number = 0, Slots-1 do
		ItemId, ItemCount = InventoryGetSlotInfo("", Number, InventoryType)
		if ItemId and ItemId>0 and ItemCount then
			--nothing
		else
			HasRoom = 1
		end
	end
	
	if HasRoom == 0 then
		MsgQuick("","@L_GENERAL_INFORMATION_INVENTORY_INVENTORY_FULL_SPEECH_+3")
		AddItems("",ItemName[ItemIndex],1,INVENTORY_STD)
		StopMeasure()
	end

	SetData("ItemUsed",ItemName[ItemIndex])
	SetData("SummonComplete",0)
	
	-- do the visual stuff here
	GetLocatorByName("Building", "Ritual1", "Evocation1")
	f_MoveTo("","Evocation1")
	PlayAnimation("", "cogitate")
	GetLocatorByName("Building", "Ritual2", "Evocation2")
	f_MoveTo("","Evocation2")
	PlayAnimation("", "manipulate_middle_twohand")
	GetLocatorByName("Building", "Ritual3", "Evocation3")
	GetLocatorByName("Building", "ParticleSpawnPos","SpawnPos")
	f_MoveTo("","Evocation3")
	local AnimTime = PlayAnimationNoWait("", "make_evocation")
	Sleep(AnimTime-2)

	--do the evocation stuff
	SetMeasureRepeat(1)	
	SetData("SummonComplete",1)
	
	local SumGold
	local EvocationSkill = GetSkillValue("",10) * 10 --secret knowledge
	local EvocationChance = Rand(110)
	local Success = false

	if EvocationSkill > EvocationChance then
		if ItemGetID(ItemName[ItemIndex]) == 243 then		--gold
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			AddItems("","Iron",1)
			ms_001_makeevocation_Success(243,241)

		elseif ItemGetID(ItemName[ItemIndex]) == 134 then	--spiderleg
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			AddItems("","PoisonedCake",1)
			ms_001_makeevocation_Success(134,140)

		elseif ItemGetID(ItemName[ItemIndex]) == 202 then	--oakwood
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			AddItems("","OakwoodRing",1)
			ms_001_makeevocation_Success(202,79)

		elseif ItemGetID(ItemName[ItemIndex]) == 131 then	--frogeye
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			AddItems("","PoisonedCake",1)
			ms_001_makeevocation_Success(131,140)

		elseif ItemGetID(ItemName[ItemIndex]) == 9 then		--cattle
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			AddItems("","Sheep",1)
			ms_001_makeevocation_Success(9,7)

		elseif ItemGetID(ItemName[ItemIndex]) == 7 then		--sheep
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			AddItems("","Cattle",1)
			ms_001_makeevocation_Success(7,9)

		elseif ItemGetID(ItemName[ItemIndex]) == 242 then	--silver
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)
			SumGold = chr_RecieveMoney("",Rand(300)+300,"Evocation")
			ms_001_makeevocation_SuccessGold(242,SumGold)

		elseif ItemGetID(ItemName[ItemIndex]) == 241 then	--iron
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)
			SumGold = chr_RecieveMoney("",Rand(300)+100,"Evocation")
			ms_001_makeevocation_SuccessGold(241,SumGold)

		else
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
--			PlayAnimation("","cogitate")
			ms_001_makeevocation_Nothing()
		end
	else
		StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
--		PlayAnimation("","cogitate")
		ms_001_makeevocation_Nothing()
	end
end

function Success(item1,item2)
	feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",
					"@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_BODY_+1",ItemLabel[item1],ItemLabel[item2])
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()
end

function SuccessGold(item1,gold)
	feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",
					"@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_BODY_+0",ItemLabel[item1],gold)
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()
end

function Nothing()
	StartSingleShotParticle("particles/toadexcrements_hit.nif", "SpawnPos", 1.3,5)
	feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_FAILED_HEAD_+0",
					"@L_ALCHEMIST_001_MAKEEVOCATION_FAILED_BODY_+0")
	StopMeasure()
end

function AIDecide()
	NumItems = GetData("NumItems")
	return "A"..NumItems
end

function CleanUp()
	MsgMeasure("","")
	if GetData("SummonComplete") == 0 then
  	AddItems("",GetData("ItemUsed"),1,INVENTORY_STD)
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end


