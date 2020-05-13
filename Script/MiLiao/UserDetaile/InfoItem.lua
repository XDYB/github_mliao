--[[

信息子项

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

InfoItem = kd.inherit(kd.Layer);
local impl = InfoItem;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN2_LM           = 1001,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
}

function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/XQXinXi.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	-- 图片
	self.m_sprBg = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM);
	-- 信息
	self.m_txtInfo = self.m_thView:GetText(idsw.ID_TXT_NO0);
	self.m_txtInfo:SetHAlignment(kd.TextHAlignment.CENTER);
	-- 调整位置
	local x,y = self.m_sprBg:GetPos();
	self.m_txtInfo:SetPos(x,y);
	
	self:initView();
end

function impl:initView()
	-- 设置颜色
	self.m_sprBg:SetColor(0xffFFA5D4);
	-- 设置文本
	self.m_txtInfo:SetString("---------");
end

function impl:SetViewData(data)
	-- 设置颜色
	self.m_sprBg:SetColor(0xffFFA5D4);
	-- 设置文本
	self.m_txtInfo:SetString(data);
end

function impl:GetWH()
	local _,_,w,h = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN2_LM);
	return w,h;
end