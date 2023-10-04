Class = {}
nextId = 0

function Class:Extend(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Class:New(o)
	o = self:Extend(o)

	o.id = nextId
	nextId = nextId + 1

	if o.OnNew then
		o:OnNew()
	end
	return o
end

function Class:IsA(class)
	local super = self
	while super do
		if super == class then
			return true
		end
		super = getmetatable(super)
	end
	return false
end

function Class:Equals(class, o)
	return class.id == o.id
end

return Class
