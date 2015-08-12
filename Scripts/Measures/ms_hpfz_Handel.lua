function Run()

	if not f_MoveTo("","Destination") then
		MsgQuick("","")
    StopMeasure()
  end	
	
	local bestand1, bestand2, lagerSlot = ms_hpfz_handel_BestandCheck()
  if bestand1 == 0 and bestand2 == 0 then
	  MsgQuick("","_HPFZ_HANDEL_FEHLER_+0")
	  StopMeasure()
  end

  MeasureSetStopMode(STOP_NOMOVE)
  CommitAction("handeln", "", "")

  while bestand1 > 0 or bestand2 > 0 do
	  local s, ItID, ItMg, ItIDX, ItMgX
	  if bestand1 > 0 then
	    for s = 0, lagerSlot-1 do
		    ItID, ItMg = InventoryGetSlotInfo("",s,INVENTORY_STD)
				if ItMg > 0 then
	        GetPosition("","MovePos")
	        GfxAttachObject("tradetisch", "city/Stuff/tradetable.nif")
	        GfxSetPositionTo("tradetisch", "MovePos")	

          while GetItemCount("",ItID) > 0 do
				    if ItemGetCategory(ItID) == 1 then
		          ms_hpfz_handel_Ausrufer(1)
		        elseif ItemGetCategory(ItID) == 2 then
	            ms_hpfz_handel_Ausrufer(2)
		        elseif ItemGetCategory(ItID) == 3 then
	            ms_hpfz_handel_Ausrufer(3)
		        elseif ItemGetCategory(ItID) == 4 then
	            ms_hpfz_handel_Ausrufer(4)
		        elseif ItemGetCategory(ItID) == 5 then
	            ms_hpfz_handel_Ausrufer(5)
		        end
          end
          GfxDetachAllObjects()
				end
			end
		end

    if bestand2 > 0 then
	    for s = 0, lagerSlot-1 do
				Find("", "__F((Object.GetObjectsByRadius(Cart)==800)AND(Object.CanBeControlled())AND(Object.BelongsToMe()))", "ExtraLagerX", 1)
				hpfzFreierHandelKarrenID = GetID("ExtraLagerX")
		    ItIDX, ItMgX = InventoryGetSlotInfo("ExtraLagerX",s,INVENTORY_STD)
	
				if ItMgX > 0 then
		      GfxAttachObject("verkaufsStand", "city/freierhandler.nif")
	
	        while GetItemCount("ExtraLagerX",ItIDX) > 0 do
				    if ItemGetCategory(ItIDX) == 1 then
				      ms_hpfz_handel_Ausrufer(1)
				    elseif ItemGetCategory(ItIDX) == 2 then
				      ms_hpfz_handel_Ausrufer(2)
				    elseif ItemGetCategory(ItIDX) == 3 then
				      ms_hpfz_handel_Ausrufer(3)
				    elseif ItemGetCategory(ItIDX) == 4 then
				      ms_hpfz_handel_Ausrufer(4)
				    elseif ItemGetCategory(ItIDX) == 5 then
				      ms_hpfz_handel_Ausrufer(5)
				    end
	        end
	        GfxDetachAllObjects()
				end
			end
		end

	  bestand1, bestand2, lagerSlot = ms_hpfz_handel_BestandCheck()
	end

  StopAction("handeln","")
	hpfzFreierHandelKarrenID = 0
  StopMeasure()
end

function BestandCheck()

  local Slots = InventoryGetSlotCount("",INVENTORY_STD)
  local r, ItemID, ItemMenge
  local Lager = 0
	local LagerX = 0

  for r = 0, Slots-1 do
    ItemID, ItemMenge = InventoryGetSlotInfo("",r,INVENTORY_STD)
    if ItemMenge ~= nil and ItemMenge > 0 then
        Lager = Lager + 1
    end 
		if ItemID ~= nil then
	    if ItemGetCategory(ItemID)==0 or ItemGetCategory(ItemID)==6 then
  	    Lager = Lager - 1
	    end
		end
  end

	local Karren = Find("", "__F((Object.GetObjectsByRadius(Cart)==800)AND(Object.CanBeControlled())AND(Object.BelongsToMe()))", "ExtraLager", 1)
    if Karren > 0 then
        Slots = InventoryGetSlotCount("ExtraLager",INVENTORY_STD)
        for r = 0, Slots-1 do
            ItemID, ItemMenge = InventoryGetSlotInfo("ExtraLager",r,INVENTORY_STD)
            if ItemMenge ~= nil and ItemMenge > 0 then
                LagerX = LagerX + 1
            end 
			if ItemID ~= nil then
	            if ItemGetCategory(ItemID)==0 or ItemGetCategory(ItemID)==6 then
	                LagerX = LagerX - 1
		        end
			end
        end
	end
	return Lager, LagerX, Slots
	
