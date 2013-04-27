local Tools = require 'construct.tools'
HC = require 'hardoncollider'

local function on_collide(dt, shape_a, shape_b)
end

local World = Tools:Class()


-- we are going to assume 32x32 'tiles', screen is 800x600
function World:init()
    self.Collider = HC(100, on_collide)
    self.parts = {}
    self.entities = {}

    self:addRectangle(0, 576, 800, 32)

    self:makeScreenBounds()
	return self
end

function World:addRectangle(t,l,w,h)
	local parts = self.parts

	table.insert( parts, { f = "rectangle", params = {"fill", t,l,w,h}})
end

function World:addEntity(e, phys)
	table.insert(self.entities, e)

	if phys then
		local scale = e.scale or 1
		local x,y,w,h = unpack(phys)
		e.shape = self.Collider:addRectangle(x*scale, y*scale, w*scale, h*scale)
	end
end

function World:makeScreenBounds()
	--top
	local Collider = self.Collider

	local left = Collider:addRectangle(-32,-32, 32, love.graphics.getHeight() + 64)

	local top = Collider:addRectangle(-32,-32, love.graphics.getWidth() + 64, 32)

	local right = Collider:addRectangle(love.graphics.getWidth(),-32, 32, love.graphics.getHeight() + 64)

	local bottom = Collider:addRectangle(-32,love.graphics.getHeight(), love.graphics.getWidth() + 64, 32)


end

function World:update(dt)
    self.Collider:update(dt)

    for i,e in ipairs(self.entities) do
    	e:update(dt)
    end
end

function World:draw()
	love.graphics.setColor(255,255,255)
	for i,p in ipairs(self.parts) do

		love.graphics[p.f](unpack(p.params))
	end

	for i,e in ipairs(self.entities) do
		e:draw()
	end
end

return World