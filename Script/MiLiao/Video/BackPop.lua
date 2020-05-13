--[[

	举报弹窗

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

BackPop = kd.inherit(kd.Layer);
local impl = BackPop;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM                  = 1001,
	ID_IMG_ML_TONGYONGTC5_LM           = 1002,
	ID_IMG_ML_TONGYONGTC_LM0           = 1003,
	--/* Text ID */
	ID_TXT_NO0                         = 4001,
	ID_TXT_NO1                         = 4002,
}
local isClick = false;
function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/TCJuBao1.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView); 
	end
	
	local bg = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM);
	bg:SetVisible(false);
	gDef:AddGuiBySpr(self,bg,idsw.ID_IMG_ML_MAIN_LM,ScreenH/2,ScreenW/2,ScreenH/2,ScreenW/2);
	
	local back = self.m_thView:GetSprite(idsw.ID_IMG_ML_TONGYONGTC_LM0);
	gDef:AddGuiBySpr(self,back,idsw.ID_IMG_ML_TONGYONGTC_LM0,0,0,0,0);
	
	local sprClose = self.m_thView:GetSprite(idsw.ID_IMG_ML_TONGYONGTC5_LM);
	gDef:AddGuiBySpr(self,sprClose,idsw.ID_IMG_ML_TONGYONGTC5_LM,0,0,0,0);
	
	
end

function impl:onGuiToucBackCall(id)
	-- 返回
	if id == idsw.ID_IMG_ML_TONGYONGTC5_LM or id == idsw.ID_IMG_ML_MAIN_LM then
		echo("返回");
		self:SetVisible(false);
	-- 举报
	elseif id == idsw.ID_IMG_ML_TONGYONGTC_LM0 then
		echo("举报");
		isClick = true;
		self:SetVisible(false);
		DC:CallBack("PlayView.ShowBackSelect", true);
	end
end

function impl:OnActionEnd()
	if (not self:IsVisible()) and (not isClick) then
		DC:CallBack("PlayView.ShowMask",false);
	end
	
	isClick = false;
end

