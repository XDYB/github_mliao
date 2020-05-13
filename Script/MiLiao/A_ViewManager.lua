
--========================================================================
--                              引擎文件
-- ========================================================================

local kd = KDGame;  
local gCfg = KDConfigFix;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

A_ViewManager = kd.class(kd.Layer,true,false);
local gSink = A_ViewManager;
kd.AddLayer(A_ViewManager);

local APath = "MiLiao"
c_Require("Script/"..APath.."/A_ViewManager_fn.lua")
c_Require("Script/"..APath.."/A_ViewManager_tim.lua")

-- ====================================================
-- Com
-- ====================================================
c_Require("Script/"..APath.."/Com/AUrl.lua")
c_Require("Script/"..APath.."/Com/AFunction.lua")
c_Require("Script/"..APath.."/Com/AMessBox.lua")

-- ====================================================
-- Cmp
-- ====================================================
c_Require("Script/"..APath.."/Cmp/ANTab.lua")
c_Require("Script/"..APath.."/Cmp/TweenPro.lua")
c_Require("Script/"..APath.."/Cmp/AScroll.lua")
c_Require("Script/"..APath.."/Cmp/AScrollEx.lua")
c_Require("Script/"..APath.."/Cmp/AScrollA.lua")
c_Require("Script/"..APath.."/Cmp/MsgBox.lua")
c_Require("Script/"..APath.."/Cmp/Scroll.lua")
c_Require("Script/"..APath.."/Cmp/ScrollA.lua")
c_Require("Script/"..APath.."/Cmp/ScrollRevA.lua")
c_Require("Script/"..APath.."/Cmp/ScrollH.lua")
c_Require("Script/"..APath.."/Cmp/ScrollEx.lua")
c_Require("Script/"..APath.."/Cmp/ScrollExA.lua")
c_Require("Script/"..APath.."/Cmp/Swiper.lua")
c_Require("Script/"..APath.."/Cmp/Slide.lua")
c_Require("Script/"..APath.."/Cmp/Tab.lua")
c_Require("Script/"..APath.."/Cmp/NTab.lua")
c_Require("Script/"..APath.."/Cmp/Nav.lua")
c_Require("Script/"..APath.."/Cmp/NavSingle.lua")
c_Require("Script/"..APath.."/Cmp/BackUI.lua")
c_Require("Script/"..APath.."/Cmp/LoadUI.lua")
c_Require("Script/"..APath.."/Cmp/LoadDown.lua")
c_Require("Script/"..APath.."/Cmp/LoadAniUI.lua")
c_Require("Script/"..APath.."/Cmp/Loading.lua")
c_Require("Script/"..APath.."/Cmp/LabelUI.lua")
c_Require("Script/"..APath.."/Cmp/NavSingle1.lua")
c_Require("Script/"..APath.."/Cmp/ATab.lua")
c_Require("Script/"..APath.."/Cmp/ABottom.lua")
c_Require("Script/"..APath.."/Cmp/HtmlUI.lua")
c_Require("Script/"..APath.."/Cmp/MgDef.lua")
c_Require("Script/"..APath.."/Cmp/ScrollVideo.lua")

--顶部标题
c_Require("Script/"..APath.."/MyInfo/Title.lua")
--消息
c_Require("Script/"..APath.."/ModuleMessage/AChat.lua")
--我的
c_Require("Script/"..APath.."/MyInfo/MyView.lua")
c_Require("Script/"..APath.."/MyInfo/EditMyName.lua")
c_Require("Script/MiLiao/MyInfo/ABlank.lua");
--搜索
c_Require("Script/"..APath.."/Search/SearchView.lua")
c_Require("Script/"..APath.."/Search/SearchItem.lua")
c_Require("Script/"..APath.."/Search/SearchOpenItem.lua")
--官方认证
c_Require("Script/"..APath.."/MyInfo/OfficialCertification/OfficialCertification.lua")
c_Require("Script/"..APath.."/MyInfo/OfficialCertification/PhotoItem.lua")
c_Require("Script/"..APath.."/MyInfo/OfficialCertification/PersonalInfoitem.lua")
c_Require("Script/"..APath.."/MyInfo/OfficialCertification/SubmitItem.lua")
c_Require("Script/"..APath.."/MyInfo/OfficialCertification/CertificationView.lua")
c_Require("Script/"..APath.."/MyInfo/OfficialCertification/SelectOptionView.lua")
c_Require("Script/"..APath.."/MyInfo/OfficialCertification/Picker.lua")
--关注、黑名单、粉丝列表、消息列表
c_Require("Script/"..APath.."/MyInfo/BlackList/BlackListView.lua")
c_Require("Script/"..APath.."/MyInfo/BlackList/BlackListItem.lua")
c_Require("Script/"..APath.."/MyInfo/FanList/FanListView.lua")
c_Require("Script/"..APath.."/MyInfo/FanList/FocusListView.lua")
c_Require("Script/"..APath.."/MessageList/MessageListView.lua")
c_Require("Script/"..APath.."/MessageList/MessageListItem.lua")
--身份认证
c_Require("Script/"..APath.."/MyInfo/RealNameAuthentication/RealNameAuthened.lua")
c_Require("Script/"..APath.."/MyInfo/RealNameAuthentication/RealNameAuthening.lua")
c_Require("Script/"..APath.."/MyInfo/RealNameAuthentication/RealNameUnAuthen.lua")

-- 启动页面
c_Require("Script/"..APath.."/ModuleStart/AStartLoadUI.lua")
c_Require("Script/"..APath.."/UserDetaile/DetaileView.lua")

-- 登录相关
c_Require("Script/"..APath.."/ALogin/ALogin.lua")
c_Require("Script/"..APath.."/ALogin/AEditingInformation.lua")


-- 首页
c_Require("Script/"..APath.."/AHomePage/AHomePageView.lua")
c_Require("Script/"..APath.."/AHomePage/AHomePageMessageBox.lua")
c_Require("Script/MiLiao/ADynamic/ADynamicView.lua");		--动态页面

-- 底部菜单栏
c_Require("Script/MiLiao/AHomePage/AHomePageButtom.lua");


-- 咪一下
c_Require("Script/"..APath.."/MiYiXia/MiOneView.lua")

-- 登录后的主视图
c_Require("Script/"..APath.."/AHomePage/AHomeView.lua")
-- 视频
c_Require("Script/"..APath.."/Video/PlayVideoItem.lua")
c_Require("Script/"..APath.."/Video/PlayView.lua")
c_Require("Script/"..APath.."/Video/BackPop.lua")

-- 标签
c_Require("Script/"..APath.."/MiYiXia/SetMiLabel.lua")
c_Require("Script/"..APath.."/MyInfo/MyTagHelp.lua")

local local_agora = agora;
local local_tim = tim;
local local_tsdk = tim.sdk;
local local_tconv = tim.Conv;
local local_tmsg = tim.Msg;
local local_tgroup = tim.Group;
local local_tuser = tim.UserProfile;
local local_tfriend = tim.Friendship;

local tv = TVideo;

local VoiceFilePath = "videos/";
local VoiceFile = "temp.dat";


