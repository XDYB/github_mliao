local kd = KDGame;

kd.Button = kd.inherit(kd.Node)

function kd.Button:constr(self, ...)
	
end

function kd.Button:Ruin(self)
	
end

function kd.Button:create(...--[[Layer Father,
									int nID,
									float x, float y,
									string _backPath,
									KDGame.tRect _texRect,
									string _title,
									int nFontSize,
									uint _ARGB_
									]])
	local cnt = select("#", ...);
	
	if (cnt < 9) then 
		return;
	end

	local father = select(1, ...);
	if (kd.IsNull(father) == true) then
		return;
	end
	
	local nID = select(2, ...);
	local x = select(3, ...);
	local y = select(4, ...);
	local _backPath = select(5, ...);
	local _texRect = select(6, ...);
	local _title = select(7, ...);
	local nFontSize = select(8, ...);
	local _ARGB_ = select(9, ...);
	
	self._object = kd.BntCreate(father._object, nID, x, y, _backPath, _texRect, _title, nFontSize, _ARGB_);
end

function kd.Button:setNewTopImg(--[[string]] _topImg)
	if (self._object ~= nil) then
		kd.BntsetNewTopImg(self._object, _topImg);
	end
end

function kd.Button:setEnabledImg(--[[string]] _endImg, --[[KDGame.tRect]] _texRect)
	if (self._object ~= nil) then
		kd.BntsetEnabledImg(self._object, _endImg, _texRect);
	end
end

function kd.Button:SetTitle(--[[string]] _txt, --[[int]] nFontSzie --[[=-1]], --[[uint]] col--[[=nil]])
	if (self._object ~= nil) then
		local _nFontSzie = -1;
		local _col = 0;
		if (nFontSzie ~= nil) then _nFontSzie = nFontSzie; end
		if (col ~= nil) then _col = col; end
		kd.BntSetTitle(self._object, _txt, _nFontSzie, _col);
	end
end

function kd.Button:SetPos(x, y)
	if (self._object ~= nil) then
		kd.BntSetPos(self._object, x, y); 
	end
end

function kd.Button:GetPos()
	local x, y = 0, 0;
	if (self._object ~= nil) then
		x, y = kd.BntGetPos(self._object);
	end
	
	return x, y;
end

function kd.Button:SetEnable(bEnable)
	if (self._object ~= nil) then
		kd.BntSetEnable(self._object, bEnable); 
	end
end

function kd.Button:SetTitlePosOffset(x, y)
	if (self._object ~= nil) then
		kd.BntSetTitlePosOffset(self._object, x, y); 
	end
end

