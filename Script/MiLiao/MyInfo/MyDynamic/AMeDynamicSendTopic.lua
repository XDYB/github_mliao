--[[
	发布动态界面
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

AMeDynamicSendTopic = kd.inherit(kd.Layer);

-- 判断上传视频还是相框
local flag = false;
-- 判断相框2是否可以点击
local flag2 = nil;
-- 判断相框3是否可以点击
local flag3 = nil;
-- 判断相框4是否可以点击
local flag4 = nil;
local flag5 = nil;

--判断是否点击话题
local flagTopic1 = nil;
local flagTopic2 = nil;
local flagTopic3 = nil;

local flagPhonto = true; 

local x_Ip = 0;
-- 存放我的拼图的路径
local UserPhoto = "LocalFile/UserPhoto/";
local idsw = 
{
--/* Image ID */
	ID_IMG_ML_MAIN2_LM1               = 1001,
	ID_IMG_ML_MAIN2_LM2               = 1002,
	ID_IMG_ML_MAIN2_LM3               = 1003,
	ID_IMG_ML_MAIN2_LM4               = 1004,
	ID_IMG_ML_MAIN2_LM11              = 1005,
	ID_IMG_ML_MAIN2_LM12              = 1006,
	ID_IMG_ML_MAIN2_LM21              = 1007,
	ID_IMG_ML_MAIN2_LM22              = 1008,
	ID_IMG_ML_MAIN2_LM31              = 1009,
	ID_IMG_ML_MAIN2_LM32              = 1010,
	ID_IMG_ML_MAIN2_LM41              = 1011,
	ID_IMG_ML_MAIN2_LM411             = 1012,
	ID_IMG_ML_MAIN2_LM412             = 1013,
	ID_IMG_ML_MAIN2_LM413             = 1014,
	ID_IMG_ML_MAIN2_LM4131            = 1015,
	ID_IMG_ML_MAIN2_LM41311           = 1016,
	ID_IMG_ML_MAIN_LM                 = 1017,
	ID_IMG_ML_MAIN_LM1                = 1018,
	ID_IMG_ML_MAIN_LM8                = 1019,
	ID_IMG_ML_MAIN_LM9                = 1020,
	ID_IMG_ML_MAIN_LM10               = 1021,
	ID_IMG_ML_MAIN_LM11               = 1022,
	ID_IMG_ML_MAIN_LM12               = 1023,
	ID_IMG_ML_MAIN_LM13               = 1024,
	--/* Button ID */
	ID_BTN_ML_MAIN_LM                 = 3001,
	--/* Text ID */
	ID_TXT_NO1                        = 4001,
	ID_TXT_NO4                        = 4002,
	ID_TXT_NO5                        = 4003,
	ID_TXT_NO6                        = 4004,
	--/* Custom ID */
	ID_CUS_ML_MAIN2_LM                = 6001,
	ID_CUS_ML_MAIN_LM0                = 6002,
	ID_CUS_ML_MAIN_LM1                = 6003,
	ID_CUS_ML_MAIN_LM2                = 6004,
}

function AMeDynamicSendTopic:init()
	
	-- 背景			
	local backGroud = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/BeiJing.UI"), self);
	self:addChild(backGroud);

	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/DTFaBu.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	-- 输入框
	local x,y,w,h = self.m_thView:GetScaleRect(idsw.ID_TXT_NO6) 
	self.m_editSign = gDef:AddEditBox(self,550,300,900,300,44,0xff333333,true);
	self.m_editSign:SetMaxLength(14);
	self.m_editSign:SetTitle("记录这一刻...",0xffCCCCCC);
	self.m_editSign:SetInputMode(kd.InputMode.SINGLE_LINE);
    self.m_editSign:SetInputFlag(kd.InputFlag.SENSITIVE);
	self.m_editSign:SetReturnType(kd.KeyboardReturnType.GO);
	self.m_text = self.m_editSign:GetText();
	self.m_editSign.OnTextChanged = function(this,text)  
       self:OnTextChanged();
    end
	-- 文字数量
	self.m_txtNum = self.m_thView:GetText(idsw .ID_TXT_NO5);
	self.m_txtNum:SetString("0/14");
	-- 话题删除按钮
	self.m_sprCloseTopic = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM13);
	self.m_sprCloseTopic:SetVisible(false);
	-- 话题1
	self.m_sprTopic1Left = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM11);
	
	if gDef.IphoneXView then
		self.m_sprTopic1Left:SetPos(62,676);
	else
		self.m_sprTopic1Left:SetPos(62,609);
	end
	
	self.m_sprTopic1Middle = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM21);
	self.m_sprTopic1Right = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM31);
	self.guiTopic1 = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN2_LM21,0,30,0,30);
	local szStr1 = "#萌新来袭#";
	self.m_txtMsg1 = kd.class(kd.StaticText,32,szStr1,kd.TextHAlignment.CENTER, 400, 0);
	self:addChild(self.m_txtMsg1);
	self.m_txtMsg1:SetColor(0xffffffff);
	self.m_Topic1TextX,self.m_Topic1TextY = self.m_sprTopic1Middle:GetPos();
	self.m_txtMsg1:SetPos(self.m_Topic1TextX, self.m_Topic1TextY);
	self:SetTopic1ColorGray();
	-- 话题2
	self.m_sprTopic2Left = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM12);
	self.m_sprTopic2Middle = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM22);
	self.m_sprTopic2Right = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM32);
	self.guiTopic2 = gDef:AddGuiBySpr(self,self.m_sprTopic2Middle,idsw.ID_IMG_ML_MAIN2_LM22,0,30,0,30)
	local szStr2 = "#我有超能力#";
	self.m_txtMsg2 = kd.class(kd.StaticText,32,szStr2,kd.TextHAlignment.CENTER, 400, 0);
	self:addChild(self.m_txtMsg2);
	self.m_txtMsg2:SetColor(0xffffffff);
	self.m_Topic2TextX, self.m_Topic2TextY = self.m_sprTopic2Middle:GetPos();
	self.m_txtMsg2:SetPos(self.m_Topic2TextX,self.m_Topic2TextY);
	self:SetTopic2ColorGray();
	-- 话题3
	self.m_sprTopic3Left = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM1);
	self.m_sprTopic3Middle = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM2);
	self.m_sprTopic3Right = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM3);
	self.guiTopic3 = gDef:AddGuiBySpr(self,self.m_sprTopic3Middle,idsw.ID_IMG_ML_MAIN2_LM2,0,30,0,30)
	local szStr3 = "#给我一首歌的时间#";
	self.m_txtMsg3 = kd.class(kd.StaticText,32,szStr3,kd.TextHAlignment.CENTER, 400, 0);
	self:addChild(self.m_txtMsg3);
	self.m_txtMsg3:SetColor(0xffffffff);
	self.m_Topic3TextX, self.m_Topic3TextY = self.m_sprTopic3Middle:GetPos();
	self.m_txtMsg3:SetPos(self.m_Topic3TextX, self.m_Topic3TextY);
	self:SetTopic3ColorGray();
	
	-- 照片框1
	self.m_sprPhoto1  = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM4);
	self.m_guiPhoto1 = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_MAIN2_LM,nil,true);
	self.m_guiPhoto1:SetFace();
	self.m_deletePhoto1 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM9);
	self.guiDeltePhoto1 = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM9,10,10,10,10);
	self.guiDeltePhoto1:SetVisible(false);

	-- 照片框2
	self.m_sprPhoto2  = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM41);
	self.m_sprPhoto2 :SetVisible(false);
	self.m_deletePhoto2 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM10);
	self.guiDeltePhoto2 = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM10,10,10,10,10);
	self.guiDeltePhoto2:SetVisible(false);
	
	self.m_guiPhoto2 = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_MAIN_LM0,nil,true);
	self.m_guiPhoto2:SetFace();

	-- 照片框3
	self.m_sprPhoto3  = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM411);
	self.m_sprPhoto3 :SetVisible(false);
	self.m_deletePhoto3 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM11);
	self.guiDeltePhoto3 = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM11,10,10,10,10);
	self.guiDeltePhoto3:SetVisible(false);
	
	self.m_guiPhoto3 = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_MAIN_LM1,nil,true);
	self.m_guiPhoto3:SetFace();
	
	-- 照片框4
	self.m_sprPhoto4  = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM412);
	self.m_sprPhoto4 :SetVisible(false);
	self.m_deletePhoto4 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM12);
	self.guiDeltePhoto4 = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM12,10,10,10,10);
	self.guiDeltePhoto4:SetVisible(false);

	self.m_guiPhoto4 = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_MAIN_LM2,nil,true);
	self.m_guiPhoto4:SetFace();
	
	self.m_guilist = {}
	self.m_guilist[self.m_guiPhoto1.clickGui.id] = 1
	self.m_guilist[self.m_guiPhoto2.clickGui.id] = 2
	self.m_guilist[self.m_guiPhoto3.clickGui.id] = 3
	self.m_guilist[self.m_guiPhoto4.clickGui.id] = 4
	
	-- 播放按钮
	self.m_Play1 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM413);
	self.m_Play2 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM4131);
	self.m_Play3 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM41311);
	self.m_Play1 :SetVisible(false);
	self.m_Play2 :SetVisible(false);
	self.m_Play3 :SetVisible(false);
	
	self.m_itemList = {
		[1] = {
			bg = self.m_sprPhoto1,
			face = self.m_guiPhoto1,
			del = self.guiDeltePhoto1,
			voideicon = self.m_Play1,
		},
		[2] = {
			bg = self.m_sprPhoto2,
			face = self.m_guiPhoto2,
			del = self.guiDeltePhoto2

		},
		[3] = {
			bg = self.m_sprPhoto3,
			face = self.m_guiPhoto3,
			del = self.guiDeltePhoto3
		},
		[4] = {
			bg = self.m_sprPhoto4,
			face = self.m_guiPhoto4,
			del = self.guiDeltePhoto4

		},
	}
	-- 发布按钮
	self.m_btnSend = self.m_thView:GetButton(idsw.ID_BTN_ML_MAIN_LM);
	self.m_btnSend:setEnabledImg(gDef.GetResPath("ResAll/Main2.png"),{
	x = 1387,
	y = 1057,
	width = 526,
	height = 166});
	self.m_btnSend:SetEnable(false);
	
	-- 返回上一界面
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM1,10,10,10,10);
	
	-- 注册数据中心
	DC:RegisterCallBack("AMeDynamicSendTopic.Show",self,function(bool)
		self:Clear();
		self:SetVisible(bool)
		gSink:ShowBottomBar(false);
	end)
