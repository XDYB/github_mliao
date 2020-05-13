--[[
	搜索结果 列表子项
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

SearchItem = kd.inherit(kd.Layer);
local impl = SearchItem;
local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM2           = 1001,
	ID_IMG_ML_MAIN_LM4           = 1002,
	ID_IMG_ML_MAIN_LM5           = 1003,
	ID_IMG_ML_MAIN_LM6           = 1004,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
	--/* Custom ID */
	ID_CUS_ML_TX145_LM           = 6001,
}

function impl:init(father)
	self.m_father = father
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/SYSouSuoLieBiao2.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	self.m_sprBG = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM2);
	local x,y = self.m_sprBG:GetPos()
	--名字
	self.m_nickname = self.m_thView:GetText(idsw.ID_TXT_NO0)
	self.m_nickname:SetVisible(false)
	self.m_namex,self.m_namey = self.m_nickname:GetPos()
	self.m_namex,self.m_namey = self.m_namex - 210,y 
	--头像
	self.m_cusFace = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_TX145_LM,nil,false,2);
	--关注
	self.facousgui = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM5,0,0,0,0);
	--已关注
	self.removegui = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM6,0,0,0,0);
	
	--self.facousgui:SetVisible(ty == 1);
	self.removegui:SetVisible(ty == 2);
	
	--[[self.m_txtleft = kd.class(kd.StaticText,43,"namel",kd.TextHAlignment.CENTER, ScreenW, 80);
	self.m_txtcenter = kd.class(kd.StaticText,43,"namec",kd.TextHAlignment.CENTER, ScreenW, 80);
	self.m_txtright = kd.class(kd.StaticText,43,"namer",kd.TextHAlignment.CENTER, ScreenW, 80);
	self:addChild(self.m_txtleft);
	self:addChild(self.m_txtcenter);
	self:addChild(self.m_txtright);
	self.m_txtleft:SetColor(0xff353235);
	self.m_txtcenter:SetColor(0xff353235);
	self.m_txtright:SetColor(0xff353235);--]]
	
	self.m_txt = {};
	for i=1,20 do
		self.m_txt[i] = kd.class(kd.StaticText,48,"",kd.TextHAlignment.CENTER, 700, 0);
		self:addChild(self.m_txt[i]);
	end
	
end

function impl:GetWH()
	local x,y = self.m_sprBG:GetPos();
	return ScreenW,y*2
end	

--[[

	UserId int
	Nickname string
	AvatarFile string
	IsFocus bool
]]

--设置数据
function impl:SetData(data)
	self.UserId = data.UserId
	--头像
	self.m_cusFace:SetFace(gDef.domain ..  data.AvatarFile);
	--设置名字
	self.m_nickname:SetString(data.Nickname)
	--关注/已关注
	self.facousgui:SetVisible(not data.IsFocus);
	self.removegui:SetVisible(data.IsFocus);
	
	--self:SetLightNameEx(data.Nickname)
	local split_str = self.m_father:GetEditText()
	self:SetName(data.Nickname,split_str)
end

function impl:getSplitStr(logStr,breakpointsStr)
	local t = {}
    local i = 0
    local j = 1
    local z = string.len(breakpointsStr)
    while true do
        i = string.find(logStr, breakpointsStr, i + 1)  -- 查找下一行
        if i == nil then
            table.insert(t, string.sub(logStr,j,-1))
            break 
        end
        table.insert(t, string.sub(logStr,j,i - 1))
        j = i + z
    end 
    return t
end


--设置名字
function impl:SetName(szName,szKeyword)
	--local szName = gDef:GetName(szName,10)
	local fx = 0;
	local x,y,w,h = self.m_thView:GetScaleRect(idsw.ID_CUS_ML_TX145_LM);
	fx = x+w/2 + 35;			--得到名字的起点坐标
	
	local szName_ = gDef:utf8tochars(szName);
	local szKeyword_ = gDef:utf8tochars(szKeyword);
	
	local nKeyCnt = #szKeyword_;
	local x,y = self.m_nickname:GetPos();
	x = fx;
	
	local nIndex = 0;
	for i=1,#szName_ do			--搜索字标红
		if szName_[i].char==nil then
			return;
		end
		self.m_txt[i]:SetString(szName_[i].char)
		self.m_txt[i]:SetColor(0xff505050);
		for j=1,#szKeyword_ do
			local str1 = string.upper(szName_[i].char);
			local str2 = string.upper(szKeyword_[j].char);
			if str1==str2 and nIndex<nKeyCnt then
				self.m_txt[i]:SetColor(0xffff2f79);--红色
				nIndex = nIndex+1;
			end
		end
		
		local nLen = 0;
		local nLen1 = 0;
		nLen = gDef:GetTextLen(44,szName_[i].char);
		if i>1 then
			nLen1 = gDef:GetTextLen(44,szName_[i-1].char);
		end
		
		x = x+nLen1/2+nLen/2+1;
		self.m_txt[i]:SetPos(x,y);
	end
end

