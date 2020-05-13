local kd = KDGame;

kd.WebSocket = {
	bCBindingObject = true,
	_object = 0,
	nIdx = -1,
	
	--发起连接
	--[[bool]] connect = function(self, --[[string]] ws_url)
		if (self._object ~= nil) then
			return c_WebSocketConnect(self._object, ws_url);
		end
		
		return false;
	end,
	
	--关闭连接
	--[[bool]] close = function(self)
		if (self._object ~= nil) then
			return c_WebSocketClose(self._object);
		end
		
		return false;
	end,
	
	--发送消息
	--[[bool]] send = function(self, --[[string]] msg)
		if (self._object ~= nil) then
			return c_WebSocketSendString(self._object, msg);
		end
		
		return false;
	end,
	
	--[[
		--获取连接的状态--
		0:正在进行连接
		1:连接中
		2:正在关闭连接
		3:无连接
	]]
	--[[int]] getState = function(self)
		if (self._object ~= nil) then
			return c_WebSocketGetState(self._object);
		end
		
		return 3;
	end,
	
	-- 回调接口(外部可以重载) =================================
	
	--连接成功
	OnConnect = function(self)
		
	end,
	
	--连接被关闭
	OnClose = function(self)
		
	end,
	
	--错误
	--[[
		0:超时
		1:连接错误
	]]
	OnError = function(self, --[[int]] code)
		
	end,
	
	--收到消息
	OnMessage = function(self, --[[stirng]] msg)
		
	end,
};

function kd.WebSocket:constr(self, ...)
	self.nIdx = kd.RegLuaTable(self);
	self._object = c_CreateWebSocket(self.nIdx);
	
	--C层对象生成失败,取消table全局绑定
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
		self.nIdx = -1;
	end
end

function kd.WebSocket:Ruin(self)
	kd.c_FreeWebSocket(self._object);
end


