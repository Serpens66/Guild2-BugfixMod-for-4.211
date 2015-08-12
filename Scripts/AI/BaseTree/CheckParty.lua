function Weight()

	if not ReadyToRepeat("dynasty", "AI_CheckPartyMember") then
		return 0
	end	

	local Count = DynastyGetMemberCount("dynasty")
	if Count > 2 then
		return 0
	end
	
	local Count = DynastyGetFamilyMemberCount("dynasty")
	local	idx
	local BestWeight = -1
	
	for idx=0,Count-1 do
		if DynastyGetFamilyMember("dynasty", idx, "member") then
			local Weight =  checkparty_CheckMember("member")
			if Weight > BestWeight then
				BestWeight = Weight
				CopyAlias("member", "SIM")
			end
		end
	end
	
	if not AliasExists("SIM") then
		SetRepeatTimer("dynasty", "AI_CheckPartyMember", 0.75)
		return 0
	end
	
	return 100
end

function CheckMember(SimAlias)
	if GetState(SimAlias, STATE_DEAD) or GetState(SimAlias, STATE_DYING) then
		return -1
	end
	
	local Age = SimGetAge(SimAlias)
	
	if Age>68 or Age<18 then
		return -1
	end
	
	if IsPartyMember(SimAlias) then
		return -1
	end
	
	local Weight
	Weight = 2*(68 - (Age - 18)) + SimGetLevel(SimAlias) * 10
	
	return Weight
end

function Execute()
	DynastyAddMember("dynasty", "SIM")
end

