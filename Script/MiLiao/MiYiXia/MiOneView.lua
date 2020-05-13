--[[

咪一下 -- 选择（小姐姐、小哥哥、我不挑）

--]]
c_Require("Script/MiLiao/MiYiXia/Mi_MainLabel.lua")
c_Require("Script/MiLiao/MiYiXia/Mi_ChangeLabel.lua")
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

MiOneView = kd.inherit(kd.Layer);
local impl = MiOneView;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM                = 1001,
	ID_IMG_ML_MIYIXIATG_LM           = 1002,
	ID_IMG_ML_MAIN2_LM               = 1003,
	ID_IMG_ML_MAIN3_LM               = 1004,
	ID_IMG_ML_MAIN2_LM1              = 1005,
	ID_IMG_ML_MAIN2_LM2              = 1006,
	ID_IMG_ML_MAIN3_LM1              = 1007,
	ID_IMG_ML_MAIN3_LM2              = 1008,
	ID_IMG_ML_MAIN3_LM3              = 1009,
	ID_IMG_ML_MAIN3_LM4              = 1010,
	ID_IMG_ML_MAIN3_LM5              = 1011,
	--/* Button ID */
	ID_BTN_ML_MAIN2_LM               = 3001,
	--/* Text ID */
	ID_TXT_NO0                       = 4001,
}

local sprOpenReac = {
	{1680, 1799, 136, 69},	-- 关闭
	{1243, 1708, 136, 69},	-- 开启
}

function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/MYXShaiXuanTC.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	-- 设置蒙版点击区域
	self:SetMaskClick();
	
	-- 小姐姐
	self.m_objWoman = self:GetSprObj(idsw.ID_IMG_ML_MAIN3_LM1, idsw.ID_IMG_ML_MAIN3_LM);
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM1,20,20,20,20);
	
	-- 小哥哥
	self.m_objMan = self:GetSprObj(idsw.ID_IMG_ML_MAIN3_LM2, idsw.ID_IMG_ML_MAIN3_LM3);
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM2,20,20,20,20);
	
	-- 我不挑
	self.m_objOther = self:GetSprObj(idsw.ID_IMG_ML_MAIN3_LM4, idsw.ID_IMG_ML_MAIN3_LM5);
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM4,20,20,20,20);
	
	-- 开关
	self.m_objOpen = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN2_LM2,20,20,20,20);
	
	-- 按钮
	local btn = self.m_thView:GetButton(idsw.ID_BTN_ML_MAIN2_LM);
	btn:SetTitle("确定",42, 0xffffffff);
	
	-------------------------------- View Start --------------------------------
	self.m_MI_ChangeLabel = kd.class(MI_ChangeLabel,false,true);
	self.m_MI_ChangeLabel:init();
	self:addChild(self.m_MI_ChangeLabel);
	self.m_MI_ChangeLabel:SetVisible(false);
	local x, y = self.m_MI_ChangeLabel:GetPos();
	self.m_MI_ChangeLabel:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x, y+ScreenH);
	self.m_MI_ChangeLabel:SetVisible(false);

	
	--------------------------------- View End ---------------------------------
	
	self:initView();
	
	DC:RegisterCallBack("MiOneView.Show",self,function(bo)
		gSink:ShowMi(true);
		if bo then
			-- 发包
			gSink:Post("michat/get-matchsetup",{},function(data)
				if data.Result then
					self:SetViewData(data);
					gSink:ShowMask(true);
					self:SetVisible(true);
				else
					
				end
			end);
		else
			self:SetVisible(not bo);
		end
	end)
	
	self.m_tabViewData = {};
	
	DC:RegisterCallBack("MiOneView.NoHave",self,function()
		kd.Node.SetVisible(self.m_thView, false);
	end)
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,0,ScreenH*2);
end

-- 获取标签对象
function impl:GetSprObj(onId, offId)
	local sprOn = self.m_thView:GetSprite(onId);
	local sprOff = self.m_thView:GetSprite(offId);
	local obj = {sprOn = sprOn, sprOff = sprOff};
	obj.SetOn = function (this, bo)
		this.sprOn:SetVisible(bo);
		this.sprOff:SetVisible(not bo);
	end
	return obj;
end

function impl:initView()
	-- 设置标签
	self:SelectLable(3);
	-- 设置开关
	self:ChangeStatusOpen(2);
	
	kd.Node.SetVisible(self.m_thView, true);
end

function impl:onGuiToucBackCall(id)
	if id == idsw.ID_IMG_ML_MAIN2_LM2 then
		local num = self.m_numOpen == 1 and 2 or 1;
		self:ChangeStatusOpen(num);
		echo("打开/关闭 被撩");
	elseif id == idsw.ID_IMG_ML_MAIN3_LM1 then
		echo("小姐姐");
		self:SelectLable(0);
	elseif id == idsw.ID_IMG_ML_MAIN3_LM2 then
		echo("小哥哥");
		self:SelectLable(1);
	elseif id == idsw.ID_IMG_ML_MAIN3_LM4 then
		echo("我不挑");
		self:SelectLable(-1);
	elseif id == idsw.ID_BTN_ML_MAIN2_LM then
		echo("确定");
		-- 是否修改过数据
		self:CheckData();
	elseif id == 100 then
		echo("关闭界面");
		self:SetVisible(false);
	end
end

-- 切换开关的状态
--@num 1:开启 2:关闭
function impl:ChangeStatusOpen(num)
	self.m_numOpen = num;
	self.m_objOpen.spr:SetTextureRect(sprOpenReac[num][1], sprOpenReac[num][2], sprOpenReac[num][3], sprOpenReac[num][4] );
end

-- 选择标签
function impl:SelectLable(numType)
	self.m_objWoman:SetOn(numType == 0);
	self.m_objMan:SetOn(numType == 1);
	self.m_objOther:SetOn(numType == -1);
	self.m_numType = numType;
end

function impl:SetViewData(data)
	-- 设置性别
	dump(data);
	self:SelectLable(data.MatchSex);
	
	-- 设置开关
	self:ChangeStatusOpen(data.MatchOpen + 1);
	
	self.m_tabViewData = data;
end

function impl:OnActionEnd()
	if not self:IsVisible() then
		gSink:ShowMask(false);
		--gSink:ShowMi(false);
	end
end

-- 设置蒙版点击区域
function impl:SetMaskClick()
	local spr =self.m_thView:GetSprite(idsw.ID_IMG_ML_MIYIXIATG_LM);
	local x,y = spr:GetPos();
	local w,h = spr:GetWH();
	local gui = kd.class(kd.GuiObjectNew, self, 100, 0,0,ScreenW,y-h/2, false, true);
	self:addChild(gui);
	gui:setDebugMode(true);
end

-- 检查数据是否修改，如果修改发送修改的数据
function impl:CheckData()
	-- 检查性别是否修改
	local bo = self.m_numType == self.m_tabViewData.MatchSex;
	-- 检查开关是否改变
	local num = self.m_numOpen - 1;
	local bo2 = num == self.m_tabViewData.MatchOpen;
	-- 如果改变发送改变值
	if bo and bo2 then
		self:SetVisible(false);
	else
		local Data = {sex = self.m_numType, open = num}
		gSink:Post("michat/set-matchsetup",Data,function(data)
			if data.Result then
				self:SetVisible(false);
			else
				gSink:messagebox_default(data.ErrMsg);
			end
		end);
	end
end





