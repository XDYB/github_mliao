


local kd = KDGame;
local gCfg = KDConfigFix;
local gDef = GDefine;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
local gSink = G_ViewManager;

local local_tim = tim;
local local_tsdk = tim.sdk;
local local_tconv = tim.Conv;
local local_tmsg = tim.Msg;
local local_tgroup = tim.Group;
local local_tuser = tim.UserProfile;
local local_tfriend = tim.Friendship;

local impl = A_ViewManager

-- 消息更新回调
function impl:OnMsgUpdate(json_msg_array)
	
	local json_msg_table = kd.CJson.DeCode(json_msg_array);
	local msg = json_msg_table[1]
	-- ====================================================================
	--
	-- 							 群组会话 conv_type==2
	--
	-- ====================================================================	
	if msg.message_conv_type == 2 then
		local message_elem_array = msg.message_elem_array
		local message_elem = message_elem_array[1];
		
		if message_elem.elem_type==local_tmsg.TIMElemType.kTIMElem_Custom then	--是自定义才解码
			local custom_elem_data = message_elem.custom_elem_data
			local cusdatajson = KDGame.Aes128DecodeStr(custom_elem_data,"%ObymLoJ^tF(W2EM")
			local custdata = kd.CJson.DeCode(cusdatajson);
			-- 直播房间文字留言	
--[[			if custdata.type == "LiveSendMessage" then
				DC:CallBack("MulPartyChatTab.InsertNewText1",custdata.data);
				DC:CallBack("MulPartyVideoChat.InsertNewText1",custdata.data);
			end--]]
		elseif message_elem.elem_type==local_tmsg.TIMElemType.kTIMElem_Text then	 --文本
			local text_elem_content = message_elem.text_elem_content
			local tb_elem_content = kd.CJson.DeCode(text_elem_content)
			-- 直播房间文字留言	
			if tb_elem_content.type == "LiveSendMessage" then
				DC:CallBack("MulPartyChatTab.InsertNewText1",tb_elem_content.data);
				DC:CallBack("MulPartyVideoChat.InsertNewText1",tb_elem_content.data);
			end
		end
	end
end

