-- ============================================================
-- 新选项卡组件NTab 使用回调函数取代Tab中的数据中心 支持多层嵌套的事件传递 
-- 注意：索引从0开始
-- 应用：排行榜 视频派对
-- ============================================================
local kd = KDGame;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

NTab = kd.inherit(kd.Layer);
local impl = NTab

function impl:constr(self)
	self.m_nodes = {};
	self.m_index = 0;-- 默认索引 从0开始
	self.m_isCanChangeLock = true;-- 是否可以改变滑动方向
	self.m_isHoldUpEvent = false  -- 是否拦截事件
	self.m_isOverDrag = false	  -- 是否跨选项拖动 跨大选项需忽略拦截函数的返回值
	self.m_isHandlerLongDown = false-- 是否响应长按事件 触发长按则不再响应点击
end

function impl:SetOffY(y)
	self.offy = y
end

-- @offy y偏移
function impl:init(offy)
	self.offy = offy or 0
end

function impl:AddNode(node)
	table.insert(self.m_nodes,node);
	local count = #self.m_nodes;
	self:addChild(node);
	node:SetPos(ScreenW*(count-1),ScreenH);
	-- 性能优化 并不显示所有的选项 (存在的问题 当通过标题跳跃式的切换选项卡时，后面的选项还来不及显示 所以会出现空白现象)
	--[[
	if count>2 then
		node:SetVisible(false)
	end
	--]]
end
function impl:onGuiToucBackCall(--[[int]] id)
end

function impl:update(--[[float--]] delta)

end
function impl:OnTimerBackCall(--[[int--]] id)
	if id == 1 then
		if self.OnLongDown then
			self.m_isHandlerLongDown = true
			self:OnLongDown(self:GetNode(),self.ontouchdownx,self.ontouchdowny)
		end
	end
end
function impl:onTouchBegan(--[[float]] x, --[[float]] y)
	if y<self.offy then
		return false
	end
	TweenPro:StopSingleAnimate(self.aniHandler)
	self.ontouchdownx = x;
	self.ontouchdowny = y;
	self.prex = x

	self.lock = self.m_isCanChangeLock and 0 or self.lock;
	self.m_isHandlerLongDown = false
	self.m_isHoldUpEvent = false
	self.m_isOverDrag = false
	self.ondowntime = os.time()
	self:SetTimer(1,1000,1)
	if self.OnDown then self:OnDown(self:GetNode(),x,y) end
