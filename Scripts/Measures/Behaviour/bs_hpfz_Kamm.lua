function Run()
	if SimGetOfficeID("") > 0 then
		chr_ModifyFavor("","Actor",5)
		if IsPartyMember("")  then
			MsgNewsNoWait("","Actor","","intrigue",-1,
					"@L_HPFZ_ARTEFAKT_KAMM_OPFER_KOPF_+0",
					"@L_HPFZ_ARTEFAKT_KAMM_OPFER_RUMPF_+0",GetID("Actor"))
		end
	else
	  return ""
  end
end

