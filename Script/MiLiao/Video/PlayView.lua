
local kd = KDGame;
local gDef = gDef;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
local gSink = A_ViewManager;
local bufferHeight = 10;							 -- 缓冲条高度
local mixColorFile = "ResAll/ML_Main_LM.png";		 -- 混色基础
local bufferBarColor = 0x9Aff0000					 -- 缓冲条
local playBarColor = 0xff00ff00						 -- 进度条
local bufferBarSmoothness = 10						 -- 缓冲条平滑度


local TIMER_BUFFER = 1
local TIMER_CLICK = 101;

PlayView = kd.inherit(kd.Layer);--主界面

c_Require("Script/MiLiao/Comment/Comments.lua")
c_Require("Script/MiLiao/Video/PlayVideoTab.lua")
c_Require("Script/MiLiao/Video/NoWifi.lua")
-- 前一个动态ID
local oldDynamicId = 0;
function PlayView:init()	
	self.m_datas = {};		-- 数据容器
	self.m_items = {}		-- 视图容器
	self.m_index = 1;		-- 当前索引
	self.m_buffer = false;	-- 是否缓冲
	self.m_bIndexChange = true;	--索引发生改变
				
	-- 背景色
	local draw = kd.class(kd.GeometryDraw);
	local stpos = {x=ScreenW/2, y=0};
	local endpos = {x=ScreenW/2, y=ScreenH};
	draw:DrawLine(stpos, endpos, ScreenW/2, 0xff000000);
	self:addChild(draw);
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
	
	-- 播放器
	self.m_Player = kd.class(kd.VideoView,ScreenW,ScreenH,10000,0);
	self.m_Player:SetPos(ScreenW/2,ScreenH/2);
	self.m_Player.OnplayError = function(this,err_code,err_msg)
		-- 异步错误回调
		self.m_Player:Stop();
	end
	-- 播放当前索引视频
	self.m_Player.PlayByIndex = function(this)
		-- 判断是否有网络
		local netType = kd.GetNetworkType(); --获取网络连接
		-- 无网络连接
		if netType == -1 or netType == 0 then
			self.NoWifi:SetVisible(true);
		else
			self.NoWifi:SetVisible(false);
		end
		--[[if self:IsVisible()==false then		--播放界面不可见
			self.m_Player:Stop(); 
			return;
		end--]]
		local data = self.m_datas[self.m_index];
		if data then
			--data.video == "http://10.10.11.77/michat/up/dynamic/video/16.mp4" 
			if string.len(data.video)>0 then
				this:Play(data.video);
				oldDynamicId = 0;
			else
				if oldDynamicId == data.m_data.Id and self.m_bIndexChange==false then
					return;
				end
				self.m_items[self.m_index]:Show(true);
				--判断是否需要显示图片滑动视图
					
				--重新设置图片左右滑动视图的位置
				local x,y = self.m_items[self.m_index]:GetPos();
				self.m_PlayPhotoView:SetPos(x,y);
				
				if data.m_data and data.m_data.Imglist then 
					if #data.m_data.Imglist > 0 and self.m_bIndexChange then
						self.m_PlayPhotoView:ShowPhoto(data.m_data);
					end
				end
				oldDynamicId = data.m_data.Id;
			end
		end
	end
	-- 播放结束回调
	self.m_Player.OnplayEnd = function(this)
		self.m_buffer = false;	-- 是否已加载
		local data = self.m_datas[self.m_index];

		self.m_Player:Play(data.video);
		self:ResetBufferBar();
	end
	-- 读取到视频信息回调
	self.m_Player.OnVideoInfo  = function(this,w,h,r)
		if self:IsVisible()==false then return;end -- 自身不可见,不做处理
		if r ==nil then r = 0;end 
		if r == 90 then
			local ww = w;
			w = h;
			h = ww;
		end
		self.m_Player:SetRotation(r);
		if self.m_ScrollView:IsMotionless() then
			self.NoWifi:SetVisible(false);
			self.m_buffer = true;
			
			local sc = math.min(ScreenW/w,ScreenH/h);
			local sc1 = tonumber(string.format("%.2f",sc));
			if sc1>sc then sc1 =sc1 - 0.01;end 
			self.m_Player:SetScale(sc1,sc1);

			self.m_Player:SetPos(ScreenW/2,ScreenH/2+ScreenH*(self.m_index-1));
			self.m_items[self.m_index]:HideCover();
		end		
	end
	-- 滑动条
	self.m_ScrollView =  kd.class(ScrollVideo,true,true);
	if (self.m_ScrollView) then
		self:addChild(self.m_ScrollView);
		self.m_ScrollView:init(self,0, 0, ScreenW, ScreenH);
		self.m_ScrollView:InsertItem(self.m_Player);
	end	
	-- 滑动结束
	self.m_ScrollView.ScrollEndCallback = {
		[1] = function(this,x,y)-- 右滑
			print("===========ScrollEndCallback======右滑");
			self.m_PlayPhotoView:onTouchEnded(x,y);
			-- 判断是否是视频
			local itemData = self.m_datas[self.m_index]
			if itemData then
				if string.len(itemData.video)>0 or (not self.m_PlayPhotoView:IsVisible()) then
					local dx = self.m_ex - self.m_x
					local dy = math.abs(self.m_ey - self.m_y);
					if dx > 3*dy then
						DC:CallBack("PlayView.Show",false);
					end
				end
			end
		end,
		[2] = function(this,x,y)-- 左滑
			print("===========ScrollEndCallback======左滑");
			self.m_PlayPhotoView:onTouchEnded(x,y);
		end,
		[3] = function(this)-- 上下
			local _,endY = self.m_ScrollView:GetViewPos();
			local offset = endY - this.beginY;
			local forward = offset > 0 and -1 or 1;
			local oldIndex = self.m_index;		--记住旧的索引
			if math.abs(offset) > ScreenH/5 then
				self.m_index = self.m_index + forward;
				if self.m_index < 1 then self.m_index = 1 ;
				elseif self.m_index > #self.m_datas then self.m_index=#self.m_datas end
			end
			
			self.m_bIndexChange = self.m_index ~= oldIndex ;
			if self.m_bIndexChange then 
				self.m_PlayPhotoView:Hide();
			end
			
			local posy = ScreenH - (self.m_index-1)*ScreenH;
			this:SetAppointBack(0,posy);
			this.offset = offset;	-- 偏移
		end
	}
	-- 滑动之中
	self.m_ScrollView.ScrollMoveCallback = {
		[1] = function(this,x,y)-- 右滑
			print("===========ScrollMoveCallback======右滑");
			self.m_PlayPhotoView:onTouchMoved(x,y);
		end,
		[2] = function(this,x,y)-- 左滑
			print("===========ScrollMoveCallback======左滑");
			self.m_PlayPhotoView:onTouchMoved(x,y);
			
		end,
		[3] = function(this,x,y)-- 上下
			ScrollVideo.onTouchMoved(this,x,y);
		end
	}
	-- 计算滑动方向
	self.m_ScrollView.CalScrollDirect = function(this,x,y)
		if this.direct == 0 then
			local diffx = x - this.touchX;
			local diffy = y - this.touchY;
			if diffx > 20 then
				-- 右滑
				this.direct = 1;
			elseif diffx < -20 then
				-- 左滑
				this.direct = 2 ;
			elseif math.abs(diffy)>10 then
				-- 上下滑
				this.direct = 3;
			end
		end
	end
	self.m_ScrollView.onTouchBegan = function(this,x,y)
		ScrollVideo.onTouchBegan(this,x,y);
		this.beginX,this.beginY = self.m_ScrollView:GetViewPos()
		this.touchX,this.touchY = x,y;
		self.m_x,self.m_y = x,y;
		self.m_PlayPhotoView:onTouchBegan(x,y);
		this.direct = 0;	-- 滑动方向
	end
	self.m_ScrollView.onTouchMoved = function(this,x,y)
		this.CalScrollDirect(this,x,y);
		if this.direct>0 then
			this.ScrollMoveCallback[this.direct](this,x,y);
		end
	end
	self.m_ScrollView.onTouchEnded = function(this,x,y)
		self.m_ex,self.m_ey = x,y;
		ScrollVideo.onTouchEnded(this,x,y);
		if this.direct>0 then
			this.ScrollEndCallback[this.direct](this,x,y);
		end
	end
	-- 点击事件
	self.m_ScrollView.OnClickedCall = function(this,x,y)
		if self.m_dwClickTime == nil then
			self:SetTimer(TIMER_CLICK, 500, 1);	 --用来 判断是否有下一次点击
			self.m_dwClickTime = os.time();
		else
			self:KillTimer(TIMER_CLICK);
			self.m_dwClickTime = nil;
			local userid = self.m_items[self.m_index]:GetUserId();
			if userid ~= gSink.m_User.userId then
				local action = self.m_items[self.m_index]:GetActionStatus();
				if action == 0 then
					self:like_dynamic();
				else
					self.m_AniFollow:Play();
				end
			else
				gSink:messagebox_default("不能给自己点赞");
			end
			
		end
		if self.m_buffer then
		else
			-- 播放
			self.m_Player:PlayByIndex();
		end
	end
	-- 复位结束
	self.m_ScrollView.OnAppointBackEnd = function(this)
		self.NoWifi:SetVisible(false);
		if math.abs(this.offset) > 20 then	
			self:ResetBufferBar();
			self.m_Player:Stop();
			self.m_buffer = false;
			local item_data = self.m_datas[self.m_index];
			local videoUrl = item_data.video;
			local bo = string.len(videoUrl)>0;
			for i,v in ipairs(self.m_items) do
				if i~=self.m_index then
					v:ShowCover();
				end
			end
		end
		
		if self.m_index and self.m_items[self.m_index] then
			local netType = kd.GetNetworkType(); --获取网络连接
			-- 无网络连接
			if netType == -1 or netType == 0 then
				self.NoWifi:SetVisible(true);
			else
				self.NoWifi:SetVisible(false);
				self.m_items[self.m_index]:SetVideoInfo();
			end
		end
	end
	
	--左右滑动
	self.m_PlayPhotoView = kd.class(PlayTab,false,false);
	self.m_ScrollView:InsertItem(self.m_PlayPhotoView);
	self.m_PlayPhotoView:SetZOrder(2)
	self.m_PlayPhotoView:init();
	self.m_PlayPhotoView:SetPos(0,ScreenH);
	self.m_PlayPhotoView:SetVisible(true);
	
	-- 缓冲动画
	self.m_bufferTimeNowW = 0;
	self.m_playTimeNowW = 0;
	self.m_bufferTimeRealW = 0;
	self.m_playTimeRealW = 0;
	-- 缓冲条
	self.m_sprBufferTime = kd.class(kd.Sprite,mixColorFile,1293,2006,1,1);
	local w,h = self.m_sprBufferTime:GetWH();
	self.m_sprBufferTime:SetScale(1,bufferHeight);
	self.m_sprBufferTime:SetColor(bufferBarColor);
	self:addChild(self.m_sprBufferTime);
	self.m_sprBufferTime:SetPos(0,ScreenH-h/2);
	-- 进度条
	self.m_sprPlayTime = kd.class(kd.Sprite,mixColorFile,1293,2006,1,1);
	self.m_sprPlayTime:SetScale(1,bufferHeight);
	self.m_sprPlayTime:SetColor(playBarColor);
	self:addChild(self.m_sprPlayTime);
	self.m_sprPlayTime:SetPos(0,ScreenH-h/2);
	
	-- 点赞动画
	self.m_AniFollow = kd.class(kd.AniMultipleImg,self,1,30);
	self:addChild(self.m_AniFollow);
	self.m_AniFollow:SetMode(0);
	for i=0,40 do 
		local str = gDef.GetResPath("ResAll/DongXiao/Zan/");
		local spr = kd.class(kd.Sprite, str..i..".png");
		spr:SetScale(5,5);
		self.m_AniFollow:InstFrameSpr(spr);
	end
	self.m_AniFollow:SetPos(ScreenW/2,ScreenH/2);
	self.m_AniFollow:Stop();
	
	---------------------------- 蒙版 ----------------------------
	self.mask = kd.class(MaskUI, false, true);
	self.mask:init();
	self:addChild(self.mask)
	self.mask:SetVisible(false);
	---------------------------- 举报 ----------------------------
	self.m_backPop = kd.class(BackPop, false, true);
	self.m_backPop:init();
	self:addChild(self.m_backPop);
	self.m_backPop:SetVisible(false);
	local x, y = self.m_backPop:GetPos();
	self.m_backPop:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x, y+ScreenH);
	self.m_backPop:SetVisible(false);
	self.m_backPop:SetZOrder(2)
	--------------------------- 举报类型 --------------------------
	self.m_BackSelect = kd.class(BackSelect, false, true);
	self.m_BackSelect:init("PlayView.ShowBackSelect");
	self:addChild(self.m_BackSelect);
	self.m_BackSelect:SetVisible(false);
	local x, y = self.m_BackSelect:GetPos();
	self.m_BackSelect:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x, y+ScreenH);
	self.m_BackSelect:SetVisible(false);
	self.m_BackSelect:SetZOrder(2)
	---------------------------- 断网 ----------------------------
	self.NoWifi = kd.class(NoWifi, false, false);
	self.NoWifi:init();
	self:addChild(self.NoWifi)
	self.NoWifi.SetVisible = function (this,bo)
		kd.Node.SetVisible(this,bo);
		DC:FillData("NoWifi.Show",bo);
	end
	self.NoWifi:SetVisible(false);

	--[[
		data = {
			Data = {},		-- 当前的所有数据
			page = 0,		-- 当前页
			topic = "",		-- topic（""：所有，"focus"：关注，"xxx"：话题）
			index = 0		-- 第几个
		}
	--]]
	DC:RegisterCallBack("PlayView.ShowView",self,function (data)
		self:Show(data);
	end);
	
	DC:RegisterCallBack("PlayView.Show",self,function (bo)
		self:SetVisible(bo);
	end);
	
	DC:RegisterCallBack("PlayView.ShowMask",self,function (bo)
		self.mask:SetVisible(bo);
	end);
	
	DC:RegisterCallBack("PlayView.ShowBackPop",self,function (bo)
		if bo then
			self.mask:SetVisible(bo);
		end
		self.m_backPop:SetVisible(bo);
	end);
	
	DC:RegisterCallBack("PlayView.ShowBackSelect",self,function (bo)
		self.m_BackSelect:SetVisible(bo);
	end);
	DC:RegisterCallBack("PlayView.like_dynamic",self,function ()
		self:like_dynamic();
	end);
	
	DC:RegisterCallBack("PlayView.report",self,function()
		self:report();
	end)
	DC:RegisterCallBack("PlayView.PlayByIndex",self,function()
		self.m_Player:PlayByIndex();
	end)
	
	DC:RegisterCallBack("GetOneVideoList.create_conv",self,function (data)
		self:create_conv(data)
	end)
	
	DC:RegisterCallBack("PlayView.UpdteCommentNum",self,function(newNum)
		self.m_items[self.m_index]:UpdteCommentNum(newNum);
		local bo = self.m_PlayPhotoView:IsVisible();
		if bo then
			self.m_PlayPhotoView:UpdteCommentNum(newNum);
		end
		-- 更新外面的数据
		local dynamicid = self.m_items[self.m_index]:GetDynamicId();
		local num = self.m_items[self.m_index]:GetDynamicNum();
		local updateData = {dynamicid = dynamicid, LikeNum = 0, action = 0, commentNum = num}
		if self.m_viewType then
			DC:CallBack(self.m_viewType..".updateIndex", updateData);
		end
	end)	
	
	DC:RegisterCallBack("PlayView.viewType",self,function (view)
		self.m_viewType = view;
	end)
	
	DC:RegisterCallBack("PlayView.IsPause",self,function (bo)
		self.m_Player:Pause(bo);
	end)
	
	-- 缓冲动画定时器
	self:SetTimer(TIMER_BUFFER,500,0xffffffff);
