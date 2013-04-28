HC = require "hardoncollider"
local Monster = require 'monster'
local Encyclopedia = require 'encyclopedia'
local World = require 'world'
local Vector = require 'hump.vector'
local Room = require 'room'
local Camera = require 'hump.camera'

local player 
local level
local encyclopedia
local camera

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
	player.scale = 5
	player.physics = fallFunc

	local room = Room:new(2,2)
	level = World:new(room)
	level:addEntity(player, {-3, 0, 6, 4})
	level:setFocus(player)
	player:setPos(100,100)

	print(love.graphics.getWidth(),love.graphics.getHeight())
	--love.graphics.setBackgroundColor(0,128,128)
end

function love.update(dt)
	local moving = false
	local run = love.keyboard.isDown("lshift")

	local speed = 140
	if run then
		speed = speed * 1.5
	end

	if love.keyboard.isDown("a") then
		player:move(-speed * dt, 0)
		player:run(true)
		moving = true
	end
	if love.keyboard.isDown("d") then
		player:move(speed * dt, 0)
		player:run(true)
		moving = true
	end

	if not moving and player.onground then
		player:stand()
	end
	level:update(dt)
	-- for i,rows in pairs(encyclopedia.things) do
	-- 	for i,thing in ipairs(rows) do
	-- 		thing:update(dt)
	-- 	end
	-- end

end

function love.keypressed(key)
	if key == " " and player.onground then
		player:jump()
		player.velocity = Vector(0,-400)
		player.onground = nil
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