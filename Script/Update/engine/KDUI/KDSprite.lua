local kd = KDGame;

kd.Sprite = kd.inherit(kd.Node);

function kd.Sprite:constr(self, ...)
	
end

function kd.Sprite:Ruin(self)
	
end

function kd.Sprite:create(...--[[string texfile, 
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
	
	local szFile = select(1, ...);
	
	if (cont == 5) then 
		local tx = select(2, ...);
		local ty = select(3, ...);
		local tw = select(4, ...);
		local th = select(5, ...);
		
		self._object = kd.SprCreate(szFile, tx, ty, tw, th);	
	else 
		self._object = kd.SprCreate(szFile);	
	end
end

function kd.Sprite:SetTexture(--[[string]] szTexFile)
	if (self._object ~= nil) then
		kd.SprSetTexture(self._object, szTexFile);
	end
end

function kd.Sprite:GetTexWH()
	if (self._object ~= nil) then
		local w, h = kd.SprGetTexWH(self._object);
		return w, h;
	end
	
	return -1, -1;
end

function kd.Sprite:SetTextureRect(--[[float]] x, y, w, h)
	if (self._object ~= nil) then
		kd.SprSetTextureRect(self._object, x, y, w, h);
	end
end

function kd.Sprite:GetTextureRect()
	if (self._object ~= nil) then
		local x, y, w, h = kd.SprGetTextureRect(self._object);
		return x, y, w, h;
	end
	
	return -1, -1, -1, -1;
end

function kd.Sprite:SetFlipX(flip)
	if (self._object ~= nil) then
		kd.SprSetFlipX(self._object, flip);
	end
end

function kd.Sprite:SetFlipY(flip)
	if (self._object ~= nil) then
		kd.SprSetFlipY(self._object, flip);
	end
end

function kd.Sprite:IsFlipX()
	if (self._object ~= nil) then
		local bFlip = kd.SprIsFlipX(self._object);
		return bFlip;
	end
	
	return false;
end

function kd.Sprite:IsFlipY()
	if (self._object ~= nil) then
		local bFlip = kd.SprIsFlipY(self._object);
		return bFlip;
	end
	
	return false;
end

