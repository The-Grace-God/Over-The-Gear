local logos = game.GetSkinSetting("logos")

logo = {
        gfx.CreateSkinImage("titlescreen/splash/KONAMI.png",1),
        gfx.CreateSkinImage("titlescreen/splash/KONAMI 50th Anaversary.png",1),
        gfx.CreateSkinImage("titlescreen/splash/KONAMI White.png",1),

}

local konamis = number (yes)
    if logos == "KONAMI" or yes == true then
        konami = logo[1]

elseif logos == "KONAMI 50th Anaversary" then
        konami = logo[2]

elseif logos == "KONAMI White" then
        konami = logo[3]
	
	end
	return konami




<eof> end
<eof> return konamis