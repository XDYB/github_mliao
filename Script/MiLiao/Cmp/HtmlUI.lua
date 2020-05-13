--[[
webview
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

HtmlUI = kd.inherit(kd.Layer);--主界面

function HtmlUI:constr(self)

	
end
function HtmlUI:init()
	self.back = kd.class(BackUI,false,false);
	self.back:init();
	self:addChild(self.back);
	
	
	self.head = kd.class(Title,false,false);
	self.head:init(self,"--",true);
	self:addChild(self.head);
	--[[self.head:SetLeftCallBack(function()	
		self:SetVisible(false)
	end)--]]
	self.head.onTouchBegan = function (this,x,y)
		local h = this:GetH();
		if y > h then
			return false
		else
			return true
		end
	end	
	
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE,ScreenW,ScreenH);
end
function HtmlUI:OnActionEnd()
	if self:IsVisible()== false then
		self:ClearWebView();
	end
end

function HtmlUI:Show(title,url)
	self.url = url;
	self.head:SetTitle(title);
	if self.m_webView==nil then
		self:CreateWebView();
	end
	self.m_webView:loadUrl(self.url);
	self:SetVisible(true);
	DC:CallBack("AHomePageButtom.Show",false);
end	

function HtmlUI:ShowWebView(bool)
	if self.m_webView then
		self.m_webView:SetVisible(bool);
	end	
end
function HtmlUI:ClearWebView()
	if self.m_webView then
		self.m_webView:SetVisible(false);
		self:RemoveChild(self.m_webView);
		local boAStartLoadUI = DC:GetData("AStartLoadUI.IsInHtml");
		local boALogin = DC:GetData("ALogin.IsInHtml");
		if boAStartLoadUI then
			DC:FillData("AStartLoadUI.IsInHtml",false);
		elseif boALogin then
			DC:FillData("ALogin.IsInHtml",false);
		else
			DC:CallBack("AHomePageButtom.Show",true);
		end
		
		self.m_webView = nil;
	end
end
function HtmlUI:CreateWebView()
	if self.m_webView == nil then
		self.m_webView = kd.class(kd.WebView,0,gDef.HeadH,ScreenW,ScreenH-gDef.HeadH);
		self:addChild(self.m_webView);
		self.m_webView:SetVisible(true);
		if (kd.GetSystemType() ~= kd.SystemType.OS_WIN32) then	
			-- 开始加载
			self.m_webView.OnloadUrlStart = function(this, url)
				local cmd = string.match(url,"http://cmd.(%a+)/");
				if cmd then
					-- 拦截URL
					return false;
				end
				return true;
			end
			-- 结束加载
			self.m_webView.OnloadUrlFinish = function(this, url)
				-- 加载成功
				self:ShowWebView(true);
			end
			-- 加载失败
			self.m_webView.OnloadUrlFail = function(this, url)
				-- 加载失败
				self:ShowWebView(false);
			end	
		end		
	end
end