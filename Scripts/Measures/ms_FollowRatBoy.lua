function Run()
	local RatBoyFilter = "__F( (Object.GetObjectsByRadius(Sim)==3200)AND(Object.HasProperty(ImYourDestiny)))"
	local NumRatBoys = Find("",RatBoyFilter,"RatBoy",-1)
	if NumRatBoys>0 then
		f_FollowNoWait("","RatBoy",GL_MOVESPEED_RUN,Rand(200)+200,false,false)
	end
	
	while HasProperty("RatBoy","ImYourDestiny") do
		if HasProperty("RatBoy","LetsGo") then
		    GetOutdoorLocator("MapExit1",1,"MapExit")
			if not GetOutdoorLocator("MapExit1",1,"MapExit") then
			    GetOutdoorLocator("MapExit2",1,"MapExit")
				if not GetOutdoorLocator("MapExit2",1,"MapExit") then
				    GetOutdoorLocator("MapExit3",1,"MapExit")
				else
				    StopMeasure()
				end
			end
			f_MoveTo("","MapExit",GL_MOVESPEED_WALK)
			while HasProperty("RatBoy","LetsGo") do
				if HasProperty("RatBoy","KillingTime") then
					local Age = SimGetAge("")
					local SettlementId = GetSettlementID("")
					feedback_MessageCharacter("", "@L_FAMILY_6_DEATH_MSG_DEAD_OWNER_HEAD", "@L_FAMILY_6_DEATH_MSG_DEAD_OWNER_BODY_MALE", GetID(""), Age, SettlementId)
					ModifyHP("",-GetMaxHP(""))
				end
				Sleep(2)
			end
		end
		

		Sleep(2)
	end
	
	StopMeasure()
end

function CleanUp()
	AddImpact("","HaveBeenPickpocketed",1,4)
end

