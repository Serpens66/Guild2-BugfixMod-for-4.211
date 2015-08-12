function Run(SimAlias, ResourceAlias, mode)

	SetData("WorkMode",mode)

	local Type = ResourceGetScriptFunc(ResourceAlias)
	if not Type then
		return false
	end

	local Function_In
	local Function_Out
	local Function_Cleanup
	local Function_Prepare = gather_GotoResource

	if Type=="Herbs" then
		Function_In = gather_Herbs_In
		Function_Out = gather_Herbs_Out
	elseif Type=="Mine" then
 		Function_In = gather_Mine_In
		Function_Out = gather_Mine_Out
	elseif Type=="Harvest" then
 		Function_In = gather_Harvest_In
 		Function_Out = gather_Harvest_Out
	elseif Type=="Beet" then
 		Function_In = gather_Beet_In
 		Function_Out = gather_Beet_Out
	elseif Type=="Animal" then
 		Function_In = gather_Animal_In
 		Function_Out = gather_Animal_Out
 	elseif Type=="Take" then
 		Function_In = gather_Take_In
 		Function_Out = gather_Take_Out
 	elseif Type=="Lumber" then
 		Function_In = gather_Lumber_In
 		Function_Out = gather_Lumber_Out
 	elseif Type=="well" then
 		Function_In = gather_Well_In
 		Function_Out = gather_Well_Out
 	elseif Type=="Charcoal" then
 		Function_In = gather_Charcoal_In
 		Function_Out = gather_Charcoal_Out
 	elseif Type=="Fungi" then
 		Function_In = gather_Beet_In
 		Function_Out = gather_Beet_Out
 	elseif Type=="Ton" then
 		Function_In = gather_Ton_In
 		Function_Out = gather_Ton_Out
 	elseif Type=="Fruit" then
 		Function_In = gather_Fruit_In
 		Function_Out = gather_Fruit_Out
 	elseif Type=="Honey" then
 		Function_In = gather_Honey_In
 		Function_Out = gather_Honey_Out
 	elseif Type=="Fishing" then
 		return false
 	end

	if not Function_In and not Function_Out then
		return false
	end

	local ItemID = ResourceGetItemId(ResourceAlias)
	if ItemID==-1 then
		return false
	end

	local Time = ItemGetProductionTime(ItemID)
	local Count = ItemGetProductionAmount(ItemID)

	local Value = GetImpactValue("", 34)	-- 34 = GatherBonus
	if Value and Value>0 then
		Time = Time - Time * Value * 0.01
	end

	if GetSeason() == 3 then
	    Time =  math.floor(Time + ((Time / 100) * 20)) -- im Winter 20% langsamer
	end
	
	if HasProperty(ResourceAlias,"Heuschrecken") then
	    Time =  math.floor(Time + ((Time / 100) * 40)) -- bei Heuschrecken 40% langsamer
	end
	
	if Count<1 then
		-- this should never happen - the item seems to be buggy in the database
		return false
	end

	-- get the remaining progress of the last	gather action. this happend eg. at closing time
	local Label		= ItemGetLabel(ItemID, true)
	local	PropName	= "Gather_"..ItemID
	if not GetProperty(SimAlias, PropName) then
		SetProperty(SimAlias, PropName, 0)
	end
	
	local	WorkerAlias
	
	while true do

		if GetRemainingInventorySpace(SimAlias,ItemID) < Count then
	 		break
		end
		
		if Function_Prepare then
			WorkerAlias = Function_Prepare(SimAlias, ResourceAlias, Name,ItemID)
		else
			WorkerAlias = SimAlias
		end
		
		if not WorkerAlias then
			break
		end

		if Function_In and Function_In(WorkerAlias, ResourceAlias, Label,ItemID) then

			local	Diff
			local	StartTime
			local	CurrentTime = GetGametime()
			StartTime = CurrentTime
			while true do
				Sleep(2)
				CurrentTime = GetGametime()
				Diff = (CurrentTime - StartTime)
				local Total = GetProperty(WorkerAlias, PropName)
				if not Total then
					Total = 0
				end
				Total = Total + SimGetProductivity("")*Diff
				SetProperty(WorkerAlias, PropName, Total)
				if Total > Time then
					RemoveProperty(WorkerAlias, PropName)
					break
				end
			end

			Removed = RemoveItems(ResourceAlias, ItemID, Count)
			if Removed>0 then
				AddItems(SimAlias, ItemID, Removed)
			end
			
		end

		if AliasExists("WorkPosition") then
			f_EndUseLocator(WorkerAlias, "WorkPosition", GL_STANCE_STAND)
		end

		if BuildingGetAISetting("WorkBuilding", "Produce_Selection")>0 then
			local	prodid
			local targetid
			prodid, targetid = SimFindProduction(SimAlias)
			
			if not AliasExists(SimAlias) then
				Sleep(0.1)
				return false
			end

			if prodid and prodid~=ItemID then
				if Function_Out then
					Function_Out(SimAlias, ResourceAlias, Label, Removed, 1,ItemID)
				end
				SimSetProduceItemID(SimAlias, prodid, targetid)
				Sleep(0.1)
				return false
			end
		end
		
		local	Finish

		if GetRemainingInventorySpace(SimAlias,ItemID) < Count then
			Finish = 1
		else
			Finish = 0
		end
		
		if Function_Out then
			Function_Out(SimAlias, ResourceAlias, Label, Removed, Finish,ItemID)
		end		

	end

	if Function_Cleanup then
		Function_Cleanup(SimAlias, WorkerAlias)
	end

	return true, ItemID
