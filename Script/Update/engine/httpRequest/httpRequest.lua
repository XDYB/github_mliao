local kd = KDGame;

kd.HttpRequest = {
	bCBindingObject = true,
	_object = 0,
	nIdx = -1,
	
	--发起GET请求
	SendHttpGETRequest = function( self, --[[uint]] _uID, --[[string]] _szUrl)
		if (self._object ~= nil) then		
			return kd.SendHttpGETRequest(self._object, _uID, _szUrl);
		end
	end;
	
	--发起POST请求
	SendHttpPOSTRequest = function( self, --[[uint]] _uID, --[[string]] _szUrl, --[[string]] _szHeadInfo, --[[string]] _szPostInfo)
		if (self._object ~= nil) then		
			return kd.SendHttpPOSTRequest(self._object, _uID, _szUrl, _szHeadInfo, _szPostInfo);
		end
	end;	
	
	--[[回调接口 ================================================================================]]
	
	--GET事务回调函数
	OnHttpGETRequest = function(self, 
								--[[uint]] _uID, 			--事务ID
								--[[string]] data, 			--GET下来的JSON格式字符串数据
								--[[int]] size,				--GET下来的数据长度
								--[[int]] nErrorCode,		--错误编码(非0为错误)
								--[[string]] szError)		--错误信息
		
	end;
	
	--POST事务回调函数
	OnHttpPOSTRequest = function(self, 
								--[[uint]] _uID, 			--事务ID
								--[[string]] data, 			--POST下来的JSON格式字符串数据
								--[[int]] size,				--POST下来的数据长度
								--[[int]] nErrorCode,		--错误编码(非0为错误)
								--[[string]] szError)		--错误信息
		
	end;	
}

function kd.HttpRequest:constr(self, ...)
	self.nIdx = kd.RegLuaTable(self);
	self._object = kd.CreateHttpRequestAgent(self.nIdx);
	
	--C层对象生成失败,取消table全局绑定
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
	end
end

function kd.HttpRequest:Ruin(self)
	kd.FreeHttpRequestAgent(self._object);
end