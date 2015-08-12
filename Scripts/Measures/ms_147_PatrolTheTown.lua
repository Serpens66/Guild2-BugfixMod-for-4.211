-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_147_PatrolTheTown"
----
----	with this measure, the player can send a myrmidon to patrol between 
----	2 waypoints or guard an building
----
-------------------------------------------------------------------------------

function Init() 
	local i = 2
	local Distance
	CopyAlias("Destination","Waypoint1")
	--collect the waypoints
	if AliasExists("Waypoint1") then
		while true do 
			InitAlias("Waypoint"..i,MEASUREINIT_SELECTION, "__F((Object.Type == Building) OR (Object.Type == Position))",
				"@L_GENERAL_MEASURES_147_PATROLTHETOWN_WAYPOINT_+0", AIInit)
			--GetPosition("Waypoint"..i,"ParticleSpawnPos")
			--StartSingleShotParticle("particles/aimingpoint.nif", "ParticleSpawnPos",4,5)
			Distance = GetDistance("Waypoint"..i,"Waypoint"..i-1)
			i = i + 1
			if Distance < 50 then
				break
			end	
			Sleep(1)
		end
	end
	i = i-1
	SetData("WaypointCount",i)
	MsgMeasure("","")
end

function AIInit()
end

function Run()
	local Count
	local i
	if AliasExists("Waypoint1") then
		Count = 0+GetData("WaypointCount")
	end
	--ai timeout
	local	TimeOut
	TimeOut = GetData("TimeOut")
	if TimeOut then
		TimeOut = GetGametime() + TimeOut
	end
	
	
	while true do
	
		if TimeOut then
			if TimeOut < GetGametime() then
				break
			end
		end
		
		--for the ai
		if not AliasExists("Waypoint1") then
			if (GetOutdoorMovePosition("", "Destination", "Target")) then
				if not (f_MoveTo("", "Target", GL_MOVESPEED_WALK, 200)) then
					return
				end
			end
			f_Stroll("", 500, 20)
			return
		else
			--if only one waypoint, and waypoint1 is building
			if (Count == 2 and IsType("Waypoint1","Building")) then
					
				for k=1, 4 do
					if GetLocatorByName("Waypoint1", "Walledge"..k, "VictimsCorner"..k) then
						f_MoveTo("", "VictimsCorner"..k, GL_MOVESPEED_WALK, 10)
					end
					Sleep(Rand(3)+1)
				end
			else
				
				--walk through all waypoints
				i = 1
				for i=1,Count do
					f_MoveTo("","Waypoint"..i)
					Sleep(1)
				end
			end
	
		end
		Sleep(5)
	end
end


function CleanUp()
end

