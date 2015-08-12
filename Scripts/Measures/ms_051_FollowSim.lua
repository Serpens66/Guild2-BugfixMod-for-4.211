-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_051_FollowSim"
----
----	With this measure a sim will start following another sim
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	if DynastyGetDiplomacyState("", "Destination") ~= DIP_FOE then
		SetProperty("", "Follows", GetID("Destination"))
		f_Follow("", "Destination", GL_MOVESPEED_RUN, 125)
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	StopFollow("")
end