end

function Ausrufer(z)

    local HandVerkauf = Rand(3)
    local Aktion
    local Rufe = Rand(2)

    if SimGetGender("")==GL_GENDER_MALE then
        PlaySound3DVariation("","CharacterFX/male_jolly",1)
    else
        PlaySound3DVariation("","CharacterFX/female_jolly",1)
    end
    PlayAnimation("","preach")
    Sleep(1)
    if z==1 then
        MoveSetActivity("","carry")
        if HandVerkauf == 0 then
            CarryObject("", "Handheld_Device/ANIM_Floursack.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+0")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+1")
            end
        elseif HandVerkauf == 1 then
            CarryObject("", "Handheld_Device/ANIM_Woodlog.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+2")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+3")
            end
        else
            CarryObject("", "Handheld_Device/ANIM_Metalbar.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+4")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+5")
            end
        end
        Sleep(12)
    elseif z==2 then
        MoveSetActivity("","carry")
        if HandVerkauf == 0 then
            CarryObject("", "Handheld_Device/ANIM_Barrel.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+6")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+7")
            end
        elseif HandVerkauf == 1 then
            CarryObject("", "Handheld_Device/ANIM_Breadbasket.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+8")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+9")
            end
        else
            CarryObject("", "Handheld_Device/ANIM_fish_L.nif", true)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+10")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+11")
            end
        end
        Sleep(12)
    elseif z==3 then
        Aktion = PlayAnimationNoWait("","use_object_standing")
        Sleep(1)
        if HandVerkauf == 0 then
            CarryObject("", "Handheld_Device/Anim_Hammer.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+12")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+13")
            end
        elseif HandVerkauf == 1 then
            CarryObject("", "Handheld_Device/ANIM_gun.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+14")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+15")
            end
        else
            CarryObject("", "weapons/langsword_01.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+16")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+17")
            end
        end
        Sleep(Aktion-1)
    elseif z==4 then
        if HandVerkauf == 0 then
            MoveSetActivity("","carry")
            CarryObject("", "Handheld_Device/ANIM_bookpile.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+18")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+19")
            end
            Sleep(12)
        elseif HandVerkauf == 1 then
            MoveSetActivity("","carry")
            CarryObject("", "Handheld_Device/ANIM_Cloth.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+20")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+21")
            end
            Sleep(12)
        else
            Aktion = PlayAnimationNoWait("","use_object_standing")
            Sleep(1)
            CarryObject("", "Handheld_Device/ANIM_Smallsack.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+22")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+23")
            end
            Sleep(Aktion-1)
        end
    elseif z==5 then
        if HandVerkauf == 0 then
            MoveSetActivity("","carry")
            CarryObject("", "Handheld_Device/ANIM_Bottlebox.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+24")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+25")
            end
            Sleep(12)
        elseif HandVerkauf == 1 then
            Aktion = PlayAnimationNoWait("","use_object_standing")
            Sleep(1)
            CarryObject("", "Handheld_Device/ANIM_Aesculap_Staff.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+26")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+27")
            end
            Sleep(Aktion-1)
        else
            Aktion = PlayAnimationNoWait("","use_object_standing")
            Sleep(1)
            CarryObject("", "Handheld_Device/ANIM_perfumebottle.nif", false)
            if Rufe==0 then
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+28")
            else
                MsgSay("","_HPFZ_HANDEL_SPRUCH_+29")
            end
            Sleep(Aktion-1)
        end
    end
	CarryObject("", "", false)
	CarryObject("", "", true)
    MoveSetActivity("")

end

function CleanUp()
	StopAnimation("")
	StopAction("handeln", "")
    MoveSetActivity("")
	GfxDetachAllObjects()
	CarryObject("", "", false)
	CarryObject("", "", true)
end
