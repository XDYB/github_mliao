-- ============================================================
-- 首页-推荐-滑动幻灯片组件
-- ============================================================
local kd = KDGame;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
local gDef = GDefine;
Slide = kd.inherit(kd.Layer);
local impl = Slide

function impl:constr(self)
	self.m_nodes = {};
	self.m_index = 0;-- 默认索引 从0开始
	self.m_isCanChangeLock = true;-- 是否可以改变滑动方向
	
	self.pos = {}
	self.gui = {}
	self.maxIndex = 0
	self.t = 1000
end


function impl:init()
	self.layer = kd.class(kd.Layer,false,false)
	self:addChild(self.layer)
end

function impl:GetPos(x,y)
	return self.layer:GetPos()
end
function impl:SetPos(x,y)
	self.layer:SetPos(x,y)
end


function impl:SetPointIndex()
	for i,v in ipairs(self.sprOn) do
		v:SetVisible(false)
	end
	if self.sprOn[self.m_index+1] then
		self.sprOn[self.m_index+1]:SetVisible(true)
	end
	
end

function impl:AddNode(node)
	table.insert(self.m_nodes,node);
	local count = #self.m_nodes;
	local w,h = node:GetContainerWH();
	self.h = h
	local clipGui = kd.class(kd.GuiObjectNew, self, 1, 0, 0,w,h, false, false);
	clipGui:setRectClipping(0,0,w,h);
	clipGui:addChild(node);
	node:SetPos(w/2,h/2);
	self.layer:addChild(clipGui);
	local x,y = ScreenW*(count-1)+w/2,ScreenH/2
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
		self.gui[self.maxIndex]:SetPos(-ScreenW/2,ScreenH/2)
	end
	
	self:SetTimer(1,self.t,0xffffffff)
end


function impl:onGuiToucBackCall(--[[int]] id)
end

function impl:update(--[[float--]] delta)

end
function impl:OnTimerBackCall(--[[int--]] id)
	if id == 1 then
		self:SetIndex(self.m_index+1)
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
				if px > -(#self.m_nodes-1) * ScreenW then
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
				if diffx > ScreenW/4 then
					self.m_index = self.m_index-1
				end
			end
		else
			if self.m_index <= #self.m_nodes-1 then
				if math.abs(diffx) > ScreenW/4 then
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
			{o = self.layer,x=-self.m_index*ScreenW,y=py,d=300,tween=TweenPro.swing.easeOutCubic,fn = function()
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
			{o = self.layer,x=-self.m_index*ScreenW,y=py,d=300,tween=TweenPro.swing.easeOutCubic,fn = function()
				self.m_isCanChangeLock = true
				self:SetPointIndex()
			end}
		})
	end
	
end

function impl:CalPos()
	if self.maxIndex>2 then
		if self.m_index== -1 then
			self:ResetPos()
			self:SetIndexNoAni(self.maxIndex-1)-- 索引从0开始
			self.gui[1]:SetPos(self.pos[self.maxIndex].x+ScreenW,ScreenH/2)
			self.m_index = self.maxIndex-1
		elseif self.m_index==self.maxIndex then
			self:ResetPos()
			self:SetIndexNoAni(0)
			self.gui[self.maxIndex]:SetPos(-ScreenW/2,ScreenH/2)
			self.m_index = 0
		elseif self.m_index==0 then
			self.gui[self.maxIndex]:SetPos(-ScreenW/2,ScreenH/2)
		elseif self.m_index==self.maxIndex-1 then
			self.gui[1]:SetPos(self.pos[self.maxIndex].x+ScreenW,ScreenH/2)
		else
			self:ResetPos()
		end
	end
	self:SetPointIndex()
end

function impl:GetWH()
	return ScreenW,ScreenH
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
	local x = -self.m_index*ScreenW
	local y = py
	self.layer:SetPos(x,y)
end

-- 显示小圆点
function impl:ShowPoint()
	self.sprOn = {}
	self.sprOff = {}
	for i,v in ipairs(self.m_nodes) do
		self.sprOn[i] = kd.class(kd.Sprite,gDef:GetResPath("ResAll/Main.png"),1672, 456, 18, 18);
		self:addChild(self.sprOn[i])
		self.sprOn[i]:SetVisible(false)
		self.sprOff[i] = kd.class(kd.Sprite,gDef:GetResPath("ResAll/Main.png"),1692, 456, 18, 18);
		self:addChild(self.sprOff[i])
	end
	gDef:Layout(self.sprOn,ScreenW/2,self.h-20,20,2,0)
	gDef:Layout(self.sprOff,ScreenW/2,self.h-20,20,2,0)
	self:SetPointIndex()
end