--room tiles = 25 x 19
--l/r edges one thickness
-- bottom edge = 2 min top = 1 min

local Tools = require 'construct.tools'
local Map = require 'construct.map'

local Room = Tools:Class()


function Room:init(w, h)
	self.width = w
	self.height = h
	w = 25 * w
	h = 19 * h
	local map = Map:new(w, h)

	--initialize room to be fully bounded

	for x=1,w do
		map:set(x, 1, { border = true })		
		map:set(x, h-1, { border = true })		
		map:set(x, h, { border = true })		
	end

	for y=1,h do
		map:set(1, y, {border = true})
		map:set(w, y, {border = true})
	end
	self.map = map



	return self
end

return Room