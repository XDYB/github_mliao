--[[
	动态视图
--]]

c_Require("Script/MiLiao/ADynamic/ADynamicTitle.lua");								--	动态标题
c_Require("Script/MiLiao/ADynamic/ADynamicTopic.lua");								--	动态话题
c_Require("Script/MiLiao/ADynamic/ADynamicTopicDetaiHeader.lua");					--	动态话题详情头部
c_Require("Script/MiLiao/ADynamic/ADynamicTopicButton.lua");						--	动态发布按钮
c_Require("Script/MiLiao/ADynamic/ADynamicTopicDetaiPhoto.lua");					--	图片详情页面
c_Require("Script/MiLiao/ADynamic/ADynamicTopicDetaiVideo.lua");					--	视频详情页面
c_Require("Script/MiLiao/ADynamic/ADynamicTopicDetaiListFocus.lua");				--	滑动层视图(关注)
c_Require("Script/MiLiao/ADynamic/ADynamicTopicDetaiList.lua");						--	滑动层视图(广场)
c_Require("Script/MiLiao/ADynamic/ADynamicTopicDetaiListTopic.lua");				--	滑动层视图(话题1)
c_Require("Script/MiLiao/ADynamic/ADynamicTopicDetaiListTopic1.lua");				--	滑动层视图(话题2)
c_Require("Script/MiLiao/ADynamic/ADynamicTopicDetaiListTopic2.lua");				--	滑动层视图(话题3)
c_Require("Script/MiLiao/ADynamic/ADynamicSendTopic.lua");							--	滑动层视图(图片页面)
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

ADynamicView = kd.inherit(kd.Layer);

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM3           = 1001,			--	白色背景
	--/* Text ID */
	ID_TXT_NO0                   = 4001,			--	广场
	ID_TXT_NO1                   = 4002,			--	关注
};

--	X适配
local x_Ip = 0;
local x_Ipy = 0;
if gDef.IphoneXView then
	x_Ip = 100;
	x_Ipy = 280;
end

