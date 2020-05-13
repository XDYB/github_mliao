--[[

拉黑或举报

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

ActionPop = kd.inherit(kd.Layer);
local impl = ActionPop;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM                  = 1001,
	ID_IMG_ML_TONGYONGTC5_LM           = 1002,
	--/* Text ID */
	ID_TXT_NO0                         = 4001,
	ID_TXT_NO1                         = 4002,
	ID_TXT_NO2                         = 4003,
}

function impl:init()
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/TCJuBao2.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	-- 隐藏自带的蒙版
	self.m_thView:SetVisible(idsw.ID_IMG_ML_MAIN_LM, false);
	-- 添加大的GUI
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM,0,0,0,0);
	
	local _,_,w,h = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_TONGYONGTC5_LM);
	-- 举报
	gDef:AddGuiByID(self,idsw.ID_TXT_NO2,60,w/2,60,w/2);
	-- 拉黑
	gDef:AddGuiByID(self,idsw.ID_TXT_NO0,60,w/2,60,w/2);
	self.m_txtBack = self.m_thView:GetText(idsw.ID_TXT_NO0);
	local x,y = self.m_txtBack:GetPos();
	self.m_txtBack:SetPos(ScreenW/2,y);
	self.m_txtBack:SetWH(ScreenW/2, 50);
	self.m_txtBack:SetHAlignment(kd.TextHAlignment.CENTER);
	-- 取消
	gDef:AddGuiByID(self,idsw.ID_TXT_NO1,60,w/2,60,w/2);
	
	self.m_viewBackSelect = kd.class(BackSelect, false, true);
	self:addChild(self.m_viewBackSelect);
	self.m_viewBackSelect:init("ActionPop.Show");
	self.m_viewBackSelect:SetVisible(false);
	
	DC:RegisterCallBack("ActionPop.Show",self,function(bo)
		if bo then
			self:SetViewData();
			self.m_viewBackSelect:SetVisible(false);
		end
		self:SetVisible(bo);
	end)
	
	self.m_toUserid = 0;
	self.m_IsBlacklist = false;
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,0,ScreenH*2);
end

function impl:onGuiToucBackCall(id)
	-- 取消
	if id == idsw.ID_TXT_NO1 or id == idsw.ID_IMG_ML_MAIN_LM then
		echo("返回");
		self:SetVisible(false);
	-- 举报
	elseif id == idsw.ID_TXT_NO2 then
		echo("举报");
		self.m_viewBackSelect:SetVisible(true);
	-- 拉黑
	elseif id == idsw.ID_TXT_NO0 then
		echo("拉黑");
		self:hate();
	end
end

function impl:OnActionEnd()
	local bo = self:IsVisible();
	if not bo then
		DC:CallBack("DetaileView.ShowPop",false);
		self.m_toUserid = 0;
		self.m_IsBlacklist = false;
	end
end

function impl:SetViewData()
	local data = DC:GetData("DetaileView.data");
	self.m_IsBlacklist = data.IsBlacklist;
	if self.m_IsBlacklist then
		self.m_txtBack:SetString("取消拉黑");
	else
		self.m_txtBack:SetString("拉黑");
	end
	
	-- 记录userid
	self.m_toUserid = data.touserid;
	
	self.m_viewBackSelect:SetViewData(self.m_toUserid);
end

function impl:hate()
	local actionNum = 1
	if self.m_IsBlacklist then
		actionNum = 0;
	end
	gSink:Post("michat/hate",{touserid = self.m_toUserid, action = actionNum},function(data)
		if data.Result then
			
			self.m_IsBlacklist = not self.m_IsBlacklist;
			local str = "拉黑";
			local strMsg = "取消拉黑成功";
			local user = nil;
			local tData = DC:GetData("AHomeView.HateList");	
			if self.m_IsBlacklist then
				str = "取消拉黑";
				strMsg = "拉黑成功";
				self:updateHomePage(self.m_toUserid);
				user = {self.m_toUserid};
				tData.num = tData.num+1;
				
				DC:CallBack("FanListView.DelBlackItem",self.m_toUserid)
				DC:CallBack("FocusListView.DelBlackItem",self.m_toUserid)
				DC:CallBack("MyView.updateme")
			else
				if tData.num >1 then
					tData.num = tData.num-1;
				else
					tData.num = 0;
				end
				self:NoHomePage(self.m_toUserid);
				user = {self.m_toUserid};
			end
			tData[tostring(self.m_toUserid)] = user;	
			DC:FillData("AHomeView.HateList",tData);			--	黑名单
			local data = DC:GetData("DetaileView.data");
			data.IsBlacklist = self.m_IsBlacklist;
			DC:FillData("DetaileView.data", data);
			self.m_txtBack:SetString(str);
			gSink:messagebox_default(strMsg);
		else
			gSink:messagebox_default(data.ErrMsg);
		end
		self:SetVisible(false);
	end);
end

-- 拉黑更新主页数据
function impl:updateHomePage(userID)
	if userID ==  nil or userID == 0 then return ;end
	DC:CallBack("AHomePageView.updateUserBlock",userID);		--	更新首页
	DC:CallBack("ADynamicView.updateUserBlock",userID)			--	更新广场
end

-- 取消更新主页数据
function impl:NoHomePage(userID)
	if userID ==  nil or userID == 0 then return ;end
	DC:CallBack("AHomePageView.NoupdateUserBlock",userID);		--	更新首页
	DC:CallBack("ADynamicView.NoupdateUserBlock",userID)		--	更新广场
end