end

function GotoResource(SimAlias, ResourceAlias, Name, theitem)

	local	LocatorArray = {}
	local	LocCount = 0

	local	Level = ResourceGetLevel(ResourceAlias)

	local Removed
	local	Status
	 	
	if theitem == 39 then
	    GetFreeLocatorByName("WorkBuilding","Work",1,9,"WorkPosi")
	    f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)
    else
 	    for g=1, Level do
 		    for n=0, 9 do		
 			    Name = "work"..g..n
			    Status = LocatorStatus(ResourceAlias, Name, true)
			    if Status==-1 then
				    break
			    end
			    if Status==1 then
				    LocatorArray[LocCount] = Name
				    LocCount = LocCount + 1
			    end
 		    end
 	    end
	end
 	
	local Success = false
			
 	if LocCount>0 then
 		for trys=0,10 do
 			local LocatorName	= LocatorArray[ Rand(LocCount) ]
			GetLocatorByName(ResourceAlias, LocatorName, "WorkPosition")
 			Success = f_BeginUseLocator("Owner", "WorkPosition", GL_STANCE_STAND, true, GL_MOVESPEED_RUN)
 			if Success then
 				break
 			end
 		end
 	end

	
 	if not Success then
 		-- Removed because it looks bad in some Recources (specialy the wood) when the sim go to the center of the  resource
 		--
 		-- (cs) removed the remove of the feedback, it's so much the worse that a resource cannot be collected at all
		Success = f_MoveTo(SimAlias, ResourceAlias, GL_MOVESPEED_RUN,150)
	end


	if not Success then
		-- the sim was unable to go to the resource, so return error
		return nil
	end
	
	return SimAlias
	 		
end

-- ***************************************
--
--                   Honey
--
-- ***************************************

function Honey_In(SimAlias, ResourceAlias, Label)

	MsgMeasure("", "@L_GENERAL_MSGMEASURE_MINE_+0", Label)

	CarryObject(SimAlias,"Handheld_Device/ANIM_torchparticles.nif", false)
	GetPosition(SimAlias,"PartPos")
	PlayAnimation(SimAlias,"fetch_water_in")
	GfxStartParticle("rauch", "particles/Schornsteinrauch.nif", "PartPos",1.0)
	GfxStartParticle("bees", "particles/flies.nif", "PartPos",0.5)
	LoopAnimation(SimAlias,"fetch_water_loop",0)
	return true
end

