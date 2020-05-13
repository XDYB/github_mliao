--[[

	评论 --滑动

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

CommentScroll = kd.inherit(kd.Layer);
local impl = CommentScroll;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

function impl:init(height, height2)
	-- 滑动视图
	self.m_ScrollView = kd.class(ScrollA, true, true);
	self:addChild(self.m_ScrollView);
	self.m_ScrollView:init(0,height,ScreenW,height2);
	self.m_ScrollView:AddDownLoad(LoadUI);
	self.m_ScrollView:AddUpLoad(LoadDown);
	-- 下拉
	self.m_ScrollView.OnDown = function(this)
		this:Cls();
		self.m_numPage = 0;
		self:get_commentlist(0);
	end
	-- 上拉
	self.m_ScrollView.OnUp = function(this)
		if not self.m_boIsEnd then
			self:get_commentlist(self.m_numPage + 1);
		else
			this:BackPos();
			self.m_ScrollView:NoMore()
		end
	end
	
	self:initView();
	
	DC:RegisterCallBack("CommentScroll.get_commentlist",self,function (id)
		self:initView();
		self:SetDynamicid(id);
		self:get_commentlist(0);
	end);
	
	DC:RegisterCallBack("CommentScroll.updateComment",self,function ()
		self:get_commentlist(0);
	end);
end

function impl:SetViewData(data)
	
end

function impl:SetDynamicid(id)
	self.m_dynamicid = id;
end

function impl:initView()
	self.m_dynamicid = 0;
	self.m_numPage = 0;
	-- 数据是否结束
	self.m_boIsEnd = false;
	self.m_ScrollView:DelAll();
	self.m_ScrollView:Cls();
	self.m_ScrollView:BackTop();
end

function impl:get_commentlist(page)
	gSink:Post("michat/get-commentlist",{dynamicid = self.m_dynamicid,page = page},function(data)
		if data.Result then
			--[[local tab = {};
			local it = {Cdate = 1588062307, Content = "阿萨德法师打发打发打发打发打的费发打的费发打的费发打的费", AvatarFile = "michat/up/dynamic/video/18.png", NickName = "我是谁"}
			for i=1,7 do
				table.insert(tab, it);
			end
			self:AddItem(tab);--]]
			if page == 0 then
				self.m_ScrollView:DelAll();
				self.m_ScrollView:Cls();
				self.m_numData = 0;
			end
			self:AddItem(data.Data);
			self.m_boIsEnd = data.IsEnd;
			self.m_numPage = page;
			
			self.m_numData = self.m_numData + #data.Data;
			DC:CallBack("PlayView.UpdteCommentNum", self.m_numData);
		else
			gSink:messagebox_default(data.ErrMsg);
		end
	end);
end

function impl:AddItem(data)
	local bo = self:IsVisible();
	if bo then
		for i=1,#data do
			local item = kd.class(CommentItem, false, false);
			item:init(data[i]);
			self.m_ScrollView:Add(item);
		end
		DC:CallBack("Comments.HaveComment", #data);
	end
end
