--[[
	用户帮助--我的标签
--]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

MyTagHelp = kd.inherit(kd.Layer);

-- 标题的高度
local headHeight = 0;
local DH = 45;
local DH2 = 35;
if gDef.IphoneXView then
	DH = 58;
end

local toubu = {
	--/* Image ID */
	ID_IMG_ML_MAIN_LM3           = 1001,
	ID_IMG_ML_MAIN_LM4           = 1002,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
}

function MyTagHelp:init()
	self.m_thViewBg = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/BeiJing.UI"), self);
	if (self.m_thViewBg) then
		self:addChild(self.m_thViewBg);
	end	
	
	self:SetHead();
	
	self.m_ScrollView = kd.class(kd.ScrollViewEx, true, true);
	self:addChild(self.m_ScrollView);
	self.m_ScrollView:init(self,0,headHeight,ScreenW,ScreenH,nil,false,false);
	local nMaxH = ScreenH;
    self.m_ScrollView:SetRenderViewMaxH(nMaxH);
	
	-- 滑动式图数据
	self.m_tabData = {};

	-- 新手玩转
	local spr1_1 = kd.class(kd.Sprite, gDef.GetResPath("ResAll/BiaoQianChangTu1.png"));
	local spr1_2 = kd.class(kd.Sprite, gDef.GetResPath("ResAll/BiaoQianChangTu2.png"));
	local spr1_3 = kd.class(kd.Sprite, gDef.GetResPath("ResAll/BiaoQianChangTu3.png"));
	table.insert(self.m_tabData, {spr1_1, spr1_2, spr1_3});
	
	-- 插入视图
	local H = 0;
	for i=1,#self.m_tabData do
		local tab = self.m_tabData[i];
		for i=1,#tab do
			local spr = tab[i];
			self.m_ScrollView:InsertItem(spr);
			local _,h = spr:GetTexWH();
			spr:SetPos(ScreenW/2,H + h/2);
			H = H + h;
		end
	end
	-- 设置滑动视图的高度
	self.m_ScrollView:SetRenderViewMaxH(H+headHeight);
	
	-- 添加设置标签按钮
	local spr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main3.png"), 3, 1517, 754, 192 );
	self:addChild(spr);
	local w,h = spr:GetWH();
	spr:SetPos(ScreenW/2,ScreenH-h/2);
	
	local gui = kd.class(kd.GuiObjectNew, self, 101, 0 , ScreenH-h, w, h, false, true);
    self:addChild(gui);
	
	self.m_SetMiLabel = kd.class(SetMiLabel, false, true);
	self.m_SetMiLabel:init();
	self:addChild(self.m_SetMiLabel);
	local x, y = self.m_SetMiLabel:GetPos();
	self.m_SetMiLabel:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x, y+ScreenH);
	self.m_SetMiLabel:SetVisible(false);
	
	DC:RegisterCallBack("MyTagHelp.Show",self,function (bo)
		self:SetVisible(bo);
		if bo then
			gSink:ShowButtom(false);
		end
	end);
end

function MyTagHelp:OnActionEnd()
	local bo = self:IsVisible();
	if not bo then
		self.m_ScrollView:BackToTop();
		if gSink.m_User then
			gSink:ShowButtom(true);
		end
		self.m_SetMiLabel:SetVisible(false);
	end
end

function MyTagHelp:onGuiToucBackCall(id)
	if id == toubu.ID_IMG_ML_MAIN_LM4 then
		echo("返回");
		self:SetVisible(false);
	elseif id == 101 then
		DC:CallBack("SetMiLabel.Show", true);
	end
end

function MyTagHelp:SetHead()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/TYTouBu.UI"), self);
	self:addChild(self.m_thView);
	self.m_thView:SetVisible(toubu.ID_IMG_ML_MAIN_LM3, false);
	self.m_txtTitle = self.m_thView:GetText(toubu.ID_TXT_NO0);
	self.m_txtTitle:SetString("我的标签");
	self.m_txtTitle:SetHAlignment(kd.TextHAlignment.CENTER);
	local gui = gDef:AddGuiByID(self,toubu.ID_IMG_ML_MAIN_LM4,40,80,40,40);
	gui.gui:SetZOrder(2);
	
	local _,_,w,h = self.m_thView:GetScaleRect(toubu.ID_IMG_ML_MAIN_LM3);
	local spr = self.m_thView:GetSprite(toubu.ID_IMG_ML_MAIN_LM3);
	local x,y = spr:GetPos();
	headHeight = y+h/2;
end