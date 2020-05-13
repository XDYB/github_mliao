--[[

咪一下--标签选择

--]]
c_Require("Script/MiLiao/MiYiXia/ML_LabelScroll.lua")
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local tweenPro = TweenPro;

SetMiLabel = kd.inherit(kd.Layer);
local impl = SetMiLabel;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw = {
	--/* Image ID */
	ID_IMG_ML_MIYIXIABIAOQIANTG_LM           = 1001,
	ID_IMG_ML_MAIN2_LM                       = 1002,
	ID_IMG_ML_MAIN3_LM                       = 1003,
	ID_IMG_ML_MAIN2_LM1                      = 1004,
	ID_IMG_ML_MAIN2_LM2                      = 1005,
	ID_IMG_ML_MAIN2_LM3                      = 1006,
	ID_IMG_ML_MAIN2_LM4                      = 1007,
	ID_IMG_ML_MAIN2_LM21                     = 1008,
	ID_IMG_ML_MAIN2_LM31                     = 1009,
	ID_IMG_ML_MAIN2_LM41                     = 1010,
	--/* Text ID */
	ID_TXT_NO0                               = 4001,
}

local toubu = {
	--/* Image ID */
	ID_IMG_ML_MAIN_LM3           = 1001,
	ID_IMG_ML_MAIN_LM4           = 1002,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
}

function impl:init()
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/MYXBiaoQianShuXing.UI"), self);
	self:addChild(self.m_thView);
	
	
	-- 隐藏部分
	self.m_thView:SetVisible(idsw.ID_IMG_ML_MAIN2_LM2, false);
	self.m_thView:SetVisible(idsw.ID_IMG_ML_MAIN2_LM3, false);
	self.m_thView:SetVisible(idsw.ID_IMG_ML_MAIN2_LM4, false);
	self.m_thView:SetVisible(idsw.ID_IMG_ML_MAIN2_LM21, false);
	self.m_thView:SetVisible(idsw.ID_IMG_ML_MAIN2_LM31, false);
	self.m_thView:SetVisible(idsw.ID_IMG_ML_MAIN2_LM41, false);
	
	-- 记录选中的标签
	self.m_tabLabel = {};
	self.m_mapLabel = {};
	
	-- 设置点击（快去咪一下）
	local spr = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN3_LM);
	spr:SetTextureRect(0, 1402, 756, 112);
	local gui = gDef:AddGuiByID(self, idsw.ID_IMG_ML_MAIN3_LM, 0,0,0,0);
	gui.gui:SetZOrder(10);
	
	DC:RegisterCallBack("SetMiLabel.SetTabLabel",self,function (item)
		local name = item:GetLabelName();
		local index = self.m_mapLabel[name];
		if index then
			-- 更新map索引
			if index <= #self.m_tabLabel then
				for i=index,#self.m_tabLabel do
					local obj = self.m_tabLabel[i];
					local objName = obj:GetLabelName();
					if i==index then
						self.m_mapLabel[objName] = nil;
						obj:initView();
					else
						self.m_mapLabel[objName] = i-1
					end
				end
			end
			-- 删除
			if #self.m_tabLabel >= index  then
				table.remove(self.m_tabLabel, index);
			end
		else
			if #self.m_tabLabel == 5 then
				-- 更新map索引
				for i=1,#self.m_tabLabel do
					local obj = self.m_tabLabel[i];
					local objName = obj:GetLabelName();
					if i==1 then
						self.m_mapLabel[objName] = nil;
						obj:initView();
					else
						self.m_mapLabel[objName] = i-1
					end
				end
				-- 删除
				if #self.m_tabLabel >= 1  then
					table.remove(self.m_tabLabel, 1);
				end
				
			end
			table.insert(self.m_tabLabel, item);
			self.m_mapLabel[name] = #self.m_tabLabel;
		end
		
		echo("------------------ tab ----------------");
		for k,v in pairs(self.m_tabLabel) do
			echo("k = "..k.."; v = "..v.m_data.Text);
		end
		echo("------------------ map ----------------");
		for k,v in pairs(self.m_mapLabel) do
			echo("k = "..k.."; v = "..v);
		end
		
	end)
	
	DC:RegisterCallBack("SetMiLabel.Show",self,function(bo)
		if bo then
			local mytags = gSink:GetMyTags();
			if mytags then
				self.m_dataMytags = mytags;
				self:SetVisible(true);
			else
				self:get_mytags();
			end
		else
			self:SetVisible(bo);
		end
	end)
	DC:RegisterCallBack("SetMiLabel.get_matchuser",self,function()
		self:get_matchuser();
	end)
	
	self:initView();
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end

