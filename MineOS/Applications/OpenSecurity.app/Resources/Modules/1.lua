
local args = {...}
local mainContainer, window = args[1], args[2]

require("advancedLua")
local component = require("component")
local GUI = require("GUI")
local buffer = require("doubleBuffering")
local MineOSInterface = require("MineOSInterface")
local redstone = component.redstone
local event = require("event")
----------------------------------------------------------------------------------------------------------------

local module = {}
module.name = "RFID Reader"


local function checkPidor()


    if component.isAvailable("OSRFIDReader") then
    reader = component.OSRFIDReader
    readercheck = "zaebis"
    elseif component.isAvailable("os_rfidreader") then
    reader = component.os_rfidreader
    readercheck = "zaebis"
    else
    readercheck = "nezaebis"
    end

    if readercheck == "zaebis" then
     check = "zaebis"
    elseif readercheck == "nezaebis" then
     check = "pizdec"
    end

end


----------------------------------------------------------------------------------------------------------------

module.onTouch = function()
window.contentContainer:deleteChildren()
checkPidor()
if check == "zaebis" then

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

local function reads()
while true do
local eventType, _, _, key_code = event.pull(0)
if eventType == "key_down" and key_code == 28 then
  break
else
  local player = reader.scan()[1]
  if player and player.data == password2 and player.range <= range then
    redstone.setOutput(side, 15)
  else
    redstone.setOutput(side, 0)
  end
end
end
end

layout:setCellPosition(2, 1, layout:addChild(GUI.roundedButton(2, 6, 30, 3, 0xBBBBBB, 0xFFFFFF, 0x999999, 0xFFFFFF, "Включить RFIDSearch"))).onTouch = function()
if password2 and range then
reads()
else
GUI.error("Вы не ввели пароль или(и) радиус")
end
end
elseif check == "pizdec" then
GUI.error("Вы не подключили RfidReader.")
end

end

----------------------------------------------------------------------------------------------------------------

return module