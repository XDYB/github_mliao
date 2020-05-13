--[[
	登录注册界面
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

ALogin = kd.inherit(kd.Layer);
local str1 = nil;
local TIMEID_WAITFOR = 60;	--设置重新验证时间 5秒方便测试
local idsw =
{
	--/* Image ID */
	ID_IMG_ML_LOGO_LM            = 1001,
	ID_IMG_ML_MAIN2_LM           = 1002,
	ID_IMG_ML_MAIN_LM            = 1003,
	ID_IMG_ML_MAIN_LM1           = 1004,
	ID_IMG_ML_MAIN_LM2           = 1005,
	ID_IMG_ML_MAIN_LM3           = 1006,
	ID_IMG_ML_MAIN_LM4           = 1007,
	--/* Button ID */
	ID_BTN_ML_MAIN_LM1           = 3001,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
	ID_TXT_NO1                   = 4002,
	ID_TXT_NO2                   = 4003,
	ID_TXT_NO3                   = 4004,
	ID_TXT_NO4                   = 4005,
}

function ALogin:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/DLShuRuYanZhengMa.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	-- 输入框
	local x,y,w,h = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN_LM2);
	-- 输入栏
	self.m_input1 = gDef:AddEditBox(self,x-60,y,w-260,h+30,44,0xff000000,true);
	self.m_input1:SetInputMode(kd.InputMode.NUMERIC);
    self.m_input1:SetInputFlag(kd.InputFlag.SENSITIVE);
	self.m_input1:SetMaxLength(11);
    self.m_input1:SetReturnType(kd.KeyboardReturnType.GO);
    self.m_input1:SetTitle("请输入手机号",0xffbbbbbb)
	self.m_input1.OnTextChanged = function(this,text)  
       self:OnTextChanged();
	end
	
	-- 验证码输入框
	self.m_sprEditCode = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM);
	self.m_sprEditCode:SetTextureRect(0,832,720,153);
	local x2,y2,w2,h2 = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN2_LM)
    self.m_input2 = gDef:AddEditBox(self,x2-60,y2,w2-260,h2+30,44,0xff000000,true);
	self.m_input2:SetVisible(false);
	self.m_input2:SetInputMode(kd.InputMode.NUMERIC);
	self.m_input2:SetMaxLength(6);
    self.m_input2:SetReturnType(kd.KeyboardReturnType.GO);
    self.m_input2:SetTitle("",0xffbbbbbb)
	self.m_sprEditCode:SetVisible(false);
	self.m_input2.OnTextChanged = function(this,text)  
       self:OnTextChanged();
    end	
	
	--提示错误文本
	self.m_TxtTiShi = self.m_thView:GetText(idsw.ID_TXT_NO3);
	
	if gDef.IphoneXView then
		self.m_TxtTiShi:SetPos(730,1050);
	else
		self.m_TxtTiShi:SetPos(730,1000);
	end

	self.m_TxtTiShi:SetString("");
	self.m_TxtTiShi:SetVisible(true);
	
	--获取验证码
	self.m_sprGetY = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM4);
	self.guiGetY = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM4);
	self.m_sprGetY:SetTextureRect(722,767,360,153);
	self.guiGetY.gui:SetEnable(false);

	--获取验证码文字
	self.m_TxtGetY = self.m_thView:GetText(idsw.ID_TXT_NO4);
	self.m_TxtGetY:SetColor(0xff787878);	--刚开始是灰色
	
	--用户协议
	self.guiSubmit = gDef:AddGuiByID(self,idsw.ID_TXT_NO2,50,100,50,100)
	
	--立即进入
	self.m_btnIn = self.m_thView:GetButton(idsw.ID_BTN_ML_MAIN_LM1);
	
	--设置按钮禁用时为灰色
	self.m_btnIn:setEnabledImg(gDef.GetResPath("ResAll/Main.png"),{
		x = 769,
		y = 1003,
		width = 206,
		height = 206});
	self.m_btnIn:SetEnable(false);
	
	--返回上一页面
	self.m_sprBack = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM1);
	self.m_guiBack = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM1,1,1,1,1);	
	
	self.m_bSend = false;	--是否发送验证码
	self.m_bFenSend = false;	--是否在倒计时

	--重新获取验证码
	self.m_TxtHuoQu = self.m_thView:GetText(idsw.ID_TXT_NO0);
	self.m_TxtHuoQu:SetVisible(true);
	self.m_TxtHuoQu:SetString(" ");
	self.m_TxtHuoQu:SetColor(0xffFF6699);	--粉红色
	self.m_TxtHuoQu:SetHAlignment(kd.TextHAlignment.RIGHT);
	local x,y = self.m_TxtHuoQu:GetPos();
	self.m_TxtHuoQu:SetPos(x-50,y);

	--删除
	self.m_sprX = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM3);
	self.m_guiX = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM3,20,20,20,20);	
	self.m_sprX:SetVisible(false);
	self.m_guiX:SetVisible(false);
	
	--重新获取
	self.m_guiHuoQu = gDef:AddGuiByID(self,idsw.ID_TXT_NO0,50,100,50,100);
	self.m_guiHuoQu:SetVisible(false);
	
	--初始化编辑资料界面
	self.m_AEditingInformation= kd.class(AEditingInformation, false, true);
	self.m_AEditingInformation:init(self);
	self:addChild(self.m_AEditingInformation);
	self.m_AEditingInformation:SetVisible(false);
	self.m_AEditingInformation:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);

	DC:RegisterCallBack("ALogin.Show",self,function(bool)
		self:SetVisible(bool)
	end)	
	
	DC:RegisterCallBack("ALogin.clear",self,function()
		self:clear();
	end)
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function ALogin:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

