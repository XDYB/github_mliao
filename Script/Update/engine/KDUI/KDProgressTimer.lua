local kd = KDGame;

kd.ProgressTimer = kd.inherit(kd.Node);

local cfunc = {
	create =  c_ProgressTimerCreate,
	setAnti = c_ProgressTimerSetAnti,
	setType = c_ProgressTimerSetType,
	getType = c_ProgressTimerGetType,
	setPercentage = c_ProgressTimerSetPercentage,
	getPercentage = c_ProgressTimerGetPercentage,
	setSprite = c_ProgressTimerSetSprite,
	setMidpoint = c_ProgressTimerSetMidpoint,
	getMidpoint = c_ProgressTimerGetMidpoint,
	setBarChangeRate = c_ProgressTimerSetBarChangeRate,
	getBarChangeRate = c_ProgressTimerGetBarChangeRate,
}

kd.ProgressTimer.Type = {
	RADIAL = 0,				--圆形时钟
	BAR = 1,				--条形进度
};

function kd.ProgressTimer:constr(self, ...)
	
end

function kd.ProgressTimer:Ruin(self)
	
end

--[[
	创建进度条控件
	
	参数:
	mask:蒙版精灵
]]
function kd.ProgressTimer:create(...--[[KDGame.Sprite mask]])
	local cnt = select("#", ...);
	
	if (cnt < 1) then
		return;
	end
	
	local mask = select(1, ...);
	
	if (kd.IsNull(mask) == false) then
		self._object = cfunc.create(mask._object);
	end
end

--[[
	设置进度条控件的类型
	
	参数:
	pro_type: 类型(详见kd.ProgressTimer.Type)
	
	返回值:
	无
]]
function kd.ProgressTimer:setType(--[[kd.ProgressTimer.Type]] pro_type)
	if (self._object ~= nil) then
		cfunc.setType(self._object, pro_type);
	end
end

--[[
	获取进度条控件的类型
	
	参数:
	无
	
	返回值:
	类型(详见kd.ProgressTimer.Type)
]]
function --[[kd.ProgressTimer.Type]] kd.ProgressTimer:getType()
	if (self._object ~= nil) then
		return cfunc.getType(self._object, pro_type);
	end
	
	return -1;
end

--[[
	设置进度条进度百分比
	
	参数:
	per:进度百分比
	
	返回值:
	无
]]
function kd.ProgressTimer:setPercentage(--[[float]] per)
	if (self._object ~= nil) then
		cfunc.setPercentage(self._object, per);
	end
end

--[[
	返回进度条当前进度百分比
	
	参数:
	无
	
	返回值:
	当前进度百分比
]]
function --[[float]] kd.ProgressTimer:getPercentage()
	if (self._object ~= nil) then
		return cfunc.getPercentage(self._object);
	end
	
	return 0;
end

--[[
	设置新的蒙版精灵
	
	参数:
	mask:蒙版精灵
	
	返回值:
	无
]]
function kd.ProgressTimer:setSprite(--[[KDGame.Sprite]] mask)
	if (kd.IsNull(mask) == false and self._object ~= nil) then
		cfunc.setSprite(self._object, mask._object);
	end
end


--[[
	设置进度变换计算时的中心点
		-对于[kd.ProgressTimer.Type.RADIAL]相当于'圆心',从0到100,慢慢展开扇形
		-对于[kd.ProgressTimer.Type.BAR]相当于'扩散起始点',从某点开始从0到100向上下或者左右两边开始扩散
	
	参数:
	x:相对进度条的X坐标(0.0~1.0)
	y:相对进度条的Y坐标(0.0~1.0)
	
	返回值:
	无
]]
function kd.ProgressTimer:setMidpoint(--[[float]] x, --[[float]] y)
	if (self._object ~= nil) then
		cfunc.setMidpoint(self._object, x, y);
	end
end

--[[
	获取进度变换计算时的中心点
	
	参数:
	无
	
	返回值:
	x:相对进度条的X坐标(0.0~1.0)
	y:相对进度条的Y坐标(0.0~1.0)
]]
function --[[float x, y]] kd.ProgressTimer:getMidpoint()
	if (self._object ~= nil) then
		return cfunc.getMidpoint(self._object);
	end
	
	return 0, 0;
end

--[[
	设置顺逆时针方向(只有当进度条模式为kd.ProgressTimer.Type.RADIAL有效)
	
	参数:
	anti:true->顺时针 false->逆时针
	
	返回值:
	无
]]
function kd.ProgressTimer:setAnti(--[[bool]] anti)
	if (self._object ~= nil) then
		cfunc.setAnti(self._object, anti);
	end
end

--[[
	设置进度变换计算时的X坐标,和Y坐标的显示范围
		-只对[kd.ProgressTimer.Type.BAR]类型有效
		-基本示例:
			setBarChangeRate( 1, 0 )    :  //只有X轴变化(起始X轴不显示)
			setBarChangeRate( 0, 1 )    :  //只有Y轴变化(起始Y轴不显示)
			setBarChangeRate( 1, 1 )    :  //X,Y轴都变化(起始X,y轴都不显示)
			setBarChangeRate( 0.5, 0.5 ):  //X,Y轴都变化
	
	参数:
	x:X坐标显示范围(0.0~1.0)
	y:Y坐标显示范围(0.0~1.0)
	
	返回值:
	无
]]
function kd.ProgressTimer:setBarChangeRate(--[[float]] x, --[[float]] y)
	if (self._object ~= nil) then
		cfunc.setBarChangeRate(self._object, x, y);
	end
end

--[[
	获取进度变换计算时的X坐标,和Y坐标的显示范围
	
	参数:
	无
	
	返回值:
	x:X坐标显示范围(0.0~1.0)
	y:Y坐标显示范围(0.0~1.0)
]]
function --[[float x, y]] kd.ProgressTimer:getBarChangeRate()
	if (self._object ~= nil) then
		return cfunc.getBarChangeRate(self._object);
	end
	
	return 0, 0;
end