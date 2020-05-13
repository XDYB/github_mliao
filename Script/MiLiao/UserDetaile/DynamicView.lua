--[[

信息

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

DynamicView = kd.inherit(kd.Layer);
local impl = DynamicView;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

function impl:init(height)
	self.m_ScrollView = kd.class(kd.ScrollViewEx, true, true);
	self:addChild(self.m_ScrollView);
	self.m_ScrollView:init(self, 0, height, ScreenW, 800, nil, true, false);
    self.m_ScrollView:SetRenderViewMaxH(ScreenW*2);
	
	self.m_numHeight = height;
	self.m_numInitx = 58;
	self.m_numDx = 57

	self.m_tabItem = {};
	
	self:initView();
	
end

function impl:initView()
	
	for i=1,#self.m_tabItem do
		self.m_ScrollView:DeleteItem(self.m_tabItem[i]);
	end
	
	self.m_tabItem = {};
	self.m_ScrollView:SetRenderViewMaxH(ScreenW);
end

-- 设置信息
function impl:SetViewData(data)
	local width = 0; 
	local dx = self.m_numDx
	local url = "";
	local len = 0
	if data.PhotoList then
		len = #data.PhotoList;
	end
	for i=1,len do
		local item = kd.class(DynamicItem, false, false);
		item:init();
		item:SetViewData(gDef.domain..data.PhotoList[i]);
		self.m_ScrollView:InsertItem(item);
		table.insert(self.m_tabItem, item);
		local w,_ = item:GetWH();
		width = w;
		item:SetPos(self.m_numInitx + (w+dx)*(i-1),kd.MKCY(0));
	end
	
	self.m_ScrollView:SetRenderViewMaxH(self.m_numInitx + (width + dx)*len);
end



