-- ============================================================
-- 常规滚动视图组件
-- 更详细的说明：组件中判断水平和垂直滑动，可将事件传递给内部组件
-- 推荐有限的子元素使用本组件，需要手动创建每一项，性能一般
-- 需要无限的子元素请使用ScrollEx
-- ============================================================


local kd = KDGame;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
local TweenPro = TweenPro
local iphonex = kd.SceneSize.ratio <= 0.5
local gSink = _ViewStart;
Scroll = kd.class(kd.Layer);

function Scroll:init(x,y,w,h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.realHeight = 0-- 实际高度
	self.posHeight = 0 -- 定位高度(影响垂直布局)
	self.tempWidth = 0 -- 临时宽度(影响水平布局)
	self.nodes = {}
	
	self.guilayer = kd.class(kd.GuiObjectNew,self,1,x,y,w,h);
	self.guilayer:setDebugMode(true)
	self.guilayer:setRectClipping(x,y,w,h);
	self:addChild(self.guilayer);
	self.layer = kd.class(kd.Layer,false,false);
	self.guilayer:addChild(self.layer);
	
	-- 加载状态 "down" "up"
	self.state = "normal" 
	
	-- 滚动优化
	self.isOptimize = true
	self.OptimizeCount = 15 -- （开启优化时，显示的节点数量）默认15，如果小了，需要手动调节
	
	-- 惯性滚动
	self.maxY = ScreenH
	self.minY = 0
    self.offsetY = ScreenH
    self.duration = 0
    self.bezier = {0,0,1,1}
    self.startY = 0
    self.pointY = 0
    self.startTime = 0            
    self.momentumStartY = 0         
    self.momentumTimeThreshold = 300
    self.momentumYThreshold = 15
    self.isStarted = false
	
	self.m_isCanChangeLock = true
	self.isSendExScrollEvent = true
	self.min = 0
	self.max = 0
end

function Scroll:SetMinMax(min,max)
	self.min = min
	self.max = max
end
function Scroll:CalMiny()
	local min = 0
	if self.realHeight<=self.h then
		min = ScreenH
	else
		min = ScreenH - (self.realHeight-self.h)
	end

	self.minY = min
end


function Scroll:onTouchBegan(--[[float]] x, --[[float]] y)
	if x<self.x or x>self.x+self.w or y<self.y or y>self.y+self.h then
		return false
	end

	
	self.downY = y
	self.downX = x
	self.bx,self.by = self.layer:GetPos()
	self.lock = self.m_isCanChangeLock and 0 or self.lock;
	self:Stop()
	
	self.isStarted = true;
	self.duration = 0;	
	self.pointY = y;
	self.momentumStartY = self.offsetY
	self.startY = self.offsetY
	self.startTime = self.clock()
	
	self.isSendExScrollEvent = false
	if y>self.y+self.min and y<self.y+self.max then
		self.isSendExScrollEvent = true
		DC:CallBack("Scroll.onTouchBegan",x,y)
	end
end


	
function Scroll.clock()
	return os.clock() * 1000 -- 秒
end
function Scroll:onTouchMoved(--[[float]] x, --[[float]] y)

	
	if self.m_isCanChangeLock and self.lock == 0 then
		if math.abs(x - self.downX) > 20 then
			self.lock = 1 -- 水平滑动 
		elseif math.abs(y - self.downY) > 20 then
			self.lock = 2 -- 垂直滑动
			self.m_isCanChangeLock = false
		end
	end
	
	if self.lock == 2 then
		-- ==============================
		-- 垂直滚动
		-- ==============================
		if not self.isStarted then
			return
		end
		
		local deltaY = y - self.pointY;

		local offsetY = math.round(self.startY + deltaY);

		if offsetY > self.maxY then
			offsetY = math.round((offsetY-self.maxY)/3 + self.maxY);
		elseif offsetY < self.minY then
			offsetY = math.round(self.minY - (self.minY - offsetY)/3);
		end
		
		self.offsetY = offsetY;
		local now = self.clock();
		if now - self.startTime > self.momentumTimeThreshold then
			self.momentumStartY = self.offsetY;
			self.startTime = now;
		end
	elseif  self.lock == 1 then
		if self.isSendExScrollEvent then
			self.m_isCanChangeLock = true
			DC:CallBack("Scroll.onTouchMoved",x,y)
		end
	end
	
	

end


function Scroll:onTouchEnded(--[[float]] x, --[[float]] y)
	
	if self.lock == 2 then
		-- ==============================
		-- 垂直滚动
		-- ==============================
		if (not self.isStarted) then return end;
		self.isStarted = false;
		-- ======================================================
		-- 超出边界回弹
		-- ======================================================
		if (self:isNeedReset()) then
			
			self.ex,self.ey = self.layer:GetPos();
			local setfixy = 100 -- 触发下拉、上拉的偏移量
			-- ==============================
			-- 下拉事件
			-- ==============================
			if self.OnDown and self.ey>self.maxY and math.abs(self.ey-self.maxY)>setfixy then
				-- 下拉状态
				self.state = "down"
				-- 下拉暂停
				self.offsetY = self.offsetY +setfixy
			-- ==============================
			-- 上拉事件
			-- ==============================
			elseif self.OnUp and self.ey<self.minY and math.abs(self.ey-self.minY)>setfixy  then
				-- 上拉状态
				self.state = "up"
				-- 上拉暂停
				self.offsetY = self.offsetY -setfixy
			end
			-- 复位
			TweenPro:Animate({
				{o=self.layer,y=self.offsetY,d=self.duration,speed_bezier=self.bezier,fn = function()
					if self.state == "down" then
						self:OnDown()
					elseif self.state == "up" then
						self:OnUp()
					end
				end}
			});
		-- ======================================================
		-- 未超出边界
		-- ======================================================
		else
			local absDeltaY = math.abs(self.offsetY - self.momentumStartY);
			local duration = self.clock() - self.startTime;

			-- ====================有惯性=====================
			if (duration < self.momentumTimeThreshold and absDeltaY > self.momentumYThreshold) then
				local momentum = self:momentum(self.offsetY, self.momentumStartY, duration);
				self.offsetY = math.round(momentum.destination);
				self.duration = momentum.duration;
				self.bezier = momentum.bezier;
				TweenPro:Animate({
					{o=self.layer,y=self.offsetY,d=self.duration,speed_bezier=self.bezier,fn=function()
						if (self:isNeedReset()) then
							TweenPro:Animate({
								{o=self.layer,y=self.offsetY,d=self.duration,speed_bezier=self.bezier}
							});
						end
					end}
				});

			-- ====================无惯性=====================
			else
				self.ex,self.ey = self.layer:GetPos();
				-- ==============================
				-- 点击事件
				-- ==============================
				if math.abs(x-self.downX)<20 
				and math.abs(self.ey-self.by)<20
				and y>=self.y  
				and y<=self.y+self.h
				then
					if self.OnClick then
						local fy = math.abs(self.ey-ScreenH) + (y-self.y) 	-- 滑动层点击y坐标
						local fx = x - self.x								-- 滑动层点击x坐标
						local height = 0
						local width = 0
						local index = 0
						for i,v in ipairs(self.nodes) do
							local w,h = v:GetWH()
							if width+2*w>self.w then	
								if height+h>fy and width+w>fx then
									index = i 
									break;
								end
								width = 0
								height = height + h
							else
								width = width + w
								if height+h>fy and width>fx then
									index = i 
									break;
								end
							end
						end
						if index > 0 then
							self:OnClick(index,self.nodes[index])
						end
					end
				end
				
				
			end
		end
	elseif self.lock == 1 and self.isSendExScrollEvent then
		-- ==============================
		-- 水平滚动
		-- ==============================
		DC:CallBack("Scroll.onTouchEnded",x,y)
		self.isSendExScrollEvent = false
	end
	self.m_isCanChangeLock = true

	
end

function Scroll:update(delta)
	if self.isStarted then
		local x,y = self.layer:GetPos()
		self.layer:SetPos(x,self.offsetY)
	end
	

	
	if self.isOptimize then
		local x,y = self.layer:GetPos()
		local scrolly = math.abs(y - ScreenH)
		
		local index = 0
		local width = 0
		local height = 0
		
		for i,v in ipairs(self.nodes) do
			local w,h = v:GetWH()
			if width+2*w>self.w then	
				width = 0
				height = height + h
			else
				width = width + w

			end				
			if height>scrolly then
				index = i 
				break;
			end
		end
		for i=index-10,index-self.OptimizeCount//2 do
			local v = self.nodes[i]
			if v then
				v:SetVisible(false)
			end
		end
		for i=index-self.OptimizeCount//2,index+self.OptimizeCount do
			local v = self.nodes[i]
			if v then
				v:SetVisible(true)
			end
		end
		for i=index+self.OptimizeCount,index+2*self.OptimizeCount do
			local v = self.nodes[i]
			if v then
				v:SetVisible(false)
			end
		end

--		local screeny = y-ScreenH - scrolly 子元素当前屏幕绝对坐标
			

	end
end


function Scroll:momentum(current, start, duration)
	local durationMap = {
		noBounce=2500,
		weekBounce=800,
		strongBounce=400,
	}
	local bezierMap = {
		noBounce={.17, .89, .45, 1},
		weekBounce={.25, .46, .45, .94},
		strongBounce={.25, .46, .45, .94},
	}
	local swingfn = 'noBounce'
	local deceleration = 0.003;
	local bounceRate = 10;
	local bounceThreshold = 300;
	local maxOverflowY = self.h / 6;
	local overflowY;

	local distance = current - start;
	local speed = 2 * math.abs(distance) / duration;
	local destination = current + speed / deceleration * (distance < 0 and -1 or 1);
	
	if (destination > self.maxY) then
		overflowY = destination - self.maxY;
		swingfn = overflowY > bounceThreshold and 'strongBounce' or 'weekBounce';
--		destination = self.maxY
		destination = math.min(self.maxY + maxOverflowY, self.maxY + overflowY / bounceRate);
	elseif (destination < self.minY) then
		overflowY = self.minY - destination;
		swingfn = overflowY > bounceThreshold and 'strongBounce' or 'weekBounce';
--		destination = self.minY
		destination = math.max(self.minY - maxOverflowY, self.minY - overflowY / bounceRate);
	end

	return {destination = destination,duration=durationMap[swingfn],bezier=bezierMap[swingfn]};
end

function Scroll:isNeedReset()
	local offsetY;
	if (self.offsetY > self.maxY) then
		offsetY = self.maxY;
	elseif (self.offsetY < self.minY) then
		offsetY = self.minY;
	end
	
	if (offsetY ~= nil) then
		self.offsetY = offsetY;
		self.duration = 500;
		self.bezier = {.165, .84, .44, 1}
		return true;
	end
	return false;
end
	
function Scroll:Stop()
	TweenPro:StopSingleAnimate(self.layer)
	local x,y = self.layer:GetPos()
	self.offsetY =  y
end






-- =======================================================================
--
--								API
--
-- =======================================================================



Scroll.enumAddAni = {
	bottom = 1, -- 从底部出现
	right =  2, -- 从右边出现
	scale =  3, -- 逐渐放大出现
	rotz =   4, -- 旋转出现
	scale2 = 5, -- 逐渐缩小出现
	bsr1   = 6, -- 贝塞尔1
	bsr2   = 7, -- 贝塞尔2
	cus    = 8,-- 自定义
}
-- 添加项(动画版)
-- @enumAddAni 枚举 出场动画
function Scroll:Add_Ani(item,enumAddAni)
	local enum = enumAddAni or Scroll.enumAddAni.bottom
	if self.isOptimize then
		item:SetVisible(false)
	end
	local w,h = item:GetWH()
	self.layer:addChild(item)
	local x = self.x+self.tempWidth
	local y = ScreenH+self.y+self.posHeight
	-- 超出最大宽度 下一行
	if self.tempWidth+2*w>self.w then
		self.posHeight = self.posHeight + h
		self.tempWidth = 0
	else
		self.tempWidth = self.tempWidth + w
	end
	
	if enum == Scroll.enumAddAni.bottom then
		item:SetPos(0,ScreenH+self.posHeight+self.y+ScreenH);
		TweenPro:Animate({
			{o=item,x=x,y=y,tween = TweenPro.swing.easeOutExpo,d=800}
		});
	elseif enum == Scroll.enumAddAni.right then 
		item:SetPos(ScreenW,ScreenH+self.posHeight+self.y);
		TweenPro:Animate({
			{o=item,x=x,y=y,tween = TweenPro.swing.easeOutExpo,d=800}
		});
	elseif enum == Scroll.enumAddAni.scale then 
		item:SetPos(0,ScreenH+self.posHeight+self.y);
		item:SetScale(0.1,0.1)
		TweenPro:Animate({
			{o=item,scale = 1,x=x,y=y,tween = TweenPro.swing.easeOutExpo,d=800}
		});
	elseif enum == Scroll.enumAddAni.rotz then
		item:SetPos(0,ScreenH+self.posHeight+self.y);
		local rotx,roty,rotz = item:GetRotation3D()
		item:SetRotation3D(rotx,roty,45)
		TweenPro:Animate({
			{o=item,rotz=0,x=x,y=y,tween = TweenPro.swing.easeOutExpo,d=800}
		});
	elseif enum == Scroll.enumAddAni.scale2 then
		item:SetPos(0,ScreenH+self.posHeight+self.y);
		item:SetScale(1.3,1.3)
		TweenPro:Animate({
			{o=item,scale = 1,x=x,y=y,tween = TweenPro.swing.easeOutExpo,d=800}
		});
	elseif enum == Scroll.enumAddAni.bsr1 then
		item:SetPos(ScreenW,ScreenH+self.posHeight+self.y+ScreenH/2);
		TweenPro:Animate({
			{o=item,x=x,y=y,tween = TweenPro.swing.easeOutExpo,d=800,
			cubic_bezier = {.78,.11,.89,.26}
			}
		});
	elseif enum == Scroll.enumAddAni.bsr2 then
		item:SetPos(ScreenW,ScreenH+self.posHeight+self.y+ScreenH/2);
		TweenPro:Animate({
			{o=item,x=x,y=y,tween = TweenPro.swing.easeOutExpo,d=800,
			cubic_bezier = {.86,.46,.8,1.65}
			}
		});
	-- 复杂的自定义
	elseif enum == Scroll.enumAddAni.cus then
		local isLeft = true

		local jo = self.posHeight // h -- 行 从0开始
		if jo%2==0 then
			-- 偶
			if x<=ScreenW/2-100 then
				isLeft = true
			else
				isLeft = false
			end
		else
			-- 奇
			if x>=ScreenW/2+100 then
				isLeft = false
			else
				isLeft = true
			end
		end	
		if isLeft then
			item:SetPos(-ScreenW//5,ScreenH+self.posHeight+self.y);
		else
			item:SetPos(ScreenW,ScreenH+self.posHeight+self.y);
		end
		TweenPro:Animate({
			{o=item,x=x,y=y,tween = TweenPro.swing.linear,d=800}
		});
	end
	
	table.insert(self.nodes,item)

	if self.tempWidth==0 then
		self.realHeight = self.posHeight -- 实际高度
	else
		self.realHeight = self.posHeight + h -- 实际高度
	end
	
	self:CalMiny()
	
end
-- 删除项(动画版) 节点过多时(>200)慎用，会让帧率急剧下降
-- @index 下标
function Scroll:DelByIndex_Ani(index)
	local item = table.remove(self.nodes,index)
	local w,h= item:GetWH()
	TweenPro:DelNode(item) -- 非常重要(防止崩溃) 标记C层对象已经被移除 动画将被忽略
	self.layer:RemoveChild(item)
	self.posHeight = 0
	self.realHeight = 0
	self.tempWidth = 0
	local lastH = 0 -- 最后一个元素高度
	for i,v in ipairs(self.nodes) do
		local w,h = v:GetWH()
		lastH = h
		local x = self.x+self.tempWidth
		local y = ScreenH+self.y+self.posHeight
		-- 超出最大宽度 下一行
		if self.tempWidth+2*w>self.w then
			self.posHeight = self.posHeight + h
			self.tempWidth = 0
		else
			self.tempWidth = self.tempWidth + w
		end
		TweenPro:Animate({
			{o=v,x=x,y=y,tween = TweenPro.swing.easeInQuat}
		});
	end
	if self.tempWidth==0 then
		self.realHeight = self.posHeight -- 实际高度
	else
		self.realHeight = self.posHeight + lastH -- 实际高度
	end
	self:CalMiny()
	
	
end

-- 重新排列
function Scroll:Layout()
	self.posHeight = 0
	self.realHeight = 0
	self.tempWidth = 0
	local lastH = 0 -- 最后一个元素高度
	for i,v in ipairs(self.nodes) do
		local w,h = v:GetWH()
		lastH = h
		local x = self.x+self.tempWidth
		local y = ScreenH+self.y+self.posHeight
		-- 超出最大宽度 下一行
		if self.tempWidth+2*w>self.w then
			self.posHeight = self.posHeight + h
			self.tempWidth = 0
		else
			self.tempWidth = self.tempWidth + w
		end
		v:SetPos(x,y);
	end
	if self.tempWidth==0 then
		self.realHeight = self.posHeight -- 实际高度
	else
		self.realHeight = self.posHeight + lastH -- 实际高度
	end
	self:CalMiny()
end

-- 添加项
function Scroll:Add(item)
	
	local w,h = item:GetWH()
	self.layer:addChild(item)
	local x = self.x+self.tempWidth
	local y = ScreenH+self.y+self.posHeight
	-- 超出最大宽度 下一行
	if self.tempWidth+2*w>self.w then
		self.posHeight = self.posHeight + h
		self.tempWidth = 0
	else
		self.tempWidth = self.tempWidth + w
	end
	item:SetPos(x,y);
	table.insert(self.nodes,item)
	item.sub = #self.nodes
	if self.tempWidth==0 then
		self.realHeight = self.posHeight -- 实际高度
	else
		self.realHeight = self.posHeight + h -- 实际高度
	end
	
	self:CalMiny()
end
-- 删除项
-- @index 下标
function Scroll:DelByIndex(index)
	local item = table.remove(self.nodes,index)
	local w,h= item:GetWH()
	TweenPro:DelNode(item)
	self.layer:RemoveChild(item)
	self:Layout()
end
-- 删除所有
function Scroll:DelAll()
	for i,v in ipairs(self.nodes) do
		-- 1 先停止动画
		TweenPro:DelNode(v)
		-- 2 再删除
		self.layer:RemoveChild(v)
	end
	self.nodes = {}
	self.posHeight = 0
	self:Layout()
end
-- 复位：下拉或上拉复位(建议在[收包]或[请求超时]调用)
function Scroll:BackPos()
	if self.state == "down" then
		TweenPro:Animate({
			{o=self.layer,y=self.maxY,speed_bezier=self.bezier}
		});
		self.state = "normal"
	elseif self.state == "up" then
		TweenPro:Animate({
			{o=self.layer,y=self.minY,speed_bezier=self.bezier}
		});
		self.state = "normal"
	end
end
-- 复位到顶部
function Scroll:BackTop()
	TweenPro:Animate({
		{o=self.layer,y=self.maxY,speed_bezier={.25, .46, .45, .94}}
	});
end
-- 复位到底部
function Scroll:BackBottom()
	TweenPro:Animate({
		{o=self.layer,y=self.minY,speed_bezier={.25, .46, .45, .94}}
	});
end
-- 显示边界
function Scroll:ShowBorder()
	self.m_draw = kd.class(kd.GeometryDraw);
	self:addChild(self.m_draw);
	local color = 0xff337AB7
	local point1 = {x=self.x,y=ScreenH-self.y}
	local point2 = {x=self.x+self.w,y=ScreenH-self.y}
	local point3 = {x=self.x+self.w,y=ScreenH-(self.y+self.h)}
	local point4 = {x=self.x,y=ScreenH-(self.y+self.h)}
	-- 上
	self.m_draw:DrawLine(point1,point2 , 1, color);
	-- 右
	self.m_draw:DrawLine(point2,point3 , 1, color);
	-- 下
	self.m_draw:DrawLine(point3,point4 , 1, color);
	-- 左
	self.m_draw:DrawLine(point4,point1 , 1, color);
end
-- 开启滚动优化(默认) 开启滚动优化只显示屏幕一定区域内的节点，可以大大减少顶点数量，提高帧率
function Scroll:OpenOptimize()
	self.isOptimize =  true
end
-- (Test)关闭滚动优化 总是将所有的节点设置为可见状态 元素过多会降低帧率
function Scroll:CloseOptimize()
	self.isOptimize =  false
end
-- 优化数量 一屏范围内显示的子元素个数 一屏元素过多时 请调用该方法手动调节 默认15
function Scroll:SetOptimizeCount(c)
	self.OptimizeCount = c
end

-- 根据下标获取节点
function Scroll:GetItemByIndex(i)
	return self.nodes[i]
end
-- 获取所有节点
function Scroll:GetItems()
	return self.nodes
end
-- 根据ID查询节点
function Scroll:GetItemByID(id)
	local item
	for i,v in ipairs(self.nodes) do
		if v.id == id then
			item = v
			break;
		end
	end
	return item
end
-- =======================================================================
--
--								回调函数及演示
--
-- =======================================================================
--[[
self.Scroll = kd.class(Scroll,true,true)
self.Scroll:init(0,50,ScreenW,ScreenH-50)
self:addChild(self.Scroll)
self.Scroll.OnClick = function(this,index,item)
	echo("==========点击"..index)
end

self.Scroll.OnDown = function(this)
	echo("==========下拉")
	this:BackPos() -- 复位
end
self.Scroll.OnUp = function(this)
	echo("==========上拉")
	this:BackPos() -- 复位
end
for i=1,100 do
	local item = kd.class(Item,false,false) -- 每个Item需实现 GetWH 方法
	item:init()
	self.Scroll:Add(item)
end
--]]
