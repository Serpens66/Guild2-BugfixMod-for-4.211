function MehlMahlen()
    GetLocatorByName("WorkBuilding","Entry1","GehPos")
    f_MoveTo("","WorkBuilding")
	StartProduction("","WorkBuilding")
	SetState("", 54, true)

	SetProperty("WorkBuilding","Active",1)
    while true do
		
		PlaySound3D("WorkBuilding","Cart/CartRumbling_r_01.wav",1.0)
		Sleep(10)
		
		-- if SimGetProduceItemID("") == 943 and GetItemCount("WorkBuilding", 3, INVENTORY_STD)<2 then
	        -- SimBeamMeUp("","GehPos",false)
            -- SetState("", 54, false)
			-- GetInsideBuilding("", "WorkBuilding")
			-- f_Stroll("",100,1)
		    -- local spruch = Rand(4)
		    -- if spruch == 1 then
                -- MsgSay("","_HPFZ_PRODUCEMILL_SPRUCH_+0")
		    -- elseif spruch == 2 then
		        -- MsgSay("","_HPFZ_PRODUCEMILL_SPRUCH_+1")
		    -- elseif spruch == 3 then
		        -- MsgSay("","_HPFZ_PRODUCEMILL_SPRUCH_+2")
		    -- else
		        -- MsgSay("","_HPFZ_PRODUCEMILL_SPRUCH_+3")
		    -- end

			-- break
		-- end
		
		-- if SimGetProduceItemID("") == 944 and GetItemCount("WorkBuilding", 2, INVENTORY_STD)<4 then
	        -- SimBeamMeUp("","GehPos",false)
            -- SetState("", 54, false)
			-- GetInsideBuilding("", "WorkBuilding")
			-- f_Stroll("",100,1)
		    -- local spruch = Rand(4)
		    -- if spruch == 1 then
                -- MsgSay("","_HPFZ_PRODUCEMILL_SPRUCH_+0")
		    -- elseif spruch == 2 then
		        -- MsgSay("","_HPFZ_PRODUCEMILL_SPRUCH_+1")
		    -- elseif spruch == 3 then
		        -- MsgSay("","_HPFZ_PRODUCEMILL_SPRUCH_+2")
		    -- else
		        -- MsgSay("","_HPFZ_PRODUCEMILL_SPRUCH_+3")
		    -- end

			-- break
		-- end		
		Sleep(1)
		if not HasProperty("WorkBuilding","Active") or GetProperty("WorkBuilding","Active")~=1 then
		    SetProperty("WorkBuilding","Active",1)
		end
		IncrementXPQuiet("",5)
	end
	return --true
end

function CleanUp()

	if GetState("",54) == true then
        SimBeamMeUp("","GehPos",false)
        SetState("", 54, false)
	end
    SetProperty("WorkBuilding","Active",0)

end
