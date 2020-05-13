--[[
	首页
--]]

c_Require("Script/MiLiao/AHomePage/AHomePageTitle.lua");							--	首页标题
c_Require("Script/MiLiao/AHomePage/AHomePageBanner.lua");							--	首页顶部图片
c_Require("Script/MiLiao/AHomePage/AHomePageMenu.lua");								--	首页选项

c_Require("Script/MiLiao/AHomePage/AHomeMenu/AHomePageMenu1.lua");					--	首页选项(外显,推荐)
c_Require("Script/MiLiao/AHomePage/AHomeMenu/AHomePageMenu2.lua");					--	首页选项(外显,关注)
c_Require("Script/MiLiao/AHomePage/AHomeMenu/AHomePageMenu3.lua");					--	首页选项(外显,新人)
c_Require("Script/MiLiao/AHomePage/AHomeMenu/AHomePageMenu4.lua");					--	首页选项(外显,唱歌)
c_Require("Script/MiLiao/AHomePage/AHomeMenu/AHomePageMenu5.lua");					--	首页选项(外显,跳舞)
c_Require("Script/MiLiao/AHomePage/AHomeMenu/AHomePageMenu6.lua");					--	首页选项(外显,颜值)

c_Require("Script/MiLiao/AHomePage/AHomePageList/AHomePageViewList.lua");			--	滑动层视图(推荐)
c_Require("Script/MiLiao/AHomePage/AHomePageList/AHomePageViewList1.lua");			--	滑动层视图(关注)
c_Require("Script/MiLiao/AHomePage/AHomePageList/AHomePageViewList3.lua");			--	滑动层视图(新人)
c_Require("Script/MiLiao/AHomePage/AHomePageList/AHomePageViewList4.lua");			--	滑动层视图(唱歌)
c_Require("Script/MiLiao/AHomePage/AHomePageList/AHomePageViewList5.lua");			--	滑动层视图(跳舞)
c_Require("Script/MiLiao/AHomePage/AHomePageList/AHomePageViewList6.lua");			--	滑动层视图(颜值)

c_Require("Script/MiLiao/AHomePage/AHomePageBigMap.lua");							--	大图
c_Require("Script/MiLiao/AHomePage/AHomePageFourMap.lua");							--	4张图
c_Require("Script/MiLiao/AHomePage/AHomePageBG1.lua");								--	网络连接图1
c_Require("Script/MiLiao/AHomePage/AHomePageBG2.lua");								--	网络连接图2

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AHomePageView = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

--	X适配
local x_Ip = 0;
if gDef.IphoneXView then
	x_Ip = 50;
end

function AHomePageView:init()
	
	--	背景
	self.back = kd.class(BackUI,false,false);
	self.back:init();
	self:addChild(self.back);


	--	滑动层视图(推荐)
	self.m_AHomePageViewList = kd.class(AHomePageViewList,true,false);
	self.m_AHomePageViewList:init();
	self:addChild(self.m_AHomePageViewList);
	self.m_AHomePageViewList:SetVisible(false);
	
	--	滑动层视图(关注)
	self.m_AHomePageViewList1 = kd.class(AHomePageViewList1,true,false);
	self.m_AHomePageViewList1:init();
	self:addChild(self.m_AHomePageViewList1);
	self.m_AHomePageViewList1:SetVisible(false);
	
	--	滑动层视图(新人)
	self.m_AHomePageViewList3 = kd.class(AHomePageViewList3,true,false);
	self.m_AHomePageViewList3:init();
	self:addChild(self.m_AHomePageViewList3);
	self.m_AHomePageViewList3:SetVisible(false);

	--	滑动层视图(唱歌)
	self.m_AHomePageViewList4 = kd.class(AHomePageViewList4,true,false);
	self.m_AHomePageViewList4:init();
	self:addChild(self.m_AHomePageViewList4);
	--	设置显示隐藏的动画模式
	self.m_AHomePageViewList4:SetVisible(false);	

	--	滑动层视图(跳舞)
	self.m_AHomePageViewList5 = kd.class(AHomePageViewList5,true,false);
	self.m_AHomePageViewList5:init();
	self:addChild(self.m_AHomePageViewList5);
	self.m_AHomePageViewList5:SetVisible(false);	

	--	滑动层视图(颜值)
	self.m_AHomePageViewList6 = kd.class(AHomePageViewList6,true,false);
	self.m_AHomePageViewList6:init();
	self:addChild(self.m_AHomePageViewList6);
	self.m_AHomePageViewList6:SetVisible(false);
	
	--	首页选项(关注)
	self.AHomePageMenu1 = kd.class(AHomePageMenu1,false,true);
	self.AHomePageMenu1:init();
	local x,y = self.AHomePageMenu1:GetPos();
	self.AHomePageMenu1:SetPos(x,y+220+x_Ip);
	self:addChild(self.AHomePageMenu1);
	--self.AHomePageMenu1:SetZOrder(1);
	self.AHomePageMenu1:SetVisible(false);
	
	--	首页选项(推荐)
	self.AHomePageMenu2 = kd.class(AHomePageMenu2,false,true);
	self.AHomePageMenu2:init();
	local x,y = self.AHomePageMenu2:GetPos();
	self.AHomePageMenu2:SetPos(x,y+220+x_Ip);
	self:addChild(self.AHomePageMenu2);
