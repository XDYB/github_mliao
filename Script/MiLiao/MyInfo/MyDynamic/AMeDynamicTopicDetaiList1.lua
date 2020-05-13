--[[
	我的动态滑动层
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AMeDynamicTopicDetaiList1 = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

--	X适配
local x_Ip = 0;
if gDef.IphoneXView then
	x_Ip = 60;
end

function AMeDynamicTopicDetaiList1:init()
	
	--==========================================================		滑动层		========================================================
	local ScrollViewStart = 245;						--	滑动层起始高度
	local ScrollViewH = ScreenH-ScrollViewStart;		--	滑动层总高度
	self.m_nIndex = {};									--	初始化详情类型(1.图片，2.视频)
	self.m_data = {};
	self.m_page = 0;									--	初始化为第一页
	self.m_isend = false								-- 	是否结束
	--======================	滚动模板==================================
	-- 创建滚动
	self.Scroll = kd.class(ScrollEx,true,true)
	if self.Scroll then
		self.Scroll:init(0,ScrollViewStart+x_Ip,ScreenW,ScrollViewH-x_Ip*2);
		self:addChild(self.Scroll);
	end
	self.Scroll:SetOptimizeCount(4);
	-- 获取模版
	self.Scroll.OnGetTemplate = function(this,index)
		if self.m_nIndex[index] == 1 then									--	加载图片
			return AMeDynamicTopicDetaiPhoto
		elseif self.m_nIndex[index] == 2 then								--	加载视频
			return AMeDynamicTopicDetaiVideo
		end
	end
	-- 点击事件演示
	self.Scroll.OnClick = function(this,index)
		echo("我的动态信息点击事件演示");
		-- 发包(动态信息)
		if self.m_data[index] and self.m_data[index].Id  ~= nil then
			local data = {
					Data =  self.m_data;
					page = self.m_page;
					topic = "";
					index = index;
			};
			DC:CallBack("PlayView.ShowView",data);
		end
	end	
	
	--	下拉加载演示
	self.Scroll.OnDown = function(this)
		echo("==========下拉");
		self:Cls();
		local index = DC:GetData("AMeDynamicTitle.Index");
		DC:CallBack("AMeDynamicTopicDetaiList1.OnRequestDynamiclist",index);	--	请求我的动态数据
	end
	
	-- 上拉加载
	self.Scroll.OnUp = function(this)
		if self.m_isend == false then
			gSink:Post("michat/get-mydynamiclist",{page = self.m_page+1},function(data)
				if data.Result then
					self.m_page = self.m_page + 1;
					self.m_isend = data.IsEnd
					for i,v in ipairs(data.Data) do
						table.insert(self.m_data,v)
						self.Scroll:AppendData(v)
					end
					self.Scroll:Layout();
					self.Scroll:BackPos();
					if self.m_isend then
					--	self.Scroll:NoMore()  	--	加载等待(没资源)
					end
				end
			end,false)
		else
			this:BackPos()
		end
	end
	
	-- 下拉刷新									--	没资源
	self.Scroll:AddDownLoad(LoadUI);
	-- 上拉加载
	self.Scroll:AddUpLoad(LoadUI);
	
	--	注册数据中心
	DC:RegisterCallBack("AMeDynamicTopicDetaiList1.Show",self,function(bool)
		self:SetVisible(bool);
	end);
	
	-- 注册数据中心(我的动态数据)
	DC:RegisterCallBack("AMeDynamicTopicDetaiList1.OnRequestDynamiclist",self,function(index)
		self:OnRequestDynamiclist(index);
	end);
		
	-- 注册数据中心(Clear)
	DC:RegisterCallBack("AMeDynamicTopicDetaiList1.Cls",self,function()
		self:Cls();
	end);
	
	-- 注册数据中心
	DC:RegisterCallBack("AMeDynamicTopicDetaiList1.RemoveTable",self,function(index)
		if index ~= nil then 
			self:RemoveTable(index);
		end
	end);
	
	-- 切换话题详情头部图片
	DC:RegisterCallBack("AMeDynamicTopicDetaiList1.SetData",self,function(data)
		if data ~= nil then
			self:SetData(data);
		end
	end);
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function AMeDynamicTopicDetaiList1:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

function AMeDynamicTopicDetaiList1:onTouchBegan(x,y)
	echo("我的动态信息点击开始");
	return true;
end

function AMeDynamicTopicDetaiList1:onTouchMoved(x,y)
	echo("我的动态信息点击移动");
	return true;
end


function AMeDynamicTopicDetaiList1:onTouchEnded(x,y)
	echo("我的动态信息点击结束");
	return true;
end

function AMeDynamicTopicDetaiList1:onGuiToucBackCall(id)

end

--获取动态列表数据(我的动态请求数据)
function AMeDynamicTopicDetaiList1:OnRequestDynamiclist(index)
	-- 发包
	gSink:Post("michat/get-mydynamiclist",{page = 0,audit = index},function(data)
		if data.Result then
			DC:CallBack("AMeDynamicTopicDetaiList1.SetData",data);
		else
			
		end
	end,false);
end

--	列表数据
function AMeDynamicTopicDetaiList1:SetData(data)
	if data == nil then return;end
	DC:CallBack("AMeDynamicTopicDetaiList1.Show",true);
	DC:CallBack("ABlank.Show",false);
	self:Cls();
	-- 我的头像
	local AvatarFile = DC:GetData("MyView.self.m_AvatarFile");	
	local MeInfo =gSink:GetUser();
	for i= 1,#data.Data do
		data.Data[i].IsChecked = true;
		data.Data[i].AvatarFile = AvatarFile;
		data.Data[i].NickName = MeInfo.Nickname;
		data.Data[i].UserId = MeInfo.UserId;
		table.insert(self.m_data,data.Data[i]);	
	end
	self.Scroll:BackPos();		
	self:SetTemplate(data);							-- 从数据里区分出来是图片还是视频
	local mdata = self:copy(self.m_data);
	self.Scroll:SetData(mdata);
	if #self.m_data == 0 then
		DC:CallBack("ABlank.Show",true);
		DC:CallBack("ABlank.SetTxt","暂无动态");
	end
end

function AMeDynamicTopicDetaiList1:copy(orig)
	local copytb;
	if type(orig) == "table" then
		copytb = {};
		for orig_key, orig_value in next, orig, nil do
		copytb[copy(orig_key)] = copy(orig_value);
		end
		setmetatable(copytb, copy(getmetatable(orig)));
	else
		copytb = orig;
	end
	return copytb;
end



function AMeDynamicTopicDetaiList1:RemoveTable(index)
	for i = #self.m_data,1,-1 do
		if index == self.m_data[i].Id then
			table.remove(self.m_data,i);
			self.m_IsDel  = true;	--	是否执行了删除操作
		end
	end
end

--设置模板类型
function AMeDynamicTopicDetaiList1:SetTemplate(data)
	if data == nil then return;end
	local list = data.Data;
	for i= 1,#list do
		if list[i].Filetype == "image" then
			table.insert(self.m_nIndex,1);
		elseif list[i].Filetype == "video" then
			table.insert(self.m_nIndex,2);
		end
	end
end

function AMeDynamicTopicDetaiList1:Cls()
	self.Scroll:BackTop();	
	self.Scroll:DelAll();
	self.m_data = {};
	self.m_nIndex = {};
	self.m_page = 0 		-- 	当前页
	self.m_isend = false	-- 	是否结束
--	self.Scroll:Cls()
end
