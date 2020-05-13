--[[

	详情--没有数据

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

NoHaveData = kd.inherit(kd.Layer);
local impl = NoHaveData;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM1           = 1001,
	ID_IMG_ML_MAIN_LM2           = 1002,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
}

function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/KongBaiYe2.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	-- 图片
	self.m_sprBg = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM2);
	self.m_sprBg:SetVisible(false);
	
	-- 文字
	self.m_txt = self.m_thView:GetText(idsw.ID_TXT_NO0);
	self.m_txt:SetString("空空如也");
	local x,y = self.m_txt:GetPos();
	self.m_txt:SetPos(ScreenW/2, y);
	self.m_txt:SetHAlignment(kd.TextHAlignment.CENTER);
	
	self:initView();
end

function impl:initView()
	
end
