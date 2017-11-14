UIGroup = {}

function UIGroup:new()

  g = {
    elements = {},
    display = true,
    thread = love.thread.newThread("runFunction.lua"),
    input = false
  }

  function g:toggle()
    if self.display then
      self.display = false
      love.keyboard.setKeyRepeat(false)
    else
      self.display = true
      love.keyboard.setKeyRepeat(true)
    end
  end

  function  g:add(e)
    table.insert(self.elements, e)
  end

  function  g:draw()
    if self.display then
      local x = self:getElements()
      for i=1, #x do
        x[i]:draw()
      end
    end
  end

  function  g:getElements()
    return self.elements
  end

  function  g:onKeypress(key)
    local x = self:getElements()
    for i=1, #x do
      if x[i].input then
        x[i]:onKeypress(key)
      end
    end
  end

  function  g:update(dt)
    local x = self:getElements()
    for i=1, #x do
      --UIthread:start(x[i]:update(dt))
      --x[i]:update(dt)
    end
  end

  function  g:turnOffInput()
    local x = self:getElements()
    for i=1, #x do
      x[i].input = false
    end
  end

  function  g:elementsOnInput()
    local x = self:getElements()
    for i=1, #x do
      if x[i].input then
        return true
      end
    end
    return false
  end

  function g:onInput2()

    if g:elementsOnInput() then
      return true
    end

    return false
  end

  function g:onInput()
    local x = self:getElements()
    for i=1, #x do
      if x[i].input then
        return true
      end
    end
    return false
  end

  function  g:onClick(x, y)
    local t = self:getElements()
    if self.display then
      for i=1, #t do
        if t[i]:onPoint(x, y) then
          t[i]:onClick()
        end
      end
    end
    --if g:elementsOnInput() then
      --self.input = true
    --else
      --self.input = false
  --end
  end

  function  g:onPoint(x, y)
    if self.display then
      local t = self:getElements()
      for i=1, #t do
        if t[i]:onPoint(x, y) then
          return true
        end
      end
      return false
    end
  end

  return g

end
