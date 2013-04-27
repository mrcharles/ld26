local Tools = require 'construct.tools'
local Vector = require 'hump.vector'

local Base = Tools:Class()

function Base:init()
	self.pos = Vector(0,0)
	return self
end

function Base:setPos(x,y)
	self.pos = Vector(x,y)
end

function Base:move(x,y)
	self.pos = self.pos + Vector(x,y)
end

function Base:preDraw()
	love.graphics.translate(self.pos.x, self.pos.y)
end

return Base