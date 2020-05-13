-- ============================================================
-- 常规滚动视图组件
-- 更详细的说明：不支持在组件中嵌套其他组件比如选项卡
-- 推荐有限的子元素使用本组件，需要手动创建每一项，性能一般
-- 需要无限的子元素请使用ScrollEx 
-- ============================================================

local kd = KDGame;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
local TweenPro = TweenPro
local iphonex = kd.SceneSize.ratio <= 0.5
local gSink = _ViewStart;
ScrollA = kd.class(kd.Layer);
local impl = ScrollA
function impl:init(x,y,w,h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.realHeight = 0-- 实际高度
	self.posHeight = 0 -- 定位高度(影响垂直布局)
	self.tempWidth = 0 -- 临时宽度(影响水平布局)
	self.nodes = {}
	
	self.guilayer = kd.class(kd.GuiObjectNew,self,1,x,y,w,h);
--	self.guilayer:setDebugMode(true)
	self.guilayer:setRectClipping(x,y,w,h);
	self:addChild(self.guilayer);
	self.layer = kd.class(kd.Layer,false,false);
	self.guilayer:addChild(self.layer);
	
	-- 底部提示文字
	self.bottomTextH = 0
	self.txtBottom = kd.class(kd.StaticText,40,"",kd.TextHAlignment.CENTER,ScreenW,40);
	self.txtBottom:SetColor(0xff333333)
	self.layer:addChild(self.txtBottom)
	self.txtBottom:SetVisible(false)
	
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
	

	self.min = 0
	self.max = 0
	
	-- ====================================
	-- 解决：避免滑动过程中点击触发事件
	-- ====================================
	self.isMoveing = false 	 -- 是否滚动中
	self.isClickAble = false -- 是否可点击
end

function impl:SetMinMax(min,max)
	self.min = min
	self.max = max
end
function impl:CalMiny()
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


function impl:onTouchBegan(--[[float]] x, --[[float]] y)
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
	
end


	
function impl.clock()
	return os.clock() * 1000 -- 秒
end
function impl:onTouchMoved(--[[float]] x, --[[float]] y)
	if not self.isStarted then
		return
	end
	
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
	local now = self.clock();
	if now - self.startTime > self.momentumTimeThreshold then
		self.momentumStartY = self.offsetY;
		self.startTime = now;
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

end


function impl:onTouchEnded(--[[float]] x, --[[float]] y)
	

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
							-- 点击了空白区域
							if height>fy then
								return 
							end
						end
						if index > 0 then
							self:OnClick(index,self.nodes[index])
							index = 0
						end
					end
				end
			end
			
			
			
		end
	end


	
end

function impl:update(delta)
	if self.sprLoadRot then
		self.sprLoadRot = self.sprLoadRot>360 and 0 or self.sprLoadRot + 2
		self.sprLoad:SetRotation(self.sprLoadRot)
	end
	
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
--		destination = math.min(self.maxY + maxOverflowY, self.maxY + overflowY / bounceRate);
	elseif (destination < self.minY) then
		overflowY = self.minY - destination;
		swingfn = overflowY > bounceThreshold and 'strongBounce' or 'weekBounce';
		destination = self.minY
--		destination = math.max(self.minY - maxOverflowY, self.minY - overflowY / bounceRate);
	end

	return {destination = destination,duration=durationMap[swingfn],bezier=bezierMap[swingfn]};
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
function impl:Add_Ani(item,enumAddAni)
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
function impl:DelByIndex_Ani(index)
	local item = table.remove(self.nodes,index)
	local w,h= item:GetWH()
	TweenPro:DelNode(item) -- 非常重要(防止崩溃) 标记C层对象已经被移除 动画将被忽略
	TweenPro:Animate({
		{o = item,x=-ScreenW,fn = function()
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
		end}
	})
	
	
	
end

-- 重新排列
function impl:Layout()
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
	if self.upload then
		self:SetUpLoadPos()
	end
end

-- 添加项
function impl:Add(item)
	
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
	if self.upload then
		self:SetUpLoadPos()
	end
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
		if v.Cls then
			v:Cls()
		end
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
function impl:BackPos()
	if self.state == "down" then
		TweenPro:Animate({
			{o=self.layer,y=self.maxY,speed_bezier=self.bezier,fn = function()
				if self.download then
					self.download:StopRot()
					self.download:UpdateTime()
				end
			end}
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
function impl:BackTop()
	TweenPro:Animate({
		{o=self.layer,y=self.maxY,speed_bezier={.25, .46, .45, .94}}
	});
end
function impl:BackTopNoAni()
	self.layer:SetPos(0,self.maxY)
end
-- 复位到底部
function impl:BackBottom()
	TweenPro:Animate({
		{o=self.layer,y=self.minY,speed_bezier={.25, .46, .45, .94}}
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
	self.m_draw:DrawLine(point1,point2 , 5, color);
	-- 右
	self.m_draw:DrawLine(point2,point3 , 5, color);
	-- 下
	self.m_draw:DrawLine(point3,point4 , 5, color);
	-- 左
	self.m_draw:DrawLine(point4,point1 , 5, color);

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

-- 显示上拉等待
function impl:ShowUpLoad(spr)
	self.sprLoadRot = 1
	self.layer:addChild(spr)
	self.sprLoad=spr
end
-- 隐藏上拉等待
function impl:HideUpLoad()
	if self.sprLoad then
		self.layer:addChild(self.sprLoad)
		self.sprLoadRot = nil
		self.sprLoad = nil
	end
end
-- =====================================================================
--
--								加载等待		
-- 						
-- =====================================================================
-- 下拉加载等待
function impl:AddDownLoad(clazz)
	self.download = kd.class(clazz,true,false)
	self.download:init()
	self.layer:addChild(self.download)
	local _,h = self.download:GetWH()
	self.download:SetPos(0,ScreenH+self.y-h)
end

-- 上拉加载等待
function impl:AddUpLoad(clazz)
	self.upload = kd.class(clazz,true,false)
	self.upload:init()
	self.layer:addChild(self.upload)
	local _,h = self.upload:GetWH()
	if self.realHeight<self.h then
		self.upload:SetPos(0,ScreenH+self.y+h+self.h)
	else
		self.upload:SetPos(0,ScreenH+self.y+h+self.realHeight)
	end
	
end
function impl:SetUpLoadPos()
	local _,h = self.upload:GetWH()
	if self.realHeight<self.h then
		self.upload:SetPos(0,ScreenH+self.y+h/2+self.h)
	else
		self.upload:SetPos(0,ScreenH+self.y+h/2+self.realHeight)
	end
end

function impl:NoMore()
	self.upload:NoMore()
end
function impl:Cls()
	self:BackTop()
	self.upload:Cls()
	self.offsetY = ScreenH
end

-- 设置底部文字显示
function impl:SetTxtBottomPos()
	self.bottomTextH = 150
	self.txtBottom:SetPos(ScreenW/2,self.y+self.realHeight-self.bottomTextH/2+120)
end
-- 显示底部文字
function impl:ShowBottomText(str)
	self.txtBottom:SetString(str)
	self.txtBottom:SetVisible(true)
	self:SetTxtBottomPos()
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
