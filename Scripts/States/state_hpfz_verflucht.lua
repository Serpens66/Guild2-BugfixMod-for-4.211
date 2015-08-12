function Init()
end

function Run()

  local Slots, Number, ItemId, ItemCount, Abzug, Menge

    if GetImpactValue("","verflucht")==1 then
        GetPosition("","HausFliegen")
        GfxAttachObject("fliegen", "particles/flies.nif")
        GfxSetPositionTo("fliegen", "HausFliegen")
	    GfxMoveToPosition("fliegen",0,20,0,0.1,false)
	    GfxStartParticle("fliegenfliegen", "particles/flies.nif", "HausFliegen", 2)

        while GetImpactValue("",388)>0 do
              Slots = InventoryGetSlotCount("",INVENTORY_STD)
              Number = Rand(Slots)
              ItemId, ItemCount = InventoryGetSlotInfo("", Number, InventoryType)
              Abzug = Rand(3)

              if Abzug == 0 then
                 Menge = (ItemCount / 100) * 20
                 RemoveItems("",ItemId,Menge,INVENTORY_STD)
              elseif Abzug == 1 then
                 Menge = (ItemCount / 100) * 30
                 RemoveItems("",ItemId,Menge,INVENTORY_STD)
              elseif Abzug == 2 then
                 Menge = (ItemCount / 100) * 50
                 RemoveItems("",ItemId,Menge,INVENTORY_STD)
              end

              Sleep(30)
        end
        SetState("",STATE_HPFZ_VERFLUCHT,false)
        GfxDetachObject("fliegen")
        return
    end
 
end

function CleanUp()
  SetState("",STATE_HPFZ_VERFLUCHT,false)
end
