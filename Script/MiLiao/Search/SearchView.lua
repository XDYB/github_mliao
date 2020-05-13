--[[
	搜索页面
]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

SearchView = kd.inherit(kd.Layer);
local impl = SearchView;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM2           = 1001,
	ID_IMG_ML_MAIN_LM3           = 1002,
	ID_IMG_ML_MAIN_LM5           = 1003,
}

function impl:init(father)
	self.m_father = father
	--背景
	local thview = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/BeiJing.UI"), self);
	self:addChild(thview)
	--头部
	self.Title = kd.class(Title,false,true)
	self.Title:init(self)
	self.Title:SetTitle("搜索")
	self:addChild(self.Title)
	local headH = self.Title:GetH();
	
	--搜索框
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/SYSouSuo.UI"), self);
	self:addChild(self.m_thView)
	self.m_sprBG = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM2)
	local _,by = self.m_sprBG:GetPos();
	
	local x,y = self.m_thView:GetPos()
	self.m_thView:SetPos(x,y + headH)
	local offsety = headH + by*2 + 100
	
	self.m_txtFateYou = kd.class(kd.StaticText, 32, "与你有缘的", kd.TextHAlignment.CENTER, 200, 40);
	self:addChild(self.m_txtFateYou);
	self.m_txtFateYou:SetColor(0xFFA2A2A2)
	self.m_txtFateYou:SetPos(100,headH + by*2 + 50)
	
	--输入框
	local x,y,w,h = self.m_thView:GetScaleRect(idsw.ID_IMG_ML_MAIN_LM3)
	-- 输入栏
	self.m_EditBox = gDef:AddEditBox(self,x + 120,y + headH,w,h,32,0xFF353235,true);
	self.m_EditBox:SetMaxLength(15);
	self.m_EditBox:SetInputMode(kd.InputMode.SINGLE_LINE);		--SINGLE_LINE 用这个模式IOS上回车就可以来EditingReturn回调
    self.m_EditBox:SetReturnType(kd.KeyboardReturnType.SEND);
	--回车键被按下或键盘的外部区域被触摸时
	self.m_EditBox.OnTextChanged = function(this,text) 
		if string.len(text) > 0 and self.m_text ~= text then
			--self:KillTimer(1001);
			--self:SetTimer(1001,500,1)
			self.m_page = 0; 
			--local text = self.m_EditBox:GetText()
			self:SearchUser(0,text)
		end
		self.m_text = text
		print(text)
    end
	-------------------------------------------
	
	self.Scroll = kd.class(ScrollA,true,true)
	self.Scroll:init(0,offsety,ScreenW,ScreenH - offsety)
	self:addChild(self.Scroll)
	self.Scroll.OnClick = function(this,index)
		echo("==========index"..index)
		if self.m_data[index] then
			print("进入资料页")
			DC:CallBack("DetaileView.GetDetailData",self.m_data[index].UserId);
		end
	end

	self.Scroll.OnDown = function(this)
		echo("==========下拉")
		this:BackPos() -- 复位
	end
	
	self.Scroll.OnUp = function(this)
		echo("==========上拉")
		if self.IsEnd  == false and self.m_Destined == false then
			self.m_page = self.m_page + 1
			local text = self.m_EditBox:GetText()
			self:SearchUser(self.m_page,text)
		end
		this:BackPos() -- 复位
	end
	
	self.m_page = 0
	
	self.Scroll:AddUpLoad(LoadUI)
	
	local x,y = self:GetPos();
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	
	--	注册数据中心
	DC:RegisterCallBack("SearchView.Show",self,function(bool,data)
		if data then
			self:SetDestined(data)
		end
		self:SetVisible(bool)
	end)
end

function impl:OnTimerBackCall(id)
	if id == 1001 then
		self.m_page = 0; 
		local text = self.m_EditBox:GetText()
		self:SearchUser(0,text)
	end
end

function impl:SetVisible(bool)
	kd.Node.SetVisible(self,bool)
	if bool and self.m_thView then
		DC:CallBack("AHomePageButtom.Show",false);
	end
end

function impl:OnActionEnd()
	if self:IsVisible() then
		print("打开")
	else
		if self.m_father:IsVisible() then
			DC:CallBack("AHomePageButtom.Show",true)
		end
		self:Clear()
	end
end

function impl:Clear()
	self.Scroll:DelAll()
	self.m_EditBox:SetText("")
end

function impl:GetEditText()
	return self.m_EditBox:GetText()
end

--[[
	
	"/michat/search"
	userid
	userkey
	keyword
	page
	成功消息：
	{
		Result bool
		IsEnd bool（是否最后一页）
		Data [
			{
				UserId int
				Nickname string
				AvatarFile string
				IsFocus bool
			},
			...
		]
	}
]]

--搜索用户
function impl:SearchUser(page,keyword)
	self.m_Destined = false
	local loadui = gSink:ShowLoading()
	loadui.mask:SetVisible(false)--不需要蒙版
	gSink:Post("michat/search",{page = page,keyword = keyword},function(data)
		if data.Result then
			self.m_txtFateYou:SetVisible(false);
			
			self:SetData(data)
		end
		loadui.mask:SetVisible(true)--恢复蒙版
		gSink:HideLoading()
	end,false);
end

function impl:SetData(data)
	if #data.Data == 0 then
		gSink:messagebox_default("暂无搜索结果")
	end
	
	self.IsEnd = data.IsEnd
	
	if self.m_page == 0 then
		self.Scroll:DelAll();
		self.m_data = data.Data
	else
		if #self.m_data > 0 then
			for k,v in ipairs(data.Data) do
				table.insert(self.m_data,v)
			end
		end
	end	
	for k,v in ipairs(data.Data) do
		local item = kd.class(SearchItem,false,false)
		item:init(self)
		item:SetData(v)
		self.Scroll:Add(item)
	end
	
	if self.m_page == 0 then
		self.Scroll:BackTopNoAni()
	end
end

--[[
	Result bool
    UserInfoList [
        {
            UserId int
            Nickname string
            AvatarFile string
            City string
        },
        ...
    ]

]]

function impl:SetDestined(data)
	self.m_Destined = true;
	for k,v in ipairs(data.UserInfoList) do
		local item = kd.class(SearchOpenItem,false,false)
		item:init(self)
		item:SetData(v)
		self.Scroll:Add(item)
		self.m_txtFateYou:SetVisible(true);
	end
	self.m_data = data.UserInfoList
end

