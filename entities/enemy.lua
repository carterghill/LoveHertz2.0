require('collision')

Enemy = {}

function Enemy:new(folder, scale, ai, mousex, mousey)

	e = Entity:new()

	e.objType = "Enemy"
	e.folder = folder
	e.scale = scale or 1
	e.maxHealth = 15
	e.currentAnim = "default"
	e.defaultImage = loadImagesInFolder(folder.."/idle")[2]

	local directories = getFoldersInFolder(folder)
	for i=1, #directories do
		e.animations[directories[i]] = createAnimation(folder.."/"..directories[i])
	end
	--Player[num].img = love.graphics.newImage(Player[num].imagePath)
	e.width = 64--Player[num].img:getWidth()
	e.height = 128--Player[num].img:getHeight()

	function e:animate(scale, x, y)
		if self.animations[self.currentAnim] ~= nil then
			if scale < 0 then
		  	self.animations[self.currentAnim]:play((x or self.x)+96*globalScale, y or self.y, 3.14159, 2*globalScale, 2*scale)
			else
				self.animations[self.currentAnim]:play((x or self.x)-32*globalScale, y or self.y, 0, 2*globalScale, 2*scale)
			end
		else
			if scale < 0 then
		  	love.graphics.draw(self.defaultImage, (x or self.x)+96*globalScale, y or self.y, 3.14159, 2*globalScale, 2*scale)
			else
				love.graphics.draw(self.defaultImage, (x or self.x)-32*globalScale, y or self.y, 0, 2*globalScale, 2*scale)
			end
		end
	end

	function e:draw()

	  love.graphics.print(tostring(self.health), self:getx(), self:gety()-20)
	  love.graphics.setColor(255,255,255,self.alpha)

		if self.facing == "Right" then
			self:animate(self.scale*globalScale, (self:getx())*globalScale, self:gety()*globalScale)
		elseif self.facing == "Left" then
			self:animate(0 - self.scale*globalScale, (self:getx()*globalScale), self:gety()*globalScale)
		end

	  love.graphics.setColor(255,255,255,255)

	end

	function e:update(dt)

		if ai ~= nil then
			ai()
		end

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
	    self:onDamage(dt)

	    if (self.rightCol or self.leftCol) and self.ySpeed > 0 then
	      self.ySpeed = self.ySpeed*0.85
	    end

			collision(self, dt)


			self.y = self.y + self.ySpeed*dt
			self.x = self.x + self.xSpeed*dt

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
