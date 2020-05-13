--[[
	黑名单/关注 列表子项
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

BlackListItem = kd.inherit(kd.Layer);
local impl = BlackListItem;
local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN3_LM           = 1001,
	ID_IMG_ML_MAIN_LM2           = 1002,
	ID_IMG_ML_MAIN_LM5           = 1003,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
	ID_TXT_NO1                   = 4002,
	--/* Custom ID */
	ID_CUS_ML_TX145_LM           = 6001,
}

function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/HMDLieBiao.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	self.m_sprBG = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM2);
	
	--名字
	self.m_nickname = self.m_thView:GetText(idsw.ID_TXT_NO0)
	
	--个性签名
	self.m_sign = self.m_thView:GetText(idsw.ID_TXT_NO1)
	
	--头像
	self.m_cusFace = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_TX145_LM,nil,true,2);
	self.m_cusFace.clickGui:SetEnable(false)
	--关注
	self.facousgui = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM,0,0,0,0);
	--移除
	self.removegui = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM5,0,0,0,0);
end

function impl:GetWH()
	--local x,y = self.m_sprBG:GetPos();
	return ScreenW,202
end	

--[[
			关注列表
			UserId		int
            NickName	string
            Avatar		string
            Signature	string（个性签名）
]]

--[[
粉丝
			UserId	int
            NickName	string
            Avatar	string
            Signature	string（个性签名）
            IsFocus	bool
]]

--设置数据
function impl:SetData(data)
	self.m_ty = data.ty
	self.UserId = data.UserId
	self.m_username = data.NickName
	--头像
	self.m_cusFace:SetFace(gDef.domain ..data.Avatar);
	--设置名字
	self.m_nickname:SetString(gDef:GetName(data.NickName,9))
	--个性签名
	self.m_sign:SetString(data.Signature)
	
	self.facousgui:SetVisible(data.ty == 1 or data.ty == 2);
	self.removegui:SetVisible(data.ty == 1 or data.ty == 2);
	
	if data.IsFocus ~= nil then
		self.facousgui:SetVisible(not data.IsFocus);
		self.removegui:SetVisible(data.IsFocus);
	end
	
	
	if data.ty == 3 or data.ty == 1 then
		self.m_cusFace.clickGui:SetEnable(true)
	end
	
	if data.ty == 2 then
		self.facousgui:SetVisible(false);
		self.removegui:SetVisible(true);
	end
	
	if self.m_ty == 1 then
		self.removegui:SetVisible(false);
	end
end

function impl:onGuiToucBackCall(id)
	--关注
	if id == idsw.ID_IMG_ML_MAIN3_LM then
		echo("关注")
		self:Setlove(1)
	--移除
	elseif id == idsw.ID_IMG_ML_MAIN_LM5 then
		echo("移除")
		if self.m_ty == 2 then
			gSink:messagebox({
			txt = {"确认将" .. self.m_username .. "移除黑名单？"},
			btn = {"取消","确认"},				-- 按钮
			fn = {
			function() 
				
			end,
				
			function() 
				-- 发包
				gSink:Post("michat/hate",{touserid = self.UserId,action = 0},function(data)
					if data.Result then
						self:GetIndex(self.UserId);
						DC:CallBack("BlackListView.RemoveTable",self.UserId);	
						local tData = DC:GetData("AHomeView.HateList");	
						tData[tostring(self.UserId)] = nil;
						if tData.num > 1 then
							tData.num = tData.num -1;
						end
						DC:FillData("AHomeView.HateList",tData);			--	黑名单
					end
				end);
			end
			},
		});	
		else
			self:Setlove(0)
		end
	elseif id == idsw.ID_CUS_ML_TX145_LM then
		gSink:Post("michat/is-hate",{touserid = self.UserId},function(data)
			if data.Result then
				if data.IsBlacklist then
					gSink:messagebox_default("你已将TA拉入黑名单")
					return;
				end
				if data.IsBeBlacklist then
					gSink:messagebox_default("TA已将您拉入黑名单")
					return;
				end
				DC:CallBack("DetaileView.GetDetailData",self.UserId);
			else
				gSink:messagebox_default(data.ErrMsg)
			end
		end);
	end
end

--[[
	关注/取消关注
	"/michat/love"
	userid
	userkey
	touserid
	action （0-取消关注，1-关注）
	成功消息：
	{
		Result bool
}
]]

function impl:Setlove(sign)
	self.m_sign = sign
	gSink:Post("michat/love",{touserid = self.UserId,action = sign},function(data)
		if data.Result then
			self.facousgui:SetVisible(self.m_sign == 0);
			self.removegui:SetVisible(self.m_sign == 1);
			--关注成功/取消关注成功
			if self.m_sign == 0 then
				gSink:messagebox_default("取消关注成功")
			else
				gSink:messagebox_default("关注成功")
			end
			--刷新我页面的关注数字
			DC:CallBack("MyView.updateme")
			
			if self.m_sign == 1 and  self.m_ty == 1 then
				self.removegui:SetVisible(false);	
			end
		else	
			gSink:messagebox_default(data.ErrMsg)	
		end
	end);
end

--[[

	关注/取消关注
"/michat/love"
userid
userkey
touserid
action （0-取消关注，1-关注）
成功消息：
{
    Result bool
}


拉黑/取消拉黑
"/michat/hate"
userid
userkey
touserid
action （0-取消拉黑，1-拉黑）
成功消息：
{
    Result bool
}

]]

function impl:GetIndex(userID)
	DC:CallBack("AHomePageView.NoupdateUserBlock",userID);		--	更新首页
	DC:CallBack("ADynamicView.NoupdateUserBlock",userID)		--	更新广场

end