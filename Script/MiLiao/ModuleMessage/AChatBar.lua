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

-----------------------------------------------------------------------------------

local ipx_luyin = 0;
if gDef.IphoneXView then
	ipx_luyin = 188;
end

AChatBar = kd.inherit(kd.Layer);

AChatBar.IDlis1 =
{
	--/* Image ID */
	ID_IMG_ML_BIAOQIANLAN_LM           = 1001,
	ID_IMG_ML_MAIN_LM                  = 1002,
	ID_IMG_ML_MAIN_LM1                 = 1003,
	--/* Text ID */
	ID_TXT_NO0                         = 4001,
}
local idsw1 = AChatBar.IDlis1;

--[[
	AChatBar.IDlis2 =
{
	--/* Image ID */
	ID_IMG_MT_BQL2_TM             = 1001,
	ID_IMG_MT_MAIN_TM             = 1002,
	ID_IMG_MT_MAIN2_TM1           = 1003,
}--]]
local idsw2 = AChatBar.IDlis2;

local idsw = nil;


function AChatBar:init(mode)	
	self.m_SendList = {};		--发送消息列表
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/ShuRuLan.UI"), self);
	idsw = idsw1;
	self:addChild(self.m_thView);	
	
	self.m_thView2 = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/ShuRuLan2.UI"), self);--按住说话
	self:addChild(self.m_thView2);	
	self.m_thView2:SetViewVisible(false);
	self.m_thView3 = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/ShuRuLan3.UI"), self);--松开结束
	self:addChild(self.m_thView3);	
	self.m_thView3:SetViewVisible(false);
	
	local x2,y2,w2,h2 = 0,0,0,0;
	local x3,y3,w3,h3 = 0,0,0,0;
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM,10,10,10,10);
	
	--说话图标
	self.m_sprYuYin1 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM);
	self.m_sprYuYin1:SetVisible(true);
	
	--打字图标
	self.m_sprYuYin2 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM1);
	self.m_sprYuYin2:SetVisible(false);

	--输入框
	local x,y,w,h = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN_LM1)
	-- 输入栏
	self.m_EditBox = gDef:AddEditBox(self,x+20,y,w-20,h,44,0xff000000,true);
	self.m_EditBox:SetMaxLength(100);
	self.m_EditBox:SetInputMode(kd.InputMode.SINGLE_LINE);		--SINGLE_LINE 用这个模式IOS上回车就可以来EditingReturn回调
    self.m_EditBox:SetReturnType(kd.KeyboardReturnType.SEND);
    self.m_EditBox:SetTitle("请输入消息...",0xff999999)
    self.m_EditBox.OnEditingDidEnd = function(this,text)  
       self:editBoxEditingDidEnd();
    end

	--回车键被按下或键盘的外部区域被触摸时
	self.m_EditBox.EditingReturn = function(this)  
		self:SendText();
    end
	
	--发送
	self.m_SendGui =  gDef:AddGuiByID(self,idsw.ID_TXT_NO0,50,100,50,100);
	
	
	self.m_ChatTime = kd.class(AChatTime, false, false);
	kd.AddLayer(self.m_ChatTime)
	--self:addChild(self.m_More); 
	self.m_ChatTime:init(self);	
	self.m_ChatTime:SetZOrder(999999);
	self.m_ChatTime:SetVisible(false)
	self.m_bSoundRecording = false;
	
	--点击时间
	self.m_TouchEndedTime = kd.SYSTEMTIME;
	self.m_TouchEndedTimehours = self.m_TouchEndedTime.Hour*60*60+self.m_TouchEndedTime.Minute*60 + self.m_TouchEndedTime.Second;
end

--当输入法文字输入完成回调
function AChatBar:editBoxEditingDidEnd()
	local str = self.m_EditBox:GetText();
	self.m_SendGui:SetGuiVisible(string.len(str)>0);
end

