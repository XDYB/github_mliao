--[[
	首页头部图标
--]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AHomePageBanner = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM2             = 1001,
	ID_IMG_ML_MAIN2_LM             = 1002,		--	咪一下设置
	ID_IMG_ML_BANNER1_LM           = 1003,		--	咪一下图标
	ID_IMG_ML_BANNER2_LM           = 1004,		--	用户协议图标
};

function AHomePageBanner:init()
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/SYBanner.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	--	咪一下图标
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_BANNER1_LM,10,10,10,10);
	
	--	咪一下设置
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN2_LM,10,10,10,10);
	
	-- 用户协议图标
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_BANNER2_LM,10,10,10,10);
end

function AHomePageBanner:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

--	UI
function AHomePageBanner:onGuiToucBackCall(id)
	if id == idsw.ID_IMG_ML_BANNER1_LM then				--	咪一下图标
		echo("咪一下图标");
		DC:CallBack("Mi_MainLabel.Show",true);
	elseif id == idsw.ID_IMG_ML_MAIN2_LM then			--	眯一下设置
		echo("眯一下设置");
		DC:CallBack("MiOneView.Show",true);
	elseif id == idsw.ID_IMG_ML_BANNER2_LM then			--	用户协议图标
		echo("用户协议图标");
		DC:FillData("ALogin.IsInHtml",false);
		gSink:ShowHtml("用户协议",gDef.agreement);
	end
end

function AHomePageBanner:SetData(data)

end

--	模板高度
function AHomePageBanner:GetWH()
	return ScreenW,360;
end