-- 清除数据
function ALogin:clear()
	self.m_input1:SetText("");
	self.m_sprEditCode:SetVisible(false);
	self.m_input2:SetText("");
	self.m_sprGetY:SetVisible(true);
	self.guiGetY = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM4);
	self.m_sprGetY:SetTextureRect(722,767,360,153);
	self.guiGetY.gui:SetEnable(false);
	self.m_guiHuoQu:SetVisible(false);
	self.m_TxtGetY:SetVisible(true);
	self.m_TxtGetY:SetColor(0xff787878);	--刚开始是灰色
	self.m_bSend = false;	--是否发送验证码
	self.m_bFenSend = false;	--是否在倒计时
	self.m_AEditingInformation:Show(false);
	self.m_btnIn:SetEnable(false);
	self.m_input2:SetVisible(false);
	self.m_sprX:SetVisible(false);
	self.m_guiX:SetVisible(false);
end	

function ALogin:onGuiToucBackCall(--[[int]] id)
	if id==idsw.ID_BTN_ML_MAIN_LM1 then		--注册
		local str1 = self.m_input1:GetText();
		local str2 = self.m_input2:GetText();
		local Data = {phone = str1,captcha = str2};
		gSink:Post("michat/phone-login",Data,function(data)
			if data.Result then
				local tData = {num=0};
				DC:FillData("AHomeView.HateList",tData);			--	黑名单
				gSink:SetMyTags();
				gSink:SetUser(data);
				
				self:KillTimer(100);
				self.m_TxtHuoQu:SetString("重新获取");
				self.m_TxtHuoQu:SetColor(0xffFD4E59);	--重新获取是红色
				self.m_bFenSend = false;	--是否还在倒计时
				self.m_guiHuoQu:SetVisible(true);
				
				DC:CallBack("AHomePageButtom.isLogingIn",true);
				if  string.len(data.Nickname)>0 then	--	有昵称直接进入主页
					self:RequestHatelist(0);			--	获取黑名单列表
				else
					self.m_AEditingInformation:Show(true);
				end
					self.m_TxtTiShi:SetString("");
			else
				self.m_TxtTiShi:SetString(data.ErrMsg);
				--提示框变红
				self.m_sprEditCode :SetTextureRect(0,677,720,153);
				self.m_guiHuoQu:SetVisible(true);
			end
		end);
	elseif id==idsw.ID_IMG_ML_MAIN_LM3 then		--删除
		self.m_input1:SetText("");
		self:OnTextChanged();
	elseif id==idsw.ID_TXT_NO0 then		--重新获取验证码
		if self.m_bFenSend then
			return;
		end
		--提示框变粉红
		self.m_sprEditCode :SetTextureRect(0,832,720,153);
		self.m_input2:SetText(""); 
		--------------------
		local str1 = self.m_input1:GetText();
		local Data = {phone = str1};
		--------------------------------
		gSink:Post("michat/get-captcha",Data,function(data)
			if data.Result then
				self:SetTimer(100,1000,0xffffffff);
				self.nTime = TIMEID_WAITFOR;
				self.m_TxtHuoQu:SetString(self.nTime.."s");
				self.m_TxtHuoQu:SetColor(0xffB4B4B4);	--刚开始是灰色
				self.m_bSend = true;
				self.m_bFenSend = true;
				
				self.m_sprGetY:SetVisible(false);
				self.guiGetY:SetVisible(false);
				self.m_TxtGetY:SetVisible(false);
				
				self.m_input2:SetVisible(true);
				self.m_TxtTiShi:SetString("");
			else
				self.m_TxtHuoQu:SetString("重新获取");
				self.m_TxtHuoQu:SetColor(0xffFD4E59);	--重新获取是红色
				self.m_TxtTiShi:SetString(data.ErrMsg);
			end
		end);
	elseif id==idsw.ID_IMG_ML_MAIN_LM4 then		--获取验证码
		local str1 = self.m_input1:GetText();
		local Data = {phone = str1};		
		self.m_input2:SetVisible(true);
		-------------------------------------
		gSink:Post("michat/get-captcha",Data,function(data)
			echo(data.Result);
			if data.Result then
				self.m_sprEditCode:SetVisible(true);
				self.m_guiHuoQu:SetVisible(true);
				self:SetTimer(100,1000,0xffffffff);
				self.nTime = TIMEID_WAITFOR;
				self.m_TxtHuoQu:SetString(self.nTime.."s");
				self.m_TxtHuoQu:SetColor(0xffB4B4B4);	--刚开始是灰色
				self.m_bSend = true;
				self.m_bFenSend = true;
				
				self.m_sprGetY:SetVisible(false);
				self.guiGetY:SetVisible(false);
				self.m_TxtGetY:SetVisible(false);
				
				self.m_input2:SetVisible(true);
				self.m_TxtTiShi:SetString("");
			else
				self.m_TxtHuoQu:SetString(" ");
				self.m_TxtHuoQu:SetColor(0xffB4B4B4);	--刚开始是灰色
				echo(data.ErrMsg);
				self.m_TxtTiShi:SetString(data.ErrMsg);
			end
		end);
	elseif id==idsw.ID_TXT_NO2 then		--用户协议
		gSink:ShowHtml("用户协议",gDef.agreement)
		DC:FillData("ALogin.IsInHtml",true);
	elseif id == idsw.ID_IMG_ML_MAIN_LM1 then
		--回到上一界面
		self:SetVisible(false);
	end
