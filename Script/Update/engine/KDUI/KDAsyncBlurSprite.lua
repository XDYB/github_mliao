local kd = KDGame;

kd.AsyncSpriteBlur = kd.inherit(kd.SpriteBlur);

kd.AsyncSpriteBlur.nIdx = -1;

function kd.AsyncSpriteBlur:constr(self, ...)
	
end

function kd.AsyncSpriteBlur:Ruin(self)
	
end

function kd.AsyncSpriteBlur:create(...--[[string tex_img, 
									float texx=0.0f,
									float texy=0.0f,
									float w=0.0f,
									float h=0.0f]])
	--获取传参
	local cont = select("#", ...);
	if (cont < 1) then 
		print("KDGame.AsyncSpriteBlur:init error:错误的传输数量!");
		return;
	end
	
	self.nIdx = kd.RegLuaTable(self);
	
	local tex_img = select(1, ...);
	
	if (cont == 5) then 
		local tx = select(2, ...);
		local ty = select(3, ...);
		local tw = select(4, ...);
		local th = select(5, ...);
		
		self._object = kd.AsyncSprBlurCreate(self.nIdx, tex_img, tx, ty, tw, th);	
	else 
		self._object = kd.AsyncSprBlurCreate(self.nIdx, tex_img);	
	end
	
	--C层对象生成失败,取消table全局绑定
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
	end	
end

function kd.AsyncSpriteBlur:SetTexture(--[[string]] szTexFile,									
									--[[float]] texx--[[=0.0f]],
									--[[float]] texy--[[=0.0f]],
									--[[float]] w--[[=0.0f]],
									--[[float]] h--[[=0.0f]])
	if (self._object ~= nil) then
		kd.AsyncSprBlurSetTexture(self._object, szTexFile, texx, texy, w, h);
	end
end

function kd.AsyncSpriteBlur:GetTexturePath()
	if (self._object ~= nil) then
		return kd.AsyncSprBlurGetTextureFilePath(self._object);
	end
end

--[[回调接口 ================================================================================]]

--加载三级缓存纹理结果回调
function kd.AsyncSpriteBlur:OnLoadTextrue(--[[int]] err_code --[[0:成功]], --[[string]] err_info)

end