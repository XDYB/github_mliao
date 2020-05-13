--[[
	我的标签主页面
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

MyLabelView = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

function MyLabelView:init()
	
	--	背景
	self.back = kd.class(BackUI,false,false);
	self.back:init();
	self:addChild(self.back);
	
	-- 滑动层显示页面
	self.m_MyLabelList = kd.class(MyLabelList,false,true);
	self.m_MyLabelList:init();
	self:addChild(self.m_MyLabelList);	
	--设置显示隐藏的动画模式
	local x, y = self.m_MyLabelList:GetPos();
	self.m_MyLabelList:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	self.m_MyLabelList:SetVisible(true);
	
	-- 设置我的标签按钮
	--[[self.m_MyLabelButton = kd.class(MyLabelButton, false, true);
	self.m_MyLabelButton:init();
	self:addChild(self.m_MyLabelButton);
	self.m_MyLabelButton:SetVisible(true);--]]

	-- 我的标签
	self.m_SetMiLabel = kd.class(SetMiLabel, false, true);
	self.m_SetMiLabel:init(self);
	self:addChild(self.m_SetMiLabel);
	local x, y = self.m_SetMiLabel:GetPos();
	self.m_SetMiLabel:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x, y+ScreenH);
	self.m_SetMiLabel:SetVisible(false);

	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
	
	--	注册数据中心
	DC:RegisterCallBack("MyLabelView.Show",self,function(bool)
		self:SetVisible(bool)
	end)
end

function MyLabelView:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end
