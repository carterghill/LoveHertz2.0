require("UI/UIGroup")

PlayerUI = {}
rightButton = {}
leftButton = {}
jumpButton = {}
shootButton = {}
joystick = {}

function PlayerUI:load()

  local s = globalScale

  PlayerUI = UIGroup:new()

  local c = function ()
    l.players.health = l.players.health + 1
    if l.players.health > l.players.maxHealth then
      l.players.health = l.players.maxHealth
    end
  end

  health = Element:new(0, 0, 86, 16, "Health Bar", "", c, function ()
    health.x = l.players.x
    health.y = l.players.y
  end)

  PlayerUI:add(health)

  local style = {
      font = love.graphics.newFont(fontDir.."Arimo-Bold.ttf", 36*s),
      showBorder = true,
      bgColor = {50, 50, 50, 175},
      fgColor = {250, 250, 250, 250},
      borderColor = {0, 0, 0, 250},
      borderStyle = "rough"
  }
  local oldStyle = component.style
  gooi.setStyle(style)

  leftButton = gooi.newButton({text = "<", x = 16*s, y = 576*s, w = 128*s, h = 128*s})
      --:setIcon(imgDir.."coin.png")
      --:setTooltip("")
      :onRelease(function()
        l.players.left = false
      end)
      :onPress(function()
        l.players.left = true
      end)
  leftButton:setGroup("player")--]]

  rightButton = gooi.newButton({text = ">", x = 160*s, y = 576*s, w = 128*s, h = 128*s})
      --:setIcon(imgDir.."coin.png")
      --:setTooltip("")
      :onRelease(function()
        l.players.right = false
      end)
      :onPress(function()
        l.players.right = true
      end)
  rightButton:setGroup("player")--]]

  jumpButton = gooi.newButton({text = "Jump", x = 810*s, y = 576*s, w = 128*s, h = 128*s})
      --:setIcon(imgDir.."coin.png")
      --:setTooltip("")
      :onPress(function()
        l.players:jump()
      end)
      :onRelease(function()
        l.players:endJump()
      end)
  jumpButton:setGroup("player")--]]

  shootButton = gooi.newButton({text = "Shoot", x = 954*s, y = 528*s, w = 310*s, h = 128*s})
      --:setIcon(imgDir.."coin.png")
      --:setTooltip("")
      :onPress(function()
        l.players:shoot()
      end)
  shootButton:setGroup("player")--]]

  joystick = gooi.newJoy({ x = 16*s, y = 432*s, size = 128*s, deadZone = 0.2, group = "player"})


  function PlayerUI:update(dt)

    health.x = l.players.x - Cameras:current().x-11
    health.y = l.players.y - Cameras:current().y-16

    --[[if l.players.left and rightButton:overIt(love.mouse.getPosition())
    and not jumpButton:overIt(love.mouse.getPosition())
    and not shootButton:overIt(love.mouse.getPosition())then
      --gooi.pressed()
    end
    if l.players.right and leftButton:overIt(love.mouse.getPosition()) then
      --gooi.pressed()
    end--]]

    if joystick:xValue() > 0 then
      player.right = true
      player.left = false
    elseif joystick:xValue() < 0 then
      player.left = true
      player.right = false
    end

  end

  gooi.setStyle(oldStyle)
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
