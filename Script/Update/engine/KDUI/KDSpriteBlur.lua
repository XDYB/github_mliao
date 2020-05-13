local kd = KDGame;

kd.SpriteBlur = kd.inherit(kd.Sprite);

function kd.SpriteBlur:constr(self, ...)
	
end

function kd.SpriteBlur:Ruin(self)
	
end

function kd.SpriteBlur:create(...--[[string texfile, 
									float texx=0.0f,
									float texy=0.0f,
									float w=0.0f,
									float h=0.0f]])
	--获取传参
	local cont = select("#", ...);
	if (cont < 1) then 
		print("KDGame.SpriteBlur:init error:错误的传输数量!");
		return;
	end
	
	local szFile = select(1, ...);
	
	if (cont == 5) then 
		local tx = select(2, ...);
		local ty = select(3, ...);
		local tw = select(4, ...);
		local th = select(5, ...);
		
		self._object = c_SprBlurCreate(szFile, tx, ty, tw, th);	
	else 
		self._object = c_SprBlurCreate(szFile);	
	end
end

--设置模糊采样半径
function kd.SpriteBlur:SetBlurRadius(--[[float]] radius)
	if (self._object ~= nil) then
		c_SprBlurSetBlurRadius(self._object, radius);
	end
end

--设置模糊采样数量
function kd.SpriteBlur:SetBlurSampleNum(--[[float]] num)
	if (self._object ~= nil) then
		c_SprBlurSetBlurSampleNum(self._object, num);
	end
end

