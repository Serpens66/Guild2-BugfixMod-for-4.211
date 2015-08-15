function Run()
end


function OnLevelUp()
	worldambient_CreateAnimal("Chicken","",1)
end


function Setup()
	worldambient_CreateAnimal("Cock","",1)
	worldambient_CreateAnimal("Chicken","",2)
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

function PingHour()
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
