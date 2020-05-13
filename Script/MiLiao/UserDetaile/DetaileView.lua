--[[

详情界面

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

DetaileView = kd.inherit(kd.Layer);
local impl = DetaileView;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

c_Require("Script/MiLiao/UserDetaile/ActionPop.lua")
c_Require("Script/MiLiao/UserDetaile/BackSelect.lua")
c_Require("Script/MiLiao/UserDetaile/InfoItem.lua")
c_Require("Script/MiLiao/UserDetaile/InfoView.lua")
c_Require("Script/MiLiao/UserDetaile/DynamicItem.lua")
c_Require("Script/MiLiao/UserDetaile/DynamicView.lua")
c_Require("Script/MiLiao/UserDetaile/ActionMenu.lua")
c_Require("Script/MiLiao/UserDetaile/NoHaveData.lua")

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM            = 1001,
	ID_IMG_ML_MAIN_LM1           = 1002,
	ID_IMG_ML_MAIN_LM2           = 1003,
	ID_IMG_ML_MAIN_LM3           = 1004,
	ID_IMG_ML_MAIN_LM4           = 1005,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
	ID_TXT_NO1                   = 4002,
	ID_TXT_NO2                   = 4003,
	ID_TXT_NO3                   = 4004,
	ID_TXT_NO4                   = 4005,
	ID_TXT_NO5                   = 4006,
	ID_TXT_NO6                   = 4007,
	ID_TXT_NO7                   = 4008,
	ID_TXT_NO8                   = 4009,
	--/* Custom ID */
	ID_CUS_ML_TX263_LM           = 6001,
}

function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/XQZiLiao.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	-- 获取头像
	self.m_cusFace = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_TX263_LM,nil,false,2)
	
	-- 获取昵称
	self.m_txtName = self.m_thView:GetText(idsw.ID_TXT_NO0);
	self.m_txtName:SetHAlignment(kd.TextHAlignment.LEFT);
	local str = self.m_txtName:GetString();
	local numLen = gDef:GetTextLen(58, str);	-- 获取原始UI上面的文字长度
	local x,y = self.m_txtName:GetPos();
	self.m_initX = x - numLen/2;
	
	-- 获取标识
	self.m_sprTco = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM2);
	
	-- 获取身份
	self.m_txtProfession = self.m_thView:GetText(idsw.ID_TXT_NO1);
	self.m_txtProfession:SetHAlignment(kd.TextHAlignment.LEFT);
	
	-- 获取个性签名
	self.m_txtTopic = self.m_thView:GetText(idsw.ID_TXT_NO2);
	self.m_txtTopic:SetHAlignment(kd.TextHAlignment.LEFT);
	
	-- 粉丝数量
	self.m_txtFans = self:SetInitInfo(idsw.ID_TXT_NO3, idsw.ID_TXT_NO6);
	
	-- 图片数量
	self.m_txtPhoto = self:SetInitInfo(idsw.ID_TXT_NO4, idsw.ID_TXT_NO7);
	
	-- 动态数量
	self.m_txtDynamic = self:SetInitInfo(idsw.ID_TXT_NO5, idsw.ID_TXT_NO8);
	
	------------------------------- view -------------------------------
	local _,y = self.m_txtFans:GetPos();
	local height = y + 165;
	local spr = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM4);
	local x,_ = spr:GetPos();
	local _,_,w,_ = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN_LM4);
	x = x - w/2;
	
	-- 空空如也
	self.m_NoHaveData = kd.class(NoHaveData, false, false);
	self.m_NoHaveData:init(height, x);
	self:addChild(self.m_NoHaveData);
	
	-- 信息
	self.m_viewInfo = kd.class(InfoView, false, false);
	self.m_viewInfo:init(height, x);
	self:addChild(self.m_viewInfo);
	
	-- 相册
	self.m_viewDynamic = kd.class(DynamicView, false, false);
	self.m_viewDynamic:init(y + 461, x);
	self:addChild(self.m_viewDynamic);
	
	-- 设置返回事件
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM1,40,90,40,40);
	-- 更多
	self.m_objMore =gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM3,30,40,30,90);
	
	-- 功能选项
	self.m_viewActionMenu = kd.class(ActionMenu, false, false);
	self.m_viewActionMenu:init();
	self:addChild(self.m_viewActionMenu);
	
	-- 蒙版
	self.m_viewMask = kd.class(MaskUI, false, true);
	self.m_viewMask:init();
	self:addChild(self.m_viewMask);
	self.m_viewMask:SetVisible(false);
	
	-- 举报
	self.m_viewActionPop = kd.class(ActionPop, false, true);
	self:addChild(self.m_viewActionPop);
	self.m_viewActionPop:init();
	self.m_viewActionPop:SetVisible(false);
	
	DC:RegisterCallBack("DetaileView.Show",self,function(bo)
		self:SetVisible(bo);
	end)
	
	DC:RegisterCallBack("DetaileView.ShowPop",self,function(bo)
		self.m_viewMask:SetVisible(bo);
	end)
	
	DC:RegisterCallBack("DetaileView.report",self,function()
		self:report();
	end)
	
	
	
	DC:RegisterCallBack("DetaileView.GetDetailData",self,function (id)
		self:GetDetailData(id);
	end);
	
	-- 更新关注数量
	DC:RegisterCallBack("DetaileView.UpdateFansNum",self,function (num)
		local fansNum = self.m_txtFans:GetString();
		fansNum = fansNum + num;
		self.m_txtFans:SetString(fansNum);
	end);

	self:initView();
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

