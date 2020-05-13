
local kd = KDGame;
local gDef = gDef;
UpdateProgress = kd.inherit(kd.Layer);

local idsw =
{
	--/* Image ID */
	ID_IMG_PLPGENGXINJIAZAIKUANG           = 1001,
	ID_IMG_PLPJINDUTIAO                    = 1002,
	ID_IMG_PLPJINDUTIAO1                   = 1003,
	ID_IMG_PLPJINDUTIAOH                   = 1004,
	ID_IMG_PLPJINDUTIAOL                   = 1005,
	--/* Text ID */
	ID_TXT_NO0                             = 4001,
	ID_TXT_NO1                             = 4002,
	ID_TXT_NO2                             = 4003,
	ID_TXT_NO3                             = 4004,
	ID_TXT_NO4                             = 4005,
}

function UpdateProgress:init(father)
	self.m_father = father;	
	
	self.m_Mask = kd.class(MaskUI,false,false)
	self.m_Mask:init(self);
	self:addChild(self.m_Mask);
	
	self.m_thView = gDef.GetUpdateView(self,"update");
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--标题
	self.m_TxtTitle = self.m_thView:GetText(idsw.ID_TXT_NO0);
	if(self.m_TxtTitle) then
		self.m_TxtTitle:SetHAlignment(kd.TextHAlignment.CENTER);
		local x,y = self.m_TxtTitle:GetPos();
		self.m_TxtTitle:SetPos(kd.SceneSize.width/2, y);
		self.m_TxtTitle:SetString("正在更新最新资源");
	end
	
	--下载条
	self.m_sprXiaZaiTiao = self.m_thView:GetSprite(idsw.ID_IMG_PLPJINDUTIAOL);
	self.m_sprXiaZaiTiao:SetTextureRect(0,0,0,0);
	local xx,yy,ww,hh = self.m_thView:GetRect(idsw.ID_IMG_PLPJINDUTIAOL);
	self.m_fXiaZaiTiaoX, self.m_fXiaZaiTiaoY = xx, yy;
	
	--下载大小
	self.m_TxtDaXiao = self.m_thView:GetText(idsw.ID_TXT_NO2);
	if(self.m_TxtDaXiao) then
		self.m_TxtDaXiao:SetHAlignment(kd.TextHAlignment.LEFT);
		local x,y,w,h = self.m_thView:GetRect(idsw.ID_TXT_NO2);
		self.m_TxtDaXiao:SetPos(xx-ww/2+w/2+50, y);
		self.m_TxtDaXiao:SetString("0M/0M");
	end	
	
	--已下载
	self.m_TxtBaiFenBiXZ = self.m_thView:GetText(idsw.ID_TXT_NO3);
	if(self.m_TxtBaiFenBiXZ) then
		self.m_TxtBaiFenBiXZ:SetHAlignment(kd.TextHAlignment.RIGHT);
		local x,y,w,h = self.m_thView:GetRect(idsw.ID_TXT_NO3);
		self.m_TxtBaiFenBiXZ:SetPos(xx+ww/2-w/2-50, y);
		self.m_TxtBaiFenBiXZ:SetString("已下载：0%");
	end		
	
	--进度条
	self.m_sprJinDiTiao = self.m_thView:GetSprite(idsw.ID_IMG_PLPJINDUTIAOH);
	self.m_sprJinDiTiao:SetTextureRect(0,0,0,0);
	xx,yy,ww,hh = self.m_thView:GetRect(idsw.ID_IMG_PLPJINDUTIAOH);
	self.m_fJinDiTiaoX, self.m_fJinDiTiaoY = xx, yy;
	
	--进度百分比
	self.m_TxtBaiFenBiJD = self.m_thView:GetText(idsw.ID_TXT_NO4);
	if(self.m_TxtBaiFenBiJD) then
		self.m_TxtBaiFenBiJD:SetHAlignment(kd.TextHAlignment.CENTER);
		local x,y = self.m_TxtBaiFenBiJD:GetPos();
		self.m_TxtBaiFenBiJD:SetPos(kd.SceneSize.width/2, y);
		self.m_TxtBaiFenBiJD:SetString("进度：0%");
	end
end

