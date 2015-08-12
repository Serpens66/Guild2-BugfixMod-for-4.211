function Init()
	--InitAlias("Destination",GetData("PanelName"),GetData("TargetFilterID"),GetData("TargetMessage"),0)
	
	local result = InitData("@P"..
	"@B[A,,@L_GENERAL_MEASURES_SENDCARTANDUNLOAD_TEXT_+1,Hud/Buttons/Unload.tga]"..
	"@B[B,,@L_GENERAL_MEASURES_SENDCARTANDUNLOAD_TEXT_+2,Hud/Buttons/UnloadAndSendBack.tga]"..
	"@B[D,,@L_GENERAL_MEASURES_SENDCART_TEXT_+0,Hud/Buttons/SendCartAndUnload.tga]",
	ms_sendcartandunload_AIInit,
	"@L_GENERAL_MEASURES_SENDCARTANDUNLOAD_TEXT_+0",
	"")
	
	SetData("Result",result)
		 
end

function AIInit()
	return "A"
end

function Run()

--CART TRADE MENU
	
	local result = GetData("Result")
	if result == "C" then
		StopMeasure()
	end
	
	if not AliasExists("Destination") then
		StopMeasure()
	end
	CopyAlias("Destination","EndPos")
	GetPosition("","StartPos")
	
	if DynastyIsPlayer("") then
			SetProperty("", "AutoRoute")
	end
		
	if not f_MoveTo("","EndPos") then
		
		StopMeasure()
	end
	
	if result == "D" then
		MsgQuick("","@L_GENERAL_MEASURES_SENDCART_MSG_+1")
		StopMeasure()
	end
	
	--do the transfer
	local	Slots = InventoryGetSlotCount("", INVENTORY_STD)
	local	ItemId
	local	ItemCount
	local	Amount = 0
	local	Error
	local	Found = false
	local	CurrentSlot = Slots-1
	for Number = 0, Slots-1 do
		ItemId, ItemCount = InventoryGetSlotInfo("", CurrentSlot, InventoryType)
		
		if ItemId and ItemCount then
			Error, ItemTransfered = Transfer("","Destination",INVENTORY_STD,"",INVENTORY_STD,ItemId,ItemCount)
			Amount = Amount + ItemTransfered
			Found = true
		end
		CurrentSlot = CurrentSlot - 1
		Sleep(0.7)
	end
	
	if not HasData("IsShip") then
		if Amount <= 0 and Found then
		--if Amount <= 0 then 
			MsgQuick("","@L_GENERAL_MEASURES_SENDCART_MSG_+0")
			StopMeasure()
		end
		
		if result == "A" and Found then
			MsgQuick("","@L_GENERAL_MEASURES_SENDCARTANDUNLOAD_MSG_+0")
			StopMeasure()
		elseif result == "A" then
			MsgQuick("","@L_GENERAL_MEASURES_SENDCART_MSG_+1")
			StopMeasure()
		end
		
		if not f_MoveTo("","StartPos") then
			StopMeasure()
		end
		
		MsgQuick("","@L_GENERAL_MEASURES_SENDCARTANDUNLOAD_MSG_+1")
	end
	
	StopMeasure()
end

function CleanUp()

	if HasProperty("", "AutoRoute") then
		RemoveProperty("", "AutoRoute")
		
	end
	
	
end



