local kd = KDGame;

kd.ScrollViewEx = kd.inherit(kd.Layer);
local ScrollView = kd.ScrollViewEx;

function ScrollView:init(father,x,y,w,h,thView,bDirectX,bNoSpringBack)	
	self.m_father = father;
	self.m_VisibleRect = {x1=x,y1=y,x2=x+w,y2=y+h,w=w,h=h};		--可见(裁剪)区域	

	--是否X方向滑动
	if(bDirectX) then self.m_bDirectX = true;
	else self.m_bDirectX = false; end
	--实际绘制高度
	if(self.m_bDirectX) then self.m_fRenderMaxH = w;
	else self.m_fRenderMaxH = h; end
	
	--是否禁止回弹
	if(bNoSpringBack) then self.m_bNoSpringBack = true;
	else self.m_bNoSpringBack = false; end
	
	--控制变量
	self.m_bTouch = false;		--是否发起触碰
	self.m_bPause = false;		--是否暂停滑动（如果是复位时设置暂停，恢复暂停后需要继续复位）
	self.m_bEnable = true;		--是否可用
	self.m_fBeganX = 0;			--移动开始时鼠标X坐标
	self.m_fBeganY = 0;			--移动开始时鼠标Y坐标
	self.m_fBeganPosX = 0;		--移动开始时视图X坐标
	self.m_fBeganPosY = kd.SceneSize.high;	--移动开始时视图Y坐标
	self.m_fMoveX = 0;			--每次移动后鼠标X坐标
	self.m_fMoveY = 0;			--每次移动后鼠标Y坐标
	self.m_fMovePosX = 0;		--每次移动后视图X坐标
	self.m_fMovePosY = 0;		--每次移动后视图Y坐标
		
	--复位变量
	self.m_fSpringK = 0.01;		--弹性系数
	self.m_bBack = false;		--是否需要复位
	self.m_fBackSpeed = 0;		--复位速度
	self.m_bApBack = false;		--指定复位
	self.m_fApBackPosX = 0;		--指定复位X坐标
	self.m_fApBackPosY = 0;		--指定复位Y坐标
		
	--惯性变量
	self.m_fInertiaSpeed = 0;	--瞬时速度
	self.m_fForce = 500;		--摩擦力
	self.m_cbInertiaMode = 0;	--0：不滑动 1：向上 2：向下
	self.m_fMomentOld = 0;		--记录坐标
	self.m_fMomentNew = 0;		--新的坐标（算速度）
	self.m_bClickOK = false;	--是否可以响应点击事件（滑动中点击是停止滑动而不是点击）
	
	--裁剪界面
	self.m_ScrollView = kd.class(kd.GuiObjectNew,self,1,x,y,w,h);
	self.m_ScrollView:setRectClipping(x,y,w,h);
	self:addChild(self.m_ScrollView);
	
	--视图(内胆
	if(thView) then
		self.m_thView = thView;
	else
		self.m_thView = kd.class(kd.Layer);
	end
	
	if (self.m_thView) then
		self.m_ScrollView:addChild(self.m_thView);
		self.m_thView:SetPos(x,kd.MKCY(y));
	end
		
	return true;
end

--设置输出日志
function ScrollView:SetLogOut(bLog)
	self.m_bLog = bLog;
end

--设置调试模式
function ScrollView:setDebugMode()
	self.m_ScrollView:setDebugMode(true);
end

--设置可视区域
function ScrollView:SetRect(x,y,w,h,bStop)
	self.m_VisibleRect = {x1=x,y1=y,x2=x+w,y2=y+h,w=w,h=h};	
	self:SetRenderViewMaxH(self.m_fRenderMaxH);
	--self:SetViewPos(x,kd.MKCY(y),bStop);
end

--设置实际的绘制区域高
function ScrollView:SetRenderViewMaxH(fMaxH)
	self.m_fRenderMaxH = fMaxH;
	if(self.m_bDirectX and self.m_fRenderMaxH < self.m_VisibleRect.w) then
		self.m_fRenderMaxH = self.m_VisibleRect.w;
	elseif(self.m_bDirectX==false and self.m_fRenderMaxH < self.m_VisibleRect.h) then
		self.m_fRenderMaxH = self.m_VisibleRect.h;	
	end
	
	--也许有增减，没有拖动的状态下，调整一次位置
	--if(self.m_bTouch == false) then self.m_bBack = true; end	
end

--添加项目
function ScrollView:InsertItem(item)
	self.m_thView:addChild(item);
end

--删除项目
function ScrollView:DeleteItem(item)
	self.m_thView:RemoveChild(item);
end

--设置暂停
function ScrollView:SetPause(bPause)
	self.m_bPause = bPause;
	if(bPause==false) then self:CheckBack(); end
	--self.m_bEnable = bPause==false;
end

--设置可用
function ScrollView:SetEnable(bEnable)
	self.m_bEnable = bEnable;
end

--设置视图(内胆)坐标
function ScrollView:SetViewPos(x,y,bStop)
	if(bStop) then
		self.m_bBack = false;
		self.m_cbInertiaMode = 0;
	end
	self.m_thView:SetPos(x,y);
--[[	local xx,yy = self.m_thView:GetPos();
	kd.LogOut("KD_LOG:ScrollView-----SetViewPos y="..y..",yy="..yy);--]]
end

--获取视图(内胆)坐标
function ScrollView:GetViewPos()
	return self.m_thView:GetPos();
end

--设置指定复位坐标
function ScrollView:SetAppointBack(x,y)
	self.m_bBack = false;
	self.m_cbInertiaMode = 0;	
	self.m_bApBack = true;
	self.m_fApBackPosX = x;
	self.m_fApBackPosY = y;
	
	--kd.LogOut("KD_LOG:ScrollView-----SetAppointBack m_bBack=false,m_cbInertiaMode=0,m_bApBack=true,m_fApBackPosX="..x..",m_fApBackPosY="..y);
end

--获取指定复位坐标
function ScrollView:GetAppointBackPos()
	return self.m_fApBackPosX,self.m_fApBackPosY;
end

--是否正在复位
function ScrollView:IsBack()
	return self.m_bBack;
end

--是否正在指定复位
function ScrollView:IsApBack()
	return self.m_bApBack;
end

--获取当前速度
function ScrollView:GetCurSpeed(delta)
	if(self.m_bPause) then return 0; end
	if(self.m_cbInertiaMode>0) then return self.m_fInertiaSpeed; end
	if(self.m_bBack) then return self.m_fBackSpeed; end
	if(self.m_bTouch) then
		return (self.m_fMomentNew - self.m_fMomentOld)/(delta*self.m_fForce);
	end
	
	return 0;
end

--是否静止
function ScrollView:IsMotionless()
	if(self.m_bTouch) then return false; end
	if(self.m_bBack) then return false; end
	if(self.m_bApBack) then return false; end
	if(self.m_cbInertiaMode>0) then return false; end
	return true;
end

--回到顶部
function ScrollView:BackToTop(bStop)
	if(bStop) then
		self:SetViewPos(self.m_VisibleRect.x1,kd.MKCY(self.m_VisibleRect.y1),true);
	else
		self:SetAppointBack(self.m_VisibleRect.x1,kd.MKCY(self.m_VisibleRect.y1));
	end
	
end

--回到底部
function ScrollView:BackToBottom()
	self:SetViewPos(self.m_VisibleRect.x1,kd.MKCY(self.m_VisibleRect.y2 - self.m_fRenderMaxH));
end

--点击事件回调(需要自己继承实现)
function ScrollView:OnClickedCall(x,y)
	
end

--内部函数
--

function ScrollView:onTouchBegan(x,y)
	if(self.m_bEnable and self.m_bPause==false
	and x>=self.m_VisibleRect.x1 and x<=self.m_VisibleRect.x2
	and y>=self.m_VisibleRect.y1 and y<=self.m_VisibleRect.y2) then
		self.m_bTouch = true;
		self.m_bBack = false;
		self.m_bClickOK = self.m_cbInertiaMode==0;
		self.m_bApBack = false;
		
		if(self.m_bDirectX) then
			self.m_fMomentOld = x; 
			self.m_fMomentNew = x; 
			
		else
			self.m_fMomentOld = y; 
			self.m_fMomentNew = y; 
		end
		
		if(self.m_bLog) then kd.LogOut("--------onTouchBegan m_fMomentOld="..self.m_fMomentOld..",m_fMomentNew="..self.m_fMomentNew); end

		self.m_fBeganX,self.m_fBeganY = x,y;
		self.m_fBeganPosX,self.m_fBeganPosY = self.m_thView:GetPos();
		
		self.m_fMoveX,self.m_fMoveY = x,y;
		self.m_fMovePosX,self.m_fMovePosY = self.m_thView:GetPos();
		
		--if(self.m_bDirectX) then kd.LogOut("KD_LOG:ScrollView-----onTouchBegan m_bTouch=true,m_bBack=false"); end
		
		return true;
	end
	
	return false;
end

function ScrollView:onTouchMoved(x,y)
	if(--[[self.m_bEnable and self.m_bPause==false and--]] self.m_bTouch) then	
		if(self.m_bDirectX) then
			self.m_fMomentNew = x; 
			
			--计算位移
			local fMove = x-self.m_fMoveX;
			--获取拉到头的距离
			local distance = self:GetSpringStretchLen(self.m_fMovePosX,self.m_fMovePosY);
			--回弹系数
			local fK = distance*self.m_fSpringK;
			if(fK<1) then fK = 1; end
			--设置坐标
			local fSetX = self.m_fMovePosX+fMove/fK;
			if(self.m_bNoSpringBack) then
				if(fSetX > self.m_VisibleRect.x1) then fSetX = self.m_VisibleRect.x1;
				elseif(fSetX < self.m_VisibleRect.x2 - self.m_fRenderMaxH) then fSetX = self.m_VisibleRect.x2 - self.m_fRenderMaxH; end
			end
			self:SetViewPos(fSetX,self.m_fMovePosY);			
			
		else
			self.m_fMomentNew = y; 
			
			--计算位移
			local fMove = y-self.m_fMoveY;
			--获取拉到头的距离
			local distance = self:GetSpringStretchLen(self.m_fMovePosX,self.m_fMovePosY);
			--回弹系数
			local fK = distance*self.m_fSpringK;
			if(fK<1) then fK = 1; end
			--设置坐标
			local fSetY = self.m_fMovePosY+fMove/fK;
			if(self.m_bNoSpringBack) then
				if(fSetY > kd.MKCY(self.m_VisibleRect.y1)) then fSetY = kd.MKCY(self.m_VisibleRect.y1);
				elseif(fSetY < kd.MKCY(self.m_VisibleRect.y2 - self.m_fRenderMaxH)) then fSetY = kd.MKCY(self.m_VisibleRect.y2 - self.m_fRenderMaxH); end
			end			
			self:SetViewPos(self.m_fMovePosX,fSetY);			
		end		
		
		if(self.m_bLog) then kd.LogOut("--------onTouchMoved m_fMomentOld="..self.m_fMomentOld..",m_fMomentNew="..self.m_fMomentNew); end
		
		--重置变量
		self.m_fMoveX,self.m_fMoveY = x,y;
		self.m_fMovePosX,self.m_fMovePosY = self.m_thView:GetPos();	
	end
end

function ScrollView:onTouchEnded (x,y)
	if(self.m_bTouch) then	
		self.m_bTouch = false;
		--kd.LogOut("KD_LOG:ScrollView-----onTouchEnded m_bTouch=false");
		if(self.m_bLog) then kd.LogOut("--------onTouchEnded m_fMomentOld="..self.m_fMomentOld..",m_fMomentNew="..self.m_fMomentNew); end
		
		self:CheckBack();
		if(self.m_bBack) then return; end
		
		local posx,posy = self:GetViewPos();
		
		--点击事件
		if(math.abs(x-self.m_fBeganX)<=10 and math.abs(y-self.m_fBeganY)<=10 and self.m_bClickOK==true and self.m_bBack==false) then
			self.m_cbInertiaMode = 0;
			--kd.LogOut("KD_LOG:ScrollView-----onTouchEnded m_cbInertiaMode=0");
			self:OnClickedCall(x,y);
			--还原位置
			self:SetViewPos(self.m_fBeganPosX,self.m_fBeganPosY);
			return;
		end			
	end
end

function ScrollView:CheckBack()
	local posx,posy = self:GetViewPos();
	
	if(self.m_bDirectX) then
		--向左拖到底，还原位置
		if(posx < self.m_VisibleRect.x2-self.m_fRenderMaxH) then
			self.m_bBack = math.abs(posx-(self.m_VisibleRect.x2-self.m_fRenderMaxH))>0.001;
			--kd.LogOut("KD_LOG:ScrollView-----onTouchEnded m_bBack=true");
			return;
		end
	
		--向右拖到底，还原位置
		if(posx > self.m_VisibleRect.x1) then
			self.m_bBack = true;
			--kd.LogOut("KD_LOG:ScrollView-----onTouchEnded m_bBack=true");
			return;
		end			
	else
		--向上拖到底，还原位置
		if(posy < kd.MKCY(self.m_VisibleRect.y2)-self.m_fRenderMaxH) then
			self.m_bBack = math.abs(posy-(kd.MKCY(self.m_VisibleRect.y2)-self.m_fRenderMaxH))>0.001;
			--kd.LogOut("KD_LOG:ScrollView-----onTouchEnded m_bBack=true");
			return;
		end
	
		--向下拖到底，还原位置
		if(posy > kd.MKCY(self.m_VisibleRect.y1) and self.m_cbInertiaMode~=1) then
			self.m_bBack = true;
			--kd.LogOut("KD_LOG:ScrollView-----onTouchEnded m_bBack=true");
			return;
		end			
	end	
end

function ScrollView:update(delta)	
	--计算瞬时速度
	if(self.m_bTouch) then
		
		if(self.m_bLog) then kd.LogOut("--------update m_fMomentOld="..self.m_fMomentOld..",m_fMomentNew="..self.m_fMomentNew); end
		
		--计算位移
		local fMove_ = self.m_fMomentNew - self.m_fMomentOld;
		--重置标志
		self.m_fMomentOld = self.m_fMomentNew;
		
		if(self.m_bLog) then kd.LogOut("--------before m_fInertiaSpeed="..self.m_fInertiaSpeed); end
		
		--停止
		if(fMove_==0) then self.m_fInertiaSpeed = 0;
		--反向重新算速度
		elseif(fMove_*self.m_fInertiaSpeed < 0) then self.m_fInertiaSpeed = fMove_/(delta*self.m_fForce);
		--正向速度叠加
		else self.m_fInertiaSpeed = 0.5*self.m_fInertiaSpeed + fMove_/(delta*self.m_fForce); end
		
		
		--限制最大速度
		local fMaxSpeed = 20;
		if(self.m_fInertiaSpeed > fMaxSpeed) then self.m_fInertiaSpeed = fMaxSpeed;
		elseif(self.m_fInertiaSpeed < -fMaxSpeed) then self.m_fInertiaSpeed = -fMaxSpeed; end
		
		--滑动方向
		if(math.abs(self.m_fInertiaSpeed) > 1) then
			--向下
			if(self.m_fInertiaSpeed>0) then self.m_cbInertiaMode = 2;
			--向上
			elseif(self.m_fInertiaSpeed<0) then self.m_cbInertiaMode = 1; end
		else 
			--停止
			self.m_cbInertiaMode = 0; 
		end
		
		if(self.m_bLog) then kd.LogOut("--------after m_fInertiaSpeed="..self.m_fInertiaSpeed); end
		
		
		--if(self.m_bDirectX) then kd.LogOut("KD_LOG:ScrollView---1--update m_cbInertiaMode="..self.m_cbInertiaMode); end
		return;
	end
	
	if(self.m_bPause) then return; end
	if(self.m_bBack == false and self.m_cbInertiaMode==0 and self.m_bApBack == false) then 
		self:CheckBack();
		if(self.m_bBack == false) then return; end
	end

	local x,y = self.m_thView:GetPos();
	
	if(self.m_bDirectX) then
		--向左拉到头，还原位置
		if(x<self.m_VisibleRect.x2-self.m_fRenderMaxH and self.m_cbInertiaMode~=2) then
			self.m_cbInertiaMode = 0;
			--kd.LogOut("KD_LOG:ScrollView---2--onTouchEnded m_cbInertiaMode=0");
			if(self:UpdateBackSpeed(x,y)) then
				x = x+delta*self.m_fBackSpeed*1000;
				if(x>=self.m_VisibleRect.x2-self.m_fRenderMaxH) then
					x = self.m_VisibleRect.x2-self.m_fRenderMaxH;
					self.m_bBack = false;
					--kd.LogOut("KD_LOG:ScrollView----3-onTouchEnded m_bBack=false");
				end
				self:SetViewPos(x,y);
			end
		--向右拉到头，还原位置
		elseif(x>self.m_VisibleRect.x1 and self.m_cbInertiaMode~=1) then
			self.m_cbInertiaMode = 0;
			--kd.LogOut("KD_LOG:ScrollView---4--onTouchEnded m_cbInertiaMode=0");
			if(self:UpdateBackSpeed(x,y)) then
				x = x-delta*self.m_fBackSpeed*1000;
				if(x<=self.m_VisibleRect.x1) then
					x = self.m_VisibleRect.x1;
					self.m_bBack = false;
					--kd.LogOut("KD_LOG:ScrollView---5--onTouchEnded m_bBack=false");
				end
				self:SetViewPos(x,y);	
			end
		--指定向右复位
		elseif(self.m_bApBack and x<=self.m_fApBackPosX) then
			if(self:UpdateBackSpeed(x,y)) then
				x = x+delta*self.m_fBackSpeed*1000;
				--kd.LogOut("right x="..x..",m_fApBackPosX="..self.m_fApBackPosX);
				if(x>=self.m_fApBackPosX) then
					x = self.m_fApBackPosX;
					self.m_bApBack = false;
					--kd.LogOut("KD_LOG:ScrollView---6--onTouchEnded m_bApBack=false");
				end
				self:SetViewPos(x,y);		
			end
		--指定向左复位
		elseif(self.m_bApBack and x>=self.m_fApBackPosX) then
			if(self:UpdateBackSpeed(x,y)) then
				x = x-delta*self.m_fBackSpeed*1000;
				--kd.LogOut("left x="..x..",m_fApBackPosX="..self.m_fApBackPosX);
				if(x<=self.m_fApBackPosX) then
					x = self.m_fApBackPosX;
					self.m_bApBack = false;
					--kd.LogOut("KD_LOG:ScrollView---7--onTouchEnded m_bApBack=false");
				end
				self:SetViewPos(x,y);	
			end
		--惯性滑动(向左)
		elseif(self.m_cbInertiaMode==1) then
			self.m_bBack = false;
			--kd.LogOut("KD_LOG:ScrollView---8--onTouchEnded m_bBack=false");
			x = x+delta*self.m_fInertiaSpeed*1000;
			if(x<=self.m_VisibleRect.x2-self.m_fRenderMaxH) then
				x = self.m_VisibleRect.x2-self.m_fRenderMaxH;
				self.m_fInertiaSpeed = 0;
			end
			self:SetViewPos(x,y);	
			self:UpdateInertiaSpeed();
		--惯性滑动(向右)
		elseif(self.m_cbInertiaMode==2) then
			self.m_bBack = false;
			--kd.LogOut("KD_LOG:ScrollView---9--onTouchEnded m_bBack=false");
			x = x+delta*self.m_fInertiaSpeed*1000;
			if(x>=self.m_VisibleRect.x1) then
				x = self.m_VisibleRect.x1;
				self.m_fInertiaSpeed = 0;
			end		
			self:SetViewPos(x,y);	
			self:UpdateInertiaSpeed();	
		--不需要调整	
		else
			self.m_bBack = false;
			self.m_cbInertiaMode = 0;
			self.m_bApBack = false;
			--kd.LogOut("KD_LOG:ScrollView---10--onTouchEnded m_bBack=false,m_cbInertiaMode=0,m_bApBack=false");
		end		
	else
		--向上拉到头，还原位置
		if(y<kd.MKCY(self.m_VisibleRect.y2)-self.m_fRenderMaxH and self.m_cbInertiaMode~=2) then
			self.m_cbInertiaMode = 0;
			if(self:UpdateBackSpeed(x,y)) then
				y = y+delta*self.m_fBackSpeed*1000;
				if(y>=kd.MKCY(self.m_VisibleRect.y2)-self.m_fRenderMaxH) then
					y = kd.MKCY(self.m_VisibleRect.y2)-self.m_fRenderMaxH;
					self.m_bBack = false;
				end
				self:SetViewPos(x,y);
			end
		--向下拉到头，还原位置
		elseif(y>kd.MKCY(self.m_VisibleRect.y1) and self.m_cbInertiaMode~=1) then
			self.m_cbInertiaMode = 0;
			if(self:UpdateBackSpeed(x,y)) then
				y = y-delta*self.m_fBackSpeed*1000;
				--kd.LogOut("y="..y);
				if(y<=kd.MKCY(self.m_VisibleRect.y1)) then
					y = kd.MKCY(self.m_VisibleRect.y1);
					self.m_bBack = false;
				end
				self:SetViewPos(x,y);	
			end
		--指定向下复位
		elseif(self.m_bApBack and y<=self.m_fApBackPosY) then
			if(self:UpdateBackSpeed(x,y)) then
				y = y+delta*self.m_fBackSpeed*1000;
				--kd.LogOut("down y="..y..",m_fApBackPosY="..self.m_fApBackPosY);
				if(y>=self.m_fApBackPosY) then
					y = self.m_fApBackPosY;
					self.m_bApBack = false;
					--kd.LogOut("KD_LOG:ScrollView---6--onTouchEnded m_bApBack=false");
				end
				self:SetViewPos(x,y);		
			end
		--指定向上复位
		elseif(self.m_bApBack and y>=self.m_fApBackPosY) then
			if(self:UpdateBackSpeed(x,y)) then
				y = y-delta*self.m_fBackSpeed*1000;
				--kd.LogOut("up y="..y..",m_fApBackPosY="..self.m_fApBackPosY);
				if(y<=self.m_fApBackPosY) then
					y = self.m_fApBackPosY;
					self.m_bApBack = false;
					--kd.LogOut("KD_LOG:ScrollView---7--onTouchEnded m_bApBack=false");
				end
				self:SetViewPos(x,y);	
			end			
		--惯性滑动(向上)
		elseif(self.m_cbInertiaMode==1) then
			self.m_bBack = false;
			y = y+delta*self.m_fInertiaSpeed*1000;
			if(y<=kd.MKCY(self.m_VisibleRect.y2)-self.m_fRenderMaxH) then
				y = kd.MKCY(self.m_VisibleRect.y2)-self.m_fRenderMaxH;
				self.m_fInertiaSpeed = 0;
			end
			self:SetViewPos(x,y);	
			self:UpdateInertiaSpeed();
		--惯性滑动(向下)
		elseif(self.m_cbInertiaMode==2) then
			self.m_bBack = false;
			y = y+delta*self.m_fInertiaSpeed*1000;
			if(y>=kd.MKCY(self.m_VisibleRect.y1)) then
				y = kd.MKCY(self.m_VisibleRect.y1);
				self.m_fInertiaSpeed = 0;
			end		
			self:SetViewPos(x,y);	
			self:UpdateInertiaSpeed();	
		--不需要调整	
		else
			self.m_bBack = false;
			self.m_cbInertiaMode = 0;
		end
	end
end

--更新惯性速度
function ScrollView:UpdateInertiaSpeed()
	self.m_fInertiaSpeed = self.m_fInertiaSpeed*0.9;
	--kd.LogOut("KD_LOG:ScrollView-----UpdateInertiaSpeed m_fInertiaSpeed="..self.m_fInertiaSpeed);
	
	if(math.abs(self.m_fInertiaSpeed)<=0.01) then 
		self.m_cbInertiaMode = 0; 
		--kd.LogOut("KD_LOG:ScrollView-----UpdateInertiaSpeed m_cbInertiaMode=0");
	end	
end

--更新还原速度
function ScrollView:UpdateBackSpeed(posx,posy)
	local distance = self:GetSpringStretchLen(posx,posy);	
	self.m_fBackSpeed = distance*self.m_fSpringK;
	
	--速度过慢时，强制修正坐标并停止滑动
	if(math.abs(self.m_fBackSpeed)<=0.01) then 
		if(self.m_bBack) then
			self.m_bBack = false;
			local x,y = self.m_thView:GetPos();
			if(self.m_bDirectX and x<self.m_VisibleRect.x2-self.m_fRenderMaxH) then x = self.m_VisibleRect.x2-self.m_fRenderMaxH;
			elseif(self.m_bDirectX and x>self.m_VisibleRect.x1) then x = self.m_VisibleRect.x1;
			elseif(self.m_bDirectX==false and y<kd.MKCY(self.m_VisibleRect.y2)-self.m_fRenderMaxH) then y = kd.MKCY(self.m_VisibleRect.y2)-self.m_fRenderMaxH;
			elseif(self.m_bDirectX==false and y>kd.MKCY(self.m_VisibleRect.y1)) then y = kd.MKCY(self.m_VisibleRect.y1); end		
			self:SetViewPos(x,y);
			return false;
		elseif(self.m_bApBack) then
			self.m_bApBack = false;
			local x,y = self.m_thView:GetPos();
			if(self.m_bDirectX and x~=self.m_fApBackPosX) then x = self.m_fApBackPosX; end	
			self:SetViewPos(x,y);
			return false;
		end
		--if(self.m_bDirectX) then kd.LogOut("KD_LOG:ScrollView-----UpdateBackSpeed m_bBack=false,m_bApBack=false"); end
	end	
	
	return true;
end

--获取弹簧拉伸长度
function ScrollView:GetSpringStretchLen(posx,posy)
	local distance = 0;
	
	if(self.m_bDirectX) then
		if(posx<self.m_VisibleRect.x2-self.m_fRenderMaxH) then
			distance = self.m_VisibleRect.x2 - self.m_fRenderMaxH - posx;
		elseif(posx>self.m_VisibleRect.x1) then
			distance = posx - self.m_VisibleRect.x1;
		elseif(self.m_bApBack) then
			distance = math.abs(self.m_fApBackPosX - posx);
		end	
		
	else
		if(posy<kd.MKCY(self.m_VisibleRect.y2)-self.m_fRenderMaxH) then
			distance = kd.MKCY(self.m_VisibleRect.y2)-self.m_fRenderMaxH - posy;
		elseif(posy>kd.MKCY(self.m_VisibleRect.y1)) then
			distance = posy - kd.MKCY(self.m_VisibleRect.y1);
		elseif(self.m_bApBack) then
			distance = math.abs(self.m_fApBackPosY - posy);
		end	
		
	end
	
	return distance;
end