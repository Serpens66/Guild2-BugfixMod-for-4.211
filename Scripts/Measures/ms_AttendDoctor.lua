function Run()
	if GetInsideBuilding("","CurrentBuilding") then
		GetSettlement("CurrentBuilding","City")
		if BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_HOSPITAL then
			CopyAlias("CurrentBuilding","Destination")
		end
	end
	if not AliasExists("City") then
		if not GetNearestSettlement("", "City") then
			StopMeasure()
		end
	end
	
	if GetState("",STATE_TOWNNPC) then
		StopMeasure()
	end
	
	MeasureSetNotRestartable()
	
	if not AliasExists("Destination") then
	
		local DistanceBest = -1
		local Attractivity
		local Distance
		local NumHospitals = CityGetBuildings("City",2,37,-1,-1,FILTER_HAS_DYNASTY,"Hospital")
		if NumHospitals == 0 then
			MsgQuick("","@L_MEDICUS_FAILURES_+1")
			StopMeasure()
		end
		
		for i=0,NumHospitals-1 do
		
			if IgnoreID and IgnoreID == GetID("Hospital"..i) then
				Distance = -1
			else
				Attractivity = GetImpactValue("Hospital"..i,"Attractivity")		
				Attractivity = Attractivity + ((BuildingGetLevel("Hospital"..i) -1) / 2)
				Distance			= GetDistance("","Hospital"..i)
				if Distance > 0 then
					Distance = Distance / (0.5 + Attractivity)
				end
			end
			
			local MinLevel = 1
			
			if GetImpactValue("","Sprain")==1 then
				MinLevel = 1
			elseif GetImpactValue("","Cold")==1 then
				MinLevel = 1
			elseif GetImpactValue("","Influenza")==1 then
				MinLevel = 2
			elseif GetImpactValue("","BurnWound")==1 then
				MinLevel = 2
			elseif GetImpactValue("","Pox")==1 then
				MinLevel = 2
			elseif GetImpactValue("","Pneumonia")==1 then
				MinLevel = 3
			elseif GetImpactValue("","Blackdeath")==1 then
				MinLevel = 3
			elseif GetImpactValue("","Fracture")==1 then
				MinLevel = 3
			elseif GetImpactValue("","Caries")==1 then
				MinLevel = 3
			end
			
			if BuildingGetLevel("Hospital"..i) < MinLevel then
				Distance = -1
			end
			
			if Distance>=0 and (DistanceBest==-1 or Distance<DistanceBest) then
				CopyAlias("Hospital"..i,"Destination")
				DistanceBest = Distance
			end
		end
		
		if DistanceBest==-1 then
			MsgQuick("", "@L_MEASURE_AttendDoctor_NODOC_+0", GetID(""))
			return
		end
	end
	
	if (GetDynastyID("Destination")~=GetID("dynasty")) then
		local Costs = 0
		if GetImpactValue("","Sprain")==1 then
			Costs = diseases_GetTreatmentCost("Sprain")
		elseif GetImpactValue("","Cold")==1 then
			Costs = diseases_GetTreatmentCost("Cold")
		elseif GetImpactValue("","Influenza")==1 then
			Costs = diseases_GetTreatmentCost("Influenza")
		elseif GetImpactValue("","BurnWound")==1 then
			Costs = diseases_GetTreatmentCost("BurnWound")
		elseif GetImpactValue("","Pox")==1 then
			Costs = diseases_GetTreatmentCost("Pox")
		elseif GetImpactValue("","Pneumonia")==1 then
			Costs = diseases_GetTreatmentCost("Pneumonia")
		elseif GetImpactValue("","Blackdeath")==1 then
			Costs = diseases_GetTreatmentCost("Blackdeath")
		elseif GetImpactValue("","Fracture")==1 then
			Costs = diseases_GetTreatmentCost("Fracture")
		elseif GetImpactValue("","Caries")==1 then
			Costs = diseases_GetTreatmentCost("Caries")
		elseif GetHPRelative("") < 0.99 then
			Costs = GetMaxHP("")-GetHP("")
		else
			StopMeasure()
		end
		
		local Money = GetMoney("")
		if Costs > Money then
			MsgQuick("", "@L_MEDICUS_FAILURES_+2",GetID(""))
			StopMeasure()
		end
	end
	local HospitalID = GetID("Destination")
	idlelib_VisitDoc(HospitalID)
end

function AIDecide()
	return "O"
end

function CleanUp()
	if HasProperty("","WaitingForTreatment") then
		RemoveProperty("","WaitingForTreatment")
	end
end

-- -----------------------
-- GetOSHData
-- -----------------------
function GetOSHData(MeasureID)
	local Costs = 0
	if GetImpactValue("","Sprain")==1 then
		Costs = diseases_GetTreatmentCost("Sprain")
	elseif GetImpactValue("","Cold")==1 then
		Costs = diseases_GetTreatmentCost("Cold")
	elseif GetImpactValue("","Influenza")==1 then
		Costs = diseases_GetTreatmentCost("Influenza")
	elseif GetImpactValue("","BurnWound")==1 then
		Costs = diseases_GetTreatmentCost("BurnWound")
	elseif GetImpactValue("","Pox")==1 then
		Costs = diseases_GetTreatmentCost("Pox")
	elseif GetImpactValue("","Pneumonia")==1 then
		Costs = diseases_GetTreatmentCost("Pneumonia")
	elseif GetImpactValue("","Blackdeath")==1 then
		Costs = diseases_GetTreatmentCost("Blackdeath")
	elseif GetImpactValue("","Fracture")==1 then
		Costs = diseases_GetTreatmentCost("Fracture")
	elseif GetImpactValue("","Caries")==1 then
		Costs = diseases_GetTreatmentCost("Caries")
	elseif GetHPRelative("") < 0.99 then
		Costs = GetMaxHP("")-GetHP("")
	end
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",Costs)
end


