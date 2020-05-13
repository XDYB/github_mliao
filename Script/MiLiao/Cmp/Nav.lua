-- ============================================================
-- 标题栏组件
-- ============================================================
local kd = KDGame;
local gDef = GDefine;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

Nav = kd.inherit(kd.Layer);
local impl = Nav

local paddingLeft = 100 -- 左填充
local fontsize = 40 	-- 字体
local minScale = 1 		-- 最小缩放
local maxScale = 1.5 	-- 最大缩放
local padding = 150 	-- 间距
function impl:init(strs)
	-- 背景
	self.bg = kd.class(kd.Sprite,gDef:GetResPath("ResAll/Main.png"),1000,2010,1,1);
	self.bg:SetScale(ScreenW,gDef.TitleH)
	self:addChild(self.bg);
	self.bg:SetPos(ScreenW/2,gDef.TitleH/2);
	
	-- 文字
	self.posx = {}
	self.txts = {}
	self.guis = {}
	for i,v in ipairs(strs) do
		local w = gDef:GetTextLen(fontsize,v)
		self.txts[i] = kd.class(kd.StaticText,fontsize,strs[i],kd.TextHAlignment.CENTER, w+50, 100);
		self:addChild(self.txts[i]); 
		local x = (i-1)*padding+paddingLeft
		self.posx[i] = x
		self.txts[i]:SetPos(x, gDef.SysBarH+80);
		self.txts[i]:SetColor(0xff333333)
		self.guis[i] = gDef:AddGuiBySpr(self,self.txts[i],i,50,60,50,60)
		self.guis[i]:setDebugMode(false)
	end
	
	-- 线
	self.line = kd.class(kd.Sprite,gDef:GetResPath("ResAll/Main.png"),1716,468,44,10);
	self:addChild(self.line);
	self.line:SetPos(self.posx[1],gDef.SysBarH+100)
	
	self.index = 1 			-- 当前索引
	self.aniIndex = 2		-- 动画索引
	self.maxIndex = #strs 	-- 最大索引
	

--[[
	DC:RegisterCallBack("Home.Tab.offsetX",self,function(diffx)
		self:SetOffset(diffx)
	end)
	DC:RegisterCallBack("Home.Tab.OnIndexChange_",self,function(index)
		self:SetIndex(index+1)
	end)
	--]]
end

function impl:onGuiToucBackCall(id)
	self:SetIndex(id)
	if self.OnIndexChange then
--		DC:CallBack("Nav.OnIndexChange",id)
		self:OnIndexChange(id)
	end
	
end

-- =======================================================================
-- 								API	
-- =======================================================================
-- 设置索引
-- @index 索引值
function impl:SetIndex(index)
	if index == self.index then
		self.txts[self.index]:SetColor(0xff000000)
		TweenPro:Animate({
			{o=self.txts[self.index],scale=maxScale,d=200}
		});
		TweenPro:Animate({
			{o=self.line,x=self.posx[index],y=gDef.SysBarH+100,d=200,tween=TweenPro.swing.easeOutBack}
		});
		if self.aniIndex~= self.index then
			TweenPro:Animate({
				{o=self.txts[self.aniIndex],scale=minScale,d=200}
			});
		end
		
	else
		self.txts[self.index]:SetColor(0xff333333)
		TweenPro:Animate({
			{o=self.txts[self.index],scale=minScale,d=200}
		});
		self.index = index
		TweenPro:Animate({
			{o=self.line,x=self.posx[index],y=gDef.SysBarH+100,d=200,tween=TweenPro.swing.easeOutBack}
		});
		TweenPro:Animate({
			{o=self.txts[self.index],scale=maxScale,d=200}
		});
		self.txts[self.index]:SetColor(0xff000000)
		
		
	end
	
