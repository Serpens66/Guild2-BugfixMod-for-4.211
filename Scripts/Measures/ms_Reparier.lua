function Init()
end

function Run()

	if GetItemCount("",80)==0 then 	
		MsgQuick("","_HPFZ_REPARIER_FEHLER_+0")
		StopMeasure()
	end

  if GetHP("Destination")==GetMaxHP("Destination") then
    MsgQuick("","_HPFZ_REPARIER_FEHLER_+1")
    StopMeasure()
  end

  if not f_MoveTo("","Destination",GL_WALKSPEED_RUN, 300) then
    StopMeasure()
  end

  GetOutdoorMovePosition("","Destination","WorkPos2")
  GetFreeLocatorByName("Destination","bomb",1,3,"WorkPos",true)
  if not f_BeginUseLocator("","WorkPos",GL_STANCE_STAND,true) then
    if not f_MoveTo("","WorkPos2") then
	    StopMeasure()
    end
  end

  AlignTo("","Destination")
	Sleep(0.7)
	SetContext("","rangerhut")
	CarryObject("","Handheld_Device/Anim_Hammer.nif", false)
	PlayAnimation("","chop_in")

	local hpmod = 100 + (25 * GetSkillValue("", CRAFTSMANSHIP))
	local hpprocess

  while GetItemCount("",80)>0 do
    RemoveItems("",80,1)
  	hpprocess = math.floor(hpmod / 10)
    for i=1,10 do
    	PlayAnimation("","chop_loop")
    	ModifyHP("Destination",hpprocess,false)
	    if GetHP("Destination")==GetMaxHP("Destination") then
				f_EndUseLocator("","WorkPos",GL_STANCE_STAND)
				PlayAnimation("","chop_out")
				CarryObject("","",false)
	      StopAnimation()
		  chr_GainXP("",GetData("BaseXP"))
		    feedback_MessageWorkshop("", 
			    "@L_BUILDING_RENOVATE_SUCCESS_HEAD_+0",
			    "@L_BUILDING_RENOVATE_SUCCESS_BODY_+0", GetID("Destination"))
				StopMeasure()
	    end
		end
  end

	f_EndUseLocator("","WorkPos",GL_STANCE_STAND)
	PlayAnimation("","chop_out")
	CarryObject("","",false)
  StopAnimation("")
  MsgQuick("","_HPFZ_REPARIER_FEHLER_+2")
  StopMeasure()
end

function Cleanup()
  StopAnimation("")
  StopMeasure()
	CarryObject("","",false)
end
