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
require("UI/PauseUI")
require("Background")
require("entities/Enemy")
require("entities/Enemies")
require("entities/Item")
require("entities/Items")
require('Debug')
require "gooi"

-- This one is called right at the start
function love.load()

    love.filesystem.setIdentity( "beatboy" )
    globalScale = love.graphics.getWidth()/1280
    en = Enemies:new()
    slowdowns = 0
    Placeables:load()
    Cameras:new()
    P = Player:create("images/traveler")
    l = Level:new(Tiles, P)
    items = Items:new()
    b = Background:new("images/backgrounds/city")

    if love.filesystem.exists("Levels/default.txt") ~= nil then
        l:load()
    end

    UI:load()

    if not love.system.getOS() == "Android" then
        PlayerUI.display = false
        gooi.setGroupEnabled("player", false)
    end
    Cameras:setPosition(l.players.x, l.players.y)
    Debug:load()
end

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
    love.graphics.print(love.timer.getFPS())

    EditModeUI:draw()
    UI:draw()
    PauseUI:draw()

    gooi.draw()
    Debug:draw()

end

-- This one is also being called repeatedly, handles game logic
function love.update(dt)

  gooi.update(dt)

  if not PauseUI.paused then
    items:update(dt)
    Cameras:update(dt)
    UI:update(dt)
    if EditModeUI.display then
      if love.mouse.isDown(1) and EditModeUI.tool == "place" then
        if not UI:mouseOn() then
          Tiles:place()
        end
      end
      if love.mouse.isDown(2) or (love.mouse.isDown(1) and EditModeUI.tool == "delete") then
        if not UI:mouseOn() then
          Tiles:remove()
        end
      end
    else
      if l ~=nil then
        l.players:update(dt)
        en:update(dt)
      end
    end
  end
end

function love.touchpressed( id, x, y, dx, dy, pressure )
    PlayerUI.touch = true
    --gooi.setGroupVisible("player", true)
    if not EditModeUI.display then
        EditModeUI:toggle()
        EditModeUI:toggle()
        gooi.setGroupVisible("player", true)
    end
    gooi.pressed(id, x, y)
end

function love.touchreleased( id, x, y, dx, dy, pressure )
    gooi.released(id, x, y)
end

function love.touchmoved( id, x, y, dx, dy, pressure )
    if not EditModeUI.display then
        PlayerUI:touchmoved(id, x, y, dx, dy)
    else
        if zoomSlider:overIt(x, y) and zoomSlider:overIt(dx, dy) then
            gooi.released(id, x-dx, y-dy)
            gooi.pressed(id, x, y)
        end
    end
end

function love.mousemoved( x, y, dx, dy, istouch )
    if EditModeUI.display and love.mouse.isDown(1) and EditModeUI.tool == "move" then
        if not (math.abs(dx) > 500 or math.abs(dy) > 500) then
            Cameras:current().xSpeed = dx
            Cameras:current().x = Cameras:current().x - dx
            Cameras:current().ySpeed = dy
            Cameras:current().y = Cameras:current().y - dy
        end
    end
end

function love.mousepressed(x, y, button, istouch)
    UI:onClick(x, y)
    if not PlayerUI.touch then
        gooi.pressed()
    end
    Placeables:onClick(x,y,button)
end

function love.mousereleased(x, y, button, istouch)
    if not PlayerUI.touch then
        gooi.released()
    end
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

function love.resize(w, h)

    globalScale = love.graphics.getWidth()/1280

    Debug:reset()
    Debug:log(("Window resized to width: %d and height: %d."):format(w, h))
    EditModeUI:reset()
    PauseUI:reset()
    PlayerUI:reset()

    for i=1, #Cameras do
        Cameras[i].width = love.graphics.getWidth()
        Cameras[i].height = love.graphics.getHeight()
    end

end
