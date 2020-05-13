local kd = KDGame;
local gDef = gDef;
local ScreenW = KDGame.SceneSize.width;
local ScreenH = KDGame.SceneSize.high;

MsgBox = kd.inherit(kd.Layer);--主界面
local impl = MsgBox
local ids = {
	--/* Image ID */
	ID_IMG_ML_MAIN_LM                 = 1001,
	ID_IMG_ML_TONGYONGTC_LM           = 1002,
	--/* Text ID */
	ID_TXT_NO0                        = 4001,
	ID_TXT_NO1                        = 4002,
	ID_TXT_NO2                        = 4003,
	ID_TXT_NO3                        = 4004,
	ID_TXT_NO4                        = 4005,
}
function impl:init()	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/TCTongYong.UI"), self);
	self:addChild(self.m_thView);
	-- 标题
	self.txtLine1 = self.m_thView:GetText(ids.ID_TXT_NO0)
	self.txtLine1:SetVisible(false)
	local _,y = self.txtLine1:GetPos()
	self.txtLine1:SetPos(ScreenW/2,y-50)
	self.txtLine1:SetHAlignment(kd.TextHAlignment.CENTER)
	
	-- 内容
	self.txtLine2 = self.m_thView:GetText(ids.ID_TXT_NO1)
	self.txtLine2:SetVisible(false)
	local _,y = self.txtLine2:GetPos()
	self.txtLine2:SetPos(ScreenW/2,y)
	self.txtLine2:SetHAlignment(kd.TextHAlignment.CENTER)
	--		设置内容的宽高
	local str = self.txtLine2:GetString();
	self.m_numTxtWidth = gDef:GetTextLen(40, str);	-- 获取原始UI上面的文字长度
	self.txtLine2:SetWH(self.m_numTxtWidth, 150);
	
	self.txtLine3 = self.m_thView:GetText(ids.ID_TXT_NO2)
	self.txtLine3:SetVisible(false)
	local _,y = self.txtLine3:GetPos()
	self.txtLine3:SetPos(ScreenW/2,y)
	self.txtLine3:SetHAlignment(kd.TextHAlignment.CENTER)
	--		设置内容的宽高
	local str = self.txtLine3:GetString();
	self.txtLine3:SetWH(self.m_numTxtWidth, 150);
	
	self.txts = {self.txtLine1,self.txtLine2,self.txtLine3}
	-- 记录三条文本的初始坐标
	self.m_tabPos = {};
	for i=1,#self.txts do
		local obj = self.txts[i];
		local x,y = obj:GetPos();
		table.insert(self.m_tabPos, {x,y});
	end
	
	-- 设置“取消”
	self.m_txtNo = self:SetTxtGui("取消",ids.ID_TXT_NO3,true);

	-- 设置“确定”
	self.m_txtOk = self:SetTxtGui("确定",ids.ID_TXT_NO4,false);

	self.leftFn = nil
	self.rightFn = nil
end

function impl:onGuiToucBackCall(id)
	if id == ids.ID_TXT_NO3 then
		self.leftFn()
	elseif id == ids.ID_TXT_NO4 then
		self.rightFn()
	end
	self:SetVisible(false)
end

function impl:SetTxtGui(str,id,isLeft)
	local txt = self.m_thView:GetText(id);
	txt:SetString(str);
	local _,_,w,_ = self.m_thView:GetScaleRect(ids.ID_IMG_ML_TONGYONGTC_LM);
	txt:SetHAlignment(kd.TextHAlignment.CENTER)
	local gui = gDef:AddGuiByID(self, id, 70, w/4, 70, w/4);
	local bg = self.m_thView:GetSprite(ids.ID_IMG_ML_TONGYONGTC_LM);
	local px,py = bg:GetPos();
	if isLeft then
		px = px - w/4;
	else
		px = px + w/4;
	end
	local _,y = txt:GetPos();
	txt:SetPos(px,y);
	txt.gui = gui;
	txt.SetVisible = function (this,bo)
		kd.Node.SetVisible(txt, bo);
		gui:SetVisible(bo);
	end
	return txt;
end

--[[
gSink:messagebox({
	txt = {"第1行文字","第2️行文字","第2️行文字"},
	btn = {"否","是"},				-- 按钮
	fn = {
		function() end, 			-- [可选]
		function() end
	},
});
--]]
function impl:Show(options)
	for i=1,#self.txts do
		self.txts[i]:SetVisible(false)
	end
	-- 计算位置
	local num = #options.txt;
	local dx = 0;
	if num and num == 1 then
		dx = 80;
	elseif num and num == 2 then
		dx = 60
	elseif num and num == 2 then
		dx = 30
	end
	if num then
		for i=1,num do
			self.txts[i]:SetPos(self.m_tabPos[i][1],self.m_tabPos[i][2]+dx);
		end
	end
	-- 显示
	for i,v in ipairs(options.txt) do
		self.txts[i]:SetString(v)
		self.txts[i]:SetVisible(true)
	end
	
	if options.btn then
		self.m_txtNo:SetString(options.btn[1]);
		self.m_txtOk:SetString(options.btn[2]);
	else
		self.m_txtNo:SetString("取消");
		self.m_txtOk:SetString("确定");
	end
	
	if #options.fn==1 then
		self.leftFn = function() end
		self.rightFn = options.fn[1]
	else
		self.leftFn = options.fn[1]
		self.rightFn = options.fn[2]
	end
	
	self:SetVisible(true)
end

