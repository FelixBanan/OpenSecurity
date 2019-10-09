
local GUI = require("GUI")
local system = require("System")
local FBAPI = require("FBAPI")

local module = {}

local workspace, window, localization = table.unpack({...})
local userSettings = system.getUserSettings()

--------------------------------------------------------------------------------

module.name = localization.cardwriter
module.margin = -2
module.onTouch = function()

    window.contentLayout:addChild(GUI.text(1, 1, 0x2D2D2D, localization.cardwriterinfo))

    local name = window.contentLayout:addChild(GUI.input(1, 1, 30, 3, 0xFFFFFF, 0x444444, 0xAAAAAA, 0xFFFFFF, 0x2D2D2D, "", localization.cardname))

    local password = window.contentLayout:addChild(GUI.input(1, 1, 30, 3, 0xFFFFFF, 0x444444, 0xAAAAAA, 0xFFFFFF, 0x2D2D2D, "", localization.cardpassword))

    local block = window.contentLayout:addChild(GUI.switchAndLabel(1, 1, 25, 8, 0x66DB80, 0xE1E1E1, 0xFFFFFF, 0xA5A5A5, localization.block, false)).switch

    local button = window.contentLayout:addChild(GUI.roundedButton(1, 1, 36, 3, 0xE1E1E1, 0x696969, 0x696969, 0xE1E1E1, localization.write))

    if component.isAvailable("OSCardWriter") then
        local check = nil
    elseif component.isAvailable("os_cardwriter") then
        local check = nil
    else
        name.disabled = true
        password.disabled = true
        block.disabled = true
        button.disabled = true
        GUI.alert(localization.BlockConnectCardWrite);
    end

    button.onTouch = function()

        local result = FBAPI.cardwrite(name.text, password.text, block.state)

        if result == "success" then
        	GUI.alert(localization.success)
        elseif result == "CardAndOrSettings" then
        	GUI.alert(localization.CardAndOrSettings)
        elseif result == "block" then
        	GUI.alert(localization.BlockConnectCardWrite)
        elseif result == "settings" then
        	GUI.alert(localization.SettingsError)
        end

    end

end

--------------------------------------------------------------------------------

return module

