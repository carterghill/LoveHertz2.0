require("Level")
require("Debug")

LevelFile = {}

function LevelFile:load(location)

  lvl = {}

  if location:match("^.+(%..+)$") == ".lvl" then

    success = love.filesystem.mount(location, "level")
    Debug:log(love.filesystem.exists("level/icon.png"))
    Debug:log(success)

    imgtypes = {".png", ".gif", ".jpg", ".jpe", ".jpeg", ".bmp"}
    for k, v in pairs(imgtypes) do
      if love.filesystem.exists("level/icon"..v) then
        lvl.icon = love.graphics.newImage("level/icon"..v)
      end
    end

    lvl.map = Tserial.unpack(love.filesystem.read("level/default.txt"))

  end

  lvl.location = location

  function lvl:load()
    l:load(location)
  end

  return lvl

end
