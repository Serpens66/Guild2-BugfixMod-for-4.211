function Weight()
	local	Item = "FragranceOfHoliness"
	
	if GetMeasureRepeat("SIM", "Use"..Item)>0 then
		return 0
	end
	
	if GetItemCount("", Item,INVENTORY_STD)>0 then
		return 25
	end

	local Price = ai_CanBuyItem("SIM", Item)
	if Price<0 then
		return 0
	end

	return 5
end

function Execute()
	MeasureRun("SIM", nil, "UseFragranceOfHoliness")
end
