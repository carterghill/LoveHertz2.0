Menu = {}

function Menu:load()

  self.groups = {"main", "levels"}
  self.scale = love.graphics.getHeight()/720
  self.titleFont = love.graphics.newFont( "fonts/CuteFont-Regular.ttf", 124*self.scale)

end

function Menu:update()
  if love.keyboard.isDown("space") then
    inGame = true
  end
end

function Menu:draw()

  love.graphics.setFont(self.titleFont)
  love.graphics.printf("Beatboy", 0, 0, love.graphics.getWidth(), "center")
  love.graphics.printf("and", 0, 100*self.scale, love.graphics.getWidth(), "center")
  love.graphics.printf("Melody", 0, 200*self.scale, love.graphics.getWidth(), "center")
  love.graphics.setFont(love.graphics.newFont(12))

end

function Menu:reset()

  self.scale = love.graphics.getHeight()/720
  self.titleFont = love.graphics.newFont( "fonts/CuteFont-Regular.ttf", 124*self.scale)

end


---------------------------------------------
---- Menu Button (Different Than Gooi) -----
---------------------------------------------


MenuButton = {}

function MenuButton:new()



end
