local kd = KDGame;

kd.GeometryDraw = kd.inherit(kd.Node);

function kd.GeometryDraw:constr(self, ...)
	
end

function kd.GeometryDraw:Ruin(self)
	
end

function kd.GeometryDraw:create(...)
	self._object = kd.GeometryCreateCreate();
end

--清理绘制
function kd.GeometryDraw:clear()
	if (self._object == nil) then return; end
	return kd.GeometryClear(self._object);
end

--绘制一个点
function kd.GeometryDraw:DrawPoint(--[[Vec2]] point, --[[float]] posSize, --[[uint]] color)
	if (self._object == nil) then return; end
	return kd.GeometryDrawPoint(self._object, point, posSize, color);
end

--绘制N个点
function kd.GeometryDraw:DrawPoints(--[[table<Vec2>]] points, --[[float]] posSize, --[[uint]] color)
	if (self._object == nil) then return; end
	return kd.GeometryDrawPoints(self._object, points, #points, posSize, color);
end

--绘制一条线
function kd.GeometryDraw:DrawLine(--[[Vec2]] origin, --[[Vec2]] destination, --[[float]] crude, --[[uint]] color)
	if (self._object == nil) then return; end
	return kd.GeometryDrawLine(self._object, origin, destination, crude, color);
end

--绘制一个多边形
function kd.GeometryDraw:DrawPolygon(--[[table<Vec2>]] points, --[[uint]] fill_color, --[[float]] border_crude, --[[uint]] border_color)
	if (self._object == nil) then return; end
	return kd.GeometryDrawPolygon(self._object, points, #points, fill_color, border_crude, border_color);
end

--绘制一个圆
function kd.GeometryDraw:DrawCircle(--[[Vec2]] center, 
						--[[float]] radius, 
						--[[float]] angle, 
						--[[uint]] segments, 
						--[[bool]] drawLineToCenter, 
						--[[float]] scaleX, 
						--[[float]] scaleY, 
						--[[uint]] color, 
						--[[bool]] bSolid)
	if (self._object == nil) then return; end
	return kd.GeometryDrawCircle(self._object, center, radius, angle, segments, drawLineToCenter, scaleX, scaleY, color, bSolid);
end