end
function impl:onTouchMoved(--[[float]] x, --[[float]] y)
	if self.m_isCanChangeLock and self.lock == 0 then
		if math.abs(x - self.ontouchdownx) > 50 then
			self.lock = 1 -- 水平滑动 
			self.m_isCanChangeLock = false

		elseif math.abs(y - self.ontouchdowny) > 50 then
			self.lock = 2 -- 垂直滑动
		end
	end
	if self.lock == 2 then
		self:KillTimer(1);
		-- ==============================
		-- 垂直滚动
		-- ==============================

		if self.OnRoll then
			self:OnRoll(self:GetNode(),x,y)
		end
	elseif  self.lock == 1 then
		self:KillTimer(1);
		-- ==============================
		-- 水平滚动
		-- ==============================
		local diffx = x - self.prex;
		local px,py = self:GetPos();
		local sp = function()
			local nowpx = px+diffx;
			self:SetPos(nowpx,py);
			self.prex = x		

			if self.OnHMove then
				self:OnHMove(x-self.ontouchdownx)
			end
		end
		if diffx>0 then
			-- 从左往右(向左滑)
			if self.m_isOverDrag then
				if px < 0 then
					sp()
				end
			else
				if self.IsHoldToLeft then
					local rt = self:IsHoldToLeft(self:GetNode())
					self.m_isHoldUpEvent = rt
					if rt then
						self:ToLeft(self:GetNode(),x,y)
					else
						if px < 0 then
							self.m_isOverDrag = true
							sp()
						end
					end
				else
					if px < 0 then
						sp()
					end
				end
			end
			
		else
			-- 从右往左(向右滑)
			if self.m_isOverDrag then
				if px > -(#self.m_nodes-1) * ScreenW then
					sp()
				end
			else
				if self.IsHoldToRight then
					local rt = self:IsHoldToRight(self:GetNode())
					self.m_isHoldUpEvent = rt
					if rt then
						self:ToRight(self:GetNode(),x,y)
					else
						if px > -(#self.m_nodes-1) * ScreenW then
							self.m_isOverDrag = true
							sp()
						end
					end
				else
					if px > -(#self.m_nodes-1) * ScreenW then
						sp()
					end
				end
			end
		end
	end
end

function impl:onTouchEnded(--[[float]] x, --[[float]] y)
	self:KillTimer(1);
	if self.m_isHoldUpEvent then
		self.m_isCanChangeLock = true
		if self.OnUp then
			self:OnUp(self:GetNode(),x,y)
		end
	else
		
		if self.lock == 2 then
			-- ==============================
			-- 垂直滚动
			-- ==============================
			self.m_isCanChangeLock = true
			if self.OnUp then
				self:OnUp(self:GetNode(),x,y)
			end
		elseif self.lock == 1 then
			-- ==============================
			-- 水平滚动
			-- ==============================
			local px,py = self:GetPos();
			local diffx = x - self.ontouchdownx
			local forward = diffx > 0 and 1 or -1
			local tmpIndex = self.m_index
			if forward>0 then
				-- 从左往右滑动
				if self.m_index > 0 then
					if diffx > ScreenW/4 then
						self.m_index = self.m_index-1

						if self.OnChangeing then
							self:OnChangeing(self.m_index)
						end
					end
				end
			else
				if self.m_index < #self.m_nodes-1 then
					if math.abs(diffx) > ScreenW/4 then
						self.m_index = self.m_index + 1

						if self.OnChangeing then
							self:OnChangeing(self.m_index)
						end
					end
				end
			end
			if self.OnChangeAfter then
				self:OnChangeAfter(self.m_index)-- 有可能未改变值
			end
			local isIndexChange = false -- 索引是否改变
			if tmpIndex~=self.m_index then
				isIndexChange = true
			end
			-- 更新位置
			self:updatePos(isIndexChange);
		elseif self.lock == 0 then
			-- ==============================
			-- 点击
			-- ==============================
			self.m_isCanChangeLock = true
			if self.m_isHandlerLongDown == false then
				if self.OnUp then
					self:OnUp(self:GetNode(),x,y)
				end
			end
			
		end
	end
	
	
	
	
end


function impl:updatePos(isIndexChange)
	local px,py = self:GetPos();

	self.aniHandler = TweenPro:Animate({
		{o = self,x=-self.m_index*ScreenW,y=py,d=300,tween=TweenPro.swing.easeOutCubic,fn = function()
			self.m_isCanChangeLock = true
			if isIndexChange then
				if self.OnChangeComplete then
					self:OnChangeComplete(self.m_index)
				end
			end
			--[[
			-- ==============================================
			-- 性能优化 START
			-- ==============================================
			if #self.m_nodes>2 then
				if self.m_index==0 then
					for i,v in ipairs(self.m_nodes) do
						v:SetVisible(false)
					end
					self.m_nodes[1]:SetVisible(true)
					self.m_nodes[2]:SetVisible(true)
				elseif self.m_index==(#self.m_nodes-1) then
					for i,v in ipairs(self.m_nodes) do
						v:SetVisible(false)
					end
					self.m_nodes[#self.m_nodes]:SetVisible(true)
					self.m_nodes[#self.m_nodes-1]:SetVisible(true)
				else
					for i,v in ipairs(self.m_nodes) do
						v:SetVisible(false)
					end
					self.m_nodes[self.m_index]:SetVisible(true)
					self.m_nodes[self.m_index+1]:SetVisible(true)
					self.m_nodes[self.m_index+2]:SetVisible(true)
				end
			end
			-- ==============================================
			-- 性能优化 END
			-- ==============================================
			--]]
		end}
	})

end

function impl:GetWH()
	return ScreenW,ScreenH
end


-- ===========================================================================
-- 								API
-- ===========================================================================
function impl:SetIndex(index)
	self.m_index = index;
	self:updatePos(true);
end
function impl:GetIndex()
	return self.m_index
end
-- 无动画切换索引
function impl:SetIndexNoAni(index)
	self.m_index = index;
	local _,py = self:GetPos();
	self:SetPos(-self.m_index*ScreenW,py)

end
-- 最大索引
function impl:MaxIndex()
	return #self.m_nodes-1 -- 索引从0开始
end

-- 获取当前项
function impl:GetNode()
	return self.m_nodes[self.m_index+1]
end