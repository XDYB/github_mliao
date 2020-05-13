
local kd = KDGame;
local gDef = gDef;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local local_tim = tim;
local local_tsdk = tim.sdk;
local local_tconv = tim.Conv;
local local_tmsg = tim.Msg;
local local_tgroup = tim.Group;
local local_tuser = tim.UserProfile;
local local_tfriend = tim.Friendship;

local gSink = A_ViewManager;

PlayVideoItem = kd.inherit(kd.Layer);--主界面

local idsw = {
	--/* Image ID */
	ID_IMG_ML_SHANGZHEZHAO_LM           = 1001,
	ID_IMG_ML_XIAZHEZHAO_LM             = 1002,
	ID_IMG_ML_MOREN_LM                  = 1003,
	ID_IMG_ML_MAIN_LM                   = 1004,
	ID_IMG_ML_MAIN_LM1                  = 1005,
	ID_IMG_ML_MAIN_LM2                  = 1006,
	ID_IMG_ML_MAIN_LM3                  = 1007,
	ID_IMG_ML_MAIN_LM4                  = 1008,
	ID_IMG_ML_MAIN_LM5                  = 1009,
	--/* Text ID */
	ID_TXT_NO0                          = 4001,
	ID_TXT_NO1                          = 4002,
	ID_TXT_NO2                          = 4003,
	ID_TXT_NO3                          = 4004,
	ID_TXT_NO4                          = 4005,
	ID_TXT_NO5                          = 4006,
	--/* Custom ID */
	ID_CUS_ML_MAIN_LM                   = 6001,
	ID_CUS_ML_TX145_LM                  = 6002,
}

local sprReac = {
	{1732, 1758, 92, 92},	-- 未点赞
	{1826, 1758, 92, 92}	-- 未点赞
}
local TIME_CLICK = 101;
function PlayVideoItem:init(playview,data)	
	self.m_playview = playview;
	self.m_cover = kd.class(kd.AsyncSprite,data.img);
	self.m_cover:SetPos(ScreenW/2,ScreenH/2);
	if data.m_data.VideoRotation ~= nil and data.m_data.VideoRotation > 0 then
		self.m_cover:SetRotation(data.m_data.VideoRotation);
	end
	self:addChild(self.m_cover);
	self.m_cover.OnLoadTextrue = function(this, --[[int]] err_code --[[0:成功]], --[[string]] err_info)
		local w,h = this:GetTexWH();
		if data.m_data.VideoRotation ~= nil and data.m_data.VideoRotation == 90 then
			local ww = w;
			w = h;
			h = ww;
		end
		local sc = math.min(ScreenW/w,ScreenH/h);
		local sc1 = tonumber(string.format("%.2f",sc));
		if sc1>sc then sc1 =sc1 - 0.01;end 
		self.m_cover:SetScale(sc1,sc1);
	end	
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/ShiPin.UI"), self);
	self:addChild(self.m_thView);
	self.m_thView:SetZOrder(2);
	-- 返回按钮
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM,40,90,40,40);
	
	-- 更多
	self.m_objMore = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM1,30,40,30,90);
	
	-- 播放
	self.m_sprPlay = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM5);
	
	-- 加载
	self.m_sprLoading = self.m_thView:GetSprite(idsw.ID_IMG_ML_MOREN_LM);
	self.m_txtLoading = self.m_thView:GetText(idsw.ID_TXT_NO5);
	
	-- 点赞
	self.m_sprLike = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM2);
	self.m_objLike = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM2,20,20,20,20);
	self.m_txtLike = self.m_thView:GetText(idsw.ID_TXT_NO2);
	self.m_txtLike:SetHAlignment(kd.TextHAlignment.CENTER);
	local x,_ = self.m_objLike.spr:GetPos();
	local _,y = self.m_txtLike:GetPos();
	self.m_txtLike:SetPos(x,y);
	
	-- 评论
	self.m_objComments = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM3,20,20,20,20);
	self.m_txtComments = self.m_thView:GetText(idsw.ID_TXT_NO3);
	self.m_txtComments:SetHAlignment(kd.TextHAlignment.CENTER);
	local x,_ = self.m_objComments.spr:GetPos();
	local _,y = self.m_txtComments:GetPos();
	self.m_txtComments:SetPos(x,y);
	
	-- 私信
	self.m_objMsg = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM4,20,20,20,20);
	self.m_txtMsg = self.m_thView:GetText(idsw.ID_TXT_NO4);
	
	-- 头像
	self.m_cusFace = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_TX145_LM,nil,false,2)
	
	-- 昵称
	self.m_txtName = self.m_thView:GetText(idsw.ID_TXT_NO0);
	self.m_txtName:SetHAlignment(kd.TextHAlignment.LEFT);
	-- 说明
	self.m_txtDescription = self.m_thView:GetText(idsw.ID_TXT_NO1);
	self.m_txtDescription:SetHAlignment(kd.TextHAlignment.LEFT);
	
	-- 进入详情
	self.m_objInDetaile = gDef:AddGuiByID(self,idsw.ID_TXT_NO0,80,200,30,80);
	local x1,y1 = self.m_txtName:GetPos();
	local x2,y2 = self.m_txtDescription:GetPos();
	local y = y1 - (y2-y1)/2;
	local str = self.m_txtDescription:GetString();
	local len = gDef:GetTextLen(35,str);
	local x = x2 - len/2 - 40;
	self.m_objInDetaile.gui:SetTouchRect(x-100,y,350,120);
	
	self:initView();
	
	self:SetViewData(data.m_data);
