require("Placeable")
require("Tiles")
require("Cameras")
require("Players")
require("controls")
require("Level")
require("UI/Element")
require("UI/EditModeUI")
require("UI/PlayerUI")
require("UI/UI")
require("Background")
require("entities/Enemy")
require("entities/Enemies")
require("entities/Item")
require("entities/Items")
require "gooi"

-- This one is called right at the start
function love.load()
  globalScale = love.graphics.getWidth()/1280
  local c = function ()
    if l ~= nil then
      if l.players.x > e.x then
        e.right = true
        e.left = false
      else
        e.right = false
        e.left = true
      end
    end
  end
  en = Enemies:new()
  slowdowns = 0
  Placeables:load()
  Cameras:new()
  P = Player:create("images/traveler")
  l = Level:new(Tiles, P)
  items = Items:new()
  UI:load()
  b = Background:new("images/backgrounds/city")
  if love.filesystem.exists("Levels/default.txt") ~= nil then
    l:load()
  end
  debug = ""
  Cameras:setPosition(l.players.x, l.players.y)
  --love.keyboard.setKeyRepeat(true)
end
tileNum = ""

-- This function is being called repeatedly and draws things to the screen
function love.draw()
  b:draw()
  Placeables:draw()
  Decorative:draw()
  if l ~= nil then
    Tiles:draw()
    l.players:draw()
  end
  items:draw()
  en:draw()
  if fps == nil then
    fps = love.timer.getFPS()
    prevfps = fps
  else
    prevfps = fps
    fps = love.timer.getFPS()
  end
  if fps < prevfps then
    slowdowns = slowdowns + 1
  end
  love.graphics.print("FPS: "..fps.."\nSlowdowns: "..slowdowns)
  if l ~= nil then
    love.graphics.print("Player: ("..l.players.x..", "..l.players.y..")\n"..
    "("..Cameras:current().x..", "..Cameras:current().y..")", 0, 30)
  end

  EditModeUI:draw()
  UI:draw()
  gooi.draw()
end

-- This one is also being called repeatedly, handles game logic
function love.update(dt)
  items:update(dt)
  gooi.update(dt)
  Cameras:update(dt)
  UI:update(dt)
  if EditModeUI.display then
    if love.mouse.isDown(1) then
      if not UI:mouseOn() then
        Tiles:place()
      end
    end
    if love.mouse.isDown(2) then
      Tiles:remove()
    end
  else
    if l ~=nil then
      l.players:update(dt)
      en:update(dt)
    end
  end

end

function love.mousepressed(x, y, button, istouch)
  UI:onClick(x, y)
  gooi.pressed()
  Placeables:onClick(x,y,button)
end

function love.mousereleased(x, y, button)
  gooi.released()
  if not jumpButton:overIt(love.mouse.getPosition())
  and not shootButton:overIt(love.mouse.getPosition()) then
    Cameras:current().xSpeed = 0
    Cameras:current().ySpeed = 0
    l.players.left = false
    l.players.right = false
  end
end

function love.textinput(text)
  if gooi.input then
    gooi.input = false
  end
  gooi.textinput(text)
end
