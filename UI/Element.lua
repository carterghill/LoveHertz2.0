local utf8 = require("utf8")

Element = {}

--[[
  Create new UI element
]]
function Element:new(x, y, width, height, type, content, click, update, fontSize)

  local fontSize = fontSize or 18

  ui = {

    visible = true,
    x = x or 0,
    y = y or 0,
    width = width or 0,
    height = height or 0,
    content = content or {},
    type = type or "Text",
    font = love.graphics.newFont(fontSize),
    click = click,
    input = false,
    active = false,
    r = 100,
    g = 100,
    b = 100,
    a = 150

  }

    function ui:onClick()

        if self.click then
            self.click()
        end
        --self:toggleActive()
    end

  function ui:toggleActive()
    if self.active then
      self.active = false
    else
      self.active = true
    end
  end

  function ui:update(dt)

    if update == nil then
      x, y = love.mouse.getPosition()
      if self:onPoint(x, y) and love.mouse.isDown(1) then
        self.active = true
      else
        self.active = false
      end
    else
      update(dt)
    end

  end

  function ui:draw()

    if self.type == "Text" or self.type == "text" then

      if self.active then
        love.graphics.setColor(150, 150, 150, 150)
      else
        love.graphics.setColor(100, 100, 100, 150)
      end
      love.graphics.rectangle("fill", self.x*globalScale, self.y*globalScale, self.width*globalScale, self.height*globalScale, 5*globalScale, 5*globalScale)
      love.graphics.setColor(255, 255, 255, 255)

      love.graphics.setColor(0,0,0, 255)
      love.graphics.rectangle("line", self.x*globalScale, self.y*globalScale, self.width*globalScale, self.height*globalScale, 5*globalScale, 5*globalScale)
      love.graphics.setColor(255, 255, 255, 255)

      self:print()

    elseif self.type == "Health Bar" or self.type == "health bar" then

      width_per_unit = self.width/l.players.maxHealth

      love.graphics.setColor(0, 150, 0, 125)
      love.graphics.rectangle("fill", (self.x - Cameras:current().x)*getZoom(), (self.y - Cameras:current().y)*getZoom(), self.width*getZoom(), self.height*getZoom(), 5*getZoom(), 5*getZoom())
      love.graphics.setColor(255, 255, 255, 255)

      if l.players.health ~= 0 then
        love.graphics.setColor(0, 255, 0, 255)
        love.graphics.rectangle("fill", (self.x - Cameras:current().x)*getZoom(), (self.y - Cameras:current().y)*getZoom(), (width_per_unit * l.players.health)*getZoom(), self.height*getZoom(), 5*getZoom(), 5*getZoom())
        love.graphics.setColor(255, 255, 255, 255)
      end

      love.graphics.setColor(0,0,0, 255)
      love.graphics.rectangle("line", (self.x - Cameras:current().x)*getZoom(), (self.y - Cameras:current().y)*getZoom(), self.width*getZoom(), self.height*getZoom(), 5*getZoom(), 5*getZoom())
      love.graphics.setColor(255, 255, 255, 255)

    end
  end

  function ui:print()
    text = tostring(self.content)
    love.graphics.setFont( self.font )
    x = self.x*globalScale
    y = (self.y + self.height/2 - self.font:getHeight(text)/2) * globalScale
    local _, endls = string.gsub(text, "\n", "")
    y_offset = (math.floor(self.font:getWidth(text)/(self.width)) + endls)*(self.font:getHeight(text)/2)
    love.graphics.printf( text, x, y-y_offset, self.width, "center", 0, globalScale )
    love.graphics.setFont(love.graphics.newFont(12))
  end

  function ui:onPoint(x, y)
    return x < self.x*globalScale + self.width*globalScale and
           x >= self.x*globalScale and
           y < self.y*globalScale + self.height*globalScale and
           y >= self.y*globalScale
  end

  function ui:onKeypress(key)
    if self.input then
      if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(self.content, -1)

        if byteoffset then
          -- remove the last UTF-8 character.
          -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
          self.content = string.sub(self.content, 1, byteoffset - 1)
        end
      end
      if key == "return" then
        self.input = false
      end
    end
  end

  function ui:toggleVisible()
    if self.visible then
      self.visible = false
    else
      self.visible = true
    end
  end

  return ui

end

function defaultUpdate()
  x, y = love.mouse.getPosition()
  if self:onPoint(x, y) and love.mouse.isDown(1) then
    self.active = true
  else
    self.active = false
  end
end
