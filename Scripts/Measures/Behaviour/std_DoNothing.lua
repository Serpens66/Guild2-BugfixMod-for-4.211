function Run()

	local DoNothing = GetProperty("", "_DO_NOTHING_TIME")
	if not DoNothing then
		Sleep(5)
		return
	end

	RemoveProperty("", "_DO_NOTHING_TIME")
	if DoNothing==0 then
		DoNothing = 0.5
	end
	DoNothing = Gametime2Realtime(DoNothing)
	Sleep(DoNothing)
end

