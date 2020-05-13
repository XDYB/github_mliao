local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

Title = kd.inherit(kd.Layer);
local impl = Title;

local idws =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM3           = 1001,
	ID_IMG_ML_MAIN_LM4           = 1002,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
}


function impl:init(father)
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/TYTouBu.UI"), self);
	self:addChild(self.m_thView)
	
	self.m_txtTitle = self.m_thView:GetText(idws.ID_TXT_NO0);
	self.m_txtTitle:SetHAlignment(kd.TextHAlignment.CENTER);
	
	gDef:AddGuiByID(self,idws.ID_IMG_ML_MAIN_LM4,20,20,20,20)
	
	self.m_sprBG = self.m_thView:GetSprite(idws.ID_IMG_ML_MAIN_LM3);
	
	self.m_sprGoBack = self.m_thView:GetSprite(idws.ID_IMG_ML_MAIN_LM4);
	
	self.m_father = father;
	
end

function impl:GetGoBackPos()
	return self.m_sprGoBack:GetPos();
end

function impl:GetH()
	local x,y = self.m_sprBG:GetPos();
	return y*2
end

function impl:SetTitle(str)
	self.m_txtTitle:SetString(str)
end

function impl:onGuiToucBackCall(id)
	if id == idws.ID_IMG_ML_MAIN_LM4 then
		self.m_father:SetVisible(false);
	end
end