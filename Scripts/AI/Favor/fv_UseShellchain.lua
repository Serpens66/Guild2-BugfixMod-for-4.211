function Weight()
	local	Item = "Shellchain"
	local value = ai_CheckTitleVSJewellery("SIM",1,20)
	
	if GetMeasureRepeat("SIM", "Use"..Item)>0 then
		return 0
	end
	
	if GetItemCount("", Item,INVENTORY_STD)>0 then
		value = value + 30
		return value
	end

	local Price = ai_CanBuyItem("SIM", Item)
	if Price<0 then
		return 0
	end

	return value
end

function Execute()
	MeasureRun("SIM", nil, "UseShellchain")
end
