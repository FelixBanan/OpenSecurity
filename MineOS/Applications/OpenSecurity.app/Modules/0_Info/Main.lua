
local GUI = require("GUI")
local paths = require("Paths")
local system = require("System")
local filesystem = require("filesystem")
local FBAPI = require("FBAPI")

local module = {}

local workspace, window, localization = table.unpack({...})
local userSettings = system.getUserSettings()

--------------------------------------------------------------------------------

module.name = localization.infoname
module.margin = 0
module.onTouch = function()

	local settings = filesystem.readTable(paths.user.applicationData .. "OpenSecurity/settings.cfg")

    window.contentLayout:addChild(GUI.text(1, 1, 0x2D2D2D, "OpenSecurity"))

    window.contentLayout:addChild(GUI.text(1, 1, 0x2D2D2D, localization.OutputTo))
    local redstone = window.contentLayout:addChild(GUI.switchAndLabel(1, 1, 27, 8, 0x66DB80, 0xE1E1E1, 0xFFFFFF, 0xA5A5A5, localization.RedstoneController, settings["redstone"])).switch
    local doorcontroller = window.contentLayout:addChild(GUI.switchAndLabel(1, 1, 27, 8, 0x66DB80, 0xE1E1E1, 0xFFFFFF, 0xA5A5A5, localization.DoorController, settings["doorcontroller"])).switch
    local rolldoorcontroller = window.contentLayout:addChild(GUI.switchAndLabel(1, 1, 27, 8, 0x66DB80, 0xE1E1E1, 0xFFFFFF, 0xA5A5A5, localization.RollDoorContoller, settings["rolldoorcontroller"])).switch

    redstone.onStateChanged = function(state)
		settings["redstone"] = redstone.state
		filesystem.writeTable(paths.user.applicationData .. "OpenSecurity/settings.cfg", settings)
	end

    doorcontroller.onStateChanged = function(state)
		settings["doorcontroller"] = doorcontroller.state
		filesystem.writeTable(paths.user.applicationData .. "OpenSecurity/settings.cfg", settings)
	end

    rolldoorcontroller.onStateChanged = function(state)
		settings["rolldoorcontroller"] = rolldoorcontroller.state
		filesystem.writeTable(paths.user.applicationData .. "OpenSecurity/settings.cfg", settings)
	end

end


--------------------------------------------------------------------------------

return module

