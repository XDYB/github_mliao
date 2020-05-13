--[[
	动态滑动层(话题数据)
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

ADynamicTopicDetaiListTopic = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

--	X适配
local x_Ip = 0;
local x_Ipy = 0;
if gDef.IphoneXView then
	x_Ip = 10;
	x_Ipy = 100;
end

function ADynamicTopicDetaiListTopic:init()
	
	--==========================================================		滑动层		========================================================
	
	local ScrollViewStart = 525;						--	滑动层起始高度
	local ScrollViewH = ScreenH-ScrollViewStart;		--	滑动层总高度
	self.m_nIndex = {};									--	初始化详情选择
	self.m_data = {};
	self.m_page = 0 ;									-- 	当前页
	self.m_isend = false;								-- 	是否结束
	self.m_topic = "";
	self.m_DelData = {};														--	被删除的数据
	self.m_Moban = {};															--	被删除的模板值
	self.DelData = {};
	--==========================================================		滚动模板		=======================================================
	-- 创建滚动
	self.Scroll = kd.class(ScrollEx,true,true)
	if self.Scroll then
		self.Scroll:init(0,ScrollViewStart-x_Ip,ScreenW,ScrollViewH-x_Ipy);
		self:addChild(self.Scroll);
	end
	self.Scroll:SetOptimizeCount(4);
	-- 获取模版
	self.Scroll.OnGetTemplate = function(this,index)
		if self.m_nIndex[index] == 1 then									--	加载图片
			return ADynamicTopicDetaiPhoto
		elseif self.m_nIndex[index] == 2 then								--	加载视频
			return ADynamicTopicDetaiVideo
		end
	end
	-- 点击事件演示
	self.Scroll.OnClick = function(this,index)
		echo("动态话题数据点击事件演示");
		-- 发包(动态信息)
		if self.m_data[index] and self.m_data[index].Id  ~= nil then
			local data = {
					Data =  self.m_data;
					page = self.m_page;
					topic = self.m_topic;
					index = index;
			};
			DC:CallBack("PlayView.ShowView",data);
		end
	end
	
	-- 下拉刷新演示
	self.Scroll.OnDown = function(this)
		echo("==========下拉");
		self:Cls();
		local str = DC:GetData("ADynamicTopic.StateStr");
		self.m_topic = str;
		DC:CallBack("ADynamicTopicDetaiListTopic.OnRequestTopicList",str);
	end
	
	-- 上拉加载演示
	self.Scroll.OnUp = function(this)
		local str = DC:GetData("ADynamicTopic.StateStr");
		if self.m_isend == false then
			self.m_topic = str;
			gSink:Post("michat/get-dynamiclist",{page = self.m_page+1,topic = str},function(data)
				if data.Result then
					if #data.Data>0 then
						self.m_page = self.m_page + 1;
					end
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
			end,false);
		else
			this:BackPos();
		end
	end
	
	-- 下拉刷新									--	没资源
	self.Scroll:AddDownLoad(LoadUI)
	-- 上拉加载
	self.Scroll:AddUpLoad(LoadUI)
	
	--	注册数据中心
	DC:RegisterCallBack("ADynamicTopicDetaiListTopic.Show",self,function(bool)
		self:SetVisible(bool);
	end);
	
	-- 注册数据中心(话题数据)
	DC:RegisterCallBack("ADynamicTopicDetaiListTopic.OnRequestTopicList",self,function(str)
		if str ~= nil then
			self:OnRequestTopicList(str);
		end
	end);
	
	-- 切换话题详情头部图片
	DC:RegisterCallBack("ADynamicTopicDetaiListTopic.SetData",self,function(data)
		if data ~= nil then
			self:SetData(data);
		end
	end);
	
	-- 实时更新点赞
	DC:RegisterCallBack("ADynamicTopicDetaiListTopic.updateIndex",self,function(data)
		if data ~= nil then
			self:updateIndex(data);
		end
	end);
	
	-- 实时更新拉黑数据
	DC:RegisterCallBack("ADynamicTopicDetaiListTopic.DeleteUserID",self,function(userID)
		if userID ~= nil then
			self:DeleteUserID(userID);
		end
	end);
	
	DC:RegisterCallBack("ADynamicTopicDetaiListTopic.InsertUser",self,function(userID)
		if userID ~= nil then
			self:InsertUser(userID);
		end
	end);
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function ADynamicTopicDetaiListTopic:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

-- 结束动画后执行页面清理
function ADynamicTopicDetaiListTopic:OnActionEnd()
	if self:IsVisible() then 
		local index = DC:GetData("ADynamicTopic.StateStr");
		DC:CallBack("ADynamicTopicDetaiHeader.SetChangeImg",index);				--	设置话题图片
		DC:CallBack("ADynamicTopicDetaiListTopic.OnRequestTopicList",index);	--	请求话题滑动层数据
	end
end

function ADynamicTopicDetaiListTopic:onTouchBegan(x,y)
	echo("动态话题信息点击开始");
	return true;
end

function ADynamicTopicDetaiListTopic:onTouchMoved(x,y)
	echo("动态话题信息点击移动");
	return true;
end


function ADynamicTopicDetaiListTopic:onTouchEnded(x,y)
	echo("动态话题信息点击结束");
	return true;
end


function ADynamicTopicDetaiListTopic:onGuiToucBackCall(id)

end

--	请求话题列表
function ADynamicTopicDetaiListTopic:OnRequestTopicList(str)
	self.m_topic = str;
	-- 发包
	gSink:Post("michat/get-dynamiclist",{page = 0,topic = str},function(data)
		if data.Result then
			DC:CallBack("ADynamicTopicDetaiListTopic.SetData",data);
		else
			
		end
	end,false);
end

--	列表数据
function ADynamicTopicDetaiListTopic:SetData(data)
	if data == nil then return;end
	self:Cls();
	for i= 1,#data.Data do
		table.insert(self.m_data,data.Data[i]);	
	end
	self.Scroll:BackPos();	
	self:SetTemplate(data);												-- 	从数据里区分出来是图片还是视频
	self.m_data = self:ClearHateList(self.m_data);						--	黑名单匹配
	local mdata = self:copy(self.m_data);
	self.Scroll:SetData(mdata);
end

function ADynamicTopicDetaiListTopic:copy(orig)
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

--设置模板类型
function ADynamicTopicDetaiListTopic:SetTemplate(data)
	if data == nil then return;end
	self.m_nIndex = {};
	local list = data.Data;
	for i= 1,#list do
		if list[i].Filetype == "image" then
			self.m_nIndex[i]  = 1;
			elseif list[i].Filetype == "video" then
			self.m_nIndex[i] = 2;
		end
	end
end
	
--	实时更新点赞数据
function ADynamicTopicDetaiListTopic:updateIndex(index)
	if index == nil then return ;end
	local dataList = copy(self.m_data);
	for i = 1,#self.m_data do
		if self.m_data[i].Id == data.dynamicid then
			if data.commentNum <0 then
				dataList[i].LikeNum = data.LikeNum;
				dataList[i].IsLike = (data.action==1);
				self.Scroll:UpdateData(i,dataList[i]);
			else
				dataList[i].commentNum = data.commentNum;
				self.Scroll:UpdateData(i,dataList[i]);
			end
		end
	end
end

-- 拉黑回调
function ADynamicTopicDetaiListTopic:DeleteUserID(userID)
	if userID == nil then return;end
	local dataList = copy(self.m_data);
	for i=#dataList,1,-1 do
		if type(dataList[i]) ~= "number" then
			if dataList[i].UserId == userID then
				table.insert(self.m_DelData,dataList[i]);
				table.insert(self.m_Moban,self.m_nIndex[i])
				table.remove(self.m_data,i);
				table.remove(dataList,i);
				table.remove(self.m_nIndex,i);			--	移除模板
				self.Scroll:DelByIndex(i);
				self.Scroll:Layout();
			end
		end
	end
end

-- 恢复拉黑回调
function ADynamicTopicDetaiListTopic:InsertUser(userID)
	if userID == nil then return;end
	self.DelData = self:copy(self.m_DelData);
	local nIndex = self:copy(self.m_Moban);
	local indexTab = {};
	for i = #self.m_DelData,1,-1 do
		if userID == self.m_DelData[i].UserId then
			table.insert(self.m_data,self.DelData[i]);
			table.insert(indexTab,i);
			table.insert(self.m_nIndex,nIndex[i]);
			self.Scroll:AppendData(self.DelData[i]);
			self.Scroll:Layout();
			table.remove(self.m_DelData,i);
		end
	end
	
	for i =#self.m_Moban,1,-1 do
		for j = 1,#indexTab do
			if indexTab[j] == i then
				table.remove(self.m_Moban,i);
			end
		end
	end
end

--黑名单匹配
function ADynamicTopicDetaiListTopic:ClearHateList(datas)
	local tData = DC:GetData("AHomeView.HateList");					--	黑名单列表													-- 已匹配的黑名单个数
	if tData ~= nil then
		for i = 1,tData.num do
			for j=#datas,1,-1 do
				if type(datas[j]) == "table" then
					local user = tData[tostring(datas[j].UserId)];
					if user ~= nil then
						if user.UserId == datas[j].UserId  or user[i] == datas[j].UserId then
							table.insert(self.m_DelData,datas[j]);
							if datas[j].Filetype == "image" then
								table.insert(self.m_Moban,1);
							elseif datas[j].Filetype == "video" then
								table.insert(self.m_Moban,2);
							end
							table.remove(self.m_nIndex,j);				--	移除模板
							table.remove(datas, j);
						end
					end
				end
			end
		end
	end
	return datas;
end

-- 清理
function ADynamicTopicDetaiListTopic:Cls()
	self.Scroll:ToTop();	
	self.Scroll:DelAll();
	self.m_data = {};
	self.m_nIndex = {};
	self.m_page = 0 ;								-- 当前页
	self.m_isend = false;							-- 是否结束
	self.DelData = {};
	self.m_DelData = {};
	self.m_Moban = {};
end