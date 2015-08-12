function Init()

end

function Run()
	while GetImpactValue("","littledrunk")>0 do
		Sleep(Rand(2)+5)
	end
end

function CleanUp()
	MoveSetActivity("","")
end

