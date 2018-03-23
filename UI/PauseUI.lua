require "gooi"

PauseUI = {
    cursor = 1,
    elements = {},
    settings = {},
    level = {},
    img = love.graphics.newImage('images/PauseBackground.png'),
    paused = false,
    group = "pause",
    clickTime = 0
}

function PauseUI:load(visible)

    visible = visible or false

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local s = h/720

    self.elements[1] = gooi.newButton({text = "Return to Game", x = (w/3)+24, y = 110*s, w = (w/3)-24, h = 48*s})
      --:setIcon(imgDir.."coin.png"):danger()
      --:setTooltip("Turn Edit Mode on or off")
      :onRelease(function()
          self:pause()
      end)
      :setGroup('pause')

    self.elements[2] = gooi.newButton({text = "Toggle Edit", x = (w/3)+24, y = 194*s, w = (w/3)-24, h = 48*s})
      --:setIcon(imgDir.."coin.png"):danger()
      --:setTooltip("Turn Edit Mode on or off")
      :onRelease(function()
          EditModeUI:toggle()
          self:pause()
      end)
      :setGroup('pause')

    self.elements[3] = gooi.newButton({text = "Settings", x = (w/3)+24, y = 250*s, w = (w/3)-24, h = 48*s})
        :onRelease(function()
            self.group = "pause_settings"
            gooi.setGroupVisible("pause_settings", true)
            gooi.setGroupVisible("pause", false)
            self.cursor = 1
        end)
        :setGroup('pause')

    self.elements[4] = gooi.newButton({text = "Load/Save Level", x = (w/3)+24, y = 306*s, w = (w/3)-24, h = 48*s})
        :setGroup('pause')
        :onRelease(function()
            self.group = "pause_level"
            gooi.setGroupVisible("pause_settings", false)
            gooi.setGroupVisible("pause", false)
            gooi.setGroupVisible("pause_level", true)
            self.cursor = 1
        end)

    self.elements[5] = gooi.newButton({text = "Quit Game", x = (w/3)+24, y = 580*s, w = (w/3)-24, h = 48*s})
        :setIcon():danger()
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
        --:setTooltip("Turn Edit Mode on or off")
        :onRelease(function()
            Debug:toggle()
        end)
        :setGroup('pause_settings')

    self.settings[3] = gooi.newButton({text = "Back", x = (w/3)+24, y = 580*s, w = (w/3)-24, h = 48*s})
        --:setIcon(imgDir.."coin.png"):danger()
        --:setTooltip("Go back to the main pause screen")
        :onRelease(function()
          self.group = "pause"
          gooi.setGroupVisible("pause_settings", false)
          gooi.setGroupVisible("pause", true)
        end)
        :setGroup('pause_settings')



    self.settings[2] = gooi.newButton({text = "Fullscreen", x = (w/3)+24, y = 166*s, w = (w/3)-24, h = 48*s})
        --:setTooltip("Turn fullscreen on or off")
        :onRelease(function()
            if love.window.getFullscreen() then
                love.window.setFullscreen( false )
            else
                love.window.setFullscreen( true )
            end
            gooi.setGroupVisible("pause_settings", true)
        end)
        :setGroup('pause_settings')

    self.txt = gooi.newText({y = 180*s, x = (w/3)+24, w = (w/3)-24, h = 64*s}):setText("")
    self.txt:setGroup("pause_level")

    self.nextbtn = gooi.newButton({text = ">", x = (w/2)+24, y = 260*s, w = (w/6)-24, h = 48*s})
        --:setIcon(imgDir.."coin.png")
        ----:setTooltip("Next in the list")
        :onRelease(function()
            local x = love.filesystem.getDirectoryItems("My Levels")
            local savedLevels = {}
            local current = 1
            for i=1, #x do
              if x[i] ~= ".DS_Store" and x[i] ~= ".DS_Store.txt" then
                local t = x[i]:gsub(".txt", "")
                table.insert(savedLevels, t)
                if t == self.txt:getText() then
                  current = #savedLevels
                end
              end
            end
            if #savedLevels == 0 then
              return
            end
            current = current + 1
            if current > #savedLevels then
              current = 1
            end
            local x = self.txt.x
            local y = self.txt.y
            local w = self.txt.w
            local h = self.txt.h
            --txt1.indexCursor = 1
            gooi.removeComponent(self.txt)
            if savedLevels[current] == nil then
              return
            end
            self.txt = gooi.newText({x = x, w = w, h = h, y = y}):setText(savedLevels[current]:gsub(".txt", ""))
            self.txt:setGroup("pause_level")
            --txt1:setText(savedLevels[current]:gsub(".txt", ""))
        end)
    self.nextbtn:setGroup("pause_level")

    local c = function()
        local x = love.filesystem.getDirectoryItems("My Levels")
        local savedLevels = {}
        local current = 1
        for i=1, #x do
          if x[i] ~= ".DS_Store" and x[i] ~= ".DS_Store.txt" then
            local t = x[i]:gsub(".txt", "")
            table.insert(savedLevels, t)
            if t == self.txt:getText() then
              current = #savedLevels
            end
          end
        end
        if #savedLevels == 0 then
          return
        end
        current = current - 1
        if current < 1 then
          current = #savedLevels
        end
        local x = self.txt.x
        local y = self.txt.y
        local w = self.txt.w
        local h = self.txt.h
        --txt1.indexCursor = 1
        gooi.removeComponent(self.txt)
        self.txt = gooi.newText({x = x, w = w, h = h, y = y}):setText(savedLevels[current]:gsub(".txt", ""))
        self.txt:setGroup("pause_level")
        --txt1:setText(savedLevels[current]:gsub(".txt", ""))
    end

    self.prevbtn = gooi.newButton({text = "<", x = (w/3)+24, y = 260*s, w = (w/6)-24, h = 48*s})
        --:setIcon(imgDir.."coin.png")
      --  --:setTooltip("previous in the list")
        :onRelease(c)
    self.prevbtn:setGroup("pause_level")

    self.savebtn = gooi.newButton({text = "Save", x = (w/3)+24, y = 324*s, w = (w/6)-24, h = 48*s})
        :setIcon(imgDir.."coin.png")
        :onRelease(function()
            gooi.confirm({
                text = "Save game as \""..txt1:getText().."\'?",
                ok = function()
                  local t = txt1:getText()..".txt"
                  l:save(t)
                end
            })
        end)
    self.savebtn:setGroup("pause_level")

    self.loadbtn = gooi.newButton({text = "Load", x = (w/2)+24, y = 324*s, w = (w/6)-24, h = 48*s})
        :setIcon(imgDir.."coin.png")
        :onRelease(function()
            gooi.confirm({
                text = "Load \""..txt1:getText().."\'?",
                ok = function()
                    l:load(txt1:getText()..".txt")
                end
            })
        end)
    self.loadbtn:setGroup("pause_level")

    self.level[1] = self.txt
    self.level[2] = self.prevbtn
    self.level[3] = self.savebtn

    self.level[4] = gooi.newButton({text = "Back", x = (w/3)+24, y = 580*s, w = (w/3)-24, h = 48*s})
            --:setIcon(imgDir.."coin.png"):danger()
            --:setTooltip("Go back to the main pause screen")
            :onRelease(function()
              self.group = "pause"
              gooi.setGroupVisible("pause_level", false)
              gooi.setGroupVisible("pause", true)
            end)
            :setGroup('pause_level')

    if not visible then
        gooi.setGroupVisible("pause", false)
        gooi.setGroupVisible("pause_settings", false)
        gooi.setGroupVisible("pause_level", false)
    end

