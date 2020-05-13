--[[
	我的动态头部信息
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AMeDynamicTitle = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM            = 1001,	--	相机图片
	ID_IMG_ML_MAIN_LM3           = 1002,
	ID_IMG_ML_MAIN_LM4           = 1003,	--	返回按钮
	--/* Text ID */
	ID_TXT_NO0                   = 4001,	--	已发布
	ID_TXT_NO1                   = 4002,	--	审核中
}

function AMeDynamicTitle:init()
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/DTWoDe.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--	初始化默认是已发布模式
	self.m_stateIndex = 1;
	
	-- 已发布
	gDef:AddGuiByID(self,idsw.ID_TXT_NO0,100,100,60,100);

	-- 审核中
	self.m_ShenHe = self.m_thView:GetText(idsw.ID_TXT_NO1);
	local x,y = self.m_ShenHe:GetPos();
	self.m_ShenHe:SetPos(x,y-8);
	gDef:AddGuiBySpr(self,self.m_ShenHe,idsw.ID_TXT_NO1,100,80,60,140);
	
	-- 相机图片按钮
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM,20,20,20,20);
		
	-- 返回按钮
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM4,40,20,30,20);
	
	--	初始化时审核中
	self.m_stateIndex = 0;	
	
	--	注册数据中心
	DC:RegisterCallBack("AMeDynamicTitle.Show",self,function(bool)
		self:SetVisible(bool);
	end);
	
	DC:RegisterCallBack("AMeDynamicTitle.SetTextScale",self,function(data)
		self:SetTextScale(data);
	end);
	
	DC:FillData("AMeDynamicTitle.Index",self.m_stateIndex);

	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function AMeDynamicTitle:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end


function AMeDynamicTitle:onGuiToucBackCall(id)
	-- 已发布
	if id == idsw.ID_TXT_NO0 then
		echo("已发布");
		self.m_stateIndex = 1;	
	-- 审核中
	elseif id == idsw.ID_TXT_NO1 then
		echo("审核中");
		self.m_stateIndex = 0;
	-- 相机图片按钮
	elseif id == idsw.ID_IMG_ML_MAIN_LM then
		echo("相机图片按钮");
		self.m_stateIndex = 2;
		DC:CallBack("AMeDynamicSendTopic.Show",true);
	-- 返回按钮
	elseif id == idsw.ID_IMG_ML_MAIN_LM4 then
		echo("返回按钮");
		self.m_stateIndex = 3;
		DC:CallBack("AMeDynamicView.Show",false);
		DC:CallBack("MyView.Show",true);
		self.m_thView:GetText(idsw.ID_TXT_NO0):SetScale(1,1)
		self.m_thView:GetText(idsw.ID_TXT_NO1):SetScale(1,1);
	end
	--	文字缩放切换
	if self.m_stateIndex <2 then
		DC:CallBack("AMeDynamicTitle.SetTextScale",self.m_stateIndex);
		DC:FillData("AMeDynamicTitle.Index",self.m_stateIndex);
		if self.m_stateIndex == 0 then
			DC:CallBack("AMeDynamicTopicDetaiList.OnRequestDynamiclist",self.m_stateIndex);	--	请求我的动态数据
			DC:CallBack("AMeDynamicTopicDetaiList1.Show",false);
		elseif self.m_stateIndex == 1 then
			DC:CallBack("AMeDynamicTopicDetaiList1.OnRequestDynamiclist",self.m_stateIndex);	--	请求我的动态数据
			DC:CallBack("AMeDynamicTopicDetaiList.Show",false);
		end
	end
end

function AMeDynamicTitle:SetTextScale(index)
	if index == nil then return ;end
	if index == 0 then
		self.m_thView:GetText(idsw.ID_TXT_NO0):SetScale(0.6,0.6);
		self.m_thView:GetText(idsw.ID_TXT_NO1):SetScale(1.6,1.6);
	elseif index == 1 then
		self.m_thView:GetText(idsw.ID_TXT_NO0):SetScale(1,1)
		self.m_thView:GetText(idsw.ID_TXT_NO1):SetScale(1,1);
	end
end
