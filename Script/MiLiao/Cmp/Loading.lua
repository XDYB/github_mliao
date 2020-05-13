-- ============================================================
-- 等待中
-- ============================================================
local kd = KDGame;
local gDef = gDef;
local gSink = G_ViewManager;

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

Loading = kd.inherit(kd.Layer);
local impl = Loading
local ids =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM           = 1001,
	--/* Text ID */
	ID_TXT_NO3                  = 4001,
}


function impl:init()
	self.mask = kd.class(MaskUI, false, true);
	self.mask:init();
	self:addChild(self.mask);
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/TSJiaZai.UI"), self);
	self:addChild(self.m_thView);
	self.spr = self.m_thView:GetSprite(ids.ID_IMG_ML_MAIN_LM)
	self.txt = self.m_thView:GetText(ids.ID_TXT_NO3)
	
	self.rot = 0
	self.ani = false
end

function impl:update(delta)
	if self.ani then
		self.rot = self.rot + 5
		self.spr:SetRotation(self.rot)
	end
end
function impl:Show(str)
	if str then
		self.txt:SetString(str)
		self.txt:SetVisible(true)
	else
		self.txt:SetVisible(false)
	end
	self.rot = 0
	self.ani = true
	self:SetVisible(true)
end
function impl:Hide()
	self.ani = false
	self.rot = 0
	self:SetVisible(false)
end