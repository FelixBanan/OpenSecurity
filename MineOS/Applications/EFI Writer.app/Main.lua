
local GUI = require("GUI")
local system = require("System")
local io = require("filesystem")
local component = require("component")

---------------------------------------------------------------------------------

local currentScriptDirectory = io.path(system.getCurrentScript())
local localization = system.getLocalization(currentScriptDirectory .. "Localizations/")

local workspace, window, menu = system.addWindow(GUI.titledWindow(1, 1, 60, 20, "EFI CardWriter", true))

--local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 60, 20, 0xF0F0F0))
--layout:addChild(GUI.text(1, 1, 0x4B4B4B, "EFI CardWriter"))

local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))

layout:setMargin(1, 1, 0, -1)
---------------------------------------------------------------------------------


local name = layout:addChild(GUI.input(1, 1, 36, 3, 0xFFFFFF, 0x444444, 0xAAAAAA, 0xFFFFFF, 0x2D2D2D, "", localization.eepromname))

local filesystemChooser = layout:addChild(GUI.filesystemChooser(1, 1, 36, 3, 0xE1E1E1, 0x696969, 0xD2D2D2, 0xA5A5A5, nil, localization.open, localization.close, localization.choose, "/"))

local flash = layout:addChild(GUI.roundedButton(1, 1, 36, 3, 0xE1E1E1, 0x696969, 0x696969, 0xE1E1E1, localization.flash))

layout:addChild(GUI.textBox(1, 1, 36, 1, nil, 0xA5A5A5, {localization.description}, 1, 0, 0, true, true))

flash.onTouch = function()

  if component.isAvailable("OSCardWriter") then
    local writer = component.OSCardWriter

    if FB_flashFile ~= nil then
      writer.flash(FB_flashFile, name.text, false)
      GUI.alert(localization.flashed)
    else
      GUI.alert(localization.texterror)
    end

  elseif component.isAvailable("os_cardwriter") then
    local writer = component.os_cardwriter

    if FB_flashFile ~= nil then
      writer.flash(FB_flashFile, name.text, false)
      GUI.alert(localization.flashed)
    else
      GUI.alert(localization.texterror)
    end

  end

end

filesystemChooser.onSubmit = function(path)
	local file = io.open(path, "r")
	FB_flashFile = file:read("*a")
end

window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  window.titlePanel.width, window.titleLabel.width = newWidth, newWidth
  layout.width, layout.height = newWidth, newHeight
end

---------------------------------------------------------------------------------

workspace:draw()

if component.isAvailable("OSCardWriter") then
  local check = nil
elseif component.isAvailable("os_cardwriter") then
  local check = nil
else
  name.disabled = true
  filesystemChooser.disabled = true
  flash.disabled = true
  GUI.alert(localization.BlockConnectCardWrite);
end