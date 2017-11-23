require('collision')
require('entities/Entity')
require("Animation")

Player = {}
bullets = {}

function Player:create(folder, scale)
	local num = table.getn(Player)+1
	local s = getZoom(globalScale)

	P = Entity:new()

	P.objType = "Player"
	P.folder = folder
	P.scale = scale or 1
	P.maxHealth = 15
	P.currentAnim = "default"
	P.defaultImage = loadImagesInFolder(folder.."/idle")[2]
	P.bulletImage = love.graphics.newImage("images/characters/bullet.png")
	P.bullets = {}

	directories = getFoldersInFolder(folder)
  for i=1, #directories do
    P.animations[directories[i]] = createAnimation(folder.."/"..directories[i])
  end
	--Player[num].img = love.graphics.newImage(Player[num].imagePath)
	P.width = 64--Player[num].img:getWidth()
	P.height = 128--Player[num].img:getHeight()

	if cameraNum > 0 then
		P.x = Cameras:current().x - P.width/2
		P.y = Cameras:current().y - P.height/2
	end

	function P:animate(scale, x, y)
		if self.animations[self.currentAnim] ~= nil then
			if scale < 0 then
		  	self.animations[self.currentAnim]:play((x or self.x)-96*scale, y or self.y, 0, 2*scale, -2*scale)
			else
				self.animations[self.currentAnim]:play((x or self.x)-32*scale, y or self.y, 0, 2*scale, 2*scale)
			end
		else
			if scale < 0 then
		  	love.graphics.draw(self.defaultImage, (x or self.x)+96*s, y or self.y, 3.14159, 2*scale, 2*scale)
			else
				love.graphics.draw(self.defaultImage, (x or self.x)-32*s, y or self.y, 0, 2*scale, 2*scale)
			end
		end
	end

	function P:shoot()
	  local num = table.getn(self.bullets)+1
		p = self
		self.bullets[num] = {
			img = nil,
	    imagePath = "images/characters/bullet.png",
			id = num,
			x = p.x,
			y = p.y+36,
			width = 0,
			height = 0,
			xSpeed = 0,
			ySpeed = 0
		}

		--self.bullets[num].img = love.graphics.newImage("images/characters/bullet.png")
		--self.bullets[num].width = self.bullets[num].img:getWidth()
		--self.bullets[num].height = self.bullets[num].img:getHeight()

	  if self.facing == "Right" then
	    self.bullets[num].xSpeed = 1000 + self.xSpeed/7
	    self.bullets[num].x = self.x + self.width
	  else
	    self.bullets[num].xSpeed = -1000 + self.xSpeed/7
	    self.bullets[num].x = self.x - self.bullets[num].width
	  end
	end


	function P:bulletUpdate(dt)
	  count = 1
	  while count <= table.getn(self.bullets) do
	    bullet = self.bullets[count]
	    bullet.x = bullet.x + bullet.xSpeed*dt
	    i = 1
	    while i <= table.getn(en.enemies) do
	      if simpleCollision(bullet, en.enemies[i]) then
	        table.remove(self.bullets, count)
	        en.enemies[i]:damage(1)
	      end
	      i = i + 1
	    end
	    if math.abs(bullet.x - self.x) > 3000 then
	      table.remove(self.bullets, count)
	    end
	    count = count + 1
	  end
	end

	function P:draw()

		local s = getZoom(globalScale)

		for i=1, #self.bullets do
			love.graphics.draw(self.bulletImage, (self.bullets[i].x - Cameras:current().x)*s, (self.bullets[i].y - Cameras:current().y)*s, 0, s, s)
			--slowdowns = tostring(self.bullets[1].img)
		end

	  --love.graphics.print(tostring(self.health), self:getx()*s, self:gety()*s-20)
	  love.graphics.setColor(255,255,255,self.alpha)

		if self.facing == "Right" then
			self:animate(self.scale*s, (self:getx())*s, self:gety()*s)
		elseif player.facing == "Left" then
			self:animate(0 - self.scale*s, (self:getx()*s), self:gety()*s)
		end

	  love.graphics.setColor(255,255,255,255)

	end

	function P:update(dt)

		player = self
		--player:shoot()
		player:bulletUpdate(dt)

	  if count == 2 then
	    print("player 2 jump")
	      --jump(player, dt)
	  end

		if player.right and player.left then
			if player.xSpeed > 0 then
				player.right = false
				player:moveLeft(dt)
			  player.facing = "Left"
			else
				player.left = false
				player:moveRight(dt)
			  player.facing = "Right"
			end
		elseif player.left then
			player.right = false
	    player:moveLeft(dt)
			player.facing = "Left"
		elseif player.right and not player.damaged then
			player.left = false
	    player:moveRight(dt)
			player.facing = "Right"
		end



			if not player.right
			and not player.left
	    and not inSequence
	    and not player.damaged then
				player:slowDown(dt)
			end

	    player:fall(dt)
	    player:updateDamage(dt)

	    if (player.rightCol or player.leftCol) and player.ySpeed > 0 then
	      player.ySpeed = player.ySpeed*0.85
	    end

			collision(player,dt)

			for i=1, #en.enemies do
				if simpleCollision(player, en.enemies[i]) then
					player:damage(1)
				end
			end

			if player.ySpeed > -0.05 and player.ySpeed < 0.05 then --and self.ySpeed > 0 then
	      if math.abs(player.xSpeed) > 5 then
					if player.currentAnim ~= "run" then
	        	player.currentAnim = "run"
					end
	      else
					if player.currentAnim ~= "idle" and not player.right and not player.left then
						player.currentAnim = "idle"
					end
				end
	    else
	      if player.ySpeed < -100 and player.currentAnim ~= "jump_up" then
	        player.currentAnim = "jump_up"
	      elseif player.ySpeed < 100 and player.ySpeed > -100 and player.currentAnim ~= "jump_midair" then
	        player.currentAnim = "jump_midair"
	      elseif player.ySpeed > 100 and player.currentAnim ~= "jump_down" then
	        player.currentAnim = "jump_down"
	      end
	    end

			player.y = player.y + player.ySpeed*dt
			player.x = player.x + player.xSpeed*dt
			PlayerUI.healthBar.y = player.y - 18
			PlayerUI.healthBar.x = player.x - 11

	end

	return P

end



-- i: player index
function Player:shoot(i)
  local num = table.getn(bullets)+1

	bullets[num] = {
		img = nil,
    imagePath = "images/characters/bullet.png",
		id = num,
		x = Player:get(i).x,
		y = Player:get(i).y+36,
		width = 0,
		height = 0,
		xSpeed = 0,
		ySpeed = 0
	}

	bullets[num].img = love.graphics.newImage("images/characters/bullet.png")
	bullets[num].width = bullets[num].img:getWidth()
	bullets[num].height = bullets[num].img:getHeight()

  if Player:get(i).facing == "right" then
    bullets[num].xSpeed = 1000 + Player:get(i).xSpeed/7
    bullets[num].x = Player:get(i).x + Player:get(i).width
  else
    bullets[num].xSpeed = -1000 + Player:get(i).xSpeed/7
    bullets[num].x = Player:get(i).x - bullets[num].width
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
