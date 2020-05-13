-- 增强版动画组件，支持动画队列
-- 参数必填，其他可选
-- ===========================================================================
--[[ demo
TweenPro:Animate({
	{
		o = self.m_spr1, -- [必须] 动画对象 (o 和 num 二选1)
		-- ==============================================================================
		-- 									基础动画
		-- ==============================================================================
		x = "+200",		 -- [可选] x 动画
		y = "+200",		 -- [可选] y 动画
		rotx="+30",		 -- [可选] rotx 动画
		roty = "+30",	 -- [可选] roty 动画
		rotz = "+30",	 -- [可选] rotz 动画(2D旋转)
		alpha=0.2,       -- [可选] 透明度 动画
		scale=2,         -- [可选] 缩放 动画
		scalex = 1,		 -- [可选] 独立的x缩放 动画
		scaley = 1,		 -- [可选] 独立的y缩放 动画
		num = {bnum=100,enum=1000},	-- [可选] 数值动画（让传入的数字大小实现缓动） 
		-- ==============================================================================
		-- 									高级动画
		-- ==============================================================================
		-- [可选][位移动画2阶贝塞尔曲线，该属性控制的是位移的路径，而不是速率]
		bsr = {	-- 贝塞尔曲线控制点，与x、y参数配置使用，暂只实现二阶贝塞尔曲线，位移动画有效
		    -- [x,y] 和 rad 不能同时配置，配置rad将自动计算控制点坐标 
			x=0, 	-- 控制点x
			y=0, 	-- 控制点y
			rad = 1,-- 弧度等级 1/5,1/4,1/3,1/2,1/1 (暂时没有实现，需要结合相似三角形，平行等分限定定理计算)
		}, 
		-- 纹理动画特别说明
		-- 纹理动画不可以与[x,y]动画同时执行,因为纹理动画调用的SetPos会覆盖x y动画,其他动画不受影响
		texture = 200,   -- [可选] 纹理动画 需先调用 tweenPro:SetTexture(self.m_sprbg1,"bottom",100)
		-- 圆周动画特别说明
		-- a,b 圆心坐标 angle 以圆心旋转的角度
		-- 圆周动画不可以与[x,y]动画同时执行
		circle = { 		 -- [可选] 圆心可以是固定坐标，也可以是移动中的精灵，obj 和 [a,b] 选一
			obj = self.m_spr -- 圆心精灵 
			a = 360,-- 圆心坐标x
			b = 640,-- 圆心坐标y
			angle = 360--旋转的角度
		},
		-- [可选][位移动画][3阶贝塞尔曲线，该属性控制的是动画的位移，不要同bsr属性同时使用] 参考CSS3 
		-- 目前只实现了(x,y动画)
		cubic_bezier = {0.5, -1, 0.5, 2} -- (x1,y1,x2,y2) 曲线生成器：https://cubic-bezier.com/
		
		-- [可选][动画曲线][3阶贝塞尔曲线，该属性控制的是动画的速度，功效与tween属性类似，该属性支持自定义的3阶贝塞尔，该属性和tween[2选1]
		-- 目前只实现了(x,y动画)
		speed_bezier = {0.5, -1, 0.5, 2} -- (x1,y1,x2,y2) 曲线生成器：https://cubic-bezier.com/
		-- ==============================================================================
		-- 									其他参数
		-- ==============================================================================
		d=800,			 -- [可选] 动画时长
		tween = tween.swing.linear,-- [可选] 动画曲线
		
		loop = true,     -- [可选] 循环动画
		fn = function()  -- [可选] 回调函数
			echo("=====1 complete===")
		end
	},
	...
})
--]]	
local kd = KDGame
local table = table
local math = math

local ScreenW = kd.SceneSize.width
local ScreenH = kd.SceneSize.high

local speed = 600
TweenPro = kd.inherit(kd.Layer)--主界面
local tween = TweenPro

local delayQueue = {} -- 延迟事件

local delayQueues = {} -- 延迟队列

local schedulerQueue = {} -- 调度队列

local animateQueue = {}; -- 动画队列 不同精灵的动画相互独立不受影响
local animateData = {};	 -- 动画数据

tween.swing = {
    easeOutExpo = function(t,b,c,d)
        return (t==d) and b+c or c * (- (2^(-10 * t/d)) + 1) + b;
    end,
	easeInExpo = function(t,b,c,d)
        return (t==0) and b or c * (2^(10 * (t/d - 1))) + b;
    end,
	easeInQuat = function(t,b,c,d)
		t = t/d;
        return c * (t) * t * t*t + b;
    end,
	easeQuadOut = function(t,b,c,d)
		t = t/d;
		 return -c *(t)*(t-2) + b;
	end,
    linear = function(t,b,c,d)
        return c * t / d + b;
    end,
	easeOutCubic = function(t, b, c, d)
		t = t/d - 1;
		return c * (t * t * t + 1) + b;
	end,
	easeOutBack = function(t, b, c, d, s)
		if (s == nil) then 
			s = 1.70158 ;
		end
		t = t/d - 1;
		return c * (t * t * ((s + 1) * t + s) + 1) + b;
	end,
	easeOutElastic = function(t, b, c, d, a, p) 
		local s;
		if (t==0) then return b end
		t = t/d
		if (t == 1) then return b + c end
		if p == nil then p = d * 0.3 end
		if (a==nil or a < math.abs(c)) then
			a = c; 
			s = p / 4;
		else 
			s = p/(2*math.pi) * math.asin(c/a);
		end
		return (a * (2^(-10 * t))* math.sin((t * d - s) * (2 * math.pi) / p) + c + b);
	end,
	easeOutInElastic = function(t, b, c, d, a, p) 
		local s;
		if (t==0) then return b end
		t = t/(d/2)
		if (t == 2) then return b+c end
		if p == nil then p = d * (.3 * 1.5) end
		if (a==nil or a < math.abs(c)) then
			a = c; 
			s = p / 4;
		else
			s = p / (2  *math.pi) * math.asin(c / a);
		end
		if (t < 1) then 
			t = t - 1
			return -.5 * (a * (2^(10* t)) * math.sin((t * d - s) * (2 * math.pi) / p)) + b;
		end
		t = t - 1
		return a * (2^(-10 *t)) * math.sin((t * d - s) * (2 *  math.pi) / p ) * .5 + c + b;
	end,
	easeOutBounce = function(t,b,c,d)
	t = t/d
	if (t < (1/2.75)) then
		return c*(7.5625*t*t) + b
	elseif (t < (2/2.75)) then
		t = t - (1.5/2.75)
		return c*(7.5625*t*t + 0.75) + b
	elseif (t < (2.5/2.75)) then
		t = t - (2.25/2.75)
		return c*(7.5625*t*t + 0.9375) + b
	else
		t = t - (2.625/2.75)
		return c*(7.5625*t*t + 0.984375) + b
	end
end
}

tween.bsr = {
	twobsr = function(t, a1, a2, a3) 
		return a1 * ((1 - t) * (1 - t))  + 2 * t * (1 - t) * a2 + t * t * a3;
	end,
	threebsr = function(t, a1, a2, a3, a4) 
		return a1 * (1 - t) * (1 - t) * (1 - t) + 3 * a2 * t * (1 - t) * (1 - t) + 3 * a3 * t * t * (1 - t) + a4 * t * t * t;
	end
}

function tween:update(--[[float--]] delta)
	if(#delayQueue>0) then
		local i = 1
		while i<=#delayQueue do
			local v = delayQueue[i]
			local t = v.t;
			local time = v.d;
			local callback = v.callback;
			if t>=time then
				-- 特别说明 必须在remove之后再执行回调，否则嵌套Settimeout执行会出现问题。
				table.remove(delayQueue,i);
				callback();
			else
				v.t = t + delta;
				i = i + 1
			end
		end
	end

	if next(delayQueues) then
		local i = 1
		while i<=#delayQueues do
			if #delayQueues[i]==0 then
				table.remove(delayQueues,i)
			else
				local act = delayQueues[i][1]
				if act.t < act.d then
					act.t = act.t + delta
				else
					-- 特别说明 必须在remove之后再执行回调，否则嵌套Settimeout执行会出现问题。
					table.remove(delayQueues[i],1)
					act.callback()
				end
				i = i + 1
			end
		end
	end
	if #schedulerQueue>0 then
		for i,v in ipairs(schedulerQueue) do
			local t = v.t;
			local time = v.d;
			local callback = v.callback;
			if t>=time then
				callback();
				v.t = 0;
			else
				v.t = t + delta;
			end
		end
	end

	if next(animateQueue) then
		for i,queue in pairs(animateQueue) do
			if #queue>0 then
				local act = queue[1]
				
				-- 贝塞尔曲线
				if act.bsr then
					self:MoveBsr(act,delta)
				else
					if act.ex then
						self:MoveX(act,delta)
					end
					if act.ey then
						self:MoveY(act,delta)
					end
				end
				if act.enum then
					self:MoveNum(act,delta)
				end
				if act.erotx then
					self:RotateX(act,delta)
				end
				if act.eroty then
					self:RotateY(act,delta)
				end
				if act.erotz then
					self:RotateZ(act,delta)
				end
				if act.eAlpha then
					self:Alpha(act,delta)
				end
				if act.escale then
					self:Scale(act,delta)
				end
				if act.escalex then
					self:ScaleX(act,delta)
				end
				if act.escaley then
					self:ScaleY(act,delta)
				end
				if act.etexture then
					self:Texture(act,delta)
				end
				if act.circle then
					self:Circle(act,delta)
				end
				if act.egx then
					self:MoveG(act,delta)
				end
				if act.complete then
					if act.callback then
						act.callback()
					end
                    if animateQueue[i] then
						local time1 = os.time()
                        table.remove(animateQueue[i],1)
						local last = table.remove(animateData[i],1)
						if act.loop then
							table.insert(animateData[i],last)
							table.insert(animateQueue[i],{})
						end
                        if #animateQueue[i] == 0 then
                            animateQueue[i] = nil;
                        end
                        if #animateData[i] ==0 then
                            animateData[i] = nil;
                        end
                        if animateData[i] and animateData[i][1] then
                            queue[1] = self:CreateAniEvent(animateData[i][1])   
                        end
                    end
				end
			end
		end
	end
	
	
end

-- 根据x坐标查找y索引的值
function tween:CalBsrIndex(x,bsrx,bsry)
	if x > 0 then
		local index = 0
		for i,v in ipairs(bsrx) do
			if x<=v then
				index = i
				break;
			end
		end
		return bsry[index]
	else
		return 0
	end
	
end
function tween:CreateAniEvent(p)
	local bx,by
	local brotx,broty,brotz
	local bAlpha
	local bscale
	local bscalex
	local bscaley
	if p.o then
		bx,by = p.o:GetPos()
		brotx,broty,brotz = p.o:GetRotation3D()
		bAlpha = p.o:GetColor() >> 24 & 0xff
		bscale = (p.o:GetScale())
		bscalex,bscaley = p.o:GetScale()
	end
	local act = {
		o = p.o,
		d = p.d and p.d/1000 or speed/1000,
		swing = p.tween or tween.swing.easeOutCubic,
		cubic_bezier = p.cubic_bezier,
		bsr = p.bsr,
		bx = bx,
		by = by,
		brotx = brotx,
		broty = broty,
		brotz = brotz,
		bAlpha = bAlpha,
		bscale = bscale,	-- 宽高采用等比缩放
		bscalex = bscalex,  -- 独立的x缩放
		bscaley = bscaley,  -- 独立的y缩放
		-- 时间 每个动画必须使用独立的时间，否则同时执行多个动画会叠加速度
		-- ===============================================================
		-- 							 时间
		-- ===============================================================
		gxt = 0,
		xt = 0,
		yt = 0,
		rotxt = 0,
		rotyt = 0,
		rotzt = 0,
		alphat = 0,
		scalet = 0,
		scalext = 0,
		scaleyt = 0,
		texturet = 0,
		circlet = 0,
		bsrt = 0,
		loop = p.loop,-- 循环
		complete = false,-- 是否完成(各动画共享完成标志) 用于执行回调
	}
	if act.o then
		act.o.isAni = true -- 是否运行动画(该属性用于，当节点Node被RemoveChild时，标记节点被移除 ，跳过动画函数，防止崩溃)
	end

	-- 数值动画
	if p.num then
		act.num = p.num
		act.num.value = p.num.bnum
		act.bnum = p.num.bnum -- 数值起始
		act.enum = p.num.enum -- 数值终止
		act.numt = 0
	end
	
	-- 计算贝塞尔点阵
	if p.speed_bezier then
		local x1 = p.speed_bezier[1]
		local y1 = p.speed_bezier[2]
		local x2 = p.speed_bezier[3]
		local y2 = p.speed_bezier[4]
				
		local step = act.d * 60//1 --  (1秒60帧 => act.d秒 step 帧)  分布密度
		local bsrx = {}
		local bsry = {}
		for i = 1,step do
			local vx = tween.bsr.threebsr(i/step,0,x1,x2,1)
			local vy = tween.bsr.threebsr(i/step,0,y1,y2,1)
			table.insert(bsrx,vx)
			table.insert(bsry,vy)
		end
		act.bsrx = bsrx
		act.bsry = bsry
	end
	
	
	-- 咪牌动画定制
	if p.bgx and p.egx then
		if p.start3d then
			-- 避免重复创建 否则两个动画之间会闪烁
			act.o:Start(table.unpack(p.start3d));
		end
		act.bgx = p.bgx
		act.egx = p.egx
		act.cgx = p.egx - p.bgx
		
	end
	-- x 动画
	if p.x then
		if type(p.x)=="number" then
			act.cx = p.x - bx
			act.ex = p.x
		else
			local f = string.sub(p.x,1,1)
			if f == "+" then
				act.cx = p.x
				act.ex = bx + string.sub(p.x,2,string.len(p.x))
			elseif f == "-" then
				act.cx = p.x
				act.ex = bx - string.sub(p.x,2,string.len(p.x))
			end
		end
		
	end
	-- y 动画
	if p.y then
		if type(p.y)=="number" then
			act.cy = p.y - by
			act.ey = p.y
		else
			local f = string.sub(p.y,1,1)
			if f == "+" then
				act.cy = p.y
				act.ey = by + string.sub(p.y,2,string.len(p.y))
			elseif f == "-" then
				act.cy = p.y
				act.ey = by - string.sub(p.y,2,string.len(p.y))		
			end
		end
		
	end
	-- 贝塞尔弧线
	if p.bsr then
		-- t a1 a2 a3
		-- t b c d
		local a1 = {x=bx,y=by}
		local a2 = {x=0,y=0}
		local a3 = {x=bx,y=by}
		if act.ex then
			a3.x = act.ex
		end
		if act.ey then
			a3.y = act.ey
		end
		if p.bsr.x and p.bsr.y then
			a2 = {x=p.bsr.x,y=p.bsr.y}
		elseif p.bsr.rad then
			-- 待实现 计算a2
			-- do sth ...
		end
		act.bsr.a1 = a1
		act.bsr.a2 = a2
		act.bsr.a3 = a3
		act.bsr.bt = 0
		act.bsr.ct = act.d
	end
	
	
	-- rotx 动画
	if p.rotx then
		if type(p.rotx)=="number" then
			act.crotx = p.rotx - brotx
			act.erotx = p.rotx
		else
			local f = string.sub(p.rotx,1,1)
			if f == "+" then
				act.crotx = p.rotx
				act.erotx = brotx + string.sub(p.rotx,2,string.len(p.rotx))
			elseif f == "-" then
				act.crotx = p.rotx
				act.erotx = brotx - string.sub(p.rotx,2,string.len(p.rotx)) 	
			end
		end
		
	end
	-- roty 动画
	if p.roty then
		if type(p.roty)=="number" then
			act.croty = p.roty - broty
			act.eroty = p.roty
		else
			local f = string.sub(p.roty,1,1)
			if f == "+" then
				act.croty = p.roty
				act.eroty = broty + string.sub(p.roty,2,string.len(p.roty))
			elseif f == "-" then
				act.croty = p.roty
				act.eroty = broty - string.sub(p.roty,2,string.len(p.roty))	
			end
		end
	end
	-- rotz 动画
	if p.rotz then
		if type(p.rotz)=="number" then
			act.crotz = p.rotz - brotz
			act.erotz = p.rotz
		else
			local f = string.sub(p.rotz,1,1)
			if f == "+" then
				act.crotz = p.rotz
				act.erotz = brotz + string.sub(p.rotz,2,string.len(p.rotz))
			elseif f == "-" then
				act.crotz = p.rotz
				act.erotz = brotz - string.sub(p.rotz,2,string.len(p.rotz))	
			end
		end
	end
	-- alpha 动画 暂不支持（增量）动画
	if p.alpha then
		local eAlpha = 0xff * p.alpha;
		
		act.eAlpha = eAlpha;
		act.cAlpha = eAlpha - bAlpha;
	end
	-- 缩放 动画
	if p.scale then
		if type(p.scale)=="number" then
			act.cscale = p.scale - bscale
			act.escale = p.scale
		else
			local f = string.sub(p.scale,1,1)
			if f == "+" then
				act.cscale = p.scale
				act.escale = bscale + string.sub(p.scale,2,string.len(p.scale))
			elseif f == "-" then
				act.cscale = p.scale
				act.escale = bscale - string.sub(p.scale,2,string.len(p.scale))	
			end
		end
	end
	-- 独立x缩放
	if p.scalex then
		if type(p.scalex)=="number" then
			act.cscalex = p.scalex - bscalex
			act.escalex = p.scalex
		else
			local f = string.sub(p.scalex,1,1)
			if f == "+" then
				act.cscalex = p.scalex
				act.escalex = bscalex + string.sub(p.scalex,2,string.len(p.scalex))
			elseif f == "-" then
				act.cscalex = p.scalex
				act.escalex = bscalex - string.sub(p.scalex,2,string.len(p.scalex))	
			end
		end
	end
	-- 独立y缩放
	if p.scaley then
		if type(p.scaley)=="number" then
			act.cscaley = p.scaley - bscaley
			act.escaley = p.scaley
		else
			local f = string.sub(p.scaley,1,1)
			if f == "+" then
				act.cscaley = p.scaley
				act.escaley = bscaley + string.sub(p.scaley,2,string.len(p.scaley))
			elseif f == "-" then
				act.cscaley = p.scaley
				act.escaley = bscaley - string.sub(p.scaley,2,string.len(p.scaley))	
			end
		end
	end
	
	-- 纹理 动画
	if p.texture then
		local btexw,btexh = p.o:GetYSWH()
		act.btexw = btexw
		act.btexh = btexh
		act.textside = p.o.textside or "left"
		local b
		if act.textside == "left" then 
			b = act.btexw
		elseif act.textside == "right" then 
			b = act.btexw
		elseif act.textside == "top" then 
			b = act.btexh
		elseif act.textside == "bottom" then  
			b = act.btexh
		end
		if type(p.texture)=="number" then
			act.ctexture = p.texture - b
			act.etexture = p.texture
		else
			local f = string.sub(p.texture,1,1)
			if f == "+" then
				act.ctexture = p.texture
				act.etexture = b + string.sub(p.texture,2,string.len(p.texture))
			elseif f == "-" then
				act.ctexture = p.texture
				act.etexture = b - string.sub(p.texture,2,string.len(p.texture))	
			end
		end
		act.btexture = b
	end
	-- 圆周 动画
	if p.circle then	
		act.circle = {}
		local a	-- 圆心x
		local b -- 圆心y
		if p.circle.obj then
			a,b = p.circle.obj:GetPos()
			act.circle.obj = p.circle.obj
		else
			a = p.circle.a
			b = p.circle.b
		end
		
		local angle = p.circle.angle
		-- 1.计算半径
		local r = (math.abs(bx-a)^2+math.abs(by-b)^2)^0.5
		-- 2.确定当前象限
		local quadrant = 0 -- 象限
		if bx>a then
			if by>b then
				quadrant = 4
			elseif by<b then
				quadrant = 1
			end
		elseif bx<a then
			if by>b then
				quadrant = 3
			elseif by<b then
				quadrant = 2
			end
		end
		-- 3.根据象限计算初始角度
		local bangle = 0 -- 角度
		if quadrant>0 then
			if quadrant == 1 then
				local arc = math.asin((math.abs(by-b))/r) 
				bangle = math.deg(arc)
			elseif quadrant == 2 then
				local arc = math.asin((math.abs(by-b))/r) 
				bangle = 180 - math.deg(arc)
			elseif quadrant == 3 then
				local arc = math.asin((math.abs(by-b))/r) 
				bangle = 180 + math.deg(arc)	
			elseif quadrant == 4 then
				local arc = math.asin((math.abs(by-b))/r) 
				bangle = 360 - math.deg(arc)	
			end
		else
			if b == by and bx>a then
				bangle = 0
			elseif bx == a and by < b then
				bangle = 90
			elseif b == by and bx<a then
				bangle = 180
			else
				bangle = 270
			end
		end
		if type(angle)=="number" then
			act.circle.cangle = angle - bangle
			act.circle.eangle = angle
		else
			local f = string.sub(angle,1,1)
			if f == "+" then
				act.circle.cangle = angle
				act.circle.eangle = bangle + string.sub(angle,2,string.len(angle))
			elseif f == "-" then
				act.circle.cangle = angle
				act.circle.eangle = bangle - string.sub(angle,2,string.len(angle))	
			end
		end
		-- 圆心、半径
		act.circle.bangle = bangle
		act.circle.a = a
		act.circle.b = b
		act.circle.r = r
	end
	
	-- 回调
	if p.fn then
		act.callback = p.fn
	end
	return act
end

-- 3D网格动画（不支持cubic_bezier）
function tween:MoveG(act,delta)
	if act.o.isAni then
		if (act.gxt<act.d) then
			local x = act.swing(act.gxt,act.bgx,act.cgx,act.d);
			if act.o:IsStart() then
				act.o:Flip(x);
			end
			act.gxt = act.gxt + delta;
		else
			if act.o and act.o:IsStart() then
				act.o:Flip(act.egx);
			end
			act.complete = true;
		end
	end
end

function tween:MoveNum(act,delta)
	if (act.numt<act.d) then
		local x = act.swing(act.numt,act.bnum,act.enum-act.bnum,act.d);
		act.num.value = x
		act.num.t = act.numt
		act.numt = act.numt + delta;
	else
		act.num.value = act.enum
		act.complete = true;
	end
end
	
--[[
local path = [[C:\Users\adminB96\Desktop\]]
function log(str)
	local file = io.open(path.."abc.txt","a")
	file:write(str.."\n")
	io.close(file);
end
--]]
-- 支持 （支持cubic_bezier）
function tween:MoveX(act,delta)
	if act.o.isAni then
		if (act.xt<act.d) then
			-- [位移]贝塞尔
			if act.cubic_bezier then
				local x1 = act.cubic_bezier[1]
				local y1 = act.cubic_bezier[2]
				local x2 = act.cubic_bezier[3]
				local y2 = act.cubic_bezier[4]
						
				local a1 = act.bx
				local a2 = act.bx+x1*act.cx
				local a3 = act.bx+x2*act.cx
				local a4 = act.ex
	
				local t = act.swing(act.xt,0,act.d,act.d)/act.d;

				local px = tween.bsr.threebsr(t,a1,a2,a3,a4)
				local _,y = act.o:GetPos();
				act.o:SetPos(px,y);
				act.xt = act.xt + delta;
			-- [速率]贝塞尔
			elseif act.bsrx then
				local dp = self:CalBsrIndex(act.xt/act.d,act.bsrx,act.bsry)
				local x = act.bx+act.cx*dp
				local _,y = act.o:GetPos();
				act.o:SetPos(x//1,y);
				act.xt = act.xt + delta;
			else
				local x = act.swing(act.xt,act.bx,act.cx,act.d);
				local _,y = act.o:GetPos();
				act.o:SetPos(x,y);
				act.xt = act.xt + delta;

			end

			
		else
			local _,ey = act.o:GetPos();
			act.o:SetPos(act.ex,ey);
			act.complete = true;
		end
	end
end
function tween:MoveY(act,delta)
	if act.o.isAni then
		if (act.yt<act.d) then
			-- [位移]贝塞尔
			if act.cubic_bezier then
				local x1 = act.cubic_bezier[1]
				local y1 = act.cubic_bezier[2]
				local x2 = act.cubic_bezier[3]
				local y2 = act.cubic_bezier[4]
						
				local a1 = act.by
				local a2 = act.by+y1*act.cy
				local a3 = act.by+y2*act.cy
				local a4 = act.ey
	
				local t = act.swing(act.yt,0,act.d,act.d)/act.d;
				local py = tween.bsr.threebsr(t,a1,a2,a3,a4)
				local x,_ = act.o:GetPos();
				act.o:SetPos(x,py);
				act.yt = act.yt + delta;
			-- [速率]贝塞尔
			elseif act.bsrx then
				local dp = self:CalBsrIndex(act.yt/act.d,act.bsrx,act.bsry)
				local y = act.by+act.cy*dp
				local x,_ = act.o:GetPos();
				act.o:SetPos(x,y);
				act.yt = act.yt + delta;
			else
				local y = act.swing(act.yt,act.by,act.cy,act.d);
				local x,_ = act.o:GetPos();
				act.o:SetPos(x,y);
				act.yt = act.yt + delta;

			end
			
			
		else
			local ex,_ = act.o:GetPos();
			act.o:SetPos(ex,act.ey);
			act.complete = true;
		end
	end
	
end

--act.bsr.a1 = a1
--act.bsr.a2 = a2
--act.bsr.a3 = a3
--act.bsr.bt = 0
--act.bsr.et = act.d
--act.bsr.ct = act.bsr.et - act.bsr.bt
function tween:MoveBsr(act,delta)
	if act.o.isAni then
		if (act.bsrt<act.d) then
			local t = act.swing(act.bsrt,act.bsr.bt,act.bsr.ct,act.d);
			local x = tween.bsr.twobsr(t/act.d,act.bsr.a1.x,act.bsr.a2.x,act.bsr.a3.x)
			local y = tween.bsr.twobsr(t/act.d,act.bsr.a1.y,act.bsr.a2.y,act.bsr.a3.y)
			act.o:SetPos(x,y);
			act.bsrt = act.bsrt + delta;
		else
			act.o:SetPos(act.bsr.a3.x,act.bsr.a3.y);
			act.complete = true;
		end
	end
end


function tween:RotateX(act,delta)
	if act.o.isAni then
		if (act.rotxt<act.d) then
			local rotx = act.swing(act.rotxt,act.brotx,act.crotx,act.d);
			local _,roty,rotz = act.o:GetRotation3D();
			act.o:SetRotation3D(rotx,roty,rotz);
			act.rotxt = act.rotxt + delta;
		else
			local _,eroty,erotz = act.o:GetRotation3D();
			act.o:SetRotation3D(act.erotx,eroty,erotz);
			act.complete = true;
		end
	end
	
end
function tween:RotateY(act,delta)
	if act.o.isAni then
		if (act.rotyt<act.d) then
			local roty = act.swing(act.rotyt,act.broty,act.croty,act.d);
			local rotx,_,rotz = act.o:GetRotation3D();
			act.o:SetRotation3D(rotx,roty,rotz);
			act.rotyt = act.rotyt + delta;
		else
			local erotx,_,erotz = act.o:GetRotation3D();
			act.o:SetRotation3D(erotx,act.eroty,erotz);
			act.complete = true;
		end
	end
end
function tween:RotateZ(act,delta)
	if act.o.isAni then
		if (act.rotzt<act.d) then
			local rotz = act.swing(act.rotzt,act.brotz,act.crotz,act.d);
			local rotx,roty,_ = act.o:GetRotation3D();
			act.o:SetRotation3D(rotx,roty,rotz);
			act.rotzt = act.rotzt + delta;
		else
			local erotx,eroty,_ = act.o:GetRotation3D();
			act.o:SetRotation3D(erotx,eroty,act.erotz);
			act.complete = true;
		end
	end
end

function tween:Alpha(act,delta)
	if act.o.isAni then
		if (act.alphat<act.d) then
			local alpha = act.swing(act.alphat,act.bAlpha,act.cAlpha,act.d);
			local _color10 = act.o:GetColor();
			local _rgb = _color10 & 0xffffff;	-- rgb颜色
			local color =  (math.floor(alpha) << 24) + _rgb;
			act.o:SetColor(color);
			act.alphat = act.alphat + delta;
		else
			local _color10 =  act.o:GetColor();
			local _rgb = _color10 & 0xffffff;
			local color = (math.floor(act.eAlpha) << 24) + _rgb;
			act.o:SetColor(color);
			act.complete = true;
		end
	end
	
end
function tween:Scale(act,delta)
	if act.o.isAni then
		if (act.scalet<act.d) then
			-- x_y  这里保持长宽比缩放 也可分开实现（感觉没有必要）
			local x_y = act.swing(act.scalet,act.bscale,act.cscale,act.d);
			act.o:SetScale(x_y,x_y);
			act.scalet = act.scalet + delta;
		else
			act.o:SetScale(act.escale,act.escale);
			act.complete = true;
		end
	end
end
function tween:ScaleX(act,delta)
	if act.o.isAni then
		if (act.scalext<act.d) then
			local x = act.swing(act.scalext,act.bscalex,act.cscalex,act.d);
			local _,sy = act.o:GetScale()
			act.o:SetScale(x,sy);
			act.scalext = act.scalext + delta;
		else
			local _,sy = act.o:GetScale()
			act.o:SetScale(act.escalex,sy);
			act.complete = true;
		end
	end
end
function tween:ScaleY(act,delta)
	if act.o.isAni then
		if (act.scaleyt<act.d) then
			local y = act.swing(act.scaleyt,act.bscaley,act.cscaley,act.d);
			local sx,_ = act.o:GetScale()
			act.o:SetScale(sx,y);
			act.scaleyt = act.scaleyt + delta;
		else
			local sx,_ = act.o:GetScale()
			act.o:SetScale(sx,act.escaley);
			act.complete = true;
		end
	end
end
function tween:Texture(act,delta)
	if act.o.isAni then
		if (act.texturet<act.d) then
			local w_or_h = act.swing(act.texturet,act.btexture,act.ctexture,act.d);
			self:SetTexture(act.o,act.textside,w_or_h)
			act.texturet = act.texturet + delta;
		else
			self:SetTexture(act.o,act.textside,act.etexture)
			act.complete = true;
		end
	end
end
-- 圆周
function tween:Circle(act,delta)
	if act.o.isAni then
		local a,b
		if act.circle.obj then
			a,b = act.circle.obj:GetPos()
		else
			a = act.circle.a
			b = act.circle.b
		end

		local r = act.circle.r
		local bangle = act.circle.bangle
		local cangle = act.circle.cangle
		local eangle = act.circle.eangle
		if (act.circlet<act.d) then
			local angle = act.swing(act.circlet,bangle,cangle,act.d);
			-- 根据当前角度、圆心计算坐标 (x-a)^2+(y-b)^=r^2
			act.o:SetPos(self:CirclePos(a,b,r,angle));
			act.circlet = act.circlet + delta;
		else
			act.o:SetPos(self:CirclePos(a,b,r,eangle));
			act.complete = true;
		end
	end
	
end

-- 获取圆周上的点坐标
-- @a 圆心x
-- @b 圆心y
-- @r 半径
-- @angle 角度
function tween:CirclePos(a,b,r,angle)
	local rad = math.rad(angle)
	local sx = a + math.cos(rad)*r
	local sy = b - math.sin(rad)*r
	return sx,sy
end

-- 追加动画
function tween:AppendAnimate(queue,data,params)
    for i,v in ipairs(params) do
        table.insert(queue,{});
        table.insert(data,v);
    end
end

-- 绘制纹理并保持位置,纹理动画前必须先调用此方法
-- @spr 精灵
-- @side 从那边开始绘制 left / right / top / bottom
-- @w_or_h 纹理的宽或高
function tween:SetTexture(spr,side,w_or_h)
	spr.textside = side
	if spr.ysx == nil and spr.ysy == nil then
		spr.ysx,spr.ysy = spr:GetPos(); 
	end
	local pw,ph = spr:GetTexWH();
	local ysx = spr.ysx
	local ysy = spr.ysy
	local px,py = spr:GetPos();
	if side == "left" then
		local pox = ysx-pw/2+w_or_h/2
		spr:SetTextureRect(0,0,w_or_h,ph);
		spr:SetPos(pox,py);
	elseif side == "right" then 
		local pox = ysx+pw/2-w_or_h/2
		spr:SetTextureRect(pw-w_or_h,0,w_or_h,ph);
		spr:SetPos(pox,py);
	elseif side == "top" then
		local poy = ysy-ph/2+w_or_h/2
		spr:SetTextureRect(0,0,pw,w_or_h);
		spr:SetPos(px,poy);
	elseif side == "bottom" then
		local poy = ysy+ph/2-w_or_h/2
		spr:SetTextureRect(0,ph-w_or_h,pw,w_or_h);
		spr:SetPos(px,poy);
	end
	if spr.GetYSWH == nil then
		spr.GetYSWH = function(this)
			return spr:GetWH();
		end
	end
	if spr.ysw == nil and spr.ysh == nil then
		spr.ysw,spr.ysh = spr:GetYSWH()
	end
end



-- =================================================================================================================
-- 									
-- 												API      
-- 								（API之外的函数禁止调用，后果不可预料）
--
-- =================================================================================================================

-- 如果当前精灵存在还没执行的动画队列，会自动追加到队列末尾
-- @params 动画参数
function tween:Animate(params)
    local spr = params[1].o;
    for i,v in ipairs(animateData) do
        local first = v[1].o; -- 取精灵动画队列中的第一个元素
        if spr == first then
            -- 针对同一个精灵，执行追加动画（否则执行创建动画）
            local queue = animateQueue[i]
            local data = animateData[i]
            self:AppendAnimate(queue,data,params);
            return
        end        
    end
	local queue = {}
	for i,v in ipairs(params) do
		local act = {}
		if i==1 then
			-- 只使用到第一个 后面的只是占位，在第一个完成时才能获取当前的 GetPos GetRotation3D GetColor GetScale
			act = self:CreateAniEvent(v)
            
		end
		table.insert(queue,act)
	end
	table.insert(animateQueue,queue)
	table.insert(animateData,params)
end

-- 停止所有 慎用
function tween:StopAll()
	-- 动画队列
	animateQueue = {};
    -- 动画数据
	animateData = {};
	-- 延迟队列
	delayQueues = {};
	-- 延迟事件
	delayQueue = {};
	-- 调度任务
	schedulerQueue = {}

end 

-- 调用RemoveChild之前，请先调用该方法，标记元素动画状态
function tween:DelNode(obj)
	obj.isAni = false
end

-- 停止单个动画
function tween:StopSingleAnimate(obj)
    for i,queue in pairs(animateQueue) do
        if #queue>0 then
            local act = queue[1]
            if act.o == obj then
               animateQueue[i] = nil;
            end
        end
    end
    for i,data in pairs(animateData) do
        if #data > 0 then
            local dt = data[1]
            if dt.o == obj then
                animateData[i] = nil;
            end
        end
    end
end

-- 设置透明度
function tween:SetAlpha(sprite,alpha)
	local _color10 =  sprite:GetColor();
	local _rgb = _color10 & 0xffffff;
	local color = (math.floor(0xff * alpha) << 24) + _rgb;
	sprite:SetColor(color);
end

-- 延迟执行
-- @time 延迟时间 毫秒
-- @func 执行方法
function tween:SetTimeout(time,func)
	if time>0 then
		local handle = {
			t = 0,
			d = time/1000,
			callback = func
		}
		table.insert(delayQueue,handle)
		return handle
	end
	
end
-- 清除延迟执行队列
-- @handle 句柄
function tween:ClearTimeout(handle)
	if handle then
		for i,v in ipairs(delayQueue) do
			if v == handle then
				table.remove(delayQueue,i)
			end
		end
	end
end

-- 计划任务
-- @time 间隔事件
-- @func 事件
function tween:SetInterval(time,func)
	local handle = {
		t = 0,
		d = time/1000,
		callback = func
	}
	table.insert(schedulerQueue,handle)
	return handle
end
-- 清除计划
-- @handle 句柄
function tween:ClearInterval(handle)
	if handle then
		for i,v in ipairs(schedulerQueue) do
			if v == handle then
				table.remove(schedulerQueue,i)
			end
		end
	end
end

-- 延迟执行队列
-- 
--{
--	{d = 1000,fn = function() end},
--	{d = 2000,fn = function() end},
--	{d = 3000,fn = function() end},
--}
function tween:SetTimeQueue(params)
	local queue = {}
	for i,v in ipairs(params) do
		local act = {
			t = 0,
			d = v.d/1000,
			callback = v.fn 
		}
		table.insert(queue,act)
	end
	table.insert(delayQueues,queue)
	return queue
end 
-- 清除延迟队列
-- @handle 句柄
function tween:ClearTimeQueue(handle)
	if handle then
		for i,v in ipairs(delayQueues) do
			if v == handle then
				table.remove(delayQueues,i)
			end
		end
	end
end

-- 睡眠
-- @time 睡眠时间 毫秒
function sleep(time)
	if (co==nil or coroutine.status(co)=="dead") then
		co = coroutine.create(function ()
			local startTime = os.clock()
			local nowTime = os.clock()
			local time = time/1000
			while((nowTime-startTime)<time) do
				nowTime = os.clock()
			end
		end)
		coroutine.resume(co)
	end
end