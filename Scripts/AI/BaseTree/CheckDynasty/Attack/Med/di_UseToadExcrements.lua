function Weight()
	local	Item = "ToadExcrements"
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
				if (DipToSim==DIP_FOE) then
					for x=0,3 do
						if DynastyGetRandomBuilding("Dynasty", nil, nil, "VicBuilding") and not (GetImpactValue("VicBuilding","toadslime")>0) and not (GetDistance("","VicBuilding")>1500) then
							if gameplayformulas_checkBuildingNoRoom("VicBuilding")==0 then
								return 100
							end
						end
					end
				end
			end
		end
	end
	
	return 0
end

function Execute()
	MeasureRun("SIM", "diute_Target", "UseToadExcrements")
end
