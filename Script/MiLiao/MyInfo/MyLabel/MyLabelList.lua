--[[
	我的标签列表，只做展示，3个图片组合
]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

MyLabelList = kd.inherit(kd.Layer);
local impl = MyLabelList;

function impl:init()
	
	-- 头部标题
	self.Title = kd.class(Title,false,true)
	self.Title:init(self)
	self.Title:SetTitle("我的标签")
	self:addChild(self.Title,1)
	self.Title.onTouchBegan = function (this,x,y)
		local h = this:GetH();
		if y > h then
			return false
		else
			return true
		end
	end	
	
	-- 索引值
	self.m_Index = {};
	
	self.Scroll = kd.class(ScrollEx,true,true)
	local headH = self.Title:GetH();
	self.Scroll:init(0,headH,ScreenW,ScreenH - headH)
	self:addChild(self.Scroll)
--	self.Scroll:ShowBorder()
	
	-- 获取模版
	self.Scroll.OnGetTemplate = function(this,index)
		return Photo;
	end
	-- 点击事件
	self.Scroll.OnClick = function(this,index)
		echo("==========index"..index)
	end

	local x,y = self:GetPos();
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
end

function impl:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
	DC:CallBack("AHomePageButtom.Show",not visible);
	if visible == false then
		self:Clear();
	end
end

function impl:OnActionEnd()
	if self:IsVisible() then
		self.m_data = {};
		self.Scroll:SetData(self.m_data);	
	end
	--[[if self:IsVisible() then
		print("打开")
	else
		if self.m_father:IsVisible() then
			DC:CallBack("AHomePageButtom.Show",true)
		end
		self:Clear()
	end--]]
end

function impl:Clear()
	self.Scroll:DelAll();
	self.m_Index = {};
end

--=======================================================================================================================

-- 图片
Photo = kd.inherit(kd.Layer);
function Photo:init()
	--加载UI
	self.m_thViewBg = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/BeiJing.UI"), self);
	if (self.m_thViewBg) then
		self:addChild(self.m_thViewBg);
	end
	
	self.spr1_1 = kd.class(kd.Sprite, gDef.GetResPath("ResAll/BiaoQianChangTu1.png"));
	self.m_thViewBg:addChild(self.spr1_1);
	self.spr1_1:SetVisible(true);
	
	self.spr1_2 = kd.class(kd.Sprite, gDef.GetResPath("ResAll/BiaoQianChangTu2.png"));
	self.m_thViewBg:addChild(self.spr1_2);
	self.spr1_2:SetVisible(true);
	
	self.spr1_3 = kd.class(kd.Sprite, gDef.GetResPath("ResAll/BiaoQianChangTu3.png"));
	self.m_thViewBg:addChild(self.spr1_3);
	self.spr1_3:SetVisible(true);
end

function Photo:SetVisible(bVisible)
	kd.Node.SetVisible(self, bVisible);	
end

function Photo:SetData()
	self:SetVisible(true);
end

function Photo:GetWH()
	return ScreenW,3350;
end

