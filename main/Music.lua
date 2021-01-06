Music = {}

function Music:load()

	self.music = {}

	if love.filesystem.isDirectory("Music") then

		local files = love.filesystem.getDirectoryItems("Music")
		for k, file in ipairs(files) do
			Debug:log(k .. ". " .. file) --outputs something like "1. main.lua"
			table.insert(self.music, file)
		end

	end

	table.insert(self.music, "No Music")

end

function Music:loadSong(song)

	if song ~= nil then
		if love.filesystem.exists("Music/"..song) then
			if self.song ~= nil then
				love.audio.stop(self.song)
			end
			self.song = love.audio.newSource("Music/"..song, "stream")
			self.songName = song
			return
		end
	end

	Debug:log("Music does not exist or is nil")

end

function Music:getMusic()
	return self.music
end

function Music:getSong()
	return self.songName
end

function Music:stop()

	if self.song ~= nil then
		love.audio.stop(self.song)
	end

end

function Music:play()

	if self.song ~= nil then
		love.audio.stop(self.song)
		love.audio.play(self.song)
	else
		Debug:log("Audio source is nil")
	end

end
