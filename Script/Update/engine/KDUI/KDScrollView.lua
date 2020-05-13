local kd = KDGame;

kd.ScrollView = kd.inherit(kd.Node);

kd.ScrollView.nIdx = -1;

function kd.ScrollView:constr(self, ...)
	
end

function kd.ScrollView:Ruin(self)
	
end

function kd.ScrollView:create(...)
	self.nIdx = kd.RegLuaTable(self);
	self._object = kd.ScrollViewCreate(self.nIdx);
	
	--C层对象生成失败,取消table全局绑定
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
	end	
end

--设置可见区域
function kd.ScrollView:setVisibleRect(--[[float]] x,y,w,h)
	if (self._object ~= nil) then
		kd.SVsetVisibleRect(self._object, x, y, w, h);
	end
end

--获取可见区域
function kd.ScrollView:getVisibleRect()
	if (self._object ~= nil) then
		return kd.SVgetVisibleRect(self._object);
	end
	
	return -1, -1, -1, -1;
end

--设置滑动方向
function kd.ScrollView:setSlipDirection(--[[int]] dir)
	if (self._object ~= nil) then
		kd.SVsetSlipDirection(self._object, dir);
	end
end

--将一个绘制层添加到自己的管理中
function kd.ScrollView:addChild(--[[kd.Node]] node, --[[int]] localZOrder --[[=nil]])
	if (self._object ~= nil and kd.IsNull(node) == false) then
		if (localZOrder) then kd.SVaddReandChild(self._object, node._object, localZOrder);
		else kd.SVaddReandChild(self._object, node._object);
		end
	end
end

--将一个绘制层移除出自己的管理
function kd.ScrollView:RemoveChild(--[[kd.Node]] node)
	if (self._object ~= nil and kd.IsNull(node) == false) then
		KDGame.SVRemovReandChild(self._object, node._object);
	end
end

--设置实际的绘制宽高
function kd.ScrollView:setRenderViewMaxWH(--[[float]] w,h)
	if (self._object ~= nil) then
		kd.SVSetRenderViewMaxWH(self._object, w, h);
	end
end

--获取实际的绘制宽高
function kd.ScrollView:getRenderViewMaxWH()
	if (self._object ~= nil) then
		return kd.SVgetRenderViewMaxWH(self._object);
	end
	
	return -1, -1;
end

--[[回调接口 ================================================================================]]

function kd.ScrollView:onTouchBegan(--[[float]] x, --[[float]] y)
	print("KD_LOG:KDGame.ScrollView.onTouchBegan:x:"..x.." y:"..y);
end

function kd.ScrollView:onTouchEnded(--[[float]] x, --[[float]] y)
	print("KD_LOG:KDGame.ScrollView.onTouchEnded:x:"..x.." y:"..y);
	return;
end