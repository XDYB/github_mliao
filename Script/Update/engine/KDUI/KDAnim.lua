local kd = KDGame;

--[[
	SKY AniMultipleImg:使用散图纹理来做帧的动画类
]]
kd.AniMultipleImg = kd.inherit(kd.Node);

function kd.AniMultipleImg:constr(self, ...)
	
end

function kd.AniMultipleImg:Ruin(self)
	
end

function kd.AniMultipleImg:create(...--[[kd.Layer pFather, int nID, float FPS]])
	local cnt = select("#", ...);
	
	if (cnt < 3) then return; end
	
	local _pFather = select(1, ...);
	local _nID = select(2, ...);
	local _FPS = select(3, ...);
	
	if (kd.IsNull(_pFather) == false) then
		self._object = kd.AniMultipleImgCreate(_pFather._object, _nID, _FPS);
	end
end

function kd.AniMultipleImg:InstFrameSpr(--[[Sprite]] frame)
	if (self._object ~= nil 
		and kd.IsNull(frame) == false) then
		return kd.InstFrameSpr(self._object, frame._object);
	end
end

function kd.AniMultipleImg:Play()
	if (self._object ~= nil) then
		kd.MAniPlay(self._object);
	end
end

function kd.AniMultipleImg:Stop()
	if (self._object ~= nil) then
		kd.MAniStop(self._object);
	end
end

function kd.AniMultipleImg:Pause()
	if (self._object ~= nil) then
		kd.MAnipause(self._object);
	end
end

function kd.AniMultipleImg:Resume()
	if (self._object ~= nil) then
		kd.MAniResume(self._object);
	end
end

function kd.AniMultipleImg:IsPlaying()
	if (self._object ~= nil) then
		return kd.MAniIsPlaying(self._object);
	end
	
	return false;
end

function kd.AniMultipleImg:SetMode(--[[int]] mode)
	if (self._object ~= nil) then
		kd.MAniSetMode(self._object, mode);
	end
end

function kd.AniMultipleImg:SetSpeed(--[[float]] FPS)
	if (self._object ~= nil) then
		kd.MAniSetSpeed(self._object, FPS);
	end
end

function kd.AniMultipleImg:SetFrame(--[[int]] n)
	if (self._object ~= nil) then
		kd.MAniSetFrame(self._object, n);
	end
end

function kd.AniMultipleImg:GetMode()
	if (self._object ~= nil) then
		return kd.MAniGetMode(self._object);
	end 
	
	return -1;
end

function kd.AniMultipleImg:GetSpeed()
	if (self._object ~= nil) then
		return kd.MAniGetSpeed(self._object);
	end 
	
	return -1.0;
end

function kd.AniMultipleImg:GetFrame()
	if (self._object ~= nil) then
		return kd.MAniGetFrame(self._object);
	end 
	
	return -1;
end

function kd.AniMultipleImg:GetFrames()
	if (self._object ~= nil) then
		return kd.MAniGetFrames(self._object);
	end 
	
	return -1;
end

--[[
	SKY AniWholeImg:使用整图纹理指定坐标系来做帧的动画类
]]
kd.AniWholeImg = kd.class(kd.Node)

function kd.AniWholeImg:constr(self, ...)
	self:create(...);
end

function kd.AniWholeImg:Ruin(self)
	
end

function kd.AniWholeImg:create(...--[[kd.Layer pFather,
											int nID,
											const char* filePath,
											int nframes,
											float FPS,
											table xs,
											table ys,
											table ws,
											table hs]])
	local cnt = select("#", ...);
	if (cnt < 9) then
		return;
	end
	
	local _pFather = select(1, ...);
	local _nID = select(2, ...);
	local _filePath = select(3, ...);
	local _nframes = select(4, ...);
	local _fps = select(5, ...);
	local _xs = select(6, ...);
	local _ys = select(7, ...);
	local _ws = select(8, ...);
	local _hs = select(9, ...);
	
	if (kd.IsNull(_pFather) == false) then
		self._object = kd.AniWholeImgCreate(_pFather._object, 
												_nID,
												_filePath,
												_nframes,
												_fps,
												_xs, _ys, _ws, _hs);
	end
end

function kd.AniWholeImg:Play()
	if (self._object ~= nil) then
		kd.WAniPlay(self._object);
	end
end

function kd.AniWholeImg:Stop()
	if (self._object ~= nil) then
		kd.WAniStop(self._object);
	end
end

function kd.AniWholeImg:Pause()
	if (self._object ~= nil) then
		kd.WAnipause(self._object);
	end
end

function kd.AniWholeImg:Resume()
	if (self._object ~= nil) then
		kd.WAniResume(self._object);
	end
end

function kd.AniWholeImg:IsPlaying()
	if (self._object ~= nil) then
		return kd.WAniIsPlaying(self._object);
	end
	
	return false;
end

function kd.AniWholeImg:SetMode(--[[int]] mode)
	if (self._object ~= nil) then
		kd.WAniSetMode(self._object, mode);
	end
end

function kd.AniWholeImg:SetSpeed(--[[float]] FPS)
	if (self._object ~= nil) then
		kd.WAniSetSpeed(self._object, FPS);
	end
end

function kd.AniWholeImg:SetFrame(--[[int]] n)
	if (self._object ~= nil) then
		kd.WAniSetFrame(self._object, n);
	end
end

function kd.AniWholeImg:GetMode()
	if (self._object ~= nil) then
		return kd.WAniGetMode(self._object);
	end 
	
	return -1;
end

function kd.AniWholeImg:GetSpeed()
	if (self._object ~= nil) then
		return kd.WAniGetSpeed(self._object);
	end 
	
	return -1.0;
end

function kd.AniWholeImg:GetFrame()
	if (self._object ~= nil) then
		return kd.WAniGetFrame(self._object);
	end 
	
	return -1;
end

function kd.AniWholeImg:GetFrames()
	if (self._object ~= nil) then
		return kd.WAniGetFrames(self._object);
	end 
	
	return -1;
end

function kd.AniWholeImg:SetDynamicFPS(wTimes, nframes)
	if (self._object ~= nil) then
		return kd.WAniSetDynamicFPS(self._object, wTimes, nframes);
	end
	
	return false;
end