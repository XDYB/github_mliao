local kd = KDGame;
c_Require("Script/Update/kdconfig."..kd.scriptFix)
c_Require("Script/Update/gDef."..kd.scriptFix)
--启动和更新
c_Require("Script/Update/StartLoadUI."..kd.scriptFix)
c_Require("Script/Update/MaskUI."..kd.scriptFix)
c_Require("Script/Update/VersionUI."..kd.scriptFix)
c_Require("Script/Update/MsgBoxUI."..kd.scriptFix)
c_Require("Script/Update/ProgressUI."..kd.scriptFix)

local gCfg = KDConfigFix;
local gDef = gDef;			

--配置
local ConfigPath = "Config/";
local VersionConfig = "Version.ini";

local VERSION = "michat/get-config" -- 获取版本

Startup = {};

function Startup:init()
	self.m_MessageBoxVct = {};
	
	kd.SetSysStateBar(true);
	
	self.LoadResLayer = kd.class(StartLoadUI, false, false);
	if (self.LoadResLayer ~= nil) then
		kd.AddLayer(self.LoadResLayer);
		self.LoadResLayer:init(self);
		self.LoadResLayer:SetJinDu(0);
	end
	
	
	self.LastCheckTime = kd.new(kd.SYSTEMTIME);
	self.m_AuditVer = "";
	
	-- =================================
	-- AB面判断 影响网络失败弹框 START 
	-- =================================
	local abconfig = kd.CJson.OpenFile("LocalFile/ConfigA/abconfig");
	if abconfig == nil then
		kd.CJson.WriteFile("LocalFile/ConfigA/","abconfig",{ab="a"});--保存
	end
	-- =================================
	-- AB面判断 影响网络失败弹框 END
	-- =================================
	
	-- 检查更新
	self:CheckVersion()
	
--	self:NoUpdate();
end	

-- 写入AB面标志
function Startup:SaveABSign(A_or_B)
	local tb = {absign=A_or_B}
	self.absign = tb
	
	-- =================================
	-- AB面判断 影响网络失败弹框 START
	-- =================================
	if A_or_B == "B" then
		kd.CJson.WriteFile("LocalFile/ConfigA/","abconfig",{ab="b"})--保存
	end
	-- =================================
	-- AB面判断 影响网络失败弹框 END
	-- =================================
	
end

