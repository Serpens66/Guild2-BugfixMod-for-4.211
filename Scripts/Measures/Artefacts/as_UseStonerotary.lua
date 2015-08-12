
function Run()
	if IsStateDriven() then
		if (HasProperty("","HaveCutscene") == true) then
			return
		end		
		local ItemName = "Stonerotary"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

  local MaxDistance = 1500
  local ActionDistance = 130
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

  if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
      StopMeasure()
  end	

	StopAnimation("Destination")
  AlignTo("", "Destination")
  AlignTo("Destination", "")
  SetMeasureRepeat(TimeOut)
  MeasureSetNotRestartable()

	local time1
	local time2
	time1 = PlayAnimationNoWait("", "use_object_standing")
	time2 = PlayAnimationNoWait("Destination","cogitate")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_Smallsack.nif",false)
		
	Sleep(1)

	CarryObject("","",false)
	CarryObject("Destination","Handheld_Device/ANIM_Smallsack.nif",false)
	time2 = PlayAnimationNoWait("Destination","fetch_store_obj_R")
	Sleep(1)	
	StopAnimation("")
	PlaySound3D("Destination","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("Destination","",false)	
	
	if RemoveItems("","Stonerotary",1)>0 then	
		chr_GainXP("",GetData("BaseXP"))

		local random = Rand(200) + 400
		chr_GainXP("Destination",random)
		SetProperty("Destination", "Stonerotary", 1)
		local DestinationAnimationLength = PlayAnimationNoWait("Destination", "cheer_01")
		Sleep(DestinationAnimationLength * 0.4)
	end
	StopMeasure()
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

function CleanUp()
	
end
