local kd = KDGame;

kd.EditBox = kd.inherit(kd.Layer);

function kd.EditBox:constr(self, ...)
	local cnt = select("#", ...);
	
	if (cnt < 5) then
		return;
	end
	
	local _w = select(1, ...);
	local _h = select(2, ...);
	local bgPath = select(3, ...);
	local fontSize = select(4, ...);
	local fontColor = select(5, ...);
	
	self.EditBoxItem = kd.class(kd.EditBoxItem,...);
	self:addChild(self.EditBoxItem);
	--self.EditBoxItem = kd.EditCreate(_w, _h, bgPath, fontSize, fontColor);	
end

function kd.EditBox:Ruin(self)
	
end

function kd.EditBox:SetMaxLength(--[[int]] maxlen)
	if (self.EditBoxItem ~= nil) then
		self.EditBoxItem:SetMaxLength(maxlen);
	end
end

function kd.EditBox:GetMaxLength()
	if (self.EditBoxItem ~= nil) then
		return self.EditBoxItem:GetMaxLength();
	end
	
	return -1;
end

function kd.EditBox:SetInputMode(--[[KDGame.InputMode]] mode)
	if (self.EditBoxItem ~= nil) then
		self.EditBoxItem:SetInputMode(mode);
	end
end

function kd.EditBox:SetInputFlag(--[[KDGame.InputFlag]] flag)
	if (self.EditBoxItem ~= nil) then
		self.EditBoxItem:SetInputFlag(flag);
	end
end

function kd.EditBox:SetReturnType(--[[KDGame.KeyboardReturnType]] _type)
	if (self.EditBoxItem ~= nil) then
		self.EditBoxItem:SetReturnType(_type);
	end
end

function kd.EditBox:SetTitle(--[[string]] title, --[[uint]] fontColor)
	if (self.EditBoxItem ~= nil) then
		self.EditBoxItem:SetTitle(title, fontColor);
	end
end

function kd.EditBox:SetText(--[[string]] str)
	if (self.EditBoxItem ~= nil) then
		self.EditBoxItem:SetText(str);
	end
end

function kd.EditBox:GetText()
	if (self.EditBoxItem ~= nil) then
		return self.EditBoxItem:GetText();
	end
	
	return nil;
end

function kd.EditBox:SetDelegate(--[[KDGame.EidtBoxDelegate]] delegate)
	if (self.EditBoxItem ~= nil) then
		self.EditBoxItem:SetDelegate(delegate);
	end
end

kd.EditBoxItem = kd.inherit(kd.Node);

function kd.EditBoxItem:constr(self, ...)
	
end

function kd.EditBoxItem:Ruin(self)
	
end

function kd.EditBoxItem:create(...--[[float w, float h, 
							string bgPath, 
							int fontSize, 
							UINT fontColor]])
	local cnt = select("#", ...);
	
	if (cnt < 5) then
		return;
	end
	
	local _w = select(1, ...);
	local _h = select(2, ...);
	local bgPath = select(3, ...);
	local fontSize = select(4, ...);
	local fontColor = select(5, ...);
	
	self._object = kd.EditCreate(_w, _h, bgPath, fontSize, fontColor);
end

function kd.EditBoxItem:SetMaxLength(--[[int]] maxlen)
	if (self._object ~= nil) then
		kd.EditSetMaxLength(self._object, maxlen);
	end
end

function kd.EditBoxItem:GetMaxLength()
	if (self._object ~= nil) then
		return kd.EditGetMaxLength(self._object);
	end
	
	return -1;
end

function kd.EditBoxItem:SetInputMode(--[[KDGame.InputMode]] mode)
	if (self._object ~= nil) then
		kd.EditSetInputMode(self._object, mode);
	end
end

function kd.EditBoxItem:SetInputFlag(--[[KDGame.InputFlag]] flag)
	if (self._object ~= nil) then
		kd.EditSetInputFlag(self._object, flag);
	end
end

function kd.EditBoxItem:SetReturnType(--[[KDGame.KeyboardReturnType]] _type)
	if (self._object ~= nil) then
		kd.EditSetReturnType(self._object, _type);
	end
end

function kd.EditBoxItem:SetTitle(--[[string]] title, --[[uint]] fontColor)
	if (self._object ~= nil) then
		kd.EditSetTitle(self._object, title, fontColor);
	end
end

function kd.EditBoxItem:SetText(--[[string]] str)
	if (self._object ~= nil) then
		kd.EditSetText(self._object, str);
	end
end

function kd.EditBoxItem:GetText()
	if (self._object ~= nil) then
		return kd.EditGetText(self._object);
	end
	
	return nil;
end

function kd.EditBoxItem:SetDelegate(--[[KDGame.EidtBoxDelegate]] delegate)
	if (self._object ~= nil and delegate._object ~= nil) then
		kd.EditSetDelegate(self._object, delegate._object);
	end
end