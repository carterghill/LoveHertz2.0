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
      if love.filesystem.exists("Levels/default.txt") ~= nil then
          l:load()
      end
  end
  self:add(MenuButton:new("Start Game", nil, 380, f, self.buttonFont), "main")
  self:add(MenuButton:new("Custom Levels", nil, 440, nil, self.buttonFont), "main")
  local f = function ()
      self.group = "settings"
      self.selected = self.menus["settings"][1]
  end
  self:add(MenuButton:new("Settings", nil, 500, f, self.buttonFont), "main")
  local f = function ()
      love.event.quit()
  end
  self:add(MenuButton:new("Quit", nil, 590, f, self.buttonFont), "main")
  local f  = function ()
    self.selected = self.menus["main"][1]
    self.group = "main"
  end
  self:add(MenuButton:new("< Back", nil, 590, f, self.buttonFont), "settings")

  self.selected = self.menus["main"][1]

  self:add(MenuTitle:new("Settings", nil, -25*self.scale, self.titleFont), "settings")
  self:add(MenuTitle:new("Love", nil, 0, self.titleFont), "main")
  self:add(MenuTitle:new("Hertz", nil, 100*self.scale, self.titleFont), "main")

end

function Menu:add(item, t)

  if self.menus[t] == nil then
    self.menus[t] = {}
  end

  table.insert(self.menus[t], item)
  local s = #self.menus[t]

  -- If the function value it nil, it is not a button
  if item.func == nil then
    return
  end

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
      --Menu:select()
    elseif love.keyboard.isDown("escape") then
      self.group = "main"
    end
  end
  --for k,v in pairs(self.menus) do
    for i=1, #self.menus[self.group] do
      self.menus[self.group][i]:update()
    end
  --end
end

function Menu:click()

    local x, y = love.mouse.getPosition()
    local w = self.selected.text:getWidth()
    local h = self.selected.text:getHeight()

    if x > self.selected.x and
    x < self.selected.x + w and
    y > self.selected.y and
    y < self.selected.y + h then
        Menu:select()
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

  love.graphics.rectangle("fill", self.selected.x - 75*globalScale, (self.selected.y+34)*self.scale, 16*self.scale, 16*self.scale)

  for i=1, #self.menus[self.group] do
    self.menus[self.group][i]:draw()
  end

end

function Menu:reset()

  self.scale = love.graphics.getHeight()/720
  self.titleFont = love.graphics.newFont( "fonts/CuteFont-Regular.ttf", 124*self.scale)
  self.buttonFont = love.graphics.newFont( "fonts/Changa-Regular.ttf", 36*self.scale)

  for k,v in pairs(self.menus) do

    for i=1, #v do
      v[i]:reset()
      Debug:log("Type: "..type(v[i]))
    end
  end

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

  function mb:update(dt)

    local x, y = love.mouse.getPosition()
    local w = self.text:getWidth()
    local h = self.text:getHeight()

    if x > self.x and
    x < self.x + w and
    y > self.y and
    y < self.y + h then
      Menu.selected = self
    end

  end

  return mb

end


----------------------------------------------------
---- Menu Title (Different Than Button lolol) -----
----------------------------------------------------


MenuTitle = {}

function MenuTitle:new(text, x, y, font)

  local mt = {}           -- Table for the button

  mt.y = y or 0           -- y position of button
  mt.text = love.graphics.newText( font, text )

  mt.font = font or love.graphics.newFont(12)
  mt.x = x or (love.graphics.getWidth()/2)-(mt.text:getWidth()/2)

  function mt:draw()

    love.graphics.draw(self.text, self.x, self.y*(love.graphics.getHeight()/720))

  end

  function mt:reset()
    self.text = love.graphics.newText( Menu.titleFont, text )
    self.x = x or (love.graphics.getWidth()/2)-(self.text:getWidth()/2)
  end

  function mt:update(dt)

  end

  return mt

end
