Background = {}

function Background:new(folder)

  b = {
    images = {}
  }

  b.images = loadImagesInFolder(folder)

  function b:sort()

    local ratios = {}
    for i=1, #self.images do
      ratios[i] = self.images[i]:getWidth()/self.images[i]:getHeight()
    end

    for i=2, #self.images do
      for j=1, i-1 do
        if ratios[i] < ratios[i-j] then
          --swap
          local tempRatio = ratios[i]
          local tempImg = self.images[i]

          ratios[i] = ratios[i-j]
          self.images[i] = self.images[i-j]

          ratios[i-j] = tempRatio
          self.images[i-j] = tempImg

        end
      end
    end

  end

  b:sort()

  function b:draw()
    for i=1, #self.images do
      love.graphics.setColor(255-((i-1)*200),255-((i-1)*200),255-((i-1)*200),255)
      local cam = Cameras:current()
      local s = globalScale*((720/self.images[i]:getHeight()))
      if cam ~=nil then
        if i ~= 1 then
          local ratio = self.images[i]:getWidth()/self.images[i]:getHeight()
          local x = (-cam.x)%self.images[i]:getWidth()*s
          local x2 = x - self.images[i]:getWidth()*s
          love.graphics.draw(self.images[i], x, 0, 0, s)
          love.graphics.draw(self.images[i], x2, 0, 0, globalScale*((720/self.images[i]:getHeight())))
        else
          love.graphics.draw(self.images[i], 0, 0, 0, globalScale*((720/self.images[i]:getHeight())))
        end
      end
      love.graphics.setColor(255,255,255,255)
    end
  end

  return b

end