-- 新消息回调
function impl:OnRecvNewMsg(json_msg_array)
	local json_msg_table = kd.CJson.DeCode(json_msg_array);
	local msg = json_msg_table[1]
	-- ====================================================================
	--
	-- 							 系统会话 conv_type==3
	--
	-- ====================================================================
	if msg.message_conv_type==local_tconv.TIMConvType.kTIMConv_System then
		local message_elem_array = msg.message_elem_array
		local message_elem = message_elem_array[1]
		local group_report_elem_group_id = message_elem.group_report_elem_group_id -- 群ID
		-- ===============================
		-- 群组系统通知元素
		-- ===============================
		if message_elem.elem_type == 8 then
			-- ==========================================
			-- 申请加群被同意（只有申请人自己接收到） 
			-- ==========================================
			if message_elem.group_report_elem_report_type == 2 then
				
			-- ==========================================
			-- 退群消息
			-- ==========================================
			elseif message_elem.group_report_elem_report_type == 5 then
				-- 直播房间内
				if self.roomdata then
					-- 直播房间群被解散
					if group_report_elem_group_id == self.roomdata.imGroup then
						local roomType = tonumber(self.roomdata.roomType)
						if roomType == 1 then
							-- 颜值电台房间关闭
							DC:CallBack("RdoParty.OnCloseRoom")
							gSink:ClsRoomData()
						else
							DC:CallBack("MulParty.OnCloseRoom")
							gSink:ClsRoomData()
						end
					-- 视频通话群被解散
					else
						DC:CallBack("CallManager.OpHungup")
					end
				-- 当前不在直播房间
				else
					-- 视频通话群被解散
					DC:CallBack("CallManager.OpHungup")
				end
			-- ==========================================
			-- 用户自定义通知 16
			-- ==========================================
			else
				local group_report_elem_user_data = message_elem.group_report_elem_user_data
				local cusdatajson = KDGame.Aes128DecodeStr(group_report_elem_user_data,"%ObymLoJ^tF(W2EM")
				local cusdata = kd.CJson.DeCode(cusdatajson);
				if cusdata then
					-- 自由房 房间更新
					if cusdata.type == "free-room-update-data" then
						local data = cusdata.data
						DC:CallBack("MulParty.CusMsg.free-room-update-data",data)
					-- 多对多 房间更新
					elseif cusdata.type == "room-UpdateData" then
						local data = cusdata.data
						DC:CallBack("MulParty.CusMsg.room-UpdateData",data)
					-- 一对多 房间更新
					elseif cusdata.type == "live-UpdateData" then
						local data = cusdata.data
						DC:CallBack("RdoParty.CusMsg.live-UpdateData",data)
					elseif cusdata.type == "live-GiftData" 
						or  cusdata.type == "room-GiftData-plus"
						or  cusdata.type == "room-GiftData" then	
						
						if self.m_mulMinView:IsVisible()==false then	--在房间内才播放礼物动画
							self:ShowAni(cusdata.data.giftData.id,cusdata.data.blindBoxGift);
						end
						
						local tab = {};
						tab.data = cusdata.data;
						tab.imGroup = message_elem.group_report_elem_group_id;
						DC:CallBack("MulPartyChatTab.InsertNewText4",tab)
						DC:CallBack("MulPartyVideoChat.InsertNewText4",tab)
						DC:CallBack("GiftCon.Show",tab.data);
					elseif cusdata.type=="BigvLoginNotice" 				--大V上线粉丝群发
						or cusdata.type=="LiveStartNotice"  then	 	--直播房间创建后的粉丝群发
						
					elseif cusdata.type=="TIM_GROUP_SYSTEM_DELETE_GROUP_TYPE" then
					
					-- =================================
					-- 通话2分钟倒计时
					-- =================================
					elseif cusdata.type == "TwoCountdown" then
						--[[
						{
							"type": "TwoCountdown",
							"data": {
								"imGroup": "videoGp_5492224_5482215_45259",
								"agoraId": "",
								"videoChatId": 5457141,
								"seconds": 60
							}
						}
						--]]
						local data = cusdata.data
						DC:CallBack("CallMain.TwoCountdown",data)
					-- ======================================================
					-- 隐藏倒计时
					-- ======================================================	
					elseif cusdata.type == "HiddenCountdown" then
						local data = cusdata.data
						DC:CallBack("CallMain.HiddenCountdown",data)
					end
				end
				
			end
		-- ===============================
		-- 资料变更消息元素
		-- ===============================	
		elseif message_elem.elem_type == 11 then
			-- 修改用户资料会回调这里
		end
		
		

	-- ====================================================================
	--
	-- 							 群组会话 conv_type==2
	--
	-- ====================================================================	
	elseif msg.message_conv_type==local_tconv.TIMConvType.kTIMConv_Group then		-- 群组会话
		
		local message_elem_array = msg.message_elem_array;
		local message_elem = message_elem_array[1];
			
		
		if message_elem.elem_type==local_tmsg.TIMElemType.kTIMElem_Text then
			local group_report_elem_user_data = message_elem.text_elem_content;
			if group_report_elem_user_data == "" or  group_report_elem_user_data==nil then return end

			-- ===================================================================================================
			-- 这里有点纠结 因为group_report_elem_user_data字段一会加密一会不加密 解密为空代表返回的字段没加密
			-- ===================================================================================================
			local cusdatajson = KDGame.Aes128DecodeStr(group_report_elem_user_data,"%ObymLoJ^tF(W2EM")
			local cusdata = kd.CJson.DeCode(cusdatajson);
			if cusdata == nil then
				cusdata = kd.CJson.DeCode(group_report_elem_user_data);
			end
			if cusdata then
				--飘屏	1
				if cusdata.type == "GlobalNotice" 			--公告
					or cusdata.type=="LiveStartGlobalNotice" 		--开直播间公告
					or cusdata.type=="UserAction" 					--用户行为推送
					or cusdata.type=="RedPacketGlobalNotice"  		--红包飘屏 
					or cusdata.type=="BigGift"  					--礼物飘屏 
					or cusdata.type=="BlindBoxBigGift" then 		--盲盒礼物飘屏 
					
					if self.m_TopAllLondspeaker:IsVisible()==false then		--顶部飘屏隐藏才显示滚动飘屏
						self.m_LondspeakerCon:Show(cusdata.data[1],cusdata.type);
					else
						local tab = {};
						tab.mode = 1;
						tab.data = cusdata.data[1];
						tab.type = cusdata.type;
						table.insert(self.m_ScreenList,tab);		--飘屏tab
					end
					
				elseif cusdata.type=="OpeningGuard" 	then			--开通女王守护
					if self.m_LondspeakerCon.isOver then
						self.m_TopAllLondspeaker:Show(cusdata.data[1],cusdata.type);
					else
						local tab = {};
						tab.mode = 2;
						tab.data = cusdata.data[1];
						tab.type = cusdata.type;
						table.insert(self.m_ScreenList,tab);		--飘屏tab
					end
					
				elseif cusdata.type=="Noble" then					--开通续费贵族
					if self.m_LondspeakerCon.isOver then
						self.m_TopAllLondspeaker:Show(cusdata.data[1],cusdata.type);
					else
						local tab = {};
						tab.mode = 2;
						tab.data = cusdata.data[1];
						tab.type = cusdata.type;
						table.insert(self.m_ScreenList,tab);		--飘屏tab
					end
				elseif cusdata.type=="BigvLoginNotice" 				--大V上线粉丝群发
				
					or cusdata.type=="LiveStartNotice"  then	 	--直播房间创建后的粉丝群发
					
				elseif cusdata.type=="LiveSendMessage" 	then			--群聊天：文本格式
					DC:CallBack("MulPartyChatTab.InsertNewText2",message_elem)
					DC:CallBack("MulPartyVideoChat.InsertNewText2",message_elem)
				elseif cusdata.type=="LiveSendEmoji" 	then			--表情：自定义消息
					DC:CallBack("MulPartyChatTab.InsertNewText2",message_elem)
					DC:CallBack("MulPartyVideoChat.InsertNewText2",message_elem)
			
				-- ============================================
				-- 视频通话发送文本消息
				-- ============================================
				elseif cusdata.type=="OneToOneSendMessage" then	
					local data = cusdata.data
					DC:CallBack("CallMain.OneToOneSendMessage",data)
					
				elseif cusdata.type=="LoginGlobalNotice" then			--至尊女皇上线通知
					local data = cusdata.data;
					
					if self.m_LondspeakerCon.isOver then
						self.m_TopAllLondspeaker:Show(data,cusdata.type);
					else
						local tab = {};
						tab.mode = 2;
						tab.data = data;
						tab.type = cusdata.type;
						table.insert(self.m_ScreenList,tab);		--飘屏tab
					end
				end
			end
			
		-- ======================================================
		-- 自定义消息 3
		-- ======================================================
		elseif message_elem.elem_type==local_tmsg.TIMElemType.kTIMElem_Custom then
			local custom_elem_data = message_elem.custom_elem_data
			local cusdatajson = KDGame.Aes128DecodeStr(custom_elem_data,"%ObymLoJ^tF(W2EM")
			local cusdata = kd.CJson.DeCode(cusdatajson);
			self:OnTIMCusMsg(cusdata)
		end	
		
	-- ====================================================================
	--
	-- 							 个人会话 conv_type==1
	--
	-- ====================================================================		
	elseif msg.message_conv_type==local_tconv.TIMConvType.kTIMConv_C2C  then		-- 个人会话

		
		
		local message_elem_array = msg.message_elem_array;
		local message_elem = message_elem_array[1];
		
		if message_elem==nil then
			return;
		end
		-- ===============================
		-- 文本消息
		-- ===============================
		
		
		if message_elem.elem_type == 3 then --自定义消息
			local cus_data = kd.CJson.DeCode(message_elem.custom_elem_data);
			if cus_data then
				if cus_data.type == "bemiyixia" then
					--被眯一下a
					DC:CallBack("AChat.BeMiyixa",cus_data)
				end
			end
		elseif message_elem.elem_type==0 then
			local text_elem_content = message_elem.text_elem_content;
			local cusdatajson = KDGame.Aes128DecodeStr(text_elem_content,"%ObymLoJ^tF(W2EM")
			if cusdatajson then 
				local cusdata = kd.CJson.DeCode(cusdatajson);
				if cusdata then
					-- ======================================================
					-- 通话呼入
					-- ======================================================
					if cusdata.type == "noticeOfflineCall" then
						local data = cusdata.data
						DC:CallBack("CallManager.CallIn",data)
						
						return;
					-- ======================================================
					-- 2分钟倒计时通知
					-- ======================================================	
					elseif cusdata.type == "TwoCountdown" then
						--[[
						{
							"type": "TwoCountdown",
							"data": {
								"imGroup": "videoGp_5492224_5482215_45259",
								"agoraId": "",
								"videoChatId": 5457141,
								"seconds": 60
							}
						}
						--]]
