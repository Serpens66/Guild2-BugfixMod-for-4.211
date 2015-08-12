function Init()
end

function Run()

  while true do
		local CurrentTime = math.mod(GetGametime(),24)

		if (CurrentTime > 10 and CurrentTime < 17) then
			state_hpfz_springbrunnen_spbrunnenstart()
		end
		Sleep(5)
  end
end   

function spbrunnenstart()

	GfxAttachObject("Fontaene", "particles/kielwater.nif")
	GfxSetPosition("Fontaene",0,200,0,false)
    local CurrentTime = math.mod(GetGametime(),24)

    while (CurrentTime > 10 and CurrentTime < 17) do
       Sleep(5)
       CurrentTime = math.mod(GetGametime(),24)
    end
    GfxDetachObject("Fontaene", "particles/kielwater.nif")

end
