require "gooi"

PauseUI = {
  index = 1,
  elements = {},
  img = love.graphics.newImage('images/PauseBackground.png'),
  paused = false
}

function PauseUI:draw()

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    local scale_x = 0.4*(love.graphics.getHeight()/720)
    local scale_y = 0.32*(love.graphics.getHeight()/720)

    if self.paused then
        love.graphics.setColor(0, 0, 0, 100)
        love.graphics.rectangle("fill", 0,0,love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(self.img, sw*0.33, sh*0.05, 0, scale_x, scale_y)
        gooi.draw('pause')
    end
    
end
