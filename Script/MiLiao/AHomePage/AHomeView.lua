--[[
	首页
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AHomeView = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

function AHomeView:init()
	-- 首页
	self.AHomePageView = kd.class(AHomePageView,false,true);
	self.AHomePageView:init();
	self:addChild(self.AHomePageView);
	self.AHomePageView:SetVisible(false);
	
	-- 动态页面
	self.ADynamicView = kd.class(ADynamicView,false,true);
	self.ADynamicView:init();
	self:addChild(self.ADynamicView);
	self.ADynamicView:SetVisible(false);
	
	--我的页面
	self.m_MyView = kd.class(MyView, false, true);
	self.m_MyView:init();
	self:addChild(self.m_MyView);
	self.m_MyView:SetVisible(false);
	

	--消息列表
	self.m_MessageListView = kd.class(MessageListView, false, true);
	self:addChild(self.m_MessageListView);
	self.m_MessageListView:init();
	self.m_MessageListView:SetVisible(false);

	self.m_MyView:SetVisible(false);

	DC:RegisterCallBack("AHomeView.Show",self,function(bool)
		self:SetVisible(bool)
		self.isFirstInstall =  gSink:IsFirstInstall()
		if self.isFirstInstall then
			--第一次安装才弹
			gSink.m_AHomePageMessageBox:SetVisible(true);		--	隐私弹窗
		end
	end)
end

function AHomeView:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end