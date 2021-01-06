require("main/Placeable")
require("main/Tiles")
require("main/Cameras")
require("main/Players")
require("main/Controls")
require("main/Level")
require("UI/Element")
require("UI/EditModeUI")
require("UI/PlayerUI")
require("UI/UI")
require("UI/PauseUI")
require("main/Background")
require("entities/Enemy")
require("entities/Enemies")
require("entities/Item")
require("entities/Items")
require('main/Debug')
require("main/LevelFile")
require("main/Menu")
require("main/Music")
require "gooi"

-- This one is called right at the start
function love.load()

    --love.mouse.setGrabbed(true)
    love.filesystem.setIdentity( "lovehertz" )
    Menu:load()
    --Music:load()
    --Music:play()

    inGame = false

    globalScale = love.graphics.getWidth()/1280
    en = Enemies:new()
    slowdowns = 0
    Placeables:load()
    Cameras:new()
    P = Player:create("images/traveler")
    l = Level:new(Tiles, P)
    items = Items:new()
    b = Background:new("images/backgrounds/city")

    UI:load()

    if not love.system.getOS() == "Android" then
        PlayerUI.display = false
        gooi.setGroupEnabled("player", false)
    end
    Cameras:setPosition(l.players.x, l.players.y)
    Debug:load()
    Debug:toggle()
    --lvl = LevelFile:load("first.lvl")
end

-- This function is being called repeatedly and draws things to the screen
function love.draw()

    if inGame then
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


        Debug:draw()

        --love.graphics.draw(lvl.icon)
    else
        Menu:draw()
    end

    Debug:draw()
    gooi.draw()

end

-- This one is also being called repeatedly, handles game logic
function love.update(dt)

  controls:update(dt)
  gooi.update(dt)

  if not PauseUI.paused and inGame then
    items:update(dt)
    Cameras:update(dt)
    UI:update(dt)
    if EditModeUI.display then
      if love.mouse.isDown(1) and EditModeUI.tool == "place" then
        if not UI:mouseOn() then
          Tiles:place()
        end
      end
      if (love.mouse.isDown(1) and EditModeUI.tool == "delete") then
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
  else
      if not inGame then
          Menu:update(dt)
      end
  end
end

function love.touchpressed( id, x, y, dx, dy, pressure )

    if ingame then
        -- If screen is touched, show touch controls
        lvl:load()
        PlayerUI.touch = true
        if not EditModeUI.display then
            EditModeUI:toggle()
            EditModeUI:toggle()
            gooi.setGroupVisible("player", true)
        end

        Placeables:onClick(x , y, 1)
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

    if EditModeUI.display and not PauseUI.paused
    and (love.mouse.isDown(2) or (love.mouse.isDown(1) and EditModeUI.tool == "move")) then
        if not (math.abs(dx) > 150 or math.abs(dy) > 150) then
            Cameras:current().x = Cameras:current().x - dx/getZoom()
            Cameras:current().y = Cameras:current().y - dy/getZoom()
        end
    end

    joyUsed = false
    local joysticks = love.joystick.getJoysticks()
    for i, joystick in ipairs(joysticks) do

            local axis = math.abs(joystick:getAxis(3))
            if axis > 0.1 then
                joyUsed = true
            end
            local axis = math.abs(joystick:getAxis(6))
            if axis > 0.1 then
                joyUsed = true
            end

    end
    if not joyUsed then
        controls.x = controls.x + dx
        controls.y = controls.y + dy
    end
end

function love.mousepressed(x, y, button, istouch)
    UI:onClick(x, y)
    if not PlayerUI.touch then
        gooi.pressed()
    end
    if not istouch then
      Placeables:onClick(x,y,button)
    end
    Menu:click()
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

    -- Reset scale on resize
    globalScale = love.graphics.getWidth()/1280

    -- Reset UI elements
    Debug:reset()
    Debug:log(("Window resized to width: %d and height: %d."):format(w, h))
    EditModeUI:reset()
    PauseUI:reset()
    PlayerUI:reset()
    Menu:reset()

    for i=1, #Cameras do
        Cameras[i].width = love.graphics.getWidth()
        Cameras[i].height = love.graphics.getHeight()
    end

end
