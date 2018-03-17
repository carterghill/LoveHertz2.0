Debug = {}

function Debug:load()

    -- Logs will be a list of strings to output by the debug
    self.logs = {}
    self.visible = true

end

function Debug:draw()

    w = love.graphics.getWidth()
    h = love.graphics.getHeight()

    if self.visible then

        love.graphics.setColor(100, 100, 100, 100)
        love.graphics.rectangle("fill", w*0.75, h*0.75, w-12, h-12)
        love.graphics.setColor(255, 255, 255, 255)

    end

end
