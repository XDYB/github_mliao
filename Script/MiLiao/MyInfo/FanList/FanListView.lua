--[[
	粉丝列表
]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

FanListView = kd.inherit(kd.Layer);
local impl = FanListView;

function impl:init(father)
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/BeiJing.UI"), self);
	self:addChild(self.m_thView)
	self.m_father = father
	
	self.m_kongbai = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/KongBaiYe.UI"), self);
	self:addChild(self.m_kongbai)
	self.m_kongbai:GetText(4001):SetHAlignment(kd.TextHAlignment.CENTER);
	self.m_kongbai:GetText(4001):SetString("你的粉丝里还没有人哦~")
	self.m_kongbai:SetViewVisible(false)
	
	self.Title = kd.class(Title,false,true)
	self.Title:init(self)
	self.Title:SetTitle("粉丝")
	
	self.Scroll = kd.class(ScrollEx,true,true)
	local headH = self.Title:GetH();
	self.Scroll:init(0,headH,ScreenW,ScreenH - headH)
	self:addChild(self.Scroll)
	self:addChild(self.Title)
	self.Title.onTouchBegan = function (this,x,y)
		if y > headH then
			return false
		else
			return true
		end
	end
--	self.Scroll:ShowBorder()
	
	self.Scroll.OnGetTemplate = function(this,index)
		return BlackListItem;
	end
	
	self.Scroll:AddDownLoad(LoadUI)
	self.Scroll:AddUpLoad(LoadUI)
	
	self.Scroll.OnClick = function(this,index)
		echo("==========index"..index)
		
	end
	
	self.Scroll.OnUp = function(this)
		echo("==========上拉")
		if self.IsEnd  == false then
			self.m_page = self.m_page + 1
			self:SendData(self.m_page)
		end
		this:BackPos() -- 复位
	end

	self.Scroll.OnDown = function(this)
		echo("==========下拉")
		self:Clear()
		self:SendData(0)
		this:BackPos() -- 复位
	end
	
	self.m_page = 0
	
	local x,y = self:GetPos();
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	
	DC:RegisterCallBack("FanListView.DelBlackItem",self,function(id)
		if self:IsVisible() then
			for k,v in ipairs(self.data) do
				if v.UserId == id then
					self.Scroll:DelByIndex(k)
					break
				end
			end
			self.m_kongbai:SetViewVisible(#self.data == 0)
		end
	end)
end

function impl:SetPage(page)
	self.m_page = page
end

function impl:SendData(page)
	self:SetPage(page);
	gSink:Post("michat/get-fanslist",{page = page},function(data)
		if data.Result then
			self:SetData(data)
		end
	end)
end


--[[

获取粉丝列表
"/michat/get-fanslist"
userid
userkey
page
成功消息：
{
    Result bool
    IsEnd bool（是否最后一页）
    Data [
        {
            UserId	int
            NickName	string
            Avatar	string
            Signature	string（个性签名）
            IsFocus	bool
        },
        ...
    ]
}

]]

function impl:SetData(data)
	self.IsEnd = data.IsEnd
	if self.m_page == 0 then
		self.data = data.Data
	elseif self.m_page > 0 then
		for k,v in ipairs(data.Data) do
			table.insert(self.data,v)
		end
	end
	
	for k,v in ipairs(data.Data) do
		v.ty = 1
	end
	self.Scroll:SetData(self.data);
	self.m_kongbai:SetViewVisible(#self.data == 0)
	
	if self.m_page == 0 then
		self.Scroll:ToTop()
	end
end

function impl:SetVisible(bool)
	kd.Node.SetVisible(self,bool)
	if bool and self.m_thView then
		DC:CallBack("AHomePageButtom.Show",false)
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
	self.data = nil
end


