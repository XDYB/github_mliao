local kd = KDGame;
local gDef = gDef;
local ScreenW = KDGame.SceneSize.width;
local ScreenH = KDGame.SceneSize.high;

local bgPath = gDef.GetUpdateResPath("ResAll/update/jrtc.png");
local bgPath2 = gDef.GetUpdateResPath("ResAll/update/oyjrheitanchuang.png");

local mgPath = gDef.GetUpdateResPath("ResAll/update/jrtanchuangbg.png");
-- ===============================================================================
-- 									半透明弹出框
-- ===============================================================================

PopUpBox = kd.inherit(kd.Layer);

local BOX_ID = 1000;		--定时器弹框ID
local BOX_TIME = 3000;		--定时器弹框ID

local DELAY_ID = 1001;		--延迟定时器弹框ID

--半透明弹框
function PopUpBox:AddBox(szStr,dwlayTime)
	--延迟定时器
	if dwlayTime then
		self:SetTimer(DELAY_ID,dwlayTime,1);
		self.m_szStr = szStr;
		return;
	end
	self:DelayTimeAdd(szStr);
end	

function PopUpBox:DelayTimeAdd(szStr)
	szStr = szStr and szStr or "";
	
	local nFind = string.find(szStr,"\n");
	if nFind then
		local fPosX,fPosY = ScreenW/2,ScreenH/2;
		self:SetTimer(BOX_ID,BOX_TIME,1);
		self.m_BgImg = {0,0,0};
		self.m_BgImg[1] = kd.class(kd.Sprite,bgPath2);
		self:addChild(self.m_BgImg[1]); 
		self.m_BgImg[2] = kd.class(kd.Sprite,bgPath2);
		self:addChild(self.m_BgImg[2]);
		self.m_BgImg[3] = kd.class(kd.Sprite,bgPath2);
		self:addChild(self.m_BgImg[3]); 
			
		local nLen = string.len(szStr);

		
		local centerBgW= gDef:GetTextLen(44,szStr)/2+100;

		self.m_BgImg[1]:SetTextureRect(0,0,50,180);
		self.m_BgImg[2]:SetTextureRect(270/2,0,1,180);
		self.m_BgImg[3]:SetTextureRect(270-50,0,50,180);
		
		self.m_txtMsg1 = kd.class(kd.StaticText,44,szStr,kd.TextHAlignment.CENTER, ScreenW, 200);
		self:addChild(self.m_txtMsg1);
		self.m_txtMsg1:SetColor(0xffffffff);
		self.m_txtMsg1:SetPos(fPosX,fPosY+50);
		
		self.m_BgImg[1]:SetPos(ScreenW/2-centerBgW/2-25,fPosY);
		self.m_BgImg[2]:SetPos(fPosX,fPosY);
		self.m_BgImg[2]:SetScale(gDef:GetTextLen(44,szStr)/2+100,1);
		self.m_BgImg[3]:SetPos(ScreenW/2+centerBgW/2+25,fPosY);
	else
		local fPosX,fPosY = ScreenW/2,ScreenH/2;
		self:SetTimer(BOX_ID,BOX_TIME,1);
		self.m_BgImg = {0,0,0};
		self.m_BgImg[1] = kd.class(kd.Sprite,bgPath);
		self:addChild(self.m_BgImg[1]); 
		self.m_BgImg[2] = kd.class(kd.Sprite,bgPath);
		self:addChild(self.m_BgImg[2]);
		self.m_BgImg[3] = kd.class(kd.Sprite,bgPath);
		self:addChild(self.m_BgImg[3]); 
			
		local nLen = string.len(szStr);

		local centerBgW= gDef:GetTextLen(44,szStr);

		self.m_BgImg[1]:SetTextureRect(0,0,50,100);
		self.m_BgImg[2]:SetTextureRect(260/2,0,1,100);
		self.m_BgImg[3]:SetTextureRect(260-50,0,50,100);
		
		self.m_txtMsg1 = kd.class(kd.StaticText,44,szStr,kd.TextHAlignment.CENTER, ScreenW, 80);
		self:addChild(self.m_txtMsg1);
		self.m_txtMsg1:SetColor(0xffffffff);
		self.m_txtMsg1:SetPos(fPosX,fPosY+18);
		
		self.m_BgImg[1]:SetPos(ScreenW/2-centerBgW/2-25,fPosY);
		self.m_BgImg[2]:SetPos(fPosX,fPosY);
		self.m_BgImg[2]:SetScale(gDef:GetTextLen(44,szStr),1);
		self.m_BgImg[3]:SetPos(ScreenW/2+centerBgW/2+25,fPosY);
	end
	

end	

function PopUpBox:OnTimerBackCall(id)
	if id==BOX_ID then
		self:SetVisible(false);
	elseif id == DELAY_ID then	
		self:DelayTimeAdd(self.m_szStr);
	end	
end

function PopUpBox:onTouchBegan(x,y)
	if self:IsVisible() then
		self:SetVisible(false);
		return true;
	else
		return false;
	end
end	

function PopUpBox:SetVisible(bVisible) 
	kd.Node.SetVisible(self,bVisible);
	if bVisible then
		self:SetVisible(false);
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


PopUpBtnBox = kd.inherit(kd.Layer);--主界面

