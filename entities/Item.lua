require("entities/Entity")

Item = {}

function Item:new(x, y, path, action)

  local x = x or love.mouse.getX()
  local y = y or love.mouse.getY()
  i = Entity:new(x, y)
  i.action = action
  i.active = true
  i.grounded = false

  if isImage(path) then
    i.img = love.graphics.newImage(path)
    i.width = i.img:getWidth()
    i.height = i.img:getHeight()
  end

  function i:draw()
    if self.active then
      local s = globalScale
      local x = self.x - Cameras:current().x
      local y = self.y - Cameras:current().y
      love.graphics.draw(self.img, x*s, y*s, 0, self.scale*s)
    end
  end

  function i:collect()
    if self.action ~= nil then
      self:action()
    end
    --else
      l.players.health = l.players.health + 1
    --end
    self.active = false
  end

  function i:update(dt)

    if self.active then
      self:fall(dt)
      if l ~= nil then
        if simpleCollision(self, l.players) then
          self:collect()
        end
      end
    end

    collision(self,dt)

    self.y = self.y + self.ySpeed*dt

  end

  return i

end

function isImage(path)
  return  string.match(path, ".png") or
          string.match(path, ".jpg") or
          string.match(path, ".gif")
end
