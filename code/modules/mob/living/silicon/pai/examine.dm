/mob/living/silicon/pai/examine(mob/user)
	..(user, infix = ", personal AI")

	var/msg = ""
	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)	msg += "\nIt appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)		msg += "\n<span class='warning'>It doesn't seem to be responding.</span>"
		if(DEAD)			msg += "\n<span class='deadsay'>It looks completely unsalvageable.</span>"
	msg += "\n*---------*"

	if(print_flavor_text()) msg += "\n[print_flavor_text()]\n"

	if (pose)
		if( findtext_char(pose,".",length_char(pose)) == 0 && findtext_char(pose,"!",length_char(pose)) == 0 && findtext_char(pose,"?",length_char(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\nIt [pose]"

	to_chat(user, msg)
