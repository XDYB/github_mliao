

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local local_tim = tim;
local local_tsdk = tim.sdk;
local local_tconv = tim.Conv;
local local_tmsg = tim.Msg;
local local_tgroup = tim.Group;
local local_tuser = tim.UserProfile;
local local_tfriend = tim.Friendship;

ACallChatView = kd.inherit(kd.Layer);
local impl = ACallChatView

function impl:init()
	
	self.m_List = {};
	
	local offset = 40
	local len = 0 - offset
	local down = 0;
	if gDef.IphoneXView then
		len  = 30 - offset;
		down = 100;
	end

	self.Scroll = kd.class(AScrollA,true,true)
	self.Scroll:init(0,300+len,ScreenW,ScreenH-500-down + 156)
	self:addChild(self.Scroll)
	self.Scroll.OnClick = function(this,index)
		echo("==========index"..index)
		
		if self.m_List[index] and self.m_List[index].m_bYuYin then
			DC:CallBack("PlayYuYinEnd",false);
			self.m_List[index]:PlayYuYin();
		end
	end

	self.Scroll.OnDown = function(this)
		echo("==========下拉")
		this:BackPos() -- 复位
	end
	-- 下拉刷新提示
	--self.Scroll:AddDownLoad(LoadUI)
	
	
	DC:RegisterCallBack("CallChatView.DelNode",self,function(node)
		--self.Scroll:DelByItem(node)
	end)
	
	
	DC:RegisterCallBack("PlayYuYinEnd",self,function(bool)
		for i=1,#self.m_List do
			if self.m_List[i] and self.m_List[i].m_bYuYin then
				self.m_List[i]:StopYuYin();
			end
		end
	end)
	
end


--[[
{
"acceptTime":0.0,
"msg":"123",
"userId":5492220
}
--]]
--是否自己
function impl:AddMsg(data,bMe)
--[[	local user = gSink:GetUser()
	local userId = user.userId
	if userId == data.userId then--]]
	
	if bMe then		-- 自己
		if data.elem_type==local_tmsg.TIMElemType.kTIMElem_Text then
			
			local item = kd.class(ACallChatRightItem,false,false)
			item:init(data);
			self.Scroll:Add(item)
			
			table.insert(self.m_List,item);
		elseif data.elem_type==local_tmsg.TIMElemType.kTIMElem_Custom then
			self:AddMiyixia(data,1)
		elseif data.elem_type==local_tmsg.TIMElemType.kTIMElem_Sound then
			local item = kd.class(ACallChatRightItem,false,false)
			item:init(data,true)
			self.Scroll:Add(item);
			table.insert(self.m_List,item);
		end
	
	else		--对方
		if data.elem_type==local_tmsg.TIMElemType.kTIMElem_Text then
			local item = kd.class(ACallChatLeftItem,false,false)
			item:init(data);
			self.Scroll:Add(item);
			
			table.insert(self.m_List,item);
		elseif data.elem_type==local_tmsg.TIMElemType.kTIMElem_Custom then
			self:AddMiyixia(data,2)
		elseif data.elem_type==local_tmsg.TIMElemType.kTIMElem_Sound then
			local item = kd.class(ACallChatLeftItem,false,false)
			item:init(data,true)
			self.Scroll:Add(item);
			table.insert(self.m_List,item);
		end
	end
end

function impl:AddTime(dwTime)
	local item = kd.class(ACallChatTimeItem,false,false)
	item:init(dwTime);
	self.Scroll:Add(item);
	table.insert(self.m_List,item);
end	

function impl:AddMiyixia(data,tp)
	local item = kd.class(AChatMYX,false,false)
	item:init(data,tp);
	self.Scroll:Add(item);
	table.insert(self.m_List,item);
end

function impl:AddEnd(NoAni)
	if NoAni then
		self.Scroll:BackBottomNoAni();
	else
		self.Scroll:BackBottom();
	end
	
end	

--清除
function impl:Cls()
	for i=1,#self.m_List do
		self.m_List[i]:Cls();
	end
	self.m_List = {};
	self.Scroll:DelAll()
end