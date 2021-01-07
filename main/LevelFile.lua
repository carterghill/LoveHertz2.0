require("main/Level")
require("main/Debug")

LevelFile = {}

function LevelFile:load(location)

  lvl = {}

  if location:match("^.+(%..+)$") == ".lvl" then

    success = love.filesystem.mount("testzip.lvl", "CustomLevel")
    print(success)

    imgtypes = {".png", ".gif", ".jpg", ".jpe", ".jpeg", ".bmp"}
    for k, v in pairs(imgtypes) do
      if love.filesystem.exists("CustomLevel/testzip/icon"..v) then
        lvl.icon = love.graphics.newImage("CustomLevel/testzip/icon"..v)
        Debug:log("icon found")
      end
    end

    --lvl.map = Tserial.unpack(love.filesystem.read("level/default.txt"))
    if love.filesystem.exists("CustomLevel/testzip/default.txt") then
        Debug:log("Exists")
    else
        Debug:log("Does not exist")
    end

    inGame = true

  end

  lvl.location = location

  --function lvl:load()
    Placeables:loadCustom()
    l:load("CustomLevel/testzip/default.txt")

  --end

  return lvl

end
