--[[

实名认证(认证通过)

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

RealNameAuthened = kd.inherit(kd.Layer);
local impl = RealNameAuthened;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM            = 1001,
	ID_IMG_ML_MAIN_LM1           = 1002,
	--/* Button ID */
	ID_BTN_ML_MAIN_LM            = 3001,
	--/* Text ID */
	ID_TXT_NO3                   = 4001,
	ID_TXT_NO4                   = 4002,
}

function impl:init(father)
	self.m_father = father
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/WoRenZhengFanKui.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM1,10,10,10,10)
	
	local x,y = self:GetPos();
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
end

function impl:onGuiToucBackCall(id)
	if id== idsw.ID_BTN_ML_MAIN_LM or id == idsw.ID_IMG_ML_MAIN_LM1 then
		self:SetVisible(false);
	end
end

function impl:SetVisible(bool)
	kd.Node.SetVisible(self,bool)
	if bool and self.m_thView then
		DC:CallBack("AHomePageButtom.Show",false)
	end
end

function impl:OnActionEnd()
	if self:IsVisible() then
		print("打开")
	else
		if self.m_father:IsVisible() then
			DC:CallBack("AHomePageButtom.Show",true)
		end
	end
end
