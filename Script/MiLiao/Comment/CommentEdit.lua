--[[

	评论 -- 输入框

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

CommentEdit = kd.inherit(kd.Layer);
local impl = CommentEdit;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw = {
	--/* Image ID */
	ID_IMG_ML_MAIN_LM1           = 1001,
	ID_IMG_ML_MAIN_LM4           = 1002,
	ID_IMG_ML_MAIN_LM5           = 1003,
}

function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/PLShuRuLan.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	-- 添加输入框
	local bg = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM1);
	local x,y = bg:GetPos();
	local w,h = bg:GetWH();
	self.m_editBox = gDef:AddEditBox(self,x+10,y,w-10,h,36,0xffffffff)
	self.m_editBox:SetInputMode(kd.InputMode.SINGLE_LINE);
	self.m_editBox:SetMaxLength(36);
    self.m_editBox:SetReturnType(kd.KeyboardReturnType.GO);
    self.m_editBox:SetTitle("给她留言，说点好听的~",0xff6A6868)
	-- 添加点击事件
	gDef:AddGuiByID(self, idsw.ID_IMG_ML_MAIN_LM5, 0,0,0,0);
	
	self.m_dynamicid = 0;
	
	DC:RegisterCallBack("CommentEdit.SetId",self,function (id)
		self.m_dynamicid = id;
	end);
end

function impl:initView()
	self.m_editBox:SetText("");
	self.m_dynamicid = 0;
end

function impl:onGuiToucBackCall(id)
	if id == idsw.ID_IMG_ML_MAIN_LM5 then
		self:comment_dynamic();
	end
end

function impl:GetEditHeight()
	local _,_,w,h = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN_LM4);
	local bg = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM4);
	local x,y = bg:GetPos();
	return y - h/2;
end

function impl:comment_dynamic()
	local str = self.m_editBox:GetText();
	str = string.gsub(str, " ", "");
	if self.m_dynamicid and self.m_dynamicid > 0 then
		if string.len(str)>0 then
			gSink:Post("michat/comment-dynamic",{dynamicid = self.m_dynamicid, content = str},function(data)
				if data.Result then
					gSink:messagebox_default("评论成功！");
					self.m_editBox:SetText("");
					-- 更新数据
					DC:CallBack("PlayView.UpdteCommentNum");
					-- 更新评论
					DC:CallBack("CommentScroll.updateComment");
				else
					gSink:messagebox_default(data.ErrMsg);
				end
			end);
		else
			gSink:messagebox_default("请输入评论内容");
		end
		
	end
end