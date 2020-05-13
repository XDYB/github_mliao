--[[

咪一下 -- 背景

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

MiBg = kd.inherit(kd.Layer);
local impl = MiBg;
	
local tweenPro = TweenPro;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/BeiJing.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	-- 添加背景
	local spr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/MeYiXiaBG.png"));
	self.m_thView:addChild(spr);
	spr:SetPos(ScreenW/2, ScreenH/2);
	
	if self.m_Player== nil then
		-- 播放器
		self.m_Player = kd.class(kd.VideoView,ScreenW,ScreenH,10000,0);
		self.m_Player:SetPos(ScreenW/2,ScreenH/2);
		self:addChild(self.m_Player);
		self.m_Player:SetPos(ScreenW/2,ScreenH/2);
		self.m_Player.OnplayError = function(this,err_code,err_msg)
			self.m_Player:Stop();
		end
		-- 播放结束回调
		self.m_Player.OnplayEnd = function(this)
			self:StartPlay(true);
		end
		-- 读取到视频信息回调
		self.m_Player.OnVideoInfo  = function(this,w,h,--[[float]] r)	
			local scaleX,scaleY = GetAdapterScale(w,h,ScreenW,ScreenH);
			echo("视频 w="..scaleX*w.." h="..scaleX*h)
			self.m_Player:SetScale(scaleX,scaleX);
			self.m_Player:SetVisible(true);
		end
	end
	
	if self.m_Player then
		self.m_Player:SetVisible(false);
	end
	
	DC:RegisterCallBack("MiBg.Show",self,function(bo)
		self:SetVisible(bo);
	end)
	DC:RegisterCallBack("MiBg.StartPlay",self,function(bo)
		self:StartPlay(bo);
	end)
	
	self:StartPlay(true);
	tweenPro:SetTimeout(1000,function ()
		self:StartPlay(false);
	end)
end

function impl:StartPlay(bo)
	if self.m_Player == nil then
		return ;
	end
	if bo then
		self.m_Player:Play(self:GetVideoUrl());
	else
		self.m_Player:Stop();
	end
end

-- 获取播放视频路径
function impl:GetVideoUrl()
	local videoFile = gDef.GetResPath("ResAll/DongXiao/BeiJing.mp4")
	if gDef.IphoneXView then
		videoFile = gDef.GetResPath("ResAll/DongXiao/BeiJingX.mp4")
	end
	return videoFile
end
