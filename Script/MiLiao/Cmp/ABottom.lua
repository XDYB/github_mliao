
local kd = KDGame;
local gDef = gDef;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
local gSink = A_ViewManager
ABottom = kd.inherit(kd.Layer);
local impl = ABottom
local ids = {
	ID_IMG_MT_BQL2_TM            = 1001,
	ID_IMG_MT_MAIN2_TM           = 1002,
	ID_IMG_MT_MAIN_TM            = 1003,
	ID_IMG_MT_MAIN_TM1           = 1004,
	ID_IMG_MT_MAIN_TM2           = 1005,
	ID_IMG_MT_MAIN_TM3           = 1006,
	ID_IMG_MT_MAIN_TM4           = 1007,
	ID_IMG_MT_MAIN_TM5           = 1008,
	ID_IMG_MT_MAIN_TM6           = 1009,
	ID_IMG_MT_MAIN_TM7           = 1010,
	--/* Custom ID */
	ID_CUS_MT_MAIN_TM            = 6001,
}


function impl:init(w)
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/BiaoQianLan.UI"), self);
	self:addChild(self.m_thView)
	
	self.objHome = {
		sprOn = self.m_thView:GetSprite(ids.ID_IMG_MT_MAIN_TM4),
		sprOff = self.m_thView:GetSprite(ids.ID_IMG_MT_MAIN_TM),
	}
	self.objHome.gui = gDef:AddGuiByID(self,ids.ID_IMG_MT_MAIN_TM4,10,50,10,50)
	
	self.objVideo = {
		sprOn = self.m_thView:GetSprite(ids.ID_IMG_MT_MAIN_TM5),
		sprOff = self.m_thView:GetSprite(ids.ID_IMG_MT_MAIN_TM1),
	}
	self.objVideo.gui = gDef:AddGuiByID(self,ids.ID_IMG_MT_MAIN_TM5,10,50,10,50)
	
	self.objChat = {
		sprOn = self.m_thView:GetSprite(ids.ID_IMG_MT_MAIN_TM6),
		sprOff = self.m_thView:GetSprite(ids.ID_IMG_MT_MAIN_TM2),
		sprDot = self.m_thView:GetSprite(ids.ID_IMG_MT_MAIN2_TM),
		
		SetDot = function (this,bool)		--是否显示红点
			this.sprDot:SetVisible(bool);
		end
	}
	self.objChat.gui = gDef:AddGuiByID(self,ids.ID_IMG_MT_MAIN_TM6,10,50,10,50)
	self.objChat.sprDot:SetVisible(false);
	
	
	
	self.objMe = {
		sprOn = self.m_thView:GetSprite(ids.ID_IMG_MT_MAIN_TM7),
		sprOff = self.m_thView:GetSprite(ids.ID_IMG_MT_MAIN_TM3),
	}
	self.objMe.gui = gDef:AddGuiByID(self,ids.ID_IMG_MT_MAIN_TM7,10,50,10,50)
	
	
	self.objs = {self.objHome,self.objVideo,self.objChat,self.objMe}
	
	for i,v in ipairs(self.objs) do
		v.SetOff = function(this)
			this.sprOn:SetVisible(false)
			this.sprOff:SetVisible(true)
		end
		v.SetOn = function(this)
			this.sprOn:SetVisible(true)
			this.sprOff:SetVisible(false)
		end
		v:SetOff()
	end
	self.objHome:SetOn()
	
	local x,y,w,h = self.m_thView:GetScaleRect(ids.ID_CUS_MT_MAIN_TM)
	gDef.BottomH = h
end

function impl:onGuiToucBackCall(--[[int]] id)
	for i,v in ipairs(self.objs) do
		v:SetOff()
	end
	-- 首页
	if id == ids.ID_IMG_MT_MAIN_TM4 then
		self.objHome:SetOn()
		gSink:ShowLayer("AHomeIndex")
	-- 视频
	elseif id == ids.ID_IMG_MT_MAIN_TM5 then
		self.objVideo:SetOn()
		gSink:ShowLayer("VListIndex")
	-- 私信	
	elseif id == ids.ID_IMG_MT_MAIN_TM6 then
		self.objChat:SetOn()
		gSink:ShowLayer("ChatLayer")
	-- 我
	elseif id == ids.ID_IMG_MT_MAIN_TM7 then
		self.objMe:SetOn()
		gSink:ShowLayer("MeLayer")
	end
	
end

function impl:Cls()
	for i,v in ipairs(self.objs) do
		v:SetOff()
	end
	self.objHome:SetOn()
end
--显示底部通知
function impl:ShowBottomNotice(bVisible)
	self.objChat:SetDot(bVisible);
end