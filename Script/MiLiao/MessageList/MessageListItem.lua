--[[
	消息列表子项
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local local_tim = tim;
local local_tsdk = tim.sdk;
local local_tconv = tim.Conv;
local local_tmsg = tim.Msg;
local local_tgroup = tim.Group;
local local_tuser = tim.UserProfile;
local local_tfriend = tim.Friendship;

MessageListItem = kd.inherit(kd.Layer);
local impl = MessageListItem;
local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM            = 1001,
	ID_IMG_ML_MAIN_LM1           = 1002,
	ID_IMG_ML_MAIN_LM2           = 1003,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
	ID_TXT_NO1                   = 4002,
	ID_TXT_NO2                   = 4003,
	ID_TXT_NO3                   = 4004,
	--/* Custom ID */
	ID_CUS_ML_TX145_LM           = 6001,
}

function impl:init(father)
	self.m_father = father
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/XXLieBiao.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	self.m_sprBG = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM);
	
	--名字
	self.m_nickname = self.m_thView:GetText(idsw.ID_TXT_NO0)
	
	--个性签名
	self.m_sign = self.m_thView:GetText(idsw.ID_TXT_NO1)
	
	--头像
	self.m_cusFace = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_TX145_LM,nil,false,2);
	--月t日
	self.m_txtMD = self.m_thView:GetText(idsw.ID_TXT_NO2)
	self.m_txtMD:SetHAlignment(KDGame.TextHAlignment.RIGHT);
	--时分
	self.m_txtHM = self.m_thView:GetText(idsw.ID_TXT_NO3)
	self.m_txtHM:SetHAlignment(KDGame.TextHAlignment.RIGHT);
	--红点
	self.m_sprRed = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM1)
end

function impl:GetWH()
	return ScreenW,113*2
end	

--[[
				local last_msg = data[i].conv_last_msg;
				tab:SetNum(data[i].conv_unread_num);
				tab:Setconv_id(data[i].conv_id);
				tab:SetLast_msg(last_msg);
]]

--设置数据
function impl:SetData(data)
	--self.m_conv_id = data.conv_id
	--self.m_conv_unread_num = data.conv_unread_num
	--self.m_last_msg = data.last_msg
	--self.UserId = data.UserId
	--头像
	--self.m_cusFace:SetFace(gDef.domain ..data.Avatar);
	--设置名字
	--self.m_nickname:SetString(data.NickName)
	--个性签名
	--self.m_sign:SetString(data.Signature)
	
	if data==nil then
		return;
	end
	
	if data.name == nil then
		return 
	end
	self.m_data = data;	--保存用户数据
	
	data.name = gDef:GetName(data.name,10);
	
	self.m_nickname:SetString(data.name);
	if #data.last_msg.message_elem_array>0 then
		if data.last_msg.message_elem_array[1].elem_type==local_tmsg.TIMElemType.kTIMElem_Text then 
			data.last_msg.message_elem_array[1].text_elem_content = gDef:GetName(data.last_msg.message_elem_array[1].text_elem_content,10);
			self.m_sign:SetString(data.last_msg.message_elem_array[1].text_elem_content);
		elseif data.last_msg.message_elem_array[1].elem_type==local_tmsg.TIMElemType.kTIMElem_Custom then 
			local data = kd.CJson.DeCode(data.last_msg.message_elem_array[1].custom_elem_data)
			if data and data.conv_id == gSink.m_myconvid then
				self.m_sign:SetString("我开启了聊天，聊点什么内容呢~");
			else
				if data.name == nil then
					return 
				end
				self.m_sign:SetString(data.name .. "开启聊天，打个招呼吧~");
			end
		elseif data.last_msg.message_elem_array[1].elem_type==local_tmsg.TIMElemType.kTIMElem_Sound then 
			if data.last_msg.message_sender == gSink:AddTimPre(gSink.m_User.userId) then
				self.m_sign:SetString("我发送了一条语音消息");
			else
				self.m_sign:SetString("向你发送了一条语音消息");
			end
		end
	end
	
	--self:SetNum(data.num);
	self.m_sprRed:SetVisible(data.num > 0)
	self:SetDate(data.last_msg.message_client_time);
	--gDef:SetCustomFace(self,idsw.ID_CUS_MT_XX_TOUXIANG_TM,data.url);
	self.m_cusFace:SetFace(data.url);
end

--设置日期(年月)
function impl:SetDate(dwDate)
	szTime = os.date("%H:%M",dwDate);
	
	local hourMin = os.date("%H:%M",dwDate);
	
	local newDay =  os.date("%m月%d日",os.time());
	local day =  os.date("%m月%d日",dwDate);
	if day==newDay then
		newDay = "今天";
	else
		newDay = day
	end
	
	self.m_txtMD:SetString(newDay);
	
	self.m_txtHM:SetString(hourMin);
end	

			
--设置消息数量
function impl:SetNum(nNum)
	if nNum==0 then
		self.m_TxtNum:SetString("");
		self.m_sprSingleBJ:SetVisible(false);
	elseif nNum<10 then
		self.m_TxtNum:SetString(nNum);
		self.m_sprSingleBJ:SetVisible(true);
	elseif nNum<100 then
		self.m_TxtNum:SetString(nNum);
		self.m_sprManyBJ:SetVisible(true);
	else
		self.m_TxtNum:SetString("99+");
		self.m_sprManyBJ:SetVisible(true);
	end
end	


function impl:onGuiToucBackCall(id)
	--关注
	if id == idsw.ID_IMG_ML_MAIN3_LM then
		echo("关注")
	--移除
	elseif id == idsw.ID_IMG_ML_MAIN_LM5 then
		echo("移除")
	elseif id == idsw.ID_CUS_ML_TX145_LM then
		
	end
end

--[[

	关注/取消关注
"/michat/love"
userid
userkey
touserid
action （0-取消关注，1-关注）
成功消息：
{
    Result bool
}


拉黑/取消拉黑
"/michat/hate"
userid
userkey
touserid
action （0-取消拉黑，1-拉黑）
成功消息：
{
    Result bool
}

]]