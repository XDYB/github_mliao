
-- 支持多重继承的构造调用
function class(classname, super)
    local cls
	if super then
		cls = {}
		setmetatable(cls, {__index = super})
		cls.super = super
	else
		cls = {ctor = function() end}
	end

	cls.__cname = classname
	cls.__index = cls

	function cls.new(...)
		local instance = setmetatable({}, cls)
		instance.class = cls

		local superlist = {}
		local mysuper = instance.super
		while(mysuper) do
			table.insert(superlist,mysuper)
			mysuper = mysuper.super
		end
		-- 调用父类构造
		for i=#superlist,1,-1 do
			-- 特别说明：调用使用. 不要使用：并把instance当第一个参数传入 这样父类构造使用的self就是子类自己了
			superlist[i].ctor(instance,...)
		end

		instance:ctor(...)
		return instance
	end
    return cls
end

-- ==========================================
-- 迭代函数
-- ==========================================	
function each(map)
	if map.__cname == "HashMap" then
		-- =========================
		-- 迭代HashMap
		-- =========================
		local key
		local value
		return function()
			key,value = next(map.Map,key)
			return key,value
		end
	elseif map.__cname == "Queue" then
		-- =========================
		-- 迭代Queue
		-- =========================
		local index = 0
		local key
		local value
		return function()
			index = index + 1
			key,value = next(map.Map,key)
			if key and value then
				return index,value
			else
				return key,value
			end
			
		end
	end
end

