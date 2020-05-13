--[[
	动态详情信息视频
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

ADynamicTopicDetaiVideo = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_HUATIZIYUANS1_LM           = 1001,	--	话题标签
	ID_IMG_ML_MAIN2_LM                   = 1002,	--	删除按钮
	ID_IMG_ML_MAIN_LM1                   = 1003,	--	红心
	ID_IMG_ML_MAIN_LM2                   = 1004,	--	评论
	ID_IMG_ML_MAIN_LM3                   = 1005,	--	性别图标
	ID_IMG_ML_MAIN_LM4                   = 1006,	--	视频播放按钮
	ID_IMG_ML_MAIN_LM5                   = 1007,	--	灰评论
	ID_IMG_ML_MAIN_LM6                   = 1008,	--	灰心
	--/* Text ID */
	ID_TXT_NO0                           = 4001,	--	名字
	ID_TXT_NO1                           = 4002,	--	日期
	ID_TXT_NO2                           = 4003,	--	签名
	ID_TXT_NO3                           = 4004,	--	红心值
	ID_TXT_NO4                           = 4005,	--	评论值
	--/* Custom ID */
	ID_CUS_ML_MAIN3_LM                   = 6001,	--	视频背景图片
	ID_CUS_ML_TX137_LM                   = 6002,	--	用户头像
};

function ADynamicTopicDetaiVideo:init(index)
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/DTShiPinLieBiao.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end

	--	用户昵称
	self.m_nickName = self.m_thView:GetText(idsw.ID_TXT_NO0);
	
	--	性别图标
	self.m_Sex = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM3);
	local x,y = self.m_Sex:GetPos();
	self.m_Sex:SetPos(x-80,y);
	
	--	签名
	self.m_sign = self.m_thView:GetText(idsw.ID_TXT_NO2);
	
	--	发布日期
	self.m_releaseTime = self.m_thView:GetText(idsw.ID_TXT_NO1);
	
	--	红心值
	self.m_redHeard = self.m_thView:GetText(idsw.ID_TXT_NO3);
	self.m_redHeard:SetHAlignment(kd.TextHAlignment.CENTER);
	local x,y = self.m_redHeard:GetPos();
	self.m_redHeard:SetPos(x-20,y);
	
	--	评论值
	self.m_comments = self.m_thView:GetText(idsw.ID_TXT_NO4);
	self.m_comments:SetHAlignment(kd.TextHAlignment.CENTER);
	local a,b = self.m_comments:GetPos();
	self.m_comments:SetPos(a-20,b);
	
	--	红心图标
	self.m_redHeardImg = {
		spr1 = 0,
		spr2 = 0,
		SetVisible = function(this,bool)
			this.spr1:SetVisible(bool);
			this.spr2:SetVisible(not bool);
		end
	};
	self.m_redHeardImg.spr1 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM1);			--	红
	self.m_redHeardImg.spr2 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM6);			--	灰
	
	--	评论图标
	self.m_commentsImg = {
		spr1 = 0,
		spr2 = 0,
		SetVisible = function(this,bool)
			this.spr1:SetVisible(bool);
			this.spr2:SetVisible(not bool);
		end
	};
	self.m_commentsImg.spr1 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM2);			--	红
	self.m_commentsImg.spr2 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM5);			--	灰
	
	--	初始化这2个都是灰色
	self.m_redHeardImg:SetVisible(false);
	self.m_commentsImg:SetVisible(false);
	self.m_thView:SetVisible(idsw.ID_IMG_ML_MAIN2_LM,false);			--	删除按钮

	
	-- 视频背景
	self.m_video = {
		BgImg = 0,
		SetVisible = function(this,bool)
			this.BgImg:SetVisible(bool);
		end,
	};
	
	self.m_video.BgImg = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_MAIN3_LM,nil,false,3);		--	图片

	--  初始化
	self.m_video:SetVisible(true);

	--	话题标签
	self.m_TopicPhoto = self.m_thView:GetSprite(idsw.ID_IMG_ML_HUATIZIYUANS1_LM);
	
	--	临时变量
	self.m_data = nil;
