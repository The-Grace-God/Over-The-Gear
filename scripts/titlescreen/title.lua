local Dim = require("common.dimensions")
local Easing = require("common.easing")
local Wallpaper = require("components.wallpaper")
local Common = require("common.util")
local triggerskips = false

local splash1aBgColor = {0, 0, 0}
local splash1aLogo = gfx.CreateSkinImage("titlescreen/title/background.png", 0)
local splash1aLogoWidth, splash1aLogoHeight = gfx.ImageSize(splash1aLogo)

local splash2aBgColor = {255, 255, 255}
local splash2aLogo = gfx.CreateSkinImage("titlescreen/title/background.png", 0)
local splash2aLogoWidth, splash2aLogoHeight = gfx.ImageSize(splash2aLogo)

local spalshaState = "init"
local spalshaTimer = 0
local fadeDuration = 0.5
local fadeAlpha = 0
local spalshaInitDuration = 1
local splash1aDuration = 10
local splash2aDuration = 0.1

local triggerSkips = false

local function calcFade(splashDuration)
    local t = splashDuration - spalshaTimer
    if t < fadeDuration then
        fadeAlpha = Easing.linear(t, 0, 255, fadeDuration) -- fade in
    elseif spalshaTimer < fadeDuration then
        fadeAlpha = Easing.linear(spalshaTimer, 0, 255, fadeDuration) -- fade out
    else
        --fadeAlpha = 255
    end
    fadeAlpha = Common.round(Common.clamp(fadeAlpha, 0, 255))
end

local function initSplash(deltaTime)
    if (spalshaTimer < 0) then
        spalshaState = "splash1a"
        spalshaTimer = 0
        return
    end

    if spalshaTimer == 0 then
        spalshaTimer = spalshaInitDuration
    end

    spalshaTimer = spalshaTimer - deltaTime
end

local function reset()
    triggerSkips = false
    spalshaState = "init"
    splashaTimer = 0
end

local function splash1a(deltaTime)
    local splash1aLogoXOffset = (Dim.design.width - splash1aLogoWidth) / 2
    local splash1aLogoYOffset = (Dim.design.height - splash1aLogoHeight) / 2

    calcFade(splash1aDuration)

    gfx.BeginPath()
    gfx.Rect(0, 0, Dim.design.width, Dim.design.height)
    gfx.FillColor(splash1aBgColor[1], splash1aBgColor[2], splash1aBgColor[3], fadeAlpha)
    gfx.Fill()

    gfx.BeginPath()
    gfx.ImageRect(splash1aLogoXOffset, splash1aLogoYOffset, splash1aLogoWidth, splash1aLogoHeight, splash1aLogo, fadeAlpha / 255, 0)

    gfx.BeginPath()
    gfx.LoadSkinFont("segoeui.ttf")
    gfx.FillColor(255, 255, 255, fadeAlpha)
    gfx.TextAlign(gfx.TEXT_ALIGN_LEFT + gfx.TEXT_ALIGN_BOTTOM)
    gfx.FontSize(28)

    gfx.Text("", 10, Dim.design.height - 10)

    if (spalshaTimer < 0) then
        spalshaState = "splash2a"
        spalshaTimer = 0
        return
    end

    if spalshaTimer == 0 then
        spalshaTimer = splash1aDuration
    end

    spalshaTimer = spalshaTimer - deltaTime
end

local function splash2a(deltaTime)
    local splash2aLogoXOffset = (Dim.design.width - splash2aLogoWidth) / 2
    local splash2aLogoYOffset = (Dim.design.height - splash2aLogoHeight) / 2

    calcFade(splash2aDuration)

    gfx.BeginPath()
    gfx.Rect(0, 0, Dim.design.width, Dim.design.height)
    gfx.FillColor(splash2aBgColor[1], splash2aBgColor[2], splash2aBgColor[3], fadeAlpha)
    gfx.Fill()

    gfx.BeginPath()
    gfx.ImageRect(splash2aLogoXOffset, splash2aLogoYOffset, splash2aLogoWidth, splash2aLogoHeight, splash2aLogo, fadeAlpha / 255, 0)

    gfx.BeginPath()
    gfx.LoadSkinFont("segoeui.ttf")
    gfx.FillColor(182, 0, 20, fadeAlpha)
    gfx.TextAlign(gfx.TEXT_ALIGN_LEFT + gfx.TEXT_ALIGN_BOTTOM)
    gfx.FontSize(28)

    gfx.Text("", 10, Dim.design.height - 10)

    if (spalshaTimer < 0) then
        spalshaState = "done"
        spalshaTimer = 0
        return
    end

    if spalshaTimer == 0 then
        spalshaTimer = splash2aDuration
    end
    
end

function render(deltaTime)
	
	if (triggerModeSelect) then
        triggerModeSelect = false
        return {
            eventType = 'switch',
            toScreen = 'mode_select'
        }
    end


    Dim.updateResolution()

    Wallpaper.render()

    Dim.transformToScreenSpace()

    gfx.BeginPath()
    gfx.Rect(0, 0, Dim.design.width, Dim.design.height)
    gfx.FillColor(255, 255, 255)
    gfx.Fill()

    if spalshaState == "init" then
        initSplash(deltaTime)
    elseif spalshaState == "splash1a" then
        splash1a(deltaTime)
    elseif spalshaState == "splash2a" then
        splash2a(deltaTime)
		reset()
        return {
            eventType = "switch",
            toScreen = "splash"
        }
    else
        game.Log("Splash screen state error, spalshaState: " .. spalshaState, game.LOGGER_ERROR)
        spalshaState = "done"
    end
end

local function onButtonPressed(button)
    if button == game.BUTTON_FXR and game.GetButton(game.BUTTON_FXL) and
        button == game.BUTTON_FXL and game.GetButton(game.BUTTON_FXR) then
        triggerServiceMenu = true
    end

    if button == game.BUTTON_STA then
        triggerModeSelect = true
    end
	
end

return {
    render = render,
    onButtonPressed = onButtonPressed
}