--检测版本
function Startup:CheckVersion()
	
	--已经是审核版本，不检测更新
	if(self.m_MiniGame~=nil) then
		self:NoUpdate();
		return;	
	end

	--一天之内不重复检测版本(如果还在加载界面就还是要检测版本)
	local sysTime = kd.GetLocalTime();
	if(self.m_ViewManager~=nil
	   and sysTime.Year == self.LastCheckTime.Year
	   and sysTime.Month == self.LastCheckTime.Month
	   and sysTime.Day == self.LastCheckTime.Day) then
		self:NoUpdate();
		return;
	end
	
	--如果还停留在加载界面，但是有弹框或者下载框，就返回
	if(self.m_ViewManager==nil and 
		(#self.m_MessageBoxVct>0 or (self.m_DownLoadDlg and self.m_DownLoadDlg:IsVisible()))) then		
		return;
	end	
	
	self.LastCheckTime = sysTime;
	self:ReadVersion();	
	
	self.m_DownType = -1;
	self.m_DownSize = "";
	self.m_DownList = {};	
	
	local systype = 0;-- 系统类型 0 安卓 1 苹果
	if(kd.GetSystemType() == kd.SystemType.OS_IOS or kd.GetSystemType() == kd.SystemType.OS_WIN32) then systype = 1; end
	
	local p = {types=systype,currVersion=self:GetVersionStr(),packageName=gDef.PackageName};
	
	self:RequestCheckVersion(p)
end
-- 请求版本检测
function Startup:RequestCheckVersion(p)
	self:Post(gDef.PostUrl..VERSION,p,function(res)
		-- 解密数据
		local json = "";
		if gDef.Test then
			json = res
		else
			json = KDGame.Aes128DecodeStr(res,gDef.Aes128Decode)
		end
		local data = kd.CJson.DeCode(json);
		local hasUpdate = data.hasUpdate -- 是否更新
		-- ==============================
		-- 无更新
		-- ==============================
		if hasUpdate == 0 then
			local scriptPath = kd.GetSysWritablePath().."Script/G_ViewManager.lua"
			-- ============================
			-- B面文件存在
			-- ============================
			if kd.IsFileExist(scriptPath) then
				-- 进入B面
				-- do sth...
				self:EnterB()
			-- ============================
			-- B面文件不存在
			-- ============================
			else
				-- 进入A面
				-- do sth...
				self:EnterA()
			end
		-- ==============================
		-- 有更新
		-- ==============================	
		else
			-- 下载内容 进入B面 
			-- do sth...
			self:EnterDown(data)
		end
	end)
end
-- ==========================================
-- 进入A面
-- ==========================================
function Startup:EnterA()
	self:SaveABSign("A")
	c_Require("Script/MiLiao/A_ViewManager.lua")
	self.m_MiniGame = A_ViewManager;
	self.m_MiniGame:init(self);
	
	--self:UnZipAResAll()
end
-- ==========================================
-- 进入B面
-- ==========================================
function Startup:EnterB()
	self:SaveABSign("B")
	c_Require("Script/G_ViewManager.lua")
	self.m_ViewManager = G_ViewManager;
	self.m_ViewManager:init(self);
end
-- ==========================================
-- 进入下载
-- ==========================================
function Startup:EnterDown(data)
	self:SaveABSign("B")
	--下载信息
	self.m_DownType = data.hasUpdate;
	self.m_DownSize = data.size;
	self.m_DownList = data.packages;
	table.sort(self.m_DownList, function(a,b) return a.id<b.id; end);

	--更新窗口
	if(self.m_DiscoveryVersion == nil) then
		self.m_DiscoveryVersion = kd.class(DiscoveryVersion, false, false);
		self.m_DiscoveryVersion:init(self);
		kd.AddLayer(self.m_DiscoveryVersion);
	end
	self.m_DiscoveryVersion:SetInfo(self:GetVersionStr(),data.updateVersion,data.size,data.content);
end


--不更新
function Startup:NoUpdate()
	if(self.m_DownLoadDlg) then
		self.m_DownLoadDlg:closeWindow();
	end
	-- =====================================
	-- 第一次启动
	-- =====================================
	if self.absign == nil or self.absign.absign == "A" then
		self:EnterA()
		return
	end

	self:EnterB()
	
end



--是否审核版本
function Startup:IsIosAuditVer()
	return false
end
function Startup:free()
	if (self.m_ViewManager) then 
		self.m_ViewManager:free();
	end
	
	if (self.m_MiniGame) then 
		self.m_MiniGame:free();
	end	
	
	kd.free(self);
end	


--关闭客户端
function Startup:CloseClient()
	if (self.m_ViewManager) then 
		self.m_ViewManager:CloseClient();
		return;
	end
	
	if (self.m_MiniGame) then 
		self.m_MiniGame:CloseClient();
		return;
	end		
	
	_GameOver();
end

--带按钮的弹框
function Startup:messagebox(options)
	local MessageBoxDlg = kd.class(PopUpBtnBox, false, true);
	MessageBoxDlg:init(self)
	MessageBoxDlg:SetZOrder(999);
	kd.AddLayer(MessageBoxDlg);
	MessageBoxDlg:Show(options);
	table.insert(self.m_MessageBoxVct,MsgBoxDlg);
end

--半透明弹框
function Startup:messagebox_default(szStr,dwlayTime)
	--dwlayTime 延迟显示
	if self.m_MessBoxDlg then
		self.m_MessBoxDlg:SetVisible(false);
		self.m_MessBoxDlg = nil;
	end
	if self.m_MessBoxDlg==nil then
		self.m_MessBoxDlg = kd.class(PopUpBox, false, true);
		self.m_MessBoxDlg:SetZOrder(999);
		kd.AddLayer(self.m_MessBoxDlg);
		self.m_MessBoxDlg:AddBox(szStr,dwlayTime);
	end
end


function Startup:messagebox_updatefail(msg)
	if(self.m_DownLoadDlg) then
		self.m_DownLoadDlg:SetVisible(false);
	end
	
	if(self.m_DownType > 1) then 
		return self:messagebox_retry(msg);
	end
	
	local sink = self;
	
	self:messagebox({
		txt = {msg},
		btn = {"暂不更新","重试"},
		fn = {
			function()
--				sink:NoUpdate();
				sink:CloseClient();
			end,
			function()
				--获取全局配置
				self:CheckVersion()
			end
		},								
	});
end

--弹重试框
function Startup:messagebox_retry(msg)
	local sink = self;
	self:messagebox({
		txt = {msg},
		btn = {"退出","重试"},
		fn = {
			function()
				sink:CloseClient();
			end,
			function()
				--获取全局配置
				self:CheckVersion()
			end
		},								
	});
end

function Startup:messagebox_remove(msgbox)
	for i=1,#self.m_MessageBoxVct do
		local MsgBoxDlg = self.m_MessageBoxVct[i];
		if(MsgBoxDlg and MsgBoxDlg==msgbox) then
			table.remove(self.m_MessageBoxVct,i);
			return;
		end
	end
end

function Startup:DownLoad()
	if(self.m_DownList==nil or #self.m_DownList==0) then
		self:NoUpdate();
		return;
	end
	
	--IOS完整包更新特殊处理
	if(self.m_DownType>1 and kd.GetSystemType()==kd.SystemType.OS_IOS) then
		if(kd.OpenBrowserToUrl(self.m_DownList[1].url)==false) then
			self:NoUpdate();
		end
		return;
	end
	
	if(self.m_DownLoadDlg == nil) then
		self.m_DownLoadDlg = kd.class(UpdateProgress,true,false);
		self.m_DownLoadDlg:init(self);
		kd.AddLayer(self.m_DownLoadDlg);		
	end
	self.m_DownLoadDlg:SetVisible(true)
	self.m_DownLoadDlg:StartDownloadFile(self.m_DownList,self.m_DownType);
end



--版本号字符串
function Startup:GetVersionStr()
	if self.m_Version0==nil then
		self.m_Version0 = 0;
	end
	if self.m_Version1==nil then
		self.m_Version1 = 0;
	end
	if self.m_Version2==nil then
		self.m_Version2 = 0;
	end
	return string.format("%d.%d.%d",self.m_Version0,self.m_Version1,self.m_Version2);
end



--读取版本文件
function Startup:ReadVersion()
	self.m_Version0 = 0;
	self.m_Version1 = 0;
	self.m_Version2 = 0;
	
	local szFile = ConfigPath..VersionConfig;
	local tData = kd.CJson.OpenFile(szFile); 
	if (tData) then
		if(tData.Version0) then self.m_Version0 = tData.Version0; end
		if(tData.Version1) then self.m_Version1 = tData.Version1; end
		if(tData.Version2) then self.m_Version2 = tData.Version2; end
	end
	
	--版本不一致 1.0.0   1.1.0
	if(	gCfg.Version0~=self.m_Version0 				--完整包版本 只认系统目录的
		or gCfg.Version1~=self.m_Version1 
		or gCfg.Version2>self.m_Version2) 
	then--热更新版本 系统目录比下载目录还要新
		--使用系统目录版本
		self.m_Version0 = gCfg.Version0;
		self.m_Version1 = gCfg.Version1;
		self.m_Version2 = gCfg.Version2;
		
		--删除热更新目录
		kd.RemoveDirectory("Config/");
		kd.RemoveDirectory("Script/");
		kd.RemoveDirectory("ResAll/");
	end
end

--保存版本号
function Startup:WriteVersion(version)
	local v = self:SplitString(version,"%.");
--	if(v==nil or #v<3) then return; end
	
	if(v[1]) then self.m_Version0 = tonumber(v[1]); end
	if(v[2]) then self.m_Version1 = tonumber(v[2]); end
	if(v[3]) then self.m_Version2 = tonumber(v[3]); end
	
	local Data = {Version0=self.m_Version0,Version1=self.m_Version1,Version2=self.m_Version2};
	kd.CJson.WriteFile(ConfigPath,VersionConfig,Data);
end




function Startup:onResume()
	if(self.m_MiniGame == nil and self.m_ViewManager == nil) then 
		--如果有弹框或者下载框，就返回
		if(#self.m_MessageBoxVct>0 or (self.m_DownLoadDlg and self.m_DownLoadDlg:IsVisible())) then		
			return;
		else			
			self:CheckVersion()
		end
	elseif(self.m_ViewManager and self.m_ViewManager:IsInitFinish()) then
		self.m_ViewManager:onResume();		
	elseif(self.m_MiniGame and self.m_MiniGame:IsInitFinish()) then
		self.m_MiniGame:onResume();		
	end		
end

--发包请求（ObjBack:回调对象，tData:{key1=value1,key2=value2,...}）
function Startup:SendData(--[[uint]]uID,--[[table]]tData,IsContainArray,Url)
	if(uID==nil or url[uID]==nil) then return false; end
	tData = tData or {};
	local szUrl
	if Url then
		szUrl = Url ..url[uID]
	else
		szUrl = gDef.PostUrl..url[uID]
	end
	local _szPostInfo = "";
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
    if(self.m_httpRequest==nil) then
        self.m_httpRequest = kd.class(kd.HttpRequest);
        self.m_httpRequest.father = self;
        self.m_httpRequest.OnHttpPOSTRequest = function(self, 
                                                    --[[uint]] uID, 
                                                    --[[string]] data,
                                                    --[[int]] size,
                                                    --[[int]] nErrorCode,
                                                    --[[string]] szError)  
			local rt = kd.CJson.DeCode(data);
			--需要父类自己实现方法
			self.father:OnReceiveData(uID,rt,nErrorCode,szError);
        end
    end
	
	print("SendData-url:"..szUrl.." ID="..uID);
	return self.m_httpRequest:SendHttpPOSTRequest(uID,szUrl,gDef.HeadInfo,_szPostInfo);
end


function Startup:SplitString(str,key)	
	local t={};
	
	if(str==nil or str=="" or key==nil or key=="") 
	then
		return t;
	end
	 
	local i = 1;
	while true do
		local index = string.find(str, key);
		if (index == nil) then
			t[i] = str;
			break;
		end
		t[i] = string.sub(str, 1, index-1);
		str = string.sub(str, index+1, -1);
		i = i + 1;
	end
	
	return t;
end



-- 解压A面资源
function Startup:UnZipAResAll()
	local initA = function()
		c_Require("Script/MiLiao/A_ViewManager.lua")
		self.m_MiniGame = A_ViewManager;
		self.m_MiniGame:init(self);
	end
	-- WIN平台 直接进入A面
	if kd.GetSystemType() == kd.SystemType.OS_WIN32 then
		initA();
	-- IOS平台 进入解压流程
	else
		-- 判断A面资源是否解压
		local scriptPath = kd.GetSysWritablePath().."Script/MiLiao/A_ViewManager.lua";
		if kd.IsFileExist(scriptPath) then
			-- 存在 进入A面
			initA();
		else
			local unzipPackage = {
				-- 资源
				{from="ResAll/abc01.VW",to="/ResAll/"},
				-- 脚本
				{from="Script/abc03.VW",to="/Script/"},
			}
			local index = 1;
			local unzip = kd.class(kd.UnZip);
			unzip.OnUnZipSuccess = function(self, --[[uint]] uID)
				index = index + 1;
				if index <= #unzipPackage then
					unzip:UnZipFile(10001, unzipPackage[index].from, unzipPackage[index].to);
				else
					initA();
				end
			end	
			unzip.OnUnZipFail = function(this, --[[uint]] uID, --[[int]] nErrorCode, --[[string]] szErrorMsg)
				self:messagebox({
					txt = {szErrorMsg},
					btn = {"退出","重试"},
					fn = {
						function()
							self:CloseClient();
						end,
						function()
							self:UnZipAResAll();
						end
					},								
				});
			end	
			
			-- 解压资源
			unzip:UnZipFile(10001, unzipPackage[1].from, unzipPackage[1].to);	

		end	
	end

	
end


-- ===========================================================================
-- 									Http
-- ===========================================================================
-- 拼接Http参数
-- @params table 参数
function Startup:GetHttpStrs(params)
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

-- 热更新HTTP请求头
local httpheader = {
	-- 手机品牌
	"phoneBrand="..gDef.SysInfo.phone_brand,
	-- 操作系统
	"phoneSystem="..gDef.SysInfo.system_version,
	-- 手机型号
	"phoneModels="..gDef.SysInfo.phone_model,
	-- 渠道
	"appMarket="..gDef.Channel,
	-- app版本号
	"appVersionCode=5.0",
	-- app版本名字
	"appVersionName=1.0",
	-- api版本
	"apiVersion=test1",
	-- 包名
	"packageName="..gDef.PackageName,
}

--[[
Post("http://localhost/pos.php",{},function(data)
	-- 这里是回调函数
end)
--]]	
-- Post请求
-- @url 请求路径
-- @params 参数 table
-- @callback 回调
function Startup:Post(url,params,callback)
	
	local paramsStr = params and self:GetHttpStrs(params) or "";
    local httpRequest = kd.class(kd.HttpRequest);
	-- 回调函数注册到数据中心
	local varName = url..tostring(httpRequest)
	DC:Register(varName,self,callback)
    httpRequest.OnHttpPOSTRequest = function(this, 
                                                --[[uint]] uID, 
                                                --[[string]] data,
                                                --[[int]] size,
                                                --[[int]] nErrorCode,
                                                --[[string]] szError)		
        kd.free(httpRequest);
		if nErrorCode ~=0 then
			local server
			-- =================================
			-- AB面判断 影响网络失败弹框 START
			-- =================================
			local msg3 = ""
			local abconfig = kd.CJson.OpenFile("LocalFile/ConfigA/abconfig");		
			if abconfig.ab =="a" then
				msg3 = "请联系官网客服"
			else
				msg3 = "联系客服微信：vliao66"
			end
			self:messagebox({
					txt = {"网络异常，请检查网络是否正常","或网络权限是否开启",msg3},
					btn = {"退出","重试"},
					fn = {
						function()
							self:CloseClient();
						end,
						function()
							--获取全局配置
							self:CheckVersion()
						end
					},								
				});
			-- =================================
			-- AB面判断 影响网络失败弹框 END
			-- =================================
            return;
        end      
		-- 向数据中心填充数据
		DC:FillData(varName,data);
    end
    return httpRequest:SendHttpPOSTRequest(1,url,table.concat(httpheader,"&"),paramsStr);
	
end