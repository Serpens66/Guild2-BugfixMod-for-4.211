function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_control")
	SetStateImpact("no_hire")
	SetStateImpact("no_enter")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_measure_start")
	SetStateImpact("NoCameraJump")
end

function Run()
	if GetHomeBuilding("", "Home") then
		if f_MoveTo("", "Home", GL_MOVESPEED_RUN) then

			local ItemID = GetProperty("", "RawMaterial")
			local	Price = math.floor(ItemGetBasePrice(ItemID)*3)

			if GetItemCount("",ItemID)==0 then
				StopMeasure()
			end

			RemoveItems("",ItemID,1)
			RemoveProperty("","RawMaterial")
			CreditMoney("", Price, "RawMaterial")
		end
	end
end

function CleanUp()
	SetState("",STATE_AIUNPACKRAWMATERIAL,false)
end

