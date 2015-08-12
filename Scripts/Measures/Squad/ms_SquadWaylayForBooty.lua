function Run() 

	SquadSetMeetingPlace("", "Destination")
	if not SquadGetLeader("", "Leader") then
		return
	end 
	
	if not GetDynasty("Leader", "dynasty") then
		return
	end

--	if GetLocalPlayerDynasty("LocalPlayer") then
--		if GetID("LocalPlayer") == GetID("dynasty") then
--			GetPosition("Destination", "SquadPos")
--			GfxAttachObject("Flag", "Editor/Settlement.nif")
--			GfxSetPositionTo("Flag", "SquadPos")
--			GfxScale("Flag", 0.2)
--		end
--	end

	local Target
	local Count
	while (true) do
		Sleep(1)
		Count = SquadGetMemberCount("", true)
		if Count==0 then
			StopMeasure()
		end
	end
end
	
function CleanUp()
	-- GfxDetachObject("Flag")
	SquadDestroy("")
end

