function Run()

	if HasProperty("", "NotAffectable") then
		return "-"
	end

	if ActionIsStopped("Action") then
		-- Check if its a city guard
		if not GetState("", STATE_SCANNING) then
			return ""
		end
	end

	if GetState("",STATE_NPC) then
		return "-"
	end
	
	if GetImpactValue("","spying") == 1 then
		return ""
	end

	if BattleIsFighting("") then
		return ""
	end
	
	if GetCurrentMeasureID("")==660 then  --burglary
		return ""
	end
	
	if GetCurrentMeasureID("")==680 then  --pickpocketing
		return ""
	end
	
	if GetCurrentMeasureID("")==360 then  --attackenemy
		return ""
	end
	
	if GetCurrentMeasureID("")==3505 then  --SquadWaylayMember
		SetProperty("","DontLeave",1)
	end

	local bEvidence = ActionIsEvidence("Action")
	local bIsGuard =(GetDynastyID("") == -1) and (SimGetClass("") == GL_CLASS_CHISELER)

	-- join an existing Fight
	if not (bIsGuard) then
		if BattleGetNextEnemy("Owner", "Actor", "nextEnemy") then
			CopyAlias("nextEnemy", "Destination")
			return "Attack"
		end
	end
	
	-- starts a new Fight
	if IsType("", "Ship") then
		-- attack if i am the victim to protect myself
		if GetDynastyID("") == GetDynastyID("Victim") then
			if DynastyGetDiplomacyState("", "Actor")>DIP_NEUTRAL then
				DynastySetDiplomacyState("", "Actor", DIP_NEUTRAL)
			end
			CopyAlias("Actor", "Destination")
			return "Attack"
		end
		
		-- attack if i am allied with victim
		if DynastyGetDiplomacyState("", "Victim") == DIP_ALLIANCE then
			if DynastyGetDiplomacyState("", "Actor") <= DIP_NEUTRAL then
				CopyAlias("Actor", "Destination")
				return "Attack"
			end
		end
	end
	
	if SimGetClass("") == GL_CLASS_CHISELER then

		-- am i a robber with protectionmoney measure (ms_134_PressProtectionMoney.lua) and is my house the victim
		local bRobberGuard = HasProperty("", "RobberProtecting")
		if (bRobberGuard == true) then
			local iRobberID = GetDynastyID("")
			if AliasExists("VictimObject") then
				local iRobberProtHouseDynID = GetProperty("VictimObject", "RobberProtected")
				if (iRobberID == iRobberProtHouseDynID) then
					CopyAlias("Actor", "Destination")
					return "Attack"
				end
			end			
		end

		-- Fighter without a dynasty means guard, and guards attack illegals
		if (bEvidence and bIsGuard) then
			local	ActorID = GetDynastyID("Actor")
			if ActorID<1 or ActorID~=SimGetServantDynastyId("") then
				CopyAlias("Actor", "Destination")
				return "Attack"
			end
			SetData("Distance", 2500)
			return "-Flee"
		end

		-- attack if i am the victim to protect myself
		if AliasExists("Victim") and GetDynastyID("") == GetDynastyID("Victim") then
			if DynastyGetDiplomacyState("", "Actor")>DIP_NEUTRAL then
				DynastySetDiplomacyState("", "Actor", DIP_NEUTRAL)
			end
			CopyAlias("Actor", "Destination")
			return "Attack"
		end
		
		-- attack if i am allied with victim
		if AliasExists("Victim") and DynastyGetDiplomacyState("", "Victim") == DIP_ALLIANCE then
			if DynastyGetDiplomacyState("", "Actor") <= DIP_NEUTRAL then
				CopyAlias("Actor", "Destination")
				return "Attack"
			end
		end
	end
	
	if GetState("",STATE_ROBBERGUARD) then
		return ""
	end

	if GetDynastyID("")>0 and AliasExists("Victim") and GetDynastyID("")==GetDynastyID("Victim") then
		return "-CallGuards"
	end
	
	-- if GetFavorToSim("Owner", "Actor") > 50 then
		-- return "-Flee"
	-- end

	-- habe ich einen Nicht-Angriffs-Pakt, dann gaffe ich nur
	if Status == DIP_NAP then
		-- return "-Gape:8"
		return ""
	end
	
	-- some workless just flee at random
	local random = Rand(5)
	if ((random > 3) and (GetDynastyID("Owner") < 1)) then
		return "-Flee"
	elseif (GetDynastyID("Owner") < 1) then
		return "-Gape:8"
	end		
	
	-- der Rest ruft Wachen
	if (bEvidence) then
		return "-CallGuards:2"
	end
	
	--return "-Gape:8"
	return ""
end