end


function AMeDynamicSendTopic:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

-- 清理
function AMeDynamicSendTopic:Clear()
	if self.m_editSign then 
		self.m_editSign:SetText("");
	end 

	if self.m_txtNum then 
		self.m_txtNum:SetString("0/14");
	end 
	--	重置3个话题标签
	self:ResetMessage();
	-- 初始状态
	self:InitialState();
end

-- 重置所有的话题标签
function AMeDynamicSendTopic:ResetMessage()
	-- 删除话题,恢复原位
	if self.guiClose then
		self.guiClose :SetVisible(false);
	end
	self.m_sprCloseTopic:SetVisible(false);
	self.m_txtMsg1:SetVisible(true);
	self.m_txtMsg2:SetVisible(true);
	self.m_txtMsg3:SetVisible(true);
	self:openAllTopic();
	self.guiTopic1:SetVisible(true);
	self.guiTopic3:SetVisible(true);
	self.guiTopic2 :SetVisible(true);

	self:TopicTwo();
	
	self:SetTopic1ColorGray();
	self:SetTopic2ColorGray();
	self:SetTopic3ColorGray();
	
	flagTopic1 = false;
	flagTopic2 = false;
	flagTopic3 = false;
end

-- 初始状态
function AMeDynamicSendTopic:InitialState()
	self.m_btnSend:SetEnable(false);
	flag2 = nil ; 
	flag3 = nil; 
	flag4 = nil;
	self.m_index = 0;
	self.m_szFileName = nil;
	self.m_szFilePath = nil;
	self.m_szCoverPath = nil;
	self.m_send = nil;
	
	self.m_photos = {};
	self.m_filelist = {};
	self.m_photosName = {};
	self.m_photoids = {};
	
	self.m_videoids = {};
	self.m_tempPhoto = {}

	self.m_videos = {}
	self.m_photoItems = {}
	self.m_type = nil;
	self.m_bUpLoad = false;
	self.m_dwVideoTime = 0;
	self.m_r = 0;
	
	self.m_deletePhoto1:SetVisible(false);
	self.m_guiPhoto1:SetFace();
	self.m_Play1 :SetVisible(false);
	
	-- 照片框2
	self.m_sprPhoto2 :SetVisible(false);
	self.m_deletePhoto2:SetVisible(false);
	self.guiDeltePhoto2:SetVisible(false);
	
	-- 照片框3
	self.m_sprPhoto3 :SetVisible(false);
	self.m_deletePhoto3 :SetVisible(false);
	self.guiDeltePhoto3:SetVisible(false);
	
	-- 照片框4
	self.m_sprPhoto4 :SetVisible(false);
	self.m_deletePhoto4 :SetVisible(false);
	self.guiDeltePhoto4:SetVisible(false);
	
	if self.m_guiPhoto2 then
		self.m_guiPhoto2:SetVisible(false);
		self.m_guiPhoto2:SetFace();
	end
	if self.m_guiPhoto3 then
		self.m_guiPhoto3:SetVisible(false);
		self.m_guiPhoto3:SetFace();
	end
	if self.m_guiPhoto4 then
		self.m_guiPhoto4:SetVisible(false);
		self.m_guiPhoto4:SetFace();
	end
	self:updatePhoto()