function AChatBar:SendText()
	local str = self.m_EditBox:GetText();
	if string.len(str)==0 then		--如果没有输入就不发送
		return;
	end
	
	local json_value_msg = {};
	json_value_msg[local_tmsg.Message.kTIMMsgSender] = gSink.m_myconvid;
	json_value_msg[local_tmsg.Message.kTIMMsgElemArray] ={};

	self.m_EditBox:SetText("");
	local json_msg = {};
	json_msg[local_tmsg.Elem.kTIMElemType] = local_tmsg.TIMElemType.kTIMElem_Text;
	json_msg[local_tmsg.TextElem.kTIMTextElemContent] = str;
	
	json_value_msg[local_tmsg.Message.kTIMMsgElemArray][1] = json_msg;
	
	--发送信息
	--构建user data
	local send_msg_data = {};
	send_msg_data.call_id = "send_msg";
	send_msg_json = kd.CJson.EnCode(send_msg_data);
	
	--json_value_msg[local_tmsg.Message.kTIMMsgElemArray][2] = json_msg1;
	
	local str_json_v = kd.CJson.EnCode(json_value_msg);
	
	local convid = self.m_convid;
	local convtype = 1;
	local ret = local_tmsg.msgSendNewMsg(convid, convtype, str_json_v, send_msg_json);
	if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
		echo("KD_LOG:TIM create send msg error code:"..ret);
	end
	
	--发送后清空列表
	self:DelAll();
end	

function AChatBar:onGuiToucBackCall(--[[int]] id)
	if(id==idsw.ID_TXT_NO0) then  
		self:SendText();
	--语音
	elseif(id==1002) then	
		--local bol = self.m_sprYuYin1:IsVisible();
		
		--说话图标
		--self.m_sprYuYin1:SetVisible(bol==false);
		--打字图标
		--self.m_sprYuYin2:SetVisible(bol);
		
		--语音文字说明
		--self.m_txtYuYin:SetVisible(bol);
		local bool = self.m_thView:IsViewVisible();
		
		self.m_EditBox:SetVisible(not bool);
		self.m_thView:SetViewVisible(not bool);
		self.m_thView2:SetViewVisible(bool);
		self.m_thView3:SetViewVisible(false);
	end
end

--恢复为输入框
function AChatBar:ReSet()
	self.m_EditBox:SetVisible(true);
	self.m_thView:SetViewVisible(true);
	self.m_thView2:SetViewVisible(false);
	self.m_thView3:SetViewVisible(false);
end


--是否上升
function AChatBar:SetUp(up)
	self.m_up = up;
end	

function AChatBar:ShowTime(bool)
	--[[self.m_ChatTime.m_sprTC:SetVisible(bool);
	self.m_ChatTime.m_txtTiShi:SetVisible(bool);
	self.m_ChatTime.m_txtTme:SetVisible(bool);--]]
	self.m_ChatTime:SetVisible(bool);
	if bool then
		self.m_nTime = 0;
		self:SetTimer(1000,1000,0xffffffff);
	else
		self:KillTimer(1000);
		--self.m_ChatTime.m_txtTme:SetString("00:00");
		--self.m_ChatTime.m_sprTC1:SetVisible(false);
	end