--						local data = cusdata.data
--						DC:CallBack("CallMain.TwoCountdown",data)
					-- ======================================================
					-- 隐藏倒计时
					-- ======================================================	
					elseif cusdata.type == "HiddenCountdown" then
--						local data = cusdata.data
--						DC:CallBack("CallMain.HiddenCountdown",data)
					end
				end
			else
--[[				----消息
				if self.MessageListLayer:IsVisible() then
					
					self.MessageListLayer:OnRecvNewMsg(json_msg_table);
				else
					--gSink:messagebox_default(text_elem_content)
				end--]]
			end
		end
		
		
		DC:CallBack("AChat.OnRecvNewMsg",json_msg_table);

	end
end

--飘屏播完回调
function impl:OnScreenCallback()
	if #self.m_ScreenList>0 then
		local tab = self.m_ScreenList[1];
		if tab.mode==1 then
			self.m_LondspeakerCon:Show(tab.data,tab.type);
		elseif tab.mode==2 then
			self.m_TopAllLondspeaker:Show(tab.data,tab.type);
		end
		
		table.remove(self.m_ScreenList,1);
	end
end	

-- 腾讯云自定义消息
function impl:OnTIMCusMsg(cusdata)
	local msgType = cusdata.type
	-- 开麦/禁麦
	if msgType == "LiveChangeMicro" then
		DC:CallBack("TIMCusMsg.LiveChangeMicro",cusdata.data)
	-- 视频通话发礼物	
	elseif msgType == "ChatSendGift" then
		-- do sth...
		self:ShowAni(cusdata.data.giftData.id);
		DC:CallBack("GiftCon.Show",cusdata.data);
	--房间内请求连麦(发表情)
	elseif msgType == "LiveSendEmoji" then	
		
		
		DC:CallBack("LiveSendEmoji.Show",cusdata.data);
	-- ===================================
	-- 颜值电台
	-- ===================================
	-- 点赞
	elseif msgType == "LiveSendStar" then
		-- 同时会来房间更新 为何还要来这个？
		
	elseif cusdata.type=="LiveSendMessage" 	then			--群聊天：文本格式
		--DC:CallBack("MulPartyChatTab.InsertNewText2",cusdata)
		--DC:CallBack("MulPartyVideoChat.InsertNewText2",cusdata)
	end
