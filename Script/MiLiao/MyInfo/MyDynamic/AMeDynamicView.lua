--[[
	动态视图
--]]
c_Require("Script/MiLiao/MyInfo/MyDynamic/AMeDynamicTitle.lua");					--	我的动态标题
c_Require("Script/MiLiao/MyInfo/MyDynamic/AMeDynamicTopicDetaiList.lua");			--	我的动态滑动层(审核中)
c_Require("Script/MiLiao/MyInfo/MyDynamic/AMeDynamicTopicDetaiList1.lua");			--	我的动态滑动层(已发布)
c_Require("Script/MiLiao/MyInfo/MyDynamic/AMeDynamicTopicDetaiPhoto.lua");			--	图片
c_Require("Script/MiLiao/MyInfo/MyDynamic/AMeDynamicTopicDetaiVideo.lua");			--	视频
c_Require("Script/MiLiao/MyInfo/MyDynamic/AMeDynamicSendTopic.lua");				--	发布

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AMeDynamicView = kd.inherit(kd.Layer);

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
if gDef.IphoneXView then
	x_Ip = 280;
end

function AMeDynamicView:init()
	--	背景
	self.back = kd.class(BackUI,false,false);
	self.back:init();
	self:addChild(self.back);
	
	-- 暂无数据蒙版
	self.m_ABlank = kd.class(ABlank,false,false);
	self.m_ABlank:init();
	self:addChild(self.m_ABlank);
	local x,y = self.m_ABlank:GetPos();
	self.m_ABlank:SetPos(x,y+x_Ip);
	self.m_ABlank:SetVisible(false);
	
	--	我的动态标题
	self.m_AMeDynamicTitle = kd.class(AMeDynamicTitle,false,false);
	self.m_AMeDynamicTitle:init();
	self:addChild(self.m_AMeDynamicTitle);
	
	--	滑动层视图(审核中)
	self.m_AMeDynamicTopicDetaiList = kd.class(AMeDynamicTopicDetaiList,true,false);
	self.m_AMeDynamicTopicDetaiList:init();
	--设置显示隐藏的动画模式
	local x, y = self.m_AMeDynamicTopicDetaiList:GetPos();
	self.m_AMeDynamicTopicDetaiList:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	self.m_AMeDynamicTopicDetaiList:SetVisible(false);
	self:addChild(self.m_AMeDynamicTopicDetaiList);

	--	滑动层视图(已发布)
	self.m_AMeDynamicTopicDetaiList1 = kd.class(AMeDynamicTopicDetaiList1,true,false);
	self.m_AMeDynamicTopicDetaiList1:init();
	--设置显示隐藏的动画模式
	local x, y = self.m_AMeDynamicTopicDetaiList1:GetPos();
	self.m_AMeDynamicTopicDetaiList1:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	self.m_AMeDynamicTopicDetaiList1:SetVisible(false);
	self:addChild(self.m_AMeDynamicTopicDetaiList1);
	
	--	动态发布(图片)
	self.m_AMeDynamicSendTopic = kd.class(AMeDynamicSendTopic,false,true);
	self.m_AMeDynamicSendTopic:init();
	self:addChild(self.m_AMeDynamicSendTopic);
	--设置显示隐藏的动画模式
	local x, y = self.m_AMeDynamicSendTopic:GetPos();
	self.m_AMeDynamicSendTopic:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	self.m_AMeDynamicSendTopic:SetVisible(false);

	--	注册数据中心
	DC:RegisterCallBack("AMeDynamicView.Show",self,function(bool)
		self:SetVisible(bool)
	end)

	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function AMeDynamicView:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
	DC:CallBack("AHomePageButtom.Show",not visible);	
end

function AMeDynamicView:onGuiToucBackCall(id)
	
end

-- 结束动画后执行页面清理
function AMeDynamicView:OnActionEnd()
	if self:IsVisible() then 
		local index = DC:GetData("AMeDynamicTitle.Index");
		DC:CallBack("AMeDynamicTitle.SetTextScale",index);					--	切换选项文字
		DC:CallBack("AMeDynamicTopicDetaiList.OnRequestDynamiclist",index);	--	请求我的动态数据
	else
		DC:FillData("AMeDynamicTitle.Index",0);
	end
end

