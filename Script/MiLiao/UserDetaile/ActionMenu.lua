--[[

功能选项

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

ActionMenu = kd.inherit(kd.Layer);
local impl = ActionMenu;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

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
	ID_IMG_ML_MAIN2_LM            = 1001,
	ID_IMG_ML_MAIN2_LM1           = 1002,
	ID_IMG_ML_MAIN_LM             = 1003,
	ID_IMG_ML_MAIN_LM1            = 1004,
	ID_IMG_ML_MAIN_LM2            = 1005,
}

-- 打开/关闭 切图区域
local sprReac = {
	{1183,1003,204,204},	-- "+"
	{977,1003,203,203}		-- "x"
}

-- 关注/取关
local sprFcous = {
	{1701, 1221, 100, 100},	-- 未关
	{1599, 1221, 100, 100}	-- 已关
}

function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/XQGongNeng.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	-- 设置点击事件
	self.m_objAddOrCloss = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN2_LM1,0,0,0,0);
	self.m_sprAddOrCloss = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM1);
	self.m_numType = 1;
	
	-- 打招呼
	self.m_objHello = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM,20,20,20,20);
	
	-- 私信
	self.m_objMessage = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM1,20,20,20,20);
	
	-- 关注
	self.m_objFcous = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM2,20,20,20,20);
	
	-- 背景
	self.m_sprBg = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM);
	
	self:initView();
	
	DC:RegisterCallBack("Detail.create_conv",self,function (data)
		self:create_conv(data)
	end)
end

function impl:onGuiToucBackCall(id)
	-- 切换状态
	if id == idsw.ID_IMG_ML_MAIN2_LM1 then
		
	-- 打招呼
	elseif id == idsw.ID_IMG_ML_MAIN_LM then
		echo("打招呼");
		gSink:Post("michat/is-hate",{touserid = self.touserid},function(data)
			if data.Result then
				if data.IsBlacklist then
					gSink:messagebox_default("你已将TA拉入黑名单")
					return;
				end
				if data.IsBeBlacklist then
					gSink:messagebox_default("TA已将您拉入黑名单")
					return;
				end
				gSink:PMsgSendTextMsg("hi~很高兴认识你！",self.touserid)
				gSink:messagebox_default("给对方发了一条私信")
			else
				gSink:messagebox_default(data.ErrMsg)
			end
		end);
		
		
	-- 私信
	elseif id == idsw.ID_IMG_ML_MAIN_LM1 then
		echo("私信");
		self:GoToIm()
	-- 关注
	elseif id == idsw.ID_IMG_ML_MAIN_LM2 then
		echo("关注");
		self:michat_love();
	end
	self.m_numType = self.m_numType == 1 and 2 or 1;
	self:ChangeStatus();
end

--创建会话
function impl:create_conv(data)
	self.m_convData = data;
	local Detaidata = DC:GetData("DetaileView.data");
	DC:CallBack("AChat.Show",data,Detaidata.Nickname,gDef.domain..Detaidata.AvatarFile,nil,"Detail")
end

function impl:GoToIm()
	gSink:Post("michat/is-hate",{touserid = self.touserid},function (data)
		if data.Result then 
			if data.IsBlacklist then 
				return gSink:messagebox_default("你已将TA拉入黑名单")
			end
			
			if data.IsBeBlacklist then 
				return gSink:messagebox_default("TA已将您拉入黑名单")
			end
			
			local create_conv_data = {};
			create_conv_data.call_id = "create_conv";
			create_conv_data.call_name ="Detail.create_conv";
			create_conv_json = kd.CJson.EnCode(create_conv_data);
			local convid = gSink:AddTimPre(self.touserid);
			local ret = local_tconv.convCreate(convid, local_tconv.TIMConvType.kTIMConv_C2C, create_conv_json);
			if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
				echo("KD_LOG:TIM create conv error code:"..ret);
			end
		else
			gSink:messagebox_default(data.ErrMsg);
		end
	end);
end


function impl:initView()
	self.m_numType = 1;
	self:ChangeStatus();
--	self:SetViewData(1);
	
end

-- 切换状态
function impl:ChangeStatus()
	local bo = self.m_numType == 2;
	self.m_objAddOrCloss.spr:SetTextureRect(sprReac[self.m_numType][1], sprReac[self.m_numType][2], sprReac[self.m_numType][3], sprReac[self.m_numType][4]);
	self.m_objHello:SetVisible(bo);
	self.m_objMessage:SetVisible(bo);
	self.m_objFcous:SetVisible(bo);
	self.m_sprBg:SetVisible(bo);
end

-- 设置关注的状态
-- @typeId 1:未关 2:已关
function impl:SetViewData()
	local data = DC:GetData("DetaileView.data");
	local boIsFocus = data.IsFocus; -- bo
	self.touserid = data.touserid;
	self.FocusStatus = 1;
	if boIsFocus then
		self.FocusStatus = 2;
	end
	local typeId = self.FocusStatus;
	self.m_objFcous.spr:SetTextureRect(sprFcous[typeId][1],sprFcous[typeId][2],sprFcous[typeId][3],sprFcous[typeId][4]);
end

function impl:michat_love()
	local action = self.FocusStatus - 1;
	action = action == 1 and 0 or 1;
	gSink:Post("michat/love",{touserid = self.touserid,action = action},function(data)
		if data.Result then
			self.FocusStatus = action + 1
			local typeId = self.FocusStatus;
			local msg = action == 1 and "关注成功" or "取消关注成功";
			self.m_objFcous.spr:SetTextureRect(sprFcous[typeId][1],sprFcous[typeId][2],sprFcous[typeId][3],sprFcous[typeId][4]);
			gSink:messagebox_default(msg);
			local UserData = DC:GetData("DetaileView.data");
			UserData.IsFocus = action == 1;
			DC:FillData("DetaileView.data", UserData);
			-- 更新数量
			local fansNum = action == 1 and 1 or (-1);
			DC:CallBack("DetaileView.UpdateFansNum",fansNum)
		else
			gSink:messagebox_default(data.ErrMsg);
		end
	end);
end
