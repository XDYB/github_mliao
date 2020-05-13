
local kd = KDGame;
local gDef = gDef;
DiscoveryVersion = kd.inherit(kd.Layer);

local idsw =
{
	--/* Image ID */
	ID_IMG_OYJRGENGXINJIAZAIKUANG           = 1001,
	--/* Button ID */
	ID_BTN_OYJRGUANBI                       = 3001,
	ID_BTN_OYJRANNIU_ON                     = 3002,
	--/* Text ID */
	ID_TXT_NO5                              = 4001,
	ID_TXT_NO6                              = 4002,
	ID_TXT_NO7                              = 4003,
	ID_TXT_NO8                              = 4004,
	ID_TXT_NO9                              = 4005,
	ID_TXT_NO10                             = 4006, 
}

function DiscoveryVersion:init(father)
	self.m_father = father;
	
	self.m_Mask = kd.class(MaskUI,false,false)
	self.m_Mask:init(self);
	self:addChild(self.m_Mask);	
	
	self.m_thView = gDef.GetUpdateView(self,"version");
	
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--当前网络
	self.m_TxtWangLuo = self.m_thView:GetText(idsw.ID_TXT_NO6);
	self.addChild(self.m_TxtWangLuo);
	
	--当前版本
	self.m_TxtOldBanBen = self.m_thView:GetText(idsw.ID_TXT_NO7);
	self.addChild(self.m_TxtOldBanBen);
	
	--更新版本
	self.m_TxtNewBanBen = self.m_thView:GetText(idsw.ID_TXT_NO8);
	self.addChild(self.m_TxtNewBanBen);
	
	--版本大小
	self.m_TxtBanBenSize = self.m_thView:GetText(idsw.ID_TXT_NO9);
	self.addChild(self.m_TxtBanBenSize);
	
	local x,y = self.m_thView:GetRect(idsw.ID_TXT_NO10);
	
	--更新内容
	self.m_TxtContent = kd.class(kd.StaticText,38,"",kd.TextHAlignment.LEFT,kd.SceneSize.width-153*2, 300);
	self:addChild(self.m_TxtContent);
	self.m_TxtContent:SetPos(kd.SceneSize.width/2, y+150+30);
	self.m_TxtContent:SetColor(0xff555555);
	self.m_TxtContent:setLineHeight(60);

	self.m_BtnUpdate = self.m_thView:GetButton(idsw.ID_BTN_OYJRANNIU_ON);

end

function DiscoveryVersion:onGuiToucBackCall(--[[int]] id)
	if(id == idsw.ID_BTN_OYJRANNIU_ON) then
		self.m_father:DownLoad();
		self:SetVisible(false);
	elseif(id == idsw.ID_BTN_OYJRGUANBI) then
		self.m_father:CloseClient();
		self:SetVisible(false);	
	end
end

function DiscoveryVersion:SetInfo(currVersion,updateVersion,size,describe)
	local netType = kd.GetNetworkType();--(-1:错误 0:无连接或者未知连接 1:WIFI 2:3/4G,GPRS)
	local strNet = "wifi环境";
	if(netType~=1) then strNet = "非wifi环境"; end	
	self.m_TxtWangLuo:SetString("当前网络："..strNet);
	self.m_TxtOldBanBen:SetString("当前版本："..currVersion);
	self.m_TxtNewBanBen:SetString("更新版本："..updateVersion);
	self.m_TxtBanBenSize:SetString("版本大小："..size);
	self.m_TxtContent:SetString(describe);
	self.m_BtnUpdate:SetTitle("更新"..size);
	self:SetVisible(true);
end






