c_Require("Script/MiLiao/ModuleMessage/AChatBar.lua")
c_Require("Script/MiLiao/ModuleMessage/ACallChatView.lua")
c_Require("Script/MiLiao/ModuleMessage/ACallChatLeftItem.lua")
c_Require("Script/MiLiao/ModuleMessage/ACallChatRightItem.lua")
c_Require("Script/MiLiao/ModuleMessage/ACallChatTimeItem.lua")
c_Require("Script/MiLiao/ModuleMessage/AChatMYX.lua")
c_Require("Script/MiLiao/ModuleMessage/ACharMYXLable.lua")


local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

local local_tim = tim;
local local_tsdk = tim.sdk;
local local_tconv = tim.Conv;
local local_tmsg = tim.Msg;
local local_tgroup = tim.Group;
local local_tuser = tim.UserProfile;
local local_tfriend = tim.Friendship;
local tweenPro = TweenPro;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

idws =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM3           = 1001,
	ID_IMG_ML_MAIN_LM4           = 1002,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
}

-----------------------------------------------------------------------------------

AChat = kd.inherit(kd.Layer);

function AChat:init(mode)
	--self.m_mode = mode;		--模式 1私信  2小客服
	
	self.m_thViewBg = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/BeiJing.UI"), self);
	if (self.m_thViewBg) then
		self:addChild(self.m_thViewBg);
	end	
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/TYTouBu.UI"), self);
	self:addChild(self.m_thView)
	
	self.m_txtTitle = self.m_thView:GetText(idws.ID_TXT_NO0);
	self.m_txtTitle:SetHAlignment(kd.TextHAlignment.CENTER);
	self.m_txtTitle:SetString("名字")
	
	gDef:AddGuiByID(self,idws.ID_IMG_ML_MAIN_LM4,20,20,20,20)
	

	self.m_OTime = 0;		--上一条消息时间
	
	-- 聊天显示
	self.callChatView = kd.class(ACallChatView,false,false);
	self.callChatView:init();
	self:addChild(self.callChatView);
	
	local x,y =  self.callChatView:GetPos()
	self.callChatView:SetPos(x,y - 58)
		
	-- 聊天栏
	self.callChatBar = kd.class(AChatBar,false,true);
	self.callChatBar:init(1);
	self:addChild(self.callChatBar);
	self.callChatBar:SetVisible(false);
	
	--显示
	DC:RegisterCallBack("AChat.SetVisible",self,function(bool)
		self:SetVisible(bool)
	end)
	
	--显示
	DC:RegisterCallBack("AChat.Show",self,function(data,name,avatar,IsFocus,nView)
		self:Show(data,name,avatar,IsFocus,nView)
	end)
	
	--接收:SetData(data)
	DC:RegisterCallBack("AChat.SetData",self,function(data)
		self:SetData(data)
	end)
	
	--接收:SetData(data)
	DC:RegisterCallBack("AChat.SetMiyixia",self,function(data)
		self:SetMiyixia(data)
	end)
	
	--发送聊天
	DC:RegisterCallBack("AChat.send_msg",self,function(data)
		if self:IsVisible() then
			self:send_msg(data);
		end
		
		if data.message_is_from_self and data.message_elem_array[1].text_elem_content == "hi~很高兴认识你！"then
			gSink:GetConvList()
		end
	end)
	
	--接收
	DC:RegisterCallBack("AChat.OnRecvNewMsg",self,function(data)
		if self:IsVisible() then
			self:OnRecvNewMsg(data);
		else
			gSink:GetConvList();
		end
	end)
	
	--设置显示隐藏的动画模式
	local x, y = self:GetPos();
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
end


