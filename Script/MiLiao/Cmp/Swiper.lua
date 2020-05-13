-- ============================================================
-- 可循环滚动缩放的选项卡组件
-- ============================================================
local kd = KDGame;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
local gDef = GDefine;
Swiper = kd.inherit(kd.Layer);
local impl = Swiper

local SlideW = ScreenW - 100

function impl:constr(self)
	self.m_nodes = {};
	self.m_index = 0;-- 默认索引 从0开始
	self.m_isCanChangeLock = true;-- 是否可以改变滑动方向
	
	self.pos = {}
	self.gui = {}
	self.maxIndex = 0
	self.t = 1000
end


function impl:init(h)
	self.h = h
	self.layer = kd.class(kd.Layer,false,false)
	self:addChild(self.layer)
end

function impl:GetPos(x,y)
	return self.layer:GetPos()
end
function impl:SetPos(x,y)
	self.layer:SetPos(x,y)
end



function impl:AddNode(node)
	table.insert(self.m_nodes,node);
	local count = #self.m_nodes;
	local w,h = node:GetContainerWH();
	local clipGui = kd.class(kd.GuiObjectNew, self, 1, 0, 0,w,h, false, false);
	clipGui:setRectClipping(0,0,w,h);
	clipGui:addChild(node);
	node:SetPos(w/2,h/2);
	self.layer:addChild(clipGui);
	local x,y = SlideW*(count-1)+w/2,ScreenH/2
	clipGui:SetPos(x,y);
	table.insert(self.pos,{x=x,y=y})
	table.insert(self.gui,clipGui)
	
	
end

-- 复原位置
function impl:ResetPos()
	for i,v in ipairs(self.gui) do
		v:SetPos(self.pos[i].x,self.pos[i].y)
	end
end

function impl:AddComplete(t)
	self.t = t
	self.maxIndex = #self.gui
	if self.maxIndex>2 then
		self.gui[self.maxIndex]:SetPos(-SlideW/2+50,ScreenH/2)
	end
	
	self:SetTimer(1,self.t,0xffffffff)
end


function impl:onGuiToucBackCall(--[[int]] id)
end

function impl:update(--[[float--]] delta)

end
function impl:OnTimerBackCall(--[[int--]] id)
	if id == 1 then
--		self:SetIndex(self.m_index+1)
	end
end



function impl:onTouchBegan(--[[float]] x, --[[float]] y)
	self:KillTimer(1);
	TweenPro:StopSingleAnimate(self.layer)
	
	
	self.ontouchdownx = x;
	self.ontouchdowny = y;
	self.prex = x

	self.lock = self.m_isCanChangeLock and 0 or self.lock;
	
	
	
	self:CalPos()
end


function impl:onTouchMoved(--[[float]] x, --[[float]] y)
	if self.m_isCanChangeLock and self.lock == 0 then
		if math.abs(x - self.ontouchdownx) > 20 then
			self.lock = 1 -- 水平滑动 
			self.m_isCanChangeLock = false
		elseif math.abs(y - self.ontouchdowny) > 20 then
			self.lock = 2 -- 垂直滑动
		end
	end
	if self.lock == 2 then
		-- ==============================
		-- 垂直滚动
		-- ==============================

	elseif  self.lock == 1 then
		-- ==============================
		-- 水平滚动
		-- ==============================
		local diffx = x - self.prex;
		local offsetx = x - self.ontouchdownx
		if self.OnScroll then
			self.OnScroll(offsetx)
		end
		if diffx>0 then
			-- 从左往右
			local px,py = self:GetPos();
			if self.maxIndex>2 then
				local nowpx = px+diffx;
				self:SetPos(nowpx,py);
				self.prex = x		
			else
				if px < 0 then
					local nowpx = px+diffx;
					self:SetPos(nowpx,py);
					self.prex = x		
				end
			end

		else
			-- 从右往左
			local px,py = self:GetPos();
			if self.maxIndex>2 then
				local nowpx = px+diffx;
				self:SetPos(nowpx,py);
				self.prex = x
			else
				if px > -(#self.m_nodes-1) * SlideW then
					local nowpx = px+diffx;
					self:SetPos(nowpx,py);
					self.prex = x
				end
			end

		end
		
	end
end

function impl:onTouchEnded(--[[float]] x, --[[float]] y)
	if self.lock == 2 then
		-- ==============================
		-- 垂直滚动
		-- ==============================
	elseif self.lock == 1 then
		-- ==============================
		-- 水平滚动
		-- ==============================
		local px,py = self:GetPos();
		local diffx = x - self.ontouchdownx
		local forward = diffx > 0 and 1 or -1
		if forward>0 then
			-- 从左往右滑动
			if self.m_index >= 0 then
				if diffx > SlideW/4 then
					self.m_index = self.m_index-1
				end
			end
		else
			if self.m_index <= #self.m_nodes-1 then
				if math.abs(diffx) > SlideW/4 then
					self.m_index = self.m_index + 1
				end
			end
		end
		self:SetTimer(1,self.t,0xffffffff)
		-- 更新位置
		self:updatePos();
	elseif self.lock == 0 then
		-- ==============================
		-- 点击
		-- ==============================
		if self.OnClick then
			self:OnClick(self.m_index)
		end
	end
end

function impl:updatePos()
	if self.maxIndex>2 then
		
		local px,py = self:GetPos();
		TweenPro:Animate({
			{o = self.layer,x=-self.m_index*SlideW,y=py,d=300,tween=TweenPro.swing.easeOutCubic,fn = function()
				self.m_isCanChangeLock = true
				self:CalPos()
			end}
		})
		
	else
		if self.m_index==-1 then
			self.m_index = 0 
		elseif self.m_index==self.maxIndex then
			self.m_index = self.maxIndex-1 
		end
		local px,py = self:GetPos();
		TweenPro:Animate({
			{o = self.layer,x=-self.m_index*SlideW,y=py,d=300,tween=TweenPro.swing.easeOutCubic,fn = function()
				self.m_isCanChangeLock = true
			end}
		})
	end
	
end

function impl:CalPos()
	if self.maxIndex>2 then
		if self.m_index== -1 then
			self:ResetPos()
			self:SetIndexNoAni(self.maxIndex-1)-- 索引从0开始
			self.gui[1]:SetPos(self.pos[self.maxIndex].x+SlideW,ScreenH/2)
			self.m_index = self.maxIndex-1
		elseif self.m_index==self.maxIndex then
			self:ResetPos()
			self:SetIndexNoAni(0)
			self.gui[self.maxIndex]:SetPos(-SlideW/2+50,ScreenH/2)
			self.m_index = 0
		elseif self.m_index==0 then
			self.gui[self.maxIndex]:SetPos(-SlideW/2+50,ScreenH/2)
		elseif self.m_index==self.maxIndex-1 then
			self.gui[1]:SetPos(self.pos[self.maxIndex].x+SlideW,ScreenH/2)
		else
			self:ResetPos()
		end
	end
end

function impl:GetWH()
	return SlideW,self.h
end


-- ===========================================================================
-- 								API
-- ===========================================================================
function impl:SetIndex(index)
	if self.maxIndex>2 then
		self.m_index = index;
		self:updatePos();
	else
		if index>self.maxIndex-1 then 
			self.m_index=0 
		else
			self.m_index = index;
		end
		self:updatePos();
	end

end
function impl:SetIndexNoAni(index)
	self.m_index = index;
	local px,py = self:GetPos();
	local x = -self.m_index*SlideW
	local y = py
	self.layer:SetPos(x,y)
end