end


-- 消息回调
function impl:OnSendNewMsg(code, desc,json_params,user_data)
	if code == 0 then
		local tb_params = kd.CJson.DeCode(json_params)
		if tb_params then
			-- ====================================================================
			-- 							群组会话 conv_type==2
			-- ====================================================================	
			if tb_params.message_conv_type == 2 then
				local message_elem_array = tb_params.message_elem_array
				local message_elem = message_elem_array[1]
				-- ========================
				-- 文本消息
				-- ========================
				if message_elem.elem_type == 0 then
					local text_elem_content = message_elem.text_elem_content
					local tb_elem_content = kd.CJson.DeCode(text_elem_content)
					if tb_elem_content then
						if tb_elem_content.type=="OneToOneSendMessage" then
							local data = tb_elem_content.data
							DC:CallBack("CallMain.OneToOneSendMessage",data)
						end
					end
					
				end
			end
		end
	end
end


-- 发送群组文本消息
-- @imGroup 群会话ID
-- @tb_json_v table 消息体 
function impl:SendGpTextMsg(imGroup,tb_json_v)
	local user = gSink:GetUser()
	local userId = user.userId
	-- 组装消息体
	local json_value_text = {
		message_sender = self.m_Config.identifierPre..userId,
		message_elem_array = {
			[1] = {
				elem_type = 0,
				text_elem_content = kd.CJson.EnCode(tb_json_v)
			}
		}
	}
	local str_json_v = kd.CJson.EnCode(json_value_text)
	
	--[[
	local send_msg_data = {};
	send_msg_data.call_id = "send_msg";
	send_msg_json = kd.CJson.EnCode(send_msg_data);
	send_msg_json = "";
	--]]
	local ret = local_tmsg.msgSendNewMsg(imGroup,2,str_json_v, "");
	if ret == 0 then
		echo("接口调用成功")
	else
		echo("接口调用失败")
	end
