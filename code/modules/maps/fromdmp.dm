/*
	DMP to swapmap converter
	version 1.0

	by Lummox JR
 */

mob/verb/Convert(filename as file)
	dmp2swapmap(filename)

proc/d2sm_prepmap(filename)
	var/txt = file2text(filename)
	if(!txt) return
	var/i,j
	i=findText(txt,ascii2text(13))	// eliminate carriage returns
	while(i)
		txt=copytext_char(txt,1,i)+copytext_char(txt,i+1)
		i=findText(txt,ascii2text(13),i)
	i=findText(txt,"\\\n")
	while(i)
		for(j=i+2,j<=length(txt),++j) if(text2ascii(txt,j)>32) break
		txt=copytext_char(txt,1,i)+copytext_char(txt,j)
		i=findText(txt,"\\\n",i)
	return txt

proc/dmp2swapmap(filename)
	//var/txt = file2text(filename)
	//if(!txt) return
	var/txt = d2sm_prepmap(filename)
	var/mapname="[filename]"
	var/i,j,k
	i=findtext_char(mapname,".dmp")
	while(i && i+4<length(mapname)) i=findtext_char(mapname,".dmp",i+1)
	mapname=copytext_char(mapname,1,i)
	/* i=findText(txt,ascii2text(13))
	while(i)
		txt=copytext_char(txt,1,i)+copytext_char(txt,i+1)
		i=findText(txt,ascii2text(13),i)
	i=findText(txt,"\\\n")
	while(i)
		for(j=i+2,j<=length(txt),++j) if(text2ascii(txt,j)>32) break
		txt=copytext_char(txt,1,i)+copytext_char(txt,j)
		i=findText(txt,"\\\n",i) */
	var/list/codes=new
	var/codelen=1
	var/list/areas
	var/mode=34
	var/z=0
	var/X=0,Y=0,Z=0
	while(txt)
		if(text2ascii(txt)==34)
			if(mode!=34)
				to_world("Corrupt map file [filename]: Unexpected code found after z-level [z]")
				return
			// standard line:
			// "a" = (/obj, /obj, /turf, /area)
			i=findtext_char(txt,"\"",2)
			var/code=copytext_char(txt,2,i)
			codelen=length(code)
			i=findtext_char(txt,"(",i)
			if(!i)
				to_world("Corrupt map file [filename]: No type list follows \"[code]\"")
				return
			k=findtext_char(txt,"\n",++i)
			j=(k || length(txt+1))
			while(--j>=i && text2ascii(txt,j)!=41)
			if(j<i)
				to_world("Corrupt map file [filename]: Type list following \"[code]\" is incomplete")
				return
			var/list/L = d2sm_ParseCommaList(copytext_char(txt,i,j))
			if(istext(L))
				to_world("Corrupt map file [filename]: [L]")
				return
			if(L.len<2)
				to_world("Corrupt map file [filename]: Type list following \"[code]\" has only 1 item")
				return
			txt=k?copytext_char(txt,k+1):null
			if(L[L.len] == "[world.area]") L[L.len]=0
			else
				if(!areas) areas=list()
				i=areas.Find(L[L.len])
				if(i) L[L.len]=i
				else
					areas+=L[L.len]
					L[L.len]=areas.len
			var/codetrans=d2sm_ConvertType(L[L.len-1],"\t\t\t\t")
			if(L[L.len]) codetrans+="\t\t\t\tAREA = [L[L.len]]\n"
			if(L.len>2) codetrans+=d2sm_Contents(L,L.len-2,"\t\t\t\t")
			codes[code]=copytext_char(codetrans,1,length(codetrans))
		else if(text2ascii(txt)==40)
			mode=40
			// standard line (top-down, left-right symbol order):
			// (1,1,1) = {"
			// abcde
			// bcdef
			// "}
			i=d2sm_MatchBrace(txt,1,40)
			if(!i)
				to_world("Corrupt map file [filename]: No matching ) for coordinates: [copytext_char(txt,1,findtext_char(txt,"\n"))]")
				return
			var/list/coords=d2sm_ParseCommaList(copytext_char(txt,2,i))
			if(istext(coords) || coords.len!=3)
				to_world("Corrupt map file [filename]: [istext(coords)?(coords):"[copytext_char(txt,1,i+1)] is not a valid (x,y,z) coordinate"]")
				return
			j=findtext_char(txt,"{",i+1)
			if(!j)
				to_world("Corrupt map file [filename]: No braces {} following [copytext_char(txt,1,i+1)]")
				return
			k=d2sm_MatchBrace(txt,j,123)
			if(!k)
				to_world("Corrupt map file [filename]: No closing brace } following [copytext_char(txt,1,i+1)]")
				return
			var/mtxt=copytext_char(txt,j+1,k)
			if(findText(mtxt,"\"\n")!=1 || !findText(mtxt,"\n\"",length(mtxt)-1))
				to_world(findText(mtxt,"\"\n"))
				to_world(findText(mtxt,"\n\"",length(mtxt)-1))
				to_world("Corrupt map file [filename]: No quotes in braces following [copytext_char(txt,1,i+1)]")
				return
			mtxt=copytext_char(mtxt,2,length(mtxt))
			var/_x=0,_y=0
			for(i=1,,++_y)
				j=findText(mtxt,"\n",i+1)
				if(!j) break
				_x=max(_x,(j-i-1)/codelen)
				i=j
			X=max(X,_x)
			Y=max(Y,_y)
			z=text2num(coords[3])
			Z=max(Z,z)
			txt=copytext_char(txt,k+1)
		else
			i=findtext_char(txt,"\n")
			txt=i?copytext_char(txt,i+1):null
	to_world("Map size: [X],[Y],[Z]")
	fdel("map_[mapname].txt")
	var/F = file("map_[mapname].txt")
	to_chat(F, ". = object(\".0\")\n.0\n\ttype = /swapmap\n\tid = \"[mapname]\"\n\tz = [Z]\n\ty = [Y]\n\tx = [X]")
	if(areas)
		txt=""
		for(i=0,i<areas.len,++i)
			txt+="[i?", ":""]object(\".[i]\")"
		to_chat(F, "\tareas = list([txt])")
		for(i=0,i<areas.len,++i)
			to_chat(F, "\t\t.[i]")
			txt=d2sm_ConvertType(areas[i+1],"\t\t\t")
			to_chat(F, copytext_char(txt,1,length(txt)))

	// 2nd pass
	txt=d2sm_prepmap(filename)
	while(txt)
		// skip all non-data sections
		if(text2ascii(txt)!=40)
			i=findText(txt,"\n")
			if(i) txt=copytext_char(txt,i+1)
			else txt=null
			continue
		i=d2sm_MatchBrace(txt,1,40)
		var/list/coords=d2sm_ParseCommaList(copytext_char(txt,2,i))
		j=findtext_char(txt,"{",i+1)
		k=d2sm_MatchBrace(txt,j,123)
		var/mtxt=copytext_char(txt,j+2,k-1)
		var/_x=0,_y=0
		for(i=1,,++_y)
			j=findText(mtxt,"\n",i+1)
			if(!j) break
			_x=max(_x,(j-i-1)/codelen)
			i=j
		// print out this z-level now
		to_chat(F, "\t[coords[3]]")
		i=1
		for(var/y=_y,y>0,--y)	// map is top-down
			++i
			to_chat(F, "\t\t[y]")
			for(var/x in 1 to _x)
				to_chat(F, "\t\t\t[x]")
				j=i+codelen
				to_chat(F, codes[copytext_char(mtxt,i,j)])
				i=j
		txt=copytext_char(txt,k+1)
	/* for(z in 1 to Z)
		to_chat(F, "\t[z]")
		for(var/y in 1 to Y)
			to_chat(F, "\t\t[y]")
			for(var/x in 1 to X)
				to_chat(F, "\t\t\t[x]")
				to_chat(F, codes[pick(codes)] */

