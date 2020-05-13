--[[
	意见反馈 
--]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AFeedBack = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN2_LM            = 1001,
	ID_IMG_ML_MAIN3_LM            = 1002,
	ID_IMG_ML_MAIN3_LM1           = 1003,
	ID_IMG_ML_MAIN_LM             = 1004,
	ID_IMG_ML_MAIN_LM1            = 1005,
	ID_IMG_ML_MAIN_LM2            = 1006,
	--/* Button ID */
	ID_BTN_ML_MAIN2_LM            = 3001,
	ID_BTN_ML_MAIN_LM             = 3002,
	--/* Text ID */
	ID_TXT_NO0                    = 4001,
	ID_TXT_NO2                    = 4002,
	ID_TXT_NO3                    = 4003,
	ID_TXT_NO4                    = 4004,
	ID_TXT_NO5                    = 4005,
	ID_TXT_NO6                    = 4006,
	--/* Custom ID */
	ID_CUS_ML_MAIN2_LM            = 6001,
};

function AFeedBack:init()

	--	加载UI
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/YiJianFanKui.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	-- 头部标题
	self.Title = kd.class(Title,false,true)
	self.Title:init(self)
	self.Title:SetTitle("意见反馈")
	self:addChild(self.Title,1)
	self.Title.onTouchBegan = function (this,x,y)
		local h = this:GetH();
		if y > h then
			return false
		else
			return true
		end
	end	
	--	编辑框背景版
	local x,y,w,h = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN3_LM);
	self.m_input1 = gDef:AddEditBox(self,x+10,y-80,w-35,h+30,44,0xff000000,true);
	self.m_input1:SetInputMode(kd.InputMode.SINGLE_LINE);
    self.m_input1:SetInputFlag(kd.InputFlag.SENSITIVE);
	self.m_input1:SetMaxLength(100);
    self.m_input1:SetReturnType(kd.KeyboardReturnType.GO);
    self.m_input1:SetTitle("请描述你的问题...",0xffbbbbbb)
	self.m_txt = self.m_thView:GetText(idsw.ID_TXT_NO6);
	self.m_input1.OnTextChanged = function(this,text)  
       self:OnTextChanged();
		local len = gDef:GetTextCount(text)//2;
		self.m_txt:SetString(len .. "/100")
    end	
	
	-- 电话号码填写栏
	local a,b,w,h = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN3_LM1);
	self.m_input2 = gDef:AddEditBox(self,a+80,b,w-35,h+30,44,0xff000000,true);
	self.m_input2:SetInputMode(kd.InputMode.NUMERIC);
	self.m_input1:SetInputFlag(kd.InputFlag.SENSITIVE);
	self.m_input2:SetMaxLength(11);
    self.m_input2:SetReturnType(kd.KeyboardReturnType.GO);

	--	图片GUI
	self.m_facePhoto = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_MAIN2_LM,nil,true,nil);

	-- btn
	self.m_NoBtn = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM2,10,10,10,10);
	
	--	禁用按钮
	self.m_BanBtn = self.m_thView:GetButton(idsw.ID_BTN_ML_MAIN2_LM);
	self.m_BanBtn:setEnabledImg(gDef.GetResPath("ResAll/Main2.png"),{
		x = 1387,
		y = 1057,
		width = 526,
		height = 166});
	self.m_BanBtn:SetEnable(false);
	
	--	提交按钮
	self.m_SubmitBtn = self.m_thView:GetButton(idsw.ID_BTN_ML_MAIN_LM);
	
	--=======================================================自定义变量区=================================================	
	
	self.m_szFilePath = nil;		--	用于接收选择的图片,最多3张
	self.m_IsCreat = true;
	
	--	注册数据中心
	DC:RegisterCallBack("AFeedBack.Show",self,function(bool)
		self:SetVisible(bool)
	end);
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function AFeedBack:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
	if visible then
		self:OnTextChanged();
	else
		if self.m_IsCreat then
			self:Clear();
		end
	end
end

--	UI
function AFeedBack:onGuiToucBackCall(id)
	if id == idsw.ID_BTN_ML_MAIN2_LM then				--	禁用按钮
		echo("禁用按钮");
	elseif id == idsw.ID_BTN_ML_MAIN_LM then			--	提交按钮
		echo("提交按钮");
		if self.m_szFilePath ~= nil then
			self:UpLoadPhoto(self.m_szFilePath,1);
		end
	elseif id == idsw.ID_IMG_ML_MAIN_LM2 then			--	图片取消按钮
		echo("图片取消按钮");
		self:DeleteIMG();
		self:OnTextChanged()
	elseif id == idsw.ID_CUS_ML_MAIN2_LM then			--	加载图片
		echo("加载图片");
		self:LoadingIMG();	
	end
