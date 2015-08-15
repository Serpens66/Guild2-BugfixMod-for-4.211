
-- CheckPosition is called everytime a new position is checked for a building of this kind
-- the only alias defined here is "Position", that represents the wanted position
-- return nil if the position ok else return the label of the error message
-- attention: this function call is unscheduled
--
function CheckPosition()

	--direct Line check 
	if (BuildingFindWaterPos("Position","PositionEntry","WaterPos")) then
		return nil
	end

	-- deeper pos check
	if not ScenarioFindPosition("Position", 2000, EN_POSTYPE_WATER, 300, 750, EN_POSTYPE_GROUND, 100, "PosWater", "PosGround") then
		-- no water found, this is a big problem
		return "@L_GENERAL_BUILDING_NEED_WATER"
	end
	return nil
end

function Setup()
	if ScenarioGetTimePlayed()>0.2 then
		SetProperty("","CheckForSpinnings",1)
	end
    for workerindex = 0 , BuildingGetWorkerCount("") -1 do -- if the default worker is sick, heal the sim. fixed by Serp
        BuildingGetWorker("",workerindex,"Worker")
        if GetImpactValue("Worker","Sickness")>0 then
            diseases_Sprain("Worker",false)
            diseases_Cold("Worker",false)
            diseases_Influenza("Worker",false)
            diseases_BurnWound("Worker",false)
            diseases_Pox("Worker",false)
            diseases_Pneumonia("Worker",false)
            diseases_Blackdeath("Worker",false)
            diseases_Fracture("Worker",false)
            diseases_Caries("Worker",false)
            SetState("Worker",STATE_SICK,false)
        end
    end
end

--
-- OnLevelUp is called everytime the building level was changed, even when the building is build the first time.
-- This function is called before Setup
-- attention: this function call is unscheduled
--
function OnLevelUp()
 
	GetPosition("", "Position")
	GetLocatorByName("", "Entry1", "PositionEntry")	
	if (BuildingFindWaterPos("Position","PositionEntry","PosWater")) then
		if (GetOutdoorMovePosition(NIL, "", "PosGround")) then
			BuildingSetWaterPos("", "PosWater", "PosGround")
			return true
		end
	end
	
	if ScenarioFindPosition("", 2250, EN_POSTYPE_WATER, 300, 750, EN_POSTYPE_GROUND, 100, "PosWater", "PosGround") then
		BuildingSetWaterPos("", "PosWater", "PosGround")
		return true
	end	
	
	-- no water found, this is a big problem
	return false
end

function PingHour()
	local Found = false
	for i=0,BuildingGetCartCount("")-1 do
		if BuildingGetCart("",i,"Cart") then
			if CartGetType("Cart")==EN_CT_CORSAIR then
				Found = true
			end
		end
	end
	if Found then
		if not HasProperty("", "pirateship") then
			SetProperty("", "pirateship", 1)
		end
	else
		if HasProperty("", "pirateship") then
			RemoveProperty("","pirateship")
		end	
	end

	if HasProperty("","CheckForSpinnings") then
		local checks = GetProperty("","CheckForSpinnings")
		
		if checks < 20 then
			if not HasProperty("","SpinningsChecked") then
				local MovObjFilter = "__F( (Object.GetObjectsByRadius(Sim)==6000)AND(Object.HasProperty(MyDest))OR(Object.GetObjectsByRadius(Cart)==6000)AND(Object.HasProperty(MyDest))AND NOT(Object.HasProperty(AutoRoute)))"
				local NumMovObj = Find("",MovObjFilter,"MovObj",-1)
	
				if NumMovObj > 0 then
					for obj=0,NumMovObj-1 do
						local ObjAlias = "MovObj"..obj
						if not GetState(ObjAlias,STATE_DRIVERATTACKED) then
							if HasProperty(ObjAlias,GetID("")) then
								if GetProperty(ObjAlias,GetID(""))==GetProperty(ObjAlias,"MyDest") then
									RemoveProperty(ObjAlias,GetID(""))
									if GetCurrentMeasureName(ObjAlias)=="WorldTrader" then
										MeasureRun(ObjAlias,nil,"WorldTrader",true)
									else
										SimStopMeasure(ObjAlias)
									end
								else
									RemoveProperty(ObjAlias,GetID(""))
								end
							else
								SetProperty(ObjAlias,GetID(""),GetProperty(ObjAlias,"MyDest"))
							end
						end
					end
				end
				SetProperty("","SpinningsChecked",1)
			else
				RemoveProperty("","SpinningsChecked")
			end
			checks = checks + 1
			SetProperty("","CheckForSpinnings",checks)
		else
			RemoveProperty("","CheckForSpinnings")
		end
	end
end
