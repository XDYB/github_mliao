-- ================================================
-- 队列
-- 先进先出
-- ================================================
Queue = class("Queue")
function Queue:ctor()
	self.Map = {}
	self.len = 0
	self.ptr = 1
	-- 添加
	self.add = function(this,value)
		this.len = this.len + 1
		this.Map[this.ptr + this.len-1] = value
	end
	-- 取出元素 不执行删除
	self.peek = function(this)
		if this.len > 0 then
			return this.Map[this.ptr]
		end
	end
	-- 取出元素，并将该元素删除
	self.pool = function(this)
		if this.len > 0 then
			local value = this.Map[this.ptr]
			this.Map[this.ptr] = nil
			this.ptr = this.ptr+1
			this.len = this.len-1
			return value
		end
	end
	-- 清空
	self.clear = function(this)
		this.Map = {}
		this.len = 0
		this.ptr = 1
	end
	-- 是否为空
	self.isEmpty = function(this)
		return this.len == 0
	end
	-- 长度
	self.size = function(this)
		return this.len
	end
end