--显示聊天界面
function AChat:Show(data,name,avatar,IsFocus,nView)
	self.m_szView = nView or "MessageListView";	--从哪个界面过来 消息0 详情1  我的2
	
	if data.url then
		avatar = data.url;
	end
	
	if data.name then
		name = data.name;
	end
	
	if data.IsFocus~=nil then		
		IsFocus = data.IsFocus;
	end
	self.m_IsFocus = data.IsFocus;
	local id = data.id;
	if data.conv_id then
		id = data.conv_id;
	end
	
	if self.m_mode==1 then
		--self.m_Head:SetFace(avatar);
	end
	
	if data.last_msg then
		self.m_lastMessage = data.last_msg;
	elseif data.conv_last_msg then
		self.m_lastMessage = data.conv_last_msg;
	else
		self.m_lastMessage = nil;
	end
	name = gDef:GetName(name,7);

	self.m_txtTitle:SetString(name)
	
	DC:FillData("AChat.Cname",name)
	DC:FillData("AChat.right_avater",avatar)
	
	self:Setcreate_conv(id);
	self:SetVisible(true);
end	

function AChat:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
	if visible == false and self.m_OTime and self.m_OTime > 0 then
		--gSink:GetConvList();
		self:MsgReportReaded()
		gSink:ShowBottomBar(visible==false);
	end
	
	--隐藏界面时停止所有播放声音
	if visible==false and self.callChatView then
		DC:CallBack("PlayYuYinEnd",false);
		self:Clear();
	end
end

function AChat:onGuiToucBackCall(--[[int]] id)
	if id == idws.ID_IMG_ML_MAIN_LM4 then
		self:SetVisible(false)
	end
end

function AChat:OnTimerBackCall(id)
	if(id==1) then

	elseif (id==2) then		--小客服提醒5秒
		if self.m_thView then
			self.m_thView:SetViewVisible(false);
		end
	end
end

function AChat:Setcreate_conv(convid)
	self.m_dconv_id = convid;
	self.callChatBar:Setcreate_conv(convid);
	self.callChatBar:SetVisible(true);
	self.callChatBar:ReSet();
	
	--[[if convid~=gSink:GetServiceIMid() then
		self.callChatBar2:SetVisible(false);
		self.callChatBar:SetVisible(true);
		
		self.callChatBar:Setcreate_conv(convid);
	else
		self.callChatBar:SetVisible(false);
		self.callChatBar2:SetVisible(true);
		
		self.callChatBar2:Setcreate_conv(convid);
	end
	--]]
	
	if self.m_lastMessage==nil then
		self.m_lastMessage = {};
		--return;
	end
	
	
	--[[
	--构建user data
	local send_msg_data = {};
	send_msg_data.call_id = "msgReportReaded";
	send_msg_json = kd.CJson.EnCode(send_msg_data);
	
	--local str_json_v = kd.CJson.EnCode(json_value_msg);
	
	local convid = self.m_dconv_id;
	local convtype = 1;
	local ret = local_tmsg.msgReportReaded(convid, convtype, "", send_msg_json);
	if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
		echo("KD_LOG:TIM create send msg error code:"..ret);
	end--]]
	--消息上报已读
	self:MsgReportReaded()
	--------------------------------------------------------------------------------------------------	
	
	local data1 = 
	{
		[local_tmsg.MsgGetMsgListParam.kTIMMsgGetMsgListParamLastMsg] = self.m_lastMessage,
		[local_tmsg.MsgGetMsgListParam.kTIMMsgGetMsgListParamCount] = 50,
		[local_tmsg.MsgGetMsgListParam.kTIMMsgGetMsgListParamIsRamble] = true,
		[local_tmsg.MsgGetMsgListParam.kTIMMsgGetMsgListParamIsForward] = false,

 
--[[		kTIMMsgGetMsgListParamLastMsg  = self.m_lastMessage,
		kTIMMsgGetMsgListParamCount = 100,
		kTIMMsgGetMsgListParamIsRamble = false,
		kTIMMsgGetMsgListParamIsForward = true,--]]
	};


	data1 = kd.CJson.EnCode(data1);
	
	local data = {};
	data.call_id = "msgGetMsgList";
	data.call_name = self.m_szView;	--从哪个界面点过来的
	
	conv_json = kd.CJson.EnCode(data);
	
	if self.m_szView ~= "MiYiXia" then
		--获取指定会话的消息列表
		local ret = local_tmsg.msgGetMsgList(self.m_dconv_id,local_tconv.TIMConvType.kTIMConv_C2C, data1,conv_json);
		if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
			echo("KD_LOG:获取消息列表 error code:"..ret);
		end
	end
