-- 蒙板
local kd = KDGame;
local gDef = gDef;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
MaskUI = kd.inherit(kd.Layer);
local color = 0x5A000000
function MaskUI:init()
	local draw = kd.class(kd.GeometryDraw);
	self:addChild(draw);
	local pints = {
		{x=0, y=0},
		{x=0, y=ScreenH},
		{x=ScreenW, y=ScreenH},
		{x=ScreenW, y=0},
	};
	draw:DrawPolygon(pints, color, 1, color);
	
	
	
end





