require("UI/UIGroup")

PlayerUI = {
  display = true,
  healthBar = {},
  elements = {}
}

rightButton = {}
leftButton = {}
jumpButton = {}
shootButton = {}
--joystick = {}

function PlayerUI:add(e)
  self.elements[#self.elements+1] = e
end

function PlayerUI:empty()
  for i=1, #self.elements do
    gooi.removeComponent(self.elements[i])
  end
  self.elements = {}
end

function PlayerUI:reset()
  self:empty()
  self:load()
end

function PlayerUI:load()

  local s = globalScale
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()

  local c = function ()
    l.players.health = l.players.health + 1
    if l.players.health > l.players.maxHealth then
      l.players.health = l.players.maxHealth
    end
  end

  self.healthBar = Element:new(l.players.x-11*getZoom(), l.players.y-18*getZoom(), 86, 16, "Health Bar", "", c)

  self.display = false
  local pause = gooi.newButton({y = 16*s, x = w-296*s, w = 280*s, h = 128*s, group="player"})
    :setText("Pause")
    :onRelease(function ()
      pauseGame()
      --gooi.newButton({y = 16*s, x = w-296*s, w = 280*s, h = 128*s, text = "Unpause"})
          --:onRelease(pauseGame())
    end)
  --PlayerUI:add(healthBar)

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

  leftButton = gooi.newButton({text = "<", x = 16*s, y = h-176*s, w = 160*s, h = 160*s})
      --:setIcon(imgDir.."coin.png")
      --:setTooltip("")
      :onRelease(function()
        l.players.left = false
      end)
      :onPress(function()
        l.players.left = true
      end)
  leftButton:setGroup("player")--]]
  PlayerUI:add(leftButton)

  rightButton = gooi.newButton({text = ">", x = 192*s, y = h-176*s, w = 160*s, h = 160*s})
      --:setIcon(imgDir.."coin.png")
      --:setTooltip("")
      :onRelease(function()
        l.players.right = false
      end)
      :onPress(function()
        l.players.right = true
      end)
  rightButton:setGroup("player")--]]
  --rightButton.touch.id
  PlayerUI:add(rightButton)

  jumpButton = gooi.newButton({text = "Jump", x = w-276*s, y = h-176*s, w = 260*s, h = 160*s})
      --:setIcon(imgDir.."coin.png")
      --:setTooltip("")
      :onPress(function()
        l.players:jump()
      end)
      :onRelease(function()
        l.players:endJump()
      end)
  jumpButton:setGroup("player")--]]
  PlayerUI:add(jumpButton)

  shootButton = gooi.newButton({text = "Shoot", x = w-452*s, y = h-176*s, w = 160*s, h = 160*s})
      :onPress(function()
          l.players:shoot()
          l.players.charge:start()
      end)
      :onRelease(function ()
          if l.players.charge.timer > 0.5 then
              l.players:shoot(l.players.charge.timer)
          end
          l.players.charge:stop()
      end)
  shootButton:setGroup("player")--]]
  PlayerUI:add(shootButton)

  --joystick = gooi.newJoy({ x = 16*s, y = 432*s, size = 128*s, deadZone = 0.2, group = "player"})

  function PlayerUI:touchmoved(id, x, y, dx, dy)
    if rightButton.touch then
      if rightButton.touch.id == id then
        if leftButton:overIt(x, y) then
          gooi.released(id, x-dx, y-dy)
          gooi.pressed(id, x, y)
        end
      end
    end
    if leftButton.touch then
      if leftButton.touch.id == id then
        if rightButton:overIt(x, y) then
          gooi.released(id, x-dx, y-dy)
          gooi.pressed(id, x, y)
        end
      end
    end
    if jumpButton.touch then
      if jumpButton.touch.id == id then
        if shootButton:overIt(x, y) then
          gooi.released(id, x-dx, y-dy)
          gooi.pressed(id, x, y)
        end
      end
    end
    if shootButton.touch then
      if shootButton.touch.id == id then
        if jumpButton:overIt(x, y) then
          gooi.released(id, x-dx, y-dy)
          gooi.pressed(id, x, y)
        end
      end
    end
  end

  function PlayerUI:update(dt)

    --health.x = l.players.x - Cameras:current().x-11
    --health.y = l.players.y - Cameras:current().y-16

    --[[if l.players.left and rightButton:overIt(love.mouse.getPosition())
    and not jumpButton:overIt(love.mouse.getPosition())
    and not shootButton:overIt(love.mouse.getPosition())then
      gooi.pressed()
    end
    if l.players.right and leftButton:overIt(love.mouse.getPosition()) then
      gooi.pressed()
    end--]]

  end

  function PlayerUI:draw()

    self.healthBar:draw()
    if self.display then
      gooi.draw("player")
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
