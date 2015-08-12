--
-- OnLevelUp is called everytime the building level was changed, even when the building is build the first time.
-- This function is called bevor Setup
-- attention: this function call is unscheduled
--
function OnLevelUp()
	church_SetupAI("")
end

function Setup()
	if ScenarioGetTimePlayed()>0.2 then
		SetProperty("","CheckForSpinnings",1)
	end
end

function SetupAI(Alias)

	local	Level = BuildingGetLevel(Alias)
	if Level<0 then
		return
	end
	if not GetInventory(Alias, INVENTORY_SELL, "Inv") then
		return
	end
	SetProperty("Inv", "Need_162", 20 + (Level+1)*10 )	-- housel
	SetProperty("Inv", "Need_164", 5 + (Level+0)*5)		  -- Chaplet
end


function PingHour()
	local currentGameTime = math.mod(GetGametime(),24)
	if (currentGameTime == 12) or ((currentGameTime > 12) and (currentGameTime < 13)) then
		PlaySound3D("", "locations/bell_stroke_church_loop+0.wav", 1.0)
	elseif (currentGameTime == 0) or ((currentGameTime > 0) and (currentGameTime < 1)) then
		PlaySound3D("", "locations/bell_stroke_church_loop+0.wav", 1.0)
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
