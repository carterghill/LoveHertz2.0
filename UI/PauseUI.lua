require "gooi"

PauseUI = {
    index = 1,
    elements = {},
    img = love.graphics.newImage('images/PauseBackground.png'),
    paused = false
}

function PauseUI:load()

    local s = globalScale
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    self.elements[1] = {}

end

function PauseUI:draw()

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    local scale_x = 0.4*(love.graphics.getWidth()/1280)
    local scale_y = 0.32*(love.graphics.getHeight()/720)

    if self.paused then
        love.graphics.setColor(0, 0, 0, 100)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(self.img, sw*0.33, sh*0.05, 0, scale_x, scale_y)
        gooi.draw('pause')
    end

end

function PauseUI:pause()

    if self.paused then
        self.paused = false
        if PlayerUI.display then
            gooi.setGroupVisible("player", true)
        elseif EditModeUI.display then
            gooi.setGroupVisible("edit_mode", true)
        end
    else
        gooi.setGroupVisible("edit_mode", false)
        gooi.setGroupVisible("player", false)
        self.paused = true
    end

end
