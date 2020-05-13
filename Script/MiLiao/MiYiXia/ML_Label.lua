--[[

	标签 -- 三宫格

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

ML_Label = kd.inherit(kd.Layer);
local impl = ML_Label;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw = {
	--/* Image ID */
	ID_IMG_ML_MAIN2_LM            = 1001,
	ID_IMG_ML_MAIN2_LM1           = 1002,
	ID_IMG_ML_MAIN2_LM2           = 1003,
}
local len = 0;
function impl:init(objData)
	self.m_data = objData;
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/MiYiXiaBiaoQian.UI"), self);
	self:addChild(self.m_thView);
	
	-- 左
	self.m_sprLeft = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM);
	-- 中
	self.m_sprCenter = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM1);
	-- 右
	self.m_sprRight = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM2);
	
	-- 创建文字
	self.m_txt = kd.class(kd.StaticText,35,"---",kd.TextHAlignment.CENTER,ScreenW/2,40);
	self:addChild(self.m_txt);
	self.m_txt:SetColor(0xffffffff);
	
	self:SetLabelData(self.m_data.Text);
	
	-- 是否是默认颜色
	self.m_isDefaultColor = true;
	
	self:initView();
end

function impl:GetLabelName()
	return self.m_data.Text;
end

function impl:initView()
	self.m_sprLeft:SetColor(0xff9575F2);
	self.m_sprCenter:SetColor(0xff9575F2);
	self.m_sprRight:SetColor(0xff9575F2);
	self.m_isDefaultColor = true;
end

-- 设置文本
function impl:SetLabelData(str)
	self.m_txt:SetString(str);
	len = gDef:GetTextLen(35,str);
	local wc,hc = self.m_sprCenter:GetWH();
	self.m_sprCenter:SetScale(len/wc, 1);
	-- 计算中间位置的坐标
	local x,y = self.m_sprLeft:GetPos();
	local wl,hl = self.m_sprLeft:GetWH();
	self.m_sprCenter:SetPos(x+wl/2+len/2, y);
	self.m_txt:SetPos(x+wl/2+len/2, y);
	-- 设置右边位置的坐标
	local wr,hr = self.m_sprRight:GetWH();
	self.m_sprRight:SetPos(x+wl+len, y);
	
end

function impl:GetWH()
	local wl,hl = self.m_sprLeft:GetWH();
	local wr,hr = self.m_sprRight:GetWH();
	return wl+len+wr, hr;
end

function impl:GetId()
	return self.m_data.Id;
end

function impl:SetLabelColor()
	
	-- 设置颜色
	if self.m_isDefaultColor then
		local color = {0xff75A4F2, 0xff8FDE83, 0xffF590FE, 0xff75E2F2, 0xffF2B075, 0xffF275A4, 0xffF27575, 0xffAC4BFF, 0xff62D3B7, 0xff5E75FF };
		local index = math.random(1,10);
		self.m_sprLeft:SetColor(color[index]);
		self.m_sprCenter:SetColor(color[index]);
		self.m_sprRight:SetColor(color[index]);
	else
		self.m_sprLeft:SetColor(0xff9575F2);
		self.m_sprCenter:SetColor(0xff9575F2);
		self.m_sprRight:SetColor(0xff9575F2);
	end
	
	self.m_isDefaultColor = not self.m_isDefaultColor;
	
end