kd.ViewType =
{
	ViewType_Begin = -1,
	ViewType_Login = 0,
	ViewType_Homepage = 1,
	ViewType_Discovery = 2,
	ViewType_Message = 3,
	ViewType_MeView = 4,
	ViewType_End = 5,
}

if(kd.GetSystemType()==kd.SystemType.OS_WIN32) then
	kd.AliPushBindAccount = function() end
	kd.AliPushUnBindAccount = function() end
	kd.CheckMsgPushPermissions = function() return false; end
end

local LayerManage = {}

function A_ViewManager:init(father)	
	
	math.randomseed(tostring(os.time()):reverse():sub(1, 7));

	local TweenPro = kd.class(TweenPro,true,false);
    kd.AddLayer(TweenPro);
	
	self.m_father = father;
	self.m_Load = father.LoadResLayer;
	self.m_LoadType = 0;	-- 加载进度
	
	self.m_MessageBoxVct = {};
	
	--语聊
	self.m_YLDownFileList = {};		--待下载列表
	self.m_YLPlayFileList = {};		--待播放列表
	self.m_YLLastFileList = {};		--上一条列表
	self.m_bYLPlaying = false;		--是否正在播放语音
	self.m_nYLBreakMode = 0;		--中断模式(0-未中断，1-因录音中断，2-因播放中断, 3-停止所有播放)
	
	--创建语音保存目录
	local video_path = kd.GetSysWritablePath()..VoiceFilePath;
	if(kd.CreateDirectory(video_path)==false) then
		echo("KD_LOG:创建语音目录失败！");
	end	
	--self.isFirstInstall =  self:IsFirstInstall()
end

--获取小客服的IMid
function A_ViewManager:GetServiceIMid()
	if self.m_User.IMPre then
		return self.m_User.IMPre.."1";
	else
		return 1;
	end
end

-- 设置登录完成数据
function A_ViewManager:SetLogin(data)
	self.m_AddData = data;
	self.m_Config = data.config
	self.m_Tags = data.tags
	
	self:SetUser(data);
end



--设置当前聊天对方ID
function A_ViewManager:SetNewConvid(convid)
	self.m_Convid = convid;
end	

--获取当前聊天对方ID
function A_ViewManager:GetNewConvid()
	return self.m_Convid;
end	


--保存用户信息
function A_ViewManager:SetUser(user)
	self.m_User = user;		--基本信息
	
	self.m_User.userId = self.m_User.UserId;
	self.m_User.userKey = self.m_User.UserKey ;
	
	---------------------------------初始化标签--------------------------------------
	gSink:Post("michat/get-tagslist",{},function(data)
		if data.Result then
			gDef.TagsList = data.TagsList 
		end
	end,false);

	--获取自己的头像名字
	DC:CallBack("MyView.updateme")
	-----------------------------------------------------------------------	
	
	
	if self.IMAppid then		--已经初始化过IM
		-----------------------------登陆----------------------------------
		--构建user data
		login_data = {};
		login_data.call_id = "login";
		login_json = kd.CJson.EnCode(login_data);
		
		local tsid = self.m_User.IMPre..self.m_User.userId;
		self.m_myconvid = tsid;		--自己TIM账号
		ret = local_tsdk.login(tsid, 
							self.m_User.IMSig,
							login_json);
		if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
			echo("KD_LOG:调用TIM login失败,错误:"..ret);
		end-----------------------------------------------------------------
		return;
	else
		self.IMAppid=self.m_User.IMAppid;
	end
	
	--初始化TIM
	local ret = local_tsdk.init(self.IMAppid, "");
	if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
		echo("KD_LOG:调用TIM init失败,错误:"..ret);
	else
		--设置回调tabel
		local_tim.registerEventHandler(self:GetIMTimBackCalls());
		
		-----------------------------登陆----------------------------------
		--构建user data
		login_data = {};
		login_data.call_id = "login";
		login_json = kd.CJson.EnCode(login_data);
		
		local tsid = self.m_User.IMPre..self.m_User.userId;
		self.m_myconvid = tsid;		--自己TIM账号
		ret = local_tsdk.login(tsid, 
							self.m_User.IMSig,
							login_json);
		if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
			echo("KD_LOG:调用TIM login失败,错误:"..ret);
		end-----------------------------------------------------------------
	end

	
	TVideo.registerEventHandler(self:GetTVideoBackCalls());
	
	local code,messag = TVideo.init("1387045864", "452e5fe12efbda9e87f4ecf1782b59cd",  tostring(self.m_User.userId));
	if code~=0 then
		echo("KD_LOG:调用TVideo.init失败,错误:"..messag);
	end
	
end

function A_ViewManager:GetUser()
	return self.m_User;
end

--是否加载完成
function A_ViewManager:IsInitFinish()
	return self.m_LoadType > 6;
end