end
-- 无动画设置索引
function impl:SetIndexNoAni(index)
	if index == self.index then
		self.txts[self.index]:SetColor(0xff000000)
		self.txts[self.index]:SetScale(maxScale,maxScale)
		self.line:SetPos(self.posx[index],gDef.SysBarH+100)
		if self.aniIndex~= self.index then
			self.txts[self.aniIndex]:SetScale(minScale,minScale)
		end	
	else
		self.txts[self.index]:SetScale(minScale,minScale)
		self.index = index
		self.line:SetPos(self.posx[index],gDef.SysBarH+100)
		self.txts[self.index]:SetScale(maxScale,maxScale)
		self.txts[self.index]:SetColor(0xff000000)
	end
end

-- 设置偏移
-- @offsetfix 层的偏移量(0~ScreenW)
function impl:SetOffset(offsetfix)
	local offsetPercent = math.abs(offsetfix) / ScreenW -- 偏移百分比
	local scale1 = maxScale - (maxScale-minScale)*offsetPercent
	local scale2 = minScale + (maxScale-minScale)*offsetPercent
	local offsetX = math.floor(offsetPercent * padding) -- x偏移量
	self.txts[self.index]:SetScale(scale1,scale1)
	local _,y = self.line:GetPos()
	if offsetfix<0 then
		-- 向右
		if self.index<self.maxIndex then
			self.line:SetPos(self.posx[self.index]+offsetX,y)
			self.txts[self.index+1]:SetScale(scale2,scale2)
			self.aniIndex = self.index+1
		end
		
	elseif offsetfix>0 then
		-- 向左
		if self.index > 1 then
			self.line:SetPos(self.posx[self.index]-offsetX,y)
			self.txts[self.index-1]:SetScale(scale2,scale2)
			self.aniIndex = self.index-1
		end
		
	end
end

























--[[

-- 标题组件
local kd = KDGame;
local gDef = GDefine;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

Nav = kd.inherit(kd.Layer);
local impl = Nav

local paddingLeft = 30 -- 左填充
local fontsize = 50 -- 字体
local padding = 50 -- 间距
function impl:init(strs)
	
	self.posx = {}
	local totalW = paddingLeft
	for i,v in ipairs(strs) do
		local txtW = gDef:GetTextLen(fontsize,v)
		self.posx[i] = totalW+txtW//2
		totalW = totalW + padding+txtW
	end
	
	-- 背景
	self.bg = kd.class(kd.Sprite,gDef:GetResPath("ResAll/Main.png"),1000,2010,1,1);
	self.bg:SetScale(ScreenW,gDef.TitleH)
	self:addChild(self.bg);
	self.bg:SetPos(ScreenW/2,gDef.TitleH/2);
	-- 线
	self.line = kd.class(kd.Sprite,gDef:GetResPath("ResAll/Main.png"),1716,468,44,10);
	self:addChild(self.line);
	self.line:SetPos(self.posx[1],gDef.SysBarH+100)
	
	self.txts = {}
	self.guis = {}
	local totalW = paddingLeft
	for i,v in ipairs(strs) do
		self.txts[i] = kd.class(kd.StaticText,fontsize,strs[i],kd.TextHAlignment.LEFT, ScreenW, 100);
		local w = gDef:GetTextLen(fontsize,v)
		self:addChild(self.txts[i]); 
		self.txts[i]:SetPos(ScreenW/2+totalW, gDef.SysBarH+80);
		self.txts[i]:SetColor(0xff333333)
		totalW = totalW + w + padding
		
		self.guis[i] = kd.class(kd.GuiObjectNew, self, i,self.posx[i]-w//2 , 150, w, 50, false, true);
		self:addChild(self.guis[i])
--		self.guis[i]:setDebugMode(true);
	end
	
	self.index = 1 -- 当前索引
end

function impl:onGuiToucBackCall(id)
	self.txts[self.index]:SetScale(1,1)
	self.txts[self.index]:SetColor(0xff333333)
	self.index = id
	TweenPro:Animate({
		{o=self.line,x=self.posx[id],y=gDef.SysBarH+100,d=200}
	});
	self.txts[self.index]:SetScale(1.2,1.2)
	self.txts[self.index]:SetColor(0xff000000)
end

--]]