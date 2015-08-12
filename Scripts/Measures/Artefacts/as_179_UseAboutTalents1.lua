-------------------------------------------------------------------------------
----
----	OVERVIEW "as_179_UseAboutTalents1"
----
----	with this artifact, the player can increase his rhetoric, empathy,
----	bargaining and secret knowledge skill by 1
----	TFTODO: rework
-------------------------------------------------------------------------------

function Run()
	if (GetState("", STATE_CUTSCENE)) then 
		as_179_useabouttalents1_Cutscene()
	else
		as_179_useabouttalents1_Normal()
	end
end

function Normal()

	if IsStateDriven() then
		local ItemName = "AboutTalents1"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	local skillmodify = 1

	--take a book and read
	local Time = PlayAnimationNoWait("","use_book_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_book.nif",false)
	Sleep(5)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(Time-7)
	CarryObject("","",false)
	
	--show particles
	if RemoveItems("","AboutTalents1",1)>0 then
		GetPosition("Owner", "ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		--show overhead text
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
			"@L_TALENTS_rhetoric_ICON_+0", "@L_TALENTS_rhetoric_NAME_+0", skillmodify)
		Sleep(1)
		
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
			"@L_TALENTS_craftsmanship_ICON_+0", "@L_TALENTS_craftsmanship_NAME_+0", skillmodify)
				
		--add the impacts and remove the artefact from inventory
		
		SetRepeatTimer("", GetMeasureRepeatName2("UseAboutTalents1"), TimeOut)
		AddImpact("","rhetoric",1,duration)
		AddImpact("","craftsmanship",1,duration)
		AddImpact("","abouttalents1",1,duration)
		Sleep(1)
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
	
end

function Cutscene()

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	local skillmodify = 1

	--take a book and read
	
	--show particles
	if RemoveItems("","AboutTalents1",1)>0 then
		GetPosition("Owner", "ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		--show overhead text
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
			"@L_TALENTS_rhetoric_ICON_+0", "@L_TALENTS_rhetoric_NAME_+0", skillmodify)
		Sleep(1)
		
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
			"@L_TALENTS_craftsmanship_ICON_+0", "@L_TALENTS_craftsmanship_NAME_+0", skillmodify)
				
		--add the impacts and remove the artefact from inventory
		
		SetRepeatTimer("", GetMeasureRepeatName2("UseAboutTalents1"), TimeOut)
		AddImpact("","rhetoric",1,duration)
		AddImpact("","craftsmanship",1,duration)
		AddImpact("","abouttalents1",1,duration)
		if SimGetCutscene("","cutscene") then
			CutsceneCallUnscheduled("cutscene", "UpdatePanel")
			Sleep(0.1)
		else
			return
		end	
	end
	StopMeasure()	
	
end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

