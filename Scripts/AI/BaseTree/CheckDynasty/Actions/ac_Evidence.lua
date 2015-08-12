function Weight()

	if not ReadyToRepeat("dynasty", "AI_evidence"..GetID("dynasty")) then
		return 0
	end

	if GetSettlement("SIM","_city") then
		local TopDynastyID = GetProperty("_city","Crimes_TopAccuserDynastyID")
		local TopActorID = GetProperty("_city","Crimes_TopActorID")
		local TopBias = GetProperty("_city","Crimes_TopBias")
		
		if TopDynastyID==GetID("dynasty") then
			if GetAliasByID(TopActorID,"Actor") then
				
				return 100
			end
		end
	end
	
	return 0
end

function Execute()
	
	local	Blackmail = false
	local ActorLevel = SimGetOfficeLevel("Actor")
	
	if ActorLevel >= 0  then
		local MyLevel = SimGetOfficeLevel("SIM")
		if MyLevel < ActorLevel then
			local RandVal = 40 + (ActorLevel - MyLevel)*15
			if RandVal < Rand(100) then
				Blackmail = true
			end
		end
	end

	SetRepeatTimer("dynasty", "AI_evidence"..GetID("dynasty"),	12)
		
	if Blackmail then
		MeasureRun("SIM", "Actor", "BlackmailCharacter")
		return
	end
	MeasureRun("SIM", "Actor", "ChargeCharacter")
end

