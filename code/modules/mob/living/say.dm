var/list/department_radio_keys = list(
	  ":r" = "right ear",	".r" = "right ear",
	  ":l" = "left ear",	".l" = "left ear",
	  ":i" = "intercom",	".i" = "intercom",
	  ":h" = "department",	".h" = "department",
	  ":+" = "special",		".+" = "special", //activate radio-specific special functions
	  ":c" = "Command",		".c" = "Command",
	  ":n" = "Science",		".n" = "Science",
	  ":m" = "Medical",		".m" = "Medical",
	  ":e" = "Engineering", ".e" = "Engineering",
	  ":s" = "Security",	".s" = "Security",
	  ":w" = "whisper",		".w" = "whisper",
	  ":t" = "Mercenary",	".t" = "Mercenary",
	  ":x" = "Raider",		".x" = "Raider",
	  ":u" = "Supply",		".u" = "Supply",
	  ":v" = "Service",		".v" = "Service",
	  ":p" = "AI Private",	".p" = "AI Private",
	  ":z" = "Entertainment",".z" = "Entertainment",

	  ":R" = "right ear",	".R" = "right ear",
	  ":L" = "left ear",	".L" = "left ear",
	  ":I" = "intercom",	".I" = "intercom",
	  ":H" = "department",	".H" = "department",
	  ":C" = "Command",		".C" = "Command",
	  ":N" = "Science",		".N" = "Science",
	  ":M" = "Medical",		".M" = "Medical",
	  ":E" = "Engineering",	".E" = "Engineering",
	  ":S" = "Security",	".S" = "Security",
	  ":W" = "whisper",		".W" = "whisper",
	  ":T" = "Mercenary",	".T" = "Mercenary",
	  ":X" = "Raider",		".X" = "Raider",
	  ":U" = "Supply",		".U" = "Supply",
	  ":V" = "Service",		".V" = "Service",
	  ":P" = "AI Private",	".P" = "AI Private",
	  ":Z" = "Entertainment",".Z" = "Entertainment",

	  //kinda localization -- rastaf0
	  //same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	  ":к" = "right ear",	".к" = "right ear",
	  ":д" = "left ear",	".д" = "left ear",
	  ":ш" = "intercom",	".ш" = "intercom",
	  ":р" = "department",	".р" = "department",
	  ":с" = "Command",		".с" = "Command",
	  ":т" = "Science",		".т" = "Science",
	  ":ь" = "Medical",		".ь" = "Medical",
	  ":у" = "Engineering",	".у" = "Engineering",
	  ":ы" = "Security",	".ы" = "Security",
	  ":ц" = "whisper",		".ц" = "whisper",
	  ":е" = "Mercenary",	".е" = "Mercenary",
	  ":ч" = "Raider",		".ч" = "Raider",
	  ":г" = "Supply",		".г" = "Supply",
	  ":м" = "Service",		".м" = "Service",
	  ":з" = "AI Private",	".з" = "AI Private",
	  ":я" = "Entertainment",".я" = "Entertainment"
)


var/list/channel_to_radio_key = new
proc/get_radio_key_from_channel(var/channel)
	var/key = channel_to_radio_key[channel]
	if(!key)
		for(var/radio_key in department_radio_keys)
			if(department_radio_keys[radio_key] == channel)
				key = radio_key
				break
		if(!key)
			key = ""
		channel_to_radio_key[channel] = key

	return key

/mob/living/proc/binarycheck()

	if (istype(src, /mob/living/silicon/pai))
		return

	if (!ishuman(src))
		return

	var/mob/living/carbon/human/H = src
	if (H.l_ear || H.r_ear)
		var/obj/item/device/radio/headset/dongle
		if(istype(H.l_ear,/obj/item/device/radio/headset))
			dongle = H.l_ear
		else
			dongle = H.r_ear
		if(!istype(dongle)) return
		if(dongle.translate_binary) return 1

/mob/living/proc/get_stuttered_message(message)
	return stutter(message, stuttering)

/mob/living/proc/get_default_language()
	return default_language

/mob/living/proc/is_muzzled()
	return 0

/mob/living/proc/handle_speech_problems(var/message, var/verb, var/message_mode)
	var/list/returns[4]
	var/speech_problem_flag = 0
	if((HULK in mutations) && health >= 25 && length(message))
		message = "[uppertext(message)]!!!"
		verb = pick("yells","roars","hollers")
		speech_problem_flag = 1
	if(slurring)
		message = slur(message,slurring)
		verb = pick("slobbers","slurs")
		speech_problem_flag = 1
	if(stuttering)
		message = get_stuttered_message(message)
		verb = pick("stammers","stutters")
		speech_problem_flag = 1
	if(tarded)
		message = slur(message,100)
		verb = pick("gibbers","gabbers")
		speech_problem_flag = 1
	if(brokejaw)
		message = slur(message,100)
		verb = pick("slobbers","slurs")
		speech_problem_flag = 1
		if(prob(50))
			to_chat(src, "<span class='danger'>You struggle to speak with your dislocated jaw!</span>")
		if(prob(10))
			to_chat(src, "<span class='danger'>You feel a sharp pain from your jaw as you speak!</span>")
			src.Weaken(3)
	returns[1] = message
	returns[2] = verb
	returns[3] = speech_problem_flag
	returns[4] = world.view
	return returns

/mob/living/proc/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	if(message_mode == "intercom")
		for(var/obj/item/device/radio/intercom/I in view(1, null))
			I.talk_into(src, message, verb, speaking)
			used_radios += I
	return 0

