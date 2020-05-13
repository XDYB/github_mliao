local kd = KDGame;
local gDef = gDef;
local ScreenW = KDGame.SceneSize.width;
local ScreenH = KDGame.SceneSize.high;


-- ===============================================================================
-- 									半透明弹出框
-- ===============================================================================

AMessBox = kd.inherit(kd.Layer);

local BOX_ID = 1000;		--定时器弹框ID
local BOX_TIME = 3000;		--定时器弹框ID

local DELAY_ID = 1001;		--延迟定时器弹框ID

--半透明弹框
function AMessBox:AddBox(szStr,dwlayTime)
	--延迟定时器
	if dwlayTime then
		self:SetTimer(DELAY_ID,dwlayTime,1);
		self.m_szStr = szStr;
		return;
	end
	self:DelayTimeAdd(szStr);
end	

function AMessBox:DelayTimeAdd(szStr)
	szStr = szStr and szStr or "";
	
	local fPosX,fPosY = ScreenW/2,ScreenH/2;
	self:SetTimer(BOX_ID,BOX_TIME,1);
	self.m_BgImg = {0,0,0};
	self.m_BgImg[1] = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"));

	self:addChild(self.m_BgImg[1]); 
	self.m_BgImg[2] = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"));
	self:addChild(self.m_BgImg[2]);
	self.m_BgImg[3] = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"));
	self:addChild(self.m_BgImg[3]); 
	
	for i=1,3 do
		if self.m_BgImg[i]==nil then
			return;
		end
	end
	-- 字体大小
	local numFontSize = 36;
	local nLen = string.len(szStr);
	local nFind = string.find(szStr,"\n");		--如果自带换行符就无需换行
	if nLen>42 or nFind then		--2排文字
		self.m_BgImg[1]:SetTextureRect(1827,560,51,101);
		self.m_BgImg[2]:SetTextureRect(1878,560,10,101); 
		self.m_BgImg[3]:SetTextureRect(1888,560,51,101); 
		
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
		self.m_txtMsg1 = kd.class(kd.StaticText,numFontSize,szStr1,kd.TextHAlignment.CENTER, ScreenW, 80);
		self:addChild(self.m_txtMsg1);
		self.m_txtMsg1:SetColor(0xffffffff);
		self.m_txtMsg1:SetPos(fPosX,fPosY-numFontSize/2+20-2);
	
		self.m_txtMsg2 = kd.class(kd.StaticText,numFontSize,szStr2,kd.TextHAlignment.CENTER, ScreenW, 80);
		self:addChild(self.m_txtMsg2);
		self.m_txtMsg2:SetColor(0xffffffff);
		self.m_txtMsg2:SetPos(fPosX,fPosY+numFontSize/2+20+2);
		
		local pxLen1 = gDef:GetTextLen(numFontSize,szStr1);
		local pxLen2 = gDef:GetTextLen(numFontSize,szStr2);
		local pxLenMax = pxLen1 > pxLen2 and pxLen1 or pxLen2;
		self.m_BgImg[1]:SetPos(fPosX-(pxLenMax+51)/2,fPosY);
		self.m_BgImg[2]:SetPos(fPosX,fPosY);
		self.m_BgImg[2]:SetScale(pxLenMax/10,1);
		self.m_BgImg[3]:SetPos(fPosX+(pxLenMax+51)/2,fPosY);
	else									--1排文字
		self.m_BgImg[1]:SetTextureRect(1718,667,45,89);
		self.m_BgImg[2]:SetTextureRect(1763,667,10,89);
		self.m_BgImg[3]:SetTextureRect(1773,667,45,89);
		
		self.m_txtMsg1 = kd.class(kd.StaticText,numFontSize,szStr,kd.TextHAlignment.CENTER, ScreenW, 80);
		self:addChild(self.m_txtMsg1);
		self.m_txtMsg1:SetColor(0xffffffff);
		self.m_txtMsg1:SetPos(fPosX,fPosY+18);
		
		local pxLen = gDef:GetTextLen(numFontSize,szStr);
		self.m_BgImg[1]:SetPos(fPosX-(pxLen+45)/2,fPosY);
		self.m_BgImg[2]:SetPos(fPosX,fPosY);
		local w,h = self.m_BgImg[2]:GetWH();
		self.m_BgImg[2]:SetScale(pxLen/w,1);
		self.m_BgImg[3]:SetPos(fPosX+(pxLen+45)/2,fPosY);
		
	end