end

function PauseUI:empty()
    for i=1, #self.elements do
        gooi.removeComponent(self.elements[i])
    end
    for i=1, #self.settings do
        gooi.removeComponent(self.settings[i])
    end
    for i=1, #self.level do
        gooi.removeComponent(self.level[i])
    end
    self.elements = {}
    self.settings = {}
    self.level = {}
end

function PauseUI:reset()

    visible = self.paused

    PauseUI:empty()
    PauseUI:load(visible)
end

function PauseUI:draw()

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    local scale_x = 0.545*(love.graphics.getWidth()/1280)
    local scale_y = 0.32*(love.graphics.getHeight()/720)

    if self.paused then

        local lg = love.graphics

        love.graphics.setColor(0, 0, 0, 200)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(self.img, sw*0.29, sh*0.05, 0, scale_x, scale_y)
        gooi.draw(self.group)

        love.graphics.setColor(255, 255, 255, 255)
        if self.group == "pause" then
            lg.rectangle("line", self.elements[self.cursor].x, self.elements[self.cursor].y,
                        self.elements[self.cursor].w, self.elements[self.cursor].h)
        elseif self.group == "pause_settings" then
            lg.rectangle("line", self.settings[self.cursor].x, self.settings[self.cursor].y,
                        self.settings[self.cursor].w, self.settings[self.cursor].h)
        elseif self.group == "pause_level" then
            lg.rectangle("line", self.level[self.cursor].x, self.level[self.cursor].y,
                        self.level[self.cursor].w, self.level[self.cursor].h)
        end

    else
        gooi.setGroupVisible("pause", false)
        gooi.setGroupVisible("pause_level", false)
        gooi.setGroupVisible("pause_settings", false)
    end

