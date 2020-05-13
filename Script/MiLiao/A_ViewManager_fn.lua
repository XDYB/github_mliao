local kd = KDGame;
local gCfg = KDConfigFix;
local gDef = gDef;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local VoiceFilePath = "LocalFile/Voice/";
local VoiceFile = "temp.dat";
local VoiceConfig = "config.ini"
local VoicePath = "videos/";


local impl = A_ViewManager;

-- 拼接Http参数
-- @params table 参数
function impl:GetHttpStrs(params)
	local paramStr = "";
	if params then
		for k,v in pairs(params) do      
			if type(v)=="table" then
				--数组参数
				for i=1,#v do
					if paramStr=="" then paramStr = k.."[]="..v[1]             
					else paramStr = paramStr .."&".. k.."[]="..v[i]  end 
				end
			else
				if(paramStr=="") then paramStr = k.."="..v;
				else paramStr = paramStr.."&"..k.."="..v; end
			end
		end
	end
	return paramStr;
end

-- 发起Post请求
-- @key 请求url
-- @params 参数
-- @callback 回调函数
-- @bloading 是否需要loading	--默认需要要
function impl:Post(key,params,callback,bloading)

	local userId = 0
	local userKey = "" 
	--默认需要要loading
	if bloading == nil then
		bloading = true
	else
		bloading = bloading
	end
	if self.m_User then
		userId = self.m_User.userId;
		userKey = self.m_User.userKey 
	end

	local url = kd.Aurl[key][1]
	local requestUrl = gDef.PostUrl..url;
	if userId and userKey and params then
		if string.len(userId)>0 and string.len(userKey)>0 then
			params.userid = userId;
			params.userkey = userKey;
		end
	end
	local paramsStr = params and self:GetHttpStrs(params) or "";
    local httpRequest = kd.class(kd.HttpRequest);
	-- 回调函数注册到数据中心
	local varName = url..tostring(httpRequest)
	DC:RegisterCallBack(varName,self,callback)
    httpRequest.OnHttpPOSTRequest = function(this, 
                                                --[[uint]] uID, 
                                                --[[string]] data,
                                                --[[int]] size,
                                                --[[int]] nErrorCode,
                                                --[[string]] szError)		
        kd.free(httpRequest);
		
		--收到包隐藏加载界面
		--self:SetLoadingView(false);
		if bloading then
			self:HideLoading()
		end	
        if nErrorCode == 1 then
			-- Http 域名错误
			self:messagebox_default("网络请求失败，请检查网络或稍后再试");
            return;
        end
        if nErrorCode == 6 then
			-- Http 断开网络连接
			self:messagebox_default("网络请求失败，请检查网络或稍后再试");
            return;
        end
		if nErrorCode == 7 then
			-- Http 错误的请求
			self:messagebox_default("网络请求失败，请检查网络或稍后再试");
            return;
        end   
        if nErrorCode == 56 then
			-- Http 发送Get请求失败
			self:messagebox_default("网络请求失败，请检查网络或稍后再试");
            return;
        end
        if nErrorCode == 404 then
			-- Http 请求的路径错误
			self:messagebox_default("网络请求失败，请检查网络或稍后再试");
            return;
        end
        if nErrorCode == 400 then
			-- Http 错误的请求
			self:messagebox_default("网络请求失败，请检查网络或稍后再试");
            return;
        end   
		if nErrorCode == 500 then
			-- Http 错误的请求
			self:messagebox_default("网络请求失败，请检查网络或稍后再试");
            return;
        end  
		if nErrorCode == -1009 then
			-- Http 错误的请求
			self:messagebox_default("网络请求失败，请检查网络或稍后再试");
            return;
        end  
--		local json = KDGame.Aes128DecodeStr(data,gDef.Aes128Decode)
		--if gDef.Test then		--测试数据包不加密
			json = data;
		--end
		local _data = kd.CJson.DeCode(json);
		if _data==nil then
			local str = "请求超时"
			if string.len(szError)>0 then
--				self:messagebox_default(szError);
			else
				local str = "";
				str =  "nErrorCode = "..nErrorCode
