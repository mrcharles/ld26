HC = require "hardoncollider"
local Monster = require 'monster'
local Encyclopedia = require 'encyclopedia'
local World = require 'world'
local Vector = require 'hump.vector'

local player 
local level
local encyclopedia


local function fallFunc(self, dt)
	local gravity = 600

	self.velocity = (self.velocity or Vector(0,0)) + Vector(0, gravity * dt)
	self.pos = self.pos + self.velocity * dt 
end

function love.load()
	encyclopedia = Encyclopedia:new()

	local m = encyclopedia:find(1)
	player = m:instance()
	player.scale = 3
	player:setPos(100,100)
	player.move = fallFunc


	level = World:new()
	level:addEntity(player)

	print(love.graphics.getWidth(),love.graphics.getHeight())
end

function love.update(dt)
	level:update(dt)
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
	level:draw()
	-- for i,rows in pairs(encyclopedia.things) do
	-- 	for i,thing in ipairs(rows) do
	-- 		thing:draw()
	-- 	end
	-- end
end