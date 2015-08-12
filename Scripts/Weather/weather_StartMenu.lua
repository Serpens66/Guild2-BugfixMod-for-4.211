function Init()
	Weather_SetParticles(0.0)
	Weather_SetLight(0.5)
	Weather_SetWind(0.7)
	Weather_SetCloudFactor(0.8)
end

function Run()	
	Sleep(Rand(40)+40)
end

function Cleanup()
end