function Honey_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	PlayAnimation(SimAlias,"fetch_water_out")
	GfxStopParticle("bees")
	GfxStopParticle("rauch")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
	
		if Removed > 0 then
			MoveSetActivity(SimAlias,"carry")
			Sleep(2)
			CarryObject(SimAlias,"Handheld_Device/ANIM_Bucket_honey.nif", false)
		else
			local Type = ResourceGetScriptFunc(ResourceAlias)
	
			SimGetWorkingPlace(SimAlias,"WorkingPlace")
	
			BuildingGetOwner("WorkingPlace","BuildingOwner")
		--[[	feedback_MessageWorkshop("BuildingOwner",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_HEAD_+0",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_BODY_+0",
					GetID(ResourceAlias), GetID(""), Label)
			StopMeasure() ]]
		end
	end
end

-- ***************************************
--
--                   Fruit
--
-- ***************************************

function Fruit_In(SimAlias, ResourceAlias, Label)

	MsgMeasure("", "@L_GENERAL_MSGMEASURE_GATHER_+0", Label)

	PlayAnimation(SimAlias,"knee_work_in")
	LoopAnimation(SimAlias,"knee_work_loop",0)
	return true
end

function Fruit_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	PlayAnimation(SimAlias,"knee_work_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
	
		if Removed > 0 then
			MoveSetActivity(SimAlias,"carry")
			Sleep(2)
			CarryObject(SimAlias,"Handheld_Device/ANIM_Fruitbasket.nif", false)
		else
			local Type = ResourceGetScriptFunc(ResourceAlias)
	
			SimGetWorkingPlace(SimAlias,"WorkingPlace")
	
			BuildingGetOwner("WorkingPlace","BuildingOwner")
			--[[feedback_MessageWorkshop("BuildingOwner",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_HEAD_+0",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_BODY_+0",
					GetID(ResourceAlias), GetID(""), Label)
			StopMeasure() ]]
		end
	end
end

-- ***************************************
--
--                   Sand
--
-- ***************************************

function Ton_In(SimAlias, ResourceAlias, Label)

	MsgMeasure("", "@L_GENERAL_MSGMEASURE_GATHER_+0", Label)

	CarryObject(SimAlias,"Handheld_Device/ANIM_Pitchfork.nif", false)
	PlayAnimation(SimAlias,"churn")
	CarryObject(SimAlias,"", false)
	CarryObject(SimAlias,"Handheld_Device/ANIM_scheffel.nif", false)
	PlayAnimation(SimAlias,"knee_work_in")
	LoopAnimation(SimAlias,"knee_work_loop",0)
	return true
end

function Ton_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	PlayAnimation(SimAlias,"knee_work_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
	
		if Removed > 0 then
			MoveSetActivity(SimAlias,"carry")
			Sleep(2)
			CarryObject(SimAlias,"Handheld_Device/ANIM_Bucket_carry.nif", false)
		else
			local Type = ResourceGetScriptFunc(ResourceAlias)
	
			SimGetWorkingPlace(SimAlias,"WorkingPlace")
	
			BuildingGetOwner("WorkingPlace","BuildingOwner")
		--[[	feedback_MessageWorkshop("BuildingOwner",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_HEAD_+0",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_BODY_+0",
					GetID(ResourceAlias), GetID(""), Label)
			StopMeasure() ]]
		end
	end
end


-- ***************************************
--
--                   Herbs
--
-- ***************************************

function Herbs_In(SimAlias, ResourceAlias, Label)

	MsgMeasure("", "@L_GENERAL_MSGMEASURE_GATHER_+0", Label)

	CarryObject(SimAlias,"Handheld_Device/ANIM_Sickel.nif", false)
	PlayAnimation(SimAlias,"knee_work_in")
	LoopAnimation(SimAlias,"knee_work_loop",0)
	return true
end

function Herbs_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	PlayAnimation(SimAlias,"knee_work_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
	
		if Removed > 0 then
			MoveSetActivity(SimAlias,"carry")
			Sleep(2)
			CarryObject(SimAlias,"Handheld_Device/ANIM_Herbbox.nif", false)
		else
			local Type = ResourceGetScriptFunc(ResourceAlias)
	
			SimGetWorkingPlace(SimAlias,"WorkingPlace")
	
			BuildingGetOwner("WorkingPlace","BuildingOwner")
			--[[feedback_MessageWorkshop("BuildingOwner",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_HEAD_+0",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_BODY_+0",
					GetID(ResourceAlias), GetID(""), Label)
			StopMeasure() ]]
		end
	end
end




-- ***************************************
--
--                  Mine
--
-- ***************************************

function Mine_In(SimAlias, ResourceAlias, Label)
	SetContext("", "mine")
	MsgMeasure("","@L_GENERAL_MSGMEASURE_MINE_+0", Label)
	CarryObject(SimAlias,"Handheld_Device/ANIM_Pick.nif", false)
	PlayAnimation(SimAlias,"chop_in")
	
	LoopAnimation(SimAlias, "chop_loop", 0)
	return true
end

function Mine_Out(SimAlias, ResourceAlias, Label, Removed, Finish,ITID)
	PlayAnimation(SimAlias,"chop_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
	
		if Removed > 0 then
			MoveSetActivity(SimAlias,"carry")
			Sleep(2)
			if ITID == 39 then
			    CarryObject(SimAlias,"Handheld_Device/ANIM_Granite.nif", false)
			else
			    CarryObject(SimAlias,"Handheld_Device/ANIM_Metalbar.nif", false)
			end
		else
	
			local Type = ResourceGetScriptFunc(ResourceAlias)
	
			SimGetWorkingPlace(SimAlias,"WorkingPlace")
	
			BuildingGetOwner("WorkingPlace","BuildingOwner")
		--[[	feedback_MessageWorkshop("BuildingOwner",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_HEAD_+0",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_BODY_+0",
					GetID(ResourceAlias), GetID(""), Label)
			StopMeasure() ]]
		end
	end
end




-- ***************************************
--
--                  Harvest
--
-- ***************************************

function Harvest_In(SimAlias, ResourceAlias, Label)
	SetContext("", "harvest")
	MsgMeasure("", "@L_GENERAL_MSGMEASURE_HARVEST_+0", Label)
	CarryObject(SimAlias,"Handheld_Device/ANIM_Scythe.nif", false)
	PlayAnimation(SimAlias,"hoe_in")
	
	LoopAnimation(SimAlias, "hoe_loop", 0)
	return true
end

function Harvest_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	PlayAnimation(SimAlias,"hoe_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
	
		if Removed == nil then
			Removed = 0
		end
	
		if Removed > 0 then
			MoveSetActivity(SimAlias,"carry")
			Sleep(2)
			CarryObject(SimAlias,"Handheld_Device/ANIM_Bag.nif", false)
		else
			local Type = ResourceGetScriptFunc(ResourceAlias)
	
			SimGetWorkingPlace(SimAlias,"WorkingPlace")
	
			BuildingGetOwner("WorkingPlace","BuildingOwner")
		--[[	feedback_MessageWorkshop("BuildingOwner",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_HEAD_+0",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_BODY_+0",
					GetID(ResourceAlias), GetID(""), Label)
			StopMeasure() ]]
		end
	end
end


-- ***************************************
--
--                   Beet
--
-- ***************************************
function Beet_In(SimAlias, ResourceAlias, Label)
	MsgMeasure("", "@L_GENERAL_MSGMEASURE_HARVEST_+0", Label)
	PlayAnimation(SimAlias,"knee_work_in")
	

	LoopAnimation(SimAlias,"knee_work_loop",0)
	return true
end

function Beet_Out(SimAlias, ResourceAlias, Label, Removed, Finish, ITID)
	PlayAnimation(SimAlias,"knee_work_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
	
		if Removed > 0 then
			MoveSetActivity(SimAlias,"carry")
			Sleep(2)
			local Ressi = ResourceGetScriptFunc(ResourceAlias)
			if ITID == 204 then
			    CarryObject(SimAlias,"Handheld_Device/ANIM_Fungibasket.nif", false)
			else
			    CarryObject(SimAlias,"Handheld_Device/ANIM_weideaeste.nif", false)
			end
		else
			local Type = ResourceGetScriptFunc(ResourceAlias)
	
			SimGetWorkingPlace(SimAlias,"WorkingPlace")
	
			BuildingGetOwner("WorkingPlace","BuildingOwner")
		--[[	feedback_MessageWorkshop("BuildingOwner",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_HEAD_+0",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_BODY_+0",
					GetID(ResourceAlias), GetID(""), Label)
			StopMeasure() ]]
		end
	end
end


-- ***************************************
--
--                   Animal
--
-- ***************************************

function Animal_In(SimAlias, ResourceAlias, Label,ITID)
	    Sleep(10)
        SetContext(SimAlias, "sow")
	    CarryObject(SimAlias,"Handheld_Device/ANIM_Seed.nif", true)
	    PlayAnimation(SimAlias,"sow_field_in")
	    LoopAnimation(SimAlias, "sow_field_loop", 6)
	    PlayAnimation(SimAlias,"sow_field_out")
		CarryObject(SimAlias,"",true)
		Sleep(1)
		PlayAnimationNoWait(SimAlias,"fetch_store_obj_R")
		Sleep(1)
		if ITID == 8 then
		    CarryObject(SimAlias,"Handheld_Device/ANIM_scissors.nif", false)
			PlayAnimationNoWait(SimAlias,"knee_work_in")
			Sleep(2)
			PlaySound3D(SimAlias,"Locations/shear_sheep/shear_sheep+1.wav", 1.0)
	        LoopAnimation(SimAlias,"knee_work_loop",10)
		elseif ITID == 10 or ITID == 11 then
            CarryObject(SimAlias,"weapons/axe_02.nif", false)
			PlayAnimationNoWait(SimAlias,"attack_middle")
			if ITID == 11 then
			    PlaySound3D(SimAlias,"Locations/slaughter_pig/slaughter_pig+1.wav", 1.0)
			else
			    PlaySound3D(SimAlias,"Locations/slaughter_cow/slaughter_cow+1.wav", 1.0)
			end
			Sleep(2)
			CarryObject(SimAlias,"Handheld_Device/ANIM_fishknife.nif",false)
			PlayAnimation(SimAlias,"knee_work_in")
			LoopAnimation(SimAlias,"knee_work_loop",6)
		end
		PlayAnimation(SimAlias,"knee_work_out")
		PlayAnimationNoWait(SimAlias,"fetch_store_obj_R")
		Sleep(1)
		CarryObject(SimAlias,"",false)
		Sleep(1)
	return true
end

function Animal_Out(SimAlias, ResourceAlias, Label, Removed, Finish,ITID)
	if Finish == 1 then
		CarryObject(SimAlias,"",false)
		
		if Removed > 0 then
		    MoveSetActivity(SimAlias,"carry")
		    Sleep(2)
		    if ITID == 8 then
		        CarryObject(SimAlias,"Handheld_Device/ANIM_Bag.nif", false)
		    else
		        CarryObject(SimAlias,"Handheld_Device/ANIM_haunch.nif", false)
		    end
		else
			local Type = ResourceGetScriptFunc(ResourceAlias)
	
			SimGetWorkingPlace(SimAlias,"WorkingPlace")
	
			BuildingGetOwner("WorkingPlace","BuildingOwner")
		--[[	feedback_MessageWorkshop("BuildingOwner",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_HEAD_+0",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_BODY_+0",
					GetID(ResourceAlias), GetID(""), Label)
			StopMeasure() ]]
        end			
	end
end


-- ***************************************
--
--                Take (Chest)
--
-- ***************************************

function Take_In(SimAlias, ResourceAlias, Label)
	MsgMeasure("", "@L_GENERAL_MSGMEASURE_TAKE_+0", Label)

	LoopAnimation(SimAlias, "manipulate_bottom_r", 0)
	return true
end

function Take_Out(SimAlias, ResourceAlias, Label)
end

-- ***************************************
--
--                  Charcoal
--
-- ***************************************

function Charcoal_In(SimAlias, ResourceAlias, Label)

	MsgMeasure("", "@L_GENERAL_MSGMEASURE_MINE_+0", Label)
	MoveSetActivity(SimAlias,"carrypeel")
	Sleep(1.7)
	CarryObject(SimAlias,"Handheld_Device/ANIM_peel_iron.nif",false)
	AlignTo(SimAlias,ResourceAlias)
	PlayAnimation(SimAlias,"peel_bread_out_oven")
	LoopAnimation(SimAlias, "peel_idle", 0)
	return true
end

function Charcoal_Out(SimAlias, ResourceAlias, Label, Removed, Finish)

	if (Finish == 1) then
	    MoveSetActivity(SimAlias,"")
		CarryObject(SimAlias,"", false)
	
		if Removed > 0 then
			MoveSetActivity(SimAlias,"carry")
			Sleep(2)
			CarryObject(SimAlias,"Handheld_Device/ANIM_Bag.nif", false)
		else
			local Type = ResourceGetScriptFunc(ResourceAlias)
	
			SimGetWorkingPlace(SimAlias,"WorkingPlace")
	
			BuildingGetOwner("WorkingPlace","BuildingOwner")
		--[[	feedback_MessageWorkshop("BuildingOwner",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_HEAD_+0",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_BODY_+0",
					GetID(ResourceAlias), GetID(""), Label)
			StopMeasure() ]]
		end
	end
end

-- ***************************************
--
--                  Lumber
--
-- ***************************************

function Lumber_In(SimAlias, ResourceAlias, Label)
	SetContext("","rangerhut")
	MsgMeasure("", "@L_GENERAL_MSGMEASURE_MINE_+0", Label)
	CarryObject(SimAlias,"weapons/axe_01.nif", false)
	PlayAnimation(SimAlias,"chop_in")
	

	LoopAnimation(SimAlias, "chop_loop", 0)
	return true
end

function Lumber_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	PlayAnimation(SimAlias,"chop_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
	
		if Removed > 0 then
			MoveSetActivity(SimAlias,"carrywood")
			Sleep(1.5)
			CarryObject(SimAlias,"Handheld_Device/ANIM_Woodlog.nif", false)
		else
	
			local Type = ResourceGetScriptFunc(ResourceAlias)
	
			SimGetWorkingPlace(SimAlias,"WorkingPlace")
	
			BuildingGetOwner("WorkingPlace","BuildingOwner")
		--[[	feedback_MessageWorkshop("BuildingOwner",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_HEAD_+0",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_BODY_+0",
					GetID(ResourceAlias), GetID(""), Label)
			StopMeasure() ]]
		end
	end
end

-- ***************************************
--
--                  Well
--
-- ***************************************

function Well_In(SimAlias, ResourceAlias, Label)
	MsgMeasure("", "@L_GENERAL_MSGMEASURE_MINE_+0", Label)
	CarryObject(SimAlias,"Handheld_Device/ANIM_Bucket.nif", false)
	PlayAnimation(SimAlias,"fetch_water_in")
	

	LoopAnimation(SimAlias, "fetch_water_loop", 0)
	return true
end

function Well_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	if Removed > 0 then
		CarryObject(SimAlias,"Handheld_Device/ANIM_Bucket_full.nif", false)
	end
	PlayAnimation(SimAlias,"fetch_water_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
	
		if Removed > 0 then
			Sleep(2)
			CarryObject(SimAlias,"Handheld_Device/ANIM_Bucket_full.nif", false)
		else
			CarryObject(SimAlias,"", true)
			local Type = ResourceGetScriptFunc(ResourceAlias)
	
			SimGetWorkingPlace(SimAlias,"WorkingPlace")
	
			BuildingGetOwner("WorkingPlace","BuildingOwner")
		--[[	feedback_MessageWorkshop("BuildingOwner",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_HEAD_+0",
				"@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_BODY_+0",
					GetID(ResourceAlias), GetID(""), Label)
			StopMeasure() ]]
		end
	end
end

