Menu = {}

function Menu:load()

  self.groups = {"main", "levels"}
  self.scale = love.graphics.getHeight()/720
  self.titleFont = love.graphics.newFont( "fonts/CuteFont-Regular.ttf", 124*self.scale)
  self.clickTime = 0

  self.buttonFont = love.graphics.newFont( "fonts/Changa-Regular.ttf", 36*self.scale)

  self.start = MenuButton:new("Start Game", 0, 380, nil, self.buttonFont)
  self.levels = MenuButton:new("Custom Levels", 0, 440, nil, self.buttonFont)
  self.settings = MenuButton:new("Settings", 0, 500, nil, self.buttonFont)
  self.quit = MenuButton:new("Quit", 0, 590, nil, self.buttonFont)

  self.start.up = self.quit
  self.start.down = self.levels
  self.levels.up = self.start
  self.levels.down = self.settings
  self.settings.up = self.levels
  self.settings.down = self.quit
  self.quit.up = self.settings
  self.quit.down = self.start

  self.selected = self.start

end

function Menu:update(dt)
  if self.clickTime > 0 then
    self.clickTime = self.clickTime - dt
  else
    if love.keyboard.isDown("space") then
      inGame = true
    end
  end
end

function Menu:down()
  if self.clickTime <= 0 then
    self.selected = self.selected.down
    self.clickTime = 0.05
  end
end

function Menu:up()
  if self.clickTime <= 0 then
    self.selected = self.selected.up
    self.clickTime = 0.05
  end
end

function Menu:draw()

  love.graphics.setFont(self.titleFont)
  love.graphics.printf("Beatboy", 0, 0, love.graphics.getWidth(), "center")
  love.graphics.printf("and", 0, 100*self.scale, love.graphics.getWidth(), "center")
  love.graphics.printf("Melody", 0, 200*self.scale, love.graphics.getWidth(), "center")
  love.graphics.setFont(love.graphics.newFont(12))

  love.graphics.rectangle("fill", 430*globalScale, (self.selected.y+34)*self.scale, 15*globalScale, 15*globalScale)

  self.start:draw()
  self.levels:draw()
  self.settings:draw()
  self.quit:draw()

end

function Menu:reset()

  self.scale = love.graphics.getHeight()/720
  self.titleFont = love.graphics.newFont( "fonts/CuteFont-Regular.ttf", 124*self.scale)

  self.start.font = love.graphics.newFont( "fonts/Changa-Regular.ttf", 36*self.scale)
  self.levels.font = love.graphics.newFont( "fonts/Changa-Regular.ttf", 36*self.scale)
  self.settings.font = love.graphics.newFont( "fonts/Changa-Regular.ttf", 36*self.scale)
  self.quit.font = love.graphics.newFont( "fonts/Changa-Regular.ttf", 36*self.scale)

end


---------------------------------------------
---- Menu Button (Different Than Gooi) -----
---------------------------------------------


MenuButton = {}

function MenuButton:new(text, x, y, func, font)

  local mb = {}           -- Table for the button

  mb.x = x or 0           -- x position of button
  mb.y = y or 0           -- y position of button
  mb.text = text or ""    -- What the button says
  mb.up = self            -- The button above it
  mb.down = self          -- The button below it

  mb.func = func or function () end
  mb.font = font or love.graphics.newFont(12)

  function mb:draw()

    love.graphics.setFont(self.font)
    love.graphics.printf(self.text, self.x, self.y*Menu.scale, love.graphics.getWidth(), "center")
    love.graphics.setNewFont(12)

  end

  return mb

end
