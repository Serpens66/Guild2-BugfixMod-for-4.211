function Weight()

	local Count = DynastyGetMemberCount("dynasty")
	for i=0,Count-1 do
	
		if DynastyGetMember("dynasty", i, "Parent") then
		
			local Childs = SimGetChildrenCount("Parent")
			for c=0,Childs-1 do
			
				if SimGetChildren("Parent", c, "Child") and GetSettlement("Child", "City") then
					
					-- check for school
				
					if GetCurrentMeasureName("Child")=="Schooldays" then
						if GetProperty("Child", "EduLevel")==0 then
							if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "School") and (gameplayformulas_CheckPublicBuilding("City", GL_BUILDING_TYPE_BANK)[1]>0) then
								SetData("ToDo", "School")
								return 100
							end
						end
					end
						
					-- check for apprenticeship

					if GetCurrentMeasureName("Child")=="Apprenticeship" then
						if not HasProperty("Child", "is_apprentice") then

							local Class = AIFindGoodClass("Child")
							local DynID = GetDynastyID("Child")

							for trys=0,10 do
						
								if CityGetBuildingForCharacter("City", Class, FILTER_HAS_DYNASTY, "WorkShop") then
									if GetDynastyID("WorkShop") ~= DynID then
										if DynastyGetDiplomacyState("Child", "WorkShop") >= DIP_NEUTRAL then
											CopyAlias("WorkShop", "School")
											SetData("ToDo", "Apprentice")
											return 100
										end
									end
								end
							end
							
						end
					end
						
						
					-- check for university
					
					if GetCurrentMeasureName("Child")=="University" then
						if SimGetClass("Child")==3 then
							if GetProperty("Child", "EduLevel")>0 and GetProperty("Child", "EduLevel")<3 then
								if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "School") and (gameplayformulas_CheckPublicBuilding("City", GL_BUILDING_TYPE_BANK)[1]>0) then
									SetData("ToDo", "Uni")
									return 100
								end
							end
						end
					end

				end
			end
		end
	end
	return 0
end
			
function Execute()
	local		ToDo = GetData("ToDo")
	
	if ToDo=="School" then
		MeasureRun("Child", "School", "AttendSchool")
		return
	end
	
	if ToDo=="Apprentice" then
		MeasureRun("Child", "School", "AttendApprenticeship")
		return
	end

	if ToDo=="Uni" then
		MeasureRun("Child", "School", "AttendUniversity")
		return
	end
	
end

