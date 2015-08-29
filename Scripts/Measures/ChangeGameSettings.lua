-- this measure allows you to change Years per Round and how often sessions should be. 
-- But the main reason for this measure is to prevent OoS bugs, if you play multiplayer and chose a different setting than every 1 round a session

function Run()
	
    local Hour = math.mod(GetGametime(), 24)
    if Hour > 12 and Hour < 24 then   -- do not change setting in this timeperiod, because it could cause problems when it is too near to the next session
        MsgQuick("","@L_GAMESETTINGS_FORBIDDEN_TIME")
        StopMeasure()
    end
    
	GetScenario("World")
    GetLocalPlayerDynasty("localdyn")  -- send quick message to every player
    
    local firsttime = false
    if HasProperty("World","ChangeSettingsNumber") then
        Allowedchanges = GetProperty("World","ChangeSettingsNumber")
    else
        Allowedchanges = -1
        firsttime = true
    end 

    if Allowedchanges == 0 then
        MsgQuick("","@L_GAMESETTINGS_FORBIDDEN")
        -- set for all party sims, so the measure does not appear again
        local GlobalSimCount = ScenarioGetObjects("cl_Sim", -1, "Sims")
        for i = 0, GlobalSimCount-1 do
            GetDynasty("Sims"..i,"Dyn")
            if IsPartyMember("Sims"..i) and DynastyIsPlayer("Dyn") then
                homeexist = GetInsideBuilding("Sims"..i,"Home")
                if homeexist then
                    SetProperty("Home","ChangeSettingsBlock",1) -- is checked in the filter dbt
                end
                GetHomeBuilding("Sims"..i,"Home")
                SetProperty("Home","ChangeSettingsBlock",1)
            end           
        end
        StopMeasure()
    end
    
    MsgQuick("localdyn",GetName("").." opened the gamesettings.")
    
    local YearsButton = ""
    local cancel = "" 
    local Body = "@L_MEASURE_CHANGEGAMESETTINGS_BODY_+1"   -- choose sessions again, if it is the first time
    if not firsttime or not IsMultiplayerGame() then  -- if it is not the first time we call this or if it is not a multiplayergame
        YearsButton = "@B[1,@L_GAMESETTINGS_BUTTONS_YEARS]"
        Body = "@L_MEASURE_CHANGEGAMESETTINGS_BODY_+2"  -- what do you want to change? 
        cancel = "@B[N,@L_MEASURE_CHANGEGAMESETTINGS_FINISH]"
    end
    
    while true do
        local Result = MsgBox("","","@P"..
                YearsButton..
                "@B[2,@L_GAMESETTINGS_BUTTONS_SESSIONS]"..
                cancel,
                "@L_MEASURE_CHANGEGAMESETTINGS_NAME_+0",
                Body,
                ScenarioGetYearsPerRound(),GetProperty("World","fos"))
        
        if Result=="N" then 
            break -- break while loop
        elseif Result==1 then
            local Result = MsgBox("","","@P"..
                    "@B[1,@L_REPLACEMENTS_BUTTONS_NUMBER_+1]"..
                    "@B[2,@L_REPLACEMENTS_BUTTONS_NUMBER_+2]"..
                    "@B[3,@L_REPLACEMENTS_BUTTONS_NUMBER_+3]"..
                    "@B[4,@L_REPLACEMENTS_BUTTONS_NUMBER_+4]"..
                    cancel,
                    "@L_MEASURE_CHANGEGAMESETTINGS_NAME_+0",
                    "@L_GAMESETTINGS_YEARS",
                    0)
            
            if Result ~= "N" and Result ~= "C" then
                ScenarioSetYearsPerRound(Result)
                MsgQuick("localdyn","Years per Round new: "..ScenarioGetYearsPerRound())
            elseif Result == "N" then
                break
            end
        elseif Result==2 then
            local Result = MsgBox("","","@P"..
                    "@B[1,@L_REPLACEMENTS_BUTTONS_NUMBER_+1]"..
                    "@B[2,@L_REPLACEMENTS_BUTTONS_NUMBER_+2]"..
                    "@B[3,@L_REPLACEMENTS_BUTTONS_NUMBER_+3]"..
                    "@B[4,@L_REPLACEMENTS_BUTTONS_NUMBER_+4]"..
                    cancel,
                    "@L_MEASURE_CHANGEGAMESETTINGS_NAME_+0",
                    "@L_GAMESETTINGS_SESSIONS",
                    0)
            
            if Result ~= "N" and Result ~= "C" then
                SetProperty("World","fos",Result)
                cancel = "@B[N,@L_MEASURE_CHANGEGAMESETTINGS_FINISH]"  -- continue with these settings
                Body = "@L_MEASURE_CHANGEGAMESETTINGS_BODY_+2"   -- what do you want to change? 
                YearsButton = "@B[1,@L_GAMESETTINGS_BUTTONS_YEARS]"
                MsgQuick("localdyn","Every "..GetProperty("World","fos").." round one session. new")
            elseif Result == "N" then
                break
            end
        elseif Result == "C" and cancel=="" then
            MsgQuick("","@L_GAMESETTINGS_PLS_CHANGE")
        elseif Result == "C" and cancel=="@B[N,@L_MEASURE_CHANGEGAMESETTINGS_FINISH]" then
            break
        else
            MsgQuick("","Error, Result: "..Result)
        end
    end
    
    
    -- how often you want to be able to change settings
    if firsttime then 
        while true do
            local Result = MsgBox("","","@P"..
                    "@B[0,@L_REPLACEMENTS_BUTTONS_NUMBER_+0]"..
                    "@B[1,@L_REPLACEMENTS_BUTTONS_NUMBER_+1]"..
                    "@B[2,@L_REPLACEMENTS_BUTTONS_NUMBER_+2]"..
                    "@B[3,@L_REPLACEMENTS_BUTTONS_NUMBER_+3]"..
                    "@B[4,@L_REPLACEMENTS_BUTTONS_NUMBER_+4]"..
                    "@B[5,@L_REPLACEMENTS_BUTTONS_NUMBER_+5]"..
                    "@B[6,@L_REPLACEMENTS_BUTTONS_NUMBER_+6]"..
                    "@B[7,@L_REPLACEMENTS_BUTTONS_NUMBER_+7]"..
                    "@B[8,@L_REPLACEMENTS_BUTTONS_NUMBER_+8]"..
                    "@B[9,@L_REPLACEMENTS_BUTTONS_NUMBER_+9]"..
                    "@B[9999,@L_MEASURE_CHANGEGAMESETTINGS_NOLIMIT]",
                    "@L_MEASURE_CHANGEGAMESETTINGS_NAME_+0",
                    "@L_MEASURE_CHANGEGAMESETTINGS_BODY_+0",
                    0)
            if Result ~= C then
                Allowedchanges = Result
                break
            end
        end
    end
    
    if not firsttime then
        Allowedchanges = Allowedchanges - 1 -- reduce the allowed amount  
    end
    if Allowedchanges < -1 then
        Allowedchanges = 0
    end
    SetProperty("World","ChangeSettingsNumber",Allowedchanges)
    
    if Allowedchanges == 0 then
        -- set for all party sims, so the measure does not appear again
        local GlobalSimCount = ScenarioGetObjects("cl_Sim", -1, "Sims")
        for i = 0, GlobalSimCount-1 do
            GetDynasty("Sims"..i,"Dyn")
            if IsPartyMember("Sims"..i) and DynastyIsPlayer("Dyn") then
                homeexist = GetInsideBuilding("Sims"..i,"Home")
                if homeexist then
                    SetProperty("Home","ChangeSettingsBlock",1) -- is checked in the filter dbt
                end
                GetHomeBuilding("Sims"..i,"Home")
                SetProperty("Home","ChangeSettingsBlock",1)
            end           
        end
    end
    
end	

function CleanUp()
end