function ADynamicView:init()
	--	背景
	self.back = kd.class(BackUI,false,false);
	self.back:init();
	self:addChild(self.back);
	
	-- 暂无数据蒙版
	self.m_ABlank = kd.class(ABlank,false,false);
	self.m_ABlank:init();
	self:addChild(self.m_ABlank);
	local x,y = self.m_ABlank:GetPos();
	self.m_ABlank:SetPos(x,y+x_Ipy);
	self.m_ABlank:SetVisible(false);
	
	--	动态标题
	self.m_ADynamicTitle = kd.class(ADynamicTitle,false,false);
	self.m_ADynamicTitle:init();
	self:addChild(self.m_ADynamicTitle);
	
	--	滑动层视图(广场)
	self.m_ADynamicTopicDetaiList = kd.class(ADynamicTopicDetaiList,true,false);
	self.m_ADynamicTopicDetaiList:init();
	self.m_ADynamicTopicDetaiList:SetVisible(false);
	self:addChild(self.m_ADynamicTopicDetaiList);
	
	--	滑动层视图(关注)
	self.m_ADynamicTopicDetaiListFocus = kd.class(ADynamicTopicDetaiListFocus,true,false);
	self.m_ADynamicTopicDetaiListFocus:init();
	self:addChild(self.m_ADynamicTopicDetaiListFocus);
	self.m_ADynamicTopicDetaiListFocus:SetVisible(false);
	
	--	动态详情头部
	self.m_ADynamicTopicDetaiHeader = kd.class(ADynamicTopicDetaiHeader,false,true);
	self.m_ADynamicTopicDetaiHeader:init();
	self:addChild(self.m_ADynamicTopicDetaiHeader);	
	-- 设置显示隐藏的动画模式
	local x, y = self.m_ADynamicTopicDetaiHeader:GetPos();
	self.m_ADynamicTopicDetaiHeader:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	self.m_ADynamicTopicDetaiHeader:SetVisible(false);
	
	--	话题滑动层视图1
	self.m_ADynamicTopicDetaiListTopic = kd.class(ADynamicTopicDetaiListTopic,true,false);
	self.m_ADynamicTopicDetaiListTopic:init();
	self:addChild(self.m_ADynamicTopicDetaiListTopic);
	--	设置显示隐藏的动画模式
	local x, y = self.m_ADynamicTopicDetaiListTopic:GetPos();
	self.m_ADynamicTopicDetaiListTopic:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	self.m_ADynamicTopicDetaiListTopic:SetVisible(false);
	
	--	话题滑动层视图2
	self.m_ADynamicTopicDetaiListTopic1 = kd.class(ADynamicTopicDetaiListTopic1,true,false);
	self.m_ADynamicTopicDetaiListTopic1:init();
	self:addChild(self.m_ADynamicTopicDetaiListTopic1);
	--	设置显示隐藏的动画模式
	local x, y = self.m_ADynamicTopicDetaiListTopic1:GetPos();
	self.m_ADynamicTopicDetaiListTopic1:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	self.m_ADynamicTopicDetaiListTopic1:SetVisible(false);
	
	--	话题滑动层视图3
	self.m_ADynamicTopicDetaiListTopic2 = kd.class(ADynamicTopicDetaiListTopic2,true,false);
	self.m_ADynamicTopicDetaiListTopic2:init();
	self:addChild(self.m_ADynamicTopicDetaiListTopic2);
	--设置显示隐藏的动画模式
	local x, y = self.m_ADynamicTopicDetaiListTopic2:GetPos();
	self.m_ADynamicTopicDetaiListTopic2:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	self.m_ADynamicTopicDetaiListTopic2:SetVisible(false);
	
	-- 发布按钮
	self.m_ADynamicTopicButton = kd.class(ADynamicTopicButton,false,false);
	self.m_ADynamicTopicButton:init();
	self:addChild(self.m_ADynamicTopicButton);
	self.m_ADynamicTopicButton:SetZOrder(999);
	
	-- 初始化发布动态
	self.m_ADynamicSendTopic = kd.class(ADynamicSendTopic,false,true);
	self.m_ADynamicSendTopic:init(self);
	self:addChild(self.m_ADynamicSendTopic);
	-- 设置显示隐藏的动画模式
	local x, y = self.m_ADynamicSendTopic:GetPos();
	self.m_ADynamicSendTopic:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	self.m_ADynamicSendTopic:SetVisible(false);
	
	--	注册数据中心
	DC:RegisterCallBack("ADynamicView.Show",self,function(bool)
		self:SetVisible(bool)
	end)
	
	-- 当从动态切到其他底部时，初始化还原
	DC:RegisterCallBack("ADynamicView.Reset",self,function()
		self:Reset()
	end)
	
	--	更新拉黑数据
	DC:RegisterCallBack("ADynamicView.updateUserBlock",self,function(userID)
		self:updateUserBlock(userID);
	end)
	DC:RegisterCallBack("ADynamicView.NoupdateUserBlock",self,function(userID)
		self:NoupdateUserBlock(userID);
	end)
	
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function ADynamicView:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
	if visible == false then
		self:Reset();
	end
end

function ADynamicView:onGuiToucBackCall(id)
	
end

function ADynamicView:Reset()
	DC:CallBack("ADynamicTopicDetaiListFocus.Show",false);
	DC:CallBack("ADynamicTopicDetaiHeader.Show",false);
	DC:CallBack("ADynamicTopicDetaiList.Show",false);
end


-- (动态)更新拉黑信息,不确定在哪一类，只有全部遍历一次
function ADynamicView:updateUserBlock(userID)
	if userID == nil or userID == 0 then return;end
	DC:CallBack("ADynamicTopicDetaiList.DeleteUserID",userID);
	DC:CallBack("ADynamicTopicDetaiListTopic.DeleteUserID",userID);
	DC:CallBack("ADynamicTopicDetaiListTopic1.DeleteUserID",userID);
	DC:CallBack("ADynamicTopicDetaiListTopic2.DeleteUserID",userID);
	DC:CallBack("ADynamicTopicDetaiListTopic2.DeleteUserID",userID);
end

-- (动态)更新拉黑信息,不确定在哪一类，只有全部遍历一次
function ADynamicView:NoupdateUserBlock(userID)
	if userID == nil or userID == 0 then return;end
	DC:CallBack("ADynamicTopicDetaiList.InsertUser",userID);
	DC:CallBack("ADynamicTopicDetaiListTopic.InsertUser",userID);
	DC:CallBack("ADynamicTopicDetaiListTopic1.InsertUser",userID);
	DC:CallBack("ADynamicTopicDetaiListTopic2.InsertUser",userID);
	DC:CallBack("ADynamicTopicDetaiListTopic2.InsertUser",userID);
end
