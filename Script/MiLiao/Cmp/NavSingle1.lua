-- ============================================================
-- 标题栏组件(无缩放)
-- ============================================================
local kd = KDGame;
local gDef = GDefine;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

NavSingle1 = kd.inherit(kd.Layer);
local impl = NavSingle1

local paddingLeft = 80 -- 左填充
local fontsize = 38 	-- 字体
local padding = ScreenW//7; 	-- 间距
local color = 0xffBFBFBF
function impl:init(strs,father)
	self.m_father = father;
	-- 背景
	--[[
	self.bg = kd.class(kd.Sprite,gDef:GetResPath("ResAll/Main.png"),1000,2010,1,1);
	self.bg:SetScale(ScreenW,gDef.TitleH)
	self:addChild(self.bg);
	self.bg:SetPos(ScreenW/2,gDef.TitleH/2);
	--]]
	
	-- 文字
	self.posx = {}
	self.txts = {}
	self.guis = {}
	for i,v in ipairs(strs) do
		local w = gDef:GetTextLen(fontsize,v)+20;
		self.txts[i] = kd.class(kd.StaticText,fontsize,strs[i],kd.TextHAlignment.CENTER, w, 100);
		self:addChild(self.txts[i]); 
		local x = (i-1)*padding+paddingLeft
		self.posx[i] = x
		self.txts[i]:SetPos(x, gDef.SysBarH+180);
		self.txts[i]:SetColor(color)
		self.guis[i] = gDef:AddGuiBySpr(self,self.txts[i],i,50,60,50,60)
		self.guis[i]:setDebugMode(false)
	end
	
	-- 线
	self.line = kd.class(kd.Sprite,gDef:GetResPath("ResAll/TanChuangBG.png"),894,1070,43,9);
	self:addChild(self.line);
	self.line:SetPos(self.posx[1],gDef.SysBarH+200)
	
	self.index = 1 			-- 当前索引
	self.aniIndex = 2		-- 动画索引
	self.maxIndex = #strs 	-- 最大索引
end

function impl:onGuiToucBackCall(id)
	self:SetIndex(id)
--	DC:CallBack("NavSingle1.OnIndexChange",id)
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
	for i=1,#self.txts do
		self.txts[self.index]:SetColor(0xffBFBFBF);
	end
	self.txts[index]:SetColor(0xffFBCC60);
	if index == self.index then
		TweenPro:Animate({
			{o=self.line,x=self.posx[index],y=gDef.SysBarH+200,d=200,tween=TweenPro.swing.easeOutBack}
		});
	else
		self.index = index
		TweenPro:Animate({
			{o=self.line,x=self.posx[index],y=gDef.SysBarH+200,d=200,tween=TweenPro.swing.easeOutBack}
		});
	end
	
	if self.m_father then
		self.m_father:SetIndex(index);
	end
end
-- 无动画设置索引
function impl:SetIndexNoAni(index)
	if index == self.index then
		self.line:SetPos(self.posx[index],gDef.SysBarH+200)
	else
		self.index = index
		self.line:SetPos(self.posx[index],gDef.SysBarH+200)
	end
end

-- 设置偏移
-- @offsetfix 层的偏移量(0~ScreenW)
function impl:SetOffset(offsetfix)
	local offsetPercent = math.abs(offsetfix) / ScreenW -- 偏移百分比
	local offsetX = math.floor(offsetPercent * padding) -- x偏移量
	local _,y = self.line:GetPos()
	if offsetfix<0 then
		-- 向右
		if self.index<self.maxIndex then
			self.line:SetPos(self.posx[self.index]+offsetX,y)
			self.aniIndex = self.index+1
		end
	elseif offsetfix>0 then
		-- 向左
		if self.index > 1 then
			self.line:SetPos(self.posx[self.index]-offsetX,y)
			self.aniIndex = self.index-1
		end
	end
end






















