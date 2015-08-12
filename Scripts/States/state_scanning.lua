function Run()
	-- dont remove this line since it sets the owners dynasty that is needed for later filter
	GetDynasty("", "Dynasty")
	
	while not GetState("", STATE_DEAD) do
	
		if IsType("","Sim") then
			state_scanning_ArrestLoop(false)
		elseif IsType("","Building")then
			state_scanning_WatchtowerLoop() 
			if GetDynastyID("")<1 then
				state_scanning_ArrestLoop(true)
			end
		end
		Sleep(1)
	end
end


function ArrestLoop(IsBuilding)

	if IsBuilding==false and GetState("", STATE_IDLE)==false then
		return
	end
	
	if CityGuardScan("", "Penalty") then	-- find a fugitive (and with no impact "no_arrestable")
		if PenaltyGetOffender("Penalty", "Wanted") then -- wanted found -> arrest him
			if IsBuilding then
				if not GetState("Wanted", STATE_UNCONSCIOUS) then
					gameplayformulas_SimAttackWithRangeWeapon("", "Wanted")
					BattleJoin("", "Wanted", true)
				end
			else
				if GetDistance("","Wanted")<4000 then
					MeasureRun("", "Wanted", "Arrest")
				end
			end
		end
	end
end

function WatchtowerLoop()
	if not GetState("", STATE_FIGHTING) then
		-- Detect enemy ships
		local ShipFilter = "__F((Object.GetObjectsByRadius(Ship)==4000)AND(Object.IsHostile()))"
		local NumOfShips = Find("", ShipFilter,"HostileShip", -1)
		if NumOfShips > 0 then
			local iBattleID = BattleJoin("","HostileShip", false)
			return
		end
		
		--Detect enemy and fighting Sims
		local SimFilter = "__F((Object.GetObjectsByRadius(Sim)==2000)AND(Object.IsInCombatWithMyDynasty()))"
		local NumOfSims = Find("", SimFilter,"HostileSim", -1) 
		if NumOfSims > 0 then
			local iBattleID = BattleJoin("","HostileSim", false)
			return
		end	
	end	
end