/mob/living/proc/handle_speech_sound()
	var/list/returns[3]
	returns[1] = null
	returns[2] = null
	returns[3] = FALSE
	return returns

/mob/living/proc/get_speech_ending(verb, var/ending)
	if(ending=="!")
		return pick("exclaims","shouts","yells")
	if(ending=="?")
		return "asks"
	return verb

/mob/living/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="")
	if(stat)
		if(stat == DEAD)
			return say_dead(message)
		return

	var/message_mode = parse_message_mode(message, "headset")

	var/regex/emote = regex("^(\[\\*^\])\[^*\]+$")

	if(emote.Find(message))
		if(emote.group[1] == "*") return emote(copytext_char(message, 2))
		if(emote.group[1] == "^") return custom_emote(1, copytext_char(message,2))

	//parse the radio code and consume it
	if (message_mode)
		if (message_mode == "headset")
			message = copytext_char(message,2)	//it would be really nice if the parse procs could do this for us.
		else
			message = copytext_char(message,3)

	message = trim_left(message)

	var/static/list/correct_punctuation = list("!" = TRUE, "." = TRUE, "?" = TRUE, "-" = TRUE, "~" = TRUE, "*" = TRUE, "/" = TRUE, ">" = TRUE, "\"" = TRUE, "'" = TRUE, "," = TRUE, ":" = TRUE, ";" = TRUE)
	var/ending = copytext_char(message, length(message), (length(message) + 1))
	if(ending && !correct_punctuation[ending] && !(HULK in mutations))
		message += "."

	//parse the language code and consume it
	if(!speaking)
		speaking = parse_language(message)
	if(speaking)
		message = copytext_char(message,2+length(speaking.key))
	else
		speaking = get_default_language()

	// This is broadcast to all mobs with the language,
	// irrespective of distance or anything else.
	if(speaking && (speaking.flags & HIVEMIND))
		speaking.broadcast(src,trim(message))
		return 1

	verb = say_quote(message, speaking)

	if(is_muzzled())
		to_chat(src, "<span class='danger'>You're muzzled and cannot speak!</span>")
		return

	message = trim_left(message)
	var/message_range
	if(!(speaking && (speaking.flags & NO_STUTTER)))
		message = handle_autohiss(message, speaking)

		var/list/handle_s = handle_speech_problems(message, verb, message_mode)
		message = handle_s[1]
		verb = handle_s[2]
		message_range = handle_s[4]

	if(!message || message == "")
		return 0

	message = process_chat_markup(message, list("~", "_"))

	//handle nonverbal and sign languages here
	if (speaking)
		if (speaking.flags & NONVERBAL)
			if (prob(30))
				src.custom_emote(1, "[pick(speaking.signlang_verb)].")

		if (speaking.flags & SIGNLANG)
			return say_signlang(message, pick(speaking.signlang_verb), speaking)

	var/list/obj/item/used_radios = new
	if(handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name))
		return 1

	var/list/handle_v = handle_speech_sound()
	var/sound/speech_sound = handle_v[1]
	var/sound_vol = handle_v[2]
	var/italics = handle_v[3]



	//speaking into radios
	if(used_radios.len)
		italics = 1
		message_range = 1
		if(speaking)
			message_range = speaking.get_talkinto_msg_range(message)
		var/msg
		if(!speaking || !(speaking.flags & NO_TALK_MSG))
			msg = "<span class='notice'>\The [src] talks into \the [used_radios[1]]</span>"
		for(var/mob/living/M in hearers(5, src))
			if((M != src) && msg)
				M.show_message(msg)
			if (speech_sound)
				sound_vol *= 0.5

	var/list/listening = list()
	var/list/listening_obj = list()
	var/turf/T = get_turf(src)

	if(T)
		//make sure the air can transmit speech - speaker's side
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment)? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE)
			message_range = 1

		if (pressure < ONE_ATMOSPHERE*0.4) //sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
			italics = 1
			sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

		get_mobs_and_objs_in_view_fast(T, message_range, listening, listening_obj)


	var/list/hear_clients = list()
	for(var/m in listening)
		var/mob/M = m
		M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol)
		if (M.client)
			hear_clients += M.client

	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h[speech_bubble_test]")
	INVOKE_ASYNC(GLOBAL_PROC, /proc/animate_speechbubble, speech_bubble, hear_clients, 30)

	for(var/o in listening_obj)
		var/obj/O = o
		spawn(0)
			if(O) //It's possible that it could be deleted in the meantime.
				O.hear_talk(src, message, verb, speaking)

	log_say("[key_name(src)] : ([get_lang_name(speaking)]) [message]",ckey=key_name(src))
	return 1

/proc/animate_speechbubble(image/I, list/show_to, duration)
	var/matrix/M = matrix()
	M.Scale(0,0)
	I.transform = M
	I.alpha = 0
	for(var/client/C in show_to)
		C.images += I
	animate(I, transform = 0, alpha = 255, time = 5, easing = ELASTIC_EASING)
	sleep(duration-5)
	animate(I, alpha = 0, time = 5, easing = EASE_IN)
	sleep(5)
	for(var/client/C in show_to)
		C.images -= I

/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/datum/language/language)
	log_say("[key_name(src)] : ([get_lang_name(language)]) [message]",ckey=key_name(src))

	for (var/mob/O in viewers(src, null))
		O.hear_signlang(message, verb, language, src)
	return 1

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name
