function Init()
	SetStateImpact("no_hire")
	SetStateImpact("no_control")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_measure_start")	
	SetStateImpact("no_action")	
end

function Run()

	if not (GetVehicle("", "MyCart")) then
		return
	end 

	if not ExitCurrentVehicle("MyCart") then
		return
	end

	if not GetEvadePosition("", 1500, "fleepos") then
	 	return
	end
	
	SetProperty("MyCart","BeeingPlundered",1)

 	f_MoveTo("", "fleepos",GL_MOVESPEED_RUN)
	AlignTo("", "MyCart")
	Sleep(1)

	PlayAnimation("","insult_character")
	PlayAnimation("","threat")
	local	Empty
	local	ItemID
	local ItemCount
	local Slots
	
	--scan for enemies
	local Enemies = 1
	while (Enemies > 0) do
	
		Enemies = Find("MyCart","__F( (Object.GetObjectsByRadius(Sim)==1500)AND(Object.IsHostile()))", "FindResult",-1)
		
		Slots = InventoryGetSlotCount("MyCart", INVENTORY_STD)
		Empty = true
		for s=0,Slots-1 do
			ItemID, ItemCount = InventoryGetSlotInfo("MyCart", INVENTORY_STD, s)
			if ItemID and ItemCount and ItemID>0 then
				Empty = false
				break
			end
		end
		
		if Empty then
			break
		end
		
		Sleep(4)
		
	end
		
	--return to cart
	if not AliasExists("MyCart") then
		if not (GetVehicle("", "MyCart")) then
			return
		end
	end

	local radius = GetRadius("MyCart")
	f_MoveTo("", "MyCart", GL_MOVESPEED_RUN, radius )
	AlignTo("", "MyCart")	
	if (GetHPRelative("MyCart") < 0.30) then
		PlayAnimation("", "crank_front_in")
	end
	while (GetHPRelative("MyCart") < 0.30) do
		PlayAnimation("", "crank_front_loop")
		ModifyHP("MyCart", 1, false)
	end
	
	--if not SimGetWorkingPlace("", "WorkPlace") then
	--	return
	--end

	--f_MoveTo("MyCart", "WorkPlace", GL_MOVESPEED_RUN)
end

function CleanUp()
	--return to cart
	if not AliasExists("MyCart") then
		if not (GetVehicle("", "MyCart")) then
			return
		end
	end
	EnterVehicle("", "MyCart")
end

