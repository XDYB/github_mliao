--[[

咪一下 -- 匹配成功

--]]

local local_tim = tim;
local local_tsdk = tim.sdk;
local local_tconv = tim.Conv;
local local_tmsg = tim.Msg;
local local_tgroup = tim.Group;
local local_tuser = tim.UserProfile;
local local_tfriend = tim.Friendship;

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local tweenPro = TweenPro;

Mi_MatchingSucc = kd.inherit(kd.Layer);
local impl = Mi_MatchingSucc;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw={
	--/* Image ID */
	ID_IMG_ML_PIPEINV_LM           = 1001,
	ID_IMG_ML_MAIN2_LM             = 1002,
	ID_IMG_ML_MAIN3_LM             = 1003,
	--/* Text ID */
	ID_TXT_NO0                     = 4001,
	--/* Custom ID */
	ID_CUS_ML_MAIN3_LM             = 6001,
}

-- 圆圈切图区域
local sprYuan = {
	{1058, 816, 222, 222},	-- 女
	{1282, 816, 222, 222}	-- 男
}

local sprBg = {
	gDef.GetResPath("ResAll/PiPeiNv.png"),	-- 女
	gDef.GetResPath("ResAll/PiPeiNan.png")	-- 男
}

function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/MYXPiPeiJieGuoNv.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	-- 气泡 
	self.m_sprPop = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM);
	self.m_popX, self.m_popY = self.m_sprPop:GetPos();
	
	-- 头像
	self.m_cusFace = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_MAIN3_LM,nil,false,2)
	
	-- 圈圈 
	self.m_sprYuan = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN3_LM);
	
	-- 昵称 
	self.m_txtName = self.m_thView:GetText(idsw.ID_TXT_NO0);
	self.m_txtName:SetHAlignment(kd.TextHAlignment.CENTER);
	local x,y = self.m_txtName:GetPos();
	self.m_txtName:SetPos(ScreenW/2,y);
	
	-- 背景 
	self.m_sprBg = self.m_thView:GetSprite(idsw.ID_IMG_ML_PIPEINV_LM);
	
	DC:RegisterCallBack("Mi_MatchingSucc.Show",self,function (bo)
		self:SetVisible(bo);
		local num = 1
		if bo then
			tweenPro:Animate({
				{o=self.m_thView,scale=num}
			})
			tweenPro:SetTimeout(500,function ()
				self:PlayPop();
			end);
		end
	end)
	
	DC:RegisterCallBack("Mi_MatchingSucc.SetViewData",self,function (data)
		self:SetViewData(data);
	end)
	DC:RegisterCallBack("MiYiXia.create_conv",self,function (data)
		self:create_conv(data);
	end)
end

function impl:initView()
	self.m_cusFace:SetFace();
	self.m_txtName:SetString("---");
end

function impl:SetViewData(data)
	self.m_data = data
	local sex = data.Sex;
	local name = data.Nickname;
	local urlface = gDef.domain..data.AvatarFile;
--	local urlface = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1587448060419&di=45b925559ee3fb719d298a53fc5eafc2&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fd1160924ab18972b48067763e4cd7b899e510a5e.jpg";
	-- 圆圈
	self.m_sprYuan:SetTextureRect(sprYuan[sex+1][1],sprYuan[sex+1][2],sprYuan[sex+1][3],sprYuan[sex+1][4]);
	-- 背景
	self.m_sprBg:SetTexture(sprBg[sex+1]);
	-- 昵称
	self.m_txtName:SetString(name);
	-- 头像
	self.m_cusFace:SetFace(urlface);
	
	-- 缩放
	local scale = 0.3;
	
	self.m_sprPop:SetPos(self.m_popX, self.m_popY + 100);
	self.m_sprPop:SetScale(scale, scale);
	self.m_sprPop:SetVisible(false);
	
	self.m_thView:SetScale(scale, scale);
	
end

function impl:GoToIm()
	--[[
		Result bool
		UserId int
		Nickname string
		Sex int（0女，1男）
		AvatarFile string
		TagsList []int（共同的标签列表）
	]]
	--self.m_data.UserId = 19--test
	--[[gSink:Post("michat/is-hate",{touserid = self.m_data.UserId },function (data)
		if data.Result then 
			if data.IsBlacklist then 
				return gSink:messagebox_default("你已将TA拉入黑名单")
			end
			
			if data.IsBeBlacklist then 
				return gSink:messagebox_default("TA已将您拉入黑名单")
			end
			
			local create_conv_data = {};
			create_conv_data.call_id = "create_conv";
			create_conv_data.call_name ="MiYiXia.create_conv";
			create_conv_json = kd.CJson.EnCode(create_conv_data);
			--self.m_data.UserId = 43--test
			local convid = gSink:AddTimPre(self.m_data.UserId);
			local ret = local_tconv.convCreate(convid, local_tconv.TIMConvType.kTIMConv_C2C, create_conv_json);
			if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
				echo("KD_LOG:TIM create conv error code:"..ret);
			end
		else
			gSink:messagebox_default(data.ErrMsg);
		end
	end);--]]
	
	local create_conv_data = {};
	create_conv_data.call_id = "create_conv";
	create_conv_data.call_name ="MiYiXia.create_conv";
	create_conv_json = kd.CJson.EnCode(create_conv_data);
	--self.m_data.UserId = 43--test
	local convid = gSink:AddTimPre(self.m_data.UserId);
	local ret = local_tconv.convCreate(convid, local_tconv.TIMConvType.kTIMConv_C2C, create_conv_json);
	if (ret ~= local_tsdk.TIMErrCode.ERR_SUCC) then
		echo("KD_LOG:TIM create conv error code:"..ret);
	end
end

--创建会话
function impl:create_conv(data)
	self.m_convData = data;
	DC:CallBack("AChat.SetMiyixia",self.m_data.TagsList)
	DC:CallBack("AChat.Show",data,self.m_data.Nickname,gDef.domain..self.m_data.AvatarFile,self.m_data.IsFocus,"MiYiXia")
	self:SendCusmsg()
end

function impl:PlayPop()
	self.m_sprPop:SetVisible(true);
	tweenPro:Animate({
		{o=self.m_sprPop,scale=1, x=self.m_popX, y=self.m_popY, fn = function ()
			tweenPro:SetTimeout(1500,function ()
				if self:IsVisible() == true then
					self:GoToIm();
					--self:SendCusmsg()
				end
			end);
		end}
	})
end

--发送自定义消息
function impl:SendCusmsg()
	local touserid = self.m_data.UserId
	local data = {}
	data.url = DC:GetData("MyView.AvatarFile")
	data.name =DC:GetData("MyView.Nickname")
	data.TagsList = self.m_data.TagsList;
	data.conv_id = gSink.m_myconvid;
	data.type = "bemiyixia"
	local json = kd.CJson.EnCode(data)
	gSink:PMsgSendCustomMsg(json,touserid)
end


