-- ============================================================
-- 下拉刷新提示 上拉加载提示 该组件被滚动组件包含
-- ============================================================

local kd = KDGame;
local gDef = gDef;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

LoadUI = kd.inherit(kd.Layer);
local impl = LoadUI
local ids = {
	--/* Image ID */
	ID_IMG_MT_MAIN2_TM           = 1001,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
	ID_TXT_NO1                   = 4002,
}
local H = 98

function impl:init(w)
	
	self.spr = kd.class(kd.Sprite, gDef.GetResPath("ResAll/Main.png"));
	self.spr:SetTextureRect(1620, 667, 96, 98);
	local nLiuHaiAdd = 0;
	if gDef.IphoneXView then
		nLiuHaiAdd = 0;
	end
	if (self.spr) then
		self:addChild(self.spr);
		self.spr:SetScale(0.8,0.8);
		self.spr:SetPos(ScreenW//2,50);
	end
--	self:addChild(self.m_thView)
	
	--[[self.txtTag = kd.class(kd.StaticText, 40, "下拉刷新", kd.TextHAlignment.CENTER, ScreenW, 50);
	self:addChild(self.txtTag);
	self.txtTag:SetColor(0xffffffff);
	self.txtTag:SetPos(ScreenW//2,170+nLiuHaiAdd + 150);--]]

	self.isRot = false -- 旋转开关
	self.isEnd = true
	self:DownState()
end

function impl:DownState()
--	self.txtTag:SetString("下拉刷新")
	self.isEnd = false
end
function impl:UpState()
	if self.isEnd==false then
--		self.txtTag:SetString("上拉加载")
	end
	
end
function impl:FreeState()
	if self.isEnd==false then
--		self.txtTag:SetString("释放刷新")
	end
end
-- 没有更多
function impl:NoMore()
	self.isEnd = true
	self.spr:SetVisible(false)
--	self.txtTag:SetString("已经到底了")
end
function impl:Cls()
	self.isEnd = false
	self.spr:SetVisible(true)
--	self.txtTag:SetString("上拉加载")
end

	
function impl:GetWH()
	return ScreenW,H
end

-- 设置旋转角度
function impl:SetRot(rot)
	self.spr:SetRotation(rot)
end

-- 开启旋转
function impl:StartRot()
	self.isRot = true
end
-- 停止旋转
function impl:StopRot()
	self.isRot = false
end

-- 更新时间
function impl:UpdateTime()

end


function impl:update(delta)
	if self.isRot then
		local rot = self.spr:GetRotation()
		self.spr:SetRotation(rot+10)
	end
end