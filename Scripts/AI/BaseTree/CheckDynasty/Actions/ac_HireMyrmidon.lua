function Weight()
	if GetMoney("dynasty") < 750 then
		return 0
	end
	
	if not GetHomeBuilding("SIM", "myrm_home") then
		return 0
	end
		
	if not BuildingCanHireNewWorker("myrm_home") then
		return 0
	end
	
	local Value	= DynastyGetRanking("dynasty")
	local	Wanted= 1 + (Value / 25000)
	local Have	= DynastyGetWorkerCount("dynasty", GL_PROFESSION_MYRMIDON)
	if Have >= Wanted then
		return 0
	end
	
	return 100
end

function Execute()
	HireWorker("myrm_home")
end

