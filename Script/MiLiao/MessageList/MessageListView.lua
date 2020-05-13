--[[
	消息列表
]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

MessageListView = kd.inherit(kd.Layer);
local impl = MessageListView;

local local_tim = tim;
local local_tsdk = tim.sdk;
local local_tconv = tim.Conv;
local local_tmsg = tim.Msg;
local local_tgroup = tim.Group;
local local_tuser = tim.UserProfile;
local local_tfriend = tim.Friendship;

function impl:init()
	local thview = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/BeiJing.UI"), self);
	self:addChild(thview)
	
	self.m_kongbai = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/KongBaiYe.UI"), self);
	self:addChild(self.m_kongbai)
	self.m_kongbai:GetText(4001):SetHAlignment(kd.TextHAlignment.CENTER);
	self.m_kongbai:GetText(4001):SetString("你还没有私信消息哦~")
	self.m_kongbai:SetViewVisible(false)
	
	self.Title = kd.class(Title,false,false)
	self.Title:init(self)
	self.Title:SetTitle("消息")
	self:addChild(self.Title)
	self.Title:SetVisible(false)
	local x, y = self.Title:GetGoBackPos()
	
	self.m_txtTitle = kd.class(kd.StaticText,70,"消息",kd.TextHAlignment.CENTER, ScreenW, 80);
	self:addChild(self.m_txtTitle);
	self.m_txtTitle:SetColor(0xff353235);
	self.m_txtTitle:SetPos(x + 50,y - 20);
	
	-- 创建滚动
	self.Scroll = kd.class(ScrollEx,true,true)
	local headH = self.Title:GetH();
	local offset = 0
	if gDef.IphoneXView then
		offset = 78
	end
	self.Scroll:init(0,headH,ScreenW,ScreenH - headH - 150 - offset)
	self:addChild(self.Scroll)
--	self.Scroll:ShowBorder()
	
	-- 获取模版
	self.Scroll.OnGetTemplate = function(this,index)
		return MessageListItem;
	end
	
	self.Scroll.OnClick = function(this,index)
		echo("列表"..index);
		--显示
		local Data = {touserid = gSink:RemoveTimPre(self.data[index].id)};
		gSink:Post("michat/is-hate",Data,function(data)
			if data.Result then
				if data.IsBlacklist then
					gSink:messagebox_default("你已将TA拉入黑名单")
					return;
				end
				if data.IsBeBlacklist then
					gSink:messagebox_default("TA已将您拉入黑名单")
					return;
				end
				--self.Chat:SetVisible(true);
				--self.Chat:Show(self.data[index]);
				DC:CallBack("AChat.SetVisible",true)
				DC:CallBack("AChat.Show",self.data[index])
			else
				gSink:messagebox_default(data.ErrMsg)
			end
		end);
	end

	-- 下拉
	self.Scroll.OnDown = function(this)
		if self:IsVisible() then
			gSink:GetConvList();
		end
		this:BackPos();
	end
	
	self.Scroll:AddDownLoad(LoadUI)
	self.Scroll:AddUpLoad(LoadUI)
	
	--显示
	DC:RegisterCallBack("MessageListView.Show",self,function(bool)
		self:SetVisible(bool)
		--[[--请求 
			gSink:Post("michat/is-hate",{touserid = 43 },function (data)
				if data.Result then 
					if data.IsBlacklist then 
						return gSink:messagebox_default("你已将TA拉入黑名单")
					end
					
					if data.IsBeBlacklist then 
						return gSink:messagebox_default("TA已将您拉入黑名单")
					end
					
					--echo("拨打视频");  --跳转页面
					echo("私信")
					local create_conv_data = {};
					create_conv_data.call_id = "create_conv";
					create_conv_data.call_name ="MessageListView.create_conv";
					create_conv_json = kd.CJson.EnCode(create_conv_data);
					
					local convid = gSink:AddTimPre(43);
					local ret = local_tconv.convCreate(convid, local_tconv.TIMConvType.kTIMConv_C2C, create_conv_json);
					if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
						echo("KD_LOG:TIM create conv error code:"..ret);
					end
				
				else
					gSink:messagebox_default(data.ErrMsg);
					
				end
			end);--]]
	end);
	
	DC:RegisterCallBack("MessageListView.convGetConvList",self,function(data)
		self:convGetConvList(data)
	end);
	
	DC:RegisterCallBack("MessageListView.msgGetMsgList",self,function(data)
		self:msgGetMsgList(data)
	end);
	
	DC:RegisterCallBack("MessageListView.create_conv",self,function(data)
		self:create_conv(data)
	end);
	
	DC:RegisterCallBack("MessageListView.Clear",self,function()
		self:Clear()
	end);
	
	self.m_bNotice = false
end

function impl:create_conv(data)
	self.m_convData = data;
	
	DC:CallBack("AChat.Show",data,"我是","",false,"MessageListView")
end

function impl:Clear()
	self.m_data = nil;
	--self.Chat:Clear();
	self.Scroll:DelAll();
end

function impl:SetVisible(bool)
	kd.Node.SetVisible(self,bool);
	
	
--	gSink:ShowBottomBar(bool==false);
	
	--有数据了就不用了每次打开都请求，下拉刷新请求就行
	if bool and self.m_data==nil then
		gSink:GetConvList();
	end
end


function impl:convGetConvList(data)
	--dump(data);
		
	self.m_MessageList = {};
	
	local conv_id = {};  --腾讯云id
	local bBottomNotice = false;		--消息通知红点
	for i=1,#data do
		if data[i].conv_id=="admin" then	--系统消息
		
		else
--[[		local_conv.TIMConvType = {
				kTIMConv_Invalid = 0, -- 无效会话
				kTIMConv_C2C = 1,     -- 个人会话
				kTIMConv_Group = 2,   -- 群组会话
				kTIMConv_System = 3,  -- 系统会话
			};
--]]
			
			if  data[i].conv_type==local_tconv.TIMConvType.kTIMConv_C2C then	--只处理个人会话
				--if gSink:AddTimPre(gSink.m_User.userId)==data[i].conv_last_msg.message_conv_id
					--or gSink:AddTimPre(gSink.m_User.userId)==data[i].conv_last_msg.message_sender then
					
					table.insert(conv_id,data[i].conv_id);
				
					local tab = {};
					tab.id = data[i].conv_id;
					tab.num = data[i].conv_unread_num;
					tab.last_msg = data[i].conv_last_msg;
					table.insert(self.m_MessageList,tab);
					
					if tab.num>0 then
						bBottomNotice = true;
					end
				--end
				
				self.m_data = data;
			end
		end
	end
	
	gSink:ShowBottomNotice(bBottomNotice);		--底部显示消息红
	
	local tab = {touseridlist = {}};
	for i=1,#conv_id do
		if gSink:RemoveTimPre(conv_id[i])==nil then		--用户数据不存在了就返回
			return;
		end
		
		table.insert(tab.touseridlist,gSink:RemoveTimPre(conv_id[i]));
	end
	gSink:Post("michat/get-userinfolist",tab,function(res)
		if res.Result then
			self:userinfo_list(res.UserInfoList);
		else
			gSink:messagebox_default(res.ErrMsg);
		end
	end,false)
end

--用户信息列表
function impl:userinfo_list(data)
	local tab = {};				--去掉空数据
	for i=1,#data do
		for j=1,#self.m_MessageList do
			if gSink:RemoveTimPre(self.m_MessageList[j].id) == tostring(data[i].UserId)  then
				local name = data[i].Nickname;
				
				self.m_MessageList[j].name = name;
				self.m_MessageList[j].url = gDef.domain..data[i].AvatarFile;
				self.m_MessageList[j].IsFocus = data[i].IsFocus;
				
				table.insert(tab,self.m_MessageList[j]);
			end
		end
	end
	
	self:LoadData(tab);
end	


--获取指定用户列表的个人资料
function impl:profileGetUserProfileList(data)
	--dump(data);
	for i=1,#data do
		for j=1,#self.m_MessageList do
			if self.m_MessageList[j].id==data[i].user_profile_identifier then
				local name = data[i].user_profile_nick_name;
				if string.len(name)<=0 then
					name = self.m_MessageList[j].id;
				end
				
				self.m_MessageList[j].name = name;
				self.m_MessageList[j].url = data[i].user_profile_face_url;
			end
		end
	end
	
	self:LoadData(self.m_MessageList);
end

--[[
	Result bool
    UserInfoList [
        {
            UserId int
            Nickname string
            AvatarFile string
            IsFocus bool
        },
        ...
    ]
]]

function impl:LoadData(data)
	self.data = copy(data);
	self.Scroll:SetData(self.data);
	self.m_kongbai:SetViewVisible(#self.data == 0)
end

function impl:ClsData()
	self.Scroll:DelAll();
	self.data = nil;
end


--获取指定会话的消息列表
function impl:msgGetMsgList(data)
	--self.Chat:SetData(data);
	DC:CallBack("AChat.SetData",data)
end

