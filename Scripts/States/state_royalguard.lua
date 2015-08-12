function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_hire")
	SetStateImpact("no_fire")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_action")
end

function Run()
	PlayAnimation("", "propel")
end

function CleanUp()
end

