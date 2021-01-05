Objects = {

  tiles = {}

}

function Objects:create(mousex, mousey)

	newObject = {
    id = num,
    objType = "Static",
		img = nil,
    imagePath = placeableStatic[placeableStaticNum].imagePath,
		width = 0,
		height = 0,
		x = mousex,
		y = mousey,
		xSpeed = 0,
		ySpeed = 0,
		scale = 1
	}



	objects[num].img = placeableStatic[placeableStaticNum].img
	objects[num].width = objects[num].img:getWidth()
	objects[num].height = objects[num].img:getHeight()

	if cameraNum > 0 then
		--newObject.x = newObject.x + cameras[cameraNum].x - newObject.img:getWidth()/2
		--newObject.y = newObject.y + cameras[cameraNum].y - newObject.img:getHeight()/2

	end

  return newObject

end

function Objects:placeTile(x, y)

  x = (x or love.mouse.getX())
  y = (y or love.mouse.getY())

  tile = Objects:getTileIndex(x, y)
  if tile ~=nil then
    table.remove(Objects.tiles, tile)
  end

  dx = x % 64
  dy = y % 64

  if dx < 64 then
    placex = x - dx
    if dy < 64 then
      placey = y-dy
    else
      placey = y+dy
    end
  else
    placex = x + dx
    if dy < 64 then
      placey = y-dy
    else
      placey = y+dy
    end
  end

  t = Placeables:getTile()
  armages = {}
  armages["default"] = t[1]
  armages["Center"] = t[2]
  armages["CliffLeft"] = t[3]
  armages["CliffRight"] = t[4]
  armages["TopLeft"] = t[5]
  armages["TopCenter"] = t[6]
  armages["TopRight"] = t[7]

  Objects.tiles[#Objects.tiles+1] = {
    images = armages,
    type = "default",
    x = placex,
    y = placey,
    scale = 64 / Placeables:getTile()[1]:getWidth()
  }

  Objects:setTileType(Objects.tiles[#Objects.tiles])

end

function Objects:removeTile(x, y)

  x = (x or love.mouse.getX())
  y = (y or love.mouse.getY())

  tile = Objects:getTileIndex(x, y)
  if tile ~=nil then
    table.remove(Objects.tiles, tile)
  end

  up = Objects:getTile(x, y-64)
  down = Objects:getTile(x, y+64)
  left = Objects:getTile(x-64, y)
  right = Objects:getTile(x+64, y)


  Objects:setTileType(up, down, left, right)


end

function Objects:setTileType(tile)

  if tile ~= nil then
    up = Objects:getTile(tile.x+2, tile.y-2)
    down = Objects:getTile(tile.x+2, tile.y+66)
    left = Objects:getTile(tile.x-2, tile.y+2)
    right = Objects:getTile(tile.x+66, tile.y+2)


    if up ~= nil and left ~= nil and right ~= nil and down ~= nil then
      tile.type = "Center"
      Objects:setTileType2(left, right, up, down)
    elseif up ~= nil and left ~= nil and down ~= nil then
      tile.type = "Center"
      Objects:setTileType2(left, up, down)
    elseif up ~= nil and right ~= nil and down ~= nil then
      tile.type = "Center"
      Objects:setTileType2(right, up, down)
    elseif up ~= nil and right ~= nil and left ~= nil then
      tile.type = "TopCenter"
      Objects:setTileType2(right, up, left)
      if Objects:getTile(tile.x-2, tile.y-2) ~= nil or Objects:getTile(tile.x+66, tile.y-2) ~= nil then
        tile.type = "Center"
      end
    elseif left ~= nil and right ~= nil and down ~= nil then
      tile.type = "TopCenter"
      Objects:setTileType2(right, left, down)
    elseif left ~= nil and right ~= nil then
      tile.type = "TopCenter"
      Objects:setTileType2(right, left)
    elseif left ~= nil and up ~= nil then
      tile.type = "Center"
      Objects:setTileType2(up, left)
    elseif right ~= nil and down ~= nil then
      tile.type = "TopLeft"
      Objects:setTileType2(right, down)
    elseif right ~= nil and up ~= nil then
      tile.type = "Center"
      Objects:setTileType2(right, up)
    elseif up ~= nil and down ~= nil then
      tile.type = "Center"
      Objects:setTileType2(down, up)
    elseif left ~= nil and down ~= nil then
      tile.type = "TopRight"
      Objects:setTileType2(left, down)
    elseif left ~= nil then
      tile.type = "CliffRight"
      Objects:setTileType2(left)
    elseif right ~= nil then
      tile.type = "CliffLeft"
      Objects:setTileType2(right)
    elseif up ~= nil then
      tile.type = "Center"
      Objects:setTileType2(up)
    elseif down ~= nil then
      tile.type = "TopCenter"
      Objects:setTileType2(down)
    else
      tile.type = "default"
    end
  end
end

function Objects:setTileType2(tile, tile2, tile3, tile4)

  if tile ~= nil then
    up = Objects:getTile(tile.x+2, tile.y-2)
    down = Objects:getTile(tile.x+2, tile.y+66)
    left = Objects:getTile(tile.x-2, tile.y+2)
    right = Objects:getTile(tile.x+66, tile.y+2)

    if up ~= nil and left ~= nil and right ~= nil and down ~= nil then
      tile.type = "Center"
    elseif up ~= nil and left ~= nil and down ~= nil then
      tile.type = "Center"
    elseif up ~= nil and right ~= nil and down ~= nil then
      tile.type = "Center"
    elseif up ~= nil and right ~= nil and left ~= nil then
      tile.type = "Center"
    elseif left ~= nil and right ~= nil and down ~= nil then
      tile.type = "TopCenter"
    elseif left ~= nil and right ~= nil then
      tile.type = "TopCenter"
    elseif left ~= nil and up ~= nil then
      tile.type = "Center"
    elseif right ~= nil and down ~= nil then
      tile.type = "TopLeft"
    elseif right ~= nil and up ~= nil then
      tile.type = "Center"
    elseif left ~= nil and down ~= nil then
      tile.type = "TopRight"
    elseif left ~= nil then
      tile.type = "CliffRight"
    elseif right ~= nil then
      tile.type = "CliffLeft"
    elseif up ~= nil then
      tile.type = "Center"
    elseif down ~= nil then
      tile.type = "TopCenter"
    else
      tile.type = "default"
    end
  end
  if tile4 ~= nil then
    Objects:setTileType2(tile2, tile3, tile4)
  elseif tile3 ~= nil then
    Objects:setTileType2(tile2, tile3)
  elseif tile2 ~= nil then
    Objects:setTileType2(tile2)
  end
end

function Objects:getTile(x, y)
  for i=1, #Objects.tiles do
    tile = Objects.tiles[i]
    if pointInObject(x, y, tile) then
      return tile
    end
  end
end

function Objects:getTileIndex(x, y)
  for i=1, #Objects.tiles do
    tile = Objects.tiles[i]
    if pointInObject(x, y, tile) then
      return i
    end
  end
end

function Objects:drawTiles()

  for i=1, #Objects.tiles do
    tile = Objects.tiles[i]
    love.graphics.draw(tile.images[tile.type], tile.x, tile.y, 0, tile.scale)
  end

end

function pointInObject(x, y, o)
  if o ~= nil then
    return x < o.x+64 and
           x >= o.x and
           y < o.y+64 and
           y >= o.y
  else
    return false
  end
end