end

-- 检测是否可以点击上传
function AMeDynamicSendTopic:Check()
	self.m_text = self.m_editSign:GetText();
	if string.len(self.m_text) >0 then 
		if #self.m_videos > 0 then
			-- 修改成可以点击
			self.m_btnSend:SetEnable(true);	
		elseif #self.m_photos  > 0 then
			-- 修改成可以点击
			self.m_btnSend:SetEnable(true);	
		else
			self.m_btnSend:SetEnable(false);		--不可点击
		end
	else
		self.m_btnSend:SetEnable(false);		--不可点击
	end
end

function AMeDynamicSendTopic:OnTextChanged()
	self.m_text = self.m_editSign:GetText();
	self.m_text = string.gsub(self.m_text, " ", "");
	if  string.len(self.m_text)> 0  then 
		local len = gDef:GetTextCount(self.m_text,true);
		if len>14 then len = 14;end
		self.m_txtNum:SetString(string.format("%d/14",len));
		self:Check();
	else
		self.m_btnSend:SetEnable(false);		--不可点击
	end
end

function AMeDynamicSendTopic:onGuiToucBackCall(--[[int]] id)
	local index = self.m_guilist[id]
	if index then
		self.m_index = index
	end
	if id == idsw.ID_CUS_ML_MAIN2_LM then
		-- 相框1选择
		self:sendAll();
		self.m_send = self.m_guiPhoto1;
	elseif id == idsw.ID_CUS_ML_MAIN_LM0 and flag2 == true  then
		-- 相框2选择
		self:sendPhoto();
		self.m_send = self.m_guiPhoto2;
		flag3 = true
	elseif id == idsw.ID_CUS_ML_MAIN_LM1 and flag3 == true  then
		-- 相框3选择
		self:sendPhoto();
		self.m_send = self.m_guiPhoto3;
		flag4 = true 
	elseif id == idsw.ID_CUS_ML_MAIN_LM2  and flag4 == true  then
		-- 相框4选择
		self:sendPhoto();
		self.m_send = self.m_guiPhoto4;
		flag5 = true;
	elseif id == idsw.ID_IMG_ML_MAIN_LM9   then
		-- 删除照片1
		if flag2 == false then
			table.remove(self.m_videos,1);
		else
			table.remove(self.m_photos,1);
		end
		self:updatePhoto()
	elseif id == idsw.ID_IMG_ML_MAIN_LM10 then
		table.remove(self.m_photos,2);
		self:updatePhoto()
	elseif id == idsw.ID_IMG_ML_MAIN_LM11 then
		table.remove(self.m_photos,3);
		self:updatePhoto()
	elseif id == idsw.ID_IMG_ML_MAIN_LM12 then	
		table.remove(self.m_photos, self.m_index);
		table.remove(self.m_photos,4);
		self:updatePhoto()
	elseif id == idsw.ID_BTN_ML_MAIN_LM then
		-- 发布动态
		if flag2 then
			gSink:ShowLoading();
			self:SubmitPhotos();
		else
			if self.m_dwVideoTime <=30 then 
				gSink:ShowLoading();
				self:SubmitVideo();
			else
				gSink:messagebox_default("视频时长不能超过30秒哦~");
			end
		end
		DC:CallBack("Add.Show",true);
	elseif id == idsw.ID_IMG_ML_MAIN_LM1  then
		-- 返回上一界面
		DC:CallBack("AMeDynamicSendTopic.Show",false);
	elseif id == idsw.ID_IMG_ML_MAIN2_LM21  then
		-- 点击话题1
		self:SetTopic1color();
		flagTopic1 = true;
		-- 隐藏话题2,3,gui
		self.m_txtMsg2:SetVisible(false);
		self.m_txtMsg3:SetVisible(false);
		self:closeTopic2();   
		self:closeTopic3();
		self.guiTopic2:SetVisible(false);
		self.guiTopic3:SetVisible(false);
		-- 显示删除按钮,设置坐标
		self.m_sprCloseTopic:SetVisible(true);
		if gDef.IphoneXView then
			x_Ip = 40;
			self.m_sprCloseTopic:SetPos(320,676);
		else
			self.m_sprCloseTopic:SetPos(320,609);
		end
		self.guiClose = gDef:AddGuiBySpr(self,self.m_sprCloseTopic,idsw.ID_IMG_ML_MAIN_LM13,0,0,0,0);
	elseif id == idsw.ID_IMG_ML_MAIN2_LM22 then
		-- 点击话题2
		self:SetTopic2color();
		flagTopic2 = true;
		-- 设置坐标
		if gDef.IphoneXView then
			self.m_sprTopic2Left:SetPos(90,676);
			self.m_sprTopic2Middle :SetPos(200,676);
			self.m_sprTopic2Right :SetPos(310,676);
			self.m_sprCloseTopic:SetPos(380,676);
			self.m_txtMsg2:SetPos(200,676);
		else
			self.m_sprTopic2Left:SetPos(90,609);
			self.m_sprTopic2Middle :SetPos(200,609);
			self.m_sprTopic2Right :SetPos(310,609);
			self.m_sprCloseTopic:SetPos(380,609);
			self.m_txtMsg2:SetPos(200,609);
		end
		self.m_sprCloseTopic:SetVisible(true);
		self.guiClose = gDef:AddGuiBySpr(self,self.m_sprCloseTopic,idsw.ID_IMG_ML_MAIN_LM13,0,0,0,0);
		-- 隐藏话题1,3 gui
		self.guiTopic2 :SetVisible(false);
		self.m_txtMsg1:SetVisible(false);
		self.m_txtMsg3:SetVisible(false);
		self:closeTopic1();
		self:closeTopic3();
		self.guiTopic1:SetVisible(false);
		self.guiTopic3:SetVisible(false);
	elseif id == idsw.ID_IMG_ML_MAIN2_LM2  then
		-- 点击话题3
		self:SetTopic3color();
		flagTopic3 = true;
		-- 设置坐标
		if gDef.IphoneXView then
			self.m_sprTopic3Left:SetPos(102,676);
			self.m_sprTopic3Middle:SetPos(265,676);
			self.m_sprTopic3Right:SetPos(428,676);
			self.m_sprCloseTopic:SetPos(500,676);
			self.m_txtMsg3:SetPos(265,676);
		else	
			self.m_sprTopic3Left:SetPos(101,609);
			self.m_sprTopic3Middle:SetPos(265,609);
			self.m_sprTopic3Right:SetPos(428,609);
			self.m_sprCloseTopic:SetPos(500,609);
			self.m_txtMsg3:SetPos(265,609);
		end
		self.m_sprCloseTopic:SetVisible(true);
		self.guiClose = gDef:AddGuiBySpr(self,self.m_sprCloseTopic,idsw.ID_IMG_ML_MAIN_LM13,0,0,0,0);
		-- 隐藏话题1,2 gui
		self.m_txtMsg1:SetVisible(false);
		self.m_txtMsg2:SetVisible(false);
		self:closeTopic1();
		self:closeTopic2();
		self.guiTopic1:SetVisible(false);
		self.guiTopic2:SetVisible(false);
		self.guiTopic3:SetVisible(false);
	elseif id == idsw.ID_IMG_ML_MAIN_LM13 then
		-- 删除话题,恢复原位
		self:deleteTopic();
		flagTopic1 = false;
		flagTopic2 = false;
		flagTopic3 = false;
	end
