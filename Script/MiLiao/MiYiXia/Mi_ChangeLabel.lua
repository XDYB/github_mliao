--[[

更改属性

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

MI_ChangeLabel = kd.inherit(kd.Layer);
local impl = MI_ChangeLabel;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM                = 1001,
	ID_IMG_ML_MIYIXIATG_LM           = 1002,
	ID_IMG_ML_MIYIXIATU_LM           = 1003,
	--/* Button ID */
	ID_BTN_ML_MAIN2_LM               = 3001,
}

function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/MYXMeiYouHeShiTC.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	local btn = self.m_thView:GetButton(idsw.ID_BTN_ML_MAIN2_LM);
	btn:SetTitle("我要更换属性", 42, 0xffffffff);
	
	self:SetMaskClick();
	
	DC:RegisterCallBack("MI_ChangeLabel.Show",self,function(bo)
		self:SetVisible(bo);
		if bo then
			gSink:ShowMask(true);
			gSink:ShowMi(true);
		end
	end)
	
	self.m_boIsBack = false;
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,0,ScreenH*2);
end

function impl:onGuiToucBackCall(id)
	if id == idsw.ID_BTN_ML_MAIN2_LM then
		echo("更换属性");
		DC:FillData("MI_ChangeLabel.IsChange", true);
		DC:CallBack("Mi_MainLabel.Show",true);
	elseif id == idsw.ID_IMG_ML_MIYIXIATG_LM then
		echo("隐藏");
		self:SetVisible(false);
		self.m_boIsBack = true;
	end
end

function impl:OnActionEnd()
	local bo = self:IsVisible();
	if not bo then
		gSink:ShowMask(false);
		if self.m_boIsBack then
--			gSink:ShowMi(false);
			self.m_boIsBack = false;
		end
	end
end

-- 设置蒙版点击区域
function impl:SetMaskClick()
	local spr =self.m_thView:GetSprite(idsw.ID_IMG_ML_MIYIXIATG_LM);
	local x,y = spr:GetPos();
	local w,h = spr:GetWH();
	local gui = kd.class(kd.GuiObjectNew, self, idsw.ID_IMG_ML_MIYIXIATG_LM, 0,0,ScreenW,y-h/2, false, true);
	self:addChild(gui);
	gui:setDebugMode(true);
end

