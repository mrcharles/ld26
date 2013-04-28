local Tools = require 'construct.tools'
local Vector = require 'hump.vector'
HC = require 'hardoncollider'

local function on_collide(dt, shape_a, shape_b, dx, dy)
	if shape_a.entity then
		local e = shape_a.entity
		e:move(dx,dy)
		--if shape_a.entity.velocity.y 
		e.velocity = Vector(0,0)
		e.onground = true
	end
end

local World = Tools:Class()


-- we are going to assume 32x32 'tiles', screen is 800x600
function World:init()
    self.Collider = HC(100, on_collide)
    self.parts = {}
    self.entities = {}

    self:makeScreenBounds()

    self:addRectangle(0, 576, 800, 32)

	return self
end

function World:addRectangle(t,l,w,h)
	local parts = self.parts

	local piece = { f = "rectangle", params = {"fill", t,l,w,h}, shape = self.Collider:addRectangle(t,l,w,h)}

	self.Collider:setPassive(piece.shape)
	table.insert( parts, piece)
end

function World:addEntity(e, phys)
	table.insert(self.entities, e)

	if phys then
		local scale = e.scale or 1
		local x,y,w,h = unpack(phys)
		e.shape = self.Collider:addRectangle(x*scale, y*scale, w*scale, h*scale)
		e.shape.entity = e
	end
end

function World:makeScreenBounds()
	--top
	local Collider = self.Collider

	local left = Collider:addRectangle(-32,-32, 32, love.graphics.getHeight() + 64)
	local top = Collider:addRectangle(-32,-32, love.graphics.getWidth() + 64, 32)
	local right = Collider:addRectangle(love.graphics.getWidth(),-32, 32, love.graphics.getHeight() + 64)
	local bottom = Collider:addRectangle(-32,love.graphics.getHeight(), love.graphics.getWidth() + 64, 32)

	self.bounds = {}
	self.bounds.top = top
	self.bounds.left = left
	self.bounds.right = right
	self.bounds.bottom = bottom

	Collider:setPassive(left,top,right,bottom)
end

function World:update(dt)
    for i,e in ipairs(self.entities) do
    	e:update(dt)
    end
    self.Collider:update(dt)
end

function World:draw()
	love.graphics.setColor(255,255,255)
	for i,p in ipairs(self.parts) do
		love.graphics.setColor(255,255,255)
		love.graphics[p.f](unpack(p.params))

		if debugDraw then
			love.graphics.setColor(255,0,09)
			p.shape:draw()
		end
	end

	for i,e in ipairs(self.entities) do
		e:draw()
	end
end

return World