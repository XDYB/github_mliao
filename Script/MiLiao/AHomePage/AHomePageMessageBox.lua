--[[
	首页隐私
--]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AHomePageMessageBox = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM                     = 1001,
	ID_IMG_ML_YINSITANCHUANG_LM           = 1002,
	ID_IMG_ML_MAIN3_LM                    = 1003,		--	同意
	ID_IMG_ML_MAIN3_LM1                   = 1004,		--	查看
};


function AHomePageMessageBox:init(father)
	
	self.m_thView1 = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/ZheZhao.UI"), self);
	if (self.m_thView1) then
		self:addChild(self.m_thView1);
	end
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/TCYinSiZhengCe.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--	同意
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM,10,10,10,10);
	
	-- 	查看
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM1,10,10,10,10);
	
	--	注册数据中心
	DC:RegisterCallBack("AHomePageMessageBox.Show",self,function(bool)
		self:SetVisible(bool)
	end);
	
end

function AHomePageMessageBox:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

function AHomePageMessageBox:onTouchBegan(x,y)
	echo("messageBox点击开始");
	return true;
end

function AHomePageMessageBox:onTouchMoved(x,y)
	echo("messageBox点击开始");
	return true;
end

function AHomePageMessageBox:onTouchEnded(x,y)
	echo("messageBox点击开始");
	return true;
end

--	UI
function AHomePageMessageBox:onGuiToucBackCall(id)
	if id == idsw.ID_IMG_ML_MAIN3_LM then				--	同意
		self:SetVisible(false);
	elseif id == idsw.ID_IMG_ML_MAIN3_LM1 then			--	查看
		gSink:ShowHtml("隐私政策",gDef.policy);
	end
end