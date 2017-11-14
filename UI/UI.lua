require("UI/PlayerUI")
require("UI/EditModeUI")

UI = {
  elements = {}
}

function UI:load()

  UIthread = love.thread.newThread("runFunction.lua")

  EditModeUI = EditModeUI:load()
  p = PlayerUI:load()

  --UI:add(EditModeUI)
  UI:add(p)

end

function UI:add(e)
  table.insert(UI.elements, e)
end

function UI:draw()

  for i = 1, #UI.elements do
    if UI.elements[i].display then
      UI.elements[i]:draw()
    end
  end

end

function UI:updateAll(dt)

  for i = 1, #UI.elements do
    if UI.elements[i].display then
      UI.elements[i]:update()
    end
  end

end

function UI:update(dt)
  UIthread:start(UI:updateAll(dt))
  --UI:updateAll(dt)
end

function UI:onClick(x, y)

  PlayerUI:onClick(x, y)

end

function UI:onInput()

  for i=1, #UI.elements do
    if UI.elements[i]:onInput() then
      return true
    end
  end

  return false

end

function UI:mouseOn()

  x, y = love.mouse.getPosition()
  if --[[(EditModeUI.display and EditModeUI:onPoint(x, y)) or]] PlayerUI:onPoint(x, y) then
    return true
  end

  return false

end