end

function PlayVideoItem:initView()
	self.m_cusFace:SetFace();
	self.m_data = {};
	self:Hide();
	self.action = 0;
	self.m_isCooling = false;
end

function PlayVideoItem:GetVideoUrl()
	return self.m_data.video;
end
-- 获取动态ID
function PlayVideoItem:GetDynamicId()
	return self.m_data.Id;
end
-- 获取点赞状态
function PlayVideoItem:GetActionStatus()
	return self.action;
end
-- 获取点赞状态
function PlayVideoItem:GetUserId()
	return self.m_data.UserId;
end
-- 设置点赞状态
function PlayVideoItem:SetActionStatus(action)
	self.action = action;
	local index = self.action + 1;
	self.m_sprLike:SetTextureRect(sprReac[index][1], sprReac[index][2], sprReac[index][3], sprReac[index][4]);
end

function PlayVideoItem:Pause()
	local bo = self.m_sprPlay:IsVisible();
	self.m_sprPlay:SetVisible(not bo);
end
function PlayVideoItem:SetLikeNum(num)
	self.m_txtLike:SetString(num);
end

function PlayVideoItem:ShowLoadView(bo)
	self.m_sprLoading:SetVisible(bo);
	self.m_txtLoading:SetVisible(bo);
end

function PlayVideoItem:Hide()
	self.m_sprPlay:SetVisible(false);
	self:ShowLoadView(false);
	self:Show(false);
end

function PlayVideoItem:Show(bo)
	self.m_objMore:SetVisible(bo);
	self.m_objLike:SetVisible(bo);
	self.m_txtLike:SetVisible(bo);
	local userid = gSink:GetUser();
	if bo and self.m_data and self.m_data.UserId == gSink.m_User.userId then
		self.m_objComments:SetVisible(false);
		self.m_txtComments:SetVisible(false);
		self.m_objMsg:SetVisible(false);
		self.m_txtMsg:SetVisible(false);
	else
		self.m_objComments:SetVisible(bo);
		self.m_txtComments:SetVisible(bo);
		self.m_objMsg:SetVisible(bo);
		self.m_txtMsg:SetVisible(bo);
	end
	self.m_cusFace:SetVisible(bo);
	self.m_txtName:SetVisible(bo);
	self.m_txtDescription:SetVisible(bo);
	self.m_objInDetaile:SetVisible(bo);
end

-- 显示封面
function PlayVideoItem:ShowCover()
	if self.m_cover then
		self.m_cover:SetVisible(true);
	end
	self:Hide(false);
end

-- 隐藏封面
function PlayVideoItem:HideCover()
	if self.m_cover then
		self.m_cover:SetVisible(false);
	end
	self:Show(true);
end