function A_ViewManager:update(delta)	

	if(self.m_LoadType < 0 or self.m_LoadType > 6) then 
		return; 
	end
	
	-- ===========================================
	-- 登录层
	-- ===========================================
	if(self.m_LoadType == 0) then

		LayerManage.StartLayer = kd.class(AStartLoadUI,false,false);
		LayerManage.StartLayer:init();
		kd.AddLayer(LayerManage.StartLayer);
		LayerManage.StartLayer:SetVisible(false)
		
		LayerManage.LoginLayer = kd.class(kd.Layer);
		kd.AddLayer(LayerManage.LoginLayer);
		LayerManage.LoginLayer:SetVisible(false);

		-- 登录
		LayerManage.LoginView = kd.class(ALogin,false,true);
		LayerManage.LoginView:init();
		LayerManage.LoginLayer:addChild(LayerManage.LoginView);
		--设置显示隐藏的动画模式
		local x, y = LayerManage.LoginView:GetPos();
		LayerManage.LoginView:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
		LayerManage.LoginView:SetVisible(false);
		
		self.m_LoadType = self.m_LoadType + 1
		return;		
	end
	-- ===========================================
	-- 菜单1 首页
	-- ===========================================
	if(self.m_LoadType == 1) then

		LayerManage.AHomeIndex = kd.class(AHomeView, false, true);
		LayerManage.AHomeIndex:init(self);
		kd.AddLayer(LayerManage.AHomeIndex);
		LayerManage.AHomeIndex:SetVisible(false);
			
		self.m_LoadType = self.m_LoadType + 1
		return;		
	end
	-- ===========================================
	-- 菜单2 视频
	-- ===========================================
	if(self.m_LoadType == 2) then
			
		self.m_LoadType = self.m_LoadType + 1
		return;		
	end
	-- ===========================================
	-- 菜单3 消息
	-- ===========================================
	if(self.m_LoadType == 3) then
		
		LayerManage.AChat = kd.class(AChat, false, true);
		kd.AddLayer(LayerManage.AChat);
		LayerManage.AChat:SetVisible(false);
		LayerManage.AChat:init(self);
		LayerManage.AChat:SetVisible(false);
		LayerManage.AChat:SetZOrder(10);
		self.m_LoadType = self.m_LoadType + 1
		return;		
	end
	-- ===========================================
	-- 菜单4 我的
	-- ===========================================
	if(self.m_LoadType == 4) then
		
	
		self.m_LoadType = self.m_LoadType + 1
		return;		
	end
	-- ===========================================
	-- 底部菜单
	-- ===========================================
	if(self.m_LoadType == 5) then
		-- 蒙版
		self.mask = kd.class(MaskUI, false, true);
		self.mask:init();
		kd.AddLayer(self.mask)
		self.mask:SetVisible(false);
		self.mask:SetZOrder(2);
		
		--	底部菜单栏
		self.m_AHomePageButtom = kd.class(AHomePageButtom,true,false);
		self.m_AHomePageButtom:init();
		kd.AddLayer(self.m_AHomePageButtom);
		self.m_AHomePageButtom:SetVisible(false);
		self.m_AHomePageButtom:SetZOrder(1);
		
		--	用户协议隐私政策(首页)
		self.m_AHomePageMessageBox = kd.class(AHomePageMessageBox,false,true);
		self.m_AHomePageMessageBox:init();
		kd.AddLayer(self.m_AHomePageMessageBox);
		self.m_AHomePageMessageBox:SetVisible(false);
		self.m_AHomePageMessageBox:SetZOrder(2);
		
		-- 咪一下
		LayerManage.Mi = kd.class(kd.Layer);
		kd.AddLayer(LayerManage.Mi);
		LayerManage.Mi:SetVisible(false);
		LayerManage.Mi:SetZOrder(2);
		-- 咪一下 设置
		self.m_viewMi = kd.class(MiOneView, false, true);
		self.m_viewMi:init();
		LayerManage.Mi:addChild(self.m_viewMi);
		self.m_viewMi:SetVisible(false);
		--设置显示隐藏的动画模式
		local x, y = self.m_viewMi:GetPos();
		self.m_viewMi:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x, y+ScreenH);
		self.m_viewMi:SetVisible(false);
		
		-- 咪一下 更改标签设置
		self.m_MI_ChangeLabel = kd.class(MI_ChangeLabel,false,true);
		self.m_MI_ChangeLabel:init();
		LayerManage.Mi:addChild(self.m_MI_ChangeLabel);
		self.m_MI_ChangeLabel:SetVisible(false);
		local x, y = self.m_MI_ChangeLabel:GetPos();
		self.m_MI_ChangeLabel:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x, y+ScreenH);
		self.m_MI_ChangeLabel:SetVisible(false);
		
		-- 咪一下 主界面
		self.m_Mi_MainLabel = kd.class(Mi_MainLabel, false, true);
		self.m_Mi_MainLabel:init();
		LayerManage.Mi:addChild(self.m_Mi_MainLabel);
		self.m_Mi_MainLabel:SetVisible(false);
		--设置显示隐藏的动画模式
		local x, y = self.m_Mi_MainLabel:GetPos();
		self.m_Mi_MainLabel:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
		self.m_Mi_MainLabel:SetVisible(false);
		
		-- 视频
		self.PlayView = kd.class(PlayView, true, true);
		self.PlayView:init();
		LayerManage.Mi:addChild(self.PlayView);
		self.PlayView:SetVisible(false);
		--设置显示隐藏的动画模式
		local x, y = self.PlayView:GetPos();
		self.PlayView:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
		self.PlayView:SetVisible(false);
		
		-- 详情
		self.m_DetaileView = kd.class(DetaileView, false, true);
		self.m_DetaileView:init();
		kd.AddLayer(self.m_DetaileView);
		self.m_DetaileView:SetVisible(false);
		--设置显示隐藏的动画模式
		local x, y = self.m_DetaileView:GetPos();
		self.m_DetaileView:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
		self.m_DetaileView:SetVisible(false);
		self.m_DetaileView:SetZOrder(2);

		--------------------------- 评论 ---------------------------
		self.m_Comments = kd.class(Comments, true, true);
		self.m_Comments:init();
		LayerManage.Mi:addChild(self.m_Comments);
		self.m_Comments:SetVisible(false);
		local x, y = self.m_Comments:GetPos();
		self.m_Comments:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x, y+ScreenH);
		self.m_Comments:SetVisible(false);
		
		-- 网页
		self.htmllayer = kd.class(kd.Layer);
		kd.AddLayer(self.htmllayer)
		self.htmllayer:SetVisible(false)
		self.htmlui =  kd.class(HtmlUI,false,true);
		self.htmlui:init()
		self.htmllayer:SetZOrder(5);
		self.htmllayer:addChild(self.htmlui);
		local x, y = self.htmlui:GetPos();
		self.htmlui:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
		self.htmlui:SetVisible(false);
		
		-- 弹出框
		self.msgbox = kd.class(MsgBox,false,true);
		self.msgbox:init()
		kd.AddLayer(self.msgbox)
		self.msgbox:SetVisible(false);
		self.msgbox:SetZOrder(3);
		
		-- 加载等待
		self.loading = kd.class(Loading,true,true);
		kd.AddLayer(self.loading)
		self.loading:init();
		self.loading:SetVisible(false);
		self.loading:SetZOrder(10);
		
		self.m_LoadType = self.m_LoadType + 1
		return;		
	end
	-- ===========================================
	-- 加载完成
	-- ===========================================
	if(self.m_LoadType == 6) then
		self.m_LoadType = self.m_LoadType + 1
		self:LoadComplete()
		return;		
	end
	
	return;
end
function A_ViewManager:ShowPolicy()
	self.policy:SetVisible(true)
end
function A_ViewManager:ShowHtml(title,url)
	self.htmllayer:SetVisible(true)
	self.htmlui:Show(title,url)
end

-- 显示蒙版
function A_ViewManager:ShowMask(bo)
	self.mask:SetVisible(bo);
end

function A_ViewManager:ShowMi(bo)
	LayerManage.Mi:SetVisible(bo);
end

-- 加载完成
function A_ViewManager:LoadComplete()
	LayerManage.StartLayer:SetVisible(true)
		
end
-- 显示视图
function A_ViewManager:ShowLayer(layerName)
	LayerManage.LoginLayer:SetVisible(false)
	LayerManage.AHomeIndex:SetVisible(false)
	LayerManage.VListIndex:SetVisible(false)
	LayerManage.ChatLayer:SetVisible(false)
	if layerName ~= "MeLayer" then 
		LayerManage.MeLayer:SetVisible(false)
	end
	
	if layerName == "LoginLayer" then
		LayerManage.LoginLayer:SetVisible(true)
		LayerManage.BottomLayer:SetVisible(false);
	elseif layerName == "AHomeIndex" then
		LayerManage.AHomeIndex:SetVisible(true)
		LayerManage.BottomLayer:SetVisible(true);
	elseif layerName == "VListIndex" then
		LayerManage.VListIndex:SetVisible(true)
		LayerManage.BottomLayer:SetVisible(true);
	elseif layerName == "ChatLayer" then
		LayerManage.ChatLayer:SetVisible(true)
		LayerManage.BottomLayer:SetVisible(true);
	elseif layerName == "MeLayer" then	
		LayerManage.MeLayer:SetVisible(true)
		LayerManage.BottomLayer:SetVisible(true);
	end
