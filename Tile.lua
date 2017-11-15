Tile = {}

function Tile:new(x, y, type)

  x = (x or love.mouse.getX())
  y = (y or love.mouse.getY())

  cam = Cameras:current()
  if cam ~= nil then
    x = x + cam.x
    y = y + cam.y
  end

  x = x*globalScale
  y = y*globalScale

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
  if #t.images > 5 then
    armages = {}
    armages["default"] = t.images[1]
    armages["Center"] = t.images[2]
    armages["CliffLeft"] = t.images[3]
    armages["CliffRight"] = t.images[4]
    armages["TopLeft"] = t.images[5]
    armages["TopCenter"] = t.images[6]
    armages["TopRight"] = t.images[7]
  else
    armages = {}
    armages["default"] = t.images[1]
    armages["Left"] = t.images[2]
    armages["Mid"] = t.images[3]
    armages["Right"] = t.images[4]
  end

  tile = {
    images = armages,
    type = type or "default",
    x = placex,
    y = placey,
    width = 64,
    height = 64,
    scale = 64 / Placeables:getTile().images[1]:getWidth(),
    folder = t.folder,
    index = Placeables.index
  }

  if #t.images <= 5 then
    tile.objType = "one-way"
  else
    tile.objType = "tile"
  end

  return tile

end
