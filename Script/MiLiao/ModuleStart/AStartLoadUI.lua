--[[

启动界面

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AStartLoadUI = kd.inherit(kd.Layer);

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM                 = 1001,
	ID_IMG_ML_DENGLULOGO_LM           = 1002,
	--/* Button ID */
	ID_BTN_ML_MAIN_LM                 = 3001,
	--/* Text ID */
	ID_TXT_NO3                        = 4001,
	ID_TXT_NO4                        = 4002,
}

function AStartLoadUI:init(father)
	

	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/DengLu.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	self.m_thView:SetViewVisible(false);
	
	--立即进入
	self.m_btnIn =self.m_thView:GetButton(idsw.ID_BTN_ML_MAIN_LM);
	self.m_btnIn:SetTitle("登录/注册",46, 0xffffffff);
	self.m_btnIn:SetVisible(false);
	
	--用户注册协议
	self.m_guiAgree = gDef:AddGuiByID(self,idsw.ID_TXT_NO4,40,100,40,100)
	self.m_guiAgree:SetVisible(false);
	
	self.m_AVideoView= kd.class(AVideoView, false, true);
	self:addChild(self.m_AVideoView);
    self.m_AVideoView:init(self);
	self.m_AVideoView:SetVisible(true);
	
	DC:RegisterCallBack("AStartLoadUI.ShowLogin",self,function()
		self:ShowLogin();
	end)
	DC:FillData("AStartLoadUI.IsInHtml",false);
	-- Test
	--[[self.m_txt1 = kd.class(kd.StaticText,100,"",kd.TextHAlignment.CENTER,ScreenW,100);
	self:addChild(self.m_txt1)
	self.m_txt1:SetPos(ScreenW/2,300)
	self.m_txt1:SetColor(0xff000000)
	self.m_gui =  gDef:AddGuiBySpr(self,self.m_txt1,100,200,200,200,200)
	self.m_txt1:SetVisible(false);
	self.m_gui:SetVisible(false);--]]

end


function AStartLoadUI:ShowLogin()
	-- 测试代码（只在pc端显示）
	if kd.GetSystemType() == kd.SystemType.OS_WIN32 then
		if self.m_txt1 and self.m_gui then
			self.m_txt1:SetVisible(true);
			self.m_gui:SetVisible(true);
		end
	end
	self.m_btnIn:SetVisible(true);
	self.m_guiAgree:SetVisible(true);
	self.m_thView:SetViewVisible(true);
end

function AStartLoadUI:OnTimerBackCall(id)

end 


function AStartLoadUI:onGuiToucBackCall(--[[int]] id)
	if id==idsw.ID_BTN_ML_MAIN_LM then
		gSink:ShowLoginLayer()
		--进入登录页
		DC:CallBack("ALogin.Show",true);
		echo("进入登录页面");
	elseif id==idsw.ID_TXT_NO4 then		--用户协议
		DC:FillData("AStartLoadUI.IsInHtml",true);
		gSink:ShowHtml("用户协议",gDef.agreement)
	elseif id == 100 then
--		gSink:ShowLayer("AHomeIndex")
--		DC:CallBack("MiOneView.Show",true);
	end
end

function AStartLoadUI:SetVisible(bool)
    kd.Node.SetVisible(self,bool);
end


local idsw1 =
{
	--/* Image ID */
	ID_IMG_MT_MAIN2_TM           = 1001,
	--/* Button ID */
	ID_BTN_MT_MAIN_TM            = 3001,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
	ID_TXT_NO1                   = 4002,
	ID_TXT_NO2                   = 4003,
	ID_TXT_NO3                   = 4004,
	ID_TXT_NO4                   = 4005,
}

AVideoView = kd.inherit(kd.Layer);
function AVideoView:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/BeiJing.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	if self.m_Player== nil then
		-- 播放器
		self.m_Player = kd.class(kd.VideoView,ScreenW,ScreenH,10000,0);
		self.m_Player:SetPos(ScreenW/2,ScreenH/2);
		self:addChild(self.m_Player);
		self.m_Player:SetPos(ScreenW/2,ScreenH/2);
		self.m_Player.OnplayError = function(this,err_code,err_msg)
			--if kd.IsNullPTR(this._object) then
				--return gSink:messagebox_default("播放器  object Is Null 1 ");
			--end
			-- 异步错误回调
			self.m_Player:Stop();
		end
		-- 播放结束回调
		self.m_Player.OnplayEnd = function(this)
			--if kd.IsNullPTR(this._object) then
				--return gSink:messagebox_default("播放器  object Is Null  2");
			--end
			--local url = self:GetVideoUrl()
			--this:Play(url);
			self:SetVisible(false);
			DC:CallBack("AStartLoadUI.ShowLogin");
		end
		-- 读取到视频信息回调
		self.m_Player.OnVideoInfo  = function(this,w,h,--[[float]] r)	
			--if kd.IsNullPTR(this._object) then
				--return gSink:messagebox_default("播放器  object Is Null  3");
			--end
			local scaleX,scaleY = GetAdapterScale(w,h,ScreenW,ScreenH);
			echo("视频 w="..scaleX*w.." h="..scaleX*h)
			self.m_Player:SetScale(scaleX,scaleX);
			self.m_Player:SetVisible(true);
		end
	end
	
	if self.m_Player then
		--local videoUrl = self:GetVideoUrl();
		--if kd.IsNullPTR(self.m_Player._object) then
			--return gSink:messagebox_default("播放器  object Is Null  4");
		--end
		self.m_Player:SetVisible(false);
		--self.m_Player:Play(videoUrl);
	end
end

function AVideoView:SetVisible(bool)
  kd.Node.SetVisible(self,bool);
  if self.m_Player then
    if bool then
		local videoUrl = self:GetVideoUrl();
        self.m_Player:Play(videoUrl);
		--self:SetTimer(1000,8000,1);
    else
        --self.m_Player:Stop();
    end
  end
end

-- 获取播放视频路径
function AVideoView:GetVideoUrl()
	local videoFile = gDef.GetResPath("ResAll/DongXiao/QiDong.mp4")

	return videoFile
end


function AVideoView:OnTimerBackCall(id)
	if id==1000 then
		self:SetVisible(false);
		DC:CallBack("AStartLoadUI.ShowLogin");
	end
end 