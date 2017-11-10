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

-- This one is called right at the start
function love.load()
  Placeables:newTile("tiles/grass")
  Cameras:new()
  P = Player:create("images/traveler")
  Tiles:place(0, 100)
  Tiles:place(-50, 100)
  Tiles:place(-70, 100)
  Tiles:place(-150, 100)
  Tiles:place(-200, 100)
  l = Level:new(Tiles, P)
  --EditModeUI:load()
  --PlayerUI:load()
  UI:load()
  b = Background:new("images/backgrounds/city")
  --box = UI:new(540, 460, 200, 200, "Text", "Click\nto lose\nhealth! ", function () l.players.health = l.players.health - 2; box.input = true end)
  --health = UI:new(36, 36, 200, 36, "Health Bar", "", function () l.players.health = l.players.health + 1 end)

  --save = Tserial.unpack(love.filesystem.read("save.txt"))
  if love.filesystem.exists("save.txt") ~= nil then
    l:load()
  end

  love.keyboard.setKeyRepeat(true)
end
tileNum = ""

-- This function is being called repeatedly and draws things to the screen
function love.draw()
  b:draw()
  Placeables:draw()
  if l ~= nil then
    Tiles:draw()
    l.players:draw()
  end
  debug = "Level Name: "..l.name.."\n"..love.filesystem.getSaveDirectory().."\nTiles: "..#Tiles.set
  love.graphics.print(debug.."\n"..tileNum.."FPS: "..love.timer.getFPS())

  --health:draw()
  --box:draw()
  if EditModeUI.display then
    --EditModeUI:draw()
  end
  --PlayerUI:draw()
  UI:draw()

end

-- This one is also being called repeatedly, handles game logic
function love.update(dt)
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
    end
  end
end

function love.mousepressed(x, y, button, istouch)
  --tileNum = tileNum.."HELLO FROM MOUSE"
  --EditModeUI:onClick(x, y)
  --PlayerUI:onClick(x, y)
  UI:onClick(x, y)
end
