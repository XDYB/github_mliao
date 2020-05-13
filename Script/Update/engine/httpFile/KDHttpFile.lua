local kd = KDGame;

kd.HttpFile = {
	bCBindingObject = true,
	_object = 0,
	nIdx = -1,
	
	--发起http-file请求
	SendHttpFileRequest = function( self,
									--[[KDGame.emHttpFileTaskType]] _type, 
									--[[string]] _szUrl, 
									--[[string]] _szFilePath,
									--[[string]] _szFileName,
									--[[bool]] _IsSaveToSDCard,
									--[[string]] _param, 
									...)
		if (self._object ~= nil) then
			local nCnt = select("#", ...);
			
			local tparam = {0, 0, 0, 0};
			if (nCnt > 0) then
				if (nCnt > 4) then nCnt = 4 end
				
				for i=1, nCnt do
					tparam[i] = select(i, ...);
				end
			end
			
			return kd.SendHttpFileRequest(self._object, 
									_type, 
									_szUrl, 
									_szFilePath,
									_szFileName,
									_IsSaveToSDCard,
									_param,
									tparam[1],
									tparam[2],
									tparam[3],
									tparam[4]);
		end
	end;
	
	--[[回调接口 ================================================================================]]
	
	--进度回调函数
	OnHttpFileDownProgress = function(self, --[[double]] MaxLen, --[[double]] DwonLen, --[[double]] _progress)
		local strMsg = string.format("下载进度:%.2f %.2f/%.2f", _progress, DwonLen, MaxLen);
		kd.LogOut(strMsg);
	end;
	
	--结果回调函数
	OnHttpFileRequest = function(self,
								--[[KDGame.emHttpFileTaskType]] _type,
								--[[int]] _nErrorCode,
								--[[string]] _szError,
								--[[string]] _szFilePath,
								--[[uint]] param0,
								--[[uint]] param1,
								--[[uint]] param2,
								--[[uint]] param3)
		
	end;
}

function kd.HttpFile:constr(self, ...)
	self.nIdx = kd.RegLuaTable(self);
	self._object = kd.CreateHttpFileAgent(self.nIdx);
	
	--C层对象生成失败,取消table全局绑定
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
	end
end

function kd.HttpFile:Ruin(self)
	kd.FreeHttpFileAgent(self._object);
end