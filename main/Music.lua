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

	self.song = love.audio.newSource("Music/BestFriend.mp3", "stream")

end

function Music:loadSong(song)

	if love.filesystem.exists("Music/"..song) then
		self.song = love.audio.newSource("Music/"..song, "stream")
	end

end

function Music:getMusic()
	return self.music
end

function Music:play()

	if self.song ~= nil then
		love.audio.play(self.song)
	else
		Debug:log("Audio source is nil")
	end

end
