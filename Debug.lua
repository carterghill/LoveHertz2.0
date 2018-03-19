Debug = {}

function Debug:load()

    -- Logs will be a list of strings to output by the debug
    self.logs = {}
    self.visible = false
    self.x = 12
    self.y = love.graphics.getHeight()*0.75

    self.logs[#self.logs+1] = "Debug console initialized!"

end

function Debug:draw()

    w = love.graphics.getWidth()
    h = love.graphics.getHeight()

    if self.visible then

        -- Draw a grey, semi-tanslucent rectangle in the bottom right
        love.graphics.setColor(0, 0, 0, 125)
        love.graphics.rectangle("fill", self.x, self.y, w*0.24, h*0.24)
        love.graphics.setColor(255, 255, 255, 255)

        -- Get number of lines to be drawn by height of the console
        lines = ((h-self.y)/12)-1

        for i=1, lines do
            local y = lines - i
            if #self.logs > i then
                love.graphics.print(self.logs[i], self.x+6, (h*0.75)+(y*12))
            else
                break
            end
        end

    end

end

-- Store string s in the logs
function Debug:log(s)
    table.insert(self.logs, 1, s)
end

function Debug:reset()
    self.x = 12
    self.y = love.graphics.getHeight()*0.75
end

function Debug:toggle()
    self.visible = not self.visible
end
