--[[
	关于我们
--]]
c_Require("Script/MiLiao/MyInfo/AFeedBack.lua")

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AInstall = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
local local_tim = tim;
local local_tsdk = tim.sdk;
local local_tconv = tim.Conv;
local local_tmsg = tim.Msg;
local local_tgroup = tim.Group;
local local_tuser = tim.UserProfile;
local local_tfriend = tim.Friendship;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_LOGO1_LM            = 1001,
	ID_IMG_ML_MAIN2_LM            = 1002,
	ID_IMG_ML_MAIN2_LM1           = 1003,
	ID_IMG_ML_MAIN2_LM2           = 1004,
	ID_IMG_ML_MAIN2_LM3           = 1005,
	ID_IMG_ML_MAIN_LM             = 1006,
	ID_IMG_ML_MAIN_LM1            = 1007,
	ID_IMG_ML_MAIN_LM2            = 1008,
	ID_IMG_ML_MAIN_LM3            = 1009,
	ID_IMG_ML_MAIN_LM4            = 1010,
	ID_IMG_ML_MAIN_LM5            = 1011,
	--/* Text ID */
	ID_TXT_NO0                    = 4001,
	ID_TXT_NO1                    = 4002,
	ID_TXT_NO2                    = 4003,
	ID_TXT_NO3                    = 4004,
	ID_TXT_NO4                    = 4005,
	ID_TXT_NO5                    = 4006,
}

function AInstall:init()

	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/GuanYuWoMen.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--	用户协议
	gDef:AddGuiByID(self,idsw.ID_TXT_NO2,30,800,30,200);
	--	隐私协议
	gDef:AddGuiByID(self,idsw.ID_TXT_NO3,30,800,30,200);
	--	客服帮助
	gDef:AddGuiByID(self,idsw.ID_TXT_NO4,30,800,30,200);
	--	意见反馈
	gDef:AddGuiByID(self,idsw.ID_TXT_NO5,30,800,30,200);
	--	返回按钮
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM1,10,10,10,10);
	
	--	意见反馈
	self.m_AFeedBack = kd.class(AFeedBack, false, true);
	self:addChild(self.m_AFeedBack);
	self.m_AFeedBack:SetVisible(false);
	self.m_AFeedBack:init();
	self.m_AFeedBack:SetVisible(false);
	
	--	注册数据中心
	DC:RegisterCallBack("AInstall.Show",self,function(bool)
		self:SetVisible(bool)
	end);
	
	--创建会话
	DC:RegisterCallBack("MeView.create_conv",self,function(data)
		DC:CallBack("AChat.Show",data,"小客服",nil,nil,"MeView");
	end)
	
	--加载数据
	DC:RegisterCallBack("MeView.msgGetMsgList",self,function(data)
		DC:CallBack("AChat.SetData",data,"小客服");
	end)
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function AInstall:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
	DC:CallBack("AHomePageButtom.Show",not visible);
end

--	UI
function AInstall:onGuiToucBackCall(id)
	if id == idsw.ID_TXT_NO2 then				--	用户协议
		echo("用户协议");
		gSink:ShowHtml("用户协议",gDef.agreement);
		DC:FillData("ALogin.IsInHtml",true);
	elseif id == idsw.ID_TXT_NO3 then			--	隐私协议
		echo("隐私协议");
		gSink:ShowHtml("隐私权政策",gDef.policy);
		DC:FillData("ALogin.IsInHtml",true);
	elseif id == idsw.ID_TXT_NO4 then			--	客服帮助
		echo("客服帮助");
		
		local create_conv_data = {};
		create_conv_data.call_id = "create_conv";
		create_conv_data.call_name ="MeView.create_conv";
		create_conv_json = kd.CJson.EnCode(create_conv_data);
		
		local convid = gSink:GetServiceIMid();
		local ret = local_tconv.convCreate(convid, local_tconv.TIMConvType.kTIMConv_C2C, create_conv_json);
		if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
			echo("KD_LOG:TIM create conv error code:"..ret);
		end
	elseif id == idsw.ID_TXT_NO5 then			--	意见反馈
		echo("意见反馈");
		DC:CallBack("AFeedBack.Show",true);
	elseif id == idsw.ID_IMG_ML_MAIN_LM1 then
		echo("返回按钮");
		DC:CallBack("AInstall.Show",false);
	end
end