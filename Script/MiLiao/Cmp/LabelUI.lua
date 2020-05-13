-- ============================================================
-- 标签
-- ============================================================

local kd = KDGame;
local gDef = GDefine;
local ScreenW = kd.SceneSize.width
local ScreenH = kd.SceneSize.high

LabelUI = kd.inherit(kd.Layer);
local impl = LabelUI

local fontsize = 38

local gray = 0xffdddddd

-- @tag 		标签参数
-- tag.id 		ID 
-- tag.color 	颜色 
-- tag.name 	名字
function impl:init(tag,isclick)
	local clickable
	if isclick==nil then
		clickable = true
	else
		clickable = isclick
	end
	self.id = tag.id
	local lw = 41
	local lh = 72
	-- 文字长度
	local len = gDef:GetTextLen(fontsize,tag.name)
	self.sprL = kd.class(kd.Sprite,gDef:GetResPath("ResAll/Main.png"),1931,822,41,72)
	self:addChild(self.sprL)
	self.sprC = kd.class(kd.Sprite,gDef:GetResPath("ResAll/Main.png"),1972,822,1,72)
	self:addChild(self.sprC)
	self.sprR = kd.class(kd.Sprite,gDef:GetResPath("ResAll/Main.png"),1988,822,41,72)
	self:addChild(self.sprR)
 
	self.txt = kd.class(kd.StaticText,fontsize,tag.name,kd.TextHAlignment.CENTER, len+50, fontsize)
	self:addChild(self.txt); 
	self.txt:SetColor(0xffffffff);
	
	self.gui = kd.class(kd.GuiObjectNew,self,1,0,0,lw+len+lw,lh,false,clickable);
	self:addChild(self.gui)
	
	self.sprC:SetScale(len,1)
	self.sprL:SetPos(lw/2,lh/2)
	self.sprC:SetPos(lw+len/2,lh/2)
	self.sprR:SetPos(lw+len+lw/2,lh/2)
	self.txt:SetPos(lw+len/2,lh/2)
	
	self.sprL:SetColor(gray)
	self.sprC:SetColor(gray)
	self.sprR:SetColor(gray)
	
	self.bgcolor = "0xff"..tag.color
	
	self.ischecked = false -- 是否选中
	
	self.GetWH = function()
		return lw+len+lw,lh
	end
end

function impl:SetMargin(margin)
	local w,h = self:GetWH()
	self.GetWH = function()
		return w+margin,h+margin
	end
end

function impl:SetTextColor(color)
	self.txt:SetColor(color)
end

function impl:onGuiToucBackCall(--[[int]] id)
	if id==1 then
		if self.ischecked then
			if self.CheckOff then self:CheckOff() end
			self.ischecked = false
			self:SetColor(gray)
			
		else
			if self.CheckOn then self:CheckOn() end
			self.ischecked = true
			self:SetColor(self.bgcolor)
		end
	end
end

function impl:SetColor(bgcolor)
	self.sprL:SetColor(bgcolor)
	self.sprC:SetColor(bgcolor)
	self.sprR:SetColor(bgcolor)
end

-- 是否选中
function impl:IsCheck()
	return self.ischecked
end
-- 获取ID
function impl:GetValue()
	return self.id
end
-- 设置选中
function impl:Check(bool)
	if bool then
		self.ischecked=true
		self:SetColor(self.bgcolor)
	else
		self.ischecked = false
		self:SetColor(gray)
	end
end