end
-- 话题2,3的默认位置
function AMeDynamicSendTopic:TopicTwo()
	if gDef.IphoneXView then
		x_Ip = 40;
		self.m_sprTopic2Left:SetPos(312,676);
		self.m_sprTopic2Middle:SetPos(425,676);
		self.m_sprTopic2Right:SetPos(538,676);
		
		self.m_sprTopic3Left:SetPos(602,676);
		self.m_sprTopic3Middle:SetPos(765,676);
		self.m_sprTopic3Right:SetPos(928,676 );
		self.m_txtMsg2:SetPos(425,676);
		self.m_txtMsg3:SetPos(765,676);
	else
		self.m_sprTopic2Left:SetPos(312,609);
		self.m_sprTopic2Middle:SetPos(425,609);
		self.m_sprTopic2Right:SetPos(538,609);
		
		self.m_sprTopic3Left:SetPos(601,609);
		self.m_sprTopic3Middle:SetPos(765,609);
		self.m_sprTopic3Right:SetPos(928,609 );

		self.m_txtMsg2:SetPos(425,609);
		self.m_txtMsg3:SetPos(765,609);
	end
end
-- 删除话题
function AMeDynamicSendTopic:deleteTopic()
	self.m_sprCloseTopic:SetVisible(false);
	self.guiClose :SetVisible(false);
	self.m_txtMsg1:SetVisible(true);
	self.m_txtMsg2:SetVisible(true);
	self.m_txtMsg3:SetVisible(true);
	self:openAllTopic();
	self.guiTopic1:SetVisible(true);
	self.guiTopic3:SetVisible(true);
	self.guiTopic2 :SetVisible(true);
	self:TopicTwo();
	self:SetTopic1ColorGray();
	self:SetTopic2ColorGray();
	self:SetTopic3ColorGray();
