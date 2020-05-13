local kd = KDGame;

kd.WebView = kd.inherit(kd.Node);

function kd.WebView:constr(self, ...)
	
end

function kd.WebView:Ruin(self)
	
end

function kd.WebView:create(...--[[x,y,w,h,Transparent=false]])
	local cnt = select("#", ...);
	if (cnt < 4) then
		return;
	end
	
	local Transparent = false;
	if (cnt > 4) then Transparent = select(5, ...); end
	self.nIdx = kd.RegLuaTable(self);
	self._object = kd.WebViewCreate(self.nIdx, 
										select(1, ...),
										select(2, ...),
										select(3, ...),
										select(4, ...),
										Transparent);
										

	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
	end
end

function kd.WebView:loadUrl(--[[string]] url)
	if (self._object ~= nil) then
		kd.WebViewLoadUrl(self._object, url);
	end
end

--[[bool]] function kd.WebView:setCookie(--[[string]] domain, --[[string]] name, --[[string]] value, --[[string]] path)
	if (self._object ~= nil) then
		return kd.WebViewSetCookie(self._object, domain, name, value, path);
	end
	
	return false;
end

--[[string]] function kd.WebView:getCookie(--[[string]] domain, --[[string]] name)
	if (self._object ~= nil) then
		return kd.WebViewGetCookie(self._object, domain, name);
	end
	
	return nil;
end

--[[bool]] function kd.WebView:deleteCookie(--[[string]] domain, --[[string]] name)
	if (self._object ~= nil) then
		return kd.WebViewDeleteCookie(self._object, domain, name);
	end
	
	return false;
end

function kd.WebView:SetVisible(--[[boolean]] visible)
	if (self._object ~= nil) then
		kd.WebViewSetVisible(self._object, visible);
	end
end

function kd.WebView:SetPos(--[[float]] x, y)
	if (self._object ~= nil) then
		kd.WebViewSetPos(self._object, x, y);
	end
end

function kd.WebView:SetRect(--[[float]] x, y, w, h)
	if (self._object ~= nil) then
		kd.WebViewSetRect(self._object, x, y, w, h);
	end
end

function kd.WebView:SetScalesPageToFit(--[[bool]] scalesPageToFit)
	if (self._object ~= nil) then
		kd.WebViewsetSPToFit(self._object, scalesPageToFit);
	end
end

--»Øµ÷º¯Êý ===========================================================

function kd.WebView:OnloadUrlStart(--[[string]] url)
	print("KD_LOG:loadUrlStart"..url);
	return true;
end

function kd.WebView:OnloadUrlFinish(--[[string]] url)
	print("KD_LOG:OnloadUrlFinish"..url);
end

function kd.WebView:OnloadUrlFail(--[[string]] url)
	print("KD_LOG:OnloadUrlFail"..url);
end


