local kd = KDGame;

kd.Node = {bCBindingObject = true}

function kd.Node:constr(self, ...)
	self:create(...);
end

function kd.Node:Ruin(self)
	self._object = nil;
end

function kd.Node:create(...)
	self._object = kd.NodeCreate();
end

function kd.Node:addChild(node, nZOrder)
	if (self._object ~= nil and kd.IsNull(node)==false) then
		if (nZOrder == nil) then 
			kd.NodeAddChild(self._object, node._object);
		else 
			kd.NodeAddChild(self._object, node._object, nZOrder); 
		end
	end
end

function kd.Node:RemoveChild(node)
	if (self._object ~= nil and kd.IsNull(node)==false) then
		kd.NodeRemoveChild(self._object, node._object);
		node._object = nil;
	end
end

function kd.Node:ChangeParent(new_parent)
	if (self._object ~= nil and kd.IsNull(new_parent)==false) then
		kd.NodeChangeParent(self._object, new_parent._object);
	end
end

function kd.Node:SetZOrder(--[[int]] zorder)
	if (self._object ~= nil) then
		return kd.NodeSetZOrder(self._object,zorder);
	end
end

function kd.Node:GetZOrder()
	if (self._object ~= nil) then
		local ZOrder = kd.NodeGetZOrder(self._object);
		return ZOrder;
	end
	
	return -1;	
end

function kd.Node:SetPos(x, y)
	if (self._object ~= nil) then 
		kd.NodeSetPos(self._object, x, y); 
	end
end

function kd.Node:SetVisible(visible)
	if (self._object ~= nil) then
		kd.NodeSetVisible(self._object, visible);
	end
end

function kd.Node:SetColor(_ARGB_)
	if (self._object ~= nil) then
		kd.NodeSetColor(self._object, _ARGB_);
	end
end

function kd.Node:SetHotSpot(x, y)
	if (self._object ~= nil) then
		kd.NodeSetHotSpot(self._object, x, y);
	end
end

function kd.Node:SetScale(sx, sy)
	if (self._object ~= nil) then
		kd.NodeSetScale(self._object, sx, sy);
	end
end

function kd.Node:SetRotation(rot)
	if (self._object ~= nil) then
		kd.NodeSetRotation(self._object, rot);
	end
end

function kd.Node:SetRotation3D(xrot, yrot, zrot)
	if (self._object ~= nil) then
		kd.NodeSetRotation3D(self._object, xrot, yrot, zrot);
	end
end

function kd.Node:GetPos()
	if (self._object ~= nil) then
		local x, y = kd.NodeGetPos(self._object);
		return x, y;
	end
	
	return -1, -1;
end

function kd.Node:IsVisible()
	if (self._object ~= nil) then
		local visible = kd.NodeIsVisible(self._object);
		return visible;
	end
	
	return false;
end

function kd.Node:GetColor()
	if (self._object ~= nil) then
		local _ARGB_ = kd.NodeGetColor(self._object);
		return _ARGB_;
	end
	
	return 0x0;
end

function kd.Node:GetHotSpot()
	if (self._object ~= nil) then
		local x, y = kd.NodeGetHotSpot(self._object);
		return x, y;
	end
	
	return -1, -1;
end

function kd.Node:GetWH()
	if (self._object ~= nil) then
		local w, h = kd.NodeGetWH(self._object);
		return w, h;
	end
	
	return -1, -1;
end

function kd.Node:GetScale()
	if (self._object ~= nil) then
		local sx, sy = kd.NodeGetScale(self._object);
		return sx, sy;
	end
	
	return -1, -1;
end

function kd.Node:GetRotation()
	if (self._object ~= nil) then
		local rot = kd.NodeGetRotation(self._object);
		return rot;
	end
	
	return 0;
end

function kd.Node:GetRotation3D()
	if (self._object ~= nil) then
		return kd.NodeGetRotation3D(self._object);
	end
	
	return 0, 0, 0;
end
