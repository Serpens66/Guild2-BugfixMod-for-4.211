function Weight()

	if GetMeasureRepeat("SIM", "AddPamphlet")>0 then
		return 0
	end
	return 50
end

function Execute()
	MeasureRun("SIM","VICTIM","AddPamphlet")
end