end


--发送消息
function AChat:send_msg(data)
	for i=1,#data.message_elem_array do
--[[		if data.message_elem_array[i].elem_type==local_tmsg.TIMElemType.kTIMElem_Text then
			local str = data.message_elem_array[i].text_elem_content;
			--self:InsertNewText(str, true, os.time(),gSink.m_UserData.avatar);
			
			self.callChatView:AddMsg(data.message_elem_array[i],true);
		elseif  data.message_elem_array[i].elem_type==local_tmsg.TIMElemType.kTIMElem_Image then	
		elseif  data.message_elem_array[i].elem_type==local_tmsg.TIMElemType.kTIMElem_Sound then	
		elseif  data.message_elem_array[i].elem_type==local_tmsg.TIMElemType.kTIMElem_Custom then		--自定义元素
		
			--aes解密
			local data = kd.Aes128DecodeStr(last.custom_elem_data,"%ObymLoJ^tF(W2EM");
			local ext = kd.Aes128DecodeStr(last.custom_elem_ext,"%ObymLoJ^tF(W2EM");
			data = kd.CJson.DeCode(data);
			if data==nil then
				return;
			end
			
			ext = kd.CJson.DeCode(ext);
			if ext==nil then
				return;
			end
			
			local a = string.find(ext.data.content,"\n")
			local str = string.sub(ext.data.content,1,a-1);
			str = str.."...";
			self:SetJianJie(str);
			
			
		elseif  data.message_elem_array[i].elem_type==local_tmsg.TIMElemType.kTIMElem_File then	
		elseif  data.message_elem_array[i].elem_type==local_tmsg.TIMElemType.kTIMElem_GroupTips then	
		elseif  data.message_elem_array[i].elem_type==local_tmsg.TIMElemType.kTIMElem_Face then		--表情元素
			local index = data.message_elem_array[i].face_elem_index;
			if index<10 then
				index = "0"..index;
			end
			local str = "ResAll/ChatFace/Emoji/emoji_"..index.."@2x.png";
			self:InsertNewImg(str,true,os.time(),gSink.m_UserData.avatar);
		end--]]
		
		--驱除眯一下自定义消息
	--[[	local endindex = #data
		for i = endindex,1,-1 do
			if data[i].message_elem_array[1].elem_type == 3 then
				table.remove(data,i)
			end
		end--]]
		
		--添加时间
		local time = data.message_client_time;
		
		if time-self.m_OTime>gDef.MesTimeReminder and 
				data.message_elem_array[i].elem_type ~=local_tmsg.TIMElemType.kTIMElem_Custom then
			local szTime = "";
			local day = os.date("%m月%d日",time);
			local newDay =  os.date("%m月%d日",os.time());
			if day~=newDay then
				szTime = os.date("%m-%d %H:%M",time);
			else
				szTime = os.date("%H:%M",time);
			end
			self.callChatView:AddTime(szTime);
		end
		
		self.m_OTime = time;  
		
		
			
		self.callChatView:AddMsg(data.message_elem_array[i],true);
		self.callChatView:AddEnd();
	end
end

