function CheckStart()
  return true
end

function Start()
	local Options = FindNode("\\Settings\\Options")
	local Difficulty = Options:GetValueInt("MissionDifficulty")
	
	SetProperty("Actor","CrimeMoneyScore",0)
	SetData("MissionDifficulty",Difficulty)
	if (Difficulty==0) then
		SetData("CrimeMoneyGoal",25000)
	elseif (Difficulty==1) then
		SetData("CrimeMoneyGoal",50000)
	else
		SetData("CrimeMoneyGoal",100000)
	end
	
	GetLocalPlayerDynasty("LocalPlayerDynasty")
	if (GetID("LocalPlayerDynasty") == GetID("Actor")) then
		SetMainQuestTitle("MAIN_MISSION","@L_INTERFACE_MISSIONS_QUESTBOOK_HEADER","@L_MISSIONS_MISSIONS_CRIMINAL_+0")
		SetMainQuest("MAIN_MISSION")
		feedback_MessageMission("Actor","@L_MISSIONS_MISSIONS_CRIMINAL_+0","@L_MISSIONS_MISSIONS_CRIMINAL_+1",GetData("CrimeMoneyGoal"))
	end
	
	GetScenario("World")
	if HasProperty("World", "Finito") then
		RemoveProperty("World", "Finito")
	end
	
end

function CheckEnd()
	
	if HasProperty("World", "Finito") then
		return true
	end
	
	if GetDynasty("Actor","criminal_dynasty") then
	
		if (GetProperty("criminal_dynasty","CrimeMoneyScore") >= GetData("CrimeMoneyGoal")) then
	   		return true
	   	else
			if CheckPlayerExtinct("Actor") then
				SetData("extinct", 1)
				return true
			elseif CheckPlayerBankrupt("Actor") then
				SetData("bankrupt", 1)
				return true
			end
			
			GetLocalPlayerDynasty("LocalPlayerDynasty")
			if (GetID("LocalPlayerDynasty") == GetID("Actor")) then
				SetMainQuestDescription("MAIN_MISSION","@L_INTERFACE_MISSIONS_CRIMINAL_+0",GetData("CrimeMoneyGoal"),GetProperty("criminal_dynasty","CrimeMoneyScore"))
			end
		end
	
	
	end
 	return false
end

function End()
	
	local Won = 0
	local Extinct = HasData("extinct")
	local Bankrupt = HasData("bankrupt")
	local LastMemberID = GetProperty("Actor", "LastMemberID")
	
	if IsMultiplayerGame() then
	
		-- ---------------
		-- Multiplayer end
		-- ---------------
		if HasProperty("World", "Finito") then
			local	Winner = GetProperty("World", "Finito")
			MsgBoxNoWait("Actor", nil, "@L_MISSIONS_MISSIONS_LOOSE_HEAD", "@L_MISSIONS_MISSIONS_LOOSE_MULTIPLAYER_BODY", Winner)
			DynastyAvoidControl("Actor")
			return
		end
		
		if Extinct then
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			MsgBoxNoWait("Actor", nil, "@L_FAMILY_6_DEATH_MSG_DEAD_END_OWNER_HEAD", "@L_FAMILY_6_DEATH_MSG_DEAD_END_OWNER_BODY", LastMemberID)
		elseif Bankrupt then
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			MsgBoxNoWait("Actor", nil, "@L_TOOMUCHDEBT_2_HEAD", "@L_TOOMUCHDEBT_2_BODY", GetID("Actor"))
		else
			SetProperty("World", "Finito", GetID("Actor"))
			
			if (GetID("LocalPlayerDynasty") == GetID("Actor")) then
				gameplayformulas_StartHighPriorMusic(MUSIC_GAME_WON)
				local CrimeMoneyGoal = GetData("CrimeMoneyGoal")
				MsgBoxNoWait("Actor", nil, "@L_MISSIONS_MISSIONS_CRIMINAL_+0", "@L_MISSIONS_MISSIONS_CRIMINAL_+2", CrimeMoneyGoal)
			else
				gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			end
		end		
		
	else
	
		-- ----------------
		-- Singleplayer end
		-- ----------------
		local ShowStats = 0
		if Extinct then
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			if MsgBox("Actor", nil, "@P@B[M,@L_INTERFACE_BUTTONS_ENDGAME]@B[S,@L_INTERFACE_BUTTONS_STATISTICS]", "@L_FAMILY_6_DEATH_MSG_DEAD_END_OWNER_HEAD", "@L_FAMILY_6_DEATH_MSG_DEAD_END_OWNER_BODY", LastMemberID) == "S" then
				ShowStats = 1
			end
		elseif Bankrupt then
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			if MsgBox("Actor", nil, "@P@B[M,@L_INTERFACE_BUTTONS_ENDGAME]@B[S,@L_INTERFACE_BUTTONS_STATISTICS]", "@L_TOOMUCHDEBT_2_HEAD", "@L_TOOMUCHDEBT_2_BODY", GetID("Actor")) == "S" then
				ShowStats = 1
			end
		else
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_WON)
			local CrimeMoneyGoal = GetData("CrimeMoneyGoal")
			if MsgBox("Actor", nil, "@P@B[M,@L_INTERFACE_BUTTONS_ENDGAME]@B[S,@L_INTERFACE_BUTTONS_STATISTICS]", "@L_MISSIONS_MISSIONS_CRIMINAL_+0", "@L_MISSIONS_MISSIONS_CRIMINAL_+2", CrimeMoneyGoal) == "S" then
				ShowStats = 1
				Won = 1
			end
		end
					
		-- Show the statistics screen or not
		if ShowStats == 1 then
			ShowStatistics()
			while HudPanelIsVisible("StatisticsSheetGold") or
				HudPanelIsVisible("StatisticsSheetAsset") or
				HudPanelIsVisible("StatisticsSheetSkill") or
				HudPanelIsVisible("StatisticsSheetAlign") or
				HudPanelIsVisible("StatisticsSheetPoints") or
				HudPanelIsVisible("StatisticsBalanceLast") or
				HudPanelIsVisible("StatisticsBalanceTotal") do
					Sleep(1.0)
			end
		end
		
		-- End the game
		if Won == 0 then
			CampaignExit(false)
		else
			CampaignExit(true)
		end
		
	end	
	
end

function CleanUp()
end
