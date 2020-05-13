--[[

个性签名、个人标签 共用子项

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

PersonalInfoitem = kd.inherit(kd.Layer);
local impl = PersonalInfoitem;
local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM            = 1001,
	ID_IMG_ML_MAIN2_LM           = 1002,
	--/* Text ID */
	ID_TXT_NO2                   = 4001,
	ID_TXT_NO3                   = 4002,
	ID_TXT_NO4                   = 4003,
}

function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/GFRenZhengDiBu.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--标题
	self.m_txtTitle = self.m_thView:GetText(idsw.ID_TXT_NO2);
	
	--内容
	self.m_txtContext = self.m_thView:GetText(idsw.ID_TXT_NO3);
	self.m_txtContext:SetString("");
	
	--个数
	self.m_txt = self.m_thView:GetText(idsw.ID_TXT_NO4);
	self.m_txt:SetString("0/15");
	
	--白色背景
	self.m_sprbg = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM);
	
	--输入框
	local x,y,w,h = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN2_LM);
	-- 输入栏
	self.m_EditBox = gDef:AddEditBox(self,x+20 - 150,y + 35,w-300,h,40,0xff999999,true);
	self.m_EditBox:SetMaxLength(15);
	self.m_EditBox:SetInputMode(kd.InputMode.SINGLE_LINE);		--SINGLE_LINE 用这个模式IOS上回车就可以来EditingReturn回调
    self.m_EditBox:SetReturnType(kd.KeyboardReturnType.DONE);
	--回车键被按下或键盘的外部区域被触摸时
	self.m_EditBox.OnTextChanged = function(this,text)  
		--local len = gDef:GetTextCount(text)//2;
		local len = #gDef:utf8tochars(text);	
		self.m_txt:SetString(len .. "/15")
    end
	self.m_EditBox.EditingReturn = function(this,text)
		DC:CallBack("OfficialCertification.CheckSubmit")
	end	
end

function impl:SetData(str)
	local len = gDef:GetTextCount(str)//2;
	self.m_txt:SetString(len .. "/15")
	
	self.m_EditBox:SetText(str)
end

function impl:GetInfo()
	return self.m_EditBox:GetText()
end

function impl:SetType(p)
	local tp = p or 0;
	if tp == 1 then		--个人签名
		self.m_txtTitle:SetString("个人签名");
	elseif tp == 2 then -- 个人介绍
		self.m_txtTitle:SetString("个人介绍");
	end
end

function impl:GetWH()
	local x,y = self.m_sprbg:GetPos();
	return ScreenW,y*2;
end

function impl:onGuiToucBackCall(id)
	
end

