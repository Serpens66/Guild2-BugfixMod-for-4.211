-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_006_HaveVision"
----
----	with this measure the player can invent new artefacts
----
-------------------------------------------------------------------------------


function Run()
	if not GetInsideBuilding("", "Building") then
		StopMeasure()
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	--check if buildmaterial is available
	if GetItemCount("",80,INVENTORY_STD)==0 then 	
		MsgQuick("","@L_ALCHEMIST_006_HAVEVISION_FAILURES_+0")
		StopMeasure()
	end
	--check if tool is available
	if GetItemCount("",60,INVENTORY_STD)==0 then 	
		MsgQuick("","@L_ALCHEMIST_006_HAVEVISION_FAILURES_+1")
		StopMeasure()
	end
	
	--do the initial stuff
	
	RemoveItems("",80,1,INVENTORY_STD)
	RemoveItems("",60,1,INVENTORY_STD)
	if GetRemainingInventorySpace("",138,INVENTORY_STD) <= 0 then
		MsgQuick("","@L_ALCHEMIST_006_HAVEVISION_FAILURES_+2")
		AddItems("",80,1,INVENTORY_STD)
		AddItems("",60,1,INVENTORY_STD)
		StopMeasure()
	end
	MeasureSetNotRestartable()
	SetMeasureRepeat(TimeOut)
	
	MeasureSetStopMode(STOP_NOMOVE)
	
	-- do the visual stuff here
	GetLocatorByName("Building","Telescope","MovePos")
	f_MoveTo("","MovePos")
	PlayAnimation("","manipulate_middle_twohand")
	PlayAnimation("","cogitate")
	for i=1,3 do
		GetLocatorByName("Building","ThinkPos"..i,"MovePos")
		f_MoveTo("","MovePos")
		if Rand(100)> 60 then
			PlayAnimation("","cogitate")
		else
			PlayAnimation("","shake_head")
		end
	end
	
	GetPosition("","ParticleSpawnPos")
	StartSingleShotParticle("particles/pray_glow.nif","ParticleSpawnPos",2,15)
	PlayAnimation("","nod")
	
	
	Sleep(0.1)

	--do the vision stuff
	local EvocationSkill = GetSkillValue("",10) * 10 --secret knowledge
	local CurrentTime = math.mod(GetGametime(),24)
	local EvocationChance = Rand(150)
	if (CurrentTime > 22) and (CurrentTime < 6) then
		EvocationSkill = EvocationSkill * 2
	end
	if Weather_GetValue(1) < 0.5 then
		EvocationChance = EvocationChance - 20
	end
	
	
	
	if EvocationSkill > EvocationChance then			--vision successful
		local ItemChoice = Rand(3)
		local ItemToGet
		if ItemChoice == 0 then
			ItemToGet = "Blissstone"
		elseif ItemChoice == 1 then
			ItemToGet = "CartBooster"
		elseif ItemChoice == 2 then
			ItemToGet = "BoobyTrap"
		end
		
		
		AddItems("",ItemToGet,1,INVENTORY_STD)
		chr_GainXP("",GetData("BaseXP"))
		feedback_MessageWorkshop("","@L_ALCHEMIST_006_HAVEVISION_START_HEAD_+0",
						"@L_ALCHEMIST_006_HAVEVISION_START_BODY_+0",ItemGetLabel(ItemToGet,1))
	else								--vision failed
		StartSingleShotParticle("particles/toadexcrements_hit.nif","ParticleSpawnPos",3,5)
		feedback_MessageWorkshop("","@L_ALCHEMIST_006_HAVEVISION_END_HEAD_+0",
						"@L_ALCHEMIST_006_HAVEVISION_END_BODY_+0")
	end
	
end



function AIDecide()
	NumItems = GetData("NumItems")
	return "A"..NumItems
end

function CleanUp()
	MsgMeasure("","")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

