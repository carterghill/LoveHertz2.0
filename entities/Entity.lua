Entity = {}

function Entity:new(x, y)
  ent = {

    gravity = 3000,
		currentAnim = "",
		animations = {},
		id = num,
    objType = "Entity",
		x = x or 0,
		y = y or 0,
		width = 0,
		height = 0,
		runSpeed = 500,
		fallSpeed = 1000,
		xSpeed = 0,
		ySpeed = 0,
		accel = 3000,
		up = false,
		down = false,
		left = false,
		right = false,
    rightCol = false,
    leftCol = false,
		grounded = false,
		jumped = false,
    facing = "Right",
    jumpForce = 1275,
    damageTimer = 0,
    health = 15,
    damaged = false,
    alpha = 255,
    flicker = 0,
    flickerTime = 2.25,
		scale = 1

  }

  function ent:moveLeft()
    self.facing = "left"
    if not self.damaged then
      self.xSpeed = self.xSpeed - self.accel*love.timer.getDelta()
      if self.xSpeed < -self.runSpeed then
        self.xSpeed = -self.runSpeed
      end
    end
  end

  function ent:moveRight(dt)
    self.facing = "right"
    if not self.damaged then
      self.xSpeed = self.xSpeed + self.accel*dt
      if self.xSpeed > self.runSpeed then
        self.xSpeed = self.runSpeed
      end
    end
  end

  function ent:slowDown(dt)
    if self.xSpeed > 0 + self.accel*dt then
      self.xSpeed = self.xSpeed - self.accel*dt
    elseif self.xSpeed < 0 - self.accel*dt then
      self.xSpeed = self.xSpeed + self.accel*dt
    else
      self.xSpeed = 0
    end
  end

  function ent:fall(dt)
    if not self.grounded then
      self.ySpeed = self.ySpeed + self.gravity*dt
      if self.ySpeed > self.fallSpeed then
        self.ySpeed = self.fallSpeed
      end
    end
  end

  function ent:grounded()
    for i = 1, #Tiles.set do
      if self.y + self.height + 2 > Tiles.set[i].y and i ~= self.id then
        if self.x+self.width > Tiles.set[i].x and self.x < Tiles.set[i].x + Tiles.set[i].width then
          if self.y + self.height < Tiles.set[i].y + Tiles.set[i].height/2 then
            return true
          end
        end
      end
    end
    return false
  end

  function ent:jump()
    --print("jumped = "..tostring(self.jumped).."\ngrounded = "..tostring(self.grounded))
    if grounded(self) then
      self.ySpeed = -self.jumpForce
      self.y = self.y
      self.jumped = true
      --self.jumped = true
    elseif self.rightCol then
      self.ySpeed = -self.jumpForce
      self.xSpeed = -self.runSpeed*1.5
      --self.jumped = true
    elseif self.leftCol then
      self.ySpeed = -self.jumpForce
      self.xSpeed = self.runSpeed*1.5
      --self.jumped = true
    end
  end

  function ent:getx()
    return self.x - Cameras:current().x
  end

  function ent:gety()
    return self.y - Cameras:current().y
  end

  function ent:damage(damage)
    if self.damageTimer == 0 then
      self.health = self.health - damage or 1
      self.damageTimer = 0.0001
      self.ySpeed = -1000
      self.damaged = true
      if self.facing == "Right" then
        self.xSpeed = -500
      else
        self.xSpeed = 500
      end
    end
  end

  function ent:updateDamage(dt)

    -- The ent will flicker and be invincible for 2.25 seconds.
    -- The ent is vulnerable if the timer is set to 0
    if self.damageTimer > self.flickerTime then
      self.damageTimer = 0
      self.alpha = 255

    -- If the timer is above 0, but less than 2.25, the ent will flicker
    -- Switches between an alpha of 75 and 255 (translucent and opaque)
    elseif self.damageTimer > 0 then
      self.damageTimer = self.damageTimer + dt
      self.flicker = self.flicker + dt
      if self.flicker > 0.015 then
        self.flicker = 0
        if self.alpha == 255 then
          self.alpha = 75
        else
          self.alpha = 255
        end
      end
        --self.ySpeed = -800
      if not grounded(self) and self.objType ~= "Enemy" then
        if self.damaged == true then
          if self.xSpeed < 0 then
            self.xSpeed = -300
          else
            self.xSpeed = 300
          end
        end
      else
        self.damaged = false
      end

    end
  end

  return ent

end

function grounded(ent)
  for i = 1, #Tiles.set do
    if ent.y + ent.height + 2 > Tiles.set[i].y then
      if ent.x+ent.width > Tiles.set[i].x and ent.x < Tiles.set[i].x + Tiles.set[i].width then
        if ent.y + ent.height < Tiles.set[i].y + Tiles.set[i].height/2 then
          return true
        end
      end
    end
  end
  return false
end
