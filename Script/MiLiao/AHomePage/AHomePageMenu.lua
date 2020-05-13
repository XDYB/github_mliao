--[[
	首页头部选项卡
--]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AHomePageMenu = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	--/* Image ID */
	ID_IMG_ML_MAIN_LM2            = 1001,	
	ID_IMG_ML_MAIN_LM5            = 1002,	--	关注图标
	ID_IMG_ML_MAIN_LM6            = 1003,	--	推荐图标
	ID_IMG_ML_MAIN_LM7            = 1004,	--	新人图标
	ID_IMG_ML_MAIN_LM8            = 1005,	--	唱歌图标
	ID_IMG_ML_MAIN_LM9            = 1006,	--	跳舞图标
	ID_IMG_ML_MAIN_LM10           = 1007,	--	颜值图标
	--/* Text ID */
	ID_TXT_NO0                    = 4001,	--	关注
	ID_TXT_NO1                    = 4002,	--	推荐
	ID_TXT_NO2                    = 4003,	--	新人
	ID_TXT_NO3                    = 4004,	--	唱歌
	ID_TXT_NO4                    = 4005,	--	跳舞
	ID_TXT_NO5                    = 4006,	--	颜值
};

-- 文字颜色
local colorTab = {  [1] = 0xffA082FD,		--	关注
					[2] = 0xffFDC331,		--	推荐
					[3] = 0xffFC86DF,		--	新人
					[4] = 0xff64CCFB,		--	唱歌
					[5] = 0xff4CEB7E,		--	跳舞
					[6] = 0xffFAADFF 		--	颜值
				};

function AHomePageMenu:init()

	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/SYFenQu.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	self.m_photo = {};			--	图标列表
	self.m_txt = {};			--	图标文字
	
	self.m_photo[1] = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM5);
	self.m_txt[1] = self.m_thView:GetText(idsw.ID_TXT_NO0);
	
	self.m_photo[2] = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM6);
	self.m_txt[2] = self.m_thView:GetText(idsw.ID_TXT_NO1);
	
	self.m_photo[3] = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM7);
	self.m_txt[3] = self.m_thView:GetText(idsw.ID_TXT_NO2);
	
	self.m_photo[4] = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM8);
	self.m_txt[4] = self.m_thView:GetText(idsw.ID_TXT_NO3);
	
	self.m_photo[5] = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM9);
	self.m_txt[5] = self.m_thView:GetText(idsw.ID_TXT_NO4);
	
	self.m_photo[6] = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM10);
	self.m_txt[6] = self.m_thView:GetText(idsw.ID_TXT_NO5);
end

function AHomePageMenu:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

--	点击事件
function AHomePageMenu:onGuiToucBackCall(id)
	
end

-- 切换文字颜色
function AHomePageMenu:SwitchColor(index)
	if index ==  nil or index < 0 then return;end
	for i = 1,6 do
		self.m_txt[i]:SetColor(0xff353235);
	end
	self.m_txt[index]:SetColor(colorTab[index]);
end

function AHomePageMenu:SetData(data)
	self:SwitchColor(data)
end

--	模板高度
function AHomePageMenu:GetWH()
	return ScreenW,240;
end