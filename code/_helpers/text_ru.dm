/proc/sanitize_ru(var/input)
	var/ind
	while((ind  = findtext(input, "я")))
		input = copytext_char(input, 1, ind) + "&#255;" + copytext_char(input, ind + 1)
		ind = findtext(input, "я")
	return input

/proc/rhtml_encode(var/msg, var/html = 0)
        var/rep
        if(html)
                rep = "&#x44F;"
        else
                rep = "&#255;"
        var/list/c = text2list(msg, "я")
        if(c.len == 1)
                c = text2list(msg, rep)
                if(c.len == 1)
                        return html_encode(msg)
        var/out = ""
        var/first = 1
        for(var/text in c)
                if(!first)
                        out += rep
                first = 0
                out += html_encode(text)
        return out

/proc/rhtml_decode(var/msg, var/html = 0)
        var/rep
        if(html)
                rep = "&#x44F;"
        else
                rep = "&#255;"
        var/list/c = text2list(msg, "я")
        if(c.len == 1)
                c = text2list(msg, "&#255;")
                if(c.len == 1)
                        c = text2list(msg, "&#x4FF")
                        if(c.len == 1)
                                return html_decode(msg)
        var/out = ""
        var/first = 1
        for(var/text in c)
                if(!first)
                        out += rep
                first = 0
                out += html_decode(text)
