local Monster = require 'monster'

local things = {}
local player 
function love.load()
	player = Monster:new(10)
	player.scale = 3
	player:setPos(100,100)

	for i=1,11 do
		things[i] = {}

		for j=1,16 do
			local t = Monster:new(i)
			t.scale = 3
			t:setPos(100 + j * 30, 100 + i * 30)			
			things[i][j] = t
		end
	end
end

function love.update(dt)
	for i,rows in ipairs(things) do
		for i,thing in ipairs(rows) do
			thing:update(dt)
		end
	end
end

function love.keypressed(key)
	if key == "z" then
		for i,rows in ipairs(things) do
			for i,thing in ipairs(rows) do
				thing:run()
			end
		end
	end
	if key == " " then
		for i,rows in ipairs(things) do
			for i,thing in ipairs(rows) do
				thing:jump()
			end
		end
	end
	if key == "x" then
		for i,rows in ipairs(things) do
			for i,thing in ipairs(rows) do
				thing:fly()
			end
		end
	end

end

function love.draw()
	for i,rows in ipairs(things) do
		for i,thing in ipairs(rows) do
			thing:draw()
		end
	end
end