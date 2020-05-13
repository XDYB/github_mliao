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

ACallChatRightItem = kd.inherit(kd.Layer);
local impl = ACallChatRightItem
local ids =
{
		--/* Image ID */
	ID_IMG_ML_MAIN2_LM           = 1001,
	ID_IMG_ML_MAIN_LM0           = 1002,
	ID_IMG_ML_MAIN_LM1           = 1003,
	ID_IMG_ML_MAIN_LM3           = 1004,
	ID_IMG_ML_MAIN_LM5           = 1005,
	ID_IMG_ML_MAIN_LM6           = 1006,
	ID_IMG_ML_MAIN_LM7           = 1007,
	ID_CUS_ML_TX147_LM           = 6001,
}

local WIDTH = ScreenW/2 -- 最大文字宽度
local LINE_COUNT = 20	-- 每行最大字符数 汉字=2字符
local FONT_SIZE = 40
local LINE_HEIGHT = 40  -- 行高
function impl:init(data,bYuYin)
	self.m_data = data;
	self.m_bYuYin = bYuYin;	--是否语音
	
	local txt = "";
	if bYuYin then
		txt = data.sound_elem_file_time.."’";
	else
		txt  = data.text_elem_content;
	end
	
	self.m_thView1 = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/XXQiPao2.UI"), self);
	self:addChild(self.m_thView1);
	local x,y = self.m_thView1:GetPos()
	self.m_thView1:SetPos(x - 110,y)
	
	self.sprTopL = self.m_thView1:GetSprite(ids.ID_IMG_ML_MAIN2_LM)
	local topL_x,topL_y = self.sprTopL:GetPos()
	local topL_w,topL_h = self.sprTopL:GetWH()
	self.sprTopC = self.m_thView1:GetSprite(ids.ID_IMG_ML_MAIN_LM0)
	local topC_x,topC_y = self.sprTopC:GetPos()
	local topC_w,topC_h = self.sprTopC:GetWH()
	self.sprTopR = self.m_thView1:GetSprite(ids.ID_IMG_ML_MAIN_LM1)
	local topR_x,topR_y = self.sprTopR:GetPos()
	local topR_w,topR_h = self.sprTopR:GetWH()
	
	self.sprCenter = self.m_thView1:GetSprite(ids.ID_IMG_ML_MAIN_LM3)
	
	self.sprBtmL = self.m_thView1:GetSprite(ids.ID_IMG_ML_MAIN_LM5)
	local btmL_x,_ = self.sprBtmL:GetPos()
	local btmL_w,btmL_h = self.sprBtmL:GetWH()
	self.sprBtmC = self.m_thView1:GetSprite(ids.ID_IMG_ML_MAIN_LM6)
	self.sprBtmR = self.m_thView1:GetSprite(ids.ID_IMG_ML_MAIN_LM7)
	local btmR_x,_ = self.sprBtmR:GetPos()
	local btmR_w,_ = self.sprBtmR:GetWH()
	
	local txtLen = gDef:GetTextCount(txt,false) -- 字数
	local txtWidth = gDef:GetTextLen(FONT_SIZE,txt)
	
	local line = 0 	-- 行数
	local txtW = 0  -- 文字宽度
	if txtWidth<=WIDTH then
		line = 1
		txtW = txtWidth
	else
		if txtWidth%WIDTH==0 then
			line = txtWidth/WIDTH
		else
			line = math.floor(txtWidth/WIDTH) + 1
		end
		txtW = WIDTH
	end
	
	local txtWW = txtW;
	
	if bYuYin then
		txtW = txtW+200;
	
		self.m_aniHuo = kd.class(kd.AniMultipleImg,self,1,3);
		self:addChild(self.m_aniHuo);
		self.m_aniHuo:SetVisible(false);
		
		
		self.m_sprYuYin = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"),1512,480,40,40);
		if self.m_aniHuo then 
			for i= 1,3 do
				local spr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"),1596-(i-1)*40,480,40,40);
				local value = self.m_aniHuo:InstFrameSpr(spr);
				local a = 0;
			end
		end

		if self.m_sprYuYin then
			self:addChild(self.m_sprYuYin);	
			self.m_sprYuYin:SetPos(WIDTH/2+450 - 150,topC_y+topC_h/2+FONT_SIZE*line/2)
		end
		
		if 	self.m_aniHuo then
			--self.m_aniHuo:SetMode(kd.AniPlayMode.HGEANIM_LOOP);
			self.m_aniHuo:SetPos(WIDTH/2+450 - 150,topC_y+topC_h/2+FONT_SIZE*line/2)
		end
	end
					
	-- 文字
	self.txt = kd.class(kd.StaticText,FONT_SIZE,txt,kd.TextHAlignment.CENTER,WIDTH,FONT_SIZE*line);
	self.txt:SetHAlignment(kd.TextHAlignment.LEFT);
	self:addChild(self.txt)
	self.txt:SetPos(WIDTH/2+ScreenW-txtWW-150 - 110,topC_y+topC_h/2+FONT_SIZE*line/2)
	
	self.txt:SetColor(0xffA2A2A2);
	
	-- 上
	self.sprTopC:SetScale(txtW/10,1)
	local _,y = self.sprTopC:GetPos()
	self.sprTopC:SetPos(topR_x-topR_w/2-txtW/2,y)
	self.sprTopL:SetPos(topR_x-topR_w/2-txtW-topR_w/2,y)
	-- 中
	self.sprCenter:SetScale((txtW+topL_w+topL_w)/10,(FONT_SIZE*line)/10)
	self.sprCenter:SetPos(topR_x-topR_w/2-txtW/2,topL_y+topL_h/2+FONT_SIZE*line/2)
	-- 下
	self.sprBtmL:SetPos(topR_x-topR_w/2-txtW-topR_w/2,topL_y+topL_h/2+(FONT_SIZE*line)+btmL_h/2)
	self.sprBtmC:SetScale(txtW/10,1)
	self.sprBtmC:SetPos(topR_x-topR_w/2-txtW/2,topL_y+topL_h/2+(FONT_SIZE*line)+btmL_h/2)
	self.sprBtmR:SetPos(btmR_x,topL_y+topL_h/2+(FONT_SIZE*line)+btmL_h/2)
	
	-- 获取宽高
	self.GetWH = function(this)
		return ScreenW,topL_y+topL_h/2+(FONT_SIZE*line)+btmL_h
	end
	
	self:SetColor(0xffffffff);

	--头像
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/XXDuiHuaTouXiangYou.UI"), self);
	self:addChild(self.m_thView);
	local avatar_me = DC:GetData("MyView.AvatarFile");
	self.m_cusRightFace = gDef:SetFaceForGame(self,ids.ID_CUS_ML_TX147_LM,avatar_me,false,2);
