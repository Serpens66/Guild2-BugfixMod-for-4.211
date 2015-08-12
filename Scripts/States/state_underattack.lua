function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_hire")
end

function Run()
	-- as long as this state is set, spawn Fire, smoke and wreckage particles of
	-- different intesities, depending on the hp status of the building.
	-- also play some burning sounds.
	
	-- CommitAction("defendbuilding","Owner","Owner")
	BuildingRallyWorkers("Owner")
	--Evacuate("Owner")
	
	PlaySound3D("Owner","Locations/alarm_horn_single+0.wav",1.0)
	
	local SmokeStatus = 0	
	local SmokeStatusOld = 0
	-- 0 no smoke
	-- 1 light smoke
	-- 2 medium smoke
	-- 3 heavy smoke
	
	local FlameSize = 6
	-- 6 small
	-- 7 medium
	-- 8 large
	
	while true do
	
		--if building then start smoking
		if IsType("Owner","Building") then	
			
			local Wreckage = Rand(10)
			local j = Rand(3)
			local ActualHP = GetHP("Owner")
			local SmokeType = ""
			local FlameType = ""
			GetFreeLocatorByName("Owner", "Fire"..j,-1,-1,"ParticlePos")
			SmokeStatusOld = SmokeStatus
			
			--when building HP is lower than 30%
			if (ActualHP < (0.3*GetMaxHP("Owner"))) then
				SmokeStatus = 3
				SmokeType = "particles/smoke_heavy.nif"
				FlameType = "particles/flame_small.nif"
				FlameSize = 5
				if (Wreckage > 7) then
					PlaySound3D("Owner","fire/Explosion_s_04.wav",0.9)
					StartSingleShotParticle("particles/smoketrail2.nif", "ParticlePos",1,2)
					StartSingleShotParticle("particles/wreckage.nif", "ParticlePos",1,2)
				end
			--when building HP is lower than 50%
			elseif (ActualHP < (0.5*GetMaxHP("Owner"))) then
				SmokeStatus = 2
				SmokeType = "particles/smoke_medium.nif"
				FlameType = "particles/flame_small.nif"
				FlameSize = 3
			--when building HP is lower than 75%
			elseif (ActualHP < (0.75*GetMaxHP("Owner"))) then
				SmokeStatus = 1
				SmokeType = "particles/smoke_light.nif"
				FlameType = ""
			else
				SmokeStatus = 0
				SmokeType = ""
				FlameType = ""
			end
			
			--check if the damage state has changed
			if not (SmokeStatusOld == SmokeStatus) then
				Detach3DSound("Owner")
				if (SmokeStatus == 1) then
					Attach3DSound("Owner","fire/Fire_l_01.wav", 1.0)
				elseif (SmokeStatus == 2) then
					Attach3DSound("Owner","fire/Fire_l_02.wav", 1.0)
				elseif (SmokeStatus == 3) then
					Attach3DSound("Owner","fire/Fire_01.wav", 1.0)
				else
					Detach3DSound("Owner")
				end
				
				-- count the fire locator
				FireLocatorCount = 1
				while GetFreeLocatorByName("Owner", "Fire"..FireLocatorCount, -1, -1, "SmokeLocator"..FireLocatorCount) do
					FireLocatorCount = FireLocatorCount + 1
				end
				FireLocatorCount = FireLocatorCount - 1
				
				--remove existing smoke and Fire particles
				local SmokeCount
				SmokeCount = FireLocatorCount-1
				while(SmokeCount > 0) do
					GfxStopParticle("Smoke"..SmokeCount)
					GfxStopParticle("Flames"..SmokeCount)
					SmokeCount = SmokeCount -1
				end
				
				-- create the smoke particles, size and position them
				SmokeCount = FireLocatorCount-1
				while(SmokeCount > 0) do
				
					GfxStartParticle("Smoke"..SmokeCount, SmokeType, "SmokeLocator"..SmokeCount, 7)
					SmokeCount = SmokeCount -1	
				end
				
				-- create the flame particles, size and position them
				FlameCount = FireLocatorCount-1
				while(FlameCount > 0) do
					
					GfxStartParticle("Flames"..FlameCount, FlameType,"SmokeLocator"..FlameCount, FlameSize)
					FlameCount = FlameCount -1							
				end
			end			
		end
		Sleep(2)
	end
end

function CleanUp()
	-- StopAction("defendbuilding", "Owner")
	Detach3DSound("Owner")
	SetState("Owner", STATE_UNDERATTACK, false)
end

