require('collision')
require('entities/entities')
require('animation')

players = {}
bullets = {}

function createPlayer()
	local num = table.getn(players)+1
	
	players[num] = {
		gravity = 3000,
		img = nil,
    imagePath = "images/characters/players/dudeguy/front.png",
		id = num,
    objType = "Player",
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
    facing = "right",
    jumpForce = 1200, 
    damageTimer = 0,
    health = 15,
    damaged = false,
    alpha = 255,
    flicker = 0,
    walkAnim = newAnim("images/characters/players/dudeguy/walk", 1/30)
	}
	
	players[num].img = love.graphics.newImage(players[num].imagePath)
	players[num].width = players[num].img:getWidth()
	players[num].height = players[num].img:getHeight()
	
	if cameraNum > 0 then
		players[num].x = cameras[cameraNum].x - players[num].width/2
		players[num].y = cameras[cameraNum].y - players[num].height/2
	end
	
end

function drawPlayer(i)
    if getPlayer(i) ~= nil then
      love.graphics.print(tostring(getPlayer(i).health), getx(getPlayer(i)), gety(getPlayer(i))-20)
      love.graphics.setColor(255,255,255,getPlayer(i).alpha)
      if getPlayer(i).walkAnim:getFrame() ~= nil then
        love.graphics.draw(getPlayer(i).walkAnim:getFrame(), getx(getPlayer(i)), gety(getPlayer(i)), 0, getPlayer(i).scale)
      else
        love.graphics.draw(getPlayer(i).img, getx(getPlayer(i)), gety(getPlayer(i)), 0, getPlayer(i).scale)
      end
      love.graphics.setColor(255,255,255,255)
    end
end
-- Returns player num
function getPlayer(num)
	return players[num]
end

function playerUpdate(dt)
	local count = 1
	while count <= table.getn(players) do
		player = getPlayer(count)
    
    if count == 2 then
      print("player 2 jump")
      --jump(player, dt)
    end

		if player.left then
      moveLeft(player, dt)
		end
		if player.right then
      moveRight(player, dt)
      if player.walkAnim ~= nil then
        --player.img = player.walkAnim:getFrame()
        player.walkAnim:animate(dt)
      else
        player.walkAnim = newAnim("images/characters/players/dudeguy/walk", 1/30)
      end
		end
		
		if not player.right
		and not player.left 
    and not inSequence 
    and not player.damaged then
			slowDown(player, dt)
		end
    
    fall(player, dt)
    onDamage(player, dt)
    
    if (player.rightCol or player.leftCol) and player.ySpeed > 0 then
      player.ySpeed = player.ySpeed*0.85
    end

		collision(player,dt)
		player.y = player.y + player.ySpeed*dt
		player.x = player.x + player.xSpeed*dt
		count = count + 1
	end
end

-- i: player index
function shoot(i)
  local num = table.getn(bullets)+1

	bullets[num] = {
		img = nil,
    imagePath = "images/characters/bullet.png",
		id = num,
		x = getPlayer(i).x,
		y = getPlayer(i).y+36,
		width = 0,
		height = 0,
		xSpeed = 0,
		ySpeed = 0
	}
	
	bullets[num].img = love.graphics.newImage("images/characters/bullet.png")
	bullets[num].width = bullets[num].img:getWidth()
	bullets[num].height = bullets[num].img:getHeight()
  
  if getPlayer(i).facing == "right" then
    bullets[num].xSpeed = 1000 + getPlayer(i).xSpeed/7
    bullets[num].x = getPlayer(i).x + getPlayer(i).width
  else
    bullets[num].xSpeed = -1000 + getPlayer(i).xSpeed/7
    bullets[num].x = getPlayer(i).x - bullets[num].width
  end
end


function bulletUpdate(dt)
  count = 1
  while count <= table.getn(bullets) do
    bullet = bullets[count]
    bullet.x = bullet.x + bullet.xSpeed*dt
    i = 1
    while i <= table.getn(enemies) do
      if simpleCollision(bullet, getEnemy(i)) then
        table.remove(bullets, count)
        getEnemy(i).health = getEnemy(i).health - 1
      end
      i = i + 1
    end
    if math.abs(bullet.x - getPlayer(1).x) > 3000 then
      table.remove(bullets, count)
    end
    count = count + 1
  end
end

-- This function is called when the player comes in contact with an enemy or 
-- anything that could damage him/her
function onDamage(player, dt)
  
  -- The player will flicker and be invincible for 2.25 seconds.
  -- The player is vulnerable if the timer is set to 0
  if player.damageTimer > 2.25 then
    player.damageTimer = 0
    player.alpha = 255
    
  -- If the timer is above 0, but less than 2.25, the player will flicker
  -- Switches between an alpha of 75 and 255 (translucent and opaque) 
  elseif player.damageTimer > 0 then
    player.damageTimer = player.damageTimer + dt
    player.flicker = player.flicker + dt
    if player.flicker > 0.015 then
      player.flicker = 0
      if player.alpha == 255 then
        player.alpha = 75
      else
        player.alpha = 255
      end
    end
      --player.ySpeed = -800
    if not grounded(player) then
      if player.damaged == true then
        if player.xSpeed < 0 then
          player.xSpeed = -300
        else
          player.xSpeed = 300
        end
      end
    else
      player.damaged = false
    end
    
  end
  
  -- Checks collision between the given player and the enemies.
  -- Damage will not be taken if the damage timer on the player is not equal to 0
  for i = 1, table.getn(enemies) do
    if simpleCollision(player, getEnemy(i)) and player.damageTimer == 0 then
      takeDamage(player, dt)
    end
  end
end

-- Adds damage to player, receives knockback, and trigger the damage boost
function takeDamage(player, dt)
  player.damageTimer = player.damageTimer + dt
  player.health = player.health - 2
  player.ySpeed = -1000
  player.damaged = true
  if player.facing == "right" then
    player.xSpeed = -300
  else
    player.xSpeed = 300
  end
end

function onDeath()
  if getPlayer(1) ~= nil then
    if getPlayer(1).health == nil then
      getPlayer(1).health = 15
    elseif getPlayer(1).health <= 0 then
      loadLevels()
    end
  end
end