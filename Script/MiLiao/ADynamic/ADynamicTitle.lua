--[[
	动态头部信息
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

ADynamicTitle = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

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
	x_Ip = 30;
end

function ADynamicTitle:init()
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/DTTouBu.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--	初始化默认是广场模式
	local stateIndex = 1;
	
	-- 广场
	gDef:AddGuiByID(self,idsw.ID_TXT_NO0,50,70,50,70);

	-- 关注
	self.m_GuanZhu = self.m_thView:GetText(idsw.ID_TXT_NO1);
	local x,y = self.m_GuanZhu:GetPos();
	self.m_GuanZhu:SetPos(x,y-6);
	gDef:AddGuiBySpr(self,self.m_GuanZhu,idsw.ID_TXT_NO1,60,40,40,100);
	
	--	话题
	self.m_ADynamicTopic = kd.class(ADynamicTopic,false,false);
	self.m_ADynamicTopic:init();
	self:addChild(self.m_ADynamicTopic);	
	local x, y =  self.m_ADynamicTopic:GetPos();
	self.m_ADynamicTopic:SetPos(x,y+250+x_Ip);
	self.m_ADynamicTopic:SetVisible(true);
	
	--	注册数据中心
	DC:RegisterCallBack("ADynamicTitle.SetTextScale",self,function(data)
		self:SetTextScale(data);
	end);
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function ADynamicTitle:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

function ADynamicTitle:onGuiToucBackCall(id)
	-- 广场
	if id == idsw.ID_TXT_NO0 then
		echo("广场");
		stateIndex = 1;	
	-- 关注
	elseif id == idsw.ID_TXT_NO1 then
		echo("关注");
		stateIndex = 2;
	end
	--	文字缩放切换
	DC:CallBack("ADynamicTitle.SetTextScale",stateIndex);
end

function ADynamicTitle:SetTextScale(index)
	if index == nil then return ;end
	DC:CallBack("ADynamicTopic.Show",(index==1));						--	切换选项卡，来显示或因此动态话题
	if index == 2 then
		self.m_thView:GetText(idsw.ID_TXT_NO0):SetScale(0.6,0.6);
		self.m_thView:GetText(idsw.ID_TXT_NO1):SetScale(1.6,1.6);
	elseif index == 1 then
		self.m_thView:GetText(idsw.ID_TXT_NO0):SetScale(1,1)
		self.m_thView:GetText(idsw.ID_TXT_NO1):SetScale(1,1);
	end
	self:SwitchScrollEx(index);
end

--	切换两个滑动层
function ADynamicTitle:SwitchScrollEx(index)
	DC:CallBack("ADynamicTopicDetaiList.Show",(index == 1));
	DC:CallBack("ADynamicTopicDetaiListFocus.Show",(index == 2));
	DC:CallBack("ABlank.Show",false);
	if index == 1 then
		DC:CallBack("ADynamicTopicDetaiList.OnRequestDynamiclist");
	elseif index == 2 then
		DC:CallBack("ADynamicTopicDetaiListFocus.OnRequestLovelist");
	end
end