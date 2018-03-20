controls = {}
controlsEnabled = true

controls[1] = {

  left = "a",
  right = "d",
  up = "w",
  down = "s",
  jump = "space",
  shoot = "e"

}

controls[2] = {

  left = "b",
  right = "m",
  up = "h",
  down = "n",
  jump = "k",
  shoot = "j"

}

function love.gamepadpressed( joystick, button )
  local i = joystick:getID()
  if P ~= nil then
    if button == "a" then
        if PauseUI.paused then
            PauseUI:select()
        else
            l.players:jump()
        end
    end
    if button == "b" then
        if PauseUI.paused then
            --PauseUI:deselect()
        end
    end
    if button == "x" then
        l.players:shoot()
        l.players.charge:start()
    end
    if button == "dpup" then
        if PauseUI.paused then
            PauseUI:up()
        else
            P.up = true
        end
    end
    if button == "dpdown" then
        if PauseUI.paused then
            PauseUI:down()
        else
            P.down = true
        end
    end
    if button == "dpleft" then
      P.left = true
    end
    if button == "dpright" then
      P.right = true
    end
  end
end

function love.gamepadreleased( joystick, button )
    local i = joystick:getID()
    if P ~= nil then
        if button == "a" then
            if PauseUI.paused then
                --PauseUI:selectUp()
            else
                if P.ySpeed < -400 then
                    P.ySpeed = -400
                end
            end
        end
        if button == "b" then
            if PauseUI.paused then
                PauseUI:deselect()
            end
        end
        if button == "x" then
            if l.players.charge.timer > 0.5 then
                l.players:shoot(l.players.charge.timer)
            end
            l.players.charge:stop()
        end
        if button == "dpup" then
            P.up = false
        end
        if button == "dpdown" then
            P.down = false
        end
        if button == "dpleft" then
            P.left = false
        end
        if button == "dpright" then
            P.right = false
        end
        if button == "start" then
            PauseUI:pause()
        end
    end
end

function love.keypressed(key)
  PlayerUI.touch = false
  gooi.setGroupVisible("player", false)
  gooi.keypressed(key, scancode, isrepeat)
  --EditModeUI:onKeypress(key)
  if not gooi.onInput() then
    for i = 1, table.getn(controls) do
      if key == controls[i].shoot then
        l.players:shoot()
        l.players.charge:start()
      end
      if key == controls[i].jump then
        P:jump()
      end
      if key == controls[i].up then
          if PauseUI.paused then
              PauseUI:up()
          else
              P.up = true
          end
      end
      if key == controls[i].down then
        P.down = true
        if PauseUI.paused then
            PauseUI:down()
        end
      end
      if key == controls[i].left then
        P.left = true
      end
      if key == controls[i].right then
        P.right = true
      end
      if key == "up" then
          if PauseUI.paused then
              PauseUI:down()
          end
      end
      if key == "down" then
          if PauseUI.paused then
              PauseUI:up()
          end
      end

    end
    if key == "escape" then
      PauseUI:pause()
    end
    if key == "backspace" then
        if PauseUI.paused then
            PauseUI:deselect()
        end
    end

    if not inSequence and key == controls[1].jump then
      for i = 1, table.getn(controls) do
        if key == controls[i].jump then
          --jump(Players:get(i), dt)
          --jump(getPlayer(2), dt)
        end
      end
    end
  end
end

function love.keyreleased(key, scancode)
  gooi.keyreleased(key, scancode)
  for i = 1, table.getn(controls) do
    if key == controls[i].jump and P.ySpeed < -400 then
      P.ySpeed = -400
    end
    if key == controls[i].up then
      P.up = false
    end
    if key == controls[i].down then
      P.down = false
    end
    if key == controls[i].left then
      P.left = false
    end
    if key == controls[i].right then
      P.right = false
    end
    if key == controls[i].shoot then
      if l.players.charge.timer > 0.5 then
        l.players:shoot(l.players.charge.timer)
      end
      l.players.charge:stop()
    end
    if key == "space" or key == "return" then
        if PauseUI.paused then
            PauseUI:select()
        end
    end
  end
end
