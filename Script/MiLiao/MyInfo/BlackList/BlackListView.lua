--[[
	黑名单
]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;
local TweenPro = TweenPro
BlackListView = kd.inherit(kd.Layer);
local impl = BlackListView;

function impl:init(father)
	local thview = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/BeiJing.UI"), self);
	self:addChild(thview)
	self.m_father = father
	
	self.m_kongbai = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/KongBaiYe.UI"), self);
	self:addChild(self.m_kongbai)
	self.m_kongbai:GetText(4001):SetHAlignment(kd.TextHAlignment.CENTER);
	self.m_kongbai:GetText(4001):SetString("你的黑名单里还没有人哦~")
	self.m_kongbai:SetViewVisible(false)
	
	self.Title = kd.class(Title,false,true)
	self.Title:init(self)
	self.Title:SetTitle("黑名单")
	
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
	
	-- 获取模版
	self.Scroll.OnGetTemplate = function(this,index)
		return BlackListItem;
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
	
	self.Scroll:AddDownLoad(LoadUI)
	self.Scroll:AddUpLoad(LoadUI)
	
	DC:RegisterCallBack("BlackListView.RemoveTable",self,function (remove_id)
		local ListItems = self.Scroll.nodemap.Map
		local index = 0
		for k,v in ipairs(self.data) do
			if v.UserId == remove_id then
				index = k
				break;
			end
		end
		for k,v in ipairs(ListItems) do
			if v.UserId == remove_id then
				local actionitme = v
				self.aniHandler = TweenPro:Animate({
				{o = actionitme,x= -ScreenW,d = 500,tween=TweenPro.swing.easeOutCubic,fn = function()
					if index > 0 then
						self.Scroll:DelByIndex(index)
						local datasrcoll = self.Scroll:GetData()
						self.m_kongbai:SetViewVisible(#datasrcoll == 0)
					end
				end}
				})
			end		
		end		
	end);
	
	local x,y = self:GetPos();
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
end


function impl:SetPage(page)
	self.m_page = page
end

function impl:SendData(page)
	self:SetPage(page);
	gSink:Post("michat/get-hatelist",{page = page},function(data)
		if data.Result then
			self:SetData(data)
		end
	end)
end


--[[

获取黑名单
"/michat/get-hatelist"
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
		v.ty = 2
	end
	self.Scroll:SetData(self.data);
	self.m_kongbai:SetViewVisible(#self.data == 0)
	
	if self.m_page == 0 then
		self.Scroll:ToTop()
	end
end

function impl:SetVisible(bool)
	kd.Node.SetVisible(self,bool)
	if bool and self.Scroll then
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

