require("UI/UIGroup")
require "gooi"

EditModeUI = {
  display = true,
  elements = {},
  delete = false
}

deleteButton = {}
zoomSlider = {}
joystick = {}

function EditModeUI:toggleMode()
  if self.delete then
    self.delete = false
  else
    self.delete = true
  end
end

function EditModeUI:toggle()
  if self.display then
    self.display = false
    PlayerUI.display = true
    gooi.setGroupEnabled("edit_mode", false)
    gooi.setGroupEnabled("player", true)
  else
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
  EditModeUI:add(txt1)
  savebtn = gooi.newButton({text = "Save", x = w-296*s, y = 144*s, w = 135*s, h = 48*s})
      :setIcon(imgDir.."coin.png")
      :setTooltip("Save the current level")
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
  loadbtn = gooi.newButton({text = "Load", x = w-151*s, y = 144*s, w = 135*s, h = 48*s})
      :setIcon(imgDir.."coin.png")
      :setTooltip("Load the above level")
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
  quit = gooi.newButton({text = "Quit Game", x = 16*s, y = 16*s, w = 150*s, h = 48*s})
      :setIcon():danger()
      :setTooltip("Exit the program")
      :onRelease(function()
          gooi.confirm({
              text = "Are you sure you\nwant to quit?",
              ok = function()
                  love.event.quit()
              end
          })
      end)
  EditModeUI:add(quit)

  edittoggle = gooi.newButton({text = "Toggle Edit", x = 16*s, y = 80*s, w = 150*s, h = 48*s})
      --:setIcon(imgDir.."coin.png"):danger()
      :setTooltip("Turn Edit Mode on or off")
      :onRelease(function()
          EditModeUI:toggle()
      end)
  EditModeUI:add(edittoggle)

  nextbtn = gooi.newButton({text = ">", x = w-151*s, y = 88*s, w = 135*s, h = 48*s})
      --:setIcon(imgDir.."coin.png")
      :setTooltip("Next in the list")
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

  local c = function()
      local x = love.filesystem.getDirectoryItems("My Levels")
      local y = love.filesystem.getDirectoryItems("Levels")
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
      for i=1, #y do
        if y[i] ~= ".DS_Store" and y[i] ~= ".DS_Store.txt" then
          local t = y[i]:gsub(".txt", "")
          table.insert(savedLevels, t)
          if t == txt1:getText() then
            current = #savedLevels
          end
        end
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
      :setTooltip("previous in the list")
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

  f = function ()
    if EditModeUI.delete then
      EditModeUI.delete = false
      gooi.removeComponent(deleteButton)
      deleteButton = gooi.newButton({text = "Delete\n(off)", x = w-408*s, y = 32*s, w = 80*s, h = 80*s})
          :onRelease(f)
          :setTooltip("Turn delete mode on")
      deleteButton:setGroup("edit_mode")
    else
      EditModeUI.delete = true
      gooi.removeComponent(deleteButton)
      deleteButton = gooi.newButton({text = "Delete\n(on)", x = w-408*s, y = 32*s, w = 80*s, h = 80*s})
          :onRelease(f)
          :setTooltip("Turn delete mode off")
      deleteButton:setGroup("edit_mode")
    end
  end

  deleteButton = gooi.newButton({text = "Delete\n(off)", x = w-408*s, y = 32*s, w = 80*s, h = 80*s})
      --:setIcon(imgDir.."coin.png")
      :setTooltip("Turn delete mode on")
      :onRelease(f)
  deleteButton:setGroup("edit_mode")
  EditModeUI:add(deleteButton)

  tileButtons = {}
  local tiles = gooi.newButton({text = "Tiles", x = ((112*1)+(90))*s, y = 32*s, w = 80*s, h = 80*s})
      --:setIcon(imgDir.."coin.png")
      :setTooltip("previous in the list")
      :onRelease(function()
        Placeables.index = 1
        for i=1, #tileButtons do
          gooi.removeComponent(tileButtons[i])
        end
        tileButtons = {}
        Placeables.currentSet = "tiles"
        for i=1, #Placeables.tiles do
          local num = #tileButtons+1
          tileButtons[num] = gooi.newButton({text = "", x = ((64*4)+(i*90)-90)*s, y = h-112*s, w = 80*s, h = 80*s})
              --:setIcon(imgDir.."coin.png")
              :setTooltip("previous in the list")
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

  local enemies = gooi.newButton({text = "Bad\nGuys", x = ((112)+(90*2))*s, y = 32*s, w = 80*s, h = 80*s})
      --:setIcon(imgDir.."coin.png")
      :setTooltip("previous in the list")
      :onRelease(function()
        Placeables.index = 1
        for i=1, #tileButtons do
          gooi.removeComponent(tileButtons[i])
        end
        tileButtons = {}
        Placeables.currentSet = "enemies"
        for i=1, #Placeables.enemies do
          local num = #tileButtons+1
          tileButtons[num] = gooi.newButton({text = "", x = ((64*4)+(i*90)-90)*s, y = h-112*s, w = 80*s, h = 80*s})
              --:setIcon(imgDir.."coin.png")
              :setTooltip("previous in the list")
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

  local decorative = gooi.newButton({text = "Decor", x = ((112)+(90*3))*s, y = 32*s, w = 80*s, h = 80*s})
      --:setIcon(imgDir.."coin.png")
      :setTooltip("Get decorative placeable objects")
      :onRelease(function()
        Placeables.index = 1
        for i=1, #tileButtons do
          gooi.removeComponent(tileButtons[i])
        end
        tileButtons = {}
        Placeables.currentSet = "decorative"
        local images = loadImagesInFolder("images/decorative")
        for i=1, #images do
          --local num = #tileButtons+1
          tileButtons[i] = gooi.newButton({text = "", x = ((64*4)+(i*90)-90)*s, y = h-112*s, w = 80*s, h = 80*s})
              --:setIcon(imgDir.."coin.png")
              :setTooltip("previous in the list")
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




  local style2 = {
    bgColor = {0,0,0,10},
    fgColor = {0,0,0,10}, -- Foreground color
    tooltipFont = love.graphics.newFont(love.window.toPixels(11)), -- tooltips are smaller than the main font
    radius = love.window.toPixels(3), -- radius for the outer shapes of components
    innerRadius = love.window.toPixels(3), -- For the inner ones
    showBorder = false, -- border for components
    borderColor = component.colors.blue,
    borderWidth = love.window.toPixels(2), -- in pixels
    borderStyle = "smooth", -- or "rough"
    font = love.graphics.newFont(love.window.toPixels(13))
  }


  joystick = gooi.newJoy({ x = 16*s, y = 432*s, size = 256*s, deadZone = 0.1, group = "edit_mode"})
  EditModeUI:add(joystick)

  return EditModeUI

end

function EditModeUI:draw()
  if self.display then
    gooi.draw("edit_mode")
    Cameras:current().xSpeed = 750 * joystick:xValue()
    Cameras:current().ySpeed = 750 * joystick:yValue()
  else

  end
end
