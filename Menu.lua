Menu = {}

function Menu:load()

  self.group = "main"
  self.scale = love.graphics.getHeight()/720
  self.titleFont = love.graphics.newFont( "fonts/CuteFont-Regular.ttf", 124*self.scale)
  self.clickTime = 0

  self.menus = {}
  self.menus["main"] = {}
  self.menus["settings"] = {}

  self.buttonFont = love.graphics.newFont( "fonts/Changa-Regular.ttf", 36*self.scale)

  -- Give each button an action
  local f = function ()
      inGame = true
  end
  self:add(MenuButton:new("Start Game", nil, 380, f, self.buttonFont), "main")
  self:add(MenuButton:new("Custom Levels", nil, 440, nil, self.buttonFont), "main")
  local f = function ()
      self.group = "settings"
  end
  self:add(MenuButton:new("Settings", nil, 500, f, self.buttonFont), "main")
  local f = function ()
      love.event.quit()
  end
  self:add(MenuButton:new("Quit", nil, 590, f, self.buttonFont), "main")

  self.selected = self.menus["main"][1]

  -- Settings screen buttons
  --self.fullscreen = MenuButton:new("Fullscreen", 0, 380, nil, self.buttonFont)

end

function Menu:add(item, t)

  if self.menus[t] == nil then
    self.menus[t] = {}
  end

  table.insert(self.menus[t], item)
  local s = #self.menus[t]

  -- If it's the only item, up and down should lead to itself
  if s == 1 then
    self.menus[t][s].up = self.menus[t][s]
    self.menus[t][s].down = self.menus[t][s]
    return
  end

  -- If there's 2, up and down should both point to each other
  if s == 2 then
    self.menus[t][s].up = self.menus[t][1]
    self.menus[t][s].down = self.menus[t][1]
    self.menus[t][1].up = self.menus[t][s]
    self.menus[t][1].down = self.menus[t][s]
    return
  end

  -- Otherwise, set down to 1, and up to s-1 (the one below in list)
  self.menus[t][s].up = self.menus[t][s-1]
  self.menus[t][s].down = self.menus[t][1]
  self.menus[t][1].up = self.menus[t][s]
  self.menus[t][s-1].down = self.menus[t][s]

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

    love.graphics.rectangle("fill", self.selected.x - 75*globalScale, (self.selected.y+34)*self.scale, 16*self.scale, 16*self.scale)

  elseif self.group == "settings" then

    love.graphics.setFont(self.titleFont)
    love.graphics.printf("Settings", 0, -25*self.scale, love.graphics.getWidth(), "center")
    love.graphics.setFont(love.graphics.newFont(12))

  end

  for i=1, #self.menus[self.group] do
    self.menus[self.group][i]:draw()
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

  mb.y = y or 0           -- y position of button
  mb.text = text or ""    -- What the button says
  mb.text = love.graphics.newText( font, text )
  mb.up = self            -- The button above it
  mb.down = self          -- The button below it

  mb.func = func or function () end
  mb.font = font or love.graphics.newFont(12)

  mb.x = x or (love.graphics.getWidth()/2)-(mb.text:getWidth()/2)

  function mb:draw()

    love.graphics.draw(self.text, self.x, self.y*(love.graphics.getHeight()/720))

  end

  function mb:reset()
    self.text = love.graphics.newText( Menu.buttonFont, text )
    self.x = x or (love.graphics.getWidth()/2)-(self.text:getWidth()/2)
  end

  return mb

end


----------------------------------------------------
---- Menu Title (Different Than Button lolol) -----
----------------------------------------------------


MenuButton = {}

function MenuButton:new(text, x, y, func, font)

  local mb = {}           -- Table for the button

  mb.y = y or 0           -- y position of button
  mb.text = text or ""    -- What the button says
  mb.text = love.graphics.newText( font, text )
  mb.up = self            -- The button above it
  mb.down = self          -- The button below it

  mb.func = func or function () end
  mb.font = font or love.graphics.newFont(12)

  mb.x = x or (love.graphics.getWidth()/2)-(mb.text:getWidth()/2)

  function mb:draw()

    love.graphics.draw(self.text, self.x, self.y*(love.graphics.getHeight()/720))

  end

  function mb:reset()
    self.text = love.graphics.newText( Menu.buttonFont, text )
    self.x = x or (love.graphics.getWidth()/2)-(self.text:getWidth()/2)
  end

  return mb

end
