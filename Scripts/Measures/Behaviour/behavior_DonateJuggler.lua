function Run()

    if GetImpactValue("","HaveBeenPickpocketed")>0 then
		return
	end
    ai_GetWorkBuilding("Actor", 102, "Juggler")
    local begbonus = math.floor(GetImpactValue("Juggler",394))
	local spender = SimGetRank("")
	local spend
	if spender == 0 or spender == 1 then
	    return
	elseif spender == 2 then
	    spend = Rand(5)+5
	elseif spender == 3 then
	    spend = Rand(5)+10
	elseif spender == 4 then
	    spend = Rand(10)+10
	elseif spender == 5 then
	    spend = Rand(10)+20
	end
	local getbeg = math.floor(spend + ((spend / 100) * begbonus))
	CreditMoney("Actor",getbeg,"Offering")
    ShowOverheadSymbol("Actor",false,true,0,"%1t",getbeg)
    if IsDynastySim("Owner") then
        SpendMoney("Owner",getbeg,"Offering")
    end
	AddImpact("Owner", "HaveBeenPickpocketed", 1, 4)

end

