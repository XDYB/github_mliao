-- ============================================================
-- ��ת��ScrollA ������Ƶͨ����������
-- ============================================================

local kd = KDGame;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
local TweenPro = TweenPro
local iphonex = kd.SceneSize.ratio <= 0.5
local gSink = _ViewStart;
ScrollRevA = kd.class(kd.Layer);
local impl = ScrollRevA
function impl:init(x,y,w,h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.realHeight = 0-- ʵ�ʸ߶�
	self.posHeight = 0 -- ��λ�߶�(Ӱ�촹ֱ����)
	self.tempWidth = 0 -- ��ʱ���(Ӱ��ˮƽ����)
	self.nodes = {}
	self.marginTop = 0 -- �ϼ��
	self.guilayer = kd.class(kd.GuiObjectNew,self,1,x,y,w,h);
	self.guilayer:setDebugMode(true)
	self.guilayer:setRectClipping(x,y,w,h);
	self:addChild(self.guilayer);
	self.layer = kd.class(kd.Layer,false,false);
	self.guilayer:addChild(self.layer);
	
	-- ����״̬ "down" "up"
	self.state = "normal" 
	
	-- �����Ż�
	self.isOptimize = true
	self.OptimizeCount = 15 -- �������Ż�ʱ����ʾ�Ľڵ�������Ĭ��15�����С�ˣ���Ҫ�ֶ�����
	
	-- ���Թ���
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
	self.pointY = y;
	self.momentumStartY = self.offsetY
	self.startY = self.offsetY
	self.startTime = self.clock()
	
end


	
function impl.clock()
	return os.clock() * 1000 -- ��
end
function impl:onTouchMoved(--[[float]] x, --[[float]] y)
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
	-- ��ֱ����
	-- ==============================
	if (not self.isStarted) then return end;
	self.isStarted = false;
	-- ======================================================
	-- �����߽�ص�
	-- ======================================================
	if (self:isNeedReset()) then
		
		self.ex,self.ey = self.layer:GetPos();
		local setfixy = 180 -- ����������������ƫ����
		-- ==============================
		-- �����¼�
		-- ==============================
		if self.OnDown and self.ey>self.maxY and math.abs(self.ey-self.maxY)>setfixy then
			-- ����״̬
			self.state = "down"
			-- ������ͣ
			self.offsetY = self.offsetY +setfixy
			if self.download then
				self.download:StartRot()
			end
		-- ==============================
		-- �����¼�
		-- ==============================
		elseif self.OnUp and self.ey<self.minY and math.abs(self.ey-self.minY)>setfixy  then
			-- ����״̬
			self.state = "up"
			-- ������ͣ
			self.offsetY = self.offsetY -setfixy
			if self.upload then
				self.upload:StartRot()
			end
		end
		-- ��λ
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
	-- δ�����߽�
	-- ======================================================
	else
		local absDeltaY = math.abs(self.offsetY - self.momentumStartY);
		local duration = self.clock() - self.startTime;

		-- ====================�й���=====================
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

		-- ====================�޹���=====================
		else
			if self.OnClickAny then self:OnClickAny() end
			self.ex,self.ey = self.layer:GetPos();
			-- ==============================
			-- ����¼�
			-- ==============================
			if math.abs(x-self.downX)<20 
			and math.abs(self.ey-self.by)<20
			and y>=self.y  
			and y<=self.y+self.h
			then
				if self.OnClick then
					local fy = math.abs(self.ey-ScreenH) + (y-self.y) 	-- ��������y����
					local fx = x - self.x								-- ��������x����
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

--		local screeny = y-ScreenH - scrolly ��Ԫ�ص�ǰ��Ļ��������
			

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
		destination = math.min(self.maxY + maxOverflowY, self.maxY + overflowY / bounceRate);
	elseif (destination < self.minY) then
		overflowY = self.minY - destination;
		swingfn = overflowY > bounceThreshold and 'strongBounce' or 'weekBounce';
		destination = self.minY
		destination = math.max(self.minY - maxOverflowY, self.minY - overflowY / bounceRate);
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

-- ��������
function impl:Layout()
	
	self.posHeight = 0
	self.realHeight = 0
	self.tempWidth = 0
	local lastH = 0 -- ���һ��Ԫ�ظ߶�
	for i,v in ipairs(self.nodes) do
		local w,h = v:GetWH()
		lastH = h
		local x = self.x+self.tempWidth
		local y = ScreenH+self.y+self.posHeight
		-- ��������� ��һ��
		if self.tempWidth+2*w>self.w then
			self.posHeight = self.posHeight + h
			self.tempWidth = 0
		else
			self.tempWidth = self.tempWidth + w
		end
		v:SetPos(x,y);
	end
	if self.tempWidth==0 then
		self.realHeight = self.posHeight -- ʵ�ʸ߶�
	else
		self.realHeight = self.posHeight + lastH -- ʵ�ʸ߶�
	end
	self:CalMiny()
end

-- �����
function impl:Add(item)
	local w,h = item:GetWH()
	self.layer:addChild(item)
	local x = self.x+self.tempWidth
	local y = ScreenH+self.y+self.posHeight
	-- ��������� ��һ��
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
		self.realHeight = self.posHeight -- ʵ�ʸ߶�
	else
		self.realHeight = self.posHeight + h -- ʵ�ʸ߶�
	end
	
	self:CalMiny()
end
-- ɾ����
-- @index �±�
function impl:DelByIndex(index)
	local item = table.remove(self.nodes,index)
	local w,h= item:GetWH()
	TweenPro:DelNode(item)
	self.layer:RemoveChild(item)
	self:Layout()
end

function impl:DelByItem(item)
	for i,v in ipairs(self.nodes) do
		if v == item then
			local item1 = table.remove(self.nodes,i)
			local w,h= item1:GetWH()
			TweenPro:DelNode(item1)
			self.layer:RemoveChild(item1)
			self:Layout()
			break;
		end
	end
	
end

-- ɾ������
function impl:DelAll()
	for i,v in ipairs(self.nodes) do
		-- 1 ��ֹͣ����
		TweenPro:DelNode(v)
		-- 2 ��ɾ��
		self.layer:RemoveChild(v)
	end
	self.nodes = {}
	self.posHeight = 0
	self:Layout()
end
-- ��λ��������������λ(������[�հ�]��[����ʱ]����)
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
-- ��λ������
function impl:BackTop()
	TweenPro:Animate({
		{o=self.layer,y=self.maxY,speed_bezier={.25, .46, .45, .94}}
	});
end
-- ��λ���ײ�
function impl:BackBottom()
	TweenPro:Animate({
		{o=self.layer,y=self.minY,speed_bezier={.25, .46, .45, .94}}
	});
end
-- ��ʾ�߽�
function impl:ShowBorder()
	--[[
	self.m_draw = kd.class(kd.GeometryDraw);
	self:addChild(self.m_draw);
	local color = 0xff337AB7
	local point1 = {x=self.x,y=ScreenH-self.y}
	local point2 = {x=self.x+self.w,y=ScreenH-self.y}
	local point3 = {x=self.x+self.w,y=ScreenH-(self.y+self.h)}
	local point4 = {x=self.x,y=ScreenH-(self.y+self.h)}
	-- ��
	self.m_draw:DrawLine(point1,point2 , 1, color);
	-- ��
	self.m_draw:DrawLine(point2,point3 , 1, color);
	-- ��
	self.m_draw:DrawLine(point3,point4 , 1, color);
	-- ��
	self.m_draw:DrawLine(point4,point1 , 1, color);
	--]]
end
-- ���������Ż�(Ĭ��) ���������Ż�ֻ��ʾ��Ļһ�������ڵĽڵ㣬���Դ����ٶ������������֡��
function impl:OpenOptimize()
	self.isOptimize =  true
end
-- (Test)�رչ����Ż� ���ǽ����еĽڵ�����Ϊ�ɼ�״̬ Ԫ�ع���ή��֡��
function impl:CloseOptimize()
	self.isOptimize =  false
end
-- �Ż����� һ����Χ����ʾ����Ԫ�ظ��� һ��Ԫ�ع���ʱ ����ø÷����ֶ����� Ĭ��15
function impl:SetOptimizeCount(c)
	self.OptimizeCount = c
end

-- �����±��ȡ�ڵ�
function impl:GetItemByIndex(i)
	return self.nodes[i]
end
-- ��ȡ���нڵ�
function impl:GetItems()
	return self.nodes
end
-- ����ID��ѯ�ڵ�
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

-- ��ʾ�����ȴ�
function impl:ShowUpLoad(spr)
	self.sprLoadRot = 1
	self.layer:addChild(spr)
	self.sprLoad=spr
end
-- ���������ȴ�
function impl:HideUpLoad()
	if self.sprLoad then
		self.layer:addChild(self.sprLoad)
		self.sprLoadRot = nil
		self.sprLoad = nil
	end
end
-- =====================================================================
--
--								���صȴ�		
-- 						
-- =====================================================================
-- �������صȴ�
function impl:AddDownLoad(clazz)
	self.download = kd.class(clazz,true,false)
	self.download:init()
	self.layer:addChild(self.download)
	local _,h = self.download:GetWH()
	self.download:SetPos(0,ScreenH+self.y-h)
end

-- �������صȴ�
function impl:AddUpLoad(clazz)
	self.upload = kd.class(clazz,true,false)
	self.upload:init()
	self.layer:addChild(self.upload)
	local _,h = self.upload:GetWH()
	self.upload:SetPos(0,ScreenH+self.y+h+self.realHeight)
end
function impl:SetUpLoadPos()
	local _,h = self.upload:GetWH()
	self.upload:SetPos(0,ScreenH+self.y+h/2+self.realHeight)
end
function impl:SetUpLoadPos()
	local _,h = self.upload:GetWH()
	self.upload:SetPos(0,ScreenH+self.y+h/2+self.realHeight)
end
function impl:NoMore()
	self.upload:NoMore()
end