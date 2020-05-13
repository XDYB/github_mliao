--[[

信息

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

InfoView = kd.inherit(kd.Layer);
local impl = InfoView;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

function impl:init(height,initx)
	self.m_ScrollView = kd.class(kd.ScrollViewEx, true, true);
	self:addChild(self.m_ScrollView);
	self.m_ScrollView:init(self, 0, height, ScreenW, 241, nil, true, false);
    self.m_ScrollView:SetRenderViewMaxH(ScreenW*2);
	
	self.m_numHeight = height;
	self.m_numInitx = initx;
	self.m_numDx = 58
	self.m_numMaxItem = 0;

	-- 个人信息
	self.m_tabInfo = {};
	-- 个性特质
	self.m_tabLabel = {};
end

function impl:initView()
	self.m_numMaxItem = 0;
	
	-- 删除个人信息
	for i=1,#self.m_tabInfo do
		self.m_ScrollView:DeleteItem(self.m_tabInfo[i]);
	end
	self.m_tabInfo = {};
	-- 标签信息
	for i=1,#self.m_tabLabel do
		self.m_ScrollView:DeleteItem(self.m_tabLabel[i]);
	end
	self.m_tabInfo = {};
	
	self.m_ScrollView:SetRenderViewMaxH(ScreenW);
end

-- 设置信息
function impl:SetUserInfo(data)
	local width = 0;
	local dx = self.m_numDx
	local info_data = {"身高:"..data.Height.."cm", "体重:"..data.Weight.."kg", "城市:"..data.City, "星座:"..data.Constellation,}
	for i=1,#info_data do
		local item = kd.class(InfoItem, false, false);
		item:init();
		self.m_ScrollView:InsertItem(item);
		item:SetViewData(info_data[i]);
		local w,_ = item:GetWH();
		width = w;
		item:SetPos(self.m_numInitx + (w+dx)*(i-1),kd.MKCY(0));
		table.insert(self.m_tabInfo, item);
	end
	local len = #info_data;
	self.m_numMaxItem = len > self.m_numMaxItem and len or self.m_numMaxItem;
	self.m_ScrollView:SetRenderViewMaxH(self.m_numInitx + (width + dx)*self.m_numMaxItem);
end

-- 设置标签
function impl:SetLable(data)
	local width = 0;
	local dx = self.m_numDx
	for i=1,#data do
		local item = kd.class(InfoItem, false, false);
		item:init();
		self.m_ScrollView:InsertItem(item);
		item:SetViewData(gDef.TagsList[data[i]].Text);
		local w,h = item:GetWH();
		width = w;
		item:SetPos(self.m_numInitx + (w+dx)*(i-1),kd.MKCY(h + 40));
		table.insert(self.m_tabLabel, item);
	end
	if data then
		local len = #data;
		self.m_numMaxItem = len > self.m_numMaxItem and len or self.m_numMaxItem;
		self.m_ScrollView:SetRenderViewMaxH(self.m_numInitx + (width + dx)*self.m_numMaxItem);
	end
end

function impl:SetViewData(data)
	self:SetUserInfo(data);
	if data.TagsList and type(data.TagsList) == "table" then
		self:SetLable(data.TagsList);
	end
end
