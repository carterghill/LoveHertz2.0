require("UI/UIGroup")
require "gooi"

EditModeUI = {
  display = true
}


function love.textinput(t)
  local x = EditModeUI:getElements()
  for i=1, #x do
      if x[i].input then
        x[i].content = x[i].content .. t
      end
  end
end

function EditModeUI:toggle()
  if self.display then
    self.display = false
    gooi.setGroupEnabled("edit_mode", false)
  else
    self.display = true
    gooi.setGroupEnabled("edit_mode", true)
  end
end

function EditModeUI:load()


  imgDir = "/imgs/"
  fontDir = "/fonts/"
  style = {
      font = love.graphics.newFont(fontDir.."Arimo-Bold.ttf", 16),
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
  txt1 = gooi.newText({x = 990, w = 280, h = 26}):setText("")
  savebtn = gooi.newButton({text = "Save", x = 990, y = 70, w = 135, h = 26})
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
  txt1:setGroup("edit_mode")
  loadbtn = gooi.newButton({text = "Load", x = 1135, y = 70, w = 135, h = 26})
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
  quit = gooi.newButton({text = "Quit Game", x = 1135, y = 688, w = 135, h = 26})
      :setIcon(imgDir.."coin.png"):danger()
      :setTooltip("Exit the program")
      :onRelease(function()
          gooi.confirm({
              text = "Are you sure you\nwant to quit?",
              ok = function()
                  love.event.quit()
              end
          })
      end)

  edittoggle = gooi.newButton({text = "Toggle Edit Mode", x = 990, y = 688, w = 135, h = 26})
      --:setIcon(imgDir.."coin.png"):danger()
      :setTooltip("Turn Edit Mode on or off")
      :onRelease(function()
          EditModeUI:toggle()
      end)

  nextbtn = gooi.newButton({text = ">", x = 1135, y = 40, w = 135, h = 26})
      --:setIcon(imgDir.."coin.png")
      :setTooltip("Next in the list")
      :onRelease(function()
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
          txt1 = gooi.newText({x = x, w = w, h = h, y = y}):setText(savedLevels[current]:gsub(".txt", ""))
          txt1:setGroup("edit_mode")
          --txt1:setText(savedLevels[current]:gsub(".txt", ""))
      end)
  nextbtn:setGroup("edit_mode")

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

  prevbtn = gooi.newButton({text = "<", x = 990, y = 40, w = 135, h = 26})
      --:setIcon(imgDir.."coin.png")
      :setTooltip("previous in the list")
      :onRelease(c)
  prevbtn:setGroup("edit_mode")
  c()
  --[[

    TILES AND TYPE SELECTION

  ]]

  tileButtons = {}
  local tiles = gooi.newButton({text = "Tiles", x = (64*4)+(74), y = 10, w = 64, h = 64})
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
          tileButtons[num] = gooi.newButton({text = "", x = (64*4)+(i*68)-68, y = 640, w = 64, h = 64})
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

  local enemies = gooi.newButton({text = "Enemies", x = (64*4), y = 10, w = 64, h = 64})
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
          tileButtons[num] = gooi.newButton({text = "", x = (64*4)+(i*68)-68, y = 640, w = 64, h = 64})
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

  local decorative = gooi.newButton({text = "Decor", x = (64*4)+(74*2), y = 10, w = 64, h = 64})
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
          tileButtons[i] = gooi.newButton({text = "", x = (64*4)+(i*72)-72, y = 640, w = 64, h = 64})
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



  return EditModeUI

end

function EditModeUI:draw()
  if self.display then
    gooi.draw("edit_mode")
  end
  gooi.draw()
end
