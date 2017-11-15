require("Tserial")

Level = {}

function Level:new(t, p, n)

  l = {

    name = n or "Untitled Level",
    tiles = t,
    players = p,
    x = 0,
    y = 0

  }

  function l:setStart(x, y)
    l.x = x
    l.y = y
  end

  function l:save(name)
    save = {
      name = name or "Untitled",
      tiles = {},
      players = {},
      startx = l.x,
      starty = l.y,
      x = 0,
      y = 0
    }

    if l.players ~= nil then
      save.x = l.players.x
      save.y = l.players.y
    end

    for i=1, #Tiles.set do
      t = {
        x = Tiles.set[i].x,
        y = Tiles.set[i].y,
        type = Tiles.set[i].type,
        folder = Tiles.set[i].folder,
        index = Tiles.set[i].index
      }
      table.insert(save.tiles, t)

    end


    for i=1, #l.players do
      save.players[i] = "images/traveler"
    end
    save.players[1] = "images/traveler"
    if love.filesystem.isDirectory("My Levels") then
      love.filesystem.write( "My Levels/"..save.name, Tserial.pack(save, {}, false) )
    else
      love.filesystem.createDirectory("My Levels")
      love.filesystem.write( "My Levels/"..save.name, Tserial.pack(save, {}, false) )
    end
  end

  function l:load(name)
    if name == nil then
	     if love.filesystem.exists("save.txt") then
         save = Tserial.unpack(love.filesystem.read("save.txt"))
	     else
		       return
	     end
    else
      if love.filesystem.exists("My Levels/"..name) then
        save = Tserial.unpack(love.filesystem.read("My Levels/"..name))
      else
        return
      end
    end
    --tileNum = "\n"..tostring(save.tiles.x)
    --for key,value in pairs(save.tiles) do tileNum = "\n"..tileNum..key..": "..tostring(value) end
    self.name = save.name
    self.tiles = {}
    self.players = {}

    --tileNum = "\nTiles Present: ".. #Tiles.set
    Tiles.set = {}
    --tileNum = tileNum.."\nAfter Delete: ".. #Tiles.set

    --tileNum = "\nSaved Tiles: "..#save.tiles
    debug = #save.tiles
    for i=1, #save.tiles do
      Placeables.index = save.tiles[i].index
      Tiles:placeAlways(save.tiles[i].x - (Cameras:current().x or 0)+1, save.tiles[i].y - (Cameras:current().y or 0) +1 )
      debug = debug..", "..tostring(#Tiles.set)
      --Tiles.set[#Tiles.set].type = save.tiles[i].type
    end

    for i=1, #save.players do
      l.players = Player:create(save.players[i])
    end
    l.players.x = save.x
    l.players.y = save.y
  end

  return l

end