-- 初始化界面
function impl:initView()
	-- 设置默认头像
	self.m_cusFace:SetFace();
	-- 昵称
	self.m_txtName:SetString("-----------");
	-- 标识
	self.m_sprTco:SetVisible(false);
	-- 身份
	self.m_txtProfession:SetString("-----");
	-- 个性签名
	self.m_txtTopic:SetString("-----");
	-- 粉丝数
	self.m_txtFans:SetString("-----");
	-- 照片数
	self.m_txtPhoto:SetString("-----");
	-- 动态数
	self.m_txtDynamic:SetString("-----");
	-- 隐藏“更多”
	self.m_objMore:SetVisible(false);
	-- 隐藏“+”
	self.m_viewActionMenu:SetVisible(false);
	self.m_viewActionMenu:initView();
	
	-- 隐藏标签信息
	self.m_viewInfo:SetVisible(false);
	self.m_viewInfo:initView()
	
	-- 隐藏动态信息
	self.m_viewDynamic:SetVisible(false);
	self.m_viewDynamic:initView()
	
	self.m_viewDynamic:initView();
	
	self.m_NoHaveData:SetVisible(true);
end

function impl:onGuiToucBackCall(id)
	-- 返回
	if id == idsw.ID_IMG_ML_MAIN_LM1 then
		echo("返回");
		self:SetVisible(false);
	-- 更多
	elseif id == idsw.ID_IMG_ML_MAIN_LM3 then
		echo("举报或拉黑");
		DC:CallBack("DetaileView.ShowPop",true);
		DC:CallBack("ActionPop.Show",true);
	end
end

-- 设置粉丝数、照片数、动态数
-- @id1 数量ID
-- @id2 名称ID
-- 返回 数量的文本
function impl:SetInitInfo(id1,id2)
	local objTxt = self.m_thView:GetText(id1);
	objTxt:SetHAlignment(kd.TextHAlignment.CENTER);
	local obj = self.m_thView:GetText(id2);
	obj:SetHAlignment(kd.TextHAlignment.CENTER);
	local x,y = obj:GetPos();
	local _,y = objTxt:GetPos();
	objTxt:SetPos(x,y);
	
	return objTxt;
end

-- 设置昵称
-- @str 昵称
-- @bo 	是否显示实名认证
function impl:SetName(str,bo)
	str = gDef:GetName(string.format("%s",str),7)
	self.m_txtName:SetString(str);
	if bo then
		local numLen = gDef:GetTextLen(58, str);
		local _,y = self.m_sprTco:GetPos();
		local x = self.m_initX + numLen + 10;
		self.m_sprTco:SetPos(x, y);
	end
	self.m_sprTco:SetVisible(bo);
end

-- 获取详情
function impl:GetDetailData(sendId)
	local myId =  gSink.m_User.userId;
	local sendData = {touserid = sendId};
	-- 判断是否是我自己
	if sendId == nil or myId == sendId then
		gSink:Post("michat/get-mydetail",{},function(data)
			if data.Result then
				data["isMe"] = true;
				DC:FillData("DetaileView.data", data);
				self:SetVisible(true);
			else
				gSink:messagebox_default(data.ErrMsg);
			end
		end);
	else
		gSink:Post("michat/get-userdetail",sendData,function(data)
			if data.Result then
				data["touserid"] = sendId;
				data["isMe"] = false;
				DC:FillData("DetaileView.data", data);
				self:SetVisible(true);
			else
				gSink:messagebox_default(data.ErrMsg);
			end
		end);
	end
end

function impl:OnActionEnd()
	local bo = self:IsVisible();
	if bo then
		self:SetViewData();
	else
		if gSink.PlayView:IsVisible() then
			DC:CallBack("PlayView.IsPause",false);
		end
		self:initView();
		DC:FillData("DetaileView.data", nil);
	end
end

-- 设置用户数据
function impl:SetViewData()
	local data = DC:GetData("DetaileView.data");
	if data and data.Nickname then
		-- 设置昵称/实名
		self:SetName(data.Nickname, data.Certification == 1);
		-- 设置头像
		self.m_cusFace:SetFace(gDef.domain..data.AvatarFile);
		-- 设置个人介绍
		local Introduce = string.len(data.Introduce) > 0 and data.Introduce or "我是个秘密...";
		self.m_txtProfession:SetString(Introduce);
		-- 设置个性签名
		local Signature = string.len(data.Signature) > 0 and data.Signature or "萌新一枚，刚开咪聊，来找我聊天";
		self.m_txtTopic:SetString(Signature);
		-- 设置粉丝数、照片数、动态数量 
		self.m_txtFans:SetString(data.FansNum);
		self.m_txtPhoto:SetString(data.PhotoNum);
		self.m_txtDynamic:SetString(data.DynamicNum);

		local bo = data.Age > 0;
		if bo then
			-- 设置标签
			self.m_viewInfo:SetViewData(data);
			-- 设置动态
			self.m_viewDynamic:SetViewData(data);
		end
		self.m_viewInfo:SetVisible(bo)
		self.m_viewDynamic:SetVisible(bo);
		self.m_NoHaveData:SetVisible(not bo);
		
		-- 是否是自己
		self.m_viewActionMenu:SetVisible(not data.isMe);
		self.m_objMore:SetVisible(not data.isMe);
		
		if not data.isMe then
			-- 设置拉黑的提示
			self.m_viewActionPop:SetViewData(data);
			self.m_viewActionMenu:SetViewData();
		end
	end
end

-- 举报
function impl:report()
	local data = DC:GetData("DetaileView.data");
	gSink:Post("michat/report",{touserid = data.touserid},function(data)
		if data.Result then
			gSink:messagebox_default("举报成功");
		else
			gSink:messagebox_default(data.ErrMsg);
		end
	end);
end