--[[
	暂无动态模板
--]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

ABlank = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
		--/* Image ID */
	ID_IMG_ML_MAIN_LM            = 1001,
	ID_IMG_ML_MAIN_LM1           = 1002,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
};

function ABlank:init()

	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/KongBaiYe.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	-- 文字
	self.m_Txt = self.m_thView:GetText(idsw.ID_TXT_NO0);
	self.m_Txt:SetHAlignment(kd.TextHAlignment.CENTER);
	local x,y = self.m_Txt:GetPos();
	self.m_Txt:SetPos(ScreenW//2,y);
	
	--	注册数据中心
	DC:RegisterCallBack("ABlank.Show",self,function(bool)
		self:SetVisible(bool)
	end);
	
		--	注册数据中心
	DC:RegisterCallBack("ABlank.SetTxt",self,function(data)
		if data ~= nil then
			self:SetTxt(data);
		end
	end);
end

function ABlank:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

--	UI
function ABlank:SetTxt(str)
	self.m_Txt:SetString(str);
end