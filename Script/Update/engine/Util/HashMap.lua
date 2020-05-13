HashMap = class("HashMap")
function HashMap:ctor()
	self.Map = {}
	self.len = 0
	self.clear = function(this)
		this.Map = {}
		this.len = 0
	end
	-- 向map中添加key-value 键值对，如果可以包含了key的映射，则旧的value将被替换
	self.put = function(this,key,value)
		if this.Map[key]==nil then
			this.len = this.len + 1
		end
		this.Map[key] = value
	end
	-- 返回key ，对应的值
	self.get = function(this,key)
		return this.Map[key]
	end
	-- 返回key组成的集合
	self.keySet = function(this)
		local list = {}
		for k,v in pairs(this.Map) do
			table.insert(list,k)
		end
		return list
	end
	-- 返回value组成的集合
	self.values = function(this)
		local collection = {}
		for k,v in pairs(this.Map) do
			table.insert(collection,v)
		end
		return collection
	end
	-- 是否包含键为key的元素
	self.containsKey = function(this,key)
		return this.Map[key]~=nil
	end
	-- 判断是否包含指定value的实体
	self.containsValue = function(this,value)
		local exist = false
		for k,v in pairs(this.Map) do
			if v==value then
				exist = true
				break;
			end
		end
		return exist
	end
	-- 删除key ,并返回key对应的value值
	self.remove = function(this,key)
		if this.Map[key] then
			this.len = this.len - 1
		end
		local value = this.Map[key]
		this.Map[key] = nil
		return value
	end
	-- 判断集合是否为空
	self.isEmpty = function(this)
		return this.len == 0
	end
	-- 返回Map中键值对的数量
	self.size = function(this)
		return this.len
	end

end
