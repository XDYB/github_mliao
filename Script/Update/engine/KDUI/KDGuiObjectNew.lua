local kd = KDGame;

kd.GuiObjectNew = kd.inherit(kd.Node);

function kd.GuiObjectNew:constr(self, ...)
	
end

function kd.GuiObjectNew:Ruin(self)

end

function kd.GuiObjectNew:create(...--[[KDGame.Layer Father, 
									int nID, 
									float x, y, w, h, 
									boolean bUpdate = false,
									boolean bTouch = false]])
	local cnt = select("#", ...);
	if (cnt < 6) then
		return;
	end
	
	local Father = select(1, ...);
	if (kd.IsNull(Father) == true) then
		return;
	end
	
	local nID = select(2, ...);
	local x = select(3, ...);
	local y = select(4, ...);
	local w = select(5, ...);
	local h = select(6, ...);
	
	local bUpdate = false;
	if (cnt > 6) then bUpdate = select(7, ...); end
	local bTouch = false;
	if (cnt > 7) then bTouch = select(8, ...); end
	
	self.nIdx = kd.RegLuaTable(self);
	self._object = kd.GuiObjectNewCreate(self.nIdx, Father._object, nID, bUpdate, bTouch, x, y, w, h);
	
	--C层对象生成失败,取消table全局绑定
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
	end
end

function kd.GuiObjectNew:SetEnable(bEnable)
	if (self._object ~= nil) then 
		kd.GuiObjectNewSetEnable(self._object, bEnable); 
	end
end

function kd.GuiObjectNew:SetPos(x, y)
	if (self._object ~= nil) then 
		kd.GuiObjectNewSetPos(self._object, x, y); 
	end
end

function kd.GuiObjectNew:SetTouchRect(x, y, w, h)
	if (self._object ~= nil) then
		kd.GuiObjectNewSetRect(self._object, x, y, w, h);
	end
end

function kd.GuiObjectNew:GetTouchRect()
	if (self._object ~= nil) then
		return kd.GuiObjectNewGetTouchRect(self._object);
	end
	
	return 0,0,0,0;
end

--矩形裁剪
function kd.GuiObjectNew:setRectClipping(--[[float]] x, --[[float]] y, --[[float]] w, --[[float]] h)
	if (self._object ~= nil) then
		kd.GuiObjectNewSetRectClipping(self._object, x, y, w, h);
	end
end

--蒙版裁剪
function kd.GuiObjectNew:setMaskingClipping(--[[KDGame.Node]] _node)
	if (self._object ~= nil and kd.IsNull(_node) == false) then
		kd.GuiObjectNewsetMaskingClipping(self._object, _node._object);
	end
end

--清除裁剪
function kd.GuiObjectNew:cancelClipping()
	if (self._object ~= nil) then
		kd.GuiObjectNewcancelClipping(self._object);
	end
end

--设置DEBUG绘制模式
function kd.GuiObjectNew:setDebugMode(--[[bool]] mode)
	if (self._object ~= nil) then
		KDGame.GuiObjectNewSetDebugMode(self._object, mode);
	end
end

--[[回调接口 ================================================================================]]

function kd.GuiObjectNew:Init()
	return true;
end

function kd.GuiObjectNew:update(--[[float]] delta)
	return;
end

function kd.GuiObjectNew:onTouchBegan()
	return true;
end

function kd.GuiObjectNew:onTouchEnded()
	return;
end