--新消息回调
function AChat:OnRecvNewMsg(data)
	for j=1,#data do
		local data1 = data[j];
		local time = data1.message_server_time;
		for i=1,#data1.message_elem_array do
			if data1.message_sender~="admin" then
				if self.callChatView:IsVisible() and self.m_dconv_id == data1.message_conv_id  then
					--添加时间
					local time = data1.message_client_time;
					
					if time-self.m_OTime>gDef.MesTimeReminder then
						local szTime = "";
						local day = os.date("%m月%d日",time);
						local newDay =  os.date("%m月%d日",os.time());
						if day~=newDay then
							szTime = os.date("%m-%d %H:%M",time);
						else
							szTime = os.date("%H:%M",time);
						end
						self.callChatView:AddTime(szTime);
					end
					
					self.m_OTime = time;  
		
					self.callChatView:AddMsg(data1.message_elem_array[i]);
				else
					gSink:ShowBottomNotice(true);		--底部红点
				end
			end
		end
	end
	self.callChatView:AddEnd();
	
	self:MsgReportReaded()
end

--消息上报已读
function AChat:MsgReportReaded()
	--构建user data
	local send_msg_data = {};
	send_msg_data.call_id = "msgReportReaded";
	send_msg_json = kd.CJson.EnCode(send_msg_data);
	
	--local str_json_v = kd.CJson.EnCode(json_value_msg);
	
	local convid = self.m_dconv_id;
	local convtype = 1;
	local ret = local_tmsg.msgReportReaded(convid, convtype, "", send_msg_json);
	if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
		--echo("KD_LOG:TIM create send msg error code:"..ret);
	end
end


function AChat:SetData(data)
	self.m_data = data;
	
	for i=#data,1,-1 do
		if #data[i].message_elem_array>0 then
			
			--添加时间
			local time = data[i].message_client_time;
			
			if time-self.m_OTime>gDef.MesTimeReminder then
				local szTime = "";
				local day = os.date("%m月%d日",time);
				local newDay =  os.date("%m月%d日",os.time());
				if day~=newDay then
					szTime = os.date("%m-%d %H:%M",time);
				else
					szTime = os.date("%H:%M",time);
				end
				self.callChatView:AddTime(szTime);
			end
			
			self.m_OTime = time;  
			
			if data[i].message_sender == gSink:AddTimPre(gSink.m_User.userId) then
				self.callChatView:AddMsg(data[i].message_elem_array[1],true);
			else
				self.callChatView:AddMsg(data[i].message_elem_array[1]);
			end
		end
	end
	
	if self.m_lastMessage==nil or self.m_lastMessage=={} or self.m_lastMessage.message_elem_array==nil then
		return;
	end
	
	if  #self.m_lastMessage.message_elem_array>0  then
		--添加时间
		local time = self.m_lastMessage.message_client_time;
		
		if time-self.m_OTime>gDef.MesTimeReminder then
			local szTime = "";
			local day = os.date("%m月%d日",time);
			local newDay =  os.date("%m月%d日",os.time());
			if day~=newDay then
				szTime = os.date("%m-%d %H:%M",time);
			else
				szTime = os.date("%H:%M",time);
			end
			self.callChatView:AddTime(szTime);
		end
		self.m_OTime = time;  
		
		if self.m_lastMessage.message_sender == gSink:AddTimPre(gSink.m_User.userId) then
			self.callChatView:AddMsg(self.m_lastMessage.message_elem_array[1],true);
		else
			self.callChatView:AddMsg(self.m_lastMessage.message_elem_array[1]);
		end
	end
	
	self.callChatView:AddEnd(true);
end

function AChat:Clear()
	self.callChatView:Cls();
	self.m_lastMessage = nil;
	self.m_OTime = 0
end

function AChat:SetMiyixia(data)
	self.TagsList = data
end

function AChat:OnActionEnd()
	if self:IsVisible() and self.m_szView =="MiYiXia" then
		DC:CallBack("Mi_MatchingSucc.Show",false);
		DC:CallBack("Mi_MainLabel.m_boIsBack",true);
		DC:CallBack("Mi_MainLabel.Show",false);
	end
end