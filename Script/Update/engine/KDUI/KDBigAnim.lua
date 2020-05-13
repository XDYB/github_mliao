
local kd = KDGame;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

kd.BigAni = kd.inherit(kd.Layer);
local max = math.max;
function kd.BigAni:init(father,nID,FPS)	
	self.m_father = father;
	self.m_nID = nID;
	self.m_FPS = FPS;
	
	self.m_PerTime = 1000/FPS;
	self.m_bPlay = false;
	self.m_Frame = {};
	self.m_Spr = {};
	self.m_nSprIndex = 0;
	self.m_nIndex = 0;
	self.m_NowTime = 0;
end

function kd.BigAni:InstFrameSpr(path,bscale)		--帧数为0的时候才能执行插入操作
	table.insert(self.m_Frame,path);
	if(#self.m_Spr<1) then
		local spr = kd.class(kd.Sprite,path);
		self:addChild(spr);
		spr:SetPos(ScreenW/2,ScreenH/2);
		local w,h = spr:GetWH();
		local ScaleX = ScreenW/w;
		local ScaleY = ScreenH/h;
		local scale = max(ScaleX,ScaleY);
		if bscale then
		else
			spr:SetScale(scale,scale);
		end
		spr:SetVisible(false);	
		table.insert(self.m_Spr,spr);
	end	
end

function kd.BigAni:update(--[[float]] delta)
	if(self.m_bPlay == false) then return; end
	self.m_NowTime = self.m_NowTime + delta*1000;
	if(self.m_NowTime>=self.m_PerTime) then
		self:HideFrame();
		
		self.m_nSprIndex = self.m_nSprIndex+1;
		
		self.m_nIndex = self.m_nIndex+1;
		if(self.m_nIndex>#self.m_Frame) then 
--			self.m_nIndex = 1; 					--重置索引为 1 ;循环播放
			self:onAniPlayBackCall();
		end
	
		self:ShowFrame();
		self.m_NowTime = 0;
	end
end

function kd.BigAni:Stop()
	self:HideFrame();
	self.m_bPlay = false;
	self.m_nSprIndex = 0;
	self.m_nIndex = 0;
	self.m_NowTime = 0;
end

function kd.BigAni:Play()
	self:HideFrame();
	self.m_bPlay = true;
	self.m_nSprIndex = 0;
	self.m_nIndex = 0;
	self.m_NowTime = self.m_PerTime;	
end

function kd.BigAni:ShowFrame()
	if(self.m_nSprIndex>#self.m_Spr) then 
		local nIndex = self.m_nIndex;
		for i=1,#self.m_Spr do
			if(self.m_Frame[nIndex]) then 
				self.m_Spr[i]:SetTexture(self.m_Frame[nIndex]);
			end
			nIndex = nIndex+1;
			if(nIndex>#self.m_Frame) then nIndex=1; end
		end
		self.m_nSprIndex = 1; 
	end

	if(self.m_Spr[self.m_nSprIndex]==nil) then return; end
	self.m_Spr[self.m_nSprIndex]:SetVisible(true);
end

function kd.BigAni:HideFrame()
	if(self.m_Spr[self.m_nSprIndex]==nil) then return; end
	self.m_Spr[self.m_nSprIndex]:SetVisible(false);
end

function kd.BigAni:IsPlaying()
	return self.m_bPlay;
end

function kd.BigAni:StopAndClear()
	self:Stop();
	while (#self.m_Frame>0) do
		table.remove(self.m_Frame);
	end
	while (#self.m_Spr>0) do
		local Item = self.m_Spr[#self.m_Spr];
		table.remove(self.m_Spr);
		Item = nil;
	end
	self.m_Frame = {};
	self.m_Spr = {};
end

function kd.BigAni:onAniPlayBackCall()
	if self.m_father and self.m_father.onAniPlayBackCall then 
		return self.m_father:onAniPlayBackCall();
	else 
		self:StopAndClear();
	end
end