end

function ALogin:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

--输入框的编辑回调函数
function ALogin:OnTextChanged()
	local str1 = self.m_input1:GetText();
	local str2 = self.m_input2:GetText();
	if string.len(str1)>0 then
		self.m_sprX:SetVisible(true);
		self.m_guiX:SetVisible(true);
		if  string.len(str1) == 11 then
			if self.m_bSend == false then --没有发送才显示获取
				--验证码按钮亮起 可点击
				self.m_sprGetY:SetTextureRect(1084,767,360,153);
				self.guiGetY.gui:SetEnable(true);
				self.m_TxtGetY:SetVisible(true);
				self.m_TxtGetY:SetColor(0xffFF6699);
			end	
			if self.m_bSend and string.len(str2)==6 then 		--发送了验证码
				self.m_btnIn:SetEnable(true);
			else
				self.m_btnIn:SetEnable(false);
			end
		end	
	else
		self.m_sprX:SetVisible(false);
		self.m_guiX:SetVisible(false);
		self.m_sprGetY:SetTextureRect(722,767,360,153);
		-- 不能获取验证码
		self.guiGetY.gui:SetEnable(false);
		self.m_TxtGetY:SetColor(0xff787878);	--刚开始是灰色
		self.m_btnIn:SetEnable(false);
	end	
end 
	
function ALogin:OnTimerBackCall(id)
	if id == 100 then
		self.nTime = self.nTime-1;
		if self.nTime >0 then
			echo(self.nTime);
			self.m_TxtHuoQu:SetString(self.nTime.."s");
		else
			self:KillTimer(100);
			self.m_TxtHuoQu:SetString("重新获取");
			self.m_TxtHuoQu:SetColor(0xffFD4E59);	--重新获取是红色
			self.m_bFenSend = false;	--是否还在倒计时
			self.m_guiHuoQu:SetVisible(true);
		end
	end
end 

--用户按下android的后退键或者PC的ESC键后弹起回调
function ALogin:onBackKeyReleased()

end	

function ALogin:LogonServer()
	
end

function ALogin:LoginSuccess()
	
end

function ALogin:getPhoneNum()
	return self.m_input1:GetText();
end

function ALogin:RequestHatelist(page)
	gSink:Post("michat/get-hatelist",{page = page},function(data)
		local tData = {};
		if data.Result then
				local num = 0;
				for i =1,#data.Data do
					tData[tostring(data.Data[i].UserId)]=data.Data[i]
					num = num + 1;
				end
				tData["num"] = num;
			if data.IsEnd == false then
				page = page+1;
				self:RequestHatelist(page);
			else
				DC:FillData("AHomeView.HateList",tData);			--	黑名单
				DC:CallBack("AHomeView.Show",true);					--	默认显示首页
				DC:CallBack("AHomePageButtom.SwitchIcon",1);
				DC:CallBack("AHomePageView.Show",true);
				DC:CallBack("AHomePageButtom.Show",true);			--	菜单栏-
			end
		end
	end)
end