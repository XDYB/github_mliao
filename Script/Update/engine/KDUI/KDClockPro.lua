local kd = KDGame;

kd.ClockPro = kd.inherit(kd.Node);

function kd.ClockPro:constr(self, ...)
	
end

function kd.ClockPro:Ruin(self)
	
end

function kd.ClockPro:create(...--[[int id, KDGame.Sprite mask]])
	local cnt = select("#", ...);
	
	if (cnt < 2) then
		return;
	end
	
	local nID = select(1, ...);
	local mask = select(2, ...);
	
	if (kd.IsNull(mask) == false) then
		self._object = kd.ClockProCreate(nID, mask._object);
	end
end

function kd.ClockPro:SetAnti(--[[bool]] anti)
	if (self._object ~= nil) then
		kd.ClockProSetAnti(self._object, anti);
	end
end

function kd.ClockPro:Start(--[[float]] second)
	if (self._object ~= nil) then
		kd.ClockProStart(self._object, second);
	end
end

function kd.ClockPro:Stop()
	if (self._object ~= nil) then
		kd.ClockProStop(self._object);
	end
end