function PlayVideoItem:onGuiToucBackCall(--[[int]] id)
	-- 返回
	if id == idsw.ID_IMG_ML_MAIN_LM then
		DC:CallBack("PlayView.Show",false);
	end
	-- 断网界面是否显示
	local bo = DC:GetData("NoWifi.Show");
	if bo then
		return;
	end
	-- 更多
	if id == idsw.ID_IMG_ML_MAIN_LM1 then
		echo("更多");
		if self.m_data.UserId == gSink.m_User.userId then
			gSink:messagebox_default("不能对自己进行操作");
			return;
		end
		self:SetTimer(TIME_CLICK, 2000, 1);
		if not self.m_isCooling then
			self.m_isCooling = true
			DC:CallBack("PlayView.ShowBackPop",true)
		end
	-- 点赞
	elseif id == idsw.ID_IMG_ML_MAIN_LM2 then
		echo("点赞");
		if self.m_data.UserId == gSink.m_User.userId then
			gSink:messagebox_default("不能给自己点赞");
		else
			DC:CallBack("PlayView.like_dynamic");
		end
	-- 评论
	elseif id == idsw.ID_IMG_ML_MAIN_LM3 then
		echo("评论");
		DC:CallBack("Comments.Show",true, self:GetDynamicId());
	-- 私信
	elseif id == idsw.ID_IMG_ML_MAIN_LM4 then
		echo("私信");
		self:GoToIm()
	-- 进入详情
	elseif id == idsw.ID_TXT_NO0 then
		echo("进入详情");
		DC:CallBack("PlayView.IsPause",true);
		DC:CallBack("DetaileView.GetDetailData",self.m_data.UserId);
	end
end

function PlayVideoItem:OnTimerBackCall(id)
	if id == TIME_CLICK then
		self.m_isCooling = false;
	end
end

function PlayVideoItem:GoToIm()
	gSink:Post("michat/is-hate",{touserid = self.m_data.UserId },function (data)
		if data.Result then 
			if data.IsBlacklist then 
				return gSink:messagebox_default("你已将TA拉入黑名单")
			end
			
			if data.IsBeBlacklist then 
				return gSink:messagebox_default("TA已将您拉入黑名单")
			end
			
			local create_conv_data = {};
			create_conv_data.call_id = "create_conv";
			create_conv_data.call_name ="GetOneVideoList.create_conv";
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
	end);
end

function PlayVideoItem:SetViewData(data)
	self.m_data = data;
	self.m_txtLike:SetString(data.LikeNum);
	self.m_txtComments:SetString(data.CommentNum);
	self.m_txtName:SetString(data.NickName);
	self.m_txtDescription:SetString(data.Description);
	
	self.m_cusFace:SetFace(gDef.domain..data.AvatarFile);
	
end

function PlayVideoItem:UpdteCommentNum(newNum)
	local num = self.m_txtComments:GetString();
	num = num - 0;
	if newNum then
		num = newNum > num and newNum or num;
	else
		num = num + 1;
	end
	self.m_txtComments:SetString(num);
end

function PlayVideoItem:GetDynamicNum()
	local num = self.m_txtComments:GetString();
	return num - 0;
end

function PlayVideoItem:SetVideoInfo()
	local id = self:GetDynamicId();
	gSink:Post("michat/get-dynamicinfo",{dynamicid = id},function(data)
		if data.Result then
			self.m_txtLike:SetString(data.LikeNum);
			self.m_txtComments:SetString(data.CommentNum);
			-- 是否点赞
			if data.IsLike then
				self.action = 1;
			else
				self.action = 0;
			end
			local index = self.action + 1;
			self.m_sprLike:SetTextureRect(sprReac[index][1], sprReac[index][2], sprReac[index][3], sprReac[index][4]);
			DC:CallBack("PlayView.PlayByIndex");
			DC:CallBack("PlayTab.SetVideoInfo",data);
			local updateData = {dynamicid = id, LikeNum = data.LikeNum, action = self.action, commentNum = -1}
			if self.m_viewType then
				DC:CallBack(self.m_viewType..".updateIndex", updateData);
			end
		else
			gSink:messagebox_default(data.ErrMsg);
		end
	end);
end