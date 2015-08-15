function Run()
end


function OnLevelUp()
end


function Setup()
	worldambient_CreateAnimal("Stag","",1)
	worldambient_CreateAnimal("Deer","",2)
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
end