end
-- 设置话题1的颜色为灰色	
function AMeDynamicSendTopic:SetTopic1ColorGray()
	self.m_sprTopic1Left:SetColor(0xffAFAFAD);
	self.m_sprTopic1Middle:SetColor(0xffAFAFAD);
	self.m_sprTopic1Right:SetColor(0xffAFAFAD);
end	
-- 设置话题2的颜色为灰色	
function AMeDynamicSendTopic:SetTopic2ColorGray()
	self.m_sprTopic2Left:SetColor(0xffAFAFAD);
	self.m_sprTopic2Middle:SetColor(0xffAFAFAD);
	self.m_sprTopic2Right:SetColor(0xffAFAFAD);
end	
-- 设置话题3的颜色为灰色	
function AMeDynamicSendTopic:SetTopic3ColorGray()
	self.m_sprTopic3Left:SetColor(0xffAFAFAD);
	self.m_sprTopic3Middle:SetColor(0xffAFAFAD);
	self.m_sprTopic3Right:SetColor(0xffAFAFAD);
end	
-- 隐藏话题1
function AMeDynamicSendTopic:closeTopic1()
	self.m_sprTopic1Left:SetVisible(false);
	self.m_sprTopic1Middle:SetVisible(false);
	self.m_sprTopic1Right:SetVisible(false);
