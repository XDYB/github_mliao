--[[

	无网络

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

NoWifi = kd.inherit(kd.Layer);
local impl = NoWifi;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM3           = 1001,
	ID_IMG_ML_MAIN_LM4           = 1002,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
}
local isClick = false;
function impl:init()
	self.m_bg = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/ShiPinWuWangLuo.UI"), self);
	self:addChild(self.m_bg)
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/TYTouBu.UI"), self);
	self:addChild(self.m_thView)
	
	local spr = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM4);
	spr:SetTextureRect(1889, 498, 60, 60);
	
	self.m_thView:SetVisible(idsw.ID_IMG_ML_MAIN_LM3, false);
	self.m_thView:SetVisible(idsw.ID_TXT_NO0, false);
	
	gDef:AddGuiByID(self,idws.ID_IMG_ML_MAIN_LM4,40,80,40,40)
	
end

function impl:onGuiToucBackCall(id)
	-- 返回
	if id == idsw.ID_IMG_ML_MAIN_LM4 then
		DC:CallBack("PlayView.Show",false);
	end
end



