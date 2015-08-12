function Run()
	local ItemID = ResourceGetItemId("destination")
	SimSetProduceItemID("", ItemID, GetID("destination"))
	local error = MeasureRun("","destination","BaseProduce")	
end
