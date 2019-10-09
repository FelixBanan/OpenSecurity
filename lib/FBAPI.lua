local FBAPI = {}

function FBAPI.rfidcheck()

  local component = require("component")

  if component.isAvailable("OSRFIDReader") then
    return "OSRFIDReader"
  elseif component.isAvailable("os_rfidreader") then
    return "os_rfidreader"
  else
    return false
  end

end

function FBAPI.redstonecheck()
  local component = require("component")

  if component.isAvailable("redstone") then
    return true
  else
    return false
  end

end

function FBAPI.rfidread(password, range, side, settings)

  if password ~= "" and range and side then

    local component = require("component")

    if component.isAvailable("OSRFIDReader") then
      local reader = component.OSRFIDReader
      FBAPI.rfidwhile(reader, password, range, side, settings)
    elseif component.isAvailable("os_rfidreader") then
      local reader = component.os_rfidreader
      FBAPI.rfidwhile(reader, password, range, side, settings)
    else
      return "block"
    end

  else
    return "settings"
  end

end

function FBAPI.rfidwhile(reader, password, range, side, settings)

  local event = require("event")
  local component = require("component")
  
  while true do
    local eventType, _, _, key_code = event.pull(0)
    if eventType == "key_down" and key_code == 28 then
      if settings["redstone"] == true and component.isAvailable("redstone") then
        component.redstone.setOutput(side, 0)
      end
      if settings["doorcontroller"] == true and component.isAvailable("os_doorcontroller") then
        component.os_doorcontroller.close()
      end
      if settings["rolldoorcontroller"] == true and component.isAvailable("os_rolldoorcontroller") then
        component.os_rolldoorcontroller.close()
      end
      break
    else
      local player = reader.scan()[1]
      if player and player.data == password and player.range <= range then
        if settings["redstone"] == true and component.isAvailable("redstone") then
          component.redstone.setOutput(side, 15)
        end
        if settings["doorcontroller"] == true and component.isAvailable("os_doorcontroller") then
          component.os_doorcontroller.open()
        end
        if settings["rolldoorcontroller"] == true and component.isAvailable("os_rolldoorcontroller") then
          component.os_rolldoorcontroller.open()
        end
      else
        if settings["redstone"] == true and component.isAvailable("redstone") then
          component.redstone.setOutput(side, 0)
        end
        if settings["doorcontroller"] == true and component.isAvailable("os_doorcontroller") then
          component.os_doorcontroller.close()
        end
        if settings["rolldoorcontroller"] == true and component.isAvailable("os_rolldoorcontroller") then
          component.os_rolldoorcontroller.close()
        end
      end
    end
  end

end

function FBAPI.cardwrite(name, password, block)

  if name ~= "" and password ~= "" then

    local component = require("component")

    if component.isAvailable("OSCardWriter") then

      local writer = component.OSCardWriter
      local success = writer.write(password, name, block)
      return "success"

    elseif component.isAvailable("os_cardwriter") then

      local writer = component.os_cardwriter
      local success = writer.write(password, name, block)
      return "success"

    else
      return "block"
    end

  else
    return "settings"
  end

end

function FBAPI.magread(password, side, sec, settings)

  if password ~= "" and side and sec then

    local component = require("component")
    local event = require("event")

    while true do
      local output = { event.pull() }
      if output[1] == "magData" then
        if output[4] == password then

          if settings["redstone"] == true and component.isAvailable("redstone") then
            component.redstone.setOutput(side, 15)
          end
          if settings["doorcontroller"] == true and component.isAvailable("os_doorcontroller") then
            component.os_doorcontroller.toggle()
          end
          if settings["rolldoorcontroller"] == true and component.isAvailable("os_rolldoorcontroller") then
            component.os_rolldoorcontroller.toggle()
          end

          event.sleep(sec)

        else
          event.sleep(sec)
        end

          if settings["redstone"] == true and component.isAvailable("redstone") then
            component.redstone.setOutput(side, 0)
          end
          if settings["doorcontroller"] == true and component.isAvailable("os_doorcontroller") then
            component.os_doorcontroller.close()
          end
          if settings["rolldoorcontroller"] == true and component.isAvailable("os_rolldoorcontroller") then
            component.os_rolldoorcontroller.close()
          end

      elseif output[1] == "key_down" and output[4] == 28 then
        break
      end
    end

  else
    return "settings"
  end

end

return FBAPI