end
-- 隐藏话题2
function AMeDynamicSendTopic:closeTopic2()
	self.m_sprTopic2Left:SetVisible(false);
	self.m_sprTopic2Middle:SetVisible(false);
	self.m_sprTopic2Right:SetVisible(false);
end
-- 隐藏话题3
function AMeDynamicSendTopic:closeTopic3()
	self.m_sprTopic3Left:SetVisible(false);
	self.m_sprTopic3Middle:SetVisible(false);
	self.m_sprTopic3Right:SetVisible(false);
end
-- 显示所有话题
function AMeDynamicSendTopic:openAllTopic()
	self.m_sprTopic1Left:SetVisible(true);
	self.m_sprTopic1Middle:SetVisible(true);
	self.m_sprTopic1Right:SetVisible(true);
	self.m_sprTopic2Left:SetVisible(true);
	self.m_sprTopic2Middle:SetVisible(true);
	self.m_sprTopic2Right:SetVisible(true);
	self.m_sprTopic3Left:SetVisible(true);
	self.m_sprTopic3Middle:SetVisible(true);
	self.m_sprTopic3Right:SetVisible(true);
end
-- 设置话题1的颜色为紫色	
function AMeDynamicSendTopic:SetTopic1color()
	self.m_sprTopic1Left:SetColor("0xffC4B1F6");
	self.m_sprTopic1Middle:SetColor("0xffC4B1F6");
	self.m_sprTopic1Right:SetColor("0xffC4B1F6");
end	
-- 设置话题2的颜色为紫色	
function AMeDynamicSendTopic:SetTopic2color()
	self.m_sprTopic2Left:SetColor("0xffC4B1F6");
	self.m_sprTopic2Middle:SetColor("0xffC4B1F6");
	self.m_sprTopic2Right:SetColor("0xffC4B1F6");
end	
-- 设置话题3的颜色为紫色	
function AMeDynamicSendTopic:SetTopic3color()
	self.m_sprTopic3Left:SetColor("0xffC4B1F6");
	self.m_sprTopic3Middle:SetColor("0xffC4B1F6");
	self.m_sprTopic3Right:SetColor("0xffC4B1F6");
end	
-- 上传视频或者照片
function AMeDynamicSendTopic:sendAll()
	gSink:RequestPhotoPermissions();
	local localtime = kd.GetLocalTime();
	self.m_szFileName = string.format("%u%04d%02d%02d%02d%02d%02d",		--生成文件名. 自己去拼接.mp4 或者封面的 .jpg
						147852,localtime.Year,localtime.Month, 
						localtime.Day,localtime.Hour,localtime.Minute,localtime.Second);
	table.insert(self.m_photosName,self.m_szFileName);
	gSink:OpenPhotoGetJPEG( 0, "LocalFile/Video/", self.m_szFileName, ScreenW,self,kd.emOpenPhotoType.OPEN_PH_TYPE_ALL);
