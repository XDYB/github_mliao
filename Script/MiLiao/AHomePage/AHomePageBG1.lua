--[[
	首页 数据加载中呢，请稍等一下...
--]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AHomePageBG1 = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
		--/* Image ID */
	ID_IMG_ML_MAIN_LM1           = 1001,
	ID_IMG_ML_MAIN_LM2           = 1002,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
};

local txt = {"暂无更多数据","数据加载中呢，请稍等一下..."}

function AHomePageBG1:init()
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/KongBaiYe2.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--	无加载图标
	self.m_photo1 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM1);
	local a,b = self.m_photo1:GetPos();
	self.m_photo1:SetPos(a,b-700);	
	self.m_photo1:SetVisible(false);
	
	--	加载中图标
	self.m_photo2 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM2);
	local x,y = self.m_photo2:GetPos();
	self.m_photo2:SetPos(x,y-700);
	self.m_photo1:SetVisible(true);
	
	-- 文字
	self.m_txt = self.m_thView:GetText(idsw.ID_TXT_NO0);
	self.m_txt:SetHAlignment(kd.TextHAlignment.CENTER);
	local x,y = self.m_txt:GetPos();
	self.m_txt:SetPos(ScreenW/2,y-700);
	self.m_txt:SetString(txt[2]);
end

function AHomePageBG1:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

function AHomePageBG1:onGuiToucBackCall(id)
	
end

function AHomePageBG1:SetData()
	
end

-- 根据网络状态显示不同的界面
function AHomePageBG1:SetData(index)
	if index == nil then return;end
	self.m_photo1:SetVisible(index == 1);	--	暂无更多数据
	self.m_photo2:SetVisible(index == 2);	--	数据加载中呢，请稍等一下...
	self.m_txt:SetString(txt[index]);		--	文字切换
end

--	模板高度
function AHomePageBG1:GetWH()
	return ScreenW,640;
end
