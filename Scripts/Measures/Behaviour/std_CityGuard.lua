function Run()

	local Player = false
	if GetSettlement("","Settlement") then	
		if GetOfficeTypeHolder("Settlement", 2 ,"Office") then		-- 2 = sheriff
			Player = DynastyIsPlayer("Office")
		end
		
		if not Player then
			AIExecutePlan("", "CityGuard", "SIM", "", "dynasty", "ServantDynasty")
			return
		end
	else
		PlayAnimation("","cogitate")
	end
	
	Sleep(Rand(20)+10)
end
