function Init()
end

function Run()
	local offsety = 90
	if not GetLocatorByName("", "sell", "Pos", true) then
		GetLocatorByName("", "Entry1", "Pos")
		offsety = 10
	end
	local x, y, z = PositionGetVector("Pos")
	GfxAttachObject("SellFlag","buildings/Verkaufsschild.nif")
	GfxSetPosition("SellFlag",x,y-offsety,z,true)
	while true do
		Sleep(Rand(2)+5)
		if not BuildingGetForSale("") then
			return
		end
	end
end

function CleanUp()
	GfxSetPosition("SellFlag",0,-1000,0,false)
	GfxDetachObject("SellFlag")
end
