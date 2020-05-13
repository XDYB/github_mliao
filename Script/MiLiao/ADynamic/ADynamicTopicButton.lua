--[[
	动态详细信息头部
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

ADynamicTopicButton = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	ID_IMG_ML_MAIN_LM           = 1001,
};

function ADynamicTopicButton:init(index)
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/DTXuanFu.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end

	-- 发布按钮
	self.m_send = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM,0,0,0,0);
	
	-- 注册数据中心
	DC:RegisterCallBack("ADynamicTopicButton.Show",self,function(bool)
		self:SetVisible(bool);
	end);
	
	DC:RegisterCallBack("Add.Show",self,function(bool)
		self.m_send:SetVisible(bool);
	end);
end

function ADynamicTopicButton:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

function ADynamicTopicButton:onGuiToucBackCall(id)
	-- 发布按钮
	if id == idsw.ID_IMG_ML_MAIN_LM then
		echo("发布按钮");
		gSink:ShowButtom(false);
		DC:CallBack("Topic.Show",true);
		DC:CallBack("Add.Show",false);
	end
end