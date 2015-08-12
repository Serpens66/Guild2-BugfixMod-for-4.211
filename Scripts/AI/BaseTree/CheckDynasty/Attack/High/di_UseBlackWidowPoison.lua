function Weight()
	local	Item = "BlackWidowPoison"
	if GetMeasureRepeat("SIM", "Use"..Item)>0 then
		return 0
	end

	if GetItemCount("", Item, INVENTORY_STD)==0 then
		local Price = ai_CanBuyItem("SIM", Item)
		local Round = GetRound()
		if not HasProperty("dynasty", "ItemBudget"..Round) then
			ai_CalcItemBudget("dynasty")
		end
		
		if GetProperty("dynasty", "ItemBudget"..Round) < Price then
			return 0
		end
		if Price<0 then
			return 0
		end
	end

	local NumDynasties = ScenarioGetObjects("cl_Dynasty",99,"OutPutDyn")
	local MySettlementID = GetSettlementID("SIM")
	local Count
	local VictimNo
	
	for i=0,NumDynasties-1 do
		Count = DynastyGetMemberCount("OutPutDyn"..i)
		VictimNo = Rand(Count)
		if (DynastyGetMember("OutPutDyn"..i, VictimNo, "Victim")) then
			if GetSettlementID("Victim")==MySettlementID then	
				local DipToSim = DynastyGetDiplomacyState("dynasty","OutPutDyn"..i)
				if (DipToSim==DIP_FOE) and not (GetImpactValue("Victim","poisoned")>0) and not (GetDistance("","Victim")>1500) then
					return 100
				end
			end
		end
	end
	
	return 0
end

function Execute()
	MeasureRun("SIM", "Victim", "UseBlackWidowPoison")
end
