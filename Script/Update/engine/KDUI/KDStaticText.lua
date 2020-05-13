local kd = KDGame;

kd.StaticText = kd.inherit(kd.Node)

function kd.StaticText:constr(self, ...)
	
end

function kd.StaticText:Ruin(self)
	
end

function kd.StaticText:create(...--[[int nFontSize, 
										string str, 
										KDGame.TextHAlignment hAlignment, 
										int nWide, int nhigh=0]])
	local cnt = select("#", ...);
	if (cnt < 4) then
		return;
	end
	
	local _nFontSize = select(1, ...);
	local _str = select(2, ...);
	local _hAlignment = select(3, ...);
	local _nWide = select(4, ...);
	local _nhigh = 0;
	if (cnt == 5) then _nhigh = select(5, ...); end
	
	self._object = kd.StaticTextCreate(_nFontSize, _str, _hAlignment, _nWide, _nhigh);
end

function kd.StaticText:GetString()
	if (self._object ~= nil) then
		return kd.StaticTextGetString(self._object);
	end
	
	return nil;
end

function kd.StaticText:SetString(--[[string]] newStr)
	if (self._object ~= nil) then
		if (newStr == nil or (type(newStr) ~= "string" and type(newStr) ~= "number")) then kd.StaticTextSetString(self._object, "");
		else kd.StaticTextSetString(self._object, newStr);
		end
	end
end

function kd.StaticText:SetColor(--[[uint]] _ARGB_)
	if (self._object ~= nil) then
		kd.StaticTextSetColor(self._object, _ARGB_);
	end
end

function kd.StaticText:SetWH(--[[float]] w, --[[float]] h)
	if (self._object ~= nil) then
		kd.StaticTextSetWH(self._object, w, h);
	end
end

function kd.StaticText:SetHAlignment(--[[KDGame.TextHAlignment]] hAlignment)
	if (self._object ~= nil) then
		kd.StaticTextSetHAlignment(self._object, hAlignment);
	end
end

function kd.StaticText:setLineHeight(--[[float]] height)
	if (self._object ~= nil) then
		kd.StaticTextSetLineHeight(self._object, height);
	end
end

function kd.StaticText:getLineHeight()
	if (self._object ~= nil) then
		return kd.StaticTextGetLineHeight(self._object);
	end
	
	return 0.0;
end

function kd.StaticText:setAdditionalKerning(--[[float]] space)
	if (self._object ~= nil) then
		kd.StaticTextSetAdditionalKerning(self._object, space);
	end
end

function kd.StaticText:getAdditionalKerning()
	if (self._object ~= nil) then
		return kd.StaticTextGetAdditionalKerning(self._object);
	end
	
	return 0.0;
end