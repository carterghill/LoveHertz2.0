require("entities/Enemy")

Enemies = {}

function Enemies:new()

  ens = {
    enemies = {}
  }

  function ens:add(enemy)
    self.enemies[#self.enemies+1] = enemy
  end

  function ens:loadSave(obj)
    local folder = obj.folder
    local scale = obj.scale
    local mousex = obj.x
    local mousey = obj.y
    local enemy = Enemy:new(name, folder, scale, nil, mousex, mousey)
    enemy.x = mousex
    enemy.y = mousey
    self.enemies[#self.enemies+1] = enemy
  end

  function ens:draw()
    for i=1, #self.enemies do
      self.enemies[i]:draw()
    end
  end

  function ens:update(dt)
    for i=1, #self.enemies do
      self.enemies[i]:update(dt)
      if self.enemies[i].health <= 0 then
        table.remove(self.enemies, i)
        return
      end
    end
  end

  return ens

end
