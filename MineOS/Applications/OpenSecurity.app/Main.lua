

local component = require("component")
local computer = require("computer")
local image = require("image")
local GUI = require("GUI")
local system = require("System")
local fs = require("filesystem")
local unicode = require("unicode")
local paths = require("paths")
----------------------------------------------------------------------------------------------------------------

local resourcesPath = paths.user.applications .. "OpenSecurity.app"
local modulesPath = resourcesPath .. "Modules/"

local mainContainer, window = system.addWindow(GUI.tabbedWindow(1, 1, 90, 30))

----------------------------------------------------------------------------------------------------------------

window.contentContainer = window:addChild(GUI.container(1, 4, window.width, window.height - 3))

local function loadModules()
  local fileList = fs.sortedList(modulesPath, "name", false)
  for i = 1, #fileList do
    local success, reason = loadfile(modulesPath .. fileList[i])
    if success then
      local success, reason = pcall(success, mainContainer, window, localization)
      if success then
        window.tabBar:addItem(reason.name).onTouch = function()
        reason.onTouch()
      end
    else
      error("Failed to call loaded module \"" .. tostring(fileList[i]) .. "\": " .. tostring(reason))
    end
  else
    error("Failed to load module \"" .. tostring(fileList[i]) .. "\": " .. tostring(reason))
  end
end
end

window.onResize = function(width, height)
window.tabBar.width = width
window.backgroundPanel.width = width
window.backgroundPanel.height = height - 3
window.contentContainer.width = width
window.contentContainer.height = window.backgroundPanel.height

window.tabBar:getItem(window.tabBar.selectedItem).onTouch()
end

local overrideOnTouch = window.actionButtons.close.onTouch --Выкидываем все переменные
window.actionButtons.close.onTouch = function()
password2 = nil
password = nil
range = nil
side = nil
red = nil
mag = nil
writercheck = nil
readercheck = nil
writer = nil
magcheck = nil
reader = nil
check = nil
overrideOnTouch()
end

----------------------------------------------------------------------------------------------------------------

loadModules()
window.onResize(90, 30)


