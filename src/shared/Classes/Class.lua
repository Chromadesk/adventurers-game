Class = {}

--creates a class extension for inheritance
function Class:Extend(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

--creates a new instance of a class
function Class:New(o)
	o = self:Extend(o)
	if o.OnNew then
		o:OnNew()
	end
	return o
end

return Class