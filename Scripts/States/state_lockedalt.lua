-------------------------------------------------------------------------------
----
----	OVERVIEW "state_lockedalt"
----
----	With this measure the player can lock a sim.
----	It is similar to state_locked but does not stop the measure.
----
-------------------------------------------------------------------------------

-- -----------------------
-- init
-- -----------------------
function Init()
	SetStateImpact("no_hire")
	SetStateImpact("no_control")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_start")
	SetStateImpact("no_measure_attach")
end

-- -----------------------
-- Run
-- -----------------------
function Run()
	while true do
		Sleep(100)
	end
end

