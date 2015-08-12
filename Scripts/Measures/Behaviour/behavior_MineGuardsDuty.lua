-------------------------------------------------------------------------------
----
----	OVERVIEW "behavior_MineGuardsDuty.lua"
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	GetAliasByID(GetProperty("", "DynID"), "Dynasty")
	
	SetProperty("", "NotAffectable", 1)
		
	-- Check if the guard is here the first time
	if not HasProperty("", "EndTime") then
		local duration = 16
		local CurrentTime = GetGametime()
		local EndTime = CurrentTime + duration
		SetProperty("", "EndTime", EndTime)
	end
	
	-- SetData("Time", duration)
	-- SetData("EndTime", EndTime)	
	-- SetProcessMaxProgress("", duration*10)
	-- SendCommandNoWait("", "Progress")

	local Range = 1500
	if HasData("CurMeasID") then
		local MeasureID = GetProperty("", "CurMeasID")
		Range = GetDatabaseValue("Measures", MeasureID, "rangeradius") * 50
	end
	
	-- Do the timer loop
	local EndTime = GetProperty("", "EndTime")
	while GetGametime() < EndTime do
		
		CarryObject("", "Handheld_Device/ANIM_Shield3.nif", true)
		local Enemy = Find("", "__F((Object.GetObjectsByRadius(Sim)=="..Range..")AND(Object.IsHostile())AND(Object.GetState(fighting)))", "Enemy", -1)
		if Enemy > 0 then
			gameplayformulas_SimAttackWithRangeWeapon("", "Enemy")
			BattleJoin("", "Enemy", false)
		else
			local Robber = Find("", "__F((Object.GetObjectsByRadius(Sim)=="..Range..")AND(Object.GetProfession()==15))OR(Object.GetState(robberguard))", "Robber", -1)
			if Robber >0 then	
				gameplayformulas_SimAttackWithRangeWeapon("", "Robber")
				BattleJoin("", "Robber", false)
			end
		end
		-- Fight until the fight is over even if the measure is over
		while GetState("", STATE_FIGHTING) do
			Sleep(2)
		end
		
		NextAnim = Rand(2)
		if NextAnim == 0 then
			PlayAnimation("", "watch_for_guard")
		elseif NextAnim == 1 then
			PlayAnimation("", "sentinal_idle")
		else
			Sleep(2.0)		
		end

		f_MoveTo("", "DestPos", GL_MOVESPEED_RUN)
		GfxRotateToAngle("", 0, Rand(360), 0, 1, true)
		Sleep(1)
	end
	
	-- Move out
	FindNearestBuilding("", -1, GL_BUILDING_TYPE_SOLDIERPLACE, -1, false, "Soldierplace")
	f_MoveTo("", "Soldierplace")
	StopMeasure()
	
end

-- -----------------------
-- Progress
-- -----------------------
function Progress()

	while true do
		local Time = GetData("Time")
		local EndTime = GetData("EndTime") 
		local CurrentTime = GetGametime() 
		CurrentTime = EndTime - CurrentTime 
		CurrentTime = Time - CurrentTime 
		SetProcessProgress("", CurrentTime*10)
		Sleep(3)
	end

end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()

	local EndTime = GetProperty("", "EndTime")
	if not (GetState("", STATE_FIGHTING)) and (GetGametime() > EndTime) then	
		SetState("", STATE_NPCFIGHTER, false)
		ResetProcessProgress("")
		CarryObject("", "", true)
		InternalDie("")
		InternalRemove("")		
	end
	
end

