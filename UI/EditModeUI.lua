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
  else
    self.display = true
  end
end

function EditModeUI:load()


  imgDir = "/imgs/"
  fontDir = "/fonts/"
  style = {
      font = love.graphics.newFont(fontDir.."Arimo-Bold.ttf", 13),
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
  txt1 = gooi.newText({x = 990, w = 280, h = 22}):setText("")
  savebtn = gooi.newButton({text = "Save", x = 990, y = 70, w = 135, h = 22})
      :setIcon(imgDir.."coin.png")
      :setTooltip("Save the current level")
      :onRelease(function()
          gooi.confirm({
              text = "Save game as \""..txt1:getText().."\'?",
              ok = function()
                local t = txt1:getText()..".txt"
                if not love.filesystem.exists("My Levels/"..t) then
                  savedGrid:add(gooi.newButton({text = txt1:getText()}))
                end
                l:save(t)
              end
          })
      end)
  savebtn:setGroup("edit_mode")
  txt1:setGroup("edit_mode")
  loadbtn = gooi.newButton({text = "Load", x = 1135, y = 70, w = 135, h = 22})
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
  quit = gooi.newButton({text = "Quit Game", x = 1135, y = 688, w = 135, h = 22})
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

  edittoggle = gooi.newButton({text = "Toggle Edit Mode", x = 990, y = 688, w = 135, h = 22})
      --:setIcon(imgDir.."coin.png"):danger()
      :setTooltip("Turn Edit Mode on or off")
      :onRelease(function()
          EditModeUI:toggle()
      end)

  nextbtn = gooi.newButton({text = ">", x = 1135, y = 40, w = 135, h = 22})
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
          txt1 = gooi.newText({x = x, w = w, h = h, y = y}):setText(savedLevels[current]:gsub(".txt", ""))
          txt1:setGroup("edit_mode")
          --txt1:setText(savedLevels[current]:gsub(".txt", ""))
      end)
  nextbtn:setGroup("edit_mode")

  prevbtn = gooi.newButton({text = "<", x = 990, y = 40, w = 135, h = 22})
      --:setIcon(imgDir.."coin.png")
      :setTooltip("previous in the list")
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
      end)
  prevbtn:setGroup("edit_mode")



  --[[EditModeUI = UIGroup:new()

  c = function ()
    lvlName.input = true
    lvlName.active = true
  end
  u = function ()
    if lvlName.input then
      lvlName.active = true
    else
      lvlName.active = false
    end
  end
  lvlName = Element:new(1000, 16, 264, 32, "Text", l.name, c, nil)
  EditModeUI:add(lvlName)

  save = Element:new(1000, 52, 128, 32, "Text", "Save",
    function ()
      savedLevels = love.filesystem.getDirectoryItems("My Levels")
      l:save(lvlName.content..".txt")
      EditModeUI:turnOffInput()
      local lvl = lvlName.content..".txt"
      for i=1, #savedLevels do
        if lvl == savedLevels[i] then
          return
        end
      end
      local lvl = savedLevels[#savedLevels]
      lvl = lvl:gsub(".txt", "")
      c = function ()
        lvlName.content = lvl
        EditModeUI:turnOffInput()
      end
      EditModeUI:add(Element:new(1000, 88+(#savedLevels)*26, 264, 26, "Text", lvlName.content, (c), nil, 12))
    end)
  EditModeUI:add(save)

  c = function ()
    l:load(lvlName.content..".txt")
    EditModeUI:turnOffInput()
    Cameras:setPosition(l.players.x, l.players.y)
  end
  load = Element:new(1136, 52, 128, 32, "Text", "Load", c)
  EditModeUI:add(load)

  lvls = {}
  savedLevels = love.filesystem.getDirectoryItems("My Levels")
  for i=1, #savedLevels do
    local lvl = savedLevels[i]
    lvl = lvl:gsub(".txt", "")
    c = function ()
      lvlName.content = lvl
    end
    EditModeUI:add(Element:new(1000, 88+(i-1)*26, 264, 26, "Text", lvl, c, nil, 12))
  end
  --savedLevels = Element:new(1136, 52+32, 128, 32, "Text", "Load", function () l:load(lvlName.content..".txt") end)
  --EditModeUI:add(savedLevels)--]]

  return EditModeUI

end

function EditModeUI:draw()
  if self.display then
    gooi.draw("edit_mode")
  end
  gooi.draw()
end
