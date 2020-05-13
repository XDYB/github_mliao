
local kd = KDGame;
local gDef = gDef;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
local gSink = A_ViewManager;


local local_tim = tim;
local local_tsdk = tim.sdk;
local local_tconv = tim.Conv;
local local_tmsg = tim.Msg;
local local_tgroup = tim.Group;
local local_tuser = tim.UserProfile;
local local_tfriend = tim.Friendship;

PlayTab = kd.inherit(kd.Layer);--主界面

c_Require("Script/MiLiao/Video/PlayPhotoItem.lua")
local sprReac = {
	{1732, 1758, 92, 92},	-- 未点赞
	{1826, 1758, 92, 92}	-- 未点赞
}
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
local TIME_CLICK = 101;

function PlayTab:init()
	local color = 0xff000000;
	local draw = kd.class(kd.GeometryDraw);
	self:addChild(draw);
	local pints = {
		{x=0, y=0},
		{x=0, y=ScreenH},
		{x=ScreenW, y=ScreenH},
		{x=ScreenW, y=0},
	};
	draw:DrawPolygon(pints, color, 1, color);
	
	

	self.tab = kd.class(ANTab,true,false);
	self.tab:init(0); --触发滑动的高度 从0开始
	self:addChild(self.tab)
	self.tab.ExitView = function (this, index)
		echo(" index = "..index);
		if index < 0 then
			local dx = self.m_ex - self.m_x;
			local dy = math.abs(self.m_ey - self.m_y);
			if dx >= 3*dy then
				DC:CallBack("PlayView.Show",false);
			end
		end
	end

	self.m_photoList = {};
	
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
	
	DC:RegisterCallBack("PlayTab.SetVideoInfo",self,function (data)
		self:SetVideoInfo(data);
	end)
end


function PlayTab:initView()
	self.m_cusFace:SetFace();
	self.m_data = {};
	self:Hide();
	self.action = 0;
	self.m_isCooling = false;
	self.m_bload  = false;
end

function PlayTab:GetVideoUrl()
	return self.m_data.video;
end
-- 获取动态ID
function PlayTab:GetDynamicId()
	return self.m_data.Id;
end
-- 获取点赞状态
function PlayTab:GetActionStatus()
	return self.action;
end
-- 获取点赞状态
function PlayVideoItem:GetUserId()
	return self.m_data.UserId;
end
-- 设置点赞状态
function PlayTab:SetActionStatus(action)
	self.action = action;
	local index = self.action + 1;
	self.m_sprLike:SetTextureRect(sprReac[index][1], sprReac[index][2], sprReac[index][3], sprReac[index][4]);
end

function PlayTab:SetLikeNum(num)
	self.m_txtLike:SetString(num);
end

function PlayTab:ShowLoadView(bo)
	self.m_sprLoading:SetVisible(bo);
	self.m_txtLoading:SetVisible(bo);
end

function PlayTab:Hide()
	self.m_sprPlay:SetVisible(false);
	self:ShowLoadView(false);
	self:Show(false);
	self.m_bload = false;
	
	for i = 1,#self.m_photoList do 
		local item = table.remove(self.m_photoList);
		item = nil;
	end
	self.m_photoList = {};
	echo("清空 self.m_photoList")
	
	self.tab:ClearNode();
--	self.tab:SetPos(0,ScreenH);
	self.tab:SetIndexNoAni(0);
	self:SetVisible(false);
end

function PlayTab:Show(bo)
	self.m_objMore:SetVisible(bo);
	self.m_objLike:SetVisible(bo);
	self.m_txtLike:SetVisible(bo);
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
function PlayTab:ShowCover()
	self.m_cover:SetVisible(true);
	self:Hide(false);
end

-- 隐藏封面
function PlayTab:HideCover()
	self.m_cover:SetVisible(false);
	self:Show(true);
end

function PlayTab:onGuiToucBackCall(--[[int]] id)
	-- 返回
	if id == idsw.ID_IMG_ML_MAIN_LM then
		DC:CallBack("PlayView.Show",false);
	-- 更多
	elseif id == idsw.ID_IMG_ML_MAIN_LM1 then
		echo("更多");
		if self.m_data.UserId == gSink.m_User.userId then
			gSink:messagebox_default("不能对自己进行操作");
			return;
		end
		self:SetTimer(TIME_CLICK, 101, 1);
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
		DC:CallBack("DetaileView.GetDetailData",self.m_data.UserId);
	end
end


function PlayTab:OnTimerBackCall(id)
	if id == 101 then
		self.m_isCooling = false;
	end
end

function PlayTab:GoToIm()
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

function PlayTab:SetViewData(data)
	if self.m_bload  then return;end 
	self.m_bload = true;
	self.m_data = data;
	self.m_txtLike:SetString(data.LikeNum);
	self.m_txtComments:SetString(data.CommentNum);
	self.m_txtName:SetString(data.NickName);
	self.m_txtDescription:SetString(data.Description);
	
	self.m_cusFace:SetFace(gDef.domain..data.AvatarFile);
	self:Show(true);
end


function PlayTab:UpdteCommentNum(newNum)
	local num = self.m_txtComments:GetString();
	num = num - 0;
	if newNum then
		num = newNum > num and newNum or num;
	else
		num = num + 1;
	end
	self.m_txtComments:SetString(num);
end

function PlayTab:SetVideoInfo(data)
	if data then
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
	end
end

function PlayTab:ShowPhoto(data)
	--执行清流
	self.tab:ClearNode();
	self.m_photoList = {};
	
	--创建子项
	self:SetViewData(data);
	
	--重新设置位置
	self.tab:SetIndexNoAni(0);
	
	local ncnt = 0;
	for i =1 ,#data.Imglist do 
		local PhotoItem = kd.class(PlayPhotoItem,false,false)
		if PhotoItem then 
			PhotoItem:init(ncnt,data.Imglist[i]);
			ncnt = ncnt + 1;
			self.tab:AddNode(PhotoItem);
			table.insert(self.m_photoList,PhotoItem);
		end 
	end
	
	echo("创建图片: 数量",#self.m_photoList);
	
	self:SetVisible(true);
	self:setDebugMode(true);
	self:SetViewData(data)

end

function PlayTab:onTouchBegan(x,y)
	self.tab:onTouchBegan(x,y);
	self.m_x,self.m_y = x,y;
end
function PlayTab:onTouchMoved(x,y)
	if #self.m_photoList<=1 then echo("照片数量少于1");  return ;end 
	self.tab:onTouchMoved(x,y);
end
function PlayTab:onTouchEnded(x,y)
	self.m_ex,self.m_ey = x,y;
	self.tab:onTouchEnded(x,y);
end
