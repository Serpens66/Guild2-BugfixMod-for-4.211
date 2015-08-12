function Run()
	if not GetState("", STATE_FIGHTING) then
		GetOutdoorMovePosition("","destination","MovePos")
		f_MoveTo("","MovePos",GL_MOVESPEED_RUN)
	
	Sleep(100000)
	end
end
