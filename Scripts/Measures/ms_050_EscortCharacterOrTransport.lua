function Run()

	if not AliasExists("Destination") then
		return
	end

	local TimeOut = -1
	if SimGetProfession("")==GL_PROFESSION_CITYGUARD then
		TimeOut = 5
	SetData("Endtime"..GetID("Destination"),math.mod(GetGametime(),24)+5)
	end

	local fDistance = 200
	if IsType("Destination", "Cart") then
		fDistance = 400
	elseif IsType("Destination", "Ship") then
		fDistance = 800
	end
	
	local	DataValue
	local	Temp
	for l=0,4 do
		Temp = "EscortedBy_"..l
		if not HasProperty("Destination", Temp ) then
			DataValue = Temp
			break
		end
	end
	
	if not DataValue then
		return
	end
	
	SetData("Property", DataValue)
	SetProperty("Destination", DataValue, GetID(""))

	if TimeOut<0 then
		local errorcount = 0
		while (1) do
		    if SimIsInside("Destination") then
		        if HasProperty("","CityBodyguard") or HasProperty("","KIbodyguard") then
	                break
	            end			
			end
			f_Follow("","Destination", GL_MOVESPEED_RUN, fDistance)		
			Sleep(3)
		end		
		return
	end
	
	f_FollowNoWait("","Destination", GL_MOVESPEED_RUN, fDistance)
--	Sleep(Gametime2Realtime(TimeOut))
	if TimeOut==5 then
		if math.mod(GetGametime(),24)>GetData("Endtime"..GetID("Destination")) then
			StopMeasure()
		end
	end
end

function CleanUp()
	local	DataValue = GetData("Property")
	if DataValue then
		RemoveProperty("Destination", DataValue)
	end
	if AliasExists("Destination") and HasProperty("Destination","KIbodyguard") then
	    if GetProperty("Destination","KIbodyguard")>1 then
		    SetProperty("Destination","KIbodyguard",1)
		else
		    RemoveProperty("Destination","KIbodyguard")
		end
	end
	if HasProperty("","CityBodyguard") then
	    RemoveProperty("","CityBodyguard")
	end
end