function impl:SetLightNameEx(str)
	local split_str = self.m_father:GetEditText()
	
	local len = gDef:GetTextLen(43,str);
	if string.len(split_str) <=  string.len(str) then
		local list_str = self:getSplitStr(str,split_str)
		self.m_txtleft:SetVisible(true)
		self.m_txtcenter:SetVisible(true)
		self.m_txtright:SetVisible(true)
		
		if #list_str > 1 then
			if list_str[1] == "" then
				self.m_txtleft:SetString(split_str)
				self.m_txtleft:SetColor(0xffFF2E2E)
				self.m_txtcenter:SetString(list_str[2])
				self.m_txtcenter:SetColor(0xff353235);
				self.m_txtleft:SetPos(self.m_namex,self.m_namey)
				self.m_txtright:SetVisible(false)
				
				local len1 = gDef:GetTextLen(43,split_str);
				local lenc = gDef:GetTextLen(43,list_str[2]);
				self.m_txtcenter:SetPos(self.m_namex + len1/2 + lenc/2,self.m_namey)
			elseif list_str[2] == "" then
				self.m_txtleft:SetString(list_str[1])
				self.m_txtleft:SetColor(0xff353235)
				self.m_txtcenter:SetString(split_str)
				self.m_txtcenter:SetColor(0xffFF2E2E);
				self.m_txtleft:SetPos(self.m_namex,self.m_namey)
				self.m_txtright:SetVisible(false)
				
				local len1 = gDef:GetTextLen(43,list_str[1]);
				local lenc = gDef:GetTextLen(43,split_str);
				self.m_txtcenter:SetPos(self.m_namex + len1/2 + lenc/2,self.m_namey)
			elseif list_str[1] == "" and ist_str[2] == "" then
				self.m_txtleft:SetString(str)
				self.m_txtleft:SetColor(0xff353235)
			
				self.m_txtleft:SetPos(self.m_namex,self.m_namey)
				self.m_txtright:SetVisible(false)
				self.m_txtcenter:SetVisible(false)
				
			else
				self.m_txtleft:SetString(list_str[1])
				self.m_txtleft:SetColor(0xff353235)
				
				self.m_txtcenter:SetString(split_str)
				self.m_txtcenter:SetColor(0xffFF2E2E);
				
				self.m_txtright:SetString(list_str[2])
				self.m_txtright:SetColor(0xff353235)
				
				self.m_txtright:SetVisible(true)
				
				
				local len1 = gDef:GetTextLen(43,list_str[1]);
				local lenc = gDef:GetTextLen(43,split_str);
				local lenr = gDef:GetTextLen(43,list_str[2]);
				
				self.m_txtleft:SetPos(self.m_namex,self.m_namey)
				self.m_txtcenter:SetPos(self.m_namex + math.ceil(len1/2) + math.ceil(lenc/2),self.m_namey)
				self.m_txtright:SetPos(self.m_namex + math.ceil(len1/2) + lenc + math.ceil(lenr/2),self.m_namey)
			end
		end
	end
end

function impl:SetLightName(str)
	local split_str = self.m_father:GetEditText()
	
	local len = gDef:GetTextLen(43,str);
	if string.len(split_str) <=  string.len(str) then
		local list_str = string.split(str,split_str)
		
		if #list_str > 1 then
			if list_str[1] == "" then
				self.m_txtleft:SetString(split_str)
				self.m_txtleft:SetColor(0xffFF2E2E)
				self.m_txtcenter:SetString(list_str[2])
				self.m_txtcenter:SetColor(0xff353235);
				self.m_txtleft:SetPos(self.m_namex,self.m_namey)
				self.m_txtright:SetVisible(false)
				
				local len1 = gDef:GetTextLen(43,split_str);
				local lenc = gDef:GetTextLen(43,list_str[2]);
				self.m_txtcenter:SetPos(self.m_namex + len1/2 + lenc/2,self.m_namey)
			elseif list_str[2] == "" then
				self.m_txtleft:SetString(list_str[1])
				self.m_txtleft:SetColor(0xff353235)
				self.m_txtcenter:SetString(split_str)
				self.m_txtcenter:SetColor(0xffFF2E2E);
				self.m_txtleft:SetPos(self.m_namex,self.m_namey)
				self.m_txtright:SetVisible(false)
				
				local len1 = gDef:GetTextLen(43,list_str[1]);
				local lenc = gDef:GetTextLen(43,split_str);
				self.m_txtcenter:SetPos(self.m_namex + len1/2 + lenc/2,self.m_namey)
			else
				self.m_txtleft:SetString(list_str[1])
				self.m_txtleft:SetColor(0xff353235)
				
				self.m_txtcenter:SetString(split_str)
				self.m_txtcenter:SetColor(0xffFF2E2E);
				
				self.m_txtright:SetString(list_str[2])
				self.m_txtright:SetColor(0xff353235)
				
				self.m_txtright:SetVisible(true)
				
				
				local len1 = gDef:GetTextLen(43,list_str[1]);
				local lenc = gDef:GetTextLen(43,split_str);
				local lenr = gDef:GetTextLen(43,list_str[2]);
				
				self.m_txtleft:SetPos(self.m_namex,self.m_namey)
				self.m_txtcenter:SetPos(self.m_namex + math.ceil(len1/2) + math.ceil(lenc/2),self.m_namey)
				self.m_txtright:SetPos(self.m_namex + math.ceil(len1/2) + lenc + math.ceil(lenr/2),self.m_namey)
			end
		end
	end
	
end

function impl:onGuiToucBackCall(id)
	--移除
	if id == idsw.ID_IMG_ML_MAIN_LM6 then
		echo("移除")
		self:Setlove(0)
	--关注
	elseif id == idsw.ID_IMG_ML_MAIN_LM5 then
		echo("关注")
		self:Setlove(1)
	elseif id == idsw.ID_CUS_ML_TX145_LM then
		
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
		else
			gSink:messagebox_default(data.ErrMsg)
		end
	end);
end