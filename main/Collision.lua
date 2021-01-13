function simpleCollision(o1, o2)
  if o1 ~= nil and o2 ~= nil then
    return o1.x < o2.x+o2.width and
           o2.x < o1.x+o1.width and
           o1.y < o2.y+o2.height and
           o2.y < o1.y+o1.height
  else
    return false
  end
end

--[[function pointInObject(x, y, o)
  if o ~= nil then
    return x < o.x+o.width and
           x > o.x and
           y < o.y+o.height and
           y > o.y
  else
    return false
  end
end--]]

function collision( ent, dt )

  ent.grounded = false
  ent.rightCol = false
  ent.leftCol = false
  ent.upCol = false

  for i=1, #Tiles.set do

    if Tiles.set[i].objType == "tile" then

      if ent.xSpeed > 0 and ent.x + ent.width + ent.xSpeed*dt > Tiles.set[i].x then
        if ent.y+ent.height > Tiles:getY(i) and ent.y < Tiles:getY(i) + Tiles.set[i].height then
          if ent.x < Tiles.set[i].x + Tiles.set[i].width/2 then
            ent.x = Tiles.set[i].x - ent.width
            ent.xSpeed = 0
            ent.rightCol = true
          end
        end
  		end

      if ent.xSpeed < 0 and ent.x + ent.xSpeed*dt < Tiles.set[i].x + Tiles.set[i].width then
        if ent.y+ent.height > Tiles:getY(i) and ent.y < Tiles:getY(i) + Tiles.set[i].height then
          if ent.x >= Tiles.set[i].x + Tiles.set[i].width/2 then
            ent.x = Tiles.set[i].x + Tiles.set[i].width
            ent.xSpeed = 0
            ent.leftCol = true
          end
        end
  		end

      if ent.ySpeed > 0 and ent.y + ent.height + ent.ySpeed*dt+2 > Tiles:getY(i) then
        if ent.x+ent.width > Tiles.set[i].x and ent.x < Tiles.set[i].x + Tiles.set[i].width then
          if ent.y + ent.height < Tiles:getY(i) + Tiles.set[i].height/2 then
            ent.y = Tiles:getY(i) - ent.height
            ent.ySpeed = 0
            ent.grounded = true
          end
        end
  		end

      if ent.ySpeed < 0 and ent.y + ent.ySpeed*dt < Tiles:getY(i) + Tiles.set[i].height then
        if ent.x+ent.width > Tiles.set[i].x and ent.x < Tiles.set[i].x + Tiles.set[i].width then
          if ent.y > Tiles:getY(i) + Tiles.set[i].height/2 then
            ent.y = Tiles:getY(i) + Tiles.set[i].height
            ent.ySpeed = 0
            ent.upCol = true
          end
        end
  		end
    elseif Tiles.set[i].objType == "one-way" then

      if ent.ySpeed > 0 and ent.y + ent.height + ent.ySpeed*dt+2 > Tiles:getY(i) then
        if ent.x+ent.width > Tiles.set[i].x and ent.x < Tiles.set[i].x + Tiles.set[i].width then
          if ent.y + ent.height < Tiles:getY(i) + Tiles.set[i].height/2 then
            ent.y = Tiles:getY(i) - ent.height
            ent.ySpeed = 0
            ent.grounded = true
          end
        end
  		end

    end
	end
end


function cameraCollision( player, dt )

  player.grounded = false
  player.rightCol = false
  player.leftCol = false
  player.upCol = false

  cameraColliders = Placeables.noCamera

  local count = 1
	while count <= table.getn(cameraColliders) do

    if player.xSpeed > 0 and player.x + player.width + player.xSpeed*dt > cameraColliders[count].x then
      if player.y+player.height > cameraColliders[count].y and player.y < cameraColliders[count].y + cameraColliders[count].height then
        if player.x < cameraColliders[count].x + cameraColliders[count].width/2 then
          player.x = cameraColliders[count].x - player.width
          player.xSpeed = 0
          player.rightCol = true
        end
      end
		end

    if player.xSpeed < 0 and player.x + player.xSpeed*dt < cameraColliders[count].x + cameraColliders[count].width then
      if player.y+player.height > cameraColliders[count].y and player.y < cameraColliders[count].y + cameraColliders[count].height then
        if player.x >= cameraColliders[count].x + cameraColliders[count].width/2 then
          player.x = cameraColliders[count].x + cameraColliders[count].width
          player.xSpeed = 0
          player.leftCol = true
        end
      end
		end

    if player.ySpeed > 0 and player.y + player.height + player.ySpeed*dt > cameraColliders[count].y then
      if player.x+player.width > cameraColliders[count].x and player.x < cameraColliders[count].x + cameraColliders[count].width then
        if player.y + player.height < cameraColliders[count].y + cameraColliders[count].height/2 then
          player.y = cameraColliders[count].y - player.height
          player.ySpeed = 0
          player.grounded = true
          player.jumped = false
        end
      end
		end

    if player.ySpeed < 0 and player.y + player.ySpeed*dt < cameraColliders[count].y + cameraColliders[count].height then
      if player.x+player.width > cameraColliders[count].x and player.x < cameraColliders[count].x + cameraColliders[count].width then
        if player.y > cameraColliders[count].y + cameraColliders[count].height/2 then
          player.y = cameraColliders[count].y + cameraColliders[count].height
          player.ySpeed = 0
          player.upCol = true
        end
      end
		end
    count = count + 1
	end
end
