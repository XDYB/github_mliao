-- ============================================================
-- 基于模版的滚动视图组件
-- ============================================================

local kd = KDGame;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
local TweenPro = TweenPro
local iphonex = kd.SceneSize.ratio <= 0.5
local gSink = _ViewStart;
AScrollEx = kd.class(kd.Layer);
function AScrollEx:SetMarginTop(x)
	self.marginTop = x
end
function AScrollEx:init(x,y,w,h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.marginTop = 0				-- 顶部空余
	self.bottomTextH = 0			-- 底部文字高度
	self.exNodeHeight = 0			-- 额外的节点高度
	self.realHeight = 0				-- 实际总高度(影响滚动边界)
	self.posHeight = 0 				-- 定位高度(影响垂直布局)
	self.tempWidth = 0 				-- 临时宽度(影响水平布局)
	self.nodemap = HashMap.new()  	-- 节点
	self.nodepool = Queue.new()	  	-- 节点池
	self.speTmap = HashMap.new()  	-- 特别的模版缓存 调用ChangeTemplate后 会保存在这里
	self.datas = {}  				-- 数据

	self.hasLoadAni = false 		-- 是否显示加载动画
	self.guilayer = kd.class(kd.GuiObjectNew,self,1,x,y,w,h);
--	self.guilayer:setDebugMode(true)
	self.guilayer:setRectClipping(x,y,w,h);
	self:addChild(self.guilayer);
	self.layer = kd.class(kd.Layer,false,false);
	self.guilayer:addChild(self.layer);
	self.extData = nil -- 附加参数
	-- 底部提示文字
	self.bottomTextH = 0
	self.txtBottom = kd.class(kd.StaticText,40,"",kd.TextHAlignment.CENTER,ScreenW,40);
	self.txtBottom:SetColor(0xffffffff)
	self.layer:addChild(self.txtBottom)
	self.txtBottom:SetVisible(false)
	
	self.state = "normal" 			-- 下拉、上拉状态 "normal" 静止 "down" 下拉 "up" 上拉
	

	self.OptimizeCount = 20 					-- 显示的节点数量(如果元素较小，可以开放接口自己设置)
	self.PoolCacheCount = self.OptimizeCount+5	-- 节点池缓冲数量
	
	self.index = 1	-- 当前显示的首个元素索引
	self.px = 0		-- 当前显示的首个元素 x
	self.py = 0		-- 当前显示的首个元素 y
	
	
	
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
    self.isStarted = false						-- 锁 update是否更新坐标(在ontouchbegin时开启位置更新)
	
	-- ====================================
	-- 解决：避免滑动过程中点击触发事件
	-- ====================================
	self.isMoveing = false 	 -- 是否滚动中
	self.isClickAble = false -- 是否可点击
end

-- 获取节点
function AScrollEx:OnDraw(index)
	if self.datas[index] then
		local template = self:GetTemplate(index);
	
		-- 从节点池获取
		for i,v in each(self.nodepool) do
			local peek = self.nodepool:peek()
			if peek.template == template then
				local node = self.nodepool:pool()
				node.index = index
				if node.SetData then node:SetData(self.datas[index],self.extData) end
				node:SetVisible(true)
				self.nodemap:put(index,node)
				return node
			end
		end
		-- 创建新节点
		node = kd.class(template,false,false)
		node.template = template 	-- 保存模版地址
		self.layer:addChild(node)
		node.index = index -- 下标
		node:init()
		self.nodemap:put(index,node)
		node:SetData(self.datas[index],self.extData) 
		
		return node
	end
end
-- 计算最大滑动高度
function AScrollEx:CalMiny()
	-- 计算实际高度
	local posHeight = 0
	local realHeight = 0
	local tempWidth = 0
	local x = 0
	local y = 0
	local lastH = 0
	for i=1,#self.datas do
		local template = self:GetTemplate(i) -- 获取模版
		if template == nil then
			echo(1)
		end
		local w,h = template:GetWH()
		lastH = h
		x = self.x+tempWidth
		y = ScreenH+self.y+posHeight
		-- 超出最大宽度 下一行
		if tempWidth+2*w>self.w then
			posHeight = posHeight + h
			tempWidth = 0
		else
			tempWidth = tempWidth + w
		end
	end
	if tempWidth==0 then
		self.realHeight = posHeight + self.exNodeHeight + self.marginTop + self.bottomTextH-- 实际高度
	else
		self.realHeight = posHeight + lastH + self.exNodeHeight + self.marginTop + self.bottomTextH -- 实际高度
	end
	
	-- 计算滚动边界
	local min = 0
	if self.realHeight<=self.h then
		min = ScreenH
	else
		min = ScreenH - (self.realHeight-self.h)
	end

	self.minY = min
	
	if self.sprLoadRot then
		self.sprLoad:SetPos(ScreenW/2,self.realHeight+150)
	end
	if self.bottomTextH>0 then
		self:SetTxtBottomPos()
	end
end

function AScrollEx:onTouchBegan(x,y)
	if x<self.x or x>self.x+self.w or y<self.y or y>self.y+self.h then
		return false
	end
		
	-- 滚动中...
	if self.isMoveing then
		self.isClickAble = false -- 不可点击
	-- 静止中...
	else
		self.isClickAble = true  -- 可点击
	end
	
	
	self.isMoveing = false   -- 停止
	self.downY = y
	self.downX = x
	self.bx,self.by = self.layer:GetPos()
	
	self:Stop()
	
	self.isStarted = true;
	self.duration = 0;	
	self.pointY = y;
	self.momentumStartY = self.offsetY
	self.startY = self.offsetY
	self.startTime = self.clock()
	
	self.preY = 0
end

function AScrollEx:update(delta)
	if self.sprLoadRot then
		self.sprLoadRot = self.sprLoadRot>360 and 0 or self.sprLoadRot + 2
		self.sprLoad:SetRotation(self.sprLoadRot)
	end
	
--	if #self.datas>0 or self.exNodeHeight>0 then
		-- 跟随手指
		if self.isStarted then
			local x,y = self.layer:GetPos()
			self.layer:SetPos(x,self.offsetY)
		end

		local x,y = self.layer:GetPos()
		local scrolly = math.abs(y - ScreenH)


		local node = self.nodemap:get(self.index)
		if node then
			self.px,self.py = node:GetPos()
			local w,h = node:GetWH()
			-- 节点所在屏幕y坐标
			local screeny = self.py-ScreenH-self.y-scrolly
			local step = math.abs(screeny)//h+1
			if screeny<-h then
				self.index = node.index + step
			elseif screeny>0 then
				self.index = node.index - step
			end
		end

		if self.index<1 then self.index = 1 end
		if y>=ScreenH then self.index = 1 end
		
		local index = self.index

		-- 需要隐藏的节点下标
		local indexlist = {}
		for k,node in each(self.nodemap) do
			-- 小于第一行
			if k<index-1 then
				table.insert(indexlist,k)
			end
			-- 大于视图最大显示行
			if k>index+self.OptimizeCount then
				table.insert(indexlist,k)
			end
		end
		-- 将隐藏节点加入节点池
		for i,index in ipairs(indexlist) do
			local node = self.nodemap:remove(index)
			node:SetVisible(false)
			self.nodepool:add(node)
			-- 超出容量
			if self.nodepool:size()>self.PoolCacheCount then
				local rm_node = self.nodepool:pool()
				TweenPro:DelNode(rm_node)
				self.layer:RemoveChild(rm_node)
			end
		end
		
		-- 显示的节点
		for i=index-1,index+self.OptimizeCount-1 do
			if self.nodemap:containsKey(i)==false and i>0 and self.datas[i] then
				local item = self:OnDraw(i)
				self:SetItemPos(i,item)
			end
		end
		
		local node = self.nodemap:get(index)
		if node then
			self.px,self.py = node:GetPos()
		end

--	end
	
			
end

function AScrollEx.clock()
	return os.clock() * 1000
end

function AScrollEx:onTouchMoved(x,y)

	if not self.isStarted then return end
	
	local deltaY = y - self.pointY;
	
	-- 拖动距离>50 不触发点击事件
	if deltaY>50 then
		self.isClickAble = false
	end
	
	local offsetY = math.round(self.startY + deltaY);
	
	if offsetY > self.maxY then
		offsetY = math.round((offsetY-self.maxY)/3 + self.maxY);
	elseif offsetY < self.minY then
		offsetY = math.round(self.minY - (self.minY - offsetY)/3);
	end
	self.offsetY = offsetY;
	echo("滑动控件 Y->",self.offsetY);
	local now = self.clock();
	if now - self.startTime > self.momentumTimeThreshold then
		self.momentumStartY = self.offsetY;
		self.startTime = now;
	end
	
	-- 滚动事件回调 
	if self.OnScroll then
		local totalDeltaY = self:GetScrollH()
		local preDeltaY = self.preY~=0 and y-self.preY or 0
		-- deltaY滚动偏移量 totalDeltaY总偏移量 preDeltaY相对前一次移动偏移量
		self:OnScroll(deltaY,totalDeltaY,preDeltaY)
	end

	if self.download then
		if deltaY>500 then
			self.download:FreeState()
		else
			self.download:DownState()
		end
		self.download:SetRot(deltaY)
	end
	if self.upload then
		if deltaY<-500 then
			self.upload:FreeState()
		else
			self.upload:UpState()
		end
		self.upload:SetRot(math.abs(deltaY))
	end
	self.preY = y
end

function AScrollEx:momentum(current, start, duration)
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
--		destination = math.min(self.maxY + maxOverflowY, self.maxY + overflowY / bounceRate);
	elseif (destination < self.minY) then
		overflowY = self.minY - destination;
		swingfn = overflowY > bounceThreshold and 'strongBounce' or 'weekBounce';
		destination = self.minY
--		destination = math.max(self.minY - maxOverflowY, self.minY - overflowY / bounceRate);
	end

	return {destination = destination,duration=durationMap[swingfn],bezier=bezierMap[swingfn]};
end



function AScrollEx:onTouchEnded(x,y)
	if self.OnMoveUp then
		self:OnMoveUp(x,y);
	end
	if self.SlideLeftToRight then
		if self:IsLeftToRight(x,y) then
			self:SlideLeftToRight()
			return
		end
	elseif self.SlideRightToLeft then
		if self:IsRightToLeft(x,y) then
			self:SlideRightToLeft()
			return
		end
	end
	
	if (not self.isStarted) then return end;
	self.isStarted = false;
	-- ======================================================
	-- 超出边界回弹
	-- ======================================================
	if (self:isNeedReset()) then
		
		self.ex,self.ey = self.layer:GetPos();
		local setfixy = 180 -- 触发下拉、上拉的偏移量
		-- ==============================
		-- 下拉事件
		-- ==============================
		if self.OnDown and self.ey>self.maxY and math.abs(self.ey-self.maxY)>setfixy then
			-- 下拉状态
			self.state = "down"
			-- 下拉暂停
			self.offsetY = self.offsetY +setfixy
			if self.download then
				self.download:StartRot()
			end
		-- ==============================
		-- 上拉事件
		-- ==============================
		elseif self.OnUp and self.ey<self.minY and math.abs(self.ey-self.minY)>setfixy  then
			-- 上拉状态
			self.state = "up"
			-- 上拉暂停
			self.offsetY = self.offsetY -setfixy
			if self.upload then
				self.upload:StartRot()
			end
		end
		-- 复位
		TweenPro:Animate({
			{o=self.layer,y=self.offsetY,d=self.duration,speed_bezier=self.bezier,fn = function()
				if self.state == "down" then
					self:OnDown()
				elseif self.state == "up" then
					self:OnUp()
					if self.upload then
						self.upload:StopRot()
						self.upload:UpdateTime()
					end
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
			self.isMoveing = true
			local momentum = self:momentum(self.offsetY, self.momentumStartY, duration);
			self.offsetY = math.round(momentum.destination);
			self.duration = momentum.duration;
			self.bezier = momentum.bezier;
			TweenPro:Animate({
				{o=self.layer,y=self.offsetY,d=self.duration,speed_bezier=self.bezier,fn=function()
					if (self:isNeedReset()) then
						TweenPro:Animate({
							{o=self.layer,y=self.offsetY,d=self.duration,speed_bezier=self.bezier,fn=function()
								self.isMoveing = false
							end}
						});
					else
						self.isMoveing = false
					end
				end}
			});

		-- ====================无惯性=====================
		else
			if self.isClickAble then
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
						local height = self.marginTop+self.exNodeHeight
						local width = 0
						local index = 0
						for i,v in ipairs(self.datas) do
							local template = self:GetTemplate(i)
							local w,h = template:GetWH()
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
							self:OnClick(index)
						end
					end
				end
			end
			
			
			
		end
	end
end



function AScrollEx:isNeedReset()
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
	
function AScrollEx:Stop()
	TweenPro:StopSingleAnimate(self.layer)
	local x,y = self.layer:GetPos()
	self.offsetY =  y
end

-- @scrolly 滚动高度
-- @index 	索引
-- @item 	节点
function AScrollEx:SetItemPos(index,node)
	if node then
		local posHeight = 0
		local realHeight = 0
		local tempWidth = 0
		local x = 0
		local y = 0
		local lastH = 0
		for i=1,index do
			local template = self:GetTemplate(i) -- 获取模版
			local w,h = template:GetWH()
			lastH = h
			x = self.x+tempWidth
			y = ScreenH+self.y+posHeight
			-- 超出最大宽度 下一行
			if tempWidth+2*w>self.w then
				posHeight = posHeight + h
				tempWidth = 0
			else
				tempWidth = tempWidth + w
			end
		end
		
		if self.hasLoadAni then
			-- 定制的演示动画，可开放动画枚举，或自定义
			node:SetPos(x+ScreenW/2,y+ScreenH/2);
			TweenPro:Animate({
				{o=node,x=x,y=y+self.exNodeHeight+self.marginTop}
			})
		else
			node:SetPos(x,y+self.exNodeHeight+self.marginTop);
		end

	end
end

-- 获取模版
function AScrollEx:GetTemplate(index)
	if self.speTmap:containsKey(index) then
		-- 使用特别模版
		return self.speTmap:get(index)
	else
		-- 使用普通模版
		return self:OnGetTemplate(index)
	end

	
end


-- 左滑检测
function AScrollEx:IsLeftToRight(x,y)
--	if self.downX > 50 then
--		return false
--	end
	local dx = math.abs(self.downX-x)
	local dy = math.abs(self.downY-y)
	if x - self.downX < ScreenW/4 then
		return false
	end
	if x < dy * 3 then
		return false
	end
	return true
end
-- 检测右滑
function AScrollEx:IsRightToLeft(x,y)
--	if self.downX < ScreenW-50 then
--		return false
--	end
	local dx = math.abs(self.downX-x)
	local dy = math.abs(self.downY-y)
	if self.downX - x < ScreenW/4 then
		return false
	end
	if x < dy * 3 then
		return false
	end
	return true
end

-- =====================================================================
--
--			视图移动API (API之外的函数禁止调用，后果不可预料，切记...)
--								
-- =====================================================================
-- 自动复位：下拉或上拉复位(建议在[收包]或[请求超时]调用)
function AScrollEx:BackPos()
	if self.state == "down" then
		TweenPro:Animate({
			{o=self.layer,y=self.maxY,speed_bezier=self.bezier,fn=function()
				if self.download then
					self.download:StopRot()
					self.download:UpdateTime()
				end
				
			end}
		});
		self.state = "normal"
		self.index = 1
	elseif self.state == "up" then
		TweenPro:Animate({
			{o=self.layer,y=self.minY,speed_bezier=self.bezier,fn=function()
				
			end}
		});
		self.state = "normal"
	end
end
-- 复位到顶部
function AScrollEx:BackTop()
	TweenPro:Animate({
		{o=self.layer,y=self.maxY,speed_bezier={.25, .46, .45, .94}}
	});
end

-- 复位到底部
function AScrollEx:BackBottom()
	TweenPro:Animate({
		{o=self.layer,y=self.minY,speed_bezier={.25, .46, .45, .94}}
	});
end
-- 去底部
function AScrollEx:ToBottom()
	self.layer:SetPos(0,self.minY)
end
-- 去顶部
function AScrollEx:ToTop()
	self.layer:SetPos(0,self.maxY)
end
-- 滚动到指定索引
function AScrollEx:ToIndex(i)
	local posHeight = 0
	local tempWidth = 0
	local tmpH = 0
	for i=1,i do
		local template = self:GetTemplate(i) -- 获取模版
		local w,h = template:GetWH()
		tmpH = h
		-- 超出最大宽度 下一行
		if tempWidth+2*w>self.w then
			posHeight = posHeight + h
			tempWidth = 0
		else
			tempWidth = tempWidth + w
		end
	end
	if i==1 then
		self.layer:SetPos(0,ScreenH-posHeight)
	else
		self.layer:SetPos(0,ScreenH-posHeight+tmpH)
	end
end
-- 设置偏移量
-- @y 滚动y值
-- @isAni 是否动画
function AScrollEx:SetOffSet(y,isAni)
	if isAni then
		TweenPro:Animate({
			{o=self.layer,x=0,y=ScreenH-y}
		})
	else
		self.layer:SetPos(0,ScreenH-y)
	end
end

-- 显示边界
function AScrollEx:ShowBorder()
	--[[
	self.m_draw = kd.class(kd.GeometryDraw);
	self:addChild(self.m_draw);
	self.m_draw:SetZOrder(9999)
	local color = 0xff623787
	local point1 = {x=self.x,y=ScreenH-self.y}
	local point2 = {x=self.x+self.w,y=ScreenH-self.y}
	local point3 = {x=self.x+self.w,y=ScreenH-(self.y+self.h)}
	local point4 = {x=self.x,y=ScreenH-(self.y+self.h)}
	-- 上
	self.m_draw:DrawLine(point1,point2 , 5, color);
	-- 右
	self.m_draw:DrawLine(point2,point3 , 5, color);
	-- 下
	self.m_draw:DrawLine(point3,point4 , 5, color);
	-- 左
	self.m_draw:DrawLine(point4,point1 , 5, color);
	--]]
end


-- =====================================================================
--
--								数据操作API		
-- 						
-- =====================================================================

-- 根据下标更新数据
-- @index 下标
-- @data 单个数据
function AScrollEx:UpdateData(index,data)
	self.datas[index] = data
	if self.nodemap:containsKey(index) then
		local node = self.nodemap:get(index)
		node:SetData(self.datas[index])
	end
	self:CalMiny()
end
-- 追加数据到末尾
-- @data 单个数据
function AScrollEx:AppendData(data)
	local len = #self.datas
	self.datas[len+1] = data
end
-- 设置数据
-- @datas 数据数组
function AScrollEx:SetData(datas,extData)
	if self:equal(self.datas,datas) then
		return
	end
	self:DelAll()
	self.extData = extData
	self.datas = datas
	for i=1,self.PoolCacheCount do
		local template = self:GetTemplate(i)
		if template then
			local node = kd.class(template,false,false)
			node.template = template -- 保存模版地址
			self.layer:addChild(node)
			node:init()
			node:SetVisible(false)
			self.nodepool:add(node)
		end
	end
	self:CalMiny()
	if self.upload then
		self:SetUpLoadPos()
	end
	if self.bottomTextH>0 then
		self:SetTxtBottomPos()
		
	end
end
-- 获取数据
function AScrollEx:GetData()
	return self.datas
end
-- 删除数据
function AScrollEx:DelByIndex(index)
	if #self.datas>=index then
		table.remove(self.datas,index)
		for i,v in each(self.nodemap) do
			TweenPro:DelNode(v)
			self.layer:RemoveChild(v)
		end
		self.nodemap:clear()
		self:CalMiny()
		self:SetUpLoadPos()
	else
		echo("=======AScrollEx:DelByIndex 越界")
	end
end
-- 删除全部
function AScrollEx:DelAll()
	for i,v in each(self.nodemap) do
		TweenPro:DelNode(v)
		self.layer:RemoveChild(v)
	end
	self.nodemap:clear()
	self.nodepool:clear()
	self.datas = {}
	self:CalMiny()
end

-- 重新布局 （循环调用AppendData之后，调用该方法重新计算边界，为了提高效率，没有将该操作放在AppendData函数中，避免多次调用。）
function AScrollEx:Layout()
	self:CalMiny()
	if self.upload then
		self:SetUpLoadPos()
	end
end

-- =====================================================================
--
--								模版操作API		
-- 						
-- =====================================================================
-- 清除特别模版
-- @什么是特别模版：比如说点击一行，改变该行模版外观，这种与其他大多数外观不一样的，称为特别模版。
function AScrollEx:ClearSpeTemplate()
	for i,v in each(self.speTmap) do
		local node = self.nodemap:get(i)
		if node then
			TweenPro:DelNode(node)
			self.layer:RemoveChild(node)
			self.nodemap:remove(i)
		end
	end
	self.speTmap:clear()
end

-- 根据指定索引切换模版
-- @切换模版之前，可以清除其他特别模版，也可以不清除，不清除则列表可同时存在多项特别模版
function AScrollEx:ChangeTemplate(index,TempateClazz)
	for i,node in each(self.nodemap) do
		if node.index==index then
			TweenPro:DelNode(node)
			self.layer:RemoveChild(node)
			break;
		end
	end
	-- 创建新节点
	local node = kd.class(TempateClazz,false,false)
	node.template = template -- 保存模版地址
	self.layer:addChild(node)
	node.index = index -- 下标
	node:init()
	self.nodemap:put(index,node)
	self:SetItemPos(index,node)
	if node.SetData then node:SetData(self.datas[index]) end
	-- 更新特别模版
	self.speTmap:put(index,TempateClazz)
	-- 新模版之后的元素要重新定位
	for i,node in each(self.nodemap) do
		self:SetItemPos(i,node)
	end
	
	self:CalMiny()
end
-- =====================================================================
--
--								动画操作API		
-- 						
-- =====================================================================
-- 设置显示的节点数
function AScrollEx:SetOptimizeCount(i)
	self.OptimizeCount = i
end

-- 打开加载动画
function AScrollEx:OpenAni()
	self.hasLoadAni = true
end

-- 显示上拉等待
function AScrollEx:ShowUpLoad(spr)
	self.sprLoadRot = 1
	self.layer:addChild(spr)
	self.sprLoad=spr
end
-- 隐藏上拉等待
function AScrollEx:HideUpLoad()
	if self.sprLoad then
		self.layer:addChild(self.sprLoad)
		self.sprLoadRot = nil
		self.sprLoad = nil
	end
end


-- 添加固定位置节点（如：首页Banner） 
-- 不会被动态释放或创建
-- 不会被DelByIndex 和 DelAll函数清楚
function AScrollEx:AddNode(node)
	local w,h = node:GetWH()
	self.layer:addChild(node)
	local x,y = node:GetPos()
	node:SetPos(0,ScreenH+self.y+self.exNodeHeight+self.marginTop)
	self.exNodeHeight = self.exNodeHeight + h
	
	
	self:CalMiny()
	
	
	
end

-- 获取滚动高度
function AScrollEx:GetScrollH()
	local x,y = self.layer:GetPos()
	local scrolly = math.abs(y - ScreenH)
	return scrolly
end


-- =====================================================================
--
--								加载等待		
-- 						
-- =====================================================================
-- 下拉加载等待
function AScrollEx:AddDownLoad(clazz)
	self.download = kd.class(clazz,true,false)
	self.download:init(self.w)
	self.layer:addChild(self.download)
	local _,h = self.download:GetWH()
	self.download:SetPos(0,ScreenH+self.y-h+self.marginTop)
end

-- 上拉加载等待
function AScrollEx:AddUpLoad(clazz)
	self.upload = kd.class(clazz,true,false)
	self.upload:init(self.w)
	self.layer:addChild(self.upload)
	local _,h = self.upload:GetWH()
	if self.realHeight<self.h then
		self.upload:SetPos(0,ScreenH+self.y+h/2+self.h)
	else
		self.upload:SetPos(0,ScreenH+self.y+h/2+self.realHeight)
	end
	
end
-- 设置上拉加载位置
function AScrollEx:SetUpLoadPos()
	if self.upload then
		local _,h = self.upload:GetWH()
		if self.realHeight<self.h then
			self.upload:SetPos(0,ScreenH+self.y+h/2+self.h)
		else
			self.upload:SetPos(0,ScreenH+self.y+h/2+self.realHeight)
		end
	end
	
end
-- 设置底部文字显示
function AScrollEx:SetTxtBottomPos()
	self.bottomTextH = 150
	self.txtBottom:SetPos(ScreenW/2,self.y+self.realHeight-self.bottomTextH/2)
end

function AScrollEx:NoMore()
	self.upload:NoMore()
end

-- 显示底部文字
function AScrollEx:ShowBottomText(str)
	self.txtBottom:SetString(str)
	self.txtBottom:SetVisible(true)
	self:SetTxtBottomPos()
end
	

function AScrollEx:equal(value1, value2)
	if value1 == nil and value2 == nil then
		return true
	end
	
	if value1 == nil or value2 == nil then
		return false
	end
	
	if type(value1) ~= "table" and type(value2) ~= "table" then
		return value1 == value2
	end
	
	if type(value1) ~= "table" or type(value2) ~= "table" then
		return false
	end
	
	for k,v in pairs(value1) do
		if table.equal(value2[k],v) == false then 
			return false
		end
	end
	for k,v in pairs(value2) do
		if table.equal(value1[k],v) == false then 
			return false
		end
	end
	return true
end	











-- ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
--
--										回调函数及演示
--
-- ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
-- 模版必须重写的函数：
--[[
function Item:GetWH()
	return 180,180
end
function Item:SetData(data)
	-- do sth...
end
--]]
--[[
	-- 创建滚动
	self.Scroll = kd.class(AScrollEx,true,true)
	self.Scroll:init(0,100,ScreenW,ScreenH-200)
	self:addChild(self.Scroll)
	self.Scroll:ShowBorder()
	
	-- 获取模版
	self.Scroll.OnGetTemplate = function(this,index)
		-- 模版混排演示
		if index == 4 or index == 5 or index == 6 or index == 7 or
		index == 10 or index == 11 or index == 12 or index == 13 or
		index == 15 or index == 16 or index == 17 or index == 18 or
		index == 19 or index == 20 or index == 21 or index == 22 or
		index == 23 or index == 24 or index == 25 or index == 26
		then
			return Item1
		else
			return ItemA
		end
	end
	-- 点击事件演示
	self.Scroll.OnClick = function(this,index)
		-- 切换模版演示
		self.Scroll:ClearSpeTemplate()			-- 清除全部特别模版
		local rdindex = math.random(1,3)		-- 随机切换
		local template
		if rdindex == 1 then
			template = ItemB
		elseif rdindex == 2 then
			template = ItemC
		elseif rdindex == 3 then
			template = ItemD
		end
		self.Scroll:ChangeTemplate(index,template) -- 切换指定索引模版
	end
	-- 下拉刷新演示
	self.Scroll.OnDown = function(this)
		this:DelAll()
		this:BackPos()
		local data = {}
		for i=1,500 do
			table.insert(data,{id=i,name="名字"..i})
		end
		TweenPro:SetTimeout(1000,function()
			-- 为了增强演示效果，这里延迟1秒
			self.Scroll:SetData(data)
		end)
		
	end
	-- 上拉加载演示
	self.Scroll.OnUp = function(this)
		local datas = self.Scroll:GetData();
		for i=1,10 do
			local data = {id=(#datas+1),name="名字"..(#datas+1)}
			self.Scroll:AppendData(data)
		end
		self.Scroll:Layout();
	end
	self.Scroll.SlideLeftToRight = function(this)
		-- 左滑
	end
	
	-- 加载数据演示
	local data = {}
	for i=1,500 do
		table.insert(data,{id=i,name="名字"..i})
	end
	self.Scroll:SetData(data)
--]]
