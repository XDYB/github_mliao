local kd = KDGame;

kd.Layer = kd.inherit(kd.Node)

kd.Layer.nIdx = -1;

function kd.Layer:constr(self, ...)
	
end

function kd.Layer:Ruin(self)

end

function kd.Layer:create(...--[[bool bUpdate=false, bool bInput=false]])
	local bUpdate = false;
	local bInput = false;
	
	--获取传参
	local cont = select("#", ...);
		
	if (cont == 2) then 
		bUpdate = select(1, ...);
		bInput = select(2, ...);
	end
	
	self.nIdx = kd.RegLuaTable(self);
	self._object = kd.LayerCreate(self.nIdx, bUpdate, bInput);
	
	--C层对象生成失败,取消table全局绑定
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
	end	
end

function kd.Layer:SetVisible(visible)
	if (self._object ~= nil) then
		kd.LayerSetVisible(self._object, visible);
	end
end

function kd.Layer:SetActionType(--[[KDGame.emActionType]] _type, --[[float]] dx,dy,ax,ay)
	if (self._object ~= nil) then
		if (dx == nil or dy == nil) then kd.LayerSetActionType(self._object, _type);
		elseif (ax == nil or ay == nil) then kd.LayerSetActionType(self._object, _type, dx, dy); 
		else kd.LayerSetActionType(self._object, _type, dx, dy, ax, ay);
		end
	end
end

function kd.Layer:Init()
	print("KD_LOG:KDGame.Layer:Init");
	return true;
end

function kd.Layer:SetTimer(--[[int]] id, --[[UINT]] dwElapse, --[[UINT]] dwRepeat)
	if (self._object ~= nil) then
		return kd.SetTimer(self._object, id, dwElapse, dwRepeat);
	end
	
	return false;
end
 
function kd.Layer:KillTimer(--[[int]] id)
	if (self._object ~= nil) then
		return kd.KillTimer(self._object, id);
	end
end

function kd.Layer:KillMeAllTimer()
	if (self._object ~= nil) then
		return kd.KillLayerAllTimer(self._object);
	end
end

function kd.Layer:update(--[[float]] delta)
	
end

--设置DEBUG绘制模式
function kd.Layer:setDebugMode(--[[bool]] mode)
	if (self._object ~= nil) then
		KDGame.LayerSetDebugMode(self._object, mode);
	end
end

--[[回调接口 ================================================================================]]

function kd.Layer:onTouchBegan(--[[float]] x, --[[float]] y)
	print("KD_LOG:KDGame.Layer.onTouchBegan:x:"..x.." y:"..y);
	return true;
end

function kd.Layer:onTouchMoved(--[[float]] x, --[[float]] y)
	print("KD_LOG:KDGame.Layer.onTouchMoved:x:"..x.." y:"..y);
	return;
end

function kd.Layer:onTouchEnded(--[[float]] x, --[[float]] y)
	print("KD_LOG:KDGame.Layer.onTouchEnded:x:"..x.." y:"..y);
	return;
end

function kd.Layer:onGuiToucBackCall(--[[int]] id)
	return;
end

function kd.Layer:onAniPlayBackCall(--[[int]] id)
	return;
end

function kd.Layer:OnTimerBackCall(--[[int]] id)
	return;
end

--显示隐藏效果播放结束
function kd.Layer:OnActionEnd()
	
end

