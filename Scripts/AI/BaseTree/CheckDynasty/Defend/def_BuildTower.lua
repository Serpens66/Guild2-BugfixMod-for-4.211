function Weight()
	if GetMoney("Dynasty")<3000 then
		return 0
	end
	
	if not DynastyGetRandomBuilding("Dynasty", -1, -1, "ProtectMe") then
		return 0
	end

	if not BuildingGetCity("ProtectMe", "ProCity") then
		return 0
	end
	
	local	Proto = ScenarioFindBuildingProto(0, GL_BUILDING_TYPE_TOWER, 1, -1)
	if Proto==-1 then
		return 0
	end
	
	if not BuildingGetOwner("ProtectMe", "BuildOwner") then
		return 0
	end
	
	SetData("TowerProto", Proto)
	
	return 40
end

function Execute()
	local Proto = GetData("TowerProto", Proto)
	if not CityBuildNewBuilding("ProCity", Proto, "BuildOwner", "Tower", "ProtectMe", 1500) then
		return
	end
	return
end

