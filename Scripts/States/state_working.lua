function Run()
	SimGetWorkingPlace("","WorkingPlace")
	if BuildingGetOwner("WorkingPlace", "boss") and GetID("")~=GetID("boss") then	
		local ProdSkillBonus = 0
		if SimGetClass("")==1 or SimGetClass("")==2 then
			ProdSkillBonus = GetSkillValue("boss",CRAFTSMANSHIP)
		elseif SimGetClass("")==3 then
			ProdSkillBonus = GetSkillValue("boss",SECRET_KNOWLEDGE)
		elseif SimGetClass("")==4 then
			ProdSkillBonus = GetSkillValue("boss",CRAFTSMANSHIP)
		end

		ProdSkillBonus = ProdSkillBonus / 5
		AddImpact("","Productivity",ProdSkillBonus,-1)
	end

	SetProperty("", "StartWorkingTime", 1)
	
	while true do
		Sleep(Rand(40)+40)
	end
end

function CleanUp()

	if HasProperty("", "StartWorkingTime") then
		RemoveProperty("", "StartWorkingTime")
	end
	RemoveImpact("","Productivity")

end
