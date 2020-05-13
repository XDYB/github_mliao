--[[
	动态头部话题
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

ADynamicTopic = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
		--/* Image ID */
	ID_IMG_ML_HUATIZIYUANM1_LM           = 1001,			--	萌新来袭
	ID_IMG_ML_HUATIZIYUANM2_LM           = 1002,			--	我有超能力
	ID_IMG_ML_HUATIZIYUANM3_LM           = 1003,			--	给我一首歌的时间
};

function ADynamicTopic:init()
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/DTHuaTi.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
		
	--	初始化默认是萌新模式
	self.m_stateStr = "";
	
	-- 萌新来袭
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_HUATIZIYUANM1_LM,10,10,10,10);

	-- 我有超能力
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_HUATIZIYUANM2_LM,10,10,10,10);
	
	-- 给我一首歌的时间
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_HUATIZIYUANM3_LM,10,10,10,10);
	
	--	注册数据中心
	DC:RegisterCallBack("ADynamicTopic.Show",self,function(bool)
		self:SetVisible(bool);
	end);
	
	DC:FillData("ADynamicTopic.StateStr",self.m_stateStr);
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function ADynamicTopic:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

function ADynamicTopic:onGuiToucBackCall(id)
	-- 萌新来袭
	if id == idsw.ID_IMG_ML_HUATIZIYUANM1_LM then
		self.m_stateStr = "#萌新来袭#";
		DC:CallBack("ADynamicTopicDetaiListTopic.Show",true);				--	显示话题滑动层
	-- 我有超能力
	elseif id == idsw.ID_IMG_ML_HUATIZIYUANM2_LM then
		self.m_stateStr = "#我有超能力#";
		DC:CallBack("ADynamicTopicDetaiListTopic1.Show",true);				--	显示话题滑动层
	-- 给我一首歌的时间	
	elseif id == idsw.ID_IMG_ML_HUATIZIYUANM3_LM then
		self.m_stateStr = "#给我一首歌的时间#";
		DC:CallBack("ADynamicTopicDetaiListTopic2.Show",true);				--	显示话题滑动层
	end
	DC:FillData("ADynamicTopic.StateStr",self.m_stateStr);
	--	显示对应的话题详情头部
	self:SetTextScale();
end

function ADynamicTopic:SetTextScale()
	DC:CallBack("ADynamicTopicButton.Show",false);						--	隐藏底部
	DC:CallBack("ADynamicTopicDetaiList.Show",false);					--	将广场滑动层隐藏
	DC:CallBack("ADynamicTopicDetaiHeader.Show",true);					--	显示话题图片
end