end

function A_ViewManager:ShowLoginLayer()
	LayerManage.LoginLayer:SetVisible(true);
end

function A_ViewManager:CloseClient()
	--KDOss.uninit();
	--KDNim.logout(1);
end

--退出
function A_ViewManager:Exit()
	kd.AliPushUnBindAccount();
	
	--TIM登出
	login_data = {};
	login_data.call_id = "logout";
	login_json = kd.CJson.EnCode(login_data);
	
	ret = local_tsdk.logout(login_json);
	if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
		echo("KD_LOG:调用TIM login失败,错误:"..ret);
	end
	
	if LayerManage.LoginView.Clear then
		LayerManage.LoginView:Clear();
	end	
	
	--[[if LayerManage.ChatLayer.Clear then
		LayerManage.ChatLayer:Clear();
	end	--]]
	
	DC:CallBack("MyView.Clear")
	DC:CallBack("MessageListView.Clear")
	
	--LayerManage.AHomeIndex:Cls()
	--LayerManage.VListIndex:Cls()
	--LayerManage.BottomLayer:Cls()
	self.m_AHomePageMessageBox:SetVisible(false);		--	隐私弹窗

	--self:ShowBottomBar(false);
	DC:CallBack("AHomePageButtom.SwitchIcon",1);	
	DC:CallBack("AHomePageButtom.Show",false);			

	DC:CallBack("AHomeView.Show",false)
	DC:CallBack("ALogin.clear",true)

	self.m_User = nil;		--退出后用户数据要清空1
	
	-- 清空标签
	self:SetMyTags(nil);

	-- 隐藏播放视频界面
	DC:CallBack("PlayView.Show",false);
	
	DC:CallBack("AHomePageButtom.isLogingIn",true);
	DC:FillData("AHomeView.HateList",nil);			--	黑名单
end

function A_ViewManager:OnTimerBackCall(id)

end 


-- 刷新MeView页面
function A_ViewManager:ReLoadMeViewLayer()
	LayerManage.MeLayer:ReLoad();
end

--显示权限界面
function A_ViewManager:ShowJurisdictionView()
	if(self:IsIosAuditVer()) then return; end
	
	local JurisdictionOpened = 0;
	
	local szFile = gDef.ConfigPath..gDef.JurisdictionFile;
	local tData = kd.CJson.OpenFile(szFile); 
	if(tData) then
		if(tData.open) then JurisdictionOpened = tData.open; end
	end
	
	if(JurisdictionOpened ~= 0) then 
		local ret = kd.CheckMsgPushPermissions()
		if ret==false then	--检测推送权限，当前仅在IOS有效
			self:ShowNotice(true);
			self.m_bShowNotice = true;
		else
			self:ShowNotice(false);
			self.m_bShowNotice = false;		
		end				
		return; 
	end
	
	--权限界面
	if(self.m_Jurisdiction==nil) then
		self.m_Jurisdiction = kd.class(Jurisdiction, false, true);
		self.m_Jurisdiction:init(self);
		kd.AddLayer(self.m_Jurisdiction);
	end
	self.m_Jurisdiction:SetVisible(true);
end

--不再显示权限界面
function A_ViewManager:HideJurisdictionView(bClose)
	if(self.m_Guide) then
		self.m_Guide:SetVisible(false);
	end
	
	local Data = {open=1};
	kd.CJson.WriteFile(gDef.ConfigPath,gDef.JurisdictionFile,Data);	
		
	if kd.CheckMsgPushPermissions()==false then	--检测推送权限，当前仅在IOS有效
		self:ShowNotice(bClose);
		self.m_bShowNotice = true;	
	end	
end

--请求麦克风权限
function A_ViewManager:RequestMicrophonePermissions()
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
function A_ViewManager:RequestCameraPermissions()
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
function A_ViewManager:RequestPhotoPermissions()
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

function A_ViewManager:IsFirstInstall()
	local szFile = gDef.ConfigPath  
	local filename = "IsFirstInstall.ini"
	local data = kd.CJson.OpenFile(szFile .. filename);
	if data and data.bFirstInstall then
		return false
	else
		local tb = {}
		tb.bFirstInstall = true
		kd.CJson.WriteFile(szFile,filename,tb);	
		return true
	end
end

--请求通知权限
function A_ViewManager:RequestMsgPushPermissions()
	local bRet = kd.CheckMsgPushPermissions();
	--有授权
	if(bRet) then return; end
	--无授权
	local szFile = gDef.ConfigPath..gDef.JurisdictionFile;
	local tData = kd.CJson.OpenFile(szFile); 
	if(tData and tData.MsgPush) then
		local a = kd.SystemType.OS_IOS;
		echo("kd.SystemType.OS_IOS=="..a);
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

--请求通地理位置
function A_ViewManager:RequestPositionPermissions()
	local bRet = kd.CheckPositionPermissions();
	--有授权
	if(bRet) then return; end
	--无授权
	local szFile = gDef.ConfigPath..gDef.JurisdictionFile;
	local tData = kd.CJson.OpenFile(szFile); 
	if(tData and tData.GetPosition) then
		if(kd.GetSystemType()==kd.SystemType.OS_IOS) then
			kd.IosOpenAppPermissionSetting();
		end		
		return;
	end
	--用户未进行授权操作
	kd.RequestPositionPermissions();
	local Data = tData or {};
	Data.GetPosition = true;
	kd.CJson.WriteFile(gDef.ConfigPath,gDef.JurisdictionFile,Data);	
end




--显示权限界面
function A_ViewManager:ShowJurisdiction(bVisible)
	if(self.m_Jurisdiction) then self.m_Jurisdiction:SetVisible(bVisible); end
end

function A_ViewManager:ShowBottomBar(bVisible,bAction)
	if(LayerManage.BottomLayer) and self:IsInitFinish() then
		LayerManage.BottomLayer:SetVisible(bVisible)
	end
end

--显示底部通知
function A_ViewManager:ShowBottomNotice(bVisible)
	DC:CallBack("AHomePageButtom.SetUnread",bVisible)
end


--带按钮的弹框
function A_ViewManager:messagebox(options)
	self.msgbox:Show(options)
end

--半透明弹框（只能输中文字符）
function A_ViewManager:messagebox_default(szStr,dwlayTime)
	--dwlayTime 延迟显示
	if self.m_MessBoxDlg then
		self.m_MessBoxDlg:SetVisible(false);
		self.m_MessBoxDlg = nil;
	end
	if self.m_MessBoxDlg==nil then
		self.m_MessBoxDlg = kd.class(AMessBox, false, true);
		self.m_MessBoxDlg:SetZOrder(999);
		kd.AddLayer(self.m_MessBoxDlg);
		self.m_MessBoxDlg:AddBox(szStr,dwlayTime);
	end
	return self.m_MessBoxDlg
end

function A_ViewManager:messagebox_remove(msgbox)
	for i=1,#self.m_MessageBoxVct do
		local MsgBoxDlg = self.m_MessageBoxVct[i];
		if(MsgBoxDlg and MsgBoxDlg==msgbox) then
			table.remove(self.m_MessageBoxVct,i);
			return;
		end
	end
