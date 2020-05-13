local kd = KDGame;

kd.VideoView = kd.inherit(kd.Node);

--视频分辨率
kd.VideoView.VideoQualityType =
{
    V_QUALITY_TYPE_360P = 0,
    V_QUALITY_TYPE_480P = 1,
    V_QUALITY_TYPE_720P = 2,
    V_QUALITY_TYPE_1080P = 3,
    V_QUALITY_TYPE_ERROR = 4,
}

function kd.VideoView:constr(self, ...)
	
end

function kd.VideoView:Ruin(self)

end

function kd.VideoView:create(...--[[int w, int h, uint net_time_out=10000, int adapter=0]])
	local cnt = select("#", ...);
	if (cnt < 2) then
		return;
	end
		
	local w = select(1, ...);
	local h = select(2, ...);
	local net_time_out = select(3, ...);
	local adapter = select(4, ...);
	
	self.nIdx = kd.RegLuaTable(self);
	self._object = kd.AVViewCreate(self.nIdx, w, h, net_time_out, adapter);
	
	--C层对象生成失败,取消table全局绑定
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
	end
end

--播放视频(file_url:本地地址或者网络地址;quality:视频分辨率)(暂时仅支持MP4，MP3)
function kd.VideoView:Play(--[[string]] file_url, --[[int]] quality --[[=kd.VideoView.VideoQualityType.V_QUALITY_TYPE_720P]])
	if (self._object ~= nil) then 
		return kd.AVViewPlay(self._object, file_url, quality); 
	end
	
	return false,"C层对象生成失败";
end

--暂停播放(不传参会根据实际的播放情况操作)
function kd.VideoView:Pause(--[[bool]] pause --[[= nil]])
	if (self._object ~= nil) then 
		kd.AVViewPause(self._object, pause); 
	end
end

--停止播放
function kd.VideoView:Stop()
	if (self._object ~= nil) then 
		kd.AVViewStop(self._object); 
	end
end

--调试输出
function kd.VideoView:DebugOut(--[[bool]] show)
	if (self._object ~= nil) then 
		kd.AVViewDebugOut(self._object, show); 
	end
end

--获取缓冲时长(s)
function kd.VideoView:GetBufferClock()
	if (self._object ~= nil) then 
		return kd.AVViewGetBufferClock(self._object); 
	end
	
	return 0;
end

--获取播放时长(s)
function kd.VideoView:GetPlayClock()
	if (self._object ~= nil) then 
		return kd.AVViewGetPlayClock(self._object); 
	end
	
	return 0;
end

--获取视频总时长(s)
function kd.VideoView:GetMaxTime()
	if (self._object ~= nil) then 
		return kd.AVViewGetMaxTime(self._object); 
	end
	
	return 0;
end

--[[回调接口 ================================================================================]]

--异步错误回调
function kd.VideoView:OnplayError(--[[int]] err_code, --[[string]] err_msg)
	kd.LogOut("KD_LOG:kd.VideoView:OnplayError err_code="..err_code..",err_msg="..err_msg);
	return;
end

--播放结束回调
function kd.VideoView:OnplayEnd()
	kd.LogOut("KD_LOG:kd.VideoView:OnplayEnd");
	return;
end

--视频信息回调
function kd.VideoView:OnVideoInfo(--[[int]]w, --[[int]]h, --[[float]] r)
	
end