function UpdateProgress:SetJinDuTiao(--[[double]] MaxLen, --[[double]] DwonLen, --[[double]] _progress, bUnZip)
	local fSize = _progress/100;
	self.m_sprXiaZaiTiao:SetTextureRect(0,0,fSize*749,12);
	self.m_sprXiaZaiTiao:SetPos(fSize*749/2+164,self.m_fXiaZaiTiaoY);
	
	if(bUnZip) then
		self.m_TxtDaXiao:SetString("正在安装...");
		self.m_TxtBaiFenBiXZ:SetVisible(false);
	else
		local fDwonLen = DwonLen/1024/1024;
		local fMaxLen = MaxLen/1024/1024;
		local fBaiFenBi = string.format("%.2fM/%.2fM", fDwonLen*100, fMaxLen*100);
		self.m_TxtDaXiao:SetString(fBaiFenBi);		
		
		fBaiFenBi = string.format("已下载:%.1f%%",_progress);
		self.m_TxtBaiFenBiXZ:SetString(fBaiFenBi);
		self.m_TxtBaiFenBiXZ:SetVisible(true);
	end
end

function UpdateProgress:SetJinDuTiaoTotal(Down,Total)
	local _progress = Down/Total;
	self.m_sprJinDiTiao:SetTextureRect(0,0,_progress*749,12);
	self.m_sprJinDiTiao:SetPos(_progress*749/2+164,self.m_fJinDiTiaoY);
	
	local strJinDu = string.format("进度:%.2f%%",_progress*100);
	self.m_TxtBaiFenBiJD:SetString(strJinDu);
end