end

function A_ViewManager:onTouchBack(nID,dwBtn)
	
end


--打开系统相册或者照相获取图片并保存到指定地点
function A_ViewManager:OpenPhotoGetJPEG(_type, _path, _fileName, _maxW, _backObj,_nOpenType)
	if (_backObj == nil) then return; end
	
	self.PhotoBackObj = _backObj;
	if _nOpenType == nil then 
		_nOpenType = 1;
	end
	return kd.OpenPhotoGetJPEG(_type, _path, _fileName, _maxW,_nOpenType);
end

--相册回调
function A_ViewManager:OnSystemPhotoRet(--[[string]] _filePath, --[[int]] fileType)
	if (self.PhotoBackObj) then 
		self.PhotoBackObj:OnSystemPhotoRet(_filePath, fileType);
		if fileType~=2 then  --如果不是选择的视频回调.  就清空回调对象
			self.PhotoBackObj = nil;
		end
	end
end

--相册回调
function A_ViewManager:OnVideoGetInfoRetEvent(err_code,video_file,steams,kbps,w,h,r,rate,max_time,fps,cover_path)
	if (self.PhotoBackObj) then 
		self.PhotoBackObj:OnVideoGetInfoRetEvent(err_code,video_file,steams,kbps,w,h,r,rate,max_time,fps,cover_path);
		self.PhotoBackObj = nil;
	end
end


--更新消息界面数据
function A_ViewManager:UpdateMessageView()
	local Data = {maxChatId = 1};
	self:SendData(LayerManage.ChatLayer,kd.urlID.MAIN_MESSAGE,Data);
end	


--加 tim ID前缀
function A_ViewManager:AddTimPre(szID)
	if self.m_User==nil then
		return nil;
	end
	if self.m_User.IMPre then
		szID = self.m_User.IMPre..szID;
	end
	return szID;
end

--去 tim ID前缀
function A_ViewManager:RemoveTimPre(szCCID)
	if self.m_User==nil then
		return nil;
	end
	if self.m_User.IMPre then
		local nFind = string.find(szCCID, self.m_User.IMPre);
		if(nFind==nil) then return szCCID; end
		szCCID = string.sub(szCCID,nFind+string.len(self.m_User.IMPre));
	end
	return szCCID;
end



--显示WEB界面
function A_ViewManager:ShowWebView(url,title)
	self.m_JsWebView:Show(url,title);
end

--隐藏WEB界面
function A_ViewManager:HideWebView()
	self.m_JsWebView:SetVisible(false);
end
	
--用户按下android的后退键或者PC的ESC键后弹起回调
function A_ViewManager:onBackKeyReleased()

end	

--用户按下HOME键
function A_ViewManager:OnHomeBackCall()
	-- 在视频界面Home出去
	self.PlayView:OnHomeBackCall();
end	

--HOME回来
function A_ViewManager:onResume()
	self.PlayView:onResume();
end



--播放音效
function A_ViewManager:PlayEffect(--[[string--]] effPath, --[[bool--]]loop)
	if loop==nil then
		loop = false;
	end
	local nID = -1;
	if(kd.GetSystemType()==kd.SystemType.OS_IOS) then
		effPath = gDef.GetResPath(effPath);
		if self.m_PlayVideo==nil then
			self.m_PlayVideo = kd.class(kd.VideoView,0,0);
			self:addChild(self.m_PlayVideo);
		end
		self.m_bPlay = true;
		self.m_PlayVideo:Play(effPath);
		self.m_PlayVideo.OnplayEnd = function(this)
			if self.m_bPlay then 
				if loop then
					this:Play(effPath);
				end
			end
		end
	else
		nID =  kd.PlayEffect(gDef.GetResPath(effPath),loop);
	end	
	return nID;
end

--停止音效
function A_ViewManager:StopEffect(nID)
	if(kd.GetSystemType()==kd.SystemType.OS_IOS) then
		if self.m_PlayVideo then
			self.m_PlayVideo:Stop();
			self.m_bPlay = false;
		end
	else
		if nID then
			kd.StopEffect(nID);
		else
			kd.StopAllEffect();
		end
	end	
end

-- 停止视频
function A_ViewManager:StopVideo()
	self.m_GetOneList:Stop();
	self.m_GetBeforeOneList:Stop();
end

-- 停止通话
function A_ViewManager:StopVideoChat()
	self.m_GetOneList:StopVideoChat();
	self.m_GetBeforeOneList:StopVideoChat();
end

--是否审核版本
function A_ViewManager:IsIosAuditVer()
	return self.m_father:IsIosAuditVer();
end

--版本号字符串
function A_ViewManager:GetVersionStr()
	return self.m_father:GetVersionStr();
end


--微信登录回调
function A_ViewManager:OnSystemWXLoginRet(--[[int]] err_code,	--错误code(0:成功 非0:失败)
							--[[string]] err_msg,				--错误消息 
							--[[string]] wx_open_id,			--微信用户OPENID
							--[[string]] _wx_nick_name,			--微信用户昵称
							--[[string]] _wx_sex,				--微信用户性别
							--[[string]] _wx_province,			--微信用户的省份
							--[[string]] _wx_city,				--微信用户的城市
							--[[string]] _wx_country,			--微信用户的国家
							--[[string]] _wx_headimgurl,		--微信用户的头像
							--[[string]] _wx_unionid)			--微信用户的统一标识
	echo("KD_LOG:A_ViewManager OnSystemWXLoginRet err_code="..err_code..",err_msg="..err_msg..",wx_open_id="..wx_open_id..
		",_wx_nick_name=".._wx_nick_name..",_wx_sex=".._wx_sex..",_wx_headimgurl=".._wx_headimgurl..",_wx_unionid=".._wx_unionid);
	
	if(err_code~=0) then
		self:SetLoadingView(false);
		self:messagebox_default(err_msg);
		return;
	end
	LayerManage.LoginLayer:CommonAccountLogin(wx_open_id,"wechat",_wx_nick_name,_wx_sex,_wx_headimgurl,_wx_unionid);
	self:SetLoadingView(true);
end

--QQ登录回调
function A_ViewManager:OnSystemQQLoginRet(--[[int]] err_code,	--错误code(0:成功 非0:失败)
							--[[string]] err_msg,				--错误消息 
							--[[string]] openid,				--QQ用户OPENID
							--[[string]] nickname,				--QQ用户昵称
							--[[string]] sex,					--QQ用户性别
							--[[string]] province,				--QQ用户的省份
							--[[string]] city,					--QQ用户的城市
							--[[string]] headimgurl,			--QQ用户的头像
							--[[string]] unionid)				--QQ用户的统一标识
	echo("KD_LOG:A_ViewManager OnSystemQQLoginRet err_code="..err_code..",err_msg="..err_msg..",openid="..openid..
		",nickname="..nickname..",sex="..sex..",headimgurl="..headimgurl);	
		
	if(err_code~=0) then
		self:SetLoadingView(false);
		self:messagebox_default(err_msg);
		return;
	end	
	LayerManage.LoginLayer:CommonAccountLogin(openid,"qq",nickname,sex,headimgurl,unionid);		
	self:SetLoadingView(true);
