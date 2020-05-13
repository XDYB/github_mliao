--[[

	评论主页

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

Comments = kd.inherit(kd.Layer);
local impl = Comments;

local APath = "MiLiao";
c_Require("Script/"..APath.."/Comment/CommentEdit.lua")
c_Require("Script/"..APath.."/Comment/CommentItem.lua")
c_Require("Script/"..APath.."/Comment/CommentScroll.lua")

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_PingLunTC_LM           = 1001,
	ID_IMG_ML_MAIN_LM                = 1002,
	--/* Text ID */
	ID_TXT_NO0                       = 4001,
	ID_TXT_NO1                       = 4002,
	--/* Custom ID */
	ID_CUS_ML_MOREN_LM               = 6001,
}

function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/PLTC.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	-- 添加大的GUI
	local gui = kd.class(kd.GuiObjectNew, self, 101, 0 , 0, ScreenW, ScreenH, false, true);
    self:addChild(gui);
	-- 文本
	self.m_txtNums = self.m_thView:GetText(idsw.ID_TXT_NO0);
	self.m_txtNums:SetHAlignment(kd.TextHAlignment.LEFT);
	-- 关闭
	self.m_sprClose = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM);
	gDef:AddGuiByID(self, idsw.ID_IMG_ML_MAIN_LM, 30, 30, 30, 30);
	
	local x,y,faceR,h = self.m_thView:GetScaleRect(idsw.ID_CUS_ML_MOREN_LM);
	-- 暂无留言
	self.m_sprNoHave = kd.class(kd.Sprite,gDef.GetResPath("ResAll/MoRen.png"));
	self:addChild(self.m_sprNoHave);
	self.m_sprNoHave:SetPos(x,y);
	self.m_txtNoHave = self.m_thView:GetText(idsw.ID_TXT_NO1);
	
	-- 添加输入框
	self.m_CommentEdit = kd.class(CommentEdit, false, false);
	self.m_CommentEdit:init();
	self:addChild(self.m_CommentEdit);
	
	-- 添加滑动视图
	local x,y = self.m_txtNums:GetPos();
	local height = y + 40;
	local editHeight = self.m_CommentEdit:GetEditHeight();
	local height2 = editHeight - height;
	self.m_CommentScroll =  kd.class(CommentScroll, true, false);
	self.m_CommentScroll:init(height, height2);
	self:addChild(self.m_CommentScroll);
	
	DC:RegisterCallBack("Comments.HaveComment",self,function (num)
		self:HaveComment(num > 0);
		self:SetCommentsNum(num);
	end)
	
	DC:RegisterCallBack("Comments.Show",self,function (bo, id)
		if bo then
			DC:CallBack("CommentEdit.SetId",id);
			DC:CallBack("CommentScroll.get_commentlist",id);
		end
		self:SetVisible(bo);
	end);
end

function impl:initView()
	self.m_txtNums:SetString("0条留言");
	self:HaveComment(false);
end

-- 有评论
function impl:HaveComment(bo)
	self.m_sprNoHave:SetVisible(not bo);
	self.m_txtNoHave:SetVisible(not bo);
end

function impl:onGuiToucBackCall(id)
	-- 关闭
	if id == idsw.ID_IMG_ML_MAIN_LM then
		self:SetVisible(false);
	elseif id == 101 then
		self:SetVisible(false);
	end
end

function impl:OnActionEnd()
	local bo = self:IsVisible();
	if not bo then
		self:initView();
	end
end

function impl:SetCommentsNum(num)
	self.m_txtNums:SetString(num.."条留言");
end