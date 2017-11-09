Entity = {}

function Entity:new()
  ent = {

    gravity = 3000,
		currentAnim = "",
		animations = {},
		id = num,
    objType = "Entity",
		x = 0,
		y = 0,
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
    jumpForce = 1200,
    damageTimer = 0,
    health = 15,
    damaged = false,
    alpha = 255,
    flicker = 0,
		scale = 1

  }

  function ent:moveLeft()
    ent.facing = "left"
    ent.xSpeed = ent.xSpeed - ent.accel*love.timer.getDelta()
    if ent.xSpeed < -ent.runSpeed then
      ent.xSpeed = -ent.runSpeed
    end
  end

  function ent:moveRight(dt)
    --ent.facing = "right"
    ent.xSpeed = ent.xSpeed + ent.accel*dt
    if ent.xSpeed > ent.runSpeed then
      ent.xSpeed = ent.runSpeed
    end
  end

  function ent:slowDown(dt)
    if ent.xSpeed > 0 + ent.accel*dt then
      ent.xSpeed = ent.xSpeed - ent.accel*dt
    elseif ent.xSpeed < 0 - ent.accel*dt then
      ent.xSpeed = ent.xSpeed + ent.accel*dt
    else
      ent.xSpeed = 0
    end
  end

  function ent:fall(dt)
    if not ent.grounded then
      ent.ySpeed = ent.ySpeed + ent.gravity*dt
      if ent.ySpeed > ent.fallSpeed then
        ent.ySpeed = ent.fallSpeed
      end
    end
  end

  function ent:grounded()
    for i = 1, #Tiles.set do
      if ent.y + ent.height + 2 > Tiles.set[i].y and i ~= ent.id then
        if ent.x+ent.width > Tiles.set[i].x and ent.x < Tiles.set[i].x + Tiles.set[i].width then
          if ent.y + ent.height < Tiles.set[i].y + Tiles.set[i].height/2 then
            return true
          end
        end
      end
    end
    return false
  end

  function ent:jump()
    --print("jumped = "..tostring(ent.jumped).."\ngrounded = "..tostring(ent.grounded))
    if grounded(ent) then
      ent.ySpeed = -1200
      ent.y = ent.y
      ent.jumped = true
      --ent.jumped = true
    elseif ent.rightCol then
      ent.ySpeed = -1200
      ent.xSpeed = -ent.runSpeed*1.5
      --ent.jumped = true
    elseif ent.leftCol then
      ent.ySpeed = -1200
      ent.xSpeed = ent.runSpeed*1.5
      --ent.jumped = true
    end
  end

  function ent:getx()
    return ent.x - Cameras:current().x
  end

  function ent:gety()
    return ent.y - Cameras:current().y
  end

  function ent:delete()
    local id = ent.id
    local idHolder = 0
    if ent.objType == "Enemy" then
      for i=1, table.getn(enemies) do
        if getEnemy(i).id == id then
          idHolder = i
        end
      end
    end
    table.remove(objects, ent.id)
    table.remove(enemies, idHolder)
    for i=id, #Tiles.set do
      Tiles.set[i].id = Tiles.set[i].id - 1
    end
  end

  function ent:onDamage(dt)

    -- The ent will flicker and be invincible for 2.25 seconds.
    -- The ent is vulnerable if the timer is set to 0
    if ent.damageTimer > 2.25 then
      ent.damageTimer = 0
      ent.alpha = 255

    -- If the timer is above 0, but less than 2.25, the ent will flicker
    -- Switches between an alpha of 75 and 255 (translucent and opaque)
    elseif ent.damageTimer > 0 then
      ent.damageTimer = ent.damageTimer + dt
      ent.flicker = ent.flicker + dt
      if ent.flicker > 0.015 then
        ent.flicker = 0
        if ent.alpha == 255 then
          ent.alpha = 75
        else
          ent.alpha = 255
        end
      end
        --ent.ySpeed = -800
      if not grounded(ent) then
        if ent.damaged == true then
          if ent.xSpeed < 0 then
            ent.xSpeed = -300
          else
            ent.xSpeed = 300
          end
        end
      else
        ent.damaged = false
      end

    end
  end

  return ent

end

function grounded(ent)
  for i = 1, #Tiles.set do
    if ent.y + ent.height + 2 > Tiles.set[i].y and i ~= ent.id then
      if ent.x+ent.width > Tiles.set[i].x and ent.x < Tiles.set[i].x + Tiles.set[i].width then
        if ent.y + ent.height < Tiles.set[i].y + Tiles.set[i].height/2 then
          return true
        end
      end
    end
  end
  return false
end
