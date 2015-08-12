function Run()

	local	TimeOut
	
	if not HasProperty("", "ATLOF_TimeOut") then
		TimeOut = GetData("TimeOut")
		if TimeOut then
			TimeOut = TimeOut + GetGametime()
			SetProperty("", "ATLOF_TimeOut", TimeOut)
		end
	else
		TimeOut = GetProperty("", "ATLOF_TimeOut")
	end
	
	if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_PIRAT, "WorkBuilding") then
		StopMeasure() 
		return
	end 
	MeasureSetStopMode(STOP_NOMOVE)
	
	if not AliasExists("Destination") then
		if IsStateDriven() then
			if not GetSettlement("WorkBuilding", "City") then
				return
			end
		
			if CityFindCrowdedPlace("City", "", "Destination")==0 then
				return
			end
		else
			if HasProperty("","MyLOLPosX") then
				if not ScenarioCreatePosition(GetProperty("","MyLOLPosX"), GetProperty("","MyLOLPosZ"), "Destination") then
					return
				end
			else
				return
			end
		end
	else
		if GetID("WorkBuilding")==GetID("Destination") then
			if IsStateDriven() then
				if not GetSettlement("WorkBuilding", "City") then
					return
				end
				
				if CityFindCrowdedPlace("City", "", "Destination")==0 then
					return
				end
			else
				if HasProperty("","MyLOLPosX") then
					if not ScenarioCreatePosition(GetProperty("","MyLOLPosX"), GetProperty("","MyLOLPosZ"), "Destination") then
						return
					end
				else
					return
				end
			end
		end
	end
	
	SetProperty("","CocotteHasClient",0)
	SetProperty("","CocotteProvidesLove",1)
	
	-- start the labor
	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)

	while true do
		local zielloc = Rand(300)+100
		if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,zielloc) then
				break
		end
		-- Timeout
		
		if math.mod(GetGametime(),24) <8 then
			StopMeasure()
			break
		end
		
		-- Remember your Position
		GetPosition("","MyPos")
		local x,y,z = PositionGetVector("MyPos")
		SetProperty("","MyLOLPosX",x)
		SetProperty("","MyLOLPosZ",z)
				
		-- some animation stuff
		-- random speech
		local SimFilter = "__F( (Object.GetObjectsByRadius(Sim)==500)AND(Object.HasDifferentSex())AND(Object.GetState(idle))AND NOT(Object.GetState(townnpc))AND NOT(Object.HasImpact(FullOfLove)))"
		local NumSims = Find("",SimFilter,"Sims",-1)
		if NumSims > 0 then
			local DestAlias = "Sims"..Rand(NumSims-1)
			AlignTo("",DestAlias)
			Sleep(1)
			local AnimTime = PlayAnimationNoWait("","point_at")
			MsgSayNoWait("","@L_PIRATE_LABOROFLOVE_PROPOSE")
			Sleep(AnimTime)
			if GetDynastyID(DestAlias)<1 then
				if Rand(100)>50 then
					MeasureRun(DestAlias,"","UseLaborOfLove")
				else
					AddImpact(DestAlias,"FullOfLove",1,4)
				end
			else
				AddImpact(DestAlias,"FullOfLove",1,4)
			end
			
			if not GetSettlement("", "City") then
				return
			end
		
			if CityFindCrowdedPlace("City", "", "Destination")==0 then
				return
			end
		end
		Sleep(5)
	end
	
	StopMeasure()
end

function CleanUp()
  StopAnimation("")
  RemoveProperty("","CocotteProvidesLove")
end

function GetOSHData(MeasureID)
end