end

function AFeedBack:Clear()
	self.m_input1:SetText("");
	self.m_input2:SetText("");
	self:DeleteIMG();								--	 全删除
end

-- 输入框检测
function AFeedBack:OnTextChanged()
	local txt1 = self.m_input1:GetText();
	if string.len(txt1)>0 and self.m_szFilePath ~= nil then
		self.m_BanBtn:SetVisible(false);
		self.m_SubmitBtn:SetVisible(true);
	else
		self.m_BanBtn:SetVisible(true);
		self.m_SubmitBtn:SetVisible(false);
	end
end

-- 图片加载
function AFeedBack:LoadingIMG()
	echo("图片加载");
	gSink:RequestPhotoPermissions();				--	请求相册权限
	local userId = 1;								-- 点击相册
	local dwTime = os.time();
	local nCount = math.random(1,99999999);
	self.m_szFileName = string.format("%d_%d_%08d.jpg",userId,dwTime,nCount);
	--打开系统相册或者照相获取图片并保存到指定地点
	gSink:OpenPhotoGetJPEG(0, "FeedBack/image/",self.m_szFileName, 480, self);
end

-- 相册回调
function AFeedBack:OnSystemPhotoRet( _filePath,fileType)
	echo("==== 1 OnSystemPhotoRet _filePath=".._filePath);
	self.m_szFilePath  =_filePath;
	self.m_facePhoto:SetFace(_filePath);
	self.m_NoBtn:SetVisible(true);			--	选择好图片后显示出删除图片的按钮

	self:OnTextChanged()
end

function AFeedBack:OnAliOSSBackUploadFileResults(err_code,err_msg,object,web_ret_json)
	local nID = -1;
	if err_code ==200 then
		if web_ret_json and web_ret_json.image then
			nID = web_ret_json.image.id;
		end
		local Data = {imageId=nID};
		gSink:SendData(self,kd.urlID.USER_EDIT_AVATAR,Data);
	else
		gSink:messagebox_default(err_msg);
	end
end

-- 上传图片的功能
function AFeedBack:UpLoadPhoto(filename,index)
	gSink:ShowLoading("提交审核中...")
	gSink:Post("michat/up-photo",{index = index,file = filename},function(data)
		if data.Result then
			gSink:ShowLoading("提交审核中...")
		end
	end)
	
	if (self.m_httpLoadUp == nil) then
		self.m_httpLoadUp = kd.class(kd.HttpRequest);
		if (self.m_httpLoadUp) then
			self.m_httpLoadUp.m_father = self;
			self.m_httpLoadUp.OnHttpPOSTRequest = function(self,_uID,data,size,nErrorCode,szError)				
				gSink:HideLoading();										
				echo("KD_LOG:设置图片错误码"..nErrorCode);
				echo("KD_LOG:设置图片错误信息"..szError);
				if (nErrorCode == 0) then
					local text1 = self.m_father.m_input1:GetText();
					local text2 = self.m_father.m_input2:GetText();
					local Data = {description = text1,address = text2,file = self.m_father.m_szFilePath};
					gSink:Post("michat/up-suggest",Data,function(data1)
						if data1.Result then
							--	上传成功，则跳转到上一个页面
							gSink:messagebox_default("已提交");		
							DC:CallBack("AFeedBack.Show",false);
						else
							gSink:messagebox_default(data1.ErrMsg);
						end
					end);
				else
					--弹出错误MSGBOX
					gSink:messagebox_default("上传失败")
					gSink:HideLoading();	
				end
			end
		end
	end
		
	if (self.m_httpLoadUp) then
		local szUrl = gDef.PostUrl.."michat/up-photo";			--	图片上传
		local str = "userid="..gSink.m_User.userId.."&userkey="..gSink.m_User.userKey;
		str = "scrt="..kd.Aes128EncryptStr(str,gDef.Aes128Decode).."&file="..self.m_szFilePath.. "|1";

		self.m_httpLoadUp:SendHttpPOSTRequest(1,szUrl,"",str);
		gSink:ShowLoading();
	else
		--弹出错误MSGBOX
		gSink:messagebox_default("上传图像渠道连接失败,请稍后再试!","出现异常");
	end
end

-- 图片删除
function AFeedBack:DeleteIMG(index)
	echo("图片删除");
	self.m_szFilePath = nil;
	self.m_facePhoto:SetFace(nil);								--	图片框重置为残破图状态
	self.m_NoBtn:SetVisible(false);							--	选择好图片后显示出删除图片的按钮
end

