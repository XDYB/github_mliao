--[[

咪一下 -- 标签设置

--]]
c_Require("Script/MiLiao/MiYiXia/MiBg.lua")
c_Require("Script/MiLiao/MiYiXia/MiSelectLabel.lua")
c_Require("Script/MiLiao/MiYiXia/Mi_Matching.lua")
c_Require("Script/MiLiao/MiYiXia/Mi_MatchingSucc.lua")
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

Mi_MainLabel = kd.inherit(kd.Layer);
local impl = Mi_MainLabel;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local toubu = {
	--/* Image ID */
	ID_IMG_ML_MAIN_LM3           = 1001,
	ID_IMG_ML_MAIN_LM4           = 1002,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
}

function impl:init()
	-- 添加背景
	self.MiBg = kd.class(MiBg,false,true);
	self.MiBg:init();
	self:addChild(self.MiBg);
	
	-- 添加头部
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/TYTouBu.UI"), self);
	self:addChild(self.m_thView);
	self.m_thView:SetVisible(toubu.ID_IMG_ML_MAIN_LM3, false);
	local spr = self.m_thView:GetSprite(toubu.ID_IMG_ML_MAIN_LM4);
	spr:SetTextureRect(1889, 498, 60, 60);
	self.m_txtTitle = self.m_thView:GetText(toubu.ID_TXT_NO0);
	self.m_txtTitle:SetString("咪一下");
	self.m_txtTitle:SetHAlignment(kd.TextHAlignment.CENTER);
	self.m_txtTitle:SetColor(0xffffffff);
	
	-- 添加标签选择
	self.m_MiSelectLabel = kd.class(MiSelectLabel, false, true);
	self.m_MiSelectLabel:init();
	self:addChild(self.m_MiSelectLabel);
	self.m_MiSelectLabel:SetVisible(false);
	self:SetAction(self.m_MiSelectLabel, 0, ScreenH);
	
	-- 匹配
	self.m_Mi_Matching = kd.class(Mi_Matching, false, false);
	self.m_Mi_Matching:init();
	self:addChild(self.m_Mi_Matching);
	self.m_Mi_Matching:SetVisible(false);

	-- 匹配成功
	self.m_Mi_MatchingSucc = kd.class(Mi_MatchingSucc, false, false);
	self.m_Mi_MatchingSucc:init();
	self:addChild(self.m_Mi_MatchingSucc);
	self.m_Mi_MatchingSucc:SetVisible(false);
	
	DC:RegisterCallBack("Mi_MainLabel.Show",self,function(bo)
		if bo then
			gSink:ShowMi(true);
			local mytags = gSink:GetMyTags();
			if mytags then
				self:StartMi(mytags);
			else
				self:get_mytags();
			end
		end
		self:SetVisible(bo);
	end)
	
	DC:RegisterCallBack("Mi_MainLabel.m_boIsBack",self,function(bo)
		self.m_boIsBack = bo;
	end)
	
	DC:RegisterCallBack("Mi_MainLabel.ShowTitle",self,function(bo)
		self.m_txtTitle:SetVisible(bo);
	end)
	
	DC:RegisterCallBack("Mi_MainLabel.ClickBack",self,function(bo)
		self.m_obj.gui:SetEnable(bo);
	end)
	
	-- 返回
	self.m_obj = gDef:AddGuiByID(self,toubu.ID_IMG_ML_MAIN_LM4,40,80,40,40);
	self.m_boIsBack = false;
	
	self:initView();
	
end


function impl:initView()
	self.m_dataMytags = {};
	DC:CallBack("MiSelectLabel.Show",false);
	self.m_boIsOpen = false
	DC:FillData("Mi_MainLabel.dataMytags", nil);
	self.m_boIsBack = false;
	DC:FillData("Mi_MainLabel.IsChange", nil);
	self.m_obj.gui:SetEnable(true);
	self.m_Mi_MatchingSucc:SetVisible(false);
end

function impl:onGuiToucBackCall(id)
	if id == toubu.ID_IMG_ML_MAIN_LM4 then
		DC:CallBack("Mi_MainLabel.Show",false);
		self.m_boIsBack = true;
	end
end

function impl:OnActionEnd()
	local bo = self:IsVisible();
	DC:CallBack("MiBg.StartPlay",bo);
	self.m_boIsOpen = bo;
	if bo then
		DC:CallBack("MI_ChangeLabel.Show",false);
		kd.SetSysStateBarStyle(1);
	else
		if self.m_boIsBack then
			DC:CallBack("MiBg.StartPlay",false);
--			gSink:ShowMi(false);
		end
		self:initView();
		kd.SetSysStateBarStyle(0);
	end
end

-- 获取我的标签
function impl:get_mytags()
	gSink:Post("michat/get-mytags",{},function(data)
		if data.Result then
			gSink:SetMyTags(data.TagsList);
			self:StartMi(data.TagsList);
		else
			gSink:messagebox_default(data.ErrMsg);
		end
	end);
end

function impl:SetAction(obj,dx,dy)
	local x, y = obj:GetPos();
	obj:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x + dx, y+dy);
	obj:SetVisible(false);
end

-- 获取标签列表
function impl:get_tagslist()
	local dataTag = DC:GetData("MiSelectLabel.dataTag");
	if dataTag then
		DC:CallBack("MiSelectLabel.Show", true);
	else
		DC:FillData("MiSelectLabel.dataTag", gDef.TagsList);
		DC:CallBack("MiSelectLabel.Show", true);
	end
end

function impl:StartMi(data)
	self.m_dataMytags = data;
	if #self.m_dataMytags ~= 0 then
		DC:FillData("Mi_MainLabel.dataMytags", self.m_dataMytags);
	end
	
	-- 有标签
	if #self.m_dataMytags  > 0 then
		local isChange = DC:GetData("MI_ChangeLabel.IsChange");
		if isChange then
			self.m_txtTitle:SetVisible(false);
			-- 获取标签列表
			self:get_tagslist();
		else
			echo("开始匹配");
			self.m_txtTitle:SetVisible(true);
			DC:CallBack("MiSelectLabel.get_matchuser");
		end
		DC:FillData("MI_ChangeLabel.IsChange", false);
		DC:FillData("Mi_MainLabel.IsChange", true);
	-- 无标签
	else
		self.m_txtTitle:SetVisible(false);
		echo("设置标签");
		-- 获取标签列表
		self:get_tagslist();
	end
end
