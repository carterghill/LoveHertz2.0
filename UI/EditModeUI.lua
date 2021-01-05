require("UI/UIGroup")
require "gooi"

EditModeUI = {
  display = true,
  elements = {},
  delete = false,
  tool = "move",
  selected = {},
  tools = {},
  tileButton,
  clickTime = 0
}

deleteButton = {}
zoomSlider = {}

--- toggle
-- Turns Edit Mode on or off
function EditModeUI:toggle()
  if self.display then
    love.mouse.setVisible(false)
    self.display = false
    if love.system.getOS() == "Android" or PlayerUI.touch then
       PlayerUI.display = true
       gooi.setGroupEnabled("player", true)
    end
    gooi.setGroupEnabled("edit_mode", false)
  else
    love.mouse.setVisible(true)
    self.display = true
    self.delete = false
    PlayerUI.display = false
    gooi.setGroupEnabled("edit_mode", true)
    gooi.setGroupEnabled("player", false)
  end
end

--- add
-- Inserts an element into the list of edit mode elements
-- @param e - The element
function EditModeUI:add(e)
  self.elements[#self.elements+1] = e
end

--- overIt
-- Tells you whether or not your mouse is over an EditModeUI element
-- @param x - The mouse's x position
-- @param y - The mouse's y position
-- @return true if on element, else false
function EditModeUI:overIt(x, y)
  local x = x or love.mouse.getX()
  local y = y or love.mouse.getY()
  for i=1, #self.elements do
    if self.elements[i]:overIt(x, y) then
      return true
    end
  end
  return false
end

--- empty
-- Remove every element from edit mode
function EditModeUI:empty()
  for i=1, #self.elements do
    gooi.removeComponent(self.elements[i])
  end
  for i=1, #tileButtons do
    gooi.removeComponent(tileButtons[i])
  end
  tileButtons = {}
  self.elements = {}
end

--- reset
-- Reinitialized the EditModeUI, usually for rescaling purposes
function EditModeUI:reset()
    self:empty()
    self:load()
end

function EditModeUI:load()

  local s = globalScale
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()

  imgDir = "/images/"
  fontDir = "/fonts/"
  style = {
      font = love.graphics.newFont(fontDir.."Arimo-Bold.ttf", 24*s),
      showBorder = true,
      bgColor = {50, 50, 50, 175},
      fgColor = {250, 250, 250, 250},
      borderColor = {0, 0, 0, 250},
      borderStyle = "rough"
  }
  gooi.setStyle(style)
  gooi.desktopMode()

  --gooi.shadow()
  gooi.mode3d()
  --gooi.glass()

  -----------------------------------------------
  -----------------------------------------------
  -- Menu and Zoom
  -----------------------------------------------
  -----------------------------------------------

  pauseBtn = gooi.newButton({text = "Pause", x = w-296*s, y = 16*s, w = 280*s, h = 64*s})
      --:setIcon(imgDir.."coin.png")
      ----:setTooltip("Save the current level")
      :onRelease(function()
          PauseUI:pause()
      end)
  pauseBtn:setGroup("pause_button")
  EditModeUI:add(pauseBtn)

  zoomSlider = gooi.newSlider({
    value = 0.5,
    x = w-296*s,
    y = 88*s,
    w = 280*s,
    h = 44*s,
    group = "grp1"
  })
  zoomSlider:setGroup("edit_mode")
  EditModeUI:add(zoomSlider)

  --c()
  --[[

    TILES AND TYPE SELECTION

  ]]

  deleteButton = gooi.newButton({text = "", x = 16*s, y = 360*s, w = 80*s, h = 80*s})
      :onRelease(function ()
          EditModeUI.tool = "delete"
          self.selected = deleteButton
          removeTileButtons()
          love.mouse.setVisible(true)
          love.mouse.setCursor(love.mouse.getSystemCursor("no"))
          --love.mouse.setCursor(love.mouse.newCursor("images/eraser.png"))
      end)

  deleteButton:setGroup("edit_mode")
  deleteButton:setBGImage("images/eraser.png")
  EditModeUI:add(deleteButton)

  ----------------------
  -- MOVE SCREEN BUTTON
  ----------------------

  moveScrn = gooi.newButton({text = "", x = 16*s, y = 16*s, w = 80*s, h = 80*s})
      :setBGImage(love.graphics.newImage("images/moveIcon.png"))
      :onRelease(function ()
        self.tool = 'move'
        self.selected = moveScrn
        c = love.mouse.getSystemCursor("sizeall")
        love.mouse.setCursor(c)
        love.mouse.setVisible(true)
        removeTileButtons()
      end)
  mv = love.graphics.newImage("images/moveIcon.png")
  mv:setFilter("nearest", "nearest")
  moveScrn:setGroup("edit_mode")
  --moveScrn:setBGImage(mv)
  EditModeUI:add(moveScrn)
  self.selected = moveScrn

  tileButtons = {}

  ----------------------
  -- TILES BUTTON
  ----------------------

  tiles = gooi.newButton({text = "", x = 16*s, y = 102*s, w = 80*s, h = 80*s})
      --:setIcon(imgDir.."coin.png")
      :setBGImage("images/tileIcon.png")
      :onRelease(function()
        Placeables.index = 1
        for i=1, #tileButtons do
          gooi.removeComponent(tileButtons[i])
        end
        self.tool = "place"
        self.selected = tiles
        love.mouse.setVisible(false)
        tileButtons = {}
        Placeables.currentSet = "tiles"
        for i=1, #Placeables.tiles do
          local num = #tileButtons+1
          tileButtons[num] = gooi.newButton({text = "", x = 16*s + (i-1)*86, y = h-96*s, w = 80*s, h = 80*s})
              --:setIcon(imgDir.."coin.png")
              --:setTooltip("previous in the list")
              :onRelease(function()
                Placeables.index = i
                self.tileButton = tileButtons[num]
              end)
          tileButtons[num]:setGroup("edit_mode")

          if Placeables.tiles[i] ~= nil then
            local tile = Placeables.tiles[i]
            local img = tile.images[1]
            if img == nil then
              img = tile.defaultImage
            end
            x = x - img:getWidth()/2
            y = y - img:getHeight()/2
            tileButtons[num]:setBGImage(tile.images[1])
          end
          Placeables.index = Placeables.index + 1
        end
        self.tileButton = tileButtons[1]
        Placeables.index = 1
    end)

  Placeables.index = 1

  ----------------------
  -- ENEMIES BUTTON
  ----------------------

  enemies = gooi.newButton({text = "", x = 16*s, y = 188*s, w = 80*s, h = 80*s})

      :onRelease(function()
        Placeables.index = 1
        for i=1, #tileButtons do
          gooi.removeComponent(tileButtons[i])
        end
        self.tool = "place"
        self.selected = enemies
        love.mouse.setVisible(false)
        tileButtons = {}
        Placeables.currentSet = "enemies"
        for i=1, #Placeables.enemies do
          local num = #tileButtons+1
          tileButtons[num] = gooi.newButton({text = "", x = 16*s + (i-1)*86, y = h-96*s, w = 80*s, h = 80*s})
              --:setIcon(imgDir.."coin.png")
              --:setTooltip("previous in the list")
              :onRelease(function()
                Placeables.index = i
                self.tileButton = tileButtons[num]
              end)
          tileButtons[num]:setGroup("edit_mode")
          if Placeables:getTile() ~= nil then
            local tile = Placeables:getTile()
            local img = tile.defaultImage
            tileButtons[num]:setBGImage(img)
          end
          Placeables.index = Placeables.index + 1
        end
        self.tileButton = tileButtons[1]
        Placeables.index = 1
      end)
  enemies:setGroup("edit_mode")
  enemies:setBGImage("images/enemyIcon.png")
  tiles:setGroup("edit_mode")
  EditModeUI:add(enemies)
  EditModeUI:add(tiles)

  ----------------------
  -- DECORATIVE BUTTON
  ----------------------

  decorative = gooi.newButton({text = "", x = 16*s, y = 274*s, w = 80*s, h = 80*s})
      :onRelease(function()
        Placeables.index = 1
        for i=1, #tileButtons do
          gooi.removeComponent(tileButtons[i])
        end
        self.tool = "place"
        self.selected = decorative
        love.mouse.setVisible(false)
        tileButtons = {}
        Placeables.currentSet = "decorative"
        local images = loadImagesInFolder("images/decorative")
        for i=1, #images do
          tileButtons[i] = gooi.newButton({text = "", x = 16*s + (i-1)*86, y = h-96*s, w = 80*s, h = 80*s})
              :onRelease(function()
                Placeables.index = i
                self.tileButton = tileButtons[i]
              end)
          tileButtons[i]:setGroup("edit_mode")
          tileButtons[i]:setBGImage(images[i])
          Placeables.index = Placeables.index + 1
        end
        self.tileButton = tileButtons[1]
        Placeables.index = 1
      end)
  decorative:setGroup("edit_mode")
  decorative:setBGImage("images/decorativeIcon.png")
  EditModeUI:add(decorative)

  table.insert(EditModeUI.tools, moveScrn)
  table.insert(EditModeUI.tools, tiles)
  table.insert(EditModeUI.tools, enemies)
  table.insert(EditModeUI.tools, decorative)
  table.insert(EditModeUI.tools, deleteButton)

  return EditModeUI

end

function EditModeUI:draw()

  if self.display and not PauseUI.paused then
    gooi.draw("edit_mode")
    gooi.draw("pause_button")
    love.graphics.setColor(255, 255, 255, 40)
    love.graphics.rectangle("fill", self.selected.x+2, self.selected.y+2, self.selected.w-4, self.selected.h-4)
    if self.tileButton then
      love.graphics.rectangle("fill", self.tileButton.x+2, self.tileButton.y+2, self.tileButton.w-4, self.tileButton.h-4)
    end
    love.graphics.setColor(255, 255, 255, 255)
  else
      gooi.draw("pause_button")
  end

end

function EditModeUI:up()
    local t = love.timer.getTime()
    if not PauseUI.paused and t - self.clickTime > 0.1 then
        self.clickTime = love.timer.getTime()
        for i=1, #self.tools do
            if self.tools[i] == self.selected then
                if i == 1 then
                    self.selected = self.tools[#self.tools]
                    self.selected.events.r()
                else
                    self.selected = self.tools[i-1]
                    self.selected.events.r()
                end
                break
            end
        end
    end
end

function EditModeUI:down()
    local t = love.timer.getTime()
    if not PauseUI.paused and t - self.clickTime > 0.1 then
        self.clickTime = t
        for i=1, #self.tools do
            if self.tools[i] == self.selected then
                if i == #self.tools then
                    self.selected = self.tools[1]
                    self.selected.events.r()
                else
                    self.selected = self.tools[i+1]
                    self.selected.events.r()
                end
                break
            end
        end
    end
end

function EditModeUI:left()
    local t = love.timer.getTime()
    if not PauseUI.paused and t - self.clickTime > 0.1 then
        self.clickTime = t
        for i=1, #tileButtons do
            if tileButtons[i] == self.tileButton then
                if i == 1 then
                    self.tileButton = tileButtons[#tileButtons]
                    self.tileButton.events.r()
                    self.tileButton = tileButtons[#tileButtons]
                else
                    self.tileButton = tileButtons[i-1]
                    self.tileButton.events.r()
                    self.tileButton = tileButtons[i-1]
                end
                break
            end
        end
    end
end

function EditModeUI:right()
    local t = love.timer.getTime()
    if not PauseUI.paused and t - self.clickTime > 0.1 then
        self.clickTime = love.timer.getTime()
        for i=1, #tileButtons do
            if tileButtons[i] == self.tileButton then
                if i == #tileButtons then
                    self.tileButton = tileButtons[1]
                    self.tileButton.events.r()
                    self.tileButton = tileButtons[1]
                else
                    self.tileButton = tileButtons[i+1]
                    self.tileButton.events.r()
                    self.tileButton = tileButtons[i+1]
                end
                break
            end
        end
    end
end

function removeTileButtons()
  for i=1, #tileButtons do
    gooi.removeComponent(tileButtons[i])
  end
  tileButtons = {}
  EditModeUI.tileButton = nil
end
