local Tools = require 'construct.tools'
local Vector = require 'hump.vector'
local Camera = require 'hump.camera'
HC = require 'hardoncollider'

local function on_collide(dt, shape_a, shape_b, dx, dy)
	if shape_a.entity then
		local e = shape_a.entity
		e:move(dx,dy)
		if dy ~= 0 then 
			e.velocity.y = 0

			if shape_b.world then
				e.onground = true
			end
		end

		if dx ~= 0 then
			e.velocity.x = 0

		end
	end
end

local World = Tools:Class()


-- we are going to assume 32x32 'tiles', screen is 800x600
function World:init(room)
    self.Collider = HC(100, on_collide)
    self.parts = {}
    self.entities = {}
    self.camera = Camera()

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    self.cambounds = { 	minx = w/2, 
    					maxx = room.width * w - w/2,
    					miny = h/2,
    					maxy = room.height * h - h/2 }

    --self:makeScreenBounds()

    -- self:addRectangle(0, 544, 800, 64)
    -- self:addRectangle(0, 0, 800, 32)

    -- self:addRectangle(320, 480, 96, 32)

    function isBorder(tile)
    	if tile then
    		return tile.border
    	end
    end
    function addTile(x,y,tile)
    	self:addRectangle( (x-1) * 32, (y-1) * 32, 32, 32)
    end

    room.map:iterate(addTile, isBorder)
	return self
end

function World:addRectangle(t,l,w,h)
	local parts = self.parts

	local piece = { f = "rectangle", params = {"fill", t,l,w,h}, shape = self.Collider:addRectangle(t,l,w,h)}

	self.Collider:setPassive(piece.shape)
	piece.shape.world = self
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

function World:setFocus(entity)
	self.focus = entity
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

function clamp(min,max,val)
	if val < min then
		return min
	elseif val > max then
		return max
	else
		return val
	end
end

function World:update(dt)
    for i,e in ipairs(self.entities) do
    	e:update(dt)
    end
    self.Collider:update(dt)

    --camera update
    if self.focus then
	    local cam = self.camera
	    local bounds = self.cambounds
	    cam.x = clamp(bounds.minx, bounds.maxx, self.focus.pos.x)
	    cam.y = clamp(bounds.miny, bounds.maxy, self.focus.pos.y)
	end

end

function World:draw()
	self.camera:attach()
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

	self.camera:detach()
end

return World