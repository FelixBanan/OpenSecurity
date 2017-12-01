local FBAPI = {}

function FBAPI.clearGlobal()
reader = nil
readercheck = nil
writer = nil
writercheck = nil
mag = nil
magcheck = nil
checkresult = nil
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

    if readercheck == true then
	 readercheck = nil
     checkresult = true
    elseif readercheck == false then
	 readercheck = nil
     checkresult = false
    end

end

function FBAPI.rfidread(password, range, side)
FBAPI.clearGlobal()
local GUI = require("GUI")
if password and range and side then
FBAPI.rfidcheck()
local redstone = require("component").redstone
local event = require("event")

if checkresult == true then
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

    if writercheck == true then
	 writercheck = nil
     checkresult = true
    elseif writercheck == false then
	 writercheck = nil
     checkresult = false
end

end

function FBAPI.cardread(name, password, lock)
FBAPI.clearGlobal()
local GUI = require("GUI")
if name and password and lock then
FBAPI.cardcheck()

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

    if magcheck == true then
      checkresult = true
	  magcheck = nil
    elseif magcheck == false then
	  magcheck = nil
      checkresult = false
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



return FBAPI