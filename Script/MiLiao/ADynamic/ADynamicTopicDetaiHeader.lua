 --[[
	动态详细信息头部
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

ADynamicTopicDetaiHeader = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	
	--/* Image ID */
	ID_IMG_ML_HUATIZIYUANB1_LM           = 1001,		--	萌新图片
	ID_IMG_ML_MAIN3_LM                   = 1002,
	ID_IMG_ML_MAIN_LM                    = 1003,
	ID_IMG_ML_MAIN_LM1                   = 1004,		--	返回按钮
};

function ADynamicTopicDetaiHeader:init(index)
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/DTHuaTiXiangXiTouBu.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--	图片
	self.m_TopicPhoto = self.m_thView:GetSprite(idsw.ID_IMG_ML_HUATIZIYUANB1_LM);
	local w,h = self.m_TopicPhoto:GetWH();
	
	-- 返回按钮
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM1,30,60,30,20);
	
	--	注册数据中心
	DC:RegisterCallBack("ADynamicTopicDetaiHeader.Show",self,function(bool)
		self:SetVisible(bool);
	end);
	
	-- 切换话题详情头部图片
	DC:RegisterCallBack("ADynamicTopicDetaiHeader.SetChangeImg",self,function(index)
		if index ~= nil then
			self:SetChangeImg(index);
		end
	end);
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function ADynamicTopicDetaiHeader:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
	DC:CallBack("AHomePageButtom.Show",not visible);
end

function ADynamicTopicDetaiHeader:onTouchBegan(x,y)
	echo("动态话题头部点击开始");
	return true;
end

function ADynamicTopicDetaiHeader:onTouchMoved(x,y)
	echo("动态话题头部点击移动");
	return true;
end


function ADynamicTopicDetaiHeader:onTouchEnded(x,y)
	echo("动态话题头部点击结束");
	return true;
end

function ADynamicTopicDetaiHeader:onGuiToucBackCall(id)
	-- 返回按钮
	if id == idsw.ID_IMG_ML_MAIN_LM1 then
		echo("返回按钮");
		DC:CallBack("ADynamicTopicButton.Show",true);						--	显示底部	
		DC:CallBack("ADynamicTopicDetaiHeader.Show",false);					--	隐藏话题标题栏	
		DC:CallBack("ADynamicTopicDetaiListFocus.Show",false);				--	隐藏关注滑动层
		DC:CallBack("ADynamicTopicDetaiListTopic.Show",false);				--	隐藏话题滑动层
		DC:CallBack("ADynamicTopicDetaiListTopic1.Show",false);				--	隐藏话题滑动层
		DC:CallBack("ADynamicTopicDetaiListTopic2.Show",false);				--	隐藏话题滑动层

		DC:FillData("ADynamicTopic.StateStr","");							
		DC:CallBack("ADynamicTitle.SetTextScale",1);						--	请求广场数据
		DC:CallBack("ADynamicTopicDetaiList.Show",true);					--	显示广场界面
	end
end

--	切换话题详情头部
function ADynamicTopicDetaiHeader:SetChangeImg(index)
	if index == "#萌新来袭#" then								--	萌新来袭
		self.m_TopicPhoto:SetTexture(gDef.GetResPath("ResAll/HuaTiZiYuanB1.png"));
	elseif index == "#我有超能力#" then							--	我有超能力
		self.m_TopicPhoto:SetTexture(gDef.GetResPath("ResAll/HuaTiZiYuanB2.png"));
	elseif index == "#给我一首歌的时间#" then					--	给我一首歌的时间
		self.m_TopicPhoto:SetTexture(gDef.GetResPath("ResAll/HuaTiZiYuanB3.png"));
	end	
end