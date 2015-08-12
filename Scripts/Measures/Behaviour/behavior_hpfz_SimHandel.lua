function Run()

	if Rand(5) > 1 then
	    GetFleePosition("Owner", "Actor", Rand(50)+100, "Away")
	    f_MoveTo("Owner", "Away", GL_MOVESPEED_WALK)
	    AlignTo("Owner", "Actor")
	    Sleep(1)
		
		if Rand(10) < 5 then
			if SimGetGender("Owner")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_cheer",1)
			else
				PlaySound3DVariation("","CharacterFX/female_cheer",1)
			end
			TimeLeft = PlayAnimation("Owner", "cheer_01")
		else
			TimeLeft = PlayAnimation("Owner", "cheer_02")
		end
		local ItemCat = behavior_hpfz_simhandel_KundeAuswahl()
		if ItemCat > 0 then
			 behavior_hpfz_simhandel_KundeReaktion(ItemCat)
		end
		SatisfyNeed("Owner",7,0.10)
	end

end

function KundeAuswahl()

  GetAliasByID(hpfzFreierHandelKarrenID,"KarrLager")
	local lagInhalt = { nil }
	local einkauf = nil

  if hpfzFreierHandelKarrenID > 0 then
		local r = 0
		local itemX, mengeX, slotX, feil, gPreis, summe, bonus
    slotX = InventoryGetSlotCount("KarrLager",INVENTORY_STD)
    for s = 0, slotX-1 do
      itemX, mengeX = InventoryGetSlotInfo("KarrLager",s,INVENTORY_STD)
	    if itemX and mengeX > 0 then
		    r = r + 1
	      lagInhalt[r] = itemX
	    end
    end
    einkauf = ( Rand(r) + 1 )

		if ItemGetCategory(lagInhalt[einkauf])~=0 and ItemGetCategory(lagInhalt[einkauf])~=6 then
			feil = GetSkillValue("Actor",9)
	    gPreis = ItemGetBasePrice(lagInhalt[einkauf])
			bonus = ( SimGetRank("Owner") + 5 )
      summe = ((feil * bonus) + gPreis)
      CreditMoney("Actor",summe,"Offering")
			IncrementXPQuiet("Actor",5)
      if IsDynastySim("Owner") then
            SpendMoney("Owner", summe, "Offering",true)
      end
      ShowOverheadSymbol("Actor",false,true,0,"%1t",summe)
      RemoveItems("KarrLager", lagInhalt[einkauf], 1)
	  end

	else
    local itemX, mengeX, slotX, feil, gPreis, summe, bonus, charm
    local r = 0
    slotX = InventoryGetSlotCount("Actor",INVENTORY_STD)
    for s = 0, slotX-1 do
      itemX, mengeX = InventoryGetSlotInfo("Actor",s,INVENTORY_STD)
	    if itemX and mengeX > 0 then
		    r = r + 1
				lagInhalt[r] = itemX
	    end
    end
    einkauf = ( Rand(r) + 1 )

		if ItemGetCategory(lagInhalt[einkauf])~=0 and ItemGetCategory(lagInhalt[einkauf])~=6 then
      feil = GetSkillValue("Actor",9)
			charm = GetSkillValue("Actor",3)
      gPreis = ItemGetBasePrice(lagInhalt[einkauf])
			bonus = ( SimGetRank("Owner") * charm )
      summe = ((feil * bonus) + gPreis)
      CreditMoney("Actor",summe,"Offering")
			IncrementXPQuiet("Actor",5)
      ShowOverheadSymbol("Actor",false,true,0,"%1t",summe)
      RemoveItems("Actor", lagInhalt[einkauf], 1)
		end
	end

	local itcat = ItemGetCategory(lagInhalt[einkauf])
	return itcat
	
end

function KundeReaktion(z)

    local simReagiert = Rand(3)
    local HandVerkauf = Rand(3)
	if simReagiert == 0 or simReagiert == 2 then
        if z == 1 then
            MoveSetActivity("Owner","carry")
            if HandVerkauf == 0 then
                CarryObject("Owner", "Handheld_Device/ANIM_Floursack.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+0")
            elseif HandVerkauf == 1 then
                CarryObject("Owner", "Handheld_Device/ANIM_Woodlog.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+1")
            else
                CarryObject("Owner", "Handheld_Device/ANIM_Metalbar.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+2")
            end
            Sleep(3)
	    elseif z == 2 then
            MoveSetActivity("Owner","carry")
            if HandVerkauf == 0 then
                CarryObject("Owner", "Handheld_Device/ANIM_Barrel.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+3")
            elseif HandVerkauf == 1 then
                CarryObject("Owner", "Handheld_Device/ANIM_Breadbasket.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+4")
            else
                CarryObject("Owner", "Handheld_Device/ANIM_fish_L.nif", true)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+5")
            end
            Sleep(3)
	    elseif z == 3 then
            local Aktion = PlayAnimationNoWait("Owner","use_object_standing")
            Sleep(1)
            if HandVerkauf == 0 then
                CarryObject("Owner", "Handheld_Device/Anim_Hammer.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+6")
            elseif HandVerkauf == 1 then
                CarryObject("Owner", "Handheld_Device/ANIM_gun.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+7")
            else
                CarryObject("Owner", "weapons/langsword_01.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+8")
            end
            Sleep(Aktion-1)
	    elseif z == 4 then
            if HandVerkauf == 0 then
                MoveSetActivity("Owner","carry")
                CarryObject("Owner", "Handheld_Device/ANIM_bookpile.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+9")
                Sleep(3)
            elseif HandVerkauf == 1 then
                MoveSetActivity("Owner","carry")
                CarryObject("Owner", "Handheld_Device/ANIM_Cloth.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+10")
                Sleep(3)
            else
                local Aktion = PlayAnimationNoWait("Owner","use_object_standing")
                Sleep(1)
                CarryObject("Owner", "Handheld_Device/ANIM_Smallsack.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+11")
                Sleep(Aktion-1)
            end
	    elseif z == 5 then
            if HandVerkauf == 0 then
                MoveSetActivity("Owner","carry")
                CarryObject("Owner", "Handheld_Device/ANIM_Bottlebox.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+12")
                Sleep(3)
            elseif HandVerkauf == 1 then
                local Aktion = PlayAnimationNoWait("Owner","use_object_standing")
                Sleep(1)
                CarryObject("Owner", "Handheld_Device/ANIM_Aesculap_Staff.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+13")
                Sleep(Aktion-1)
            else
                local Aktion = PlayAnimationNoWait("Owner","use_object_standing")
                Sleep(1)
                CarryObject("Owner", "Handheld_Device/ANIM_perfumebottle.nif", false)
                MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+14")
                Sleep(Aktion-1)
            end
		end
	end
    MoveSetActivity("")
	CarryObject("", "", false)
	CarryObject("", "", true)
	
end

function CleanUp()
    CarryObject("Owner", "", false)
    MoveSetActivity("Owner")
   	CarryObject("", "", false)
	CarryObject("", "", true)
    MoveSetActivity("")
end
