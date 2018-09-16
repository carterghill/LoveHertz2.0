Menu = {}

function Menu:load()

  self.group = "main"
  self.scale = love.graphics.getHeight()/720
  self.titleFont = love.graphics.newFont( "fonts/CuteFont-Regular.ttf", 124*self.scale)
  self.clickTime = 0

  self.buttonFont = love.graphics.newFont( "fonts/Changa-Regular.ttf", 36*self.scale)

  -- Start screen menu buttons
  self.start = MenuButton:new("Start Game", nil, 380, nil, self.buttonFont)
  self.levels = MenuButton:new("Custom Levels", nil, 440, nil, self.buttonFont)
  self.settings = MenuButton:new("Settings", nil, 500, nil, self.buttonFont)
  self.quit = MenuButton:new("Quit", nil, 590, nil, self.buttonFont)

  -- Assign which buttons are above or below each other
  self.start.up = self.quit
  self.start.down = self.levels

  self.levels.up = self.start
  self.levels.down = self.settings

  self.settings.up = self.levels
  self.settings.down = self.quit

  self.quit.up = self.settings
  self.quit.down = self.start

  self.selected = self.start

  -- Give each button an action
  self.start.func = function ()
      inGame = true
  end

  self.quit.func = function ()
      love.event.quit()
  end

  self.settings.func = function ()
      self.group = "settings"
  end

  -- Settings screen buttons
  self.fullscreen = MenuButton:new("Fullscreen", 0, 380, nil, self.buttonFont)

end

function Menu:update(dt)
  if self.clickTime > 0 then
    self.clickTime = self.clickTime - dt
  else
    if love.keyboard.isDown("return") then
      Menu:select()
    elseif love.keyboard.isDown("escape") then
      self.group = "main"
    end
  end
end

function Menu:select()
    if self.clickTime <= 0 then
      self.selected.func()
      self.clickTime = 0.01
    end
end

function Menu:down()
  if self.clickTime <= 0 then
    self.selected = self.selected.down
    self.clickTime = 0.01
  end
end

function Menu:up()
  if self.clickTime <= 0 then
    self.selected = self.selected.up
    self.clickTime = 0.01
  end
end

function Menu:draw()

  if self.group == "main" then

    love.graphics.setFont(self.titleFont)
    love.graphics.printf("Beatboy", 0, 0, love.graphics.getWidth(), "center")
    love.graphics.printf("and", 0, 100*self.scale, love.graphics.getWidth(), "center")
    love.graphics.printf("Melody", 0, 200*self.scale, love.graphics.getWidth(), "center")
    love.graphics.setFont(love.graphics.newFont(12))

    love.graphics.rectangle("fill", (self.selected.x - 30)*globalScale, (self.selected.y+34)*self.scale, 16*globalScale, 16*globalScale)

    self.start:draw()
    self.levels:draw()
    self.settings:draw()
    self.quit:draw()

  elseif self.group == "settings" then

    love.graphics.setFont(self.titleFont)
    love.graphics.printf("Settings", 0, -25*self.scale, love.graphics.getWidth(), "center")
    love.graphics.setFont(love.graphics.newFont(12))



  end

end

function Menu:reset()

  self.scale = love.graphics.getHeight()/720
  self.titleFont = love.graphics.newFont( "fonts/CuteFont-Regular.ttf", 124*self.scale)
  self.buttonFont = love.graphics.newFont( "fonts/Changa-Regular.ttf", 36*self.scale)

  self.start:reset()
  self.levels:reset()
  self.settings:reset()
  self.quit:reset()

end


---------------------------------------------
---- Menu Button (Different Than Gooi) -----
---------------------------------------------


MenuButton = {}

function MenuButton:new(text, x, y, func, font)

  local mb = {}           -- Table for the button

--  mb.x = x or (love.graphics.getWidth()/2)-(mb.text:getWidth()/2)           -- x position of button
  mb.y = y or 0           -- y position of button
  mb.text = text or ""    -- What the button says
  mb.text = love.graphics.newText( font, text )
  mb.up = self            -- The button above it
  mb.down = self          -- The button below it

  mb.func = func or function () end
  mb.font = font or love.graphics.newFont(12)

  mb.x = x or (love.graphics.getWidth()/2)-(mb.text:getWidth()/2)

  function mb:draw()

    --love.graphics.setFont(self.font)
    --love.graphics.printf(self.text, self.x, self.y*Menu.scale, love.graphics.getWidth(), "center")
    --self.x = (love.graphics.getWidth()/2)-(self.text:getWidth()/2)
    love.graphics.draw(self.text, self.x*love.graphics.getWidth()/1280, self.y*love.graphics.getHeight()/720)
    --love.graphics.setNewFont(12)

  end

  function mb:reset()
    mb.text = love.graphics.newText( Menu.buttonFont, text )
  end

  return mb

end
