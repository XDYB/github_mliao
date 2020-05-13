-- ============================================================
-- 下拉刷新提示 上拉加载提示 该组件被滚动组件包含
-- ============================================================

local kd = KDGame;
local gDef = gDef;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

LoadAniUI = kd.inherit(kd.Layer);
local impl = LoadAniUI

local H = 150

function impl:init(w)
	self.mazeAni = kd.class(kd.AniMultipleImg,self,1,15);
	self:addChild(self.mazeAni);
	self.mazeAni:SetPos(ScreenW/2,-100);
	self.mazeAni:SetMode(0);
	for i=0,49 do 
		local str = "ResAll/XuLieZhen/ShuaXin/"..i..".png";
		local spr = kd.class(kd.Sprite, gDef.GetResPath(str));
		self.mazeAni:InstFrameSpr(spr);
	end
	self.mazeAni:SetMode(kd.AniPlayMode.HGEANIM_LOOP);
	self.isPlay = false
end
function impl:DownState()
	echo(1)
end
function impl:UpState()
	echo(2)
	
end

function impl:BackTop()
	self.isPlay = false
	self.mazeAni:Stop()
end

function impl:FreeState()
	if self.isPlay==false then
		self.isPlay = true
		self.mazeAni:Play()
	end
end
-- 没有更多
function impl:NoMore()
	self.isEnd = true
	self.txtTime:SetVisible(false)
	self.spr:SetVisible(false)
	self.txtTag:SetString("我是有底线的")
end
	
function impl:GetWH()
	return ScreenW,H
end

-- 设置旋转角度
function impl:SetRot(rot)
	echo(3)
end

-- 开启旋转
function impl:StartRot()
	echo(4)
end
-- 停止旋转
function impl:StopRot()
	self.isPlay = false
end

-- 更新时间
function impl:UpdateTime()

end


function impl:update(delta)

end