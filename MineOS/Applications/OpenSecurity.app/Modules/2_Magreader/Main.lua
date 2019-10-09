
local GUI = require("GUI")
local paths = require("Paths")
local system = require("System")
local FBAPI = require("FBAPI")
local filesystem = require("filesystem")
local settings = filesystem.readTable(paths.user.applicationData .. "OpenSecurity/settings.cfg")

local module = {}

local workspace, window, localization = table.unpack({...})

--------------------------------------------------------------------------------

module.name = localization.magreader
module.margin = 0
module.onTouch = function()

  window.contentLayout:addChild(GUI.text(1, 1, 0x2D2D2D, localization.magreaderinfo))

  local password = window.contentLayout:addChild(GUI.input(1, 1, 30, 3, 0xFFFFFF, 0x444444, 0xAAAAAA, 0xFFFFFF, 0x2D2D2D, "", localization.cardpassword))

  local timer = window.contentLayout:addChild(GUI.slider(1, 1, 30, 0x66DB80, 0xE1E1E1, 0xFFFFFF, 0xA5A5A5, 0, 120, 0, true, localization.time, localization.seconds))

  local redstoneside = window.contentLayout:addChild(GUI.slider(1, 1, 30, 0x66DB80, 0xE1E1E1, 0xFFFFFF, 0xA5A5A5, 0, 5, 0, true, localization.side))
  redstoneside.roundValues = true

  local button = window.contentLayout:addChild(GUI.roundedButton(1, 1, 36, 3, 0xE1E1E1, 0x696969, 0x696969, 0xE1E1E1, localization.startread))

  window.contentLayout:addChild(GUI.textBox(1, 1, 36, 1, nil, 0xA5A5A5, {localization.RedstoneSideInfo .." ".. localization.EnterToExit}, 1, 0, 0, true, true))

  local function disableForm()
    password.disabled = true
    timer.disabled = true
    redstoneside.disabled = true
    button.disabled = true
  end

  if component.isAvailable("OSMAGReader") then
    local check = nil
  elseif component.isAvailable("os_magreader") then
    local check = nil
  else
    disableForm()
    GUI.alert(localization.BlockConnectMagReader);
  end

  if settings["redstone"] == true then
    if component.isAvailable("redstone") then
      local check = nil
    else
      disableForm()
      GUI.alert(localization.BlockConnectRedstone);
    end
  end

  if settings["doorcontroller"] == true then
    if component.isAvailable("os_doorcontroller") then
      local check = nil
    else
      disableForm()
      GUI.alert(localization.BlockConnectDoorController);
    end
  end

  if settings["rolldoorcontroller"] == true then
    if component.isAvailable("os_rolldoorcontroller") then
      local check = nil
    else
      disableForm()
      GUI.alert(localization.BlockConnectRolldoorController);
    end
  end

  button.onTouch = function()

    local result = FBAPI.magread(password.text, redstoneside.value, timer.value, settings)

    if result == "settings" then
      GUI.alert(localization.SettingsError)
    end
  end

end

--------------------------------------------------------------------------------

return module

