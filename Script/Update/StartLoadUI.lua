--[[

加载界面

--]]
local kd = KDGame;
local gDef = gDef;
StartLoadUI = kd.inherit(kd.Layer);

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_JRLOGO1             = 1001,
	ID_IMG_JRSANJIAO           = 1002,
	ID_IMG_JRCBCBCB            = 1003,
	--/* Text ID */
	ID_TXT_NO0                 = 4001,
	ID_TXT_NO1                 = 4002,
}

function StartLoadUI:init(father)
	self.m_thView = gDef.GetUpdateView(self,"load");
	if (self.m_thView) then
		self:addChild(self.m_thView);		
	end
	
	--比例
	self.m_TxtBili =  self.m_thView:GetText(idsw.ID_TXT_NO1);
	if(self.m_TxtBili) then self.m_fPosX,self.m_fPosY = self.m_TxtBili:GetPos(); end
	--三角形
	self.m_sprSanJiao = self.m_thView:GetSprite(idsw.ID_IMG_JRSANJIAO);		
	self.m_sprLanTiao = self.m_thView:GetSprite(idsw.ID_IMG_JRCBCBCB);
	if(self.m_sprLanTiao) then self.m_sprLanTiao:SetVisible(false); end	
	
	self:SetJinDu(0);
	
	self.proOjb = {
		txtLoading = self.m_thView:GetText(idsw.ID_TXT_NO0),
		txtProcess = self.m_thView:GetText(idsw.ID_TXT_NO1),
		sprLine = self.m_thView:GetSprite(idsw.ID_IMG_JRCBCBCB),	
		sprSanjiao = self.m_thView:GetSprite(idsw.ID_IMG_JRSANJIAO),	
		SetVisible = function(this)
			this.txtLoading:SetVisible(false)
			this.txtProcess:SetVisible(false)
			this.sprLine:SetVisible(false)
			this.sprSanjiao:SetVisible(false)
		end
	}
	self.proOjb:SetVisible(false)

end
function StartLoadUI:ShowPro()
	self.proOjb:SetVisible(true)
end
function StartLoadUI:SetJinDu(nBiLi)
	local fPosX = ScreenW//2-420; 
	local fPosY = self.m_fPosY ;

	if(self.m_TxtBili) then
		self.m_TxtBili:SetString(nBiLi.."%");
		self.m_TxtBili:SetPos(fPosX+nBiLi*840/100,fPosY);
	end
	if(self.m_sprSanJiao) then self.m_sprSanJiao:SetPos(fPosX+nBiLi*840/100,fPosY+30); end
end
 --[[
function StartLoadUI:SetBJ(loadPhoto)
	if self.m_sprUrlImg then
		self:RemoveChild(self.m_sprUrlImg);
		self.m_sprUrlImg=nil;
	end
	if self.m_sprUrlImg==nil then
		self.m_sprUrlImg = kd.class(kd.AsyncSprite, loadPhoto);
		if(self.m_sprUrlImg) then
			self:addChild(self.m_sprUrlImg);
		end
	end
end

--]]
