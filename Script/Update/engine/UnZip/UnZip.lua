local kd = KDGame;

kd.UnZip = {
	bCBindingObject = true,
	_object = 0,
	nIdx = -1,
	
	--解压文件
	UnZipFile = function( self, --[[uint]] _uID, --[[string]] _szZipFile, --[[stirng]] _dstPath, --[[string]] _szPassword--[[=nil]])
		if (self._object ~= nil) then		
			if (_szPassword ~= nil) then
				return kd.UnZipFile(self._object, _uID, _szZipFile, _dstPath, _szPassword);
			else
				return kd.UnZipFile(self._object, _uID, _szZipFile, _dstPath);
			end
		end
		
		return false;
	end;
	
	--[[回调接口 ================================================================================]]
	
	--解压进度回调
	OnUnZipProgress = function(self, --[[uint]] uID, --[[int]] nTotal, --[[int]] nNow, --[[float]] fProgress)
		local szPrit = string.format("KD_LOG:KDGame.UnZip.OnUnZipProgress %d:[%d-%d:%f]", uID, nTotal, nNow, fProgress);
		print(szPrit);
	end;
	
	--解压失败回调
	OnUnZipFail = function(self, --[[uint]] uID, --[[int]] nErrorCode, --[[string]] szErrorMsg)
		local szPrit = string.format("KD_LOG:KDGame.UnZip.OnUnZipFail %d:[%d-%s]", uID, nErrorCode, szErrorMsg);
		print(szPrit);
	end;
	
	--解压成功(完毕)
	OnUnZipSuccess = function(self, --[[uint]] uID)
		local szPrit = string.format("KD_LOG:KDGame.UnZip.OnUnZipSuccess %d", uID);
		print(szPrit);
	end;
}

function kd.UnZip:constr(self, ...)
	self.nIdx = kd.RegLuaTable(self);
	self._object = KDGame.CreateUnZipAgent(self.nIdx);
	
	--C层对象生成失败,取消table全局绑定
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
	end
end

function kd.UnZip:Ruin(self)
	kd.FreeUnZipAgent(self._object);
end