end

--微博登录回调
function A_ViewManager:OnSystemWBLoginRet(--[[int]] err_code,				--错误code(0:成功 非0:失败)
							--[[string]] err_msg,				--错误消息 
							--[[string]] openid,				--微博用户OPENID
							--[[string]] nickname,				--微博用户昵称
							--[[string]] sex,					--微博用户性别
							--[[string]] location,				--微博用户的所在地
							--[[string]] headimgurl,			--微博用户的头像
							--[[string]] unionid)				--微博用户的头像
	echo("KD_LOG:A_ViewManager OnSystemWBLoginRet err_code="..err_code..",err_msg="..err_msg..",openid="..openid..
		",nickname="..nickname..",sex="..sex..",headimgurl="..headimgurl);	
		
	if(err_code~=0) then
		self:SetLoadingView(false);
		self:messagebox_default(err_msg);
		return;
	end		
	LayerManage.LoginLayer:CommonAccountLogin(openid,"weibo",nickname,sex,headimgurl,unionid);				
	self:SetLoadingView(true);
end

--阿里推送绑定账号回调
function A_ViewManager:OnAliPushBindAccountRet(--[[int]] err_code, --[[string]] err_msg)

end

--系统推送透传消息回调
function A_ViewManager:OnSysPushThroughMsg(--[[string]] title, --[[string]] body)
    
end

--系统推送消息打开应用回调
function A_ViewManager:OnSysPushMsgOpenApp(--[[string]] content)

end



--TVideo语音回调
function A_ViewManager:GetTVideoBackCalls()
local meTVideoBackCalls = {
	--接口通用回调的定义
	OnApplyMsgKey = function( --[[GCloudVoiceCompleteCode]] _ncode, --[[string]] _err_msg)
		if (_ncode ~= tv.GCloudVoiceCompleteCode.GV_ON_MESSAGE_KEY_APPLIED_SUCC) then
			echo("KD_LOG:TVideo init fail! code:".._ncode.." msg:".._err_msg);
		else
			b_tvideo_init = true;
			--设置最大录音时长
			local code, msg = tv.SetVoiceMaxTime(10000);
			if (code ~= tv.GCloudVoiceErr.GCLOUD_VOICE_SUCC) then
				echo("KD_LOG:TVideo set voice max time fail! code:"..code.." msg:"..msg);
			end
			
			echo("KD_LOG:TVideo init succ!");
		end
	end;
	
	--[[
	上传语聊回调函数
	
	参数:
	_sev_file_id:服务器中以供下载的文件索引
	_ncode:异步处理中可能产生的错误code
	_err_msg:异步处理中可能产生的错误消息
	]]
	OnUploadVoice = function(--[[string]] _sev_file_id, --[[GCloudVoiceCompleteCode]] _ncode, --[[string]] _err_msg)
		if (_ncode ~= tv.GCloudVoiceCompleteCode.GV_ON_UPLOAD_RECORD_DONE) then
			echo("KD_LOG:TVideo OnUploadVoice fail! code:".._ncode.." msg:".._err_msg);
		else
			echo("KD_LOG:TVideo OnUploadVoice succ!");
		end
	end;
	
	--[[
	下载语聊回调函数
	
	参数:
	_sev_file_id:语音文件在服务器中的索引
	_save_file:本地保存路径
	_file_size:语音文件的磁盘大小
	_voice_time:语音文件的播放时长(秒)
	_ncode:异步处理中可能产生的错误code
	_err_msg:异步处理中可能产生的错误消息
	]]
	OnDownloadVoice = function(--[[string]] _sev_file_id, --[[string]] _save_file, --[[uint]] _file_size, --[[float]] _voice_time, --[[GCloudVoiceCompleteCode]] _ncode, --[[string]] _err_msg)
		if (_ncode ~= tv.GCloudVoiceCompleteCode.GV_ON_DOWNLOAD_RECORD_DONE) then
			echo("KD_LOG:TVideo OnDownloadVoice fail! code:".._ncode.." msg:".._err_msg);
			
		else
			echo("KD_LOG:TVideo OnDownloadVoice succ!");
			
		end
	end;
	
	--[[
	语聊播放结束
	
	参数:
	_v_file:播放完毕的语音文件路径
	]]
	OnPlayVoiceEnd = function(--[[string]] _v_file)
		echo("KD_LOG:TVideo OnPlayVoiceEnd succ!");
		
		DC:CallBack("PlayYuYinEnd",false);
	end;

}	

	return meTVideoBackCalls;
end


function A_ViewManager:GetIMTimBackCalls()
	
