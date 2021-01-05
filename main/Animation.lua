-- createAnimation: Create an animated image out of the given folder
-- folder - String: Directory to the images
-- TPF (Optional) - Integer: Time Per frame
-- f (Optional) - Integer: frame the animation should start on
function createAnimation(folder, TPF, f)

	anim = {

		images = loadImagesInFolder(folder),
		timePerFrame = TPF or 1/15,
		frame = f or 1,
		currentTime = 0

	}

	-- A function unique to this object
	-- plays the animation at the given x, y
	function anim:play(x, y, r, sx, sy, ox, oy)

		-- Image drawn is in the images frame position
		image = self.images[self.frame]
		love.graphics.draw(image, x, y, r, sx, sy, ox, oy)

		-- Keep track of time. If time exceeds timePerFrame, move to next frame
		self.currentTime = self.currentTime + love.timer.getDelta()
		if self.currentTime > self.timePerFrame then

			--set timer back to zero and increase frame
			self.currentTime = 0
			self.frame = self.frame + 1

			-- Go back to first frame if frame exceeds number of images
			if self.frame > #self.images then
				self.frame = 1
			end
		end

	end

	return anim

end


-- Loops files in a folder and returns their names
function getFilesInFolder(path)

	local x = love.filesystem.getDirectoryItems(path)
	files = {}
	for k, file in ipairs(x) do
		files[k] = file
	end

	i = 1
	while (i <= #files) do
		i = i + 1
	end

	return files

end

function loadImagesInFolder(folder)

	-- Get every image name in the given folder
	imageNames = getFilesInFolder(folder)
	images = {}

	-- Load every image into a new array
	i = 1
	while (i <= #imageNames) do
		-- I ADDED IFS TO MAKE SURE EACH FILE WAS AN IMAGE
		if string.find(imageNames[i], ".png") or string.find(imageNames[i], ".jpg")
		or string.find(imageNames[i], ".gif") then
			images[i] = love.graphics.newImage(folder.."/"..imageNames[i])
			images[i]:setFilter("nearest", "nearest")
			i = i + 1
    else
			-- IF INDEX IS NOT IMAGE, REMOVE AND TRY INDEX AGAIN
			table.remove(imageNames, i)
		end
	end

	return images

end

function getFoldersInFolder(folder)

	folders = {}
	files = love.filesystem.getDirectoryItems(folder)
	for i=1, #files do
    -- If string does not contain a dot, it is a folder
		if not string.find(files[i], "%.") then
      table.insert(folders, files[i])
    end
	end

	return folders

end