end	

function AMessBox:OnTimerBackCall(id)
	if id==BOX_ID then
		self:SetVisible(false);
	elseif id == DELAY_ID then	
		self:DelayTimeAdd(self.m_szStr);
	end	
end

function AMessBox:onTouchBegan(x,y)
	if self:IsVisible() then
		self:SetVisible(false);
		return true;
	else
		return false;
	end
end	

function AMessBox:SetVisible(bVisible) 
	kd.Node.SetVisible(self,bVisible);
	if bVisible then
		
	else
		self:KillTimer(DELAY_ID);
		self:KillTimer(BOX_ID);
		kd.RemoveLayer(self);
		kd.free(self);
	end
end





-- ===============================================================================
-- 									带按钮的MessageBox
-- ===============================================================================


local REMOVE_ID = 1001;		--销毁定时器


MessageBox = kd.inherit(kd.Layer);--主界面

local lineHeight = 80
local txtPos = {
	[1] = {{ScreenW/2,ScreenH/2-50}},
	[2] = {{ScreenW/2,ScreenH/2-50-lineHeight/2},{ScreenW/2,ScreenH/2-50+lineHeight/2}},
	[3] = {{ScreenW/2,ScreenH/2-50-lineHeight},{ScreenW/2,ScreenH/2-50},{ScreenW/2,ScreenH/2-50+lineHeight}}
}
function MessageBox:init(sink)	
	self.m_sink = sink;
	
    self.m_Mask = kd.class(Mask,false,false)
	self.m_Mask:init(self);
	self:addChild(self.m_Mask);
	
	self.m_BgImg = kd.class(kd.Sprite,gDef.GetResPath("ResAll/GuDing.png"),0,0,894,474);
	self:addChild(self.m_BgImg); 
	self.m_BgImg:SetPos(ScreenW/2,ScreenH/2);
	
	self.m_txtMsg = {}
	self.m_txtMsg[1] = kd.class(kd.StaticText,44,"",kd.TextHAlignment.CENTER, ScreenW, 0);
	self:addChild(self.m_txtMsg[1]);
	self.m_txtMsg[1]:SetColor(0xff000000);
	self.m_txtMsg[1]:SetVisible(false);
	
	self.m_txtMsg[2] = kd.class(kd.StaticText,44,"",kd.TextHAlignment.CENTER, ScreenW, 0);
	self:addChild(self.m_txtMsg[2]);
	self.m_txtMsg[2]:SetColor(0xff000000);
	self.m_txtMsg[2]:SetVisible(false);
	
	self.m_txtMsg[3] = kd.class(kd.StaticText,44,"",kd.TextHAlignment.CENTER, ScreenW, 0);
	self:addChild(self.m_txtMsg[3]);
	self.m_txtMsg[3]:SetColor(0xff000000);
	self.m_txtMsg[3]:SetVisible(false);
	
	self.m_txtTip = kd.class(kd.StaticText,44,"不再询问",kd.TextHAlignment.CENTER, ScreenW, 0);
	self:addChild(self.m_txtTip);
	self.m_txtTip:SetColor(0xff000000);
	self.m_txtTip:SetPos(ScreenW/2+20,ScreenH/2+80);
	self.m_txtTip:SetVisible(false);
	
	self.m_sprChoose = kd.class(kd.Sprite,gDef.GetResPath("ResAll/TanChuangBG.png"),980,1072,41,42);
	self:addChild(self.m_sprChoose);
	self.m_sprChoose:SetPos(ScreenW/2-100,ScreenH/2+80);
	self.m_sprChoose:SetVisible(false)
	self.m_btnChoose = gDef:AddGuiBySpr(self,self.m_sprChoose,400);
	self.m_btnChoose:setDebugMode(false);
	self.m_btnChoose:SetEnable(false);
	
	self.m_btns = {};
	self.m_btns[1] = kd.class(kd.StaticText,48,"否",kd.TextHAlignment.CENTER, ScreenW, 0);
	self:addChild(self.m_btns[1]);
	self.m_btns[1]:SetColor(0xffa2a2a2);
	self.m_btns[1]:SetPos(ScreenW/2-200,ScreenH/2+180);
	gDef:AddGuiBySpr(self,self.m_btns[1],1,50,200,50,200)
	
	self.m_btns[2] = kd.class(kd.StaticText,48,"是",kd.TextHAlignment.CENTER, ScreenW, 0);
	self:addChild(self.m_btns[2]);
	self.m_btns[2]:SetColor(0xffff2f79);
	self.m_btns[2]:SetPos(ScreenW/2+200,ScreenH/2+180);
	gDef:AddGuiBySpr(self,self.m_btns[2],2,50,200,50,200)
	
