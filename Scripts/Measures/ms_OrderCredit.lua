-- ******** THANKS TO KINVER ********
function aidecide()
	SimGetWorkingPlace("", "BuildingPointer")
	BuildingGetOwner("BuildingPointer", "BankChief")

	local cash = GetMoney("BankChief")

	local DecideValue

	if not HasProperty("BuildingPointer","KreditKonto") then
		if cash > 10000 then
			DecideValue = 3
		elseif cash > 5000 then
			DecideValue = 2
		else
			DecideValue = 1
		end
	else
		local Lmoney = GetProperty("BuildingPointer","KreditKonto")
		local Random = Rand(100)
		DecideValue = "C"
		if cash > 10000 then
			if (Lmoney < 4000) and (Random > 85) then
				DecideValue = 3
			elseif (Lmoney < 4000) and (Random > 75) then
				DecideValue = 2
			elseif (Lmoney < 4000) and (Random > 65) then
				DecideValue = 1
			end
		elseif cash > 6500 then
			if (Lmoney < 2100) and (Random > 75) then
				DecideValue = 2
			elseif (Lmoney < 2100) and (Random > 65) then
				DecideValue = 1
			end
		elseif cash > 2000 then		
			if (Lmoney < 800) and (Random > 75) then
				DecideValue = 2
			elseif (Lmoney < 800) and (Random > 65) then
				DecideValue = 1
			end
		elseif cash < 1000 then
			DecideValue = 4
		end
	end
	return DecideValue
end

function Run()

	if IsAIDriven() then
		SimGetWorkingPlace("", "BuildingPointer")
		BuildingGetOwner("BuildingPointer", "BankChief")

		CopyAlias("","Actorpointer")
		if HasProperty("Actorpointer", "SpecialMeasureDestination") then
			RemoveProperty("Actorpointer", "SpecialMeasureDestination")
		end
		if HasProperty("Actorpointer", "SpecialMeasureId") then
			RemoveProperty("Actorpointer", "SpecialMeasureId")
		end

		if IsDynastySim("Actorpointer") then
			StopMeasure()			
		end

	else
		BuildingGetOwner("","BankChief")
		CopyAlias("","BuildingPointer")
	end

	local cash = GetMoney("BankChief")
	cash = math.floor(cash)
	
	if cash < 0 and not HasProperty("BuildingPointer","KreditKonto") then
		MsgQuick("","@L_MEASURE_ORDERCREDIT_FAIL_+0")
		StopMeasure()
	end

	local MinMoney
	local MedMoney
	local BigMoney

	if cash > 0 then
		MinMoney = math.max((cash / 100) * 2 , 1)
		MedMoney = math.max((cash / 100) * 5 , 1)
		BigMoney = math.max((cash / 100) * 10 , 1)	
	else
		MinMoney = 0
		MedMoney = 0
		BigMoney = 0	
	end
		
	local kreditR
	local xtra = ""
	local xtrb = ""
	local KontoStand = 0	
	
	if HasProperty("BuildingPointer","KreditKonto") then
		xtra = "@B[4,@L_MEASURE_ORDERCREDIT_STUFF_+3]@B[5,@L_MEASURE_ORDERCREDIT_STUFF_+5]"
		xtrb = "@L_MEASURE_ORDERCREDIT_BODY_+1"
		KontoStand = GetProperty("BuildingPointer","KreditKonto")
	else
		xtrb = "@L_MEASURE_ORDERCREDIT_BODY_+0"
		KontoStand = 0
	end

	local SimAlias
	local TakeLoanSimCount = 0
	local RentMoney = 0
	local BankName = GetID("")
	local TotalSimCount = ScenarioGetObjects("cl_Sim", 9999, "SimAr")
	for i=0, TotalSimCount-1 do
		SimAlias = "SimAr"..i
		local GBankName = GetProperty(SimAlias, "SchuldenGeb")
		if BankName == GBankName then
			TakeLoanSimCount = TakeLoanSimCount + 1
			local GBankMoney = GetProperty(SimAlias, "SchuldenMeng")
			RentMoney = RentMoney + GBankMoney
		end
	end
	local Comment = "@B[7,@LDebtors: %5n Person and Total Money: %6t]"

	local layCred = ""
	layCred = layCred.."@B[1,@L_MEASURE_ORDERCREDIT_STUFF_+0]"
	layCred = layCred.."@B[2,@L_MEASURE_ORDERCREDIT_STUFF_+1]"
	layCred = layCred.."@B[3,@L_MEASURE_ORDERCREDIT_STUFF_+2]"

	kreditR = MsgNews(
		"",
		"",
		"@P"..layCred..xtra.."@B[6,@L_MEASURE_ORDERCREDIT_STUFF_+4]"..Comment,
		ms_ordercredit_aidecide,
		"intrigue",
		1,
		"@L_MEASURE_ORDERCREDIT_HEAD_+0",
		xtrb,
		MinMoney, MedMoney, BigMoney, KontoStand, TakeLoanSimCount, RentMoney)

	if kreditR=="C" then
		StopMeasure()
	end	

	local invest = 0
	if kreditR == 1 then
	    invest = MinMoney
	elseif kreditR == 2 then
	    invest = MedMoney
	elseif kreditR == 3 then
	    invest = BigMoney
	elseif kreditR == 4 then
		invest = GetProperty("BuildingPointer","KreditKonto")
		CreditMoney("BankChief",invest,"Credit")
		SetProperty("BuildingPointer","KreditKonto",0)
		StopMeasure()
	elseif kreditR == 5 then
		invest = GetProperty("BuildingPointer","KreditKonto")
		CreditMoney("BankChief",invest,"Credit")
		RemoveProperty("BuildingPointer","KreditKonto")
		StopMeasure()
	elseif kreditR == 6 then
	    StopMeasure()
	else
	    StopMeasure()
	end
		
	SpendMoney("BankChief",invest,"Credit")

	if HasProperty("BuildingPointer","KreditKonto") then
		local habKonto = GetProperty("BuildingPointer","KreditKonto")
		invest = invest + habKonto
	end

	SetProperty("BuildingPointer","KreditKonto",invest)

	StopMeasure()
end

function CleanUp()
	if AliasExists("Actorpointer") then
		if HasProperty("Actorpointer", "SpecialMeasureDestination") then
			RemoveProperty("Actorpointer", "SpecialMeasureDestination")
		end
		if HasProperty("Actorpointer", "SpecialMeasureId") then
			RemoveProperty("Actorpointer", "SpecialMeasureId")
		end
		if HasProperty("Actorpointer", "AIDecideNow") then
			RemoveProperty("Actorpointer", "AIDecideNow")
		end
		RemoveAlias("Actorpointer")
	end
end