end

function impl:PlayYuYin()
	if self.m_aniHuo then
		self.m_aniHuo:Play();
		self.m_aniHuo:SetVisible(true);
	end
	
	self.m_sprYuYin:SetVisible(false);
	
	--TVideo.PlayVoice(data1.message_elem_array[i].sound_elem_file_id);
	--TVideo.DownloadVoice(data1.message_elem_array[i].sound_elem_task_id,kd.GetSysWritablePath().."videos/");

	--下载消息内元素到指定文件路径(图片、视频、音频、文件)
	--[[
		参数:										
		string 		json_download_elem_param		--下载的参数 JSON 字符串,详情请参考tim.msg.DownloadElemParam->[https://cloud.tencent.com/document/product/269/33553#downloadelemparam]
		string 		path							--下载文件保存路径
		string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
		
		注释1:json_download_elem_param内的参数皆可以在已收取到的消息JSON(Message)内找到
		
		返回值:
		tim.sdk.TIMResult							--是否调用成功
	]]
	
	
	local send_msg_data = {};
	send_msg_data.call_id = "msgDownloadElemToPath";
	send_msg_json = kd.CJson.EnCode(send_msg_data);
	
	local data2 = 
	{
		[local_tmsg.DownloadElemParam.kTIMMsgDownloadElemParamFlag] = self.m_data.sound_elem_download_flag,
		[local_tmsg.DownloadElemParam.kTIMMsgDownloadElemParamType] = self.m_data.elem_type,
		[local_tmsg.DownloadElemParam.kTIMMsgDownloadElemParamId] = self.m_data.sound_elem_file_id,
		[local_tmsg.DownloadElemParam.kTIMMsgDownloadElemParamBusinessId] = self.m_data.sound_elem_business_id,
		[local_tmsg.DownloadElemParam.kTIMMsgDownloadElemParamUrl] = self.m_data.sound_elem_url,
		--kTIMMsgDownloadElemParamFlag       = "msg_download_elem_param_flag",         -- uint,   只写, 从消息元素里面取出来,元素的下载类型
		--kTIMMsgDownloadElemParamType       = "msg_download_elem_param_type",         -- uint [TIMDownloadType](), 只写, 从消息元素里面取出来,元素的类型
		--kTIMMsgDownloadElemParamId         = "msg_download_elem_param_id",           -- string, 只写, 从消息元素里面取出来,元素的ID
		--kTIMMsgDownloadElemParamBusinessId = "msg_download_elem_param_business_id",  -- uint,   只写, 从消息元素里面取出来,元素的BusinessID
		--kTIMMsgDownloadElemParamUrl        = "msg_download_elem_param_url",          -- string, 只写, 从消息元素里面取出来,元素URL
	};

	data2 = kd.CJson.EnCode(data2);
	local path = "videos/";				
--[[	local ret = local_tmsg.msgDownloadElemToPath(data2,path, send_msg_json);
	if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
		echo("KD_LOG:TIM create send msg error code:"..ret);
	end--]]
	--判断语音是否下载过
	if gSink:IsYuYinDownLoad(self.m_data.sound_elem_url) then
		local code = TVideo.PlayVoice(kd.GetSysWritablePath().."videos/"..gSink:IsYuYinDownLoad(self.m_data.sound_elem_url));
		echo("code===="..code)
	else
		gDef:GetFile(self.m_data.sound_elem_url,path,function(filepath)
			--local localPath = "LocalFile/img/"..filename -- 本地路径
			--self:InitAmaze_Spr(localPath,w,h)
			--播放音频
			local code = TVideo.PlayVoice(filepath);
			local a = 0;
			--保存语音文件名
			gSink:SavaVoiceName(filepath);
		end)
	end			
end	

function impl:SetColor(color)
	self.sprTopL:SetColor(color);
	self.sprTopC:SetColor(color);
	self.sprTopR:SetColor(color);
	self.sprCenter:SetColor(color);
	self.sprBtmL:SetColor(color);
	self.sprBtmC:SetColor(color);
	self.sprBtmR:SetColor(color);
end

function impl:OnTimerBackCall(id)

end

function impl:StopYuYin()
	if self.m_aniHuo then
		self.m_aniHuo:Stop();
		self.m_aniHuo:SetVisible(false);
		TVideo.StopPlayVoice();
	end
	
	if self.m_sprYuYin then
		self.m_sprYuYin:SetVisible(true);
	end
end
	
function impl:Cls()
	self.m_aniHuo = nil;
end