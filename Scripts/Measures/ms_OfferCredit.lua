-- ******** THANKS TO KINVER ********
function Run()
	if not GetInsideBuilding("", "BankBuilding") then
		MsgDebugMeasure("@L_MEASURE_OFFERCREDIT_FAIL_+0")
		StopMeasure()
	end

	if HasProperty("BankBuilding","OfferCreditNow") then
		return
	end

	if not HasProperty("BankBuilding","KreditKonto") then
		MsgDebugMeasure("@L_MEASURE_OFFERCREDIT_FAIL_+0")
		StopMeasure()
	end
	
	local TimeOut  = GetData("TimeOut")
	local MakeBreak = false

	GetLocatorByName("BankBuilding","Work3","ChiefPos")
	f_BeginUseLocator("","ChiefPos",GL_STANCE_SIT,true)
	SetProperty("BankBuilding", "OfferCreditNow", 1)
	SetProperty("BankBuilding", "OfferChr", GetID(""))
	SetProperty("BankBuilding", "OfferStartTime", GetGametime())

	if TimeOut ~= nil then
		TimeOut = GetGametime() + TimeOut
		MakeBreak = true
	end		

	while true do
		if MakeBreak then
			if TimeOut < GetGametime() then
				break
			end
		end

		local Kredit = GetProperty("BankBuilding","KreditKonto")
		if Kredit == 0 then
			break
		end
		
		if not DynastyIsPlayer("") then
			local Hour = math.mod(GetGametime(), 24)
			if (Hour > 3) and (Hour <7) then
				break
			end
		end

		if HasProperty("BankBuilding", "OfferChr") then
			local OfferID = GetProperty("BankBuilding","OfferChr")
			if GetID("") ~= OfferID then
				StopMeasure()
			else
				if Rand(11) > 9 then
					CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
					PlayAnimation("","sit_drink")
					CarryObject("","",false)
				end
				
				if HasProperty("BankBuilding","BankKundschaft") then
					if GetProperty("BankBuilding","BankKundschaft") > 0 then
						if SimGetGender("") == 1 then
							PlaySound3DVariation("","CharacterFX/male_neutral",1)
						else
							PlaySound3DVariation("","CharacterFX/female_neutral",1)
						end	
						local doWork = Rand(4)
						if doWork == 0 then
						    PlayAnimation("","sit_talk")
						elseif doWork == 1 then
						    PlayAnimation("","sit_talk_02")
						elseif doWork == 2 then
						    PlayAnimation("","sit_yes")
						else
						    PlayAnimation("","sit_no")
						end
					end
				end
				
				if not HasProperty("BankBuilding","KreditKonto") then
					StopMeasure()
				end

				if not HasProperty("BankBuilding","OfferCreditNow") then
					StopMeasure()
				end
				Sleep(5)
				IncrementXPQuiet("",1)
			end
		else
			break
		end
	end
end

function CleanUp()

	GetInsideBuilding("", "BankBuilding")
	if HasProperty("BankBuilding", "OfferCreditNow") then
		RemoveProperty("BankBuilding", "OfferCreditNow")
	end

	if HasProperty("BankBuilding" ,"OfferChr") then
		RemoveProperty("BankBuilding" ,"OfferChr")
	end

	StopAnimation("")
	CarryObject("","",false)
	CarryObject("","",true)
	MoveSetStance("",GL_STANCE_STAND)
	MoveSetActivity("","")
	f_EndUseLocator("","ChiefPos",GL_STACE_STAND)
end
