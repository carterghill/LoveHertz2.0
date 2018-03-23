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
  local s = getZoom(globalScale)
  for i=1, #Decorative.set do
    local x = Decorative.set[i].x - Cameras:current().x
    local y = Decorative.set[i].y - Cameras:current().y
    love.graphics.draw(Decorative.set[i].img, x*s, y*s, 0, s)
  end
end

function Placeables:newTile(folder)

  Placeables.tiles[#Placeables.tiles+1] = {
    images = loadImagesInFolder(folder),
    folder = folder
  }
end

function Placeables:onClick(x,y,button)

  x = x/getZoom(globalScale) + Cameras:current().x
  y = y/getZoom(globalScale) + Cameras:current().y

  if button == 1 and Placeables.currentSet == "decorative" and not EditModeUI:overIt(x, y) and EditModeUI.tool == "place" and not UI:clicked() then

    Decorative.set[#Decorative.set+1] = {img = Placeables.decorative.images[Placeables.index],
          x = x - Placeables.decorative.images[Placeables.index]:getWidth()/2,
          y = y - Placeables.decorative.images[Placeables.index]:getHeight()/2,
          imagePath = "images/decorative/"..Placeables.decorative.names[Placeables.index]
    }
    slowdowns = #Decorative.set
  elseif (button == 2 or EditModeUI.tool == "delete") and not EditModeUI:overIt(x, y) then
    for i=#en.enemies, 1, -1 do
      if x < en.enemies[i].x + en.enemies[i].width and x > en.enemies[i].x then
        if y < en.enemies[i].y + en.enemies[i].width and y > en.enemies[i].y then
          table.remove(en.enemies, i)
          return
        end
      end
    end
    for i=#Decorative.set, 1, -1 do
      if x < Decorative.set[i].x + Decorative.set[i].img:getWidth() and x > Decorative.set[i].x then
        if y < Decorative.set[i].y + Decorative.set[i].img:getHeight() and y > Decorative.set[i].y then
          table.remove(Decorative.set, i)
          return
        end
      end
    end
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

  if EditModeUI.display and EditModeUI.tool == "place" then

    x, y = love.mouse.getPosition()

    love.graphics.setColor( 255, 255, 255, 125 )
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
      x = x - img:getWidth()/2*getZoom()
      y = y - img:getHeight()/2*getZoom()
      love.graphics.draw(img, x, y, 0, sc*getZoom())
    end

  love.graphics.setColor( 255, 255, 255, 255 )
  
  end
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
			--images[i]:setFilter("nearest", "nearest")
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