end


-- 发送群组自定义消息
-- @imGroup 群会话ID
-- @tb_json_v table 消息体 
function impl:SendGpCustMsg(imGroup,tb_json_v)
	local user = gSink:GetUser()
	local userId = user.userId
	-- 组装消息体
	local json_value_text = {
		message_sender = self.m_Config.identifierPre..userId,
		message_elem_array = {
			[1] = {
				elem_type = 3,
				custom_elem_data =  kd.Aes128EncryptStr(kd.CJson.EnCode(tb_json_v),"%ObymLoJ^tF(W2EM"),
				custom_elem_desc = "",
				custom_elem_ext = "",
				custom_elem_sound = "",
			}
		}
	}
	local str_json_v = kd.CJson.EnCode(json_value_text);
	--[[
	local send_msg_data = {};
	send_msg_data.call_id = "send_msg";
	send_msg_json = kd.CJson.EnCode(send_msg_data);
	send_msg_json = "";
	--]]
	local ret = local_tmsg.msgSendNewMsg(imGroup,2,str_json_v,"");
	if ret == 0 then
		echo("接口调用成功")
	else
		echo("接口调用失败")
	end
end



--[[
/**
 * message_elem.elem_type
 */
kTIMElem_Text			0	文本元素
kTIMElem_Image			1	图片元素
kTIMElem_Sound			2	声音元素
kTIMElem_Custom			3	自定义元素
kTIMElem_File			4	文件元素
kTIMElem_GroupTips		5	群组系统消息元素
kTIMElem_Face			6	表情元素
kTIMElem_Location		7	位置元素
kTIMElem_GroupReport	8	群组系统通知元素
kTIMElem_Video			9	视频元素
kTIMElem_FriendChange	10	关系链变更消息元素
kTIMElem_ProfileChange	11	资料变更消息元素
--]]
--[[

/**
 *  群系统消息类型 message_elem.elem_type==8
 *  message_elem.group_report_elem_report_type
 */
kTIMGroupReport_None		0	未知类型
kTIMGroupReport_AddRequest	1	申请加群（只有管理员会接收到）
kTIMGroupReport_AddAccept	2	申请加群被同意（只有申请人自己接收到）
kTIMGroupReport_AddRefuse	3	申请加群被拒绝（只有申请人自己接收到）
kTIMGroupReport_BeKicked	4	被管理员踢出群（只有被踢者接收到）
kTIMGroupReport_Delete		5	群被解散（全员接收）
kTIMGroupReport_Create		6	创建群（创建者接收，不展示）
kTIMGroupReport_Invite		7	邀请加群（被邀请者接收）
kTIMGroupReport_Quit		8	主动退群（主动退出者接收，不展示）
kTIMGroupReport_GrantAdmin	9	设置管理员（被设置者接收）
kTIMGroupReport_CancelAdmin	10	取消管理员（被取消者接收）
kTIMGroupReport_RevokeAdmin	11	群已被回收（全员接收，不展示）
kTIMGroupReport_InviteReq	12	邀请加群（只有被邀请者会接收到）
kTIMGroupReport_InviteAccept13	邀请加群被同意（只有发出邀请者会接收到）
kTIMGroupReport_InviteRefuse14	邀请加群被拒绝（只有发出邀请者会接收到）
kTIMGroupReport_ReadedSync	15	已读上报多终端同步通知（只有上报人自己收到）
kTIMGroupReport_UserDefine	16	用户自定义通知（默认全员接收）
--]]

