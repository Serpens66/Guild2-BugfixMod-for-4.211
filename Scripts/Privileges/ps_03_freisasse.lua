function GetPrivilegeList()
	return ""
end

function GetCompletePrivilegeList()
	return ps_03_freisasse_GetPrivilegeList() --, ps_02_gemeiner_GetPrivilegeList() -- don't know where the problem is, I can't go that deep :/
end

function TakeTitle()
	gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
	chr_SetNobilityImpactList("TitleHolder", ps_03_freisasse_GetPrivilegeList())

	local currenttitle = GetNobilityTitle("TitleHolder") + 1
	local buildinglevel = GetDatabaseValue("NobilityTitle", currenttitle, "maxresidencelevel")
	local maxworkshops = GetDatabaseValue("NobilityTitle", currenttitle, "maxworkshops")
	local BuildLabel = "_BUILDING_Residence"..buildinglevel.."_NAME_+0"
	local TitleLabel = "_CHARACTERS_3_TITLES_NAME_+"..(currenttitle * 2) - 1

	local buildingcount = 0
	local Count = DynastyGetBuildingCount2("TitleHolder")
	local Type
	for l=0,Count-1 do
		if DynastyGetBuilding2("TitleHolder", l, "Check") then
			Type = BuildingGetClass("Check")
			if Type~=GL_BUILDING_CLASS_LIVINGROOM and Type~=GL_BUILDING_CLASS_RESOURCE then
				buildingcount = buildingcount + 1
			end
		end
	end

	feedback_MessageCharacter("",
		"@L_CHARACTERS_3_TITLES_AQUIRE_MESSAGES_NEW_PRIVILEGES_HEAD_+0",
		"@L_CHARACTERS_3_TITLES_AQUIRE_MESSAGES_NEW_BODY_+0", TitleLabel, BuildLabel, maxworkshops, buildingcount, chr_GeneratePrivilegeListLabels(ps_03_freisasse_GetCompletePrivilegeList()))

end

function LooseTitle()
	chr_RemoveNobilityImpactList("TitleHolder", ps_03_freisasse_GetPrivilegeList())
end
 
