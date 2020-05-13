	
local kd = KDGame;
local gDef = gDef;
EditMyName = kd.inherit(kd.Layer);
local impl = EditMyName;
local gSink = A_ViewManager;

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
--/* Image ID */
	ID_IMG_ML_MAIN_LM            = 1001,
	ID_IMG_ML_MAIN_LM1           = 1002,
	ID_IMG_ML_MAIN_LM4           = 1003,
	ID_IMG_ML_MAIN_LM5           = 1004,
	ID_IMG_ML_MAIN_LM6           = 1005,
	ID_IMG_ML_MAIN_LM7           = 1006,
	ID_IMG_ML_MAIN_LM8           = 1007,
	--/* Button ID */
	ID_BTN_ML_MAIN_LM            = 3001,
	--/* Text ID */
	ID_TXT_NO1                   = 4001,
	ID_TXT_NO3                   = 4002,
	ID_TXT_NO4                   = 4003,
	--/* Custom ID */
	ID_CUS_ML_TX22_LM            = 6001,
}

-- 编辑资料
function impl:init()
	self.m_isMask = true;
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/DLTianXieZiLiao.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--男生女生
	self.m_thView:SetVisible(idsw.ID_IMG_ML_MAIN_LM6, false);
	self.m_thView:SetVisible(idsw.ID_IMG_ML_MAIN_LM7, false);

	--默认头像
	self.m_cusFace = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_TX22_LM,nil,true,6);
	
	--提示
	self.m_thView:SetVisible(idsw.ID_TXT_NO3, false);
	
	--输入昵称
	self.m_sprEditName = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM5);
	--输入框
	local x,y,w,h = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN_LM5);
	self.m_input = gDef:AddEditBox(self,x+20,y-40,w,h+60,44,0xff000000,true);
	self.m_input:SetInputMode(kd.InputMode.SINGLE_LINE);
    self.m_input:SetInputFlag(kd.InputFlag.SENSITIVE);
	self.m_input:SetMaxLength(10);
    self.m_input:SetReturnType(kd.KeyboardReturnType.GO);
    self.m_input:SetTitle("请输入昵称",0xffbbbbbb);
	self.m_input.OnTextChanged = function(this,text)  
       self:OnTextChanged();
    end
	
	--返回上一页面
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM1,40,80,40,40);	
	
	--完成
	self.m_btnSubmit = self.m_thView:GetButton(idsw.ID_BTN_ML_MAIN_LM);
	self.m_btnSubmit:setEnabledImg(gDef.GetResPath("ResAll/Main2.png"),{
		x = 1387,
		y = 1057,
		width = 526,
		height = 166});
	self.m_btnSubmit:SetEnable(false);
	
	DC:RegisterCallBack("EditMyName.SetData",self,function (data)
		self.m_data = {Nickname = data.Nickname, AvatarFile = gDef.domain .. data.AvatarFile};
	end);
	
	DC:RegisterCallBack("EditMyName.Show",self,function (bo)
		self:SetVisible(bo);
		if bo then
			gSink:ShowButtom(false);
			self:SetViewData();
		end
	end);
end

function impl:OnTextChanged()
	local name = self.m_input:GetText();
	name = string.gsub(name, " ", "");
	if string.len(name)>0 then
		if name ~= self.m_strName or string.len(self.m_szFilePath)>0 then
			self.m_btnSubmit:SetEnable(true);
		else
			self.m_btnSubmit:SetEnable(false);
		end
	else
		self.m_btnSubmit:SetEnable(false);
	end
end

function impl:onGuiToucBackCall(id)
	if id == idsw.ID_IMG_ML_MAIN_LM1 then
		self:SetVisible(false);
		gSink:ShowButtom(true);
	elseif id == idsw.ID_CUS_ML_TX22_LM then
		-- 点击相册
		local userId = 1;
		local dwTime = os.time();
		local nCount = math.random(1,99999999);
		self.m_szFileName = string.format("%d_%d_%08d.jpg",userId,dwTime,nCount);
		--打开系统相册或者照相获取图片并保存到指定地点
		gSink:OpenPhotoGetJPEG(0, "prod/image/",self.m_szFileName, 480, self);
	elseif id == idsw.ID_BTN_ML_MAIN_LM then
		if string.len(self.m_szFilePath)>0 then
			self:UploadMyPhoto();
		else
			self:set_info();
		end
	end
end

-- 相册回调
function impl:OnSystemPhotoRet(--[[string]] _filePath, --[[int]] fileType)
	echo("==== 1 OnSystemPhotoRet _filePath=".._filePath);
	self.m_szFilePath = _filePath;
	self.m_cusFace:SetFace(_filePath);
	self:OnTextChanged();
end

function impl:SetViewData()
	self.m_strName = self.m_data.Nickname;
	-- 设置昵称
	self.m_input:SetText(self.m_strName);
	-- 设置头像
	self.m_cusFace:SetFace(self.m_data.AvatarFile);
end

function impl:initView()
--	self.m_cusFace:SetFace();
	self.m_input:SetText("");
	self.m_szFilePath = "";
	self.m_btnSubmit:SetEnable(false);
end

function impl:OnActionEnd()
	local bo = self:IsVisible();
	if not bo then
		self:initView();
	end
end

function impl:set_info()
	local text = self.m_input:GetText();
	local Data = {nickname=text};
	gSink:Post("michat/edit-info",Data,function(data)
		if data.Result then
			self:SetVisible(false);
			gSink:ShowButtom(true);
			gSink:messagebox_default("资料已保存");
			local name = self.m_input:GetText();
			self.m_data.Nickname = name;
			gSink:SetUserNickname(name);
			DC:CallBack("MyView.updateme")
		else
			if data.ErrCode==1 then								--errcode为1 就回到登录界面
				self:SetVisible(false);
			end
			gSink:messagebox_default(data.ErrMsg);
		end
	end);
end

-- 上传图片
function impl:UploadMyPhoto()
	echo("上传我的头像");
	if (self.m_httpLoadUp == nil) then
		self.m_httpLoadUp = kd.class(kd.HttpRequest);
		if (self.m_httpLoadUp) then
			self.m_httpLoadUp.m_father = self;
			self.m_httpLoadUp.OnHttpPOSTRequest = function(this,
														 _uID, 
														 data,  size,  nErrorCode,  szError)
				gSink:HideLoading();	
				local tabData = kd.CJson.DeCode(data);
				if tabData.Result then
					self.m_data.AvatarFile = self.m_szFilePath;
					local text = self.m_input:GetText();
					if text ~= self.m_strName then
						self:set_info();
					else
						gSink:messagebox_default("资料已保存");
						self:SetVisible(false);
						gSink:ShowButtom(true);
						DC:CallBack("MyView.updateme")
					end
				else
					--弹出错误MSGBOX
					gSink:messagebox_default(tabData.ErrMsg);
				end
				
			end
		end
	end
		
	if (self.m_httpLoadUp) then
		local szUrl = gDef.PostUrl.."michat/up-face";
		local str = "userid="..gSink.m_User.userId.."&userkey="..gSink.m_User.userKey.."&filetype=jpg&file="..self.m_szFilePath.. "|1";
--		str = kd.Aes128EncryptStr(str,gDef.Aes128Decode);
--		str = string.format("scrt=%s&file=%s|1",str,self.m_szFilePath);
		gSink:ShowLoading();
		self.m_httpLoadUp:SendHttpPOSTRequest(1,
												szUrl,
											    "",
												str 
												);
	else
		--弹出错误MSGBOX
		gSink:messagebox_default("上传头像失败");
	end	
	
end
