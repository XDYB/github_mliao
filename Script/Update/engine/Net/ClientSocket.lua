local kd = KDGame;

kd.ClientSocket = {bCBindingObject = true};

function kd.ClientSocket:constr(self, ...)
	self:create(...);
end

function kd.ClientSocket:Ruin(self)
	kd.SocketFree(self._object);
	self._object = nil;
end

function kd.ClientSocket:create(...)
	self._object = kd.SocketCreate();
end

function kd.ClientSocket:NetworkIsIpv6()
	if (self._object ~= nil) then
		return kd.NetworkIsIpv6(self._object);
	end
	
	return false;
end

function kd.ClientSocket:connect(--[[string]] szServerIP, --[[unsigned short]] wPort)
	if (self._object ~= nil) then
		return kd.SocketConnect(self._object, szServerIP, wPort);
	end
	
	return -1;
end

function kd.ClientSocket:SendData(--[[int]] wMainCmd, 
								--[[int]] wSubCmd, 
								--[[string]] data, 
								--[[int]] size)
	if (self._object ~= nil) then
		if (data == nil or size == nil) then
			return kd.SocketSendData(self._object, wMainCmd, wSubCmd)
		else
			return kd.SocketSendData(self._object, wMainCmd, wSubCmd, data, size);
		end
	end
	return false;
end

function kd.ClientSocket:CloseSocket(--[[bool]] bNotify)
	if (self._object ~= nil) then
		return kd.SocketClose(self._object, bNotify, 0);
	end
	
	return false;
end

function kd.ClientSocket:GetConnectState()
	if (self._object ~= nil) then
		return kd.SocketGetConnectState(self._object);
	end
	
	return kd.emSocketState.SocketState_NoConnect;
end


