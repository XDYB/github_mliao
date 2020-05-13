local kd = KDGame;

kd.HttpRequest = {
	bCBindingObject = true,
	_object = 0,
	nIdx = -1,
	
	--����GET����
	SendHttpGETRequest = function( self, --[[uint]] _uID, --[[string]] _szUrl)
		if (self._object ~= nil) then		
			return kd.SendHttpGETRequest(self._object, _uID, _szUrl);
		end
	end;
	
	--����POST����
	SendHttpPOSTRequest = function( self, --[[uint]] _uID, --[[string]] _szUrl, --[[string]] _szHeadInfo, --[[string]] _szPostInfo)
		if (self._object ~= nil) then		
			return kd.SendHttpPOSTRequest(self._object, _uID, _szUrl, _szHeadInfo, _szPostInfo);
		end
	end;	
	
	--[[�ص��ӿ� ================================================================================]]
	
	--GET����ص�����
	OnHttpGETRequest = function(self, 
								--[[uint]] _uID, 			--����ID
								--[[string]] data, 			--GET������JSON��ʽ�ַ�������
								--[[int]] size,				--GET���������ݳ���
								--[[int]] nErrorCode,		--�������(��0Ϊ����)
								--[[string]] szError)		--������Ϣ
		
	end;
	
	--POST����ص�����
	OnHttpPOSTRequest = function(self, 
								--[[uint]] _uID, 			--����ID
								--[[string]] data, 			--POST������JSON��ʽ�ַ�������
								--[[int]] size,				--POST���������ݳ���
								--[[int]] nErrorCode,		--�������(��0Ϊ����)
								--[[string]] szError)		--������Ϣ
		
	end;	
}

function kd.HttpRequest:constr(self, ...)
	self.nIdx = kd.RegLuaTable(self);
	self._object = kd.CreateHttpRequestAgent(self.nIdx);
	
	--C���������ʧ��,ȡ��tableȫ�ְ�
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
	end
end

function kd.HttpRequest:Ruin(self)
	kd.FreeHttpRequestAgent(self._object);
end