proc/d2sm_ParseCommaList(txt)
	var/list/L=new
	var/i,ch
	for(i=1,i<=length(txt),++i)
		if(text2ascii(txt,i)>32) break
	for(,i<=length(txt),++i)
		ch=text2ascii(txt,i)
		if(ch==44)
			L+=copytext_char(txt,1,i)
			for(++i,i<=length(txt),++i) if(text2ascii(txt,i)>32) break
			txt=copytext_char(txt,i)
			i=0;continue
		if(ch==40 || ch==91 || ch==123)
			i=d2sm_MatchBrace(txt,i,ch)
			if(!i) return "No matching brace found for [ascii2text(ch)]"
	if(i>1) L+=copytext_char(txt,1,i)
	return L

proc/d2sm_MatchBrace(txt, i, which)
	if(which==40) ++which
	else which+=2
	var/j,ch
	for(j=i+1,j<=length(txt),++j)
		ch=text2ascii(txt,j)
		if(ch==which) return j
		if(ch==40 || ch==91 || ch==123)
			j=d2sm_MatchBrace(txt,j,ch)
			if(!j) return 0

proc/d2sm_ConvertType(tt,tabs="")
	var/i=findText(tt,"{")
	if(!i) return "[tabs]type = [tt]\n"
	.="[tabs]type = [copytext_char(tt,1,i)]\n"
	var/list/L=d2sm_ParseCommaList(copytext_char(tt,i+1,d2sm_MatchBrace(tt,i,123)))
	if(istext(L)) return
	for(var/pair in L)
		.="[.][tabs][pair]\n"

proc/d2sm_Contents(list/conts,n,tabs="")
	.="[tabs]contents = list("
	var/i
	for(i=0,i<n,++i)
		.+="[i?", ":""]object(\".[i]\")"
	.+=")\n"
	tabs+="\t"
	for(i=0,i<n,++i)
		.+="[tabs].[i]\n"
		.+=d2sm_ConvertType(conts[i+1],tabs+"\t")
