-- ============================================================
-- 选项卡组件
-- 1. 首页选项卡
-- ============================================================
local kd = KDGame;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

Tab = kd.inherit(kd.Layer);
local impl = Tab

function impl:constr(self)
	self.m_nodes = {};
	self.m_index = 0;-- 默认索引 从0开始
	self.m_isCanChangeLock = true;-- 是否可以改变滑动方向
	
	self.isSendExScrollEvent = false
end

-- @y 区域y  
-- @isSprite 是否精灵
function impl:init(y,isSprite,CallBackStr)
	self.CallBackStr = CallBackStr and CallBackStr.."." or "" -- 回调标识 用于区分不同界面的回调
	self.m_isSprite = isSprite or false;
	self.y = y or 0
	--[[
	DC:RegisterCallBack("Nav.OnIndexChange",self,function(index)
		self:SetIndex(index-1)
	end)
	--]]
end

function impl:AddNode(node)
	table.insert(self.m_nodes,node);
	local count = #self.m_nodes;
	
	if self.m_isSprite then
		local w,h = node:GetContainerWH();
		local clipGui = kd.class(kd.GuiObjectNew, self, 1, 0, 0,w,h, false, false);
		clipGui:setRectClipping(0,0,w,h);
		clipGui:addChild(node);
		node:SetPos(w/2,h/2);

		self:addChild(clipGui);
		clipGui:SetPos(ScreenW*(count-1)+w/2,ScreenH/2);
	else
		self:addChild(node);
		node:SetPos(ScreenW*(count-1),ScreenH);

	end
	
end
function impl:onGuiToucBackCall(--[[int]] id)
end

function impl:update(--[[float--]] delta)

end
function impl:OnTimerBackCall(--[[int--]] id)
end
function impl:onTouchBegan(--[[float]] x, --[[float]] y)

	TweenPro:StopSingleAnimate(self.aniHandler)
	self.ontouchdownx = x;
	self.ontouchdowny = y;
	self.prex = x

	self.lock = self.m_isCanChangeLock and 0 or self.lock;
	
	DC:CallBack(self.CallBackStr.."Tab"..self.m_index..".onTouchBegan",x,y)
	
	-- 将事件传递给额外的节点
	self.isSendExScrollEvent = false
	
	local scrollH = 0 -- ScrollEx组件滚动偏移
	local exNodeH = 0 -- 额外的节点高度
	if self.m_nodes[self.m_index+1].GetScrollH then
		scrollH = self.m_nodes[self.m_index+1]:GetScrollH()
	end
	if self.m_nodes[self.m_index+1].GetScrollExNodeH then
		exNodeH = self.m_nodes[self.m_index+1]:GetScrollExNodeH()
	end
	
	
	-- 判断是否触发额外节点的点击事件
	local min = self.y-scrollH        -- 最小高度 - 滚动条偏移
	local max = self.y+exNodeH-scrollH-- 最小高度 + 节点高度 - 滚动条偏移
	if y>min and y<max then
		-- 将事件传递给额外节点
		self.isSendExScrollEvent = true
		DC:CallBack(self.CallBackStr.."ScrollExNode"..self.m_index..".onTouchBegan",x,y)
	end
	
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
		-- ==============================
		-- 垂直滚动
		-- ==============================
		DC:CallBack(self.CallBackStr.."Tab"..self.m_index..".onTouchMoved",x,y)
		self.isSendExScrollEvent = false
	elseif  self.lock == 1 then
		-- ==============================
		-- 水平滚动
		-- ==============================
		-- 判断是否将事件传递给Scroll中额外的节点
		if self.isSendExScrollEvent then
			DC:CallBack(self.CallBackStr.."ScrollExNode"..self.m_index..".onTouchMoved",x,y)
			self.m_isCanChangeLock = true
			return
		else
			self.isSendExScrollEvent = false
			local diffx = x - self.prex;
			if diffx>0 then
				-- 从左往右
				local px,py = self:GetPos();
				if px < 0 then
					local nowpx = px+diffx;
					self:SetPos(nowpx,py);
					self.prex = x		
					if self.OnOffSetX then
						self:OnOffSetX(x-self.ontouchdownx)
					end
--					DC:CallBack(self.CallBackStr.."Tab.offsetX",x-self.ontouchdownx)
				end
			else
				-- 从右往左
				local px,py = self:GetPos();
				if px > -(#self.m_nodes-1) * ScreenW then
					local nowpx = px+diffx;
					self:SetPos(nowpx,py);
					self.prex = x
					if self.OnOffSetX then
						self:OnOffSetX(x-self.ontouchdownx)
					end
--					DC:CallBack(self.CallBackStr.."Tab.offsetX",x-self.ontouchdownx)
				end
			end
		end

	end

end

function impl:onTouchEnded(--[[float]] x, --[[float]] y)
	-- 将事件传递给额外的节点
	if self.isSendExScrollEvent then
		DC:CallBack(self.CallBackStr.."ScrollExNode"..self.m_index..".onTouchEnded",x,y)
		self.m_isCanChangeLock = true
		return
	end
	
	if self.lock == 2 then
		-- ==============================
		-- 垂直滚动
		-- ==============================
		DC:CallBack(self.CallBackStr.."Tab"..self.m_index..".onTouchEnded",x,y)
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
				if diffx > ScreenW/5 then
					self.m_index = self.m_index-1
					DC:CallBack(self.CallBackStr.."Tab.OnIndexChange",self.m_index)
				end
			end
		else
			if self.m_index < #self.m_nodes-1 then
				if math.abs(diffx) > ScreenW/5 then
					self.m_index = self.m_index + 1
					DC:CallBack(self.CallBackStr.."Tab.OnIndexChange",self.m_index)
				end
			end
		end
		
		if self.OnIndexChanged then
			self:OnIndexChanged(self.m_index)
		end
--		DC:CallBack(self.CallBackStr.."Tab.OnIndexChange_",self.m_index) -- 有可能未改变值
		-- 更新位置
		self:updatePos();
	elseif self.lock == 0 then
		-- ==============================
		-- 点击
		-- ==============================
		DC:CallBack(self.CallBackStr.."Tab"..self.m_index..".onTouchEnded",x,y)
	end
	
	
end


function impl:updatePos()
	local px,py = self:GetPos();

	self.aniHandler = TweenPro:Animate({
		{o = self,x=-self.m_index*ScreenW,y=py,d=300,tween=TweenPro.swing.easeOutCubic,fn = function()
			self.m_isCanChangeLock = true
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
	self:updatePos();
end
-- 无动画切换索引
function impl:SetIndexNoAni(index)
	self.m_index = index;
	local _,py = self:GetPos();
	self:SetPos(-self.m_index*ScreenW,py)

end