end

function PauseUI:down()
    if love.timer.getTime() - self.clickTime > 0.01 then
        -- Adding a click timer to prevent menu items for being pressed twice
        self.clickTime = love.timer.getTime()
        self.cursor = self.cursor + 1
        if self.group == "pause" then
            if self.cursor > #self.elements then
                self.cursor = 1
            end
        elseif self.group == "pause_settings" then
            if self.cursor > #self.settings then
                self.cursor = 1
            end
        elseif self.group == "pause_level" then
            if self.cursor > #self.level then
                self.cursor = 1
            end
        end
    end
end

function PauseUI:up()
    if love.timer.getTime() - self.clickTime > 0.01 then
        -- Adding a click timer to prevent skipping menu items
        self.clickTime = love.timer.getTime()
        self.cursor = self.cursor - 1
        if self.group == "pause" then
            if self.cursor < 1 then
                self.cursor = #self.elements
            end
        elseif self.group == "pause_settings" then
            if self.cursor < 1 then
                self.cursor = #self.settings
            end
        elseif self.group == "pause_level" then
            if self.cursor < 1 then
                self.cursor = #self.level
            end
        end
    end
end

function PauseUI:right()
    if love.timer.getTime() - self.clickTime > 0.01 then
        -- Adding a click timer to prevent skipping menu items
        self.clickTime = love.timer.getTime()
        if self.group == "pause_level" then
            if self.level[self.cursor] == self.prevbtn then
                self.level[self.cursor] = self.nextbtn
                self.level[self.cursor+1] = self.loadbtn
            elseif self.level[self.cursor] == self.nextbtn then
                self.level[self.cursor] = self.prevbtn
                self.level[self.cursor+1] = self.savebtn
            elseif self.level[self.cursor] == self.savebtn then
                self.level[self.cursor] = self.loadbtn
                self.level[self.cursor-1] = self.nextbtn
            elseif self.level[self.cursor] == self.loadbtn then
                self.level[self.cursor] = self.savebtn
                self.level[self.cursor-1] = self.savebtn
            end
        end
    end
end

function PauseUI:select()
    if love.timer.getTime() - self.clickTime > 0.1 then
        -- Adding a click timer to prevent menu items for being pressed twice
        self.clickTime = love.timer.getTime()
        if gooi.yesButton then
            gooi.yesButton.events:r()
            gooi.yesButton = nil
            gooi.noButton = nil
        elseif self.group == "pause" then
            self.elements[self.cursor].events:r()
            return
        elseif self.group == "pause_settings" then
            self.settings[self.cursor].events:r()
            return
        elseif self.group == "pause_level" then
            if self.cursor == 1 then
                gooi.pressed(1, self.txt.x+2, self.txt.y+2)
                gooi.released(1, self.txt.x+2, self.txt.y+2)
            else
                self.level[self.cursor].events:r()
            end
            return
        end
        --gooi.pressed(id, xt, yt)
    end
end

function PauseUI:deselect()
    if love.timer.getTime() - self.clickTime > 0.1 then
        -- Adding a click timer to prevent menu items for being pressed twice
        self.clickTime = love.timer.getTime()
        if gooi.noButton then
            gooi.noButton.events:r()
            gooi.yesButton = nil
            gooi.noButton = nil
        elseif self.group == "pause" then
            self:pause()
            return
        elseif self.group == "pause_settings" then
            self.group = "pause"
            gooi.setGroupVisible("pause_settings", false)
            gooi.setGroupVisible("pause", true)
            return
        elseif self.group == "pause_level" then
            self.group = "pause"
            gooi.setGroupVisible("pause_level", false)
            gooi.setGroupVisible("pause", true)
            return
        end
    end
end

function PauseUI:pause()

    if self.paused then

        gooi.setGroupVisible("pause", false)
        gooi.setGroupVisible("pause_settings", false)
        self.paused = false
        gooi.yesButton = nil
        gooi.noButton = nil

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
