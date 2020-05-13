local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local local_tim = tim;
local local_tsdk = tim.sdk;
local local_tconv = tim.Conv;
local local_tmsg = tim.Msg;
local local_tgroup = tim.Group;
local local_tuser = tim.UserProfile;
local local_tfriend = tim.Friendship;

ACallChatTimeItem = kd.inherit(kd.Layer);
local impl = ACallChatTimeItem;

function impl:init(txt)
	local  szStr = txt or "";
	
	local fPosX,fPosY = ScreenW/2,140 - 28 - 10;
	self.m_BgImg = {0,0,0};
	self.m_BgImg[1] = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"));
	self:addChild(self.m_BgImg[1]); 
	self.m_BgImg[2] = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"));
	self:addChild(self.m_BgImg[2]);
	self.m_BgImg[3] = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"));
	self:addChild(self.m_BgImg[3]); 
	
	for i=1,3 do
		--TweenPro:SetAlpha(self.m_BgImg[i],1);
		self.m_BgImg[i]:SetColor(0xffE0E0E0)
	end
	
	local nLen = string.len(szStr);
	local nFind = string.find(szStr,"\n");		--如果自带换行符就无需换行
	if nLen>42 or nFind then		--2排文字
		self.m_BgImg[1]:SetTextureRect(1888,440,29,58);
		self.m_BgImg[2]:SetTextureRect(1917,440,10,58); 
		self.m_BgImg[3]:SetTextureRect(1927,440,29,58); 
		
		local szStr1 = "";
		local szStr2 = "";
		
		local nMaxLen = 0;
		if nFind then
			szStr1 = string.sub(szStr,1,nFind-1);
			szStr2 = string.sub(szStr,nFind+1, -1);
			if string.len(szStr1)>string.len(szStr2) then
				nMaxLen = string.len(szStr1);
			else
				nMaxLen = string.len(szStr2);
			end
		else
			nMaxLen = nLen//2;	
			if nMaxLen%2~=0 then			--奇数时，上面多一行字
				nMaxLen = nMaxLen+1;
			end
		
			local nCnt = 0;
			local list = gDef:utf8tochars(szStr);
			for i=1,#list do
				nCnt = nCnt+string.len(list[i].char);
				if nCnt>=nMaxLen then
					szStr1 = string.sub(szStr,1,nCnt);
					szStr2 = string.sub(szStr,nCnt+1,-1);
					break;
				end
			end
		end

		--弹框内容
		self.m_txtMsg1 = kd.class(kd.StaticText,44,szStr1,kd.TextHAlignment.CENTER, ScreenW, 80);
		self:addChild(self.m_txtMsg1);
		self.m_txtMsg1:SetColor(0xffffffff);
		self.m_txtMsg1:SetPos(fPosX,fPosY-10);
	
		self.m_txtMsg2 = kd.class(kd.StaticText,44,szStr2,kd.TextHAlignment.CENTER, ScreenW, 80);
		self:addChild(self.m_txtMsg2);
		self.m_txtMsg2:SetColor(0xffffffff);
		self.m_txtMsg2:SetPos(fPosX,fPosY+40);
		
		self.m_BgImg[1]:SetPos(fPosX-nMaxLen*9-45,fPosY);
		self.m_BgImg[2]:SetPos(fPosX,fPosY);
		self.m_BgImg[2]:SetScale(nMaxLen*1.8,1);
		self.m_BgImg[3]:SetPos(fPosX+nMaxLen*9+45,fPosY);
	else									--1排文字
		self.m_BgImg[1]:SetTextureRect(1888,440,29,58);
		self.m_BgImg[2]:SetTextureRect(1917,440,10,58); 
		self.m_BgImg[3]:SetTextureRect(1927,440,29,58); 
		
		self.m_txtMsg1 = kd.class(kd.StaticText,32,szStr,kd.TextHAlignment.CENTER, ScreenW, 80);
		self:addChild(self.m_txtMsg1);
		self.m_txtMsg1:SetColor(0xffffffff);
		self.m_txtMsg1:SetPos(fPosX,fPosY+24);
		
		local len = gDef:GetTextLen(32,szStr) + 58;
		local wc,hc = self.m_BgImg[2]:GetWH();
		self.m_BgImg[2]:SetScale(len/wc, 1);
		self.m_BgImg[2]:SetPos(fPosX,fPosY);
		
		local w,h = self.m_BgImg[1]:GetWH()
		self.m_BgImg[1]:SetPos(fPosX - len/2 - w/2,fPosY)
		
		local w,h = self.m_BgImg[3]:GetWH()
		self.m_BgImg[3]:SetPos(fPosX+len/2 + w/2,fPosY);
	end
end

function impl:GetWH()
	return ScreenW,200;
end

function impl:Cls()
end