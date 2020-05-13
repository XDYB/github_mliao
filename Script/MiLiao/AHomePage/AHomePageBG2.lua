--[[
	首页 网络加载失败图标
--]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AHomePageBG2 = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM3           = 1001,
	ID_IMG_ML_MAIN_LM4           = 1002,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
	ID_TXT_NO1                   = 4002,
};

function AHomePageBG2:init()
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/KongBaiYe3.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	 
	--	网络加载失败图标
	self.m_photo = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM3);
	local x,y = self.m_photo:GetPos();
	self.m_photo:SetPos(x,y-900);	

	local x,y = self.m_thView:GetText(idsw.ID_TXT_NO0):GetPos();
	self.m_thView:GetText(idsw.ID_TXT_NO0):SetPos(x,y-900);	
	
	local x,y = self.m_thView:GetText(idsw.ID_TXT_NO1):GetPos();
	self.m_thView:GetText(idsw.ID_TXT_NO1):SetPos(x,y-900);	

	-- 刷新按钮
	local x,y = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM4):GetPos();
	self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM4):SetPos(x,y-900);	
	self.m_gui = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM4,10,10,10,10);
	self.m_gui:SetPos(x,y-900);
end

function AHomePageBG2:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

function AHomePageBG2:onGuiToucBackCall(id)
	if id == idsw.ID_IMG_ML_MAIN_LM4 then
		echo("网络加载失败，重新加载");
		-- 刷新网络发包
		self:OnSendRequest();
	end
end

--	请求网路连接发包
function AHomePageBG2:OnSendRequest()
	echo("请求网路连接发包");
end

function AHomePageBG2:SetData(index)
	echo("请求网路连接发包");
end

--	模板高度
function AHomePageBG2:GetWH()
	return ScreenW,640;
end