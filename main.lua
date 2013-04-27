HC = require "hardoncollider"
local Monster = require 'monster'
local Encyclopedia = require 'encyclopedia'

local player 
local encyclopedia

function love.load()
	player = Monster:new(10)
	player.scale = 3
	player:setPos(100,100)

	encyclopedia = Encyclopedia:new()
end

function love.update(dt)
	for i,rows in pairs(encyclopedia.things) do
		for i,thing in ipairs(rows) do
			thing:update(dt)
		end
	end
end

function love.keypressed(key)
	if key == "z" then
		for i,rows in pairs(encyclopedia.things) do
			for i,thing in ipairs(rows) do
				thing:run()
			end
		end
	end
	if key == " " then
		for i,rows in pairs(encyclopedia.things) do
			for i,thing in ipairs(rows) do
				thing:jump()
			end
		end
	end
	if key == "x" then
		for i,rows in pairs(encyclopedia.things) do
			for i,thing in ipairs(rows) do
				thing:fly()
			end
		end
	end

end

function love.draw()
	for i,rows in pairs(encyclopedia.things) do
		for i,thing in ipairs(rows) do
			thing:draw()
		end
	end
end