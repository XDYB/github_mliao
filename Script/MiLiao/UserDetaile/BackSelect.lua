--[[

举报选项

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

BackSelect = kd.inherit(kd.Layer);
local impl = BackSelect;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM                  = 1001,
	ID_IMG_ML_TONGYONGTC5_LM           = 1002,
	--/* Text ID */
	ID_TXT_NO0                         = 4001,
	ID_TXT_NO1                         = 4002,
	ID_TXT_NO2                         = 4003,
	ID_TXT_NO3                         = 4004,
	ID_TXT_NO4                         = 4005,
	ID_TXT_NO5                         = 4006,
	ID_TXT_NO6                         = 4007,
	ID_TXT_NO7                         = 4008,
}

function impl:init(key)
	self.m_keyView = key;
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/TCJuBao3.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	-- 隐藏自带的蒙版
	self.m_thView:SetVisible(idsw.ID_IMG_ML_MAIN_LM, false);
	-- 添加大的GUI
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM,0,0,0,0);
	
	local _,_,w,h = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_TONGYONGTC5_LM);
	-- 请选择举报类型
	gDef:AddGuiByID(self,idsw.ID_TXT_NO3,60,w/2,60,w/2);
	-- 举报
	gDef:AddGuiByID(self,idsw.ID_TXT_NO7,500,w/2,360,w/2);
	-- 取消
	gDef:AddGuiByID(self,idsw.ID_TXT_NO1,60,w/2,60,w/2);
	
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,0,ScreenH*2);
end

function impl:onGuiToucBackCall(id)
	-- 取消
	if id == idsw.ID_TXT_NO1 or id == idsw.ID_IMG_ML_MAIN_LM then
		echo("返回");
		DC:CallBack(self.m_keyView,false);
	-- 举报
	elseif id == idsw.ID_TXT_NO7 then
		echo("举报");
		DC:CallBack(self.m_keyView,false);
		if self.m_keyView == "ActionPop.Show" then
			DC:CallBack("DetaileView.report");
		elseif self.m_keyView == "PlayView.ShowBackSelect" then
			DC:CallBack("PlayView.report");
		end
	end
end

function impl:SetViewData()

end

function impl:OnActionEnd()
	if not self:IsVisible() then
		if self.m_keyView == "PlayView.ShowBackSelect" then
			DC:CallBack("PlayView.ShowBackPop", false);
		end
	end
end