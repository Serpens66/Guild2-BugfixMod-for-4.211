function Init()
end

function Run()

  while true do
		local CurrentTime = math.mod(GetGametime(),24)

		if (CurrentTime > 0 and CurrentTime < 6) then
			state_nebel_nebelstart()
		end
		Sleep(5)
  end
end   

function nebelstart()

	GfxAttachObject("ParticleDust", "particles/hpfz_nebel.nif")
	--GfxSetPosition("ParticleDust",0,-400,0,false)
    GfxScale("ParticleDust", 3)
    local CurrentTime = math.mod(GetGametime(),24)

    while (CurrentTime > 0 and CurrentTime < 6) do
       Sleep(5)
       CurrentTime = math.mod(GetGametime(),24)
    end
    GfxScale("ParticleDust", 3)
    Sleep(3)
    GfxScale("ParticleDust", 2)
    Sleep(3)
    GfxScale("ParticleDust", 1)
    Sleep(3)
    GfxScale("ParticleDust", 0)
    Sleep(3)
    GfxDetachObject("ParticleDust")

end