end

--创建会话
function PlayView:create_conv(data)
	self.m_convData = data;
	local itemdata = self.m_datas[self.m_index].m_data;
	DC:CallBack("AChat.Show",data,itemdata.NickName,gDef.domain..itemdata.AvatarFile,nil,"PlayVideo")
end


-- 重置 缓冲条
function PlayView:ResetBufferBar()
	self.m_bufferTimeNowW = 0;
	self.m_playTimeNowW = 0;
	self.m_bufferTimeRealW = 0;
	self.m_playTimeRealW = 0;
	self.m_sprBufferTime:SetScale(1,bufferHeight);
	self.m_sprPlayTime:SetScale(1,bufferHeight);
end


function PlayView:Show(data)
	self.m_datas =  {}
	self.m_index = data.index;
	self.m_page = data.page;
	self.m_topic = data.topic
	gSink:ShowMi(true);
	self:SetAddData(data.Data);
	
	self.m_items[self.m_index]:SetVideoInfo();
	self.m_Player:PlayByIndex();
	self:ResetBufferBar();
	self:SetVisible(true);
end

	

function PlayView:Hide()
	self:SetVisible(false);
end
function PlayView:OnActionEnd()
	if self:IsVisible() == false then
		self:Clear();
		gSink:ShowMi(false);
		kd.SetSysStateBarStyle(0);
	else
		kd.SetSysStateBarStyle(1);
	end
