function Run()
end

function OnLevelUp()
end

function Setup()
end

function PingHour()
	local currentRound = GetRound()
	if currentRound > 0 then
		BuildingGetCity("","city")
		local currentGameTime = math.mod(GetGametime(),24)
		if (currentGameTime == 12) or ((currentGameTime > 12) and (currentGameTime < 13)) then
			if GetOfficeTypeHolder("city", 1, "Office") then
				chr_SimAddImperialFame("Office",1)
			end
			if GetOfficeTypeHolder("city", 6, "Office") then
				chr_SimAddFame("Office",2)
			end	
			if GetOfficeTypeHolder("city", 7, "Office") then
				chr_SimAddFame("Office",3)
			end	
		end
	end
end
