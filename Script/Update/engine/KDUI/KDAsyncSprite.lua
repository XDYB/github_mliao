local kd = KDGame;

kd.AsyncSprite = kd.inherit(kd.Sprite);

kd.AsyncSprite.nIdx = -1;

function kd.AsyncSprite:constr(self, ...)
	
end

function kd.AsyncSprite:Ruin(self)
	
end

function kd.AsyncSprite:create(...--[[string tex_img, 
									float texx=0.0f,
									float texy=0.0f,
									float w=0.0f,
									float h=0.0f]])
	--获取传参
	local cont = select("#", ...);
	if (cont < 1) then 
		print("KDGame.Sprite:init error:错误的传输数量!");
		return;
	end
	
	self.nIdx = kd.RegLuaTable(self);
	
	local tex_img = select(1, ...);
	
	if (cont == 5) then 
		local tx = select(2, ...);
		local ty = select(3, ...);
		local tw = select(4, ...);
		local th = select(5, ...);
		
		self._object = kd.AsyncSprCreate(self.nIdx, tex_img, tx, ty, tw, th);	
	else 
		self._object = kd.AsyncSprCreate(self.nIdx, tex_img);	
	end
	
	--C层对象生成失败,取消table全局绑定
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
	end	
end

function kd.AsyncSprite:SetTexture(--[[string]] szTexFile,									
									--[[float]] texx--[[=0.0f]],
									--[[float]] texy--[[=0.0f]],
									--[[float]] w--[[=0.0f]],
									--[[float]] h--[[=0.0f]])
	if (self._object ~= nil) then
		kd.AsyncSprSetTexture(self._object, szTexFile, texx, texy, w, h);
	end
end

function kd.AsyncSprite:GetTexturePath()
	if (self._object ~= nil) then
		return kd.AsyncSprGetTextureFilePath(self._object);
	end
end

--[[回调接口 ================================================================================]]

--加载三级缓存纹理结果回调
function kd.AsyncSprite:OnLoadTextrue(--[[int]] err_code --[[0:成功]], --[[string]] err_info)

end