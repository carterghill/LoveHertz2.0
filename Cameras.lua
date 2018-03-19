Cameras = {}
cameraNum = 0
cameraColliders = {}
globalScale = 1
zoom = 1

function Cameras:new()
	local num = table.getn(Cameras)+1
	Cameras[num] = {
		x = 0,
		y = 0,
		xSpeed = 0,
		ySpeed = 0,
    	width = love.graphics.getWidth( ),
    	height = love.graphics.getHeight()
	}

	if cameraNum == 0 then
		cameraNum = 1
	end
end

function getZoom()
	return zoom * globalScale
end

function Cameras:setPosition(x, y)
	c = Cameras:current()
	c.x = x - love.graphics.getWidth()/2 + l.players.width/2
	c.y = y - love.graphics.getHeight()/2 + l.players.height/2
end

function Cameras:update(dt)
	--display = false
	if EditModeUI.display then
	   if love.keyboard.isDown('d') then
	     Cameras[cameraNum].x = Cameras[cameraNum].x + 600*dt
	   end
	   if love.keyboard.isDown('a') then
       Cameras[cameraNum].x = Cameras[cameraNum].x + -600*dt
     end
     if love.keyboard.isDown('s') then
       Cameras[cameraNum].y = Cameras[cameraNum].y + 600*dt
     end
     if love.keyboard.isDown('w') then
       Cameras[cameraNum].y = Cameras[cameraNum].y - 600*dt
     end
	else

			Cameras:moveTo(P, 0.2, dt)


	end
	Cameras[cameraNum].x = Cameras[cameraNum].x + Cameras[cameraNum].xSpeed*dt
	Cameras[cameraNum].y = Cameras[cameraNum].y + Cameras[cameraNum].ySpeed*dt
end

function Cameras:current()
	return Cameras[cameraNum]
end

function Cameras:lockOn(object, dt)

	--Cameras[cameraNum].x = object.x + object.img:getWidth()/2 - 400
	--Cameras[cameraNum].y = object.y + object.img:getHeight()/2 - 300

	moveTo(object, 0.2, dt)

end

-- moveTo: Moves the camera to the object in the alloted time
function Cameras:moveTo(object, time, dt)
	if object ~= nil then
		Cameras[cameraNum].xSpeed = (((object.x + object.xSpeed/3 + object.width/2)*getZoom() - love.graphics.getWidth( )/2) - Cameras[cameraNum].x*getZoom())/time
		Cameras[cameraNum].ySpeed = (((object.y + object.ySpeed/10 + object.height/2)*getZoom() - love.graphics.getHeight( )/2) - Cameras[cameraNum].y*getZoom())/time
	end
end
