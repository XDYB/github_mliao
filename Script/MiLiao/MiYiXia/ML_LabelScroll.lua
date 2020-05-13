--[[

	标签滑动视图

--]]

c_Require("Script/MiLiao/MiYiXia/ML_Label.lua")
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

ML_LabelScroll = kd.inherit(kd.Layer);
local impl = ML_LabelScroll;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

function impl:init(height,tabText)
	self.m_ScrollView = kd.class(kd.ScrollViewEx, true, true);
	self:addChild(self.m_ScrollView);
	self.m_ScrollView:init(self, 0, height, ScreenW, 800, nil, true, false);
    self.m_ScrollView:SetRenderViewMaxH(ScreenW*2);
	
	self.m_numHeight = height;
	self.m_numInitx = 83;
	self.m_numDx = 30;	-- 横向间隙
	self.m_numDh = 30;	-- 纵向间隙
	
	self.m_tabObj = {};

	self:SetLabelData(tabText);
	
	self.m_ScrollView.OnClickedCall = function (this, x, y)
		self:ClickItem(x,y);
	end
	
	self:initView();
end

function impl:initView()
	for i=1,#self.m_tabObj do
		self.m_tabObj[i]:initView();
	end
end

-- 设置信息
function impl:SetLabelData(tabText)
	local widthSum1 = self.m_numInitx;
	local widthSum2 = self.m_numInitx;
	local dx = self.m_numDx
	for i=1,#tabText do
		local item = kd.class(ML_Label, false, false);
		item:init(tabText[i]);
		self.m_ScrollView:InsertItem(item);
		-- 设置位置
		local w,h = item:GetWH();
		if widthSum1 <= widthSum2 then
			item:SetPos(widthSum1,kd.MKCY(0));
			widthSum1 = widthSum1 + w + dx;
		else
			item:SetPos(widthSum2,kd.MKCY(h + self.m_numDh));
			widthSum2 = widthSum2 + w + self.m_numDx;
		end
		
		table.insert(self.m_tabObj, item);
	end
	local maxLen = widthSum1 > widthSum2 and widthSum1 or widthSum2;
	self.m_ScrollView:SetRenderViewMaxH(maxLen);
end

function impl:ClickItem(x,y)
	local px,py = self.m_ScrollView:GetViewPos();
	-- 转换坐标
	x = x + math.abs(px);
	y = y - py + ScreenH;
	for i=1,#self.m_tabObj do
		local item = self.m_tabObj[i];
		local w,h = item:GetWH();
		local ix,iy = item:GetPos();
		iy = iy - ScreenH;
		if ix <= x and x <= ix + w and iy <= y and y <= iy + h then
			item:SetLabelColor();
			local bo = DC:GetData("SetMiLabel.IsVisible");
			if bo then
				DC:CallBack("SetMiLabel.SetTabLabel",item);
			else
				DC:CallBack("MiSelectLabel.SetTabLabel",item);
			end
			break;
		end
	end
end

-- 设置选中
function impl:SetSelectOn(data)
	local tabItem = {};
	for i=1,#data do
		for j=1,#self.m_tabObj do
			local item = self.m_tabObj[j];
			local userid = item:GetId();
			if userid == data[i] then
				item:SetLabelColor();
				local bo = DC:GetData("SetMiLabel.IsVisible");
				if bo then
					DC:CallBack("SetMiLabel.SetTabLabel",item);
				else
					DC:CallBack("MiSelectLabel.SetTabLabel",item);
				end
				break;
			end
		end
	end
end
