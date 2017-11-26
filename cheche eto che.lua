
-- 0 - низ, 1 - верх, 2 - зад, 3 - перед, 4 - право, 5 - лево
local whoSide = "1"

local buffer = require("doubleBuffering")
local component = require("component")
local redstone = component.redstone
local event = require("event")
local gpu = component.gpu
local GUI = require("GUI")

  local mainContainer = GUI.fullScreenContainer()
  mainContainer:addChild(GUI.panel(1, 1, mainContainer.width, mainContainer.height, 0x2D2D2D, 0.4))
  local layout = mainContainer:addChild(GUI.layout(1, 1, mainContainer.width, mainContainer.height, 5, 1))

local function drawShell()
local sW, sH = gpu.getResolution()
  gpu.setResolution(sW, sH)
  gpu.setForeground(0xFFFFFF)
  gpu.fill(1,1,sW,sH," ")
  gpu.setBackground(0x1E1E1E)
  gpu.fill(1,1,sW,sH," ")
end


if component.isAvailable("os_cardwriter") then
  writer = component.os_cardwriter
  


  ------------------------------------------------------------------------------------------

  layout:setCellPosition(3, 1, layout:addChild(GUI.input(1, 1, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "Название карточки", "Placeholder text"))).onInputFinished = function(mainContainer, input, eventData, text)
  login = text
end

layout:setCellPosition(3, 1, layout:addChild(GUI.input(1, 1, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "Пароль", "Placeholder text"))).onInputFinished = function(mainContainer, input, eventData, text)
password = text
end

local comboBox = layout:setCellPosition(3, 1, layout:addChild(GUI.comboBox(1, 1, 30, 3, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888)))
comboBox:addItem("Заблокировать перезапись").onTouch = function()
lock = "true"
end
comboBox:addItem("Не блокировать перезапись").onTouch = function()
lock = "false"
end

layout:setCellPosition(3, 1, layout:addChild(GUI.button(1, 1, 30, 3, 0xFFFFFF, 0x555555, 0xAAAAAA, 0x2D2D2D, "Записать"))).onTouch = function()
if login and password then
if lock == "true" then
success = writer.write(password, login, true)
elseif lock == "false" then
success = writer.write(password, login, false)
end
else
GUI.error("Вы не ввели данные.")
end
if success then
GUI.error("Успешно!")
else
GUI.error("Вы не вставили карту.")
end
end

layout:setCellPosition(3, 1, layout:addChild(GUI.button(1, 1, 30, 3, 0xFFFFFF, 0x555555, 0xAAAAAA, 0x2D2D2D, "Выход"))).onTouch = function()
drawShell()
mainContainer:stopEventHandling()
end

------------------------------------------------------------------------------------------



elseif component.isAvailable("OSCardWriter") then
writer = component.OSCardWriter
else
print("Подключите CardWriter к компьютеру.")
os.exit()
end



  

----------------------------------------------------------------------------------------------RFID
layout:setCellPosition(2, 1, layout:addChild(GUI.input(1, 1, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "Пароль", "Placeholder text"))).onInputFinished = function(mainContainer, input, eventData, text)
password2 = text
end

layout:setCellPosition(2, 1, layout:addChild(GUI.input(1, 1, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "Радиус поиска", "Placeholder text"))).onInputFinished = function(mainContainer, input, eventData, text)
range = text
range = tonumber(range)
end

local side = tonumber(whoSide)

local reader = component.os_rfidreader
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

layout:setCellPosition(2, 1, layout:addChild(GUI.button(1, 1, 30, 3, 0xFFFFFF, 0x555555, 0xAAAAAA, 0x2D2D2D, "Включить RFIDSearch"))).onTouch = function()


  reads()


end


----------------------------------------------------------------------------------------------
  
  
----------------------------------------------------------------------------------------------Mag

layout:setCellPosition(4, 1, layout:addChild(GUI.input(1, 1, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "Пароль", "Placeholder text"))).onInputFinished = function(mainContainer, input, eventData, text)
password3 = text
end


local function mag()
  while true do
    local output = { event.pull() }
    if output[1] == "magData" then
      if output[4] == password3 then
        redstone.setOutput(side, 15)
      else
        os.sleep(2)
      end
      redstone.setOutput(side, 0)
    elseif output[1] == "key_down" and output[4] == 28 then
      break
    end
  end
end


layout:setCellPosition(4, 1, layout:addChild(GUI.button(1, 1, 30, 3, 0xFFFFFF, 0x555555, 0xAAAAAA, 0x2D2D2D, "Включить MagReader"))).onTouch = function()
  mag()
end

----------------------------------------------------------------------------------------------


 
mainContainer:draw()
buffer.draw(true)
mainContainer:startEventHandling()