end

function PlayView:Clear()
	for i,v in ipairs(self.m_items) do
		self.m_ScrollView:DeleteItem(v);
		v = nil;
	end
	self.m_ScrollView:SetViewPos(0,ScreenH);
	self.m_datas = {};		-- 数据容器
	self.m_items = {}		-- 视图容器
	self.m_index = 1;		-- 当前索引
	self.m_buffer = false;	-- 是否缓冲
	self.m_bIndexChange = true;
	self.m_Player:Stop();
	self.m_PlayPhotoView:initView();
	self.NoWifi:SetVisible(false);
	DC:FillData("PlayView.ThisDynamicData", nil);
	oldDynamicId = 0;
	self.m_viewType = nil;
end

function PlayView:update(--[[float--]] delta)
	if self.m_buffer then
		-- 缓冲动画
		if self.m_bufferTimeNowW<self.m_bufferTimeRealW then
			local x,_ = self.m_sprBufferTime:GetScale();
			self.m_bufferTimeNowW = x + bufferBarSmoothness;
			self.m_sprBufferTime:SetScale(self.m_bufferTimeNowW,bufferHeight);
		end
		if self.m_playTimeNowW<self.m_playTimeRealW then
			local x,_ = self.m_sprPlayTime:GetScale();
			self.m_playTimeNowW = x + bufferBarSmoothness;
			self.m_sprPlayTime:SetScale(self.m_playTimeNowW,bufferHeight);
		end
	end
