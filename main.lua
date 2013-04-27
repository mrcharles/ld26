HC = require "hardoncollider"
local Monster = require 'monster'
local Encyclopedia = require 'encyclopedia'
local World = require 'world'
local Vector = require 'hump.vector'

local player 
local level
local encyclopedia

debugDraw = true

local function fallFunc(self, dt)
	local gravity = 612

	self.velocity = (self.velocity or Vector(0,0)) + Vector(0, gravity * dt)
	local delta = self.velocity * dt

	self:move(delta.x, delta.y)
end

function love.load()
	encyclopedia = Encyclopedia:new()

	local m = encyclopedia:find(1)
	player = m:instance()
	player.scale = 3
	player.physics = fallFunc


	level = World:new()
	level:addEntity(player, {-3, 0, 6, 4})

	player:setPos(100,100)

	print(love.graphics.getWidth(),love.graphics.getHeight())
	--love.graphics.setBackgroundColor(0,128,128)
end

function love.update(dt)
	level:update(dt)
	-- for i,rows in pairs(encyclopedia.things) do
	-- 	for i,thing in ipairs(rows) do
	-- 		thing:update(dt)
	-- 	end
	-- end

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