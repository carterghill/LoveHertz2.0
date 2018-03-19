require "gooi"

PauseUI = {
    index = 1,
    elements = {},
    settings = {},
    img = love.graphics.newImage('images/PauseBackground.png'),
    paused = false,
    group = "pause"
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

    self.elements[2] = gooi.newButton({text = "Settings", x = (w/3)+24, y = 166*s, w = (w/3)-24, h = 48*s})
        --:setIcon(imgDir.."coin.png"):danger()
        :setTooltip("Turn Edit Mode on or off")
        :onRelease(function()
            self.group = "pause_settings"
            gooi.setGroupVisible("pause_settings", true)
            gooi.setGroupVisible("pause", false)
        end)
        :setGroup('pause')

    self.elements[3] = gooi.newButton({text = "Quit Game", x = (w/3)+24, y = 580*s, w = (w/3)-24, h = 48*s})
        :setIcon():danger()
        :setTooltip("Exit the program")
        :setGroup('pause')
        :onRelease(function()
            gooi.confirm({
                text = "Are you sure you\nwant to quit?",
                ok = function()
                    love.event.quit()
                end
            })
        end)

    self.settings[1] = gooi.newButton({text = "Toggle Debug Console", x = (w/3)+24, y = 110*s, w = (w/3)-24, h = 48*s})
        --:setIcon(imgDir.."coin.png"):danger()
        :setTooltip("Turn Edit Mode on or off")
        :onRelease(function()
            Debug:toggle()
        end)
        :setGroup('pause_settings')

    self.settings[2] = gooi.newButton({text = "Back", x = (w/3)+24, y = 580*s, w = (w/3)-24, h = 48*s})
        --:setIcon(imgDir.."coin.png"):danger()
        :setTooltip("Go back to the main pause screen")
        :onRelease(function()
          self.group = "pause"
          gooi.setGroupVisible("pause_settings", false)
          gooi.setGroupVisible("pause", true)
        end)
        :setGroup('pause_settings')

    self.settings[3] = gooi.newButton({text = "Fullscreen", x = (w/3)+24, y = 166*s, w = (w/3)-24, h = 48*s})
        :setTooltip("Turn fullscreen on or off")
        :onRelease(function()
            if love.window.getFullscreen() then
                love.window.setFullscreen( false )
            else
                love.window.setFullscreen( true )
            end

        end)
        :setGroup('pause_settings')

end

function PauseUI:empty()
    for i=1, #self.elements do
        gooi.removeComponent(self.elements[i])
    end
    for i=1, #self.settings do
        gooi.removeComponent(self.settings[i])
    end
    self.elements = {}
    self.settings = {}
end

function PauseUI:reset()
    PauseUI:empty()
    PauseUI:load()

    self.group = "pause"
    gooi.setGroupVisible("pause_settings", false)
    gooi.setGroupVisible("pause", true)
end

function PauseUI:draw()

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    local scale_x = 0.545*(love.graphics.getWidth()/1280)
    local scale_y = 0.32*(love.graphics.getHeight()/720)

    if self.paused then
        love.graphics.setColor(0, 0, 0, 100)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(self.img, sw*0.29, sh*0.05, 0, scale_x, scale_y)
        gooi.draw(self.group)
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
        self.group = 'pause'
        gooi.setGroupVisible("pause", true) -- Reset to main pause menu
        gooi.setGroupVisible("edit_mode", false)
        gooi.setGroupVisible("player", false)
        self.paused = true
    end

end
