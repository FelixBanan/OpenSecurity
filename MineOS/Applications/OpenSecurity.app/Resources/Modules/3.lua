
local args = {...}
local mainContainer, window = args[1], args[2]

require("advancedLua")
local GUI = require("GUI")
local buffer = require("doubleBuffering")
local MineOSInterface = require("MineOSInterface")
local component = require("component")
local redstone = component.redstone
local event = require("event")
----------------------------------------------------------------------------------------------------------------

local module = {}
module.name = "Mag Reader"


local function checkPidor()


    if component.isAvailable("OSMAGReader") then
      magcheck = "zaebis"
    elseif component.isAvailable("os_magreader") then
      magcheck = "zaebis"
    else
      magcheck = "nezaebis"
    end

    if magcheck == "zaebis" then
      check = "zaebis"
    elseif magcheck == "nezaebis" then
      check = "pizdec"
    end

end


----------------------------------------------------------------------------------------------------------------

local function mag()
  while true do
    local output = { event.pull() }
    if output[1] == "magData" then
      if output[4] == password then
        redstone.setOutput(side, 15)
        os.sleep(red)
      else
        os.sleep(red)
      end
      redstone.setOutput(side, 0)
    elseif output[1] == "key_down" and output[4] == 28 then
      break
    end
  end
end

module.onTouch = function()
window.contentContainer:deleteChildren()
checkPidor()
if check == "zaebis" then
  local container = window.contentContainer:addChild(GUI.container(1, 1, window.contentContainer.width, window.contentContainer.height))

  local layout = container:addChild(GUI.layout(1, 1, container.width, window.contentContainer.height, 3, 1))
  layout:setCellPosition(2, 1, layout:addChild(GUI.input(1, 1, 30, 3, 0xFFFFFF, 0x444444, 0xAAAAAA, 0xFFFFFF, 0x2D2D2D, "", "Пароль для карточки"))).onInputFinished = function(mainContainer, input, eventData, text)
  password = text
end

layout:setCellPosition(2, 1, layout:addChild(GUI.input(1, 1, 30, 3, 0xFFFFFF, 0x444444, 0xAAAAAA, 0xFFFFFF, 0x2D2D2D, "", "(Sec) Действия редстоуна"))).onInputFinished = function(mainContainer, input, eventData, text)
red = tonumber(text)
end

layout:setCellPosition(2, 1, layout:addChild(GUI.input(1, 1, 30, 3, 0xFFFFFF, 0x444444, 0xAAAAAA, 0xFFFFFF, 0x2D2D2D, "", "Сторона вывода редстоуна"))).onInputFinished = function(mainContainer, input, eventData, text)
side = tonumber(text)
end
layout:setCellPosition(2, 1, layout:addChild(GUI.roundedButton(2, 6, 30, 3, 0xBBBBBB, 0xFFFFFF, 0x999999, 0xFFFFFF, "Включить MagReader"))).onTouch = function()
if password and red and side then
mag()
else
GUI.error("Вы не ввели данные")
end
end

layout:setCellPosition(2, 1, layout:addChild(GUI.label(30, 1, 30, 3, 0x00, "Enter для выключения программы.")))
elseif check == "pizdec" then
GUI.error("Вы не подключили MagReader.")
end
end

----------------------------------------------------------------------------------------------------------------

return module