require "gooi"

PauseUI = {
    index = 1,
    elements = {},
    img = love.graphics.newImage('images/PauseBackground.png'),
    paused = false
}

function PauseUI:load()

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local s = h/720

    self.elements[1] = gooi.newButton({text = "Toggle Edit", x = (w/3)+24, y = 110*s, w = (w/3)-24, h = 48*s})
      --:setIcon(imgDir.."coin.png"):danger()
      :setTooltip("Turn Edit Mode on or off")
      :onRelease(function()
          EditModeUI:toggle()
      end)
      :setGroup('pause')

end

function PauseUI:draw()

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    local scale_x = 0.54*(love.graphics.getWidth()/1280)
    local scale_y = 0.32*(love.graphics.getHeight()/720)

    if self.paused then
        love.graphics.setColor(0, 0, 0, 100)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(self.img, sw*0.29, sh*0.05, 0, scale_x, scale_y)
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
