require("Cameras")
require("Tile")

Tiles = {
  set = {}
}

function Tiles:place(x, y)

  --tile = Tiles:getTileIndex(x, y)
  if EditModeUI.display and not gooi.clicked then
    --table.remove(Tiles.set, tile)

    Tiles:remove(x, y)

    t = Tile:new(x, y)
    table.insert(Tiles.set, t)



    Tiles:setTileType(Tiles.set[#Tiles.set])
  end
end

function Tiles:placeAlways(x, y)

  --tile = Tiles:getTileIndex(x, y)
  --if EditModeUI.display and not gooi.clicked then
    --table.remove(Tiles.set, tile)

    Tiles:remove(x, y)

    t = Tile:new(x, y)
    table.insert(Tiles.set, t)



    Tiles:setTileType(Tiles.set[#Tiles.set])
  --end
end

function Tiles:getY(i)
  return Tiles.set[i].y
end

function Tiles:remove(x, y)

  x = (x or love.mouse.getX())
  y = (y or love.mouse.getY())

  cam = Cameras:current()
  if cam ~= nil then
    x = x + cam.x
    y = y + cam.y
  end

  tile = Tiles:getTileIndex(x, y)
  if tile ~= nil then
    table.remove(Tiles.set, tile)
  end

  up = Tiles:get(x, y-64)
  down = Tiles:get(x, y+64)
  left = Tiles:get(x-64, y)
  right = Tiles:get(x+64, y)

  Tiles:setTileType(up, down, left, right)

end

function Tiles:setTileType(tile)

  if tile ~= nil and tile.objType == "tile" then
    up = Tiles:get(tile.x+2, tile.y-2)
    down = Tiles:get(tile.x+2, tile.y+66)
    left = Tiles:get(tile.x-2, tile.y+2)
    right = Tiles:get(tile.x+66, tile.y+2)


    if up ~= nil and left ~= nil and right ~= nil and down ~= nil then
      tile.type = "Center"
      Tiles:setTileType2(left, right, up, down)
    elseif up ~= nil and left ~= nil and down ~= nil then
      tile.type = "Center"
      Tiles:setTileType2(left, up, down)
    elseif up ~= nil and right ~= nil and down ~= nil then
      tile.type = "Center"
      Tiles:setTileType2(right, up, down)
    elseif up ~= nil and right ~= nil and left ~= nil then
      tile.type = "TopCenter"
      Tiles:setTileType2(right, up, left)
      if Tiles:get(tile.x-2, tile.y-2) ~= nil or Tiles:get(tile.x+66, tile.y-2) ~= nil then
        tile.type = "Center"
      end
    elseif left ~= nil and right ~= nil and down ~= nil then
      tile.type = "TopCenter"
      Tiles:setTileType2(right, left, down)
    elseif left ~= nil and right ~= nil then
      tile.type = "TopCenter"
      Tiles:setTileType2(right, left)
    elseif left ~= nil and up ~= nil then
      tile.type = "Center"
      Tiles:setTileType2(up, left)
    elseif right ~= nil and down ~= nil then
      tile.type = "TopLeft"
      Tiles:setTileType2(right, down)
    elseif right ~= nil and up ~= nil then
      tile.type = "Center"
      Tiles:setTileType2(right, up)
    elseif up ~= nil and down ~= nil then
      tile.type = "Center"
      Tiles:setTileType2(down, up)
    elseif left ~= nil and down ~= nil then
      tile.type = "TopRight"
      Tiles:setTileType2(left, down)
    elseif left ~= nil then
      tile.type = "CliffRight"
      Tiles:setTileType2(left)
    elseif right ~= nil then
      tile.type = "CliffLeft"
      Tiles:setTileType2(right)
    elseif up ~= nil then
      tile.type = "Center"
      Tiles:setTileType2(up)
    elseif down ~= nil then
      tile.type = "TopCenter"
      Tiles:setTileType2(down)
    else
      tile.type = "default"
    end
  elseif tile ~= nil and tile.objType == "one-way" then

    left = Tiles:get(tile.x-2, tile.y+2)
    right = Tiles:get(tile.x+66, tile.y+2)

    if left ~= nil and right ~= nil then
      tile.type = "Mid"
      Tiles:setTileType2(right, left)
    elseif left ~= nil then
      tile.type = "Right"
      Tiles:setTileType2(left)
    elseif right ~= nil then
      tile.type = "Left"
      Tiles:setTileType2(right)
    end

  end
end

function Tiles:setTileType2(tile, tile2, tile3, tile4)

  if tile ~= nil and tile.objType == "tile" then
    up = Tiles:get(tile.x+2, tile.y-2)
    down = Tiles:get(tile.x+2, tile.y+66)
    left = Tiles:get(tile.x-2, tile.y+2)
    right = Tiles:get(tile.x+66, tile.y+2)

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
  elseif tile ~= nil and tile.objType == "one-way" then

    left = Tiles:get(tile.x-2, tile.y+2)
    right = Tiles:get(tile.x+66, tile.y+2)

    if left ~= nil and right ~= nil then
      tile.type = "Mid"
    elseif left ~= nil then
      tile.type = "Right"
    elseif right ~= nil then
      tile.type = "Left"
    end

  end
  if tile4 ~= nil then
    Tiles:setTileType2(tile2, tile3, tile4)
  elseif tile3 ~= nil then
    Tiles:setTileType2(tile2, tile3)
  elseif tile2 ~= nil then
    Tiles:setTileType2(tile2)
  end
end

function Tiles:get(x, y)
  for i=1, #Tiles.set do
    tile = Tiles.set[i]
    if pointInObject(x, y, tile) then
      return tile
    end
  end
end

function Tiles:getTileIndex(x, y)
  for i=1, #Tiles.set do
    tile = Tiles.set[i]
    if pointInObject(x, y, tile) then
      return i
    end
  end
end

function Tiles:draw()

  for i=1, #Tiles.set do
    tile = Tiles.set[i]

    x = tile.x
    y = tile.y

    cam = Cameras:current()
    if cam ~= nil then
      x = x - cam.x
      y = y - cam.y
    end

    love.graphics.draw(tile.images[tile.type], x*globalScale, y*globalScale, 0, tile.scale*globalScale)
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