end


function PlayView:OnTimerBackCall(--[[int--]] id)
	if id == TIMER_BUFFER then
		if self.m_buffer then
			-- 计算缓冲条长度
			local totalTime = self.m_Player:GetMaxTime();
			local playTime = self.m_Player:GetPlayClock();
			local bufferTime = self.m_Player:GetBufferClock();
			local bufferPercent = bufferTime / totalTime;
			local playPercent = playTime / totalTime;
			self.m_bufferTimeRealW = bufferPercent*ScreenW*2
			self.m_playTimeRealW = playPercent*ScreenW*2
		end
	elseif id == TIMER_CLICK then
		if self.m_buffer then
			self.m_Player:Pause();
			self.m_items[self.m_index]:Pause();
		end
		self.m_dwClickTime = nil;
	end
end

--Home回调
function PlayView:OnHomeBackCall()
	if self:IsVisible() then
		self.m_Player:Pause(true);
	end
end

--Home回来
function PlayView:onResume()
	if self:IsVisible() and (not gSink.m_DetaileView:IsVisible())  then 
		self.m_Player:Pause(false);
	end 
end

-- 举报
function PlayView:report()
	local dynamicid = self.m_items[self.m_index]:GetDynamicId();
	gSink:Post("michat/report-dynamic",{dynamicid = dynamicid},function(data)
		if data.Result then
			gSink:messagebox_default("举报成功");
		else
			gSink:messagebox_default(data.ErrMsg);
		end
	end);