end

function ADynamicTopicDetaiVideo:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

function ADynamicTopicDetaiVideo:Cls()
	if self.m_vide then
		self.m_video:Del();
		self.m_video = nil;
		self.m_redHeard:SetVisible(false);
	end
end


function ADynamicTopicDetaiVideo:onGuiToucBackCall(id)
	-- 播放按钮
	if id == idsw.ID_IMG_ML_MAIN_LM4 then
		echo("播放按钮");
	elseif id == idsw.ID_CUS_ML_TX137_LM then
		echo("用户详情信息点击事件演示");
		if self.m_data ~= nil then
			local userID = self.m_data.UserId;
			if userID ~= nil then
				DC:CallBack("DetaileView.GetDetailData",userID);
			end
		end
	end
end

--	视频信息
function ADynamicTopicDetaiVideo:SetData(data)
	if data ==  nil then return;end
	self.m_data = data;							--	临时数据
	self:SetUserFace(data.AvatarFile);			-- 	设置头像
	self:SetName(data.NickName);				--	用户昵称
	self:SetSex(data.Sex);						--	用户性别(0:女，1:男)
	self:SetSign(data.Description);				--	签名
	self:SetTime(data.PostTime);				--	发布日期
	self:SetHeardNum(data.LikeNum);				--	红心值
	self:SetCommentsNum(data.CommentNum);		--	评论值
	self:SetChangeImg(data.Topic);				--	话题标签
	self:SetVideoCover(data.VideoCover);		--	加载视频图片
	self:IsLike(data.IsLike);					-- 	我是否点赞
end	

--	设置头像
function ADynamicTopicDetaiVideo:SetUserFace(face)
	if self.avatar then
		self.avatar:Del()
		self.avatar = nil
	end
	if face  ==  nil then return;end
	local _,_,w,h = self.m_thView:GetScaleRect(idsw.ID_CUS_ML_TX137_LM);
	gDef:AddGuiByID(self,idsw.ID_CUS_ML_TX137_LM,10,10,10,10);
	self.avatar = gDef:SetAvatarB(self.m_thView,idsw.ID_CUS_ML_TX137_LM,w,h,gDef.domain..face);
end

--	用户昵称
function ADynamicTopicDetaiVideo:SetName(name)
	if name ==  nil then return;end
	name = gDef:GetName(string.format("%s",name),5)
	self.m_nickName:SetString(name);
end

--	性别图标
function ADynamicTopicDetaiVideo:SetSex(index)
	if index ==  nil then return;end
	if index == 1 then
		self.m_Sex:SetTextureRect(1921,1712,43,43);
	elseif index == 0 then
		self.m_Sex:SetTextureRect(1966,1712,43,43);
	end
	local x,y = self.m_Sex:GetPos()
	local list = {self.m_nickName,self.m_Sex}
	gDef:Layout(list,233,y,5,1,44)
end

--	签名
function ADynamicTopicDetaiVideo:SetSign(sign)
	if sign ==  nil then return;end
	self.m_sign:SetString(sign);
end

--	发布日期
function ADynamicTopicDetaiVideo:SetTime(time)
	if time == nil then return;end
	time = os.date("%Y.%m.%d %H:%M",time);
	self.m_releaseTime:SetString(time);
end

--	红心值
function ADynamicTopicDetaiVideo:SetHeardNum(num)
	if num == nil then return;end
	self.m_redHeard:SetString(num);
	self.m_redHeard:SetColor(0xffCCCCCC);
	self.m_redHeard:SetVisible(true);
end

--	评论值
function ADynamicTopicDetaiVideo:SetCommentsNum(num)
	if num == nil then return;end
	self.m_comments:SetString(num);
end