--				self:messagebox_default(str);
				-- 显示登录界面 do sth...

			end
			self:messagebox_default(str);
			
			return;
		end
		
		if _data then
			if _data.result==false then		--被挤号回到登录界面
				if _data.errorCode~=nil then
					if tonumber(_data.errorCode) == 3 or tonumber(_data.errorCode) == 4 or tonumber(_data.errorCode) == 10 then
						echo("KD_LOG------VideoChat:Exit tData.errorCode = %d",tonumber(_data.errorCode));
						self:Exit();
						self:messagebox_default("账户在其他地方登陆，您被挤下线了");
						return;
					end
				end
			end
		end
		
		-- 向数据中心填充数据
		DC:CallBack(varName,_data);
    end
	echo("request:"..requestUrl);
    local parmas =  string.split(paramsStr,"&");
	dump(parmas);
	
--	paramsStr = "scrt="..kd.Aes128EncryptStr(paramsStr,gDef.Aes128Decode);
	if url ~= "michat/get-dynamicinfo" and url ~= "michat/like-dynamic" then
		if bloading then
			self:ShowLoading()
		end
	end
    return httpRequest:SendHttpPOSTRequest(kd.Aurl[key].id,requestUrl,gDef.HeadInfo,paramsStr);
end


--[[
Get("http://localhost/pos.php",{},function(data)
	-- 这里是回调函数
end)
--]]	
-- Get请求
-- @url 请求路径
-- @params 参数 table
-- @callback 回调
function impl:Get(url,params,callback)
	local paramsStr = params and self:GetHttpStrs(params) or "";
	local _url = paramsStr=="" and url or url .. "?".. paramsStr
    local httpRequest = kd.class(kd.HttpRequest);
	
	-- 回调函数注册到数据中心
	local varName = url..tostring(httpRequest)
	DC:RegisterCallBack(varName,self,callback)
    httpRequest.OnHttpGETRequest = function(this, 
                                                --[[uint]] uID, 
                                                --[[string]] data,
                                                --[[int]] size,
                                                --[[int]] nErrorCode,
                                                --[[string]] szError)	
        kd.free(httpRequest);
        if nErrorCode == 1 then
			-- Http 域名错误
            return;
        end
        if nErrorCode == 6 then
			-- Http 断开网络连接
            return;
        end
        if nErrorCode == 56 then
			-- Http 发送Get请求失败
            return;
        end
        if nErrorCode == 404 then
			-- Http 请求的路径错误
            return;
        end
        if nErrorCode == 400 then
			-- Http 错误的请求
            return;
        end   
--		local json = KDGame.Aes128DecodeStr(data,"V9LJ7T0cDPblpEzK")
		local json = data;
		local _data = kd.CJson.DeCode(json);
        -- 向数据中心填充数据
		DC:CallBack(varName,_data);
    end
    return httpRequest:SendHttpGETRequest(1,_url);
	
end

