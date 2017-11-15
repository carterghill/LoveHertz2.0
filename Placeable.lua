require("UI/UI")
require("entities/Enemy")

Placeables = {

  tiles = {},
  enemies = {},
  decorative = {},
  index = 1,
  currentSet = "tiles"


}

Decorative = {
  set = {}
}

function Decorative:draw()
  for i=1, #Decorative.set do
    local x = Decorative.set[i].x - Cameras:current().x
    local y = Decorative.set[i].y - Cameras:current().y
    love.graphics.draw(Decorative.set[i].img, x, y)
  end
end

function Placeables:newTile(folder)

  Placeables.tiles[#Placeables.tiles+1] = {
    images = loadImagesInFolder(folder),
    folder = folder
  }
end

function Placeables:onClick(x,y,button)

  if button == 1 and Placeables.currentSet == "decorative" and not gooi.clicked then

    Decorative.set[#Decorative.set+1] = {img = Placeables.decorative.images[Placeables.index],
          x = x - Placeables.decorative.images[Placeables.index]:getWidth()/2 + Cameras:current().x,
          y = y - Placeables.decorative.images[Placeables.index]:getHeight()/2 + Cameras:current().y,
          imagePath = "images/decorative/"..Placeables.decorative.names[Placeables.index]
    }
    slowdowns = #Decorative.set
  end
end

function Placeables:load()
  Placeables:newTile("tiles/default/grass")
  Placeables:newTile("tiles/default/grass2")
  Placeables:newTile("tiles/one-way/grass")
  local dir = getFoldersInFolder("images/enemies")
  for i=1, #dir do
    local enemy = Enemy:new(dir[i],"images/enemies/"..dir[i], 1)
    Placeables.enemies[#Placeables.enemies+1] = enemy
  end
  Placeables.decorative = { images = loadImagesInFolder("images/decorative"),
                            names = getFilesInFolder("images/decorative")}
end

function Placeables:getTile()
  if Placeables.currentSet == "decorative" then
    return Placeables.decorative.images[Placeables.index]
  else
    return Placeables[Placeables.currentSet][Placeables.index]
  end
end

function Placeables:draw()

  if --[[UI:mouseOn() or]] not EditModeUI.display then
    return
  end

  x, y = love.mouse.getPosition()

  love.graphics.setColor( 255, 255, 255, 125 )
--  if placeable == "Tile" then

    --x = x - ((x + cameras[cameraNum].x) % 64)
    --y = y - ((y + cameras[cameraNum].y) % 64)


    --local scale = 64/placeableTiles[placeableTileNum].img:getWidth()

    --love.graphics.draw(placeableTiles[placeableTileNum].img, x, y, 0, scale)

  --elseif placeable == "Enemy" then
  --  love.graphics.draw(placeableEnemies[placeableEnemyNum].img, x - placeableEnemies[placeableEnemyNum].img:getWidth()/2, y
    --      - placeableEnemies[placeableEnemyNum].img:getHeight()/2)

  --elseif placeable == "Static" then
    --love.graphics.draw(placeableStatic[placeableStaticNum].img, x - placeableStatic[placeableStaticNum].img:getWidth()/2, y
    --      - placeableStatic[placeableStaticNum].img:getHeight()/2)
  --end
  if Placeables:getTile() ~= nil then
    local tile = Placeables:getTile()

    if tile.images == nil then
      if tile.defaultImage == nil then
        img = tile
      else
        img = tile.defaultImage
      end
      sc = 1
    else
      img = tile.images[1]
      sc = 64/img:getWidth()
    end
    x = x - img:getWidth()/2
    y = y - img:getHeight()/2
    love.graphics.draw(img, x, y, 0, sc)
  end

  love.graphics.setColor( 255, 255, 255, 255 )

end

function loadImagesInFolder(folder)

	-- Get every image name in the given folder
	imageNames = getFilesInFolder(folder)
	images = {}

	-- Load every image into a new array
	i = 1
	while (i <= #imageNames) do
		-- I ADDED IFS TO MAKE SURE EACH FILE WAS AN IMAGE
		if string.find(imageNames[i], ".png") or string.find(imageNames[i], ".jpg")
		or string.find(imageNames[i], ".gif") then
			images[i] = love.graphics.newImage(folder.."/"..imageNames[i])
			images[i]:setFilter("nearest", "nearest")
			i = i + 1
    else
			-- IF INDEX IS NOT IMAGE, REMOVE AND TRY INDEX AGAIN
			table.remove(imageNames, i)
		end
	end

	return images

end

function getFoldersInFolder(folder)

	folders = {}
	files = love.filesystem.getDirectoryItems(folder)
	for i=1, #files do
    -- If string does not contain a dot, it is a folder
		if not string.find(files[i], "%.") then
      table.insert(folders, files[i])
    end
	end

	return folders

end

-- Loops files in a folder and returns their names
function getFilesInFolder(path)

	local x = love.filesystem.getDirectoryItems(path)
	files = {}
	for k, file in ipairs(x) do
		files[k] = file
	end

	i = 1
	while (i <= #files) do
		i = i + 1
	end

	return files

end
