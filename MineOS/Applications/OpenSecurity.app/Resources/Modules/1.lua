
local args = {...}
local mainContainer, window = args[1], args[2]

require("advancedLua")
local component = require("component")
local GUI = require("GUI")
local buffer = require("doubleBuffering")
local MineOSInterface = require("MineOSInterface")
local redstone = component.redstone
local event = require("event")
local resourcesPath = MineOSCore.getCurrentApplicationResourcesDirectory()
local FBAPI = require("FBAPI")
----------------------------------------------------------------------------------------------------------------

local module = {}
module.name = "RFID Reader"
----------------------------------------------------------------------------------------------------------------

module.onTouch = function()
window.contentContainer:deleteChildren()
FBAPI.rfidcheck()
if checkresult == true then
FBAPI.clearGlobal()
  local container = window.contentContainer:addChild(GUI.container(1, 1, window.contentContainer.width, window.contentContainer.height))
  local layout = container:addChild(GUI.layout(1, 1, container.width, window.contentContainer.height, 3, 1))

  layout:setCellPosition(2, 1, layout:addChild(GUI.input(1, 1, 30, 3, 0xFFFFFF, 0x444444, 0xAAAAAA, 0xFFFFFF, 0x2D2D2D, "", "Пароль для карточки", true))).onInputFinished = function(mainContainer, input, eventData, text)
  password2 = text
end

layout:setCellPosition(2, 1, layout:addChild(GUI.input(1, 1, 30, 3, 0xFFFFFF, 0x444444, 0xAAAAAA, 0xFFFFFF, 0x2D2D2D, "", "Радиус поиска карточки"))).onInputFinished = function(mainContainer, input, eventData, text)
range = tonumber(text)
end


layout:setCellPosition(2, 1, layout:addChild(GUI.input(1, 1, 30, 3, 0xFFFFFF, 0x444444, 0xAAAAAA, 0xFFFFFF, 0x2D2D2D, "", "Сторона вывода редстоуна"))).onInputFinished = function(mainContainer, input, eventData, text)
side = tonumber(text)
end

layout:setCellPosition(2, 1, layout:addChild(GUI.label(30, 1, 30, 3, 0x00, "Enter для выключения программы.")))

layout:setCellPosition(2, 1, layout:addChild(GUI.roundedButton(2, 6, 30, 3, 0xBBBBBB, 0xFFFFFF, 0x999999, 0xFFFFFF, "Включить RFIDSearch"))).onTouch = function()
FBAPI.rfidread(password2, range, side)
end
elseif checkresult == false then
FBAPI.clearGlobal()
GUI.error("Вы не подключили RfidReader.")
end

end

----------------------------------------------------------------------------------------------------------------

return module