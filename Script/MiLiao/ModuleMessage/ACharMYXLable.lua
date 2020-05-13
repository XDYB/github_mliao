--[[

	标签 -- 三宫格 聊天顶部卡片标签

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

ACharMYXLable = kd.inherit(kd.Layer);

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw = {
	--/* Image ID */
	ID_IMG_ML_MAIN2_LM            = 1001,
	ID_IMG_ML_MAIN2_LM1           = 1002,
	ID_IMG_ML_MAIN2_LM2           = 1003,
}
local len = 0;
function ACharMYXLable:init(id)
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/MYXPiPeiLiaoTianBiaoQian.UI"), self);
	self:addChild(self.m_thView);
	local txt = ""
	if gDef.TagsList then
		txt = gDef.TagsList[id].Text
	end
	-- 左
	self.m_sprLeft = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM);
	-- 中
	self.m_sprCenter = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM1);
	-- 右
	self.m_sprRight = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM2);
	
	-- 创建文字
	self.m_txt = kd.class(kd.StaticText,29,"---",kd.TextHAlignment.CENTER,ScreenW/2,40);
	self:addChild(self.m_txt);
	self.m_txt:SetColor(0xffffffff);
	
	self:SetLabelData(txt);
end

-- 设置文本
function ACharMYXLable:SetLabelData(str)
	self.m_txt:SetString(str);
	len = gDef:GetTextLen(29,str);
	local wc,hc = self.m_sprCenter:GetWH();
	self.m_sprCenter:SetScale(len/wc, 1);
	-- 计算中间位置的坐标
	local x,y = self.m_sprLeft:GetPos();
	local wl,hl = self.m_sprLeft:GetWH();
	self.m_sprCenter:SetPos(x+wl/2+len/2, y);
	self.m_txt:SetPos(x+wl/2+len/2, y + 2);
	-- 设置右边位置的坐标
	local wr,hr = self.m_sprRight:GetWH();
	self.m_sprRight:SetPos(x+wl+len, y);
	
end

function ACharMYXLable:GetWH()
	local wl,hl = self.m_sprLeft:GetWH();
	local wr,hr = self.m_sprRight:GetWH();
	return wl+len+wr + 17, hr;
end