function UpdateProgress:StartDownloadFile(DownList,_type)		
	--热更新	
	if (_type==1 and self.m_httpDown == nil) then
		self.m_httpDown = kd.class(kd.HttpFile);
		if (self.m_httpDown) then
			self.m_httpDown.father = self;
			
			--[[回调接口]]
			self.m_httpDown.OnHttpFileDownProgress = function(self, _dltotal, _dlnow, _progress)
				self.father:SetJinDuTiao(_dltotal, _dlnow, _progress);
			end
			
			self.m_httpDown.OnHttpFileRequest = function(self,
											--[[KDGame.emHttpFileTaskType]] _type,
											--[[int]] _nErrorCode,
											--[[string]] _szError,
											--[[string]] _szFilePath,
											--[[uint]] param0,
											--[[uint]] param1,
											--[[uint]] param2,
											--[[uint]] param3)											
				if (_nErrorCode == 0) then	
					if (self.father.m_mUnZip == nil) then
						self.father.m_mUnZip = kd.class(kd.UnZip);
						self.father.m_mUnZip.f = self.father;
						self.father.m_mUnZip.OnUnZipProgress = function(self, --[[uint]] uID, --[[int]] nTotal, --[[int]] nNow, --[[float]] fProgress)
							self.f:SetJinDuTiao(nTotal, nNow, fProgress, true);
						end
						
						self.father.m_mUnZip.OnUnZipFail = function(self, --[[uint]] uID, --[[int]] nErrorCode, --[[string]] szErrorMsg)
							self.f.m_father:messagebox_updatefail("更新错误:请重试");
						end
						
						self.father.m_mUnZip.OnUnZipSuccess = function(self, --[[uint]] uID)
							self.f:DownloadFile(1);
						end
					end
					
					if(string.len(_szFilePath)<=0 or #self.father.m_DownList<self.father.m_nIndex) then
						self.father.m_father:messagebox_updatefail("更新错误:文件名错误");		
						return;
					end
				
					--效验MD5	
					local strMD5 = kd.File2MD5Code(_szFilePath);
					if(string.upper(strMD5)~=string.upper(self.father.m_DownList[self.father.m_nIndex].md5)) then
						self.father.m_father:messagebox_updatefail("更新错误:下载文件MD5错误");		
						return;					
					end	
					
					if (self.father.m_mUnZip) then
						self.father.m_mUnZip:UnZipFile(1001, "Download/Update.zip", "/");
					end
				else
					--弹出错误MSGBOX
--					self.father.m_father:messagebox_updatefail(_szError);
					self.father.m_father:messagebox_updatefail("更新错误:请重试");	
				end
			end
			
		end
	--完整包更新
	elseif(_type>1 and self.m_httpObject == nil) then
		self.m_httpObject = kd.class(kd.HttpFile);
		if (self.m_httpObject) then
			self.m_httpObject.father = self;
			
			--[[回调接口]]
			self.m_httpObject.OnHttpFileDownProgress = function(self, _dltotal, _dlnow, _progress)
				self.father:SetJinDuTiao(_dltotal, _dlnow, _progress);
			end
			
			self.m_httpObject.OnHttpFileRequest = function(self,
											--[[KDGame.emHttpFileTaskType]] _type,
											--[[int]] _nErrorCode,
											--[[string]] _szError,
											--[[string]] _szFilePath,
											--[[uint]] param0,
											--[[uint]] param1,
											--[[uint]] param2,
											--[[uint]] param3)
				if (_nErrorCode ~= 0) then
					--弹出错误MSGBOX
--					self.father.m_father:messagebox_updatefail(_szError);		
					self.father.m_father:messagebox_updatefail("更新错误:请重试");	
					return;
				end
				
				if(string.len(_szFilePath)<=0 or #self.father.m_DownList<self.father.m_nIndex) then
					self.father.m_father:messagebox_updatefail("更新错误:文件名错误");		
					return;
				end
				
				--效验MD5	
				local strMD5 = kd.File2MD5Code(_szFilePath);
				if(strMD5~=self.father.m_DownList[self.father.m_nIndex].md5) then
					self.father.m_father:messagebox_updatefail("更新错误:下载文件MD5错误");		
					return;					
				end	
							
				--判断是安卓的情况下调用安装APK接口
				if (kd.GetSystemType() == kd.SystemType.OS_ANDROID ) 
				then
					kd.InstallAPKFile(_szFilePath);
					self.father:closeWindow();
					return;
				end
				
				--默认处理
				self.father.m_father:NoUpdate();
			end
		end		
	end
	
	self.m_DownList = DownList;
	self.m_nIndex = 0;
	if(DownList and #DownList>0) then
		self:DownloadFile(_type);
	else
		self.m_father:NoUpdate();
	end
end

function UpdateProgress:DownloadFile(_type)
	if (self.m_DownList==nil) then
		--弹出错误MSGBOX
		self.m_father:messagebox_updatefail("下载失败,请稍后再试!");	
		return;
	end
	
	if(self.m_nIndex>0) then
		local it = self.m_DownList[self.m_nIndex];
		self.m_father:WriteVersion(it.version);
	end
	
	if(self.m_nIndex>=#self.m_DownList) then
		self.m_father:NoUpdate();
		return;
	end
	
	self.m_nIndex = self.m_nIndex+1;
	
	self:SetJinDuTiaoTotal(self.m_nIndex,#self.m_DownList);
	self:SetJinDuTiao(0.0,0.0,0.0);
	
	local Item = self.m_DownList[self.m_nIndex];
	
	local strTitle = string.format("正在更新V%s",Item.version);
	self.m_TxtTitle:SetString(strTitle);
			
	--热更新		
	if(_type==1 and self.m_httpDown) then
		self.m_httpDown:SendHttpFileRequest(kd.emHttpFileTaskType.HTTP_FILE_DOWNLOAD,
												Item.url, "Download/", "Update.zip");
	--完整更新
	elseif(_type>1 and self.m_httpObject) then
		self.m_httpObject:SendHttpFileRequest(kd.emHttpFileTaskType.HTTP_FILE_DOWNLOAD,
												Item.url, "Download/", "Update.apk", true);		
	else
		self.m_father:NoUpdate();
	end

end

function UpdateProgress:OnTimerBackCall(--[[int]] id)
	if (id == 1001) then			--销毁定时器
		self.m_father.m_DownLoadDlg = nil;
		--将自己移除出主层
		kd.RemoveLayer(self);
		--析构
		kd.free(self);
	end
end

function UpdateProgress:closeWindow()
	self:SetVisible(false);
	
	--设置销毁定时器(不可以在C层自己的回调中销毁自己!)
	self:SetTimer(1001, 100, 1);
end






