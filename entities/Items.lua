require("entities/Item")

Items = {}

function Items:new()

  local set = {
    items = {}
  }

  function set:add(item)
    self.items[#self.items+1] = item
  end

  function set:spawnChance(x, y, mn, mx)

    local max = mx
    local min = mn
    if max == nil then
      if min == nil then
        min = 1
        max = 3
      else
        max = min
        min = 1
      end
    end

    local x = love.math.random(min, max)
    if x == max then
      local thing = Item:new(x, y, "images/items/healthpack.png")
      thing.ySpeed = -200
      self:add(thing)
    end

  end

  function set:draw()
    for i=1, #self.items do
      self.items[i]:draw()
    end
  end

  function set:update(dt)
    for i=1, #self.items do
      self.items[i]:update(dt)
    end
  end

  return set

end
