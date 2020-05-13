--[[
	首页最外层滑动层(唱歌)
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AHomePageViewList4 = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

-- 文字
local TxtTab = {  	[1] = "关注",		--	关注
					[2] = "推荐",		--	推荐
					[3] = "新人",		--	新人
					[4] = "唱歌",		--	唱歌
					[5] = "跳舞",		--	跳舞
					[6] = "颜值" 		--	颜值
				};

--	X适配
local x_Ip = 0;
local x_IpY = 0;
if gDef.IphoneXView then
	x_Ip = 50;
	x_IpY = 15;
end

function AHomePageViewList4:init()
	
	--====================================================		滑动层		===================================================
	local ScrollViewStart = 225;												--	滑动层起始高度
	local ScrollViewH = ScreenH-ScrollViewStart-120;							--	滑动层总高度
	self.m_nIndex = {};															--	初始化详情选择
	self.m_datas = {};															--	组合数据，用于模板初始化
	self.m_page = 0 															-- 	当前页
	self.m_isend = false														--	是否结束
	self.m_IsState = false;														--	是否是网络中断
	self.m_LastIndex = 0;
	self.m_DelData = {};														--	被删除的数据
	self.m_Moban = {};															--	被删除的模板值
	self.m_IsInsert = true;														--	是否取消拉黑
	--=====================================================		滚动模板	===================================================
	
	-- 创建滚动
	self.Scroll = kd.class(ScrollEx,true,true)
	if self.Scroll then
		self.Scroll:init(0,ScrollViewStart+x_Ip,ScreenW,ScrollViewH-x_Ip*2);
		self:addChild(self.Scroll);
	end
	self.Scroll:SetOptimizeCount(6);
	-- 获取模版
	self.Scroll.OnGetTemplate = function(this,index)
		if self.m_nIndex[index] == 1 then									--	加载2张图
			return AHomePageBanner
		elseif self.m_nIndex[index] == 2 then								--	加载6个选选项卡
			return AHomePageMenu
		elseif 	self.m_nIndex[index] == 3 then								--	加载大图
			return AHomePageBigMap
		elseif self.m_nIndex[index] == 4 then								--	加载4张
			return AHomePageFourMap
		elseif self.m_nIndex[index] == 5 then								--	加载网络状态图
			if self.m_IsState then
				return AHomePageBG2
			else
				return AHomePageBG1
			end
		end
	end
	
	self.Scroll.OnScroll= function(this,deltaY,totalDeltaY,preDeltaY)
		local totalDeltaY = self.Scroll:GetScrollViewH();
		local bo = DC:GetData("AHomePageMenu4.IsSwitch");
		if totalDeltaY<-(330 + 25+x_IpY) and bo then
			DC:CallBack("AHomePageMenu4.Show",true);
			DC:FillData("AHomePageMenu4.IsSuspend",true);
		else
			if totalDeltaY>-(330 + 25+x_IpY) then
				DC:CallBack("AHomePageMenu4.Show",false);
				DC:FillData("AHomePageMenu4.IsSuspend",false);
			end
		end
	end
	
	-- 点击事件演示
	self.Scroll.OnClick = function(this,index,x)
		if index == 2 then
			local index = 0;
			if x<ScreenW/7 then									--	关注
				echo("关注");
				index = 1;
			elseif x>ScreenW/6 and x<ScreenW*2/6 then			--	推荐
				echo("推荐");
				index = 2;
			elseif x>ScreenW*2/6 and x<ScreenW*3/6 then			--	新人
				echo("新人");
				index = 3;
			elseif x>ScreenW*3/6 and x<ScreenW*4/6 then			--	唱歌
				echo("唱歌");
				index = 4;
			elseif x>ScreenW*4/6 and x<ScreenW*5/6 then			--	跳舞
				echo("跳舞");
				index = 5;
			elseif x>ScreenW*5/6 then							--	颜值
				echo("颜值");
				index = 6;
			end	
			-- 切换文字颜色
			if index >0 then
				DC:CallBack("AHomePageView.OnRequestList",TxtTab[index],index);
				DC:CallBack("AHomePageView.HideMenu",index);
			end
			return;
		end
		
		echo("用户详情信息点击事件演示");
		if self.m_datas ~= nil then
			if self.m_datas[index] and self.m_datas[index] ~= 0 then
				local userID = self.m_datas[index].UserId;
				if userID ~= nil then
					DC:CallBack("DetaileView.GetDetailData",userID);
				end
			end
		end
	end	

	-- 下拉刷新演示
	self.Scroll.OnDown = function(this)
		echo("==========下拉");
		local nIndex = DC:GetData("AHomePageView.Index");
		self:Cls();
		DC:CallBack("AHomePageView.OnRequestList",TxtTab[nIndex],nIndex);
	end
	
	-- 上拉加载演示
	self.Scroll.OnUp = function(this)
		-- 发包
		if self.m_isend == false then
			local nIndex = DC:GetData("AHomePageView.Index");
			gSink:Post("michat/recommend-list",{page = self.m_page+1,tag = TxtTab[nIndex]},function(data)
				DC:FillData("AHomePageView.Index",nIndex);
				if data.Result then
					self.m_page = self.m_page + 1;
					self.m_isend = data.IsEnd
					for i,v in ipairs(data.Data) do
						table.insert(self.m_datas,v);
						self.Scroll:AppendData(v);
					end
					self.Scroll:Layout();
					self.Scroll:BackPos();
					if self.m_isend then
					--	self.Scroll:NoMore()  	--	加载等待(没资源)
					end	
				else

				end
			end,false);
		else
			this:BackPos();
		end
	end

	-- 下拉刷新
	self.Scroll:AddDownLoad(LoadUI)
	-- 上拉加载
	self.Scroll:AddUpLoad(LoadUI)
	
	--	注册数据中心
	DC:RegisterCallBack("AHomePageViewList4.Show",self,function(bool)
		self:SetVisible(bool);
	end);
	
	-- 切换话题详情头部图片
	DC:RegisterCallBack("AHomePageViewList4.SetData",self,function(data)
		if data ~= nil then
			self:SetData(data);
		end
	end);

	-- 实时更新拉黑数据
	DC:RegisterCallBack("AHomePageViewList4.DeleteUserID",self,function(userID)
		if userID ~= nil then
			self:DeleteUserID(userID);
		end
	end);
	
	DC:RegisterCallBack("AHomePageViewList4.InsertUser",self,function(userID)
		if userID ~= nil then
			self:InsertUser(userID);
		end
	end);
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function AHomePageViewList4:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

function AHomePageViewList4:onTouchBegan(x,y)
	echo("首页点击开始");
	return true;
end

function AHomePageViewList4:onTouchMoved(x,y)
	echo("首页点击移动");
	return true;
end

function AHomePageViewList4:onTouchEnded(x,y)
	echo("首页点击结束");
	return true;
end

function AHomePageViewList4:update()
	local totalDeltaY = self.Scroll:GetScrollViewH();
	local bo = DC:GetData("AHomePageMenu4.IsSwitch");
	if totalDeltaY<-(330 + 25+x_IpY) and bo then
		DC:CallBack("AHomePageMenu4.Show",true);
		DC:FillData("AHomePageMenu4.IsSuspend",true);
	else
		if totalDeltaY>-(330 + 25+x_IpY) then
			DC:CallBack("AHomePageMenu4.Show",false);
		end
	end
end

function AHomePageViewList4:onGuiToucBackCall(id)

end

--	列表数据
--	@type  用来判断网络状态，网络中断状态
function AHomePageViewList4:SetData(data)
	if data == nil then return;end
	if self.m_LastIndex ~= DC:GetData("AHomePageTitle.Index") then
	else
		if #self.m_datas >0 then
			local totalDeltaY = self.Scroll:GetScrollViewH();
			self.m_datas = self:ClearHateList(self.m_datas);				--	黑名单匹配
			self:SetOffSet(self.m_datas,totalDeltaY);
			return ;
		end
	end
	self:Cls();
	if DC:GetData("AHomePageTitle.Index") == 2 then
		self.Scroll:ToTop();
	end
	self.Scroll:BackPos();
	local index = DC:GetData("AHomePageView.Index");
	self:SetFiexdTemplate(index);
	if #data.Data==0 then				--	无数据
		self.m_nIndex[3] = 5;
		self.m_datas[3] = 1;
	end

	if self.m_IsState then				--	无网络
		self.m_nIndex[3] = 5;
		self.m_datas[3] = 1;
	end
	self:SetTemplate(data);									-- 再设置数据模板
	self.m_datas = self:ClearHateList(self.m_datas);		--	黑名单匹配
	local mdata = self:copy(self.m_datas);
	self:SetOffSet(mdata);
	self.Scroll:SetData(mdata,nil);
	if self.m_IsInsert then
		DC:CallBack("AHomePageMenu1.Show",false);
		DC:CallBack("AHomePageMenu1.SwitchTextColor",index);
	end
end

function AHomePageViewList4:copy(orig)
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


--	设置固定模板
function AHomePageViewList4:SetFiexdTemplate(index)
	self.m_nIndex[1] = 1;
	self.m_nIndex[2] = 2;
	self.m_datas[1] = 0;
	self.m_datas[2] = index;								--	用来修改选项卡文字颜色的值
end

--设置模板类型
function AHomePageViewList4:SetTemplate(data)
	if data == nil then return;end
	local list = data.Data;
	for i= 1,#list do
		self.m_nIndex[i+2] = DC:GetData("AHomePageTitle.Index")+2;
		self.m_datas[i+2] = list[i];
	end
	self.m_LastIndex = DC:GetData("AHomePageTitle.Index")
end


-- 坐标偏移
function AHomePageViewList4:SetOffSet(datas,offsize)
	local index = DC:GetData("AHomePageTitle.Index");			--	获取是大图还是4小图模式
	if index  == 2 then
			if #datas > 6 then
			local ii= 0;
			DC:CallBack("AHomePageView.IsSuspension");
			local IsShow = DC:GetData("AHomePageView.nIsShow");
			for i = 1,6 do 
				if IsShow[i] then
					if offsize == 0 or offsize == nil then
						self.Scroll:SetOffSet(365+x_IpY,false);
					else
						self.Scroll:SetOffSet(math.abs(offsize)+x_IpY,false);
					end
					break;
				else
					ii =ii+1;
				end
			end
			if ii == 6 then
				self.Scroll:SetOffSet(0,false);
			end
		end
	else	
		if #datas > 3 then
			local ii= 0;
			DC:CallBack("AHomePageView.IsSuspension");
			local IsShow = DC:GetData("AHomePageView.nIsShow");
			for i = 1,6 do 
				if IsShow[i] then
					if offsize == 0 or offsize == nil then
						self.Scroll:SetOffSet(365+x_IpY,false);
					else
						self.Scroll:SetOffSet(math.abs(offsize)+x_IpY,false);
					end
					break;
				else
					ii =ii+1;
				end
			end
			if ii == 6 then
				self.Scroll:SetOffSet(0,false);
			end
		end
	end
end

-- 拉黑回调
function AHomePageViewList4:DeleteUserID(userID)
	if userID == nil then return;end
	local dataList = copy(self.m_datas);
	for i=#dataList,1,-1 do
		if type(dataList[i]) ~= "number" then
			if dataList[i].UserId == userID then
				table.insert(self.m_DelData,dataList[i]);
				table.insert(self.m_Moban,self.m_nIndex[i])
				table.remove(self.m_datas,i);
				table.remove(dataList,i);
				table.remove(self.m_nIndex,i);			--	移除模板
				self.Scroll:DelByIndex(i);
				self.Scroll:Layout();
			end
		end
	end
end

-- 恢复拉黑回调
function AHomePageViewList4:InsertUser(userID)
	if userID == nil then return;end
	local DelData = self:copy(self.m_DelData);
	for i = #self.m_DelData,1,-1 do
		if userID == self.m_DelData[i].UserId then
			table.insert(self.m_nIndex,self.m_Moban[i]);
			self.m_IsInsert = false;														--	是否取消拉黑
			table.insert(self.m_datas,DelData[i]);
			self.Scroll:AppendData(self.m_DelData[i]);
			self.Scroll:Layout();
			table.remove(self.m_DelData,i);
		end
	end
end

--黑名单匹配
function AHomePageViewList4:ClearHateList(datas)
	local tData = DC:GetData("AHomeView.HateList");					--	黑名单列表
	local num = 0; -- 已匹配的黑名单个数
	if tData ~= nil then
		for i=#datas,3,-1 do
			if num == tData.num then
				break;
			elseif type(datas[i]) == "table" then
				local user = tData[tostring(datas[i].UserId)]
				if user ~= nil then
					table.insert(self.m_DelData,datas[i]);
					table.insert(self.m_Moban,DC:GetData("AHomePageTitle.Index")+2);
					table.remove(datas, i);
					num = num + 1;
				end
			end
		end
	end
	return datas;
end

-- 清理
function AHomePageViewList4:Cls()
	self.Scroll:DelAll();
	self.m_nIndex = {};
	self.m_datas = {};
	self.m_page = 0 ;				-- 当前页
	self.m_isend = false;			-- 是否结束
	self.m_IsInsert = true;														--	是否取消拉黑
end