-- ===========================================================================
-- 									Http下载
-- ===========================================================================
--[[
GetFile("http://localhost/httpdown.zip","LocalFile/",function(filepath)
	-- 回调函数
end)
--]]		
-- @url 远程下载路径
-- @localPath 本地保存目录
-- @callback 回调函数
function impl:GetFile(url,localPath,callback,callback2)
	local pos = string.len(url)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(url, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        end
        pos = pos - 1
    end
    local filename = string.sub(url, pos + 1)
    local httpRequest = kd.class(kd.HttpFile)
	-- 回调函数注册到数据中心
	local varName1 = url..tostring(httpRequest).."callback1"
	local varName2 = url..tostring(httpRequest).."callback2"
	DC:RegisterCallBack(varName1,self,callback)
	DC:RegisterCallBack(varName2,self,callback2)
    httpRequest.OnHttpFileDownProgress = function(self, _dltotal, _dlnow, _progress)
		DC:CallBack(varName2,_progress);
	end
	httpRequest.OnHttpFileRequest = function(self,
									--[[KDGame.emHttpFileTaskType]] _type,
									--[[int]] _nErrorCode,
									--[[string]] _szError,
									--[[string]] _szFilePath,
									--[[uint]] param0,
									--[[uint]] param1,
									--[[uint]] param2,
									--[[uint]] param3)											
		if (_nErrorCode == 0) then	
			-- 向数据中心填充数据
			DC:CallBack(varName1,_szFilePath);
		end
	end
	httpRequest:SendHttpFileRequest(kd.emHttpFileTaskType.HTTP_FILE_DOWNLOAD,url, 
		localPath, filename);
end

--把带&转化成%26
function impl:Change26(str)
	while(string.len(str)>0) do
		local nFind = string.find(str,"&");
		if(nFind==nil) then
			break; 
		end
		
		local tmp = string.sub(str,1,nFind-1);
		local tmp1 = string.sub(str, nFind+1, -1);
		str = tmp.."%26"..tmp1;
	end
	return str;
end	


--发包请求（ObjBack:回调对象，tData:{key1=value1,key2=value2,...}）
--Extend:扩展参数，会原封不动在回调函数传回去
function impl:SendData(ObjBack,uID,tData,IsContainArray,PostUrl,Extend)
	if ObjBack==nil then
		return;
	end
	
	if  self:IsIosAuditVer()  then		--审核模式不发获取用户信息包
		if uID == kd.urlID.ONLINE_SET_ONE or  uID == kd.urlID.DV_ONLINE_GET_ONE then
			return;
		end
	end
	
	
	tData = tData or {};
    
	if tData.userId then
	else
		if self.m_User then
			tData.userId = math.floor(self.m_User.userId);
		end
	end
	
	if tData.userKey then
	else
		if self.m_User then
			tData.userKey = self.m_User.userKey;
		end
	end

    
	if(uID==nil or kd.Aurl[uID]==nil) then return false; end
	if PostUrl==nil then
		PostUrl = gDef.PostUrl;
	end
	
	local _szUrl = PostUrl..kd.Aurl[uID];

	local _szPostInfo = "";
	
	--先把带&的字符串转化------------------------------------------------------
	local tab = {};
	if(tData) then
		for k,v in pairs(tData) do   
			tab[k] = v;
            if IsContainArray and type(v)=="table" then
                --数组参数
				local tabV = {};
                for i=1,#v do
					if type(v[i])=="string" then
						tabV[i] = self:Change26(v[i]);
					end
                end
				tab[k] = tabV;
            else
				if type(v)=="string" then
					tab[k] = self:Change26(v);
				end
            end
		end
	end
	---------------------------------------------------------------------------
	tData = tab;
	
	if(tData) then
		for k,v in pairs(tData) do      
            if IsContainArray and type(v)=="table" then
                --数组参数
                for i=1,#v do
                    if _szPostInfo=="" then _szPostInfo = _szPostInfo ..k.."[]="..v[1]             
                    else _szPostInfo = _szPostInfo .."&".. k.."[]="..v[i]  end 
                end     
            else
                --不需要检测类型
                if(_szPostInfo=="") then _szPostInfo = _szPostInfo..k.."="..v;
                else _szPostInfo = _szPostInfo.."&"..k.."="..v; end
            end
		end
	end
    if(ObjBack.m_httpRequest==nil) then
        ObjBack.m_httpRequest = kd.class(kd.HttpRequest);
        ObjBack.m_httpRequest.father = ObjBack;
        ObjBack.m_httpRequest.OnHttpPOSTRequest = function(self, 
                                                    uID, 
                                                   data,
                                                    size,
                                                    nErrorCode,
                                                    szError)
													
			--收到包隐藏加载界面
			G_ViewManager:SetLoadingView(false);
			
			if nErrorCode == 1 then
				-- Http 域名错误
				self:messagebox_default("网络请求失败，请检查网络或稍后再试");
				return;
			end
			if nErrorCode == 6 then
				-- Http 断开网络连接
				self:messagebox_default("网络请求失败，请检查网络或稍后再试");
				return;
			end
			if nErrorCode == 7 then
				-- Http 错误的请求
				self:messagebox_default("网络请求失败，请检查网络或稍后再试");
				return;
			end  
			if nErrorCode == 56 then
				-- Http 发送Get请求失败
				self:messagebox_default("网络请求失败，请检查网络或稍后再试");
				return;
			end
			if nErrorCode == 404 then
				-- Http 请求的路径错误
				self:messagebox_default("网络请求失败，请检查网络或稍后再试");
				return;
			end
			if nErrorCode == 400 then
				-- Http 错误的请求
				self:messagebox_default("网络请求失败，请检查网络或稍后再试");
				return;
			end   
			if nErrorCode == 500 then
				-- Http 错误的请求
				self:messagebox_default("网络请求失败，请检查网络或稍后再试");
				return;
			end  
			if nErrorCode == -1009 then
				-- Http 错误的请求
				self:messagebox_default("网络请求失败，请检查网络或稍后再试");
				return;
			end  
		
			echo("==KD_LOG data==========================================="..data)
			local _data = KDGame.Aes128DecodeStr(data,"V9LJ7T0cDPblpEzK")
			if gDef.Test then		--测试数据包不加密
				_data = data;
			end
			local tData = kd.CJson.DeCode(_data);
			dump(tData)
			
			
			--需要父类自己实现方法
			self.father:OnReceiveData(uID,tData,nErrorCode,szError,self.Extend);
	
			if tData then
				if tData.result==false then		--被挤号回到登录界面
					if tData.errorCode~=nil then
						if tonumber(_data.errorCode) == 3 or tonumber(_data.errorCode) == 4 or tonumber(_data.errorCode) == 10 then
							echo("KD_LOG------VideoChat:Exit tData.errorCode = %d",tonumber(_data.errorCode));
							self:Exit();
							self:messagebox_default("账户在其他地方登陆，您被挤下线了");
							return;
						end
					end
				end
			else
                -- 通话结束的情况下，不弹提示框
                if G_ViewManager.m_blockLayer:IsVisible() == false then
                    if uID ~= kd.urlID.ONLINE_SET_ONE then	--每30秒设置用户状态不需要弹出错误信息
                        if tonumber(nErrorCode)==7 or tonumber(nErrorCode)==6 then
							local str  = "网络异常,请检查网络是否政策\n或网络权限是否开启\n联系客服微信:"..gDef.WEIXIN;
                            G_ViewManager:messagebox_default(str);
                        else
                            G_ViewManager:messagebox_default(szError);
                        end
                    end
                    echo("tData==nil: nErrorCode:"..nErrorCode.." szError:"..szError);
                end 
				
			end
        end
    end

	echo("SendData-url:".._szUrl.." ID="..uID);
	echo("SendData-params START:-----------------------------------------------");
    local parmas =  string.split(_szPostInfo,"&");
	dump(parmas);
    echo("SendData-params END:-----------------------------------------------");

	ObjBack.m_httpRequest.Extend = Extend;
	
	return ObjBack.m_httpRequest:SendHttpPOSTRequest(uID,_szUrl,gDef.HeadInfo,_szPostInfo);
end



--开始录音
function impl:StartRecordVoice()
	if true then			--测试
		return true;
	end
	
	
	if(self.bYLUpReady==false) then
		self:messagebox_default("操作频繁，请稍后再试");
		return false;
	end	
	
	--停止正在播放的语音
	if(self.m_bYLPlaying) then 
		self:StopPlayVoice(1);
	end	
	
	local nRet,szError = kd.TIM.RecordingVoice("LocalFile/Voice/temp.dat");
	if(nRet~=0) then
		self:messagebox_default(szError);
		--录音失败，继续播放语音
		self:PlayVoice();
		return false;
	end
	
	return true;
end

--停止录音并且传送语音到语音服务器(可以选择不发送)
function impl:UploadVoice(bSend)	
		
	local nRet,szError = kd.TIM.UploadVoice(VoiceFilePath..VoiceFile,bSend);
	if(nRet~=0) then
		echo("KD_LOG:"..szError);
		bSend = false;		
	end
	
	if(bSend) then
		self.bYLUpReady = false;
	end		
	
	--录音完毕，继续播放语音
	self:PlayVoice();
end

function impl:OnTimApplyMsgKey(--[[GCloudVoiceCompleteCode ]] _ncode, --[[string]] _err_msg);
end

function impl:OnTimUploadVoice(--[[string]] _sev_file_id, bOK)
	self.bYLUpReady = true;
	
	--上传成功，发送给游戏服务
	if(bOK) then
		local VoiceFileData = gs:getNetTable(gs.cmd.SUB_C2GS_VOICE_FILE);
		VoiceFileData.szFileID = string.format("%s",_sev_file_id);
		
		local _data, _size = VoiceFileData:table2data();
		self:SendData(gnet.MAIN_C_GS,gs.cmd.SUB_C2GS_VOICE_FILE,_data,_size);
	end
end

function impl:OnTimDownloadVoice(--[[string]] _sev_file_id, --[[string]] _save_file, --[[uint]] _file_size, --[[float]] _voice_time, --[[GCloudVoiceCompleteCode ]] _ncode, --[[string]] _err_msg)
	local GV_ON_DOWNLOAD_RECORD_DONE = 13;				--下载语音文件成功
	if(_ncode==GV_ON_DOWNLOAD_RECORD_DONE) then
		self:OnTimDownloadVoiceCallBack(_sev_file_id,_save_file,_voice_time,_ncode==GV_ON_DOWNLOAD_RECORD_DONE);
	else
		self:messagebox_default(_err_msg);
	end
end

function impl:OnTimDownloadVoiceCallBack(--[[string]] _sev_file_id, --[[string]] _save_file, --[[float]] _voice_time, bOK)
	--从下载列表里找到该语音，保存之后从下载列表中删除
	local fileid = string.format("%s",_sev_file_id);
	local nLen1 = string.len(fileid);
	local YLFile = nil;
	for i=1,#self.m_YLDownFileList do
		local nLen2 = string.len(self.m_YLDownFileList[i].szFileID);
		if(self.m_YLDownFileList[i].szFileID==fileid) then
			YLFile = self.m_YLDownFileList[i];
			table.remove(self.m_YLDownFileList,i);
			break;
		end
	end
	if(YLFile==nil) then return; end
	
	--下载失败直接返回
	if(bOK==false) then return; end
	
	--下载成功就添加语音文件信息
	YLFile.szFilePath = _save_file;
	YLFile.fTime = _voice_time;	
	table.insert(self.m_YLPlayFileList,YLFile);
	
	--当前没有播放语音，就开始播放
	if(self.m_bYLPlaying==false) then
		self:PlayVoice();
	end
end

--判断语音是否下载
function impl:IsYuYinDownLoad(szVoiceName)
	while(true) do
		local nFind = string.find(szVoiceName,"/");
		if(nFind==nil) then break; end
		szVoiceName = string.sub(szVoiceName,nFind+1);
	end
	local szFile = VoicePath..VoiceConfig;
	local tData = kd.CJson.OpenFile(szFile);
	if tData then
		for i=1,#tData do
			if tData[i].szVoice == szVoiceName then
				return szVoiceName;
			end
		end
	end 
	
	return false;
end

--保存语音
function impl:SavaVoiceName(szVoiceName)
		while(true) do
		local nFind = string.find(szVoiceName,"/");
		if(nFind==nil) then break; end
			szVoiceName = string.sub(szVoiceName,nFind+1);
		end
		
		local data = {};
		data.szVoice = szVoiceName;
		local szFile = VoicePath..VoiceConfig;
		local tData = kd.CJson.OpenFile(szFile); 
		if tData == nil then
			tData = {};
		end
		local Data = {szVoice=szVoiceName};
		table.insert(tData,Data)
		local result = kd.CJson.WriteFile(VoicePath,VoiceConfig,tData);
end



function impl:PlayVoice()
	if(self.m_bYLPlaying) then return; end
	if(#self.m_YLPlayFileList<=0) then return; end
	
	if(self.m_bMuteYuYin) then
		--当前语音添加到上一条队列
		local YLFile = self.m_YLPlayFileList[1];
		self.m_YLLastFileList[YLFile.dwUserID] = YLFile;
		--删除当前语音
		table.remove(self.m_YLPlayFileList,1);
		return;
	end
	
	while(#self.m_YLPlayFileList>0) do
		local pUserData = self:GetUserDataByUserID(self.m_YLPlayFileList[1].dwUserID);
		if(pUserData) then
			local nRet,szError = kd.TIM.PlayVoice(self.m_YLPlayFileList[1].szFilePath);
			if(nRet==0) then
				self:PlaySoundCallBack(pUserData,self.m_YLPlayFileList[1].fTime);
				return;
			end
		end
		
		table.remove(self.m_YLPlayFileList,1);
	end	
end

function impl:PlayLastVoice(dwUserID)
	--该用户没有上一条语音，直接返回不处理
	local YLFile = self.m_YLLastFileList[dwUserID];
	if(YLFile==nil) then return; end
	
	--将该语音插入到播放队列最前
	table.insert(self.m_YLPlayFileList,1,YLFile);	
	
	--停止正在播放的语音
	if(self.m_bYLPlaying) then 
		self:StopPlayVoice(2);
		return;
	end
	
	--开始播放
	self:PlayVoice();
end

function impl:StopPlayVoice(nMode)
	self.m_bYLPlaying = false;
	self.m_nYLBreakMode = nMode;
	kd.TIM.StopPlayVoice();
end

function impl:PlaySoundCallBack(pUserData,fTime)
	self.m_bYLPlaying = true;
	if pUserData and LayerManage.GameLayer then
		LayerManage.GameLayer:PlaySoundCallBack(pUserData,fTime);
	end
end

function impl:OnTimPlayVoiceEnd()
	self.m_bYLPlaying = false;
	if LayerManage.GameLayer then
		LayerManage.GameLayer:StopSoundCallBack();
	end
	
	--如果是中断，直接返回
	if(self.m_nYLBreakMode>0) then 
		--因播放中断，需要播放下一条
		if(self.m_nYLBreakMode==2) then 
			self:PlayVoice(); 
		end
		--重置标志
		self.m_nYLBreakMode = 0;
		return; 
	end

	--有可能是删除文件前手动清空了
	if(#self.m_YLPlayFileList<=0) then return; end
	
	--当前语音添加到上一条队列
	local YLFile = self.m_YLPlayFileList[1];
	self.m_YLLastFileList[YLFile.dwUserID] = YLFile;
	--删除当前语音
	table.remove(self.m_YLPlayFileList,1);
	--播下一条语音
	self:PlayVoice();
end

--删除所有语聊文件
function impl:ClearAllVoiceFiles()
	--清空所有的语音列表
	self.m_YLDownFileList = {};
	self.m_YLPlayFileList = {};
	self.m_YLLastFileList = {};
	
	--停止正在播放的语音
	if(self.m_bYLPlaying) then 
		self:StopPlayVoice(3);
	end
	
	--删除文件
	kd.RemoveDirectory(VoiceFilePath);
	--创建语音保存目录
	if(kd.CreateDirectory(VoiceFilePath)==false) then
		echo("KD_LOG:创建语音目录失败！");
	end
end

--清空播放列表
function impl:ClearVoicePlayList()	
	--停止正在播放的语音
	if(self.m_bYLPlaying) then 
		self:StopPlayVoice(3);
	end
	
	--清空下载列表
	self.m_YLDownFileList = {};
	--播放列表中的语音都添加至上一条队列
	while(#self.m_YLPlayFileList>0) do
		local YLFile = self.m_YLPlayFileList[1];
		self.m_YLLastFileList[YLFile.dwUserID] = YLFile;
		table.remove(self.m_YLPlayFileList,1);
	end
end

-- 打印日志
function impl:Log(str)
	if type(str) == "string" then
		local path = [[C:\Users\adminB96\Desktop\]]
		local file = io.open(path.."vliao.txt","a")
		file:write(str.."\n")
		io.close(file);
	else
		self:LogDump(str)
	end
end
-- 打印日志
function impl:LogDump ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            self:Log(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        self:Log(indent.."["..pos.."] => {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        self:Log(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        self:Log(indent.."["..pos..'] => "'..val..'"')
                    else
                        self:Log(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                self:Log(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        self:Log("{")
        sub_print_r(t,"  ")
        self:Log("}")
    else
        sub_print_r(t,"  ")
    end
end

-- ==========================================================================
--                              请求权限 Start
-- ==========================================================================
--请求麦克风权限
function impl:RequestMicrophonePermissions()
	local nRet = kd.CheckMicrophonePermissions();
	--有授权
	if(nRet == 3) then return; end
	--用户未进行授权操作
	if(nRet == 0) then
		kd.RequestMicrophonePermissions();
		return;
	end
	--无授权
	if(kd.GetSystemType()==kd.SystemType.OS_IOS) then
		kd.IosOpenAppPermissionSetting();
	end
end

--请求相机权限
function impl:RequestCameraPermissions()
	local nRet = kd.CheckCameraPermissions();
	--有授权
	if(nRet == 3) then return; end
	--用户未进行授权操作
	if(nRet == 0) then
		kd.RequestCameraPermissions();
		return;
	end
	--无授权
	if(kd.GetSystemType()==kd.SystemType.OS_IOS) then
		kd.IosOpenAppPermissionSetting();
	end	
end
--请求相册权限
function impl:RequestPhotoPermissions()
	local nRet = kd.CheckPhotoPermissions();
	--有授权
	if(nRet == 3) then return; end
	--用户未进行授权操作
	if(nRet == 0) then
		kd.RequestPhotoPermissions();
		return;
	end
	--无授权
	if(kd.GetSystemType()==kd.SystemType.OS_IOS) then
		kd.IosOpenAppPermissionSetting();
	end	
end

--请求通知权限
function impl:RequestMsgPushPermissions()
	local bRet = kd.CheckMsgPushPermissions();
	--有授权
	if(bRet) then return; end
	--无授权
	local szFile = gDef.ConfigPath..gDef.JurisdictionFile;
	local tData = kd.CJson.OpenFile(szFile); 
	if(tData and tData.MsgPush) then
		if(kd.GetSystemType()==kd.SystemType.OS_IOS) then
			kd.IosOpenAppPermissionSetting();
		end		
		return;
	end
	--用户未进行授权操作
	kd.RequestMsgPushPermissions();
	local Data = tData or {};
	Data.MsgPush = true;
	kd.CJson.WriteFile(gDef.ConfigPath,gDef.JurisdictionFile,Data);	
end






