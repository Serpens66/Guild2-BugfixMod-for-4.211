function Run()
	-- see Library/diseases.lua
	local Label
	if (IsType("", "Vehicle") ) then
		  Label   =  "@L_GENERAL_MOVESPEED_VEHICLE"
		  if DynastyIsPlayer("") then
			SetProperty("", "AutoRoute")
		  end
	else
		Label = "@L_GENERAL_MOVESPEED"
	end

	Label = Label.."_+1" 
	MsgMeasure("",Label)
	if (f_MoveTo("","Destination",GL_MOVESPEED_RUN)) then
		-- succesfully reached
			if IsGUIDriven() then
			SimLock("", 0.5)
		end
	end
end

-- added by Napi
function CleanUp()

	if HasProperty("", "AutoRoute") then
		RemoveProperty("", "AutoRoute")
		
	end
end