end	

-- 上传照片
function AMeDynamicSendTopic:sendPhoto()
	gSink:RequestPhotoPermissions();
	local localtime = kd.GetLocalTime();
	self.m_szFileName = string.format("%u%04d%02d%02d%02d%02d%02d",		--生成文件名. 自己去拼接.mp4 或者封面的 .jpg
						147852,localtime.Year,localtime.Month, 
						localtime.Day,localtime.Hour,localtime.Minute,localtime.Second);
	table.insert(self.m_photosName,self.m_szFileName);
	gSink:OpenPhotoGetJPEG(0,"LocalFile/UserPhoto/",self.m_szFileName..".jpg",500,self);
end	

function AMeDynamicSendTopic:updatePhoto()
	for k,v in ipairs(self.m_itemList) do
		local photo = self.m_photos[k]
		if photo then
			v.face:SetFace(photo)
			v.face.clickGui:SetEnable(false)
			v.face:SetVisible(true)
			v.bg:SetVisible(true)
			v.del:SetVisible(true)
		else
			v.face:SetFace()
			v.face.clickGui:SetEnable(false)
			v.face:SetVisible(false)
			v.bg:SetVisible(false)
			v.del:SetVisible(false)
		end
	end
	
	if #self.m_photos < #self.m_itemList then
		local item = self.m_itemList[#self.m_photos + 1]
		item.face:SetVisible(true)
		item.face:SetFace()
		item.face.clickGui:SetEnable(true)
		item.bg:SetVisible(true)
		item.del:SetVisible(false)
		if item.voideicon then
			item.voideicon:SetVisible(false)
		end
	end
	self:Check();
end

-- 相册回调
function AMeDynamicSendTopic:OnSystemPhotoRet(--[[string]] _filePath, --[[int]] fileType)
	echo("==== 1 OnSystemPhotoRet _filePath=".._filePath);
	self.m_szFilePath = _filePath;		
	if fileType == 1 then
		-- 上传的是照片 照片框2可以点击
		flag2 = true;
		table.insert(self.m_photos,_filePath)
		self:updatePhoto()
	end
	
	if fileType == 2 then
		-- 上传的是视频 照片框2不可以点击
		flag2 = false;
		local path = kd.GetSysWritablePath();
		kd.CreateDirectory(path.."/LocalFile/cover");
		table.insert(self.m_videos,_filePath)
		if _filePath then 
			-- 设置上传视频的封面
			kd.GetVideoInfo(_filePath,path.."LocalFile/cover/"..self.m_szFileName..".jpg");
		end
		self.guiDeltePhoto1:SetVisible(true);
	end	
	self:Check();	
end


-- 先提交照片再提交信息
function AMeDynamicSendTopic:SubmitPhotos()
	self.m_photoids = {};
	self.m_tempPhoto = {}
	
	local index = 1
	
	for i = 1,4 do
		if self.m_photos[i] ~= "" then
			self.m_tempPhoto[index] = self.m_photos[i]
			index = index + 1
		end
	end
	
	if #self.m_tempPhoto > 0 then  --有新加图片
		local photo = table.remove(self.m_tempPhoto,1)
		self:upload(photo,#self.m_photos - #self.m_tempPhoto);
	else
		self:SubmitTpoic();
	end
end

-- 提交视频
function AMeDynamicSendTopic:SubmitVideo()
	gSink:messagebox_default("提交审核中...",3000)
	if  self.m_szFilePath  then  --有新视频
		self:upload(self.m_szFileName,1);
	else
		self:SubmitTpoic();
	end
end

-- 上传图片
function AMeDynamicSendTopic:upload(filename,index)
	echo("上传我的图片");
	if (self.m_httpLoadUp == nil) then
		self.m_httpLoadUp = kd.class(kd.HttpRequest);
		if (self.m_httpLoadUp) then
			self.m_httpLoadUp.m_father = self;
			self.m_httpLoadUp.OnHttpPOSTRequest = function(this,
														 _uID, 
														 data,  size,  nErrorCode,  szError)
				local _data = kd.CJson.DeCode(data);										
				if (nErrorCode == 0) and _data.Result then
					if flag2 then
						if _data.Index then
						self.m_photoids[_data.Index] = _data.Id;
						end
						if #self.m_tempPhoto > 0 then
							local photo = table.remove(self.m_tempPhoto,1)
							self:upload(photo,#self.m_photos - #self.m_tempPhoto);
						elseif #self.m_tempPhoto == 0 then
							self:SubmitTpoic();
						end
					else
						self.m_videoids = {};
						self.m_videoids[1] = _data.Id;
						self:SubmitTpoic();
					end
				else
					if flag2 then
						--弹出错误MSGBOX
						gSink:messagebox_default("上传失败")
					else
						--弹出错误MSGBOX
						gSink:messagebox_default("上传视频失败")
					end	
					gSink:HideLoading();	
				end
			end
		end
	end

	if (self.m_httpLoadUp) then
		if flag2 then
			local szUrl = gDef.PostUrl.."michat/up-dynamicimage";
			echo(filename)
			local str = "userid="..gSink.m_User.userId.."&userkey="..gSink.m_User.userKey.."&index="..index.."&filetype=".."jpg".."&file="..filename.. "|1";
			self.m_httpLoadUp:SendHttpPOSTRequest(1,
												szUrl,
												"",
												str 
												);	
		else
			local szUrl = gDef.PostUrl.."michat/up-dynamicvideo";
			local str = string.format("userid=%d&userkey=%s&rotation=%d&covertype=%s&filetype=%s",
									gSink.m_User.userId,
									gSink.m_User.userKey,
									self.m_r,
									"jpg",
									"mp4");
			str = string.format("%s&cover=%s|1&file=%s|1",
								str,
								self.m_szCoverPath ,
								self.m_szFilePath)
			self.m_httpLoadUp:SendHttpPOSTRequest(1,
											  szUrl,
											  "",
											  str 
											  );					
		end
	else
		if flag2 then
			--弹出错误MSGBOX
			gSink:messagebox_default("上传失败")
		else
			--弹出错误MSGBOX
			gSink:messagebox_default("上传视频失败")
		end	
	end	
end


-- 提交话题
function AMeDynamicSendTopic:SubmitTpoic()
	local text = nil;
	if flagTopic1 then
			text = self.m_txtMsg1:GetString();
		end
	if flagTopic2 then
		text = self.m_txtMsg2:GetString();
	end
	if flagTopic3 then
		text = self.m_txtMsg3:GetString();
	end
	local type = "";
	if flag2 then
		type = "image";
		self.m_type = self.m_photoids;
	else 
		type = "video"
		self.m_type = self.m_videoids;
	end	
	
	local Data = {userid= gSink.m_User.userId,userkey = gSink.m_User.userKey,description = self.m_editSign:GetText(),topic = text,filetype = type, filelist = self.m_type};
	echo(gSink.m_User.userId)
	echo(gSink.m_User.userKey)
	gSink:Post("michat/post-dynamic",Data,function(data)
		if data.Result then
			-- 发布动态成功
			echo("显示审核弹窗")
			gSink:messagebox_default("已提交审核");
			DC:CallBack("AMeDynamicSendTopic.Show",false);
			local index = DC:GetData("AMeDynamicTitle.Index");
			DC:CallBack("AMeDynamicTopicDetaiList.OnRequestDynamiclist",index);	--	请求我的动态数据
		else
			if data.ErrCode==1 then		--errcode为1 就回到登录界面
				self:SetVisible(false);
			end
			gSink:messagebox_default(data.ErrMsg);
		end
	end);	
end


-- 获取视频信息回调
function AMeDynamicSendTopic:OnVideoGetInfoRetEvent(--[[int]] err_code,                  --错误码(0为成功) 
                                          --[[string]] video_file,           --请求的视频文件路径或网址 
                                          --[[int]] steams,                      --流数量(视频/声频) 
                                          --[[int]] kbps,                          --混合码率 
                                          --[[int]] w,                                --视频分辨率宽 
                                          --[[int]] h,                                --视频分辨率高 
										  --[[float]] r,								--视频角度
                                          --[[int64]] rate,                       --视频采样率 
                                          --[[int]] max_time,                  --视频的总时间(ms) 
                                          --[[int]] fps,                             --FPS 
                                          --[[string]] cover_path)         --封面地址(由获取发起方传入,回调返回,如果发起方传入为空,将不会生成封面文件)
	-- 视频时间
	self.m_dwVideoTime = max_time;
	self.m_r = r;
	if err_code == 0 then
		-- 设置封面
		self.m_szCoverPath = cover_path;
		self.m_send:SetFace(cover_path);
		self.m_Play1 :SetVisible(true);
	end
end