end

-- 点赞/取消点赞动态
function PlayView:like_dynamic()
	local dynamicid = self.m_items[self.m_index]:GetDynamicId();
	local action = self.m_items[self.m_index]:GetActionStatus();
	action = action == 1 and 0 or 1;
	gSink:Post("michat/like-dynamic",{dynamicid = dynamicid, action = action},function(data)
		if data.Result then
			local num = data.LikeNum;
			if action == 1 then
				self.m_AniFollow:Play();
			end
			-- 更新状态
			self.m_items[self.m_index]:SetActionStatus(action);
			self.m_PlayPhotoView:SetActionStatus(action);
			-- 更新数量
			self.m_datas[self.m_index].m_data.LikeNum = num;
			self.m_items[self.m_index]:SetLikeNum(num);
			self.m_PlayPhotoView:SetLikeNum(num);
			local updateData = {dynamicid = dynamicid, LikeNum = num, action = action, commentNum = -1}
			if self.m_viewType then
				DC:CallBack(self.m_viewType..".updateIndex", updateData);
			end
		else
			gSink:messagebox_default(data.ErrMsg);
		end
	end);
end

function PlayView:GetData()
	local sendData = {page = self.m_page,topic = self.m_topic};
	gSink:Post("michat/get-dynamiclist",sendData,function(data)
		if data.Result then
			self:SetAddData(data.Data);
		else
			gSink:messagebox_default(data.ErrMsg);
		end
	end);
end

function PlayView:SetAddData(data)
	local temData = {};
	local sumNum = #self.m_datas;
	for i=1,#data do
		local item_data = {video = "", img = "", m_data = data[i]};
		if string.len(data[i].VideoUrl)>0 then
			item_data.video = gDef.domain..data[i].VideoUrl;
			item_data.img = gDef.domain..data[i].VideoCover;
		else
			item_data.img = gDef.domain..data[i].Imglist[1];
		end
		table.insert(self.m_datas, item_data);
		table.insert(temData, item_data);
	end
	
	local x,y = self.m_ScrollView:GetViewPos();
	self.m_ScrollView:SetViewPos(x,ScreenH - (self.m_index-1)*ScreenH);
	self.m_ScrollView:SetRenderViewMaxH(#self.m_datas*ScreenH);
	for i,v in ipairs(temData) do
		self.m_items[i] = kd.class(PlayVideoItem,false,false);
		self.m_items[i]:init(self,v);
		self.m_items[i]:SetPos(0,ScreenH * (sumNum + i));
		self.m_ScrollView:InsertItem(self.m_items[i]);
	end
end