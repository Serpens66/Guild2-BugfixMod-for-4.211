-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_031_GetCured"
----
----	with this measure, the player can cure his robbers
----
-------------------------------------------------------------------------------

function Run()
	local duration = 3
	local CurrentHP = GetHP("")
	local MaxHP = GetMaxHP("")
	local ToHeal = MaxHP - CurrentHP
	local HealPerTic = ToHeal / (duration * 12)
	local UseLocator = false

    SimGetWorkingPlace("","APlatz")
	f_MoveTo("","APlatz",GL_MOVESPEED_RUN,100)
	
	local CurrentTime = GetGametime()
	local EndTime = CurrentTime + duration
	local Time = MoveSetStance("",GL_STANCE_SITGROUND)
	Sleep(Time)
	while GetGametime()<EndTime do
		Sleep(5)
		if GetHP("") < MaxHP then
			ModifyHP("", HealPerTic,false)
		end

	end
	Time = MoveSetStance("",GL_STANCE_STAND)
	Sleep(Time)
end

function CleanUp()
	
end
