Debug = {}

function Debug:load()

    -- Logs will be a list of strings to output by the debug
    self.logs = {}
    self.visible = true
    self.logs[#self.logs+1] = "hi"
    self.logs[#self.logs+1] = "hi2"

    for i=1, 20 do
        self.logs[#self.logs+1] = tostring(i)
    end

end

function Debug:draw()

    w = love.graphics.getWidth()
    h = love.graphics.getHeight()

    if self.visible then

        -- Draw a grey, semi-tanslucent rectangle in the bottom right
        love.graphics.setColor(100, 100, 100, 100)
        love.graphics.rectangle("fill", w*0.75, h*0.75, w*0.24, h*0.24)
        love.graphics.setColor(255, 255, 255, 255)

        for i=1, #self.logs do
            if h-(i*12) > h*0.75 then
                love.graphics.print(self.logs[i], w*0.76, h*0.98 - (i*12))
            else
                break
            end
        end

    end

end
