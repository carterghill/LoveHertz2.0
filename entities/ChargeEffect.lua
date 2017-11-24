ChargeEffect = {}

function ChargeEffect:new(x, y, w, h)

  local ef = {
    x = x or 0,
    y = y or 0,
    width = w or 128,
    height = h or 128,
    dx = 0,
    dy = 0,
    timer = 0,
    stage = 0,
    started = false
  }

  local img = love.graphics.newImage("images/characters/bullet.png")
  ef.system = love.graphics.newParticleSystem(img, 24)
  ef.system:setParticleLifetime(0.25)
  ef.system:setEmissionRate(15)
	ef.system:setSizeVariation(1)
  ef.system:setLinearDamping(10)
  --ef.system:setSpeed(1000)
	--ef.system:setLinearAcceleration(0, 0, 20, 20) -- Random movement in all directions.
	ef.system:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.
  --ef.system:setPosition(ef.x, ef.y)

  function ef:draw()
    local s = getZoom()
    love.graphics.draw(self.system, 0, 0, 0, s, s)
  end

  function ef:start()
    self.timer = 0
    self.stage = 0
    self.started = true
    --self.system:start()
  end

  function ef:stop()
    self.system:stop()
    self.timer = 0
    self.stage = 0
    self.started = false
  end

  function ef:update(dt)

    if self.started then
      self.timer = self.timer + dt
    end
    if self.timer > 0.25 and self.stage == 0 then
      self.system:start()
    --elseif self.timer > 2*self.stage then
      --self.timer = 0
      --self.stage = self.stage + 1
    end
    local s = getZoom()
    local x = self.x
    local y = self.y
    self.system:update(dt)
    local dx = love.math.random(-80, 80)-- + self.dx/5
    local dy = love.math.random(-80, 80)-- + self.dy/5
    --x = x + dx
    --y = y + dy

    --local rads = math.angle(x, y, self.x,self.y)
    local rads = math.atan2(-dy, -dx)
    self.system:setDirection(rads)
    local dis = ((dx)^2+(dy)^2)^0.5
    ef.system:setSpeed(10*dis)
    self.system:setPosition(x + dx -Cameras:current().x, y + dy -Cameras:current().y)
  end

  return ef

end
