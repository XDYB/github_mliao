local kd = KDGame;

kd.PageGrid3D = kd.inherit(kd.Node);

kd.PageGrid3D.nIdx = -1;

function kd.PageGrid3D:constr(self, ...)
	
end

function kd.PageGrid3D:Ruin(self)
	
end

function kd.PageGrid3D:create(...)	
	self._object = kd.PG3DCreate();	
end

--添加对象到网格层(0:背面 1:正面)
function kd.PageGrid3D:AddChildToGrid(--[[int]] grid_type, --[[KDGame.Node]] node_object)
	if (self._object ~= nil and kd.IsNull(node_object) == false) then
		kd.PG3DAddChildToGrid(self._object, grid_type, node_object._object);
	end
end

--翻动(只有在开始翻动后才有效,offset根据不同的翻动方向需要传入不同的坐标(x or y))
function kd.PageGrid3D:Flip(--[[float]] offset)
	if (self._object ~= nil) then
		kd.PG3DFlip(self._object, offset);
	end
end

--是否是开始翻动状态
function kd.PageGrid3D:IsStart()
	if (self._object ~= nil) then
		return kd.PG3DIsStart(self._object);
	end
	
	return false;
end

--开始翻动
function kd.PageGrid3D:Start(--[[int]] dir, 
											--[[float]] radius, 
											--[[table<x,y,w,h>]] grid_rect, 
											--[[table<w,h>]] grid_size)
	if (self._object ~= nil) then
		return kd.PG3DStart(self._object, dir, radius, 
									grid_rect.x, grid_rect.y, grid_rect.w, grid_rect.h,
									grid_size.w, grid_size.h);
	end
	
	return false;
end

--结束翻动
function kd.PageGrid3D:End()
	if (self._object ~= nil) then
		kd.PG3DEnd(self._object);
	end
end