end

function MessageBox:_init()
	self.m_txtMsg[1]:SetColor(0xff000000);
	self.m_txtMsg[1]:SetVisible(false);
	self.m_txtMsg[2]:SetColor(0xff000000);
	self.m_txtMsg[2]:SetVisible(false);
	self.m_txtMsg[3]:SetColor(0xff000000);
	self.m_txtMsg[3]:SetVisible(false);
	self.m_btns[1]:SetColor(0xffa2a2a2);
	self.m_btns[1]:SetString("否");
	self.m_btns[2]:SetColor(0xffff2f79);
	self.m_btns[2]:SetString("是");
	
	self.m_btnChoose:SetEnable(false);
	self.m_txtTip:SetVisible(true);
	self.m_sprChoose:SetVisible(false);
	self.m_sprChoose:SetTextureRect(980,1072,41,42);
	self.fn1 = nil;
	self.fn2 = nil;
	self.bChoose =false;
	
end

function MessageBox:Show(options)
	self.options = options;
	local msgLength = #options.txt;
	local pos = txtPos[msgLength];
	for i,v in ipairs(options.txt) do
		self.m_txtMsg[i]:SetString(v);
		self.m_txtMsg[i]:SetVisible(true);
		self.m_txtMsg[i]:SetPos(pos[i][1],pos[i][2]);
	end
	if options.cls then
		for i,v in ipairs(options.cls) do
			self.m_txtMsg[i]:SetColor(v)
		end
	end
	
	if options.btn then
		for i,v in ipairs(options.btn) do
			self.m_btns[i]:SetString(v)
		end
	end
	
	if msgLength<3 and options.choose and  options.choose.bShowChoose then
		self.m_btnChoose:SetEnable(true);
		self.m_sprChoose:SetVisible(true);
		self.m_txtTip:SetVisible(true);
		if options.choose.txt~=nil  then 
			self.m_txtTip:SetString(options.choose.txt);
		end
	end
	
	
	if #self.options.fn == 1 then
		self.fn1 = function()
			
		end
		self.fn2 = self.options.fn[1]
	elseif #self.options.fn == 2 then
		self.fn1 = self.options.fn[1]
		self.fn2 = self.options.fn[2]
	end
	
	self:SetVisible(true);
end

function MessageBox:onGuiToucBackCall(--[[int]] id)
	if id==1 then
		self.fn1(self.bChoose);
	elseif id==2 then
		self.fn2(self.bChoose);
	elseif id == 400 then
		self.bChoose = not self.bChoose;
		if self.bChoose then
			self.m_sprChoose:SetTextureRect(980,1116,41,41);
		else
			self.m_sprChoose:SetTextureRect(980,1072,41,42);
		end
		return;
	end
	self:closeWindow();
end


function MessageBox:SetVisible(bool) 
	if not bool then
		self:_init()
	end
	kd.Node.SetVisible(self, bool);
end

function MessageBox:closeWindow()
	self:SetVisible(false);
	
	if(self.sink) then self.sink:messagebox_remove(self); end
	
	--设置销毁定时器(不可以在C层自己的回调中销毁自己!)
	self:SetTimer(REMOVE_ID, 100, 1);
end	

function MessageBox:OnTimerBackCall(id)		
	if (id==REMOVE_ID) then
		--将自己移除出主层
		kd.RemoveLayer(self);
		--析构
		kd.free(self);		
		self = nil;
	end
end