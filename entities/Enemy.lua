require('collision')
require('entities/Entity')

Enemy = {}

function Enemy:new(name, folder, scale, ai, mousex, mousey)

	local x = (mousex or love.mouse.getX())/getZoom(globalScale)
	local y = (mousey or love.mouse.getY())/getZoom(globalScale)

  cam = Cameras:current()
  if cam ~= nil then
    x = x + cam.x
    y = y + cam.y
  end

	e = Entity:new(x, y)

	e.name = name
	e.objType = "Enemy"
	e.folder = folder
	e.scale = scale or 1
	e.maxHealth = 15
	e.currentAnim = "default"
	e.defaultImage = loadImagesInFolder(folder.."/idle")[1]
	e.folder = folder
	e.accel = 300
	e.runSpeed = 100
	e.flickerTime = 0.25
	e.ai = ai


	function e:save()
		return {x = self.x, y = self.y, folder = self.folder, scale = self.scale}
	end

	local directories = getFoldersInFolder(folder)
	for i=1, #directories do
		e.animations[directories[i]] = createAnimation(folder.."/"..directories[i])
	end
	--Player[num].img = love.graphics.newImage(Player[num].imagePath)
	e.width = 128--Player[num].img:getWidth()
	e.height = 127--Player[num].img:getHeight()

	e.x = e.x - e.width/2
	e.y = e.y - e.height/2

	function e:animate(scale, x, y)
		if self.animations[self.currentAnim] ~= nil then
			if scale < 0 then
		  	self.animations[self.currentAnim]:play((x or self.x), y or self.y, 3.14159, scale, scale)
			else
				self.animations[self.currentAnim]:play((x or self.x)-32, y or self.y, 0, scale, scale)
			end
		else
			if scale < 0 then
		  	love.graphics.draw(self.defaultImage, (x or self.x), y or self.y, 3.14159, scale, scale)
			else
				love.graphics.draw(self.defaultImage, (x or self.x), y or self.y, 0, scale, scale)
			end
		end
	end

	function e:draw()

		local s = getZoom()

	  love.graphics.print(tostring(self.health), self:getx()*s, self:gety()*s-20)
	  love.graphics.setColor(255,255,255,self.alpha)

		if self.facing == "Right" then
			self:animate(self.scale*s, (self:getx())*s, self:gety()*s)
		elseif self.facing == "Left" then
			self:animate(0 - self.scale*s, (self:getx()*s), self:gety()*s)
		end

	  love.graphics.setColor(255,255,255,255)

	end

	function e:damage(damage)
    --if self.damageTimer == 0 then
		local d = damage or 1
      self.health = self.health - d
      self.damageTimer = 0.0001
      --self.ySpeed = -1000
      self.damaged = true
      if self.facing == "Right" then
        --self.xSpeed = -500
      else
        --self.xSpeed = 500
      end
  --  end
  end

	function e:update(dt)

		if self.ai ~= nil then
			self:ai(dt)
		end

		--[[if l ~= nil then
      if l.players.x + l.players.width/2 > e.x + e.width/2 then
        e.right = true
        e.left = false
      else
        e.right = false
      	e.left = true
      end
    end]]

		if self.right and self.left then
			if self.xSpeed > 0 then
				self.right = false
				self:moveLeft(dt)
			  self.facing = "Left"
			else
				self.left = false
				self:moveRight(dt)
			  self.facing = "Right"
			end
		elseif self.left then
			self.right = false
	    self:moveLeft(dt)
			self.facing = "Left"
		elseif self.right then
			self.left = false
	    self:moveRight(dt)
			self.facing = "Right"
		end

			if not self.right
			and not self.left
	    and not inSequence
	    and not self.damaged then
				self:slowDown(dt)
			end

	    self:fall(dt)
	    self:updateDamage(dt)

	    if (self.rightCol or self.leftCol) and self.ySpeed > 0 then
	      self.ySpeed = self.ySpeed*0.85
	    end

			collision(self, dt)


			self.y = self.y + self.ySpeed*dt
			self.x = self.x + self.xSpeed*dt

	end

	if e.ai == nil then

		if e.name == nil then
			local str = split(e.folder, "/")
			e.name = str[#str]
		end


		if e.name == "Paul" then
			e.ai = function (self, dt)

				if self.jumpTimer == nil then
					self.jumpTimer = 3
				end
				self.jumpTimer = self.jumpTimer - dt

				if l ~= nil then
					if math.abs(l.players.x - self.x) > 750 or math.abs(l.players.y - self.y) > 750 then
						self.left = false
						self.right = false
					else
						if self.jumpTimer <= 0 then
							self:jump()
							self.jumpTimer = 3
							if l.players.x + l.players.width/2 > self.x + self.width/2 then
								self.xSpeed = 400
							else
								self.xSpeed = -400
							end
						elseif self.xSpeed ~= 0 and grounded(self) then
							self.xSpeed = 0
						end
					end
				end
			end
		end


		if e.name == "Frank" then
			e.ai = function (self, dt)
		    if l ~= nil then
		      if l.players.x + l.players.width/2 > self.x + self.width/2 then
		        self.right = true
		        self.left = false
		      else
		        self.right = false
		      	self.left = true
		      end
					if math.abs(l.players.x - self.x) > 750 or math.abs(l.players.y - self.y) > 750 then
						self.left = false
						self.right = false
					end
		    end
			end
		end

  end

	return e

end

-- Returns enemy object
function getEnemy(num)
	return enemies[num]
end

function enemyUpdate(dt)
	local count = 1
	while count <= table.getn(enemies) do

		enemy = getEnemy(count)
    if enemy ~= nil then

      fall(enemy, dt)

      collision(enemy,dt)

      if not inSequence then
        enemy:action(dt)
      else
        slowDown(enemy, dt)
      end

      if enemy.health <= 0 then
        --deleteEntity(enemy)
        table.remove(enemies, count)

      end

      enemy.y = enemy.y + enemy.ySpeed*dt
      enemy.x = enemy.x + enemy.xSpeed*dt
    end
		count = count + 1
	end
end


-- ////////////////////
-- ENEMY AI DEFINITIONS
-- ////////////////////


function enemyInit()

  for i=1, table.getn(enemies) do
    enemy = getEnemy(i)

    if enemy.name == "paul" or enemy.name == "paul.png" then

      enemy.runSpeed = 150
      enemy.accel = 500

      function enemy:action(dt)
       if getPlayer(1).x + getPlayer(1).width/2 > self.x + self.width/2 then
          moveRight(self, dt)
        else
          moveLeft(self, dt)
        end
      end

    elseif enemy.name == "frank" or enemy.name == "frank.png" then

      --enemy.health = 10

      function enemy:action(dt)

        if math.abs(self.x - getPlayer(1).x) < 1000 then
          self.actionTimer = self.actionTimer + dt
          if self.actionTimer > 3 then
            self.jumped = false
            jump(self, dt)
            if getPlayer(1).x + getPlayer(1).width/2 > self.x + self.width/2 then
              self.xSpeed = 200
            else
              self.xSpeed = -200
            end
            self.actionTimer = 0
          end
          if grounded(self) and xSpeed ~= 0 and self.actionTimer > 0 then
            self.xSpeed = 0
          end
        end

      end

    else

      function enemy:action(dt)

      end
    end

  end
end
