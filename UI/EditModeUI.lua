require("UI/UIGroup")
require "gooi"

EditModeUI = {
  display = true,
  elements = {},
  delete = false,
  tool = "move",
  selected = {}
}

deleteButton = {}
zoomSlider = {}

function EditModeUI:toggleMode()
  if self.delete then
    self.delete = false
  else
    self.delete = true
  end
end

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

function EditModeUI:add(e)
  self.elements[#self.elements+1] = e
end

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

function EditModeUI:reset()
    self:empty()
    self:load()
end

function EditModeUI:load()

  local s = globalScale
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()

  imgDir = "/imgs/"
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
  -- Free elements with no layout:
  -----------------------------------------------
  -----------------------------------------------

  --lbl1 = gooi.newLabel({x = 10, text = "Level Name: "}):left()
  txt1 = gooi.newText({y = 16*s, x = w-296*s, w = 280*s, h = 64*s}):setText("")
  --EditModeUI:add(txt1)
  savebtn = gooi.newButton({text = "Save", x = w-296*s, y = 144*s, w = 135*s, h = 48*s})
      :setIcon(imgDir.."coin.png")
      ----:setTooltip("Save the current level")
      :onRelease(function()
          gooi.confirm({
              text = "Save game as \""..txt1:getText().."\'?",
              ok = function()
                local t = txt1:getText()..".txt"
                if not love.filesystem.exists("My Levels/"..t) then
                  --savedGrid:add(gooi.newButton({text = txt1:getText()}))
                end
                l:save(t)
              end
          })
      end)
  savebtn:setGroup("edit_mode")
  EditModeUI:add(savebtn)
  txt1:setGroup("edit_mode")
  EditModeUI:add(txt1)
  loadbtn = gooi.newButton({text = "Load", x = w-151*s, y = 144*s, w = 135*s, h = 48*s})
      :setIcon(imgDir.."coin.png")
      ----:setTooltip("Load the above level")
      :onRelease(function()
          gooi.confirm({
              text = "Load \""..txt1:getText().."\'?",
              ok = function()
                  l:load(txt1:getText()..".txt")
              end
          })
      end)
  loadbtn:setGroup("edit_mode")
  EditModeUI:add(loadbtn)

  nextbtn = gooi.newButton({text = ">", x = w-151*s, y = 88*s, w = 135*s, h = 48*s})
      --:setIcon(imgDir.."coin.png")
      ----:setTooltip("Next in the list")
      :onRelease(function()
          local x = love.filesystem.getDirectoryItems("My Levels")
          local savedLevels = {}
          local current = 1
          for i=1, #x do
            if x[i] ~= ".DS_Store" and x[i] ~= ".DS_Store.txt" then
              local t = x[i]:gsub(".txt", "")
              table.insert(savedLevels, t)
              if t == txt1:getText() then
                current = #savedLevels
              end
            end
          end
          if #savedLevels == 0 then
            return
          end
          current = current + 1
          if current > #savedLevels then
            current = 1
          end
          local x = txt1.x
          local y = txt1.y
          local w = txt1.w
          local h = txt1.h
          --txt1.indexCursor = 1
          gooi.removeComponent(txt1)
          if savedLevels[current] == nil then
            return
          end
          txt1 = gooi.newText({x = x, w = w, h = h, y = y}):setText(savedLevels[current]:gsub(".txt", ""))
          txt1:setGroup("edit_mode")
          --txt1:setText(savedLevels[current]:gsub(".txt", ""))
      end)
  nextbtn:setGroup("edit_mode")
  EditModeUI:add(nextbtn)

  pauseBtn = gooi.newButton({text = "Pause", x = w-296*s, y = 200*s, w = 280*s, h = 48*s})
      --:setIcon(imgDir.."coin.png")
      ----:setTooltip("Save the current level")
      :onRelease(function()
          PauseUI:pause()
      end)
  pauseBtn:setGroup("edit_mode")
  EditModeUI:add(pauseBtn)

  local c = function()
      local x = love.filesystem.getDirectoryItems("My Levels")
      local savedLevels = {}
      local current = 1
      for i=1, #x do
        if x[i] ~= ".DS_Store" and x[i] ~= ".DS_Store.txt" then
          local t = x[i]:gsub(".txt", "")
          table.insert(savedLevels, t)
          if t == txt1:getText() then
            current = #savedLevels
          end
        end
      end
      if #savedLevels == 0 then
        return
      end
      current = current - 1
      if current < 1 then
        current = #savedLevels
      end
      local x = txt1.x
      local y = txt1.y
      local w = txt1.w
      local h = txt1.h
      --txt1.indexCursor = 1
      gooi.removeComponent(txt1)
      txt1 = gooi.newText({x = x, w = w, h = h, y = y}):setText(savedLevels[current]:gsub(".txt", ""))
      txt1:setGroup("edit_mode")
      --txt1:setText(savedLevels[current]:gsub(".txt", ""))
  end

  prevbtn = gooi.newButton({text = "<", x = w-296*s, y = 88*s, w = 135*s, h = 48*s})
      --:setIcon(imgDir.."coin.png")
    --  --:setTooltip("previous in the list")
      :onRelease(c)
  prevbtn:setGroup("edit_mode")
  EditModeUI:add(prevbtn)

  zoomSlider = gooi.newSlider({
    value = 0.5,
    x = w-296*s,
    y = h-60*s,
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

  deleteButton = gooi.newButton({text = "Delete\n(off)", x = 16*s, y = 360*s, w = 80*s, h = 80*s})
      --:setIcon(imgDir.."coin.png")
      --:setTooltip("Turn delete mode on")
      :onRelease(function ()
          EditModeUI.tool = "delete"
          self.selected = deleteButton
      end)
      --:setBGImage("images/items/healthpack.png")
  deleteButton:setGroup("edit_mode")
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
      end)
  mv = love.graphics.newImage("images/moveIcon.png")
  mv:setFilter("nearest", "nearest")
  moveScrn:setGroup("edit_mode")
  --moveScrn:setBGImage(mv)
  EditModeUI:add(moveScrn)
  self.selected = moveScrn

  tileButtons = {}
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
        tileButtons = {}
        Placeables.currentSet = "tiles"
        for i=1, #Placeables.tiles do
          local num = #tileButtons+1
          tileButtons[num] = gooi.newButton({text = "", x = 16*s + (i-1)*86, y = h-96*s, w = 80*s, h = 80*s})
              --:setIcon(imgDir.."coin.png")
              --:setTooltip("previous in the list")
              :onRelease(function()
                Placeables.index = i
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
        Placeables.index = 1
    end)

  Placeables.index = 1

  enemies = gooi.newButton({text = "Bad\nGuys", x = 16*s, y = 188*s, w = 80*s, h = 80*s})
      --:setIcon(imgDir.."coin.png")
      ----:setTooltip("previous in the list")
      :onRelease(function()
        Placeables.index = 1
        for i=1, #tileButtons do
          gooi.removeComponent(tileButtons[i])
        end
        self.tool = "place"
        self.selected = enemies
        tileButtons = {}
        Placeables.currentSet = "enemies"
        for i=1, #Placeables.enemies do
          local num = #tileButtons+1
          tileButtons[num] = gooi.newButton({text = "", x = 16*s + (i-1)*86, y = h-96*s, w = 80*s, h = 80*s})
              --:setIcon(imgDir.."coin.png")
              --:setTooltip("previous in the list")
              :onRelease(function()
                Placeables.index = i
              end)
          tileButtons[num]:setGroup("edit_mode")
          if Placeables:getTile() ~= nil then
            local tile = Placeables:getTile()
            local img = tile.defaultImage
            tileButtons[num]:setBGImage(img)
          end
          Placeables.index = Placeables.index + 1
        end
        Placeables.index = 1
      end)
  enemies:setGroup("edit_mode")
  tiles:setGroup("edit_mode")
  EditModeUI:add(enemies)
  EditModeUI:add(tiles)

  decorative = gooi.newButton({text = "Decor", x = 16*s, y = 274*s, w = 80*s, h = 80*s})
      --:setIcon(imgDir.."coin.png")
      ----:setTooltip("Get decorative placeable objects")
      :onRelease(function()
        Placeables.index = 1
        for i=1, #tileButtons do
          gooi.removeComponent(tileButtons[i])
        end
        self.tool = "place"
        self.selected = decorative
        tileButtons = {}
        Placeables.currentSet = "decorative"
        local images = loadImagesInFolder("images/decorative")
        for i=1, #images do
          --local num = #tileButtons+1
          tileButtons[i] = gooi.newButton({text = "", x = 16*s + (i-1)*86, y = h-96*s, w = 80*s, h = 80*s})
              --:setIcon(imgDir.."coin.png")
              ----:setTooltip("previous in the list")
              :onRelease(function()
                Placeables.index = i
              end)
          tileButtons[i]:setGroup("edit_mode")
          --if Placeables:getTile() ~= nil then
            --local img = Placeables:getTile()
            tileButtons[i]:setBGImage(images[i])
          --end
          Placeables.index = Placeables.index + 1
        end
        Placeables.index = 1
        --gooi.newButton({text = #tileButtons, x = (64*4)+(i*72)-72, y = 640, w = 64, h = 64})
      end)
  decorative:setGroup("edit_mode")
  EditModeUI:add(decorative)


  return EditModeUI

end

function EditModeUI:draw()

  if self.display then
    gooi.draw("edit_mode")
    love.graphics.setColor(255, 255, 255, 40)
    love.graphics.rectangle("fill", self.selected.x+2, self.selected.y+2, self.selected.w-4, self.selected.h-4)
    love.graphics.setColor(255, 255, 255, 255)
  else

  end

end
