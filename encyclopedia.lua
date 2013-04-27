local Tools = require 'construct.tools'
local Monster = require 'monster'
local Encyclopedia = Tools:Class()

function Encyclopedia:init()
	self.things = {
		statues = {},
		fliers = {},
		immobile = {},
		plants = {},
		strong = {},
		pogo = {},
		normal = {},
	}

	self:generate()
	return self
end

function Encyclopedia:find(bits,class)
	class = class or "normal"

	local list = self.things[class]

	for i,m in ipairs(list) do
		if m.dna.bits == bits then
			return m
		end
	end

	--if we get here, we didn't find anything.
	assert(false, "nothing found")

end

function Encyclopedia:generate()
	local insert = table.insert
	local things = self.things
	for i=1,11 do
		for j=1,16 do
			local t = Monster:new(i)
			t.scale = 3
			t:setPos(100 + j * 30, 100 + i * 30)			

			if t:isImmobile() then
				insert(things.statues, t)
			elseif t:canFly() then
				insert(things.fliers, t)
			elseif not t:canRun() then
				insert(things.immobile, t)
			elseif t:isPlant() then
				insert(things.plants, t)
			elseif t:isStrong() then
				insert(things.strong, t)
			elseif t:isPogo() then
				insert(things.pogo, t)
			else
				insert(things.normal, t)
			end

		end
	end
end

return Encyclopedia