--	self.AHomePageMenu2:SetZOrder(1);
	self.AHomePageMenu2:SetVisible(false);
	
	--	首页选项(推荐)
	self.AHomePageMenu3 = kd.class(AHomePageMenu3,false,true);
	self.AHomePageMenu3:init();
	local x,y = self.AHomePageMenu3:GetPos();
	self.AHomePageMenu3:SetPos(x,y+220+x_Ip);
	self:addChild(self.AHomePageMenu3);
--	self.AHomePageMenu3:SetZOrder(1);
	self.AHomePageMenu3:SetVisible(false);
	
	--	首页选项(唱歌)
	self.AHomePageMenu4 = kd.class(AHomePageMenu4,false,true);
	self.AHomePageMenu4:init();
	local x,y = self.AHomePageMenu4:GetPos();
	self.AHomePageMenu4:SetPos(x,y+220+x_Ip);
	self:addChild(self.AHomePageMenu4);
--	self.AHomePageMenu4:SetZOrder(1);
	self.AHomePageMenu4:SetVisible(false);
	
	--	首页选项(唱歌)
	self.AHomePageMenu5 = kd.class(AHomePageMenu5,false,true);
	self.AHomePageMenu5:init();
	local x,y = self.AHomePageMenu5:GetPos();
	self.AHomePageMenu5:SetPos(x,y+220+x_Ip);
	self:addChild(self.AHomePageMenu5);
--	self.AHomePageMenu5:SetZOrder(1);
	self.AHomePageMenu5:SetVisible(false);
	
	--	首页选项(唱歌)
	self.AHomePageMenu6 = kd.class(AHomePageMenu6,false,true);
	self.AHomePageMenu6:init();
	local x,y = self.AHomePageMenu6:GetPos();
	self.AHomePageMenu6:SetPos(x,y+220+x_Ip);
	self:addChild(self.AHomePageMenu6);
--	self.AHomePageMenu6:SetZOrder(1);
	self.AHomePageMenu6:SetVisible(false);

	self.m_SearchView = kd.class(SearchView, false, true);
	self:addChild(self.m_SearchView);
	self.m_SearchView:SetVisible(false);
	self.m_SearchView:init(self);
	self.m_SearchView:SetVisible(false);
	self.m_SearchView:SetZOrder(2);
	
	--	首页标题
	self.m_AHomePageTitle = kd.class(AHomePageTitle,false,true);
	self.m_AHomePageTitle:init();
	self:addChild(self.m_AHomePageTitle);
	
	
	self.m_ViewList = {self.m_AHomePageViewList1,
						self.m_AHomePageViewList,
						self.m_AHomePageViewList3,
						self.m_AHomePageViewList4,
						self.m_AHomePageViewList5,
						self.m_AHomePageViewList6
						};
	
	self.m_MenuList = {self.AHomePageMenu1,
						self.AHomePageMenu2,
						self.AHomePageMenu3,
						self.AHomePageMenu4,
						self.AHomePageMenu5,
						self.AHomePageMenu6
						};	
	self.m_IsShow = {false,false,false,false,false,false};					
	
	--	初始为推荐
	self.m_index  = 2;		
	
	--	注册数据中心
	DC:FillData("AHomePageView.Index", self.m_index);
	
	--	注册数据中心
	DC:RegisterCallBack("AHomePageView.Show",self,function(bool)
		self:SetVisible(bool)
	end)
	
	-- post请求
	DC:RegisterCallBack("AHomePageView.OnRequestList",self,function(str,index)
		self:OnRequestList(str,index)
	end);
	
	-- 
	DC:RegisterCallBack("AHomePageView.HideMenu",self,function(index)
		if index >0 then
			self:HideMenu(index);
		end
	end);
	
	--	设置数据
	DC:RegisterCallBack("AHomePageView.SetData",self,function(data)
		if data ~= nil then
			self:SetData(data);
		end
	end)
	
	--	是否是悬浮状态
	DC:FillData("AHomePageView.nIsShow", self.m_IsShow);
	
	--	设置数据
	DC:RegisterCallBack("AHomePageView.IsSuspension",self,function()
		self:IsSuspension();
	end)
	
	--	设置数据
	DC:RegisterCallBack("AHomePageView.HideAllView",self,function()
		self:HideAllView();
	end)
	
	
	--	更新拉黑数据
	DC:RegisterCallBack("AHomePageView.updateUserBlock",self,function(userID)
		self:updateUserBlock(userID);
	end)
	DC:RegisterCallBack("AHomePageView.NoupdateUserBlock",self,function(userID)
		self:NoupdateUserBlock(userID);
	end)
	
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function AHomePageView:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end


