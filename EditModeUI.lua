require("UIGroup")

EditModeUI = {}


function love.textinput(t)
  local x = EditModeUI:getElements()
  for i=1, #x do
      if x[i].input then
        x[i].content = x[i].content .. t
      end
  end
end


function EditModeUI:load()

  EditModeUI = UIGroup:new()

  c = function ()
    lvlName.input = true
  end
  u = function ()
    if lvlName.input then
      lvlName.active = true
    else
      lvlName.active = false
    end
  end
  lvlName = Element:new(1000, 16, 264, 32, "Text", l.name, c, u)
  EditModeUI:add(lvlName)

  save = Element:new(1000, 52, 128, 32, "Text", "Save",
    function ()
      savedLevels = love.filesystem.getDirectoryItems("My Levels")
      l:save(lvlName.content..".txt")
      lvlName.active = false
      local lvl = lvlName.content..".txt"
      for i=1, #savedLevels do
        if lvl == savedLevels[i] then
          return
        end
      end
      local lvl = savedLevels[#savedLevels]
      lvl = lvl:gsub(".txt", "")
      EditModeUI:add(Element:new(1000, 88+(#savedLevels)*26, 264, 26, "Text", lvlName.content, (function () lvlName.content = lvl end), nil, 12))
    end)
  EditModeUI:add(save)

  c = function ()
    l:load(lvlName.content..".txt")
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
  --EditModeUI:add(savedLevels)

  return EditModeUI

end
