local kd = KDGame;

kd.WebSocket = {
	bCBindingObject = true,
	_object = 0,
	nIdx = -1,
	
	--��������
	--[[bool]] connect = function(self, --[[string]] ws_url)
		if (self._object ~= nil) then
			return c_WebSocketConnect(self._object, ws_url);
		end
		
		return false;
	end,
	
	--�ر�����
	--[[bool]] close = function(self)
		if (self._object ~= nil) then
			return c_WebSocketClose(self._object);
		end
		
		return false;
	end,
	
	--������Ϣ
	--[[bool]] send = function(self, --[[string]] msg)
		if (self._object ~= nil) then
			return c_WebSocketSendString(self._object, msg);
		end
		
		return false;
	end,
	
	--[[
		--��ȡ���ӵ�״̬--
		0:���ڽ�������
		1:������
		2:���ڹر�����
		3:������
	]]
	--[[int]] getState = function(self)
		if (self._object ~= nil) then
			return c_WebSocketGetState(self._object);
		end
		
		return 3;
	end,
	
	-- �ص��ӿ�(�ⲿ��������) =================================
	
	--���ӳɹ�
	OnConnect = function(self)
		
	end,
	
	--���ӱ��ر�
	OnClose = function(self)
		
	end,
	
	--����
	--[[
		0:��ʱ
		1:���Ӵ���
	]]
	OnError = function(self, --[[int]] code)
		
	end,
	
	--�յ���Ϣ
	OnMessage = function(self, --[[stirng]] msg)
		
	end,
};

function kd.WebSocket:constr(self, ...)
	self.nIdx = kd.RegLuaTable(self);
	self._object = c_CreateWebSocket(self.nIdx);
	
	--C���������ʧ��,ȡ��tableȫ�ְ�
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
		self.nIdx = -1;
	end
end

function kd.WebSocket:Ruin(self)
	kd.c_FreeWebSocket(self._object);
end


