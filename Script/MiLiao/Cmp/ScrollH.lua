-- ============================================================
-- 水平滚动组件 只支持单行布局
-- ============================================================

local kd = KDGame;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
local TweenPro = TweenPro
local iphonex = kd.SceneSize.ratio <= 0.5
local gSink = _ViewStart;
ScrollH = kd.class(kd.Layer);
local impl = ScrollH
function impl:init(x,y,w,h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.realWidth = 0-- 实际高度
	self.posWidth = 0 -- 定位高度(影响垂直布局)
	self.nodes = {}
	
	self.guilayer = kd.class(kd.GuiObjectNew,self,1,x,y,w,h);
	self.guilayer:setDebugMode(true)
	self.guilayer:setRectClipping(x,y,w,h);
	self:addChild(self.guilayer);
	self.layer = kd.class(kd.Layer,false,false);
	self.guilayer:addChild(self.layer);

	-- 滚动优化
	self.isOptimize = true
	self.OptimizeCount = 15 -- （开启优化时，显示的节点数量）默认15，如果小了，需要手动调节
	
	-- 惯性滚动
	self.maxY = 0
	self.minY = 0
    self.offsetY = 0 -- 偏移量
    self.duration = 0
    self.bezier = {0,0,1,1}
    self.startY = 0
    self.pointY = 0
    self.startTime = 0            
    self.momentumStartY = 0         
    self.momentumTimeThreshold = 300
    self.momentumYThreshold = 15
    self.isStarted = false
end

function impl:CalMiny()
	local min = 0
	if self.realWidth<=self.w then
		min = 0
	else
		min = 0 - (self.realWidth-self.w)
	end

	self.minY = min
end


function impl:onTouchBegan(--[[float]] x, --[[float]] y)
	if x<self.x or x>self.x+self.w or y<self.y or y>self.y+self.h then
		return false
	end

	self.downY = y
	self.downX = x
	self.bx,self.by = self.layer:GetPos()
	
	self:Stop()
	
	self.isStarted = true;
	self.duration = 0;	
	self.pointX = x;
	self.momentumStartY = self.offsetY
	self.startY = self.offsetY
	self.startTime = self.clock()
end

function impl:update(delta)
	if self.isStarted then
		local x,y = self.layer:GetPos()
		self.layer:SetPos(self.offsetY,y)
	end
end
	
function impl.clock()
	return os.clock() * 1000 -- 秒
end
function impl:onTouchMoved(--[[float]] x, --[[float]] y)

	if not self.isStarted then
		return
	end
	
	local deltaY = x - self.pointX;

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

end

function impl:momentum(current, start, duration)
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
		destination = self.maxY
	elseif (destination < self.minY) then
		overflowY = self.minY - destination;
		swingfn = overflowY > bounceThreshold and 'strongBounce' or 'weekBounce';
		destination = self.minY
	end

	return {destination = destination,duration=durationMap[swingfn],bezier=bezierMap[swingfn]};
end



function impl:onTouchEnded(--[[float]] x, --[[float]] y)
	if (not self.isStarted) then return end;
	self.isStarted = false;
	-- ======================================================
	-- 超出边界回弹
	-- ======================================================
	if (self:isNeedReset()) then
		-- 复位
		TweenPro:Animate({
			{o=self.layer,x=self.offsetY,d=self.duration,speed_bezier=self.bezier,fn = function()
				
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
				{o=self.layer,x=self.offsetY,d=self.duration,speed_bezier=self.bezier,fn=function()
					if (self:isNeedReset()) then
						TweenPro:Animate({
							{o=self.layer,x=self.offsetY,d=self.duration,speed_bezier=self.bezier}
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
					local fx = math.abs(self.ex)+(x-self.x)			-- 滑动层点击x坐标
					local height = 0
					local width = 0
					local index = 0
					for i,v in ipairs(self.nodes) do
						local w,h = v:GetWH()
						if width+w>fx then	
							index = i 
							break;
						end
						width = width + w
					end
					if index > 0 then
						self:OnClick(index,self.nodes[index])
					end
				end
			end
			
			
		end
	end
end

function impl:isNeedReset()
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
	
function impl:Stop()
	TweenPro:StopSingleAnimate(self.layer)
	local x,y = self.layer:GetPos()
	self.offsetY =  x
end


-- =======================================================================
--
--								API
--
-- =======================================================================

-- 重新排列
function impl:Layout()
	self.posWidth = 0
	self.realWidth = 0

	for i,v in ipairs(self.nodes) do
		local w,h = v:GetWH()
		local x = self.x+self.realWidth
		local y = ScreenH+self.y
		self.realWidth = self.realWidth + w	
		v:SetPos(x,y);
		
	end
	self.realWidth = self.posWidth
	self:CalMiny()
end

-- 添加项
function impl:Add(item)
	local w,h = item:GetWH()
	self.layer:addChild(item)
	local x = self.x+self.realWidth
	local y = ScreenH+self.y
	self.realWidth = self.realWidth + w	
	item:SetPos(x,y);
	table.insert(self.nodes,item)
	
	self:CalMiny()
end
-- 删除项
-- @index 下标
function impl:DelByIndex(index)
	local item = table.remove(self.nodes,index)
	local w,h= item:GetWH()
	TweenPro:DelNode(item)
	self.layer:RemoveChild(item)
	self:Layout()
end
-- 删除所有
function impl:DelAll()
	for i,v in ipairs(self.nodes) do
		-- 1 先停止动画
		TweenPro:DelNode(v)
		-- 2 再删除
		self.layer:RemoveChild(v)
	end
	self.nodes = {}
	self.posWidth = 0
	self:Layout()
end
-- 复位：下拉或上拉复位(建议在[收包]或[请求超时]调用)
function impl:BackPos()
	if self.state == "down" then
		TweenPro:Animate({
			{o=self.layer,x=self.maxY,speed_bezier=self.bezier}
		});
	elseif self.state == "up" then
		TweenPro:Animate({
			{o=self.layer,x=self.minY,speed_bezier=self.bezier}
		});
	end
end
-- 复位到顶部
function impl:BackLeft()
	TweenPro:Animate({
		{o=self.layer,x=self.maxY,speed_bezier={.25, .46, .45, .94}}
	});
end
-- 复位到底部
function impl:BackRight()
	TweenPro:Animate({
		{o=self.layer,x=self.minY,speed_bezier={.25, .46, .45, .94}}
	});
end
-- 显示边界
function impl:ShowBorder()
	self.m_draw = kd.class(kd.GeometryDraw);
	self:addChild(self.m_draw);
	local color = 0xff337AB7
	local point1 = {x=self.x,y=ScreenH-self.y}
	local point2 = {x=self.x+self.w,y=ScreenH-self.y}
	local point3 = {x=self.x+self.w,y=ScreenH-(self.y+self.h)}
	local point4 = {x=self.x,y=ScreenH-(self.y+self.h)}
	-- 上
	self.m_draw:DrawLine(point1,point2 , 3, color);
	-- 右
	self.m_draw:DrawLine(point2,point3 , 3, color);
	-- 下
	self.m_draw:DrawLine(point3,point4 , 3, color);
	-- 左
	self.m_draw:DrawLine(point4,point1 , 3, color);
end
-- 开启滚动优化(默认) 开启滚动优化只显示屏幕一定区域内的节点，可以大大减少顶点数量，提高帧率
function impl:OpenOptimize()
	self.isOptimize =  true
end
-- (Test)关闭滚动优化 总是将所有的节点设置为可见状态 元素过多会降低帧率
function impl:CloseOptimize()
	self.isOptimize =  false
end
-- 优化数量 一屏范围内显示的子元素个数 一屏元素过多时 请调用该方法手动调节 默认15
function impl:SetOptimizeCount(c)
	self.OptimizeCount = c
end

-- 根据下标获取节点
function impl:GetItemByIndex(i)
	return self.nodes[i]
end
-- 获取所有节点
function impl:GetItems()
	return self.nodes
end
-- 根据ID查询节点
function impl:GetItemByID(id)
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