--	切换话题标签
function ADynamicTopicDetaiVideo:SetChangeImg(str)
	if str == "#萌新来袭#" then						--	萌新
		self.m_TopicPhoto:SetTexture(gDef.GetResPath("ResAll/HuaTiZiYuanS1.png"));
	elseif str == "#我有超能力#" then				--	我有超能力
		self.m_TopicPhoto:SetTexture(gDef.GetResPath("ResAll/HuaTiZiYuanS2.png"));
	elseif str == "#给我一首歌的时间#" then		--	给我一首歌的时间
		self.m_TopicPhoto:SetTexture(gDef.GetResPath("ResAll/HuaTiZiYuanS3.png"));
	end	
end


--	设置视频
function ADynamicTopicDetaiVideo:SetVideoCover(VideoCover)
	if VideoCover == nil then return ;end
	local url = gDef.domain;
	local _,_,w,h = self.m_thView:GetScaleRect(idsw.ID_CUS_ML_MAIN3_LM);
	self.m_video = self:SetAvatar(self.m_thView,idsw.ID_CUS_ML_MAIN3_LM,w,h,url..VideoCover);
end

-- 我是否点赞
function ADynamicTopicDetaiVideo:IsLike(bool)
	if bool == nil then return;end
	self.m_redHeardImg:SetVisible(bool);
	if bool then
		self.m_redHeard:SetColor(0xffF775A6);
	else
		self.m_redHeard:SetColor(0xffCCCCCC);
	end
end

-- 设置最近定义缩放图片
-- @thview 
-- @id 	自定义层ID
-- @w 	头像宽度
-- @url 图片路径 
function ADynamicTopicDetaiVideo:SetAvatar(thview,id,w,h,url)
	local px,py,pw,ph = thview:GetScaleRect(id);
	local maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main3.png"),0,655,712,712);
	local maskSprW,maskSprH = maskSpr:GetWH()
	-- 缩放蒙板
	local maskScale = GetAdapterScale(maskSprW,maskSprH,w,h)
	maskSpr:SetScale(maskScale,maskScale)
	maskSpr:SetPos(px,py)

	local obj = {}
	
	obj.gui = kd.class(kd.GuiObjectNew,thview,1,px-w/2,py-h/2,w,h);
	obj.gui:setDebugMode(true)
	obj.gui:setMaskingClipping(maskSpr);
	thview:SetCustomRes(id,obj.gui);

	-- ============================
	-- 远程图片1
	-- ============================
	if url then
		
		obj.img =  kd.class(kd.AsyncSprite,url);
		obj.gui:addChild(obj.img)
		obj.img:SetPos(px,py)
		obj.img.OnLoadTextrue = function(this,err_code ,err_info)
			if obj.img == nil then return end
			if err_code == 0 then
				local _w,_h = this:GetTexWH();
				local scale = GetAdapterScale(_w,_h,w,h)
				this:SetScale(scale,scale)
			else
				obj.img = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main3.png"),0,655,712,712);
				obj.gui:addChild(obj.img)
				obj.img:SetPos(px,py)
				local scale = GetAdapterScale(199,199,w,h)
				obj.img:SetScale(scale,scale)
			end
		end
	else
		obj.img = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main3.png"),0,655,712,712);
		obj.gui:addChild(obj.img)
		obj.img:SetPos(px,py)
		local scale = GetAdapterScale(300,300,w,h)
		obj.img:SetScale(scale,scale)
	end
	obj.Del = function()
		thview:DelCustomRes(id, obj.gui);
		obj.img = nil
	end
	obj.SetRot = function(this,x)
		if x>=360 then x = 0 end
		obj.img:SetRotation(x)
	end
	obj.GetRot = function(this)
		return obj.img:GetRotation()
	end
	obj.SetVisible = function(this,bool)
		obj.gui:SetVisible(bool)
		obj.img:SetVisible(bool)
	end
	return obj;
end

--	模板高度
function ADynamicTopicDetaiVideo:GetWH()
	return ScreenW,1024;
end