function impl:initView()
	for i=1,#self.m_tabLabel do
		self.m_tabLabel[i]:initView();
	end
	self.m_tabLabel = {};
	self.m_mapLabel = {};
end

function impl:onGuiToucBackCall(id)
	if id == idsw.ID_IMG_ML_MAIN3_LM then
		echo("确定");
		if #self.m_tabLabel > 0 then
			-- 设置自己的标签
			self:set_mytags();
		else
			gSink:messagebox_default("请先选择一个标签哦");
		end
	elseif id == toubu.ID_IMG_ML_MAIN_LM4 then
		self:SetVisible(false);
	end
end

-- 发 设置我的标签 包
function impl:set_mytags()
	local tagslist = {}
	for i=1,#self.m_tabLabel do
		local id = self.m_tabLabel[i]:GetId();
		table.insert(tagslist, id);
	end
	local sendData ={tagslist = tagslist};
	gSink:Post("michat/set-mytags",sendData,function(data)
		if data.Result then
			self:SetVisible(false);
			gSink:SetMyTags(tagslist);
			gSink:messagebox_default("设置成功");
			DC:CallBack("MyTagHelp.Show", false);
		else
			gSink:messagebox_default(data.ErrMsg);
		end
	end);
end

-- 设置标签
function impl:SetDefaultLable(data)
	local tabTag_1 = {};
	local tabTag_2 = {};
	for i=1,#data do
		if data[i].Type == 0 then
			table.insert(tabTag_1, data[i]);
		elseif data[i].Type == 1 then
			table.insert(tabTag_2, data[i]);
		end
	end
	-- 个性特质
	local spr = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM);
	local x,y = spr:GetPos();
	local w,h = spr:GetWH();
	self.m_Label_1 = kd.class(ML_LabelScroll, false, false);
	self.m_Label_1:init(y+h/2+66, tabTag_1);
	self:addChild(self.m_Label_1);
	
	-- 生活成诗
	local spr = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM1);
	local x,y = spr:GetPos();
	local w,h = spr:GetWH();
	self.m_Label_2 = kd.class(ML_LabelScroll, false, false);
	self.m_Label_2:init(y+h/2+66, tabTag_2);
	self:addChild(self.m_Label_2);
end

function impl:OnActionEnd()
	local bo = self:IsVisible();
	DC:FillData("SetMiLabel.IsVisible",bo);
	if bo then
		local dataTag = gDef.TagsList;
		if dataTag and self.m_Label_1 == nil then
			self:SetDefaultLable(dataTag);
		end
		local dataMytags = self.m_dataMytags;
		if #dataMytags > 0 then
			self.m_Label_1:SetSelectOn(dataMytags);
			self.m_Label_2:SetSelectOn(dataMytags);
		end
	else
		self:initView();
	end
end

-- 获取我的标签
function impl:get_mytags()
	gSink:Post("michat/get-mytags",{},function(data)
		if data.Result then
			gSink:SetMyTags(data.TagsList);
			self.m_dataMytags = data.TagsList;
			self:SetVisible(true);
		else
			gSink:messagebox_default(data.ErrMsg);
		end
	end);
end

