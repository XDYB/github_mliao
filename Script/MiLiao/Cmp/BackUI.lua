-- ============================================================
-- 背景123
-- ============================================================

local kd = KDGame;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
BackUI = kd.inherit(kd.Layer);
local impl = BackUI

function impl:init(BackgroundImage)
	if BackgroundImage then
		local sprBg = kd.class(kd.Sprite,gDef.GetResPath(BackgroundImage));
		self:addChild(sprBg)
		sprBg:SetPos(ScreenW/2,ScreenH/2)
		
		local _w,_h = sprBg:GetTexWH();
		local scale = GetAdapterScale(_w,_h,ScreenW,ScreenH);
		sprBg:SetScale(scale,scale);
	else
		self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/BeiJing.UI"), self);
		self:addChild(self.m_thView)
	end
	
end



