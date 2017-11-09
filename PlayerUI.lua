require("UIGroup")

PlayerUI = {}

function PlayerUI:load()

  PlayerUI = UIGroup:new()

  local c = function ()
    EditModeUI:toggle();
  end
  toggle = Element:new(1136, 720-16-64, 128, 64, "Text", "Toggle Edit Mode", c)

  local c = function ()
    l.players.health = l.players.health + 1
    if l.players.health > l.players.maxHealth then
      l.players.health = l.players.maxHealth
    end
  end
  health = Element:new(16, 720-16-32, 200, 32, "Health Bar", "", c)

  PlayerUI:add(toggle)
  PlayerUI:add(health)

  return PlayerUI

end
--[[
function PlayerUI:toggle()
  if  PlayerUI.display then
    PlayerUI.display = false
  else
    PlayerUI.display = true
  end
end

function  PlayerUI:add(e)
  table.insert(self.elements, e)
end

function  PlayerUI:draw()
  local x = self:getElements()
  for i=1, #x do
    x[i]:draw()
  end
end

function  PlayerUI:getElements()
  return self.elements
end

function  PlayerUI:onKeypress(key)
  local x = self:getElements()
  for i=1, #x do
    if x[i].input then
      x[i]:onKeypress(key)
    end
  end
end

function  PlayerUI:onInput()
  local x = self:getElements()
  for i=1, #x do
    if x[i].input then
      return true
    end
  end
  return false
end

function  PlayerUI:onClick(x, y)
  local t = self:getElements()
  for i=1, #t do
    if t[i]:onPoint(x, y) then
      t[i]:onClick()
    end
  end
end

function  PlayerUI:onPoint(x, y)
  local t = self:getElements()
  for i=1, #t do
    if t[i]:onPoint(x, y) then
      return true
    end
  end
  return false
end
]]