function AHomePageView:onGuiToucBackCall(id)
	
end

--	请求 推荐列表
function AHomePageView:OnRequestList(str,index)
	-- 发包
	gSink:Post("michat/recommend-list",{page = 0,tag = str},function(data)
		DC:FillData("AHomePageView.Index",index);
		if data.Result then
			self:HideView(index);
			if index == 1 then
				DC:CallBack("AHomePageViewList1.Show",true);
				DC:CallBack("AHomePageViewList1.SetData",data);
			elseif index == 2 then
				DC:CallBack("AHomePageViewList.Show",true);
				DC:CallBack("AHomePageViewList.SetData",data);
			elseif index == 3 then
				DC:CallBack("AHomePageViewList3.Show",true);
				DC:CallBack("AHomePageViewList3.SetData",data);
			elseif index == 4 then
				DC:CallBack("AHomePageViewList4.Show",true);
				DC:CallBack("AHomePageViewList4.SetData",data);
			elseif index == 5 then
				DC:CallBack("AHomePageViewList5.Show",true);
				DC:CallBack("AHomePageViewList5.SetData",data);
			elseif index == 6 then
				DC:CallBack("AHomePageViewList6.Show",true);
				DC:CallBack("AHomePageViewList6.SetData",data);	
			end
		else

		end
	end,false);
end

function AHomePageView:HideView(index)
	for i = 1,6 do
		if self.m_ViewList[i] then
			if i ~= index then
				self.m_ViewList[i]:SetVisible(false);
			end
		end
	end
end

function AHomePageView:HideAllView()
	for i = 1,6 do
		if self.m_ViewList[i] then
			self.m_ViewList[i]:SetVisible(false);
			self.m_MenuList[i]:SetIsSwitch(false);
		end
	end
end


--	模板高度
function AHomePageView:GetWH()
	return ScreenW,1040;
end

--	浮动标题栏清理处理
function AHomePageView:HideMenu(index)
	for i = 1,6 do
		if self.m_MenuList[i] then
			if i== index then
				self.m_MenuList[i]:SetIsSwitch(true);
				self.m_MenuList[i]:SwitchTextColor(index);
			else
				self.m_MenuList[i]:SetIsSwitch(false);
			end
		end
	end
end

-- 是否是悬浮状态(6个悬浮)
function AHomePageView:IsSuspension()
	self.m_IsShow[1] = DC:GetData("AHomePageMenu1.IsSuspend");
	self.m_IsShow[2] = DC:GetData("AHomePageMenu2.IsSuspend");
	self.m_IsShow[3] = DC:GetData("AHomePageMenu3.IsSuspend");
	self.m_IsShow[4] = DC:GetData("AHomePageMenu4.IsSuspend");
	self.m_IsShow[5] = DC:GetData("AHomePageMenu5.IsSuspend");
	self.m_IsShow[6] = DC:GetData("AHomePageMenu6.IsSuspend");
	DC:FillData("AHomePageView.nIsShow", self.m_IsShow);
end

-- (首页)更新拉黑信息,不确定在哪一类，只有全部遍历一次
function AHomePageView:updateUserBlock(userID)
	if userID == nil or userID == 0 then return;end
	DC:CallBack("AHomePageViewList.DeleteUserID",userID);
	DC:CallBack("AHomePageViewList1.DeleteUserID",userID);
	DC:CallBack("AHomePageViewList3.DeleteUserID",userID);
	DC:CallBack("AHomePageViewList4.DeleteUserID",userID);
	DC:CallBack("AHomePageViewList5.DeleteUserID",userID);
	DC:CallBack("AHomePageViewList6.DeleteUserID",userID);
end


-- (主页)更新拉黑信息,不确定在哪一类，只有全部遍历一次
function AHomePageView:NoupdateUserBlock(userID)
	if userID == nil or userID == 0 then return;end
	DC:CallBack("AHomePageViewList1.InsertUser",userID);
	DC:CallBack("AHomePageViewList.InsertUser",userID);
	DC:CallBack("AHomePageViewList3.InsertUser",userID);
	DC:CallBack("AHomePageViewList4.InsertUser",userID);
	DC:CallBack("AHomePageViewList5.InsertUser",userID);
	DC:CallBack("AHomePageViewList6.InsertUser",userID);
end