local Tools = require 'construct.tools'
local Base = require 'base'

local Monster = Tools:Class(Base)


function Monster:init(bits)
	Base.init(self)
	self.dna = self:makeDNA(bits)
	self:createImages(self.dna)
	self.frame = "stand"
	self.anims = {}
	return self
end

function Monster:createImages()
	local dna = self.dna
	self.images = {}
	local data = love.image.newImageData(8,8)

	for y=1,6 do
		for x=1,8 do
			local set
			if x <= 4 then
				set = dna[y][x]
			else
				set = dna[y][9-x]
			end
			if set then
				data:setPixel(x-1,y,255,255,255,255)
			else
				data:setPixel(x-1,y,0,0,0,0)
			end
		end
	end

	local image = love.graphics.newImage(data)
	image:setFilter("nearest","nearest")
	self.images["stand"] = image

	--jump anim will be bottom row extended down one
	data = love.image.newImageData(8,8)

	for y=1,7 do
		for x=1,8 do
			local set
			local ry = (y < 7 and y) or 6
			if x <= 4 then
				set = dna[ry][x]
			else
				set = dna[ry][9-x]
			end
			if set then
				data:setPixel(x-1,y,255,255,255,255)
			else
				data:setPixel(x-1,y,0,0,0,0)
			end
		end
	end

	image = love.graphics.newImage(data)
	image:setFilter("nearest","nearest")
	self.images["jump"] = image

	--run anim will be bottom row flipped
	data = love.image.newImageData(8,8)

	for y=1,6 do
		for x=1,8 do
			local set

			if y ~= 6 then
				if x <= 4 then
					set = dna[y][x]
				else
					set = dna[y][9-x]
				end
			else
				if x <= 4 then
					set = dna[y][(5-x)]
				else
					set = dna[y][5 - (9-x)]
				end
			end

			if set then
				data:setPixel(x-1,y,255,255,255,255)
			else
				data:setPixel(x-1,y,0,0,0,0)
			end
		end
	end

	image = love.graphics.newImage(data)
	image:setFilter("nearest","nearest")
	self.images["run"] = image
	
	if self:canFly() then

		--fly anim will be columns moved in one
		data = love.image.newImageData(8,8)

		for y=1,6 do
			for x=1,8 do
				local set

				if x == 1 or x == 8 then
					set = false
				else
					if x <= 4 then
						set = dna[7-y][x -1]
					elseif x >= 5 then
						set = dna[7-y][(9-x) -1]
					end
				end
				if set then
					data:setPixel(x-1,y,255,255,255,255)
				else
					data:setPixel(x-1,y,0,0,0,0)
				end
			end
		end

		image = love.graphics.newImage(data)
		image:setFilter("nearest","nearest")
		self.images["fly"] = image

	end

end

function Monster:makeDNA(bits)
	local dna = {}

	for i=1,6 do
		local strand = {}
		strand[ math.random(4) ] = true
		dna[i] = strand
	end

	while bits > 0 do
		local x,y = math.random(4), math.random(6)

		if not dna[y][x] then
			dna[y][x] = true
			bits = bits - 1
		end
	end

	return dna
end

function Monster:canRun() -- if we'll see movement on run anim
	local dna = self.dna

	if dna[6][1] ~= dna[6][4] or dna[6][2] ~= dna[6][3] then
		return true
	end
end

function Monster:isStrong() -- if it has double width legs, and a wide stance
	local strong 

	local a = self.dna[6]

	if a[4] then
		return false
	end

	for i=1,4 do
		if a[i] and strong == nil then
			strong = false
		elseif a[i] and strong == false then
			strong = true
		elseif not a[i] and not strong then
			strong = nil
		end
	end

	return strong
end

function Monster:isFast() -- basically if it's mobile and the legs move a lot

end

function Monster:isPlant() -- if it has a 'stem'
	local a = self.dna[5]
	local b = self.dna[6]

	if self:isPogo() and b[4] and not b[3] and a[4] and not a[3] then
		return true
	end
end

function Monster:isImmobile()
	local d = self.dna[6]

	if d[1] and d[2] and d[3] and d[4] then
		return true
	end
end

function Monster:isPogo() -- if it touches the ground only from one place
	local d = self.dna[6]

	if d[1] or d[2] or (d[3] and not d[4]) then
		return false
	else
		return true
	end
end

function Monster:jump()
	if self:isPlant() then
		return
	end
	self.frame = "jump"
	self.anims = {}
	table.insert(self.anims, {new = true, t=0.1, f = function() self.frame = "stand" end})
end

function Monster:run()
	if self:isPlant() or not self:canRun() then
		return 
	end
	self.frame = "run"
	self.anims = {}
	table.insert(self.anims, {new = true, t=0.1, f = function() self.frame = "stand" end})
	table.insert(self.anims, {new = true, t=0.2, f = function() self:run() end})

end

function Monster:fly()
	if not self:canFly() then
		return 
	end
	self.frame = "fly"
	self.anims = {}
	table.insert(self.anims, {new = true, t=0.2, f = function() self.frame = "stand" end})
	table.insert(self.anims, {new = true, t=0.4, f = function() self:fly() end})

end

function Monster:canFly()
	local dna = self.dna

	if self:isPogo() then
		return
	end

	local count = 0
	for i=1,4 do
		if dna[6][i] then
			count = count + 1
		end
	end

	if count ~= 1 then
		return

	end

	local can = true
	for j=1,6 do
		if dna[j][4] then
			can = false
			break
		end
	end
	if can then 
		return true
	end
end

function Monster:update(dt)
	local i = 1
	local anims = self.anims
	while i <= #anims do
		local a = anims[i]
		a.t = a.t - dt
		if a.t <= 0 and not a.new then
			a.f()
			table.remove(anims, i)
		else
			a.new = false
			i = i + 1
		end
	end
end

function Monster:draw()
	love.graphics.push()
	self:preDraw()
	local scale = self.scale or 1

	if self:isImmobile() then
		love.graphics.setColor(50,50,50)
	elseif self:canFly() then
		love.graphics.setColor(0,255,255)
	elseif not self:canRun() then
		love.graphics.setColor(255,0,0)
	elseif self:isPlant() then
		love.graphics.setColor(0,255,0)
	elseif self:isStrong() then
		love.graphics.setColor(255,255,0)
	elseif self:isPogo() then
		love.graphics.setColor(0,0,255)
	else
		love.graphics.setColor(255,255,255)
	end

	love.graphics.draw(self.images[self.frame], 0,0,0,scale,scale,-4,-8)

	love.graphics.pop()
end

return Monster