local meTimBackCalls = {
	--接口通用回调的定义
	OnTimComm = function(--[[tim.sdk.TIMError]] code, --[[string]] desc, --[[string]] json_params, --[[string]] user_data)
		--dump(json_params)
		local t = kd.CJson.DeCode(user_data);
		if (t ~= nil) then
			if (t.call_id == "login") then
				--登陆回调
				if (code ~= local_tsdk.TIMErrCode.ERR_SUCC) then
					echo("KD_LOG:TIM login err_code:"..code.." err_desc:"..desc);
					return;
				else	
					echo("KD_LOG:TIM login success.");
					
					---------------------------------------------------
					--关闭日志
					login_data = {};
					login_data.call_id = "setConfig";
					login_json = kd.CJson.EnCode(login_data);
					
					local config = {};
					
					config[local_tsdk.SetConfig.kTIMSetConfigIsLogOutputConsole] = false;
					config[local_tsdk.SetConfig.kTIMSetConfigLogLevel] = 0;
					config[local_tsdk.SetConfig.kTIMSetConfigCackBackLogLevel] = 0;
					
					config = kd.CJson.EnCode(config);
					ret = local_tsdk.setConfig(config,
										login_json);
					if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
						echo("KD_LOG:调用TIM login失败,错误:"..ret);
					end
					---------------------------------------------------
					
					--获取消息列表
					self:GetConvList();
		
					
					--创建会话
					
					--构建user data
--[[					local create_conv_data = {};
					create_conv_data.call_id = "create_conv";
					create_conv_json = kd.CJson.EnCode(create_conv_data);
					
					local ret = local_tconv.convCreate("vliour_release_5263938", local_tconv.TIMConvType.kTIMConv_C2C, create_conv_json);
					if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
						echo("KD_LOG:TIM create conv error code:"..ret);
					end--]]
					
					return;
				end
				
			elseif (t.call_id == "logout") then
				--登出回调
				if (code ~= local_tsdk.TIMErrCode.ERR_SUCC) then
					echo("KD_LOG:TIM logout err_code:"..code.." err_desc:"..desc);
					return;
				else	
					echo("KD_LOG:TIM logout success.");
				end
				
			elseif (t.call_id == "setConfig") then
				--关闭日志
				if (code ~= local_tsdk.TIMErrCode.ERR_SUCC) then
					echo("KD_LOG:TIM 关闭日志:"..code.." err_desc:"..desc);
					return;
				else
					echo("KD_LOG:TIM 关闭日志");
					
					--解析回调JSON
					local data = kd.CJson.DeCode(json_params);
					
					return;
				end
			elseif (t.call_id == "create_conv") then
				--创建会话回调
				if (code ~= local_tsdk.TIMErrCode.ERR_SUCC) then
					echo("KD_LOG:TIM create conv err_code:"..code.." err_desc:"..desc);
					return;
				else
					echo("KD_LOG:TIM create conv success.");
					
					--解析回调JSON
					local data = kd.CJson.DeCode(json_params);
					
					if t.call_name=="MessageList" then					--消息界面
						LayerManage.ChatLayer:create_conv(data);	
					elseif 	t.call_name=="Detail.create_conv" then	--详情界面
						DC:CallBack("Detail.create_conv",data)		
					elseif 	t.call_name=="MiYiXia.create_conv" then	--我的界面
						DC:CallBack("MiYiXia.create_conv",data)
					elseif 	t.call_name=="MessageListView.create_conv" then
						DC:CallBack("MessageListView.create_conv",data)
					elseif 	t.call_name=="GetOneVideoList.create_conv" then
						DC:CallBack("GetOneVideoList.create_conv",data)
					elseif 	t.call_name=="MeView.create_conv" then
						DC:CallBack("MeView.create_conv",data)
					end
					
					--发送信息
					
--[[				--构建user data
					local send_msg_data = {};
					send_msg_data.call_id = "send_msg";
					send_msg_json = kd.CJson.EnCode(send_msg_data);
					
					local json_msg = {};
					json_msg[local_tmsg.Elem.kTIMElemType] = local_tmsg.TIMElemType.kTIMElem_Text;
					json_msg[local_tmsg.TextElem.kTIMTextElemContent] = "sky test message!";
					local json_value_msg = {};
					json_value_msg[local_tmsg.Message.kTIMMsgSender] = "vliour_release_5263574";
					json_value_msg[local_tmsg.Message.kTIMMsgElemArray] ={};
					json_value_msg[local_tmsg.Message.kTIMMsgElemArray][1] = json_msg;
					
					local str_json_v = kd.CJson.EnCode(json_value_msg);
					
					local convid = t1[local_tconv.ConvInfo.kTIMConvId];
					local convtype = t1[local_tconv.ConvInfo.kTIMConvType];
					local ret = local_tmsg.msgSendNewMsg(convid, convtype, str_json_v, send_msg_json);
					if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
						echo("KD_LOG:TIM create send msg error code:"..ret);
					end--]]
					return;
				end
			elseif (t.call_id == "send_msg") then
				--发送新消息回调
				if (code ~= local_tsdk.TIMErrCode.ERR_SUCC) then
					echo("KD_LOG:TIM send new msg err_code:"..code.." err_desc:"..desc);
					return;
				else
					echo("KD_LOG:TIM send new msg success.");
					
					--解析回调JSON
										--解析回调JSON
					local t1 = kd.CJson.DeCode(json_params);
					
					-- 系统消息
					if t1.message_conv_type==local_tconv.TIMConvType.kTIMConv_System then

					elseif t1.message_conv_type==local_tconv.TIMConvType.kTIMConv_Group then		-- 群组会话
						local message_elem_array = t1.message_elem_array;
						local message_elem = message_elem_array[1];
						
						if message_elem.elem_type==local_tmsg.TIMElemType.kTIMElem_Text then	-- 文本消息
							local data = {
								level=self.m_UserData.level,
								queenId=self.m_UserData.queenId,
								nobleId=self.m_UserData.nobleId,
								nickname=self.m_UserData.nickname,
								msg=message_elem.text_elem_content};
							
							DC:CallBack("MulPartyChatTab.InsertNewText1",data)
							DC:CallBack("MulPartyVideoChat.InsertNewText1",data)
						elseif message_elem.elem_type==local_tmsg.TIMElemType.kTIMElem_Custom then		--自定义消息
							local cusdatajson = KDGame.Aes128DecodeStr(message_elem.custom_elem_data,"%ObymLoJ^tF(W2EM")
							local cusdata = kd.CJson.DeCode(cusdatajson);
							DC:CallBack("MulPartyChatTab.InsertNewText1",cusdata.data)
							DC:CallBack("MulPartyVideoChat.InsertNewText1",cusdata.data)
						end
						

					elseif t1.message_conv_type==local_tconv.TIMConvType.kTIMConv_C2C  then		-- 个人会话
--[[						----消息
						if self.MessageListLayer:IsVisible() then
							self.MessageListLayer:send_msg(t1);
						end--]]
						
						DC:CallBack("AChat.send_msg",t1);
					end
					
					--echo("KD_LOG: send new msg, ret json:"..json_params);
					
--[[					--测试加群
					--构建user data
					local join_group_data = {};
					join_group_data.call_id = "join_group";
					join_group_json = kd.CJson.EnCode(join_group_data);
					
					local ret = local_tgroup.groupJoin("@TGS#3RLRSBEGS", "teste join group!", join_group_json);
					if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
						echo("KD_LOG:TIM create join group error code:"..ret);
					end--]]
					return;
				end
			elseif (t.call_id == "join_group") then
				--发送新消息回调
				if (code ~= local_tsdk.TIMErrCode.ERR_SUCC) then
					echo("KD_LOG:TIM join group err_code:"..code.." err_desc:"..desc);
					return;
				else
					echo("KD_LOG:TIM join group msg success.");
					
					--解析回调JSON
					local t1 = kd.CJson.DeCode(json_params);
					--echo("KD_LOG: join group, ret json:"..json_params);
					
					
				end
			elseif (t.call_id == "convGetConvList") then		--获取消息列表
				if (code ~= local_tsdk.TIMErrCode.ERR_SUCC) then
					echo("KD_LOG:TIM 获取消息列表 err_code:"..code.." err_desc:"..desc);
					return;
				else
					echo("KD_LOG:TIM 获取消息列表 success.");
					
					--解析回调JSON
				--	echo("KD_LOG: 获取消息列表, ret json:"..json_params);
					local data = kd.CJson.DeCode(json_params);
--					LayerManage.ChatLayer:convGetConvList(data);
					DC:CallBack("MessageListView.convGetConvList",data);
					return;
				end
			elseif (t.call_id == "profileGetUserProfileList") then		--获取指定用户列表的个人资料
				if (code ~= local_tsdk.TIMErrCode.ERR_SUCC) then
					echo("KD_LOG:TIM 获取指定用户列表的个人资料 err_code:"..code.." err_desc:"..desc);
					return;
				else
					echo("KD_LOG:TIM 获取指定用户列表的个人资料 success.");
					
					--解析回调JSON
					--echo("KD_LOG: 获取指定用户列表的个人资料, ret json:"..json_params);
					local data = kd.CJson.DeCode(json_params);
					LayerManage.ChatLayer:profileGetUserProfileList(data);
					return;
				end	
			elseif (t.call_id == "msgGetMsgList") then		--获取历史消息
				if (code ~= local_tsdk.TIMErrCode.ERR_SUCC) then
					echo("KD_LOG:TIM 获取指定会话的消息列表 err_code:"..code.." err_desc:"..desc);
					return;
				else
					echo("KD_LOG:TIM 获取指定会话的消息列表 success.");
					
					--解析回调JSON
					echo("KD_LOG: 获取指定会话的消息列表, ret json:"..json_params);
					local data = kd.CJson.DeCode(json_params);
					
					if t.call_name=="MessageListView" then
						DC:CallBack("MessageListView.msgGetMsgList",data);
					elseif 	t.call_name=="MiYiXia" or t.call_name=="PlayVideo" or t.call_name== "Detail"then
						DC:CallBack("AChat.SetData",data)
					elseif 	t.call_name=="MeView" then
						DC:CallBack("MeView.msgGetMsgList",data);
					elseif 	t.call_name=="GetOneVideoList" then
						DC:CallBack("GetOneVideoList.msgGetMsgList",data);
					end
					return;
				end
			elseif (t.call_id == "msgReportReaded") then		--消息上报已读
				if (code ~= local_tsdk.TIMErrCode.ERR_SUCC) then
					echo("KD_LOG:TIM 消息上报已读 err_code:"..code.." err_desc:"..desc);
					return;
				else
					echo("KD_LOG:TIM 消息上报已读 success.");
					
					--解析回调JSON
					--echo("KD_LOG: 消息上报已读, ret json:"..json_params);
					local data = kd.CJson.DeCode(json_params);
					
					--获取消息列表
					self:GetConvList();
					return;
				end
				
				
			elseif (t.call_id == "msgDownloadElemToPath") then		--下载声音文件
				if (code ~= local_tsdk.TIMErrCode.ERR_SUCC) then
					echo("KD_LOG:TIM 下载声音文件 err_code:"..code.." err_desc:"..desc);
					return;
				else
					echo("KD_LOG:TIM 下载声音文件 success.");
					
					--解析回调JSON
					--echo("KD_LOG: 获取指定会话的消息列表, ret json:"..json_params);
					local data = kd.CJson.DeCode(json_params);

					return;
				end	
			end
		end
	end;

	--新消息回调
	OnRecvNewMsg = function(--[[string]] json_msg_array)
		echo("KD_LOG:TIM backCall OnRecvNewMsg json_msg_array:"..json_msg_array);
		self:OnRecvNewMsg(json_msg_array)
	end;
	--消息已读回执回调
	OnMsgReadedReceipt = function(--[[string]] json_msg_readed_receipt_array)
		echo("KD_LOG:TIM backCall OnMsgReadedReceipt json_msg_readed_receipt_array:"..json_msg_readed_receipt_array);
	end;
	--接收的消息被撤回回调
	OnMsgRevoke = function(--[[string]] json_msg_locator_array)
		echo("KD_LOG:TIM backCall OnMsgRevoke json_msg_locator_array:"..json_msg_locator_array);
	end;
	--消息内元素相关文件上传进度回调
	OnMsgElemUploadProgress = function(--[[string]] json_msg, --[[int]] index, --[[int]] cur_size, --[[int]] total_size)
		echo("KD_LOG:TIM backCall OnMsgElemUploadProgress json_msg:"..json_msg.." index:"..index.." cur_size:"..cur_size.." total_size:"..total_size);
	end;
	--群事件回调
	OnGroupTipsEvent = function(--[[string]] json_group_tip_array)

	end;
	--会话事件回调
	OnConvEvent = function(--[[tim.Conv.TIMConvEvent]] conv_event, --[[string]] json_conv_array)
		--echo("KD_LOG:TIM backCall OnRecvNewMsg conv_event:"..conv_event.." json_conv_array:"..json_conv_array);
		local data = kd.CJson.DeCode(json_conv_array);
		local a = 0;
	end;
	--网络状态回调
	OnNetworkStatusListener = function(--[[tim.sdk.TIMNetworkStatus]] status, --[[tim.sdk.TIMError]] code, --[[string]] desc)
		echo("KD_LOG:TIM backCall OnRecvNewMsg status:"..status.." code"..code.." desc"..desc);
	end;
	--被踢下线回调
	OnKickedOffline = function()
		echo("KD_LOG:TIM backCall OnKickedOffline");
		--self:messagebox_default("TIM backCall OnKickedOffline");
		self:Exit();
		self:messagebox_default("账户在其他地方登陆，您被挤下线了");
	end;
	--用户票据过期回调
	OnUserSigExpired = function()
		echo("KD_LOG:TIM backCall OnUserSigExpired");
	end;
	--添加好友的回调
	OnAddFriend = function(--[[string]] json_identifier_array)
		echo("KD_LOG:TIM backCall OnAddFriend json_identifier_array:"..json_identifier_array);
	end;
	--删除好友的回调
	OnDeleteFriend = function(--[[string]] json_identifier_array)
		echo("KD_LOG:TIM backCall OnDeleteFriend json_identifier_array:"..json_identifier_array);
	end;
	--更新好友资料的回调
	OnUpdateFriendProfile = function(--[[string]] json_friend_profile_update_array)
		echo("KD_LOG:TIM backCall OnUpdateFriendProfile json_friend_profile_update_array:"..json_friend_profile_update_array);
	end;
	--好友添加请求的回调
	OnFriendAddRequest = function(--[[string]] json_friend_add_request_pendency_array)
		echo("KD_LOG:TIM backCall OnFriendAddRequest json_friend_profile_update_array:"..json_friend_add_request_pendency_array);
	end;
	--日志回调
	OnLog = function(--[[tim.sdk.TIMLogLevel]] level, --[[string]] log)
		--echo("K1D_LOG:TIM backCall OnLog level:"..level.." log:"..log);
	end;
	--消息更新回调
	OnMsgUpdate = function(--[[string]] json_msg_array)
		self:OnMsgUpdate(json_msg_array)
		echo("KD_LOG:TIM backCall OnMsgUpdate json_msg_array:"..json_msg_array);
	end;
}	

	return meTimBackCalls;
end
	
	
-- 获取消息列表
function A_ViewManager:GetConvList()
	local data = {};
	data.call_id = "convGetConvList";
	
	conv_json = kd.CJson.EnCode(data);
	
	--获取消息列表
	local ret = local_tconv.convGetConvList( conv_json);
	if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
		echo("KD_LOG:获取消息列表 error code:"..ret);
	end
end


-- 显示等待
-- @str 等待提示语
function A_ViewManager:ShowLoading(str)
	self.loading:Show(str)
	return self.loading
end
-- 隐藏等待
function A_ViewManager:HideLoading()
	self.loading:Hide()
end

-- 显示/隐藏 底部
function A_ViewManager:ShowButtom(bo)
	self.m_AHomePageButtom:SetVisible(bo);
end

-- 设置名称
function A_ViewManager:SetUserNickname(name)
	self.m_User.Nickname = name;
end

-- 设置性别
function A_ViewManager:SetUserSex(sex)
	self.m_User.Sex = sex;
end

-- 设置我的标签
function A_ViewManager:SetMyTags(data)
	self.m_dataMytags = data;
end

-- 获取我的标签
function A_ViewManager:GetMyTags()
	return self.m_dataMytags
end