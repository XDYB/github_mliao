local kd = KDGame;

kd.ResManage = kd.class(kd.Node);

function kd.ResManage:constr(self, ...)
	
end

function kd.ResManage:Ruin(self)
	
end

function kd.ResManage:create(...--[[string lpUIFilePath, kd.Layer layer]])
	local cnt = select("#", ...);
	if (cnt < 2) then
		return;
	end
	local lpUIFilePath = select(1, ...);
	local bcaklayer = select(2, ...);

	self._object = 	kd.RMCreate(lpUIFilePath, bcaklayer._object);
	return;
end

function kd.ResManage:SetBackVisible(--[[bool]] visible)
	if (self._object ~= nil) then
		kd.RMSetBackVisible(self._object, visible);
	end 
end

function kd.ResManage:SetCenterVisible(--[[bool]] visible)
	if (self._object ~= nil) then
		kd.RMSetCenterVisible(self._object, visible);
	end 
end

function kd.ResManage:SetUpVisible(--[[bool]] visible)
	if (self._object ~= nil) then
		kd.RMSetUpVisible(self._object, visible);
	end 
end

function kd.ResManage:GetRenderDec(--[[int]] iResID)
	if (self._object ~= nil) then
		return kd.RMGetRenderDec(self._object, iResID);
	end
	
	return nil;
end

function kd.ResManage:GetSprite(--[[int]] iResID)
	if (self._object ~= nil) then
		local lpSprite = kd.RMGetSprite(self._object, iResID);
		if (lpSprite == nil) then return nil; end
		
		--创建lua Sprite
		local lpLuaSprite = kd.new(kd.Sprite);
		if (lpLuaSprite ~= nil) then
			lpLuaSprite._object = lpSprite;
		end
		
		return lpLuaSprite;
	end
	
	return nil;
end

function kd.ResManage:GetAnimation(--[[int]] iResID)
	if (self._object ~= nil) then
		local lpAnim = kd.RMGetAnimation(self._object, iResID);
		if (lpAnim == nil) then return nil; end
		
		--创建lua Anim
		local lpLuaAnim = kd.new(kd.AniWholeImg);
		if (lpLuaAnim ~= nil) then
			lpLuaAnim._object = lpAnim;
		end
		
		return lpLuaAnim;
	end
	
	return nil;
end

function kd.ResManage:GetText(--[[int]] iResID)
	if (self._object ~= nil) then
		local lpText = kd.RMGetText(self._object, iResID);
		if (lpText == nil) then return nil; end
		
		--创建lua Static Text
		local lpLuaText = kd.new(kd.StaticText);
		if (lpLuaText ~= nil) then
			lpLuaText._object = lpText;
		end
		
		return lpLuaText;
	end
	
	return nil;
end

function kd.ResManage:GetButton(--[[int]] iResID)
	if (self._object ~= nil) then
		local lpButton = kd.RMGetButton(self._object, iResID);
		if (lpButton == nil) then return nil; end
		
		--创建lua Button
		local lpLuaButton = kd.new(kd.Button);
		if (lpLuaButton ~= nil) then
			lpLuaButton._object = lpButton;
		end
		
		return lpLuaButton;
	end
	
	return nil;
end

function kd.ResManage:SetCustomRes(--[[int]] iResID, --[[KDGame.Node]] lpCusRes)
	if (self._object ~= nil) and (kd.IsNull(lpCusRes) == false) then
		return kd.RMSetCustomRes(self._object, iResID, lpCusRes._object);
	end
	
	return false;
end

function kd.ResManage:DelCustomRes(--[[int]] iResID, --[[KDGame.Node]] lpCusRes)
	if (self._object ~= nil) and (kd.IsNull(lpCusRes) == false) then
		return kd.RMDelCustomRes(self._object, iResID, lpCusRes._object);
	end
	
	return false;
end

function kd.ResManage:SetVisible(--[[int]] iResID, --[[bool]] bVisible)
	if (self._object ~= nil) then
		kd.RMSetVisible(self._object, iResID, bVisible);
	end
end

function kd.ResManage:IsVisible(--[[int]] iResID)
	if (self._object ~= nil) then
		return kd.RMIsVisible(self._object, iResID);
	end
	
	return false;
end

function kd.ResManage:SetViewVisible(--[[bool]] bVisible)
	if (self._object ~= nil) then
		kd.RMSetViewVisible(self._object, bVisible);
	end
end

function kd.ResManage:IsViewVisible()
	if (self._object ~= nil) then
		return kd.RMIsViewVisible(self._object);
	end
	
	return false;
end

function kd.ResManage:GetRect(--[[int]] iResID)
	if (self._object ~= nil) then
		return kd.RMGetRect(self._object, iResID);
	end
	
	return 0, 0, 0, 0;
end

function kd.ResManage:GetScaleRect(--[[int]] iResID)
	if (self._object ~= nil) then
		return kd.RMGetScaleRect(self._object, iResID);
	end
	
	return 0, 0, 0, 0;
end

