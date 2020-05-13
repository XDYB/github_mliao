	
local kd = KDGame;
local gDef = gDef;
AEditingInformation = kd.inherit(kd.Layer);

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
};

-- 编辑资料
function AEditingInformation:init(Avatar_,szNickName)
	self.m_isMask = true;
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/DLTianXieZiLiao.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--完成
	self.m_BtnDengLu = self.m_thView:GetButton(idsw.ID_BTN_ML_MAIN_LM);
	
	self.m_BtnDengLu:setEnabledImg(gDef.GetResPath("ResAll/Main2.png"),{
		x = 1387,
		y = 1057,
		width = 526,
		height = 166});
	self.m_BtnDengLu:SetEnable(false);

	--男生女生
	self.m_sprMan = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM6);
	self.m_sprWoMan = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM7);
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM6);
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM7);
	
	--男生女生的坐标
	self.m_womanX,self.m_womanY = self.m_sprWoMan:GetPos();
	self.m_manX,self.m_manY = self.m_sprMan:GetPos();
	
	--默认头像
	self.m_faceForGame = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_TX22_LM,nil,true,6);
	
	--提示
	self.m_promptText = self.m_thView:GetText(idsw.ID_TXT_NO3);
	
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
	self.m_sprBack = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM1);
	self.m_guiBack = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM1,1,1,1,1);	
	
	self.m_sprManOn = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"),319,1738,186,186);
	self.m_thView:addChild(self.m_sprManOn);
	
	self.m_sprWomanOn = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"),510,1736,192,191);
	self.m_thView:addChild(self.m_sprWomanOn);
	
	self.m_szFilePath = nil;
end

function AEditingInformation:SetSex(bMan)
	self.m_nSex = 1;	--0是女  1是男
	if bMan == false then
		self.m_nSex = 0;
		self.m_sprWomanOn:SetPos(self.m_womanX,self.m_womanY );
	else
		self.m_sprManOn:SetPos(self.m_manX,self.m_manY);
	end
	
	self.m_sprManOn:SetVisible(bMan);
	self.m_sprWomanOn:SetVisible(bMan == false);
	
	local str1 = self.m_input:GetText();
	str1 = string.gsub(str1, " ", "");
	if string.len(str1) > 0 then
		self.m_BtnDengLu:SetEnable(true);
	end
end	

function AEditingInformation:Show(flag)
	self:clear();
	self:SetVisible(flag);
end

function AEditingInformation:clear()
	self.m_faceForGame:SetFace();
	self.m_szFilePath = nil;
	self.m_input:SetText("");
	self.m_nSex = nil;
	self.m_sprManOn:SetVisible(false);
	self.m_sprWomanOn:SetVisible(false);
	self.m_sprMan:SetVisible(true);
	self.m_sprWoMan:SetVisible(true);
	self.m_BtnDengLu:SetEnable(false);
end

function AEditingInformation:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
	
end

function AEditingInformation:OnTextChanged()
	local str1 = self.m_input:GetText();
	echo(self.m_nSex)
	if string.len(str1)>0 and self.m_nSex then
		self.m_BtnDengLu:SetEnable(true);
	else
		self.m_BtnDengLu:SetEnable(false);
	end
end 

function AEditingInformation:onTouchBegan(--[[float]] x, --[[float]] y)
    return true;
end

function AEditingInformation:HideMask()
--	self.m_mask:SetVisible(false)
end

function AEditingInformation:onGuiToucBackCall(--[[int]] id)
	if id == idsw.ID_IMG_ML_MAIN_LM6 then		--选择男生
		self:SetSex(true);
	elseif id ==idsw.ID_IMG_ML_MAIN_LM7 then		--选择女生
		self:SetSex(false);
	elseif id == idsw.ID_IMG_ML_MAIN_LM1 then
		self:SetVisible(false);
	elseif id == idsw.ID_CUS_ML_TX22_LM then
		--选择头像
		--请求相册权限
		gSink:RequestPhotoPermissions();
		-- 点击相册
		local userId = 1;
		local dwTime = os.time();
		local nCount = math.random(1,99999999);
		self.m_szFileName = string.format("%d_%d_%08d.jpg",userId,dwTime,nCount);
		--打开系统相册或者照相获取图片并保存到指定地点
		gSink:OpenPhotoGetJPEG(0, "prod/image/",self.m_szFileName, 480, self);
	elseif id == idsw.ID_BTN_ML_MAIN_LM then
		if self.m_szFilePath then
			if string.len(self.m_szFilePath)>0 then
				self:UploadMyPhoto();
			end
		else
			self:set_info();
		end	
	end
end

function AEditingInformation:set_info()
	local text = self.m_input:GetText();
	local Data = {userid = gSink.m_User.userId,userkey = gSink.m_User.userKey,nickname=text,sex = self.m_nSex};
		gSink:Post("michat/set-info",Data,function(data)
			if data.Result then
				-- 存入昵称
				gSink:SetUserNickname(text);
				-- 存入性别
				gSink:SetUserSex(self.m_nSex);
				--登陆成功进入主页
				DC:CallBack("AHomeView.Show",true);					--	默认显示首页
				DC:CallBack("AHomePageButtom.SwitchIcon",1);		--	默认显示首页
				DC:CallBack("AHomePageView.Show",true);
				DC:CallBack("AHomePageButtom.Show",true);			--	菜单栏
			else
				if data.ErrCode==1 then		--errcode为1 就回到登录界面
					self:SetVisible(false);
				end
				gSink:messagebox_default(data.ErrMsg);
			end
		end);
end

-- 相册回调
function AEditingInformation:OnSystemPhotoRet(--[[string]] _filePath, --[[int]] fileType)
	echo("==== 1 OnSystemPhotoRet _filePath=".._filePath);
	self.m_szFilePath = _filePath;
	self.m_faceForGame:SetFace(_filePath);
	--self:AddCover(_filePath,gDef.PostUrl.."oss-callback");
end


-- 上传图片
function AEditingInformation:UploadMyPhoto()
	echo("上传我的头像");
	if (self.m_httpLoadUp == nil) then
		self.m_httpLoadUp = kd.class(kd.HttpRequest);
		if (self.m_httpLoadUp) then
			self.m_httpLoadUp.m_father = self;
			self.m_httpLoadUp.OnHttpPOSTRequest = function(this,
														 _uID, 
														 data,  size,  nErrorCode,  szError)
				gSink:HideLoading();
				local _data = kd.CJson.DeCode(data);										
				if (nErrorCode == 0) and _data.Result then										
					self:set_info();
				else
					--弹出错误MSGBOX
					gSink:messagebox_default("上传头像失败")
				end
				
			end
		end
	end
		
	if (self.m_httpLoadUp) then
		--显示LOAD界面 kd.Aes128EncryptStr(str,"akajglk(U(hngl))")
		local szUrl = gDef.PostUrl.."michat/up-face";
		local type = "jpg";
		local str = "userid="..gSink.m_User.userId.."&userkey="..gSink.m_User.userKey.."&filetype="..type.."&file="..self.m_szFilePath.. "|1";
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