--发送自定义个人消息
--tb_json_v 消息类容
--toUserid 对方id
function impl:PMsgSendCustomMsg(tb_json_v,toUserid)
	local json_value_msg = {};
	json_value_msg[local_tmsg.Message.kTIMMsgSender] = self.m_myconvid;
	json_value_msg[local_tmsg.Message.kTIMMsgElemArray] ={};

	local json_msg = {};
	json_msg[local_tmsg.Elem.kTIMElemType] = local_tmsg.TIMElemType.kTIMElem_Custom;
	json_msg[local_tmsg.CustomElem.kTIMCustomElemData] = tb_json_v;
	
	json_value_msg[local_tmsg.Message.kTIMMsgElemArray][1] = json_msg;
	
	local send_msg_data = {};
	send_msg_data.call_id = "send_msg";
	send_msg_json = kd.CJson.EnCode(send_msg_data);
	
	local str_json_v = kd.CJson.EnCode(json_value_msg);
	
	local convid = self.m_User.IMPre .. toUserid
	local convtype = local_tconv.TIMConvType.kTIMConv_C2C;
	local ret = local_tmsg.msgSendNewMsg(convid, convtype, str_json_v, send_msg_json);
	if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
		echo("KD_LOG:TIM create send msg error code:"..ret);
	end
end	

--给对方发一条文本消息
function impl:PMsgSendTextMsg(str,toUserid)
	local json_value_msg = {};
	json_value_msg[local_tmsg.Message.kTIMMsgSender] = self.m_myconvid;
	json_value_msg[local_tmsg.Message.kTIMMsgElemArray] ={};

	local json_msg = {};
	json_msg[local_tmsg.Elem.kTIMElemType] = local_tmsg.TIMElemType.kTIMElem_Text;
	json_msg[local_tmsg.TextElem.kTIMTextElemContent] = str;
	
	json_value_msg[local_tmsg.Message.kTIMMsgElemArray][1] = json_msg;
	
	local send_msg_data = {};
	send_msg_data.call_id = "send_msg";
	send_msg_json = kd.CJson.EnCode(send_msg_data);
	
	local str_json_v = kd.CJson.EnCode(json_value_msg);
	
	local convid = self.m_User.IMPre .. toUserid
	local convtype = local_tconv.TIMConvType.kTIMConv_C2C;
	local ret = local_tmsg.msgSendNewMsg(convid, convtype, str_json_v, send_msg_json);
	if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
		echo("KD_LOG:TIM create send msg error code:"..ret);
	end

end

--创建会话
--toUserid 对方userid
--call_name 回调用名称
function impl:ConversationCreate(toUserid,call_name)
	local create_conv_data = {};
	create_conv_data.call_id = "create_conv";
	create_conv_data.call_name = call_name;
	create_conv_json = kd.CJson.EnCode(create_conv_data);
	
	local convid = self.m_User.IMPre .. toUserid
	local ret = local_tconv.convCreate(convid, local_tconv.TIMConvType.kTIMConv_C2C, create_conv_json);
	if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
		echo("KD_LOG:TIM create conv error code:"..ret);
	end
end

-- 获取最近会话列表(用于消息列表)
function A_ViewManager:GetConversationList()
	local data = {};
	data.call_id = "convGetConvList";
	conv_json = kd.CJson.EnCode(data);
	local ret = local_tconv.convGetConvList( conv_json);
	if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
		echo("KD_LOG:获取消息列表 error code:"..ret);
	end
end


