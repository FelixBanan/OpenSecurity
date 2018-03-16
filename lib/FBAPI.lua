local FBAPI = {}

function FBAPI.clearGlobal()
reader = nil
readercheck = nil
writer = nil
writercheck = nil
mag = nil
magcheck = nil
checkresult = nil
entity = nil
entitycheck = nil
scan = nil
side = nil
end

function FBAPI.rfidcheck()
FBAPI.clearGlobal()
local component = require("component")
    if component.isAvailable("OSRFIDReader") then
    reader = component.OSRFIDReader
    readercheck = true
    elseif component.isAvailable("os_rfidreader") then
    reader = component.os_rfidreader
    readercheck = true
    else
    readercheck = false
    end
end

function FBAPI.rfidread(password, range, side)
FBAPI.clearGlobal()
local GUI = require("GUI")
if password and range and side then
FBAPI.rfidcheck()
local redstone = require("component").redstone
local event = require("event")

if readercheck == true then
while true do
local eventType, _, _, key_code = event.pull(0)
if eventType == "key_down" and key_code == 28 then
  break
else
  local player = reader.scan()[1]
  if player and player.data == password and player.range <= range then
    redstone.setOutput(side, 15)
  else
    redstone.setOutput(side, 0)
  end
end
end
else
GUI.error("Вы не подключили блок.")
end
else
GUI.error("Вы не ввели данные.")
end
end

function FBAPI.cardcheck()
FBAPI.clearGlobal()
local component = require("component")

if component.isAvailable("os_cardwriter") then
     writer = component.os_cardwriter
     writercheck = true
    elseif component.isAvailable("OSCardWriter") then
     writer = component.OSCardWriter
     writercheck = true
    else
     writercheck = false
    end
end



function FBAPI.cardread(name, password, lock)
FBAPI.clearGlobal()
local GUI = require("GUI")
if name and password then
FBAPI.cardcheck()
if writercheck == true then
if lock == true then
success = writer.write(password, name, true)
elseif lock == false then
success = writer.write(password, name, false)
else
success = writer.write(password, name, false)
end


if success then
GUI.error("Успешно!")
else
GUI.error("Вы не вставили карту или(и) не ввели данные.")
end
else
GUI.error("Вы не подключили блок.")
end
else
GUI.error("Вы не ввели данные.")
end
end
function FBAPI.magcheck()
FBAPI.clearGlobal()
local component = require("component")
    if component.isAvailable("OSMAGReader") then
      magcheck = true
    elseif component.isAvailable("os_magreader") then
      magcheck = true
    else
      magcheck = false
    end
end

function FBAPI.magread(password, side, sec)
FBAPI.clearGlobal()
local GUI = require("GUI")
if password and side and sec then
FBAPI.magcheck()
local event = require("event")
local redstone = require("component").redstone
  while true do
    local output = { event.pull() }
    if output[1] == "magData" then
      if output[4] == password then
        redstone.setOutput(side, 15)
        os.sleep(sec)
      else
        os.sleep(sec)
      end
      redstone.setOutput(side, 0)
    elseif output[1] == "key_down" and output[4] == 28 then
      break
    end
  end
else
GUI.error("Вы не ввели данные.")
end
end

function FBAPI.entitycheck()
local component = require("component")
if component.isAvailable("os_entdetector") then
     entity = component.os_entdetector
     entitycheck = true
    elseif component.isAvailable("OSEntDetector") then
     entity = component.OSEntDetector
     entitycheck = true
    else
     entitycheck = false
    end
end



function FBAPI.entitydetect()
FBAPI.clearGlobal()
FBAPI.entitycheck()
local GUI = require("GUI")


scan = entity.scanPlayers(10)
for l,player in pairs(scan) do
GUI.error(player.name)
GUI.error(player.range)
local resourcesPath = MineOSCore.getCurrentApplicationResourcesDirectory()
file = io.open(resourcesPath .. "entitydetector.txt", w)
file:write(playerName)
file:close()
end

end


return FBAPI