end
	
	
function AChatBar:onTouchBegan(x,y)
	--开始录音发送所有我的列表中的语聊用户
	local TouchTime = kd.GetLocalTime();
	local TouchTimehours = TouchTime.Hour*60*60+TouchTime.Minute*60 + TouchTime.Second;
	local len =0;
	if self.m_up then
		len = -500;
	end
	if(  TouchTimehours - self.m_TouchEndedTimehours  >= 1 ) then
		--输入框
		local a,b,c,d = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN_LM1)
	
		if gDef:InRect(x,y,a-c//2,b-d//2,a+c//2,b+d//2)   then
			--设置录音文件名
			--tmp_video_file = "videos/video_"..os.time()..".mp3";
			local localtime = kd.GetLocalTime();
			tmp_video_file = string.format("videos/%u%04d%02d%02d%02d%02d%02d.mp3",
						gSink:GetUser().UserId,localtime.Year,localtime.Month, 
						localtime.Day,localtime.Hour,localtime.Minute,localtime.Second);
			--开始录音
			local nRet,szError = TVideo.RecordingVoice(tmp_video_file);
		
			if (self.m_bSoundRecording == false) then
				self:ShowTime(true);
			end
			
			self.m_bSoundRecording = true;
			self.m_thView3:SetViewVisible(true);
			self.m_TouchEndedTime = kd.GetLocalTime();
			self.m_TouchEndedTimehours = self.m_TouchEndedTime.Hour*60*60+self.m_TouchEndedTime.Minute*60 + self.m_TouchEndedTime.Second;
			
			
			return true;
		end
	end
	
	return false;
end

function AChatBar:onTouchMoved(--[[float]] x, --[[float]] y)
	if self.m_bSoundRecording == true  then
		
		local a,b,c,d = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN_LM1)
		if gDef:InRect(x,y,a-c//2,b-d//2,a+c//2,b+d//2) == false then
			--self.m_ChatTime.m_sprTC1:SetVisible(true);
			--self.m_ChatTime.m_txtTiShi:SetString("松开手指，取消发送");
			self.m_ChatTime.m_thView1:SetViewVisible(false);
			self.m_ChatTime.m_thView2:SetViewVisible(true);
		else
			--self.m_ChatTime.m_sprTC1:SetVisible(false);
			--self.m_ChatTime.m_txtTiShi:SetString("手指上滑，取消发送");
			self.m_ChatTime.m_thView1:SetViewVisible(true);
			self.m_ChatTime.m_thView2:SetViewVisible(false);
		end
	end
	return;
end

function AChatBar:onTouchEnded(--[[float]] x, --[[float]] y)
	if (self.m_bSoundRecording == true) then
		self.m_bSoundRecording = false;
		self.m_thView3:SetViewVisible(false);
		self:ShowTime(false);
		
		local a,b,c,d = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN_LM1)
		if gDef:InRect(x,y,a-c//2,b-d//2,a+c//2,b+d//2)== true then
			if (string.len(tmp_video_file) > 0) then
				--停止录音
				TVideo.UploadVoice(tmp_video_file, true);
				--播放音频
				--local code = TVideo.PlayVoice(kd.GetSysWritablePath()..tmp_video_file);
				--local len = TVideo.GetAudioTime(tmp_video_file)
				local a=1;
			end

			--录音时间小于1秒就不发送
			if(self.m_nTime <= 1) then
				--停止录音并不发送
				--gSink:UploadVoice(false);
				TVideo.UploadVoice(tmp_video_file, false);
				
				--gSink:messagebox_default("录音时间不足1秒",nil,5);
			else
				--停止录音并发送
				--local tab = gSink:UploadVoice(true);
				TVideo.StopPlayVoice();
				--录完就发送语音
				local json_value_msg = {};
				json_value_msg[local_tmsg.Message.kTIMMsgSender] = gSink.m_myconvid;
				json_value_msg[local_tmsg.Message.kTIMMsgElemArray] ={};
				
				local json_msg = {};
				--声音元素
				json_msg[local_tmsg.Elem.kTIMElemType] = local_tmsg.TIMElemType.kTIMElem_Sound --[[local_tmsg.TIMElemType.kTIMElem_File--]];
				

				json_msg[local_tmsg.SoundElem.kTIMSoundElemFilePath] = kd.GetSysWritablePath()..tmp_video_file;
				json_msg[local_tmsg.SoundElem.kTIMSoundElemFileSize] = TVideo.GetAudioTime(tmp_video_file);
				json_msg[local_tmsg.SoundElem.kTIMSoundElemFileTime] = self.m_nTime;
				
				json_value_msg[local_tmsg.Message.kTIMMsgElemArray][1] = json_msg;
				
				--发送信息
				--构建user data
				local send_msg_data = {};
				send_msg_data.call_id = "send_msg";
				send_msg_json = kd.CJson.EnCode(send_msg_data);
				
				--json_value_msg[local_tmsg.Message.kTIMMsgElemArray][2] = json_msg1;
				
				local str_json_v = kd.CJson.EnCode(json_value_msg);

				local convid = self.m_convid--[["peach_44"--]];
				local convtype = 1;
				local ret = local_tmsg.msgSendNewMsg(convid, convtype, str_json_v, send_msg_json);
				if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
					echo("KD_LOG:TIM create send msg error code:"..ret);
				end
		
			end
		else
			--停止录音并不发送
			--gSink:UploadVoice(false);
			TVideo.UploadVoice(tmp_video_file, false);
			--TVideo.StopPlayVoice();
		end
	end
	return;
end

function AChatBar:OnTimerBackCall(id)
	if id==1000 then
		self.m_nTime = self.m_nTime+1;
		--[[local str = "00:"
		if self.m_nTime<10 then
			str = str.."0"..self.m_nTime;
		else
			str = str..self.m_nTime;
		end--]]
		
		--self.m_ChatTime.m_txtTme:SetString(str);
	end
end


function AChatBar:SetFace(szFace)
	local len = 0;
	for i=1,#self.m_SendList do
		if self.m_SendList[i].id==1 then		--文字
			len = len+gDef:GetTextLen(36,self.m_SendList[i].txt);
		elseif  self.m_SendList[i].id==2 then	--表情
			len = len+64;
		end
	end
	
	if len>=400 then		--超出就不能输入了
		return;
	end
	
	
	local index = szFace;
	if index<10 then
		index = "0"..index;
	end
	local path = "ResAll/ChatFace/Emoji/emoji_"..index.."@2x.png";
	--self:InsertNewImg(str, false, time,data1.message_sender_profile.user_profile_face_url);
	local spr = kd.class(kd.Sprite, path);
	if(spr) then
		self:addChild(spr);
		local tab = {id=2,EmojiIndex = szFace,object = spr};
		table.insert(self.m_SendList,tab);
	end

	self:UpdataView();
end

function AChatBar:DelAll()
	while #self.m_SendList>0 do
		self:RemoveChild(self.m_SendList[1].object);
		table.remove(self.m_SendList,1);
	end
	self.m_SendList = {};
	self.m_EditBox:SetText("");
end	

function AChatBar:DelFace()
	
	
	--[[local str = self.m_EditBox:GetText();
	local nFind = 0;
	for i=string.len(str),1,-1 do
		local byte = string.byte(str,i);
		if(byte == 0xF0 or byte == 0xE2) then
			nFind = i;
			break;
		end
		
		if(i<=string.len(str)-4) then
			break;
		end
	end
	--echo("EmojiFace:DelFace nFind="..nFind);
	
	if(nFind==0) then return; end
	if(nFind < string.len(str)-4) then return; end
	
	str = string.sub(str,1,nFind-1);
	self.m_EditBox:SetText(str);--]]
end

function AChatBar:ShowFace(bShow)
	self.m_Face:SetVisible(bShow);
end

function AChatBar:ShowMore(bShow)
	if(self.m_More) then self.m_More:SetVisible(bShow); end
end

function AChatBar:Setcreate_conv(convid)
	self.m_convid = convid;
	if convid~=gSink:GetServiceIMid() then
		
	else
	
	end
end


--语音时间
local IDlis3 =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM4           = 1001,
	ID_IMG_ML_MAIN2_LM           = 1002,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
}

AChatTime = kd.inherit(kd.Layer);
function AChatTime:init(father)	
	--语音时间UI
	self.m_thView1 = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/ShuRuTiShi.UI"), self);
	self:addChild(self.m_thView1);
	self.m_thView2 = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/ShuRuTiShi2.UI"), self);
	self:addChild(self.m_thView2);
	
	self.m_thView1:SetViewVisible(true);
	self.m_thView2:SetViewVisible(false);
	
	self.m_thView2:GetText(IDlis3.ID_TXT_NO0):SetString("松开手指，取消发送")
end