local lineHeight = 80
local txtPos = {
	[1] = {{ScreenW/2,ScreenH/2-50}},
	[2] = {{ScreenW/2,ScreenH/2-50-lineHeight/2},{ScreenW/2,ScreenH/2-50+lineHeight/2}},
	[3] = {{ScreenW/2,ScreenH/2-50-lineHeight},{ScreenW/2,ScreenH/2-50},{ScreenW/2,ScreenH/2-50+lineHeight}}
}
function PopUpBtnBox:init(sink)	
	self.m_sink = sink;
	
    self.m_Mask = kd.class(MaskUI,false,false)
	self.m_Mask:init(self);
	self:addChild(self.m_Mask);
	
	self.m_BgImg = kd.class(kd.Sprite,mgPath);
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
	
	self.m_btns = {};
	self.m_btns[1] = kd.class(kd.StaticText,48,"No",kd.TextHAlignment.CENTER, ScreenW, 0);
	self:addChild(self.m_btns[1]);
	self.m_btns[1]:SetColor(0xffa2a2a2);
	self.m_btns[1]:SetPos(ScreenW/2-200,ScreenH/2+210);
	self:AddGuiBySpr(self,self.m_btns[1],1,50,200,50,200)
	
	self.m_btns[2] = kd.class(kd.StaticText,48,"Yes",kd.TextHAlignment.CENTER, ScreenW, 0);
	self:addChild(self.m_btns[2]);
	self.m_btns[2]:SetColor(0xffff2f79);
	self.m_btns[2]:SetPos(ScreenW/2+200,ScreenH/2+210);
	self:AddGuiBySpr(self,self.m_btns[2],2,50,200,50,200)
	
end

function PopUpBtnBox:_init()
	self.m_txtMsg[1]:SetColor(0xff000000);
	self.m_txtMsg[1]:SetVisible(false);
	self.m_txtMsg[2]:SetColor(0xff000000);
	self.m_txtMsg[2]:SetVisible(false);
	self.m_txtMsg[3]:SetColor(0xff000000);
	self.m_txtMsg[3]:SetVisible(false);
	self.m_btns[1]:SetColor(0xffa2a2a2);
	self.m_btns[1]:SetString("No");
	self.m_btns[2]:SetColor(0xffff2f79);
	self.m_btns[2]:SetString("Yes");
	self.fn1 = nil;
	self.fn2 = nil;
	
end

function PopUpBtnBox:Show(options)
	self.options = options;
	-- 是否显示蒙板
	if options.mask == false then
		self.m_Mask:SetVisible(false);
	end
	
	if options.nFontSize and #options.nFontSize>0 then 
		for i=1,#options.txt do
			self:RemoveChild(self.m_txtMsg[i]);
			self.m_txtMsg[i]=nil;
			self.m_txtMsg[i] = kd.class(kd.StaticText,options.nFontSize[i],"",kd.TextHAlignment.CENTER, ScreenW, 0);
			self:addChild(self.m_txtMsg[i]);
			self.m_txtMsg[i]:SetColor(0xff000000);
			self.m_txtMsg[i]:SetVisible(false);
		end
	end 
	
	if options.LineHeight then 
		txtPos = {
		[1] = {{ScreenW/2,ScreenH/2-50}},
		[2] = {{ScreenW/2,ScreenH/2-50-lineHeight/2},{ScreenW/2,ScreenH/2-50+lineHeight/2}},
		[3] = {{ScreenW/2,ScreenH/2-50-lineHeight},{ScreenW/2,ScreenH/2-50},{ScreenW/2,ScreenH/2-50+lineHeight}}
		}
	end 
	
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
	
	if options.btnCls then
		for i,v in ipairs(options.btnCls) do
			self.m_btns[i]:SetColor(v)
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

function PopUpBtnBox:onGuiToucBackCall(--[[int]] id)
	if id==1 then
		self.fn1();
	elseif id==2 then
		self.fn2();
	end
	self:closeWindow();
end


function PopUpBtnBox:SetVisible(bool) 
	if not bool then
		self:_init()
	end
	kd.Node.SetVisible(self, bool);
end

function PopUpBtnBox:closeWindow()
	self:SetVisible(false);
	
	if(self.sink) then self.sink:messagebox_remove(self); end
	
	--设置销毁定时器(不可以在C层自己的回调中销毁自己!)
	self:SetTimer(REMOVE_ID, 100, 1);
end	

function PopUpBtnBox:OnTimerBackCall(id)		
	if (id==REMOVE_ID) then
		--将自己移除出主层
		kd.RemoveLayer(self);
		--析构
		kd.free(self);		
		self = nil;
	end
end
function PopUpBtnBox:AddGuiBySpr(father,SprOrTxt,iResID,paddingTop,paddingRight,paddingBottom,paddingLeft)
    paddingTop = paddingTop and paddingTop or 0;
    paddingRight = paddingRight and paddingRight or 0;
    paddingBottom = paddingBottom and paddingBottom or 0;
    paddingLeft = paddingLeft and paddingLeft or 0;
    
    local px,py = SprOrTxt:GetPos();
    local w,h = SprOrTxt:GetWH();
    local obj = {
        spr = SprOrTxt,
        gui = 0,
        SetVisible = function(this,bool)
            this.spr:SetVisible(bool)
            this.gui:SetVisible(bool)
        end,
        SetPos = function(this,px,py)
           if this.spr.SetHAlignment then
                this.spr:SetHAlignment(kd.TextHAlignment.CENTER);
           end
           this.spr:SetPos(px,py);
           local x = px - w/2 - paddingLeft;
           local y = py - h/2 - paddingTop;
           local w = w + paddingLeft + paddingRight;
           local h = h + paddingTop + paddingBottom;
           this.gui:SetTouchRect(x,y,w,h);
        end,
        setDebugMode = function(this,bool)
            this.gui:setDebugMode(true)
        end
    };

    local x = px - w/2 - paddingLeft;
    local y = py - h/2 - paddingTop;
    local w = w + paddingLeft + paddingRight;
    local h = h + paddingTop + paddingBottom;
    obj.gui = kd.class(kd.GuiObjectNew, father, iResID,x , y, w, h, false, true);
    obj.gui:setDebugMode(true);
    father:addChild(obj.gui);
    return obj;
end