--[[
	首页底部
--]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AHomePageButtom = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_BIAOQIANLAN_LM           = 1001,		--	白色背景板
	ID_IMG_ML_MAIN_LM                  = 1002,		--	灰心
	ID_IMG_ML_MAIN_LM1                 = 1003,		--	灰色方块
	ID_IMG_ML_MAIN_LM2                 = 1004,		--	灰色铃铛
	ID_IMG_ML_MAIN_LM3                 = 1005,		--	灰色圆脸
	ID_IMG_ML_MAIN_LM4                 = 1006,		--	红心
	ID_IMG_ML_MAIN_LM5                 = 1007,		--	蓝色方块
	ID_IMG_ML_MAIN_LM6                 = 1008,		--	黄色铃铛
	ID_IMG_ML_MAIN_LM7                 = 1009,		--	粉色圆脸
	ID_IMG_ML_MAIN_LM8                 = 1010,		--	红点
};

--	动画数组		灰变颜色
local AniTab1 = {
	"AHomePageButtom.Ani1",	--	红心
	"AHomePageButtom.Ani2",	--	蓝方块
	"AHomePageButtom.Ani3",	--	黄铃铛
	"AHomePageButtom.Ani4"	--	粉笑脸
};	

--	动画数组		颜色变灰
local AniTab2 = {
	"AHomePageButtom.Ani5",	--	红心
	"AHomePageButtom.Ani6",	--	蓝方块
	"AHomePageButtom.Ani7",	--	黄铃铛
	"AHomePageButtom.Ani8"	--	粉笑脸
};		

-- 是否是登陆进来的
local isLogingIn = true;
	
function AHomePageButtom:init(father)
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/BiaoQianLan.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	self.m_heardBg = self.m_thView:GetSprite(idsw.ID_IMG_ML_BIAOQIANLAN_LM);
	local w,h = self.m_heardBg:GetWH()
	gDef.AHomePageButtomH = h

	--	用于记录上一次的底部索引值
	self.m_LastIndex = 0;	
	self.m_index = 0;			--	有色动画
	self.m_index1 = 0;			--	上一个动画索引
	-- 心
	self.m_heard = {
			spr1 = 0,							--	红心
			spr2 = 0,							--	灰心
			gui = 0,
			SetVisible = function(this,bVisible)
				this.spr1:SetVisible(bVisible);
				this.spr2:SetVisible(not bVisible);
			end,
			SetGuiEnable = function(this,bVisible)
				this.gui:SetEnable(bVisible);
			end
	};	
	self.m_heard.spr1 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM4);
	self.m_heard.spr2 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM);
	local x,y = self.m_heard.spr2:GetPos();
	self.m_heard.gui = gDef:AddGuiBySpr(self,self.m_heard.spr2,idsw.ID_IMG_ML_MAIN_LM,10,10,10,10);
	self.m_heard:SetVisible(false);
	
	--创建散图纹理做帧动画播放
	self.m_heardAni1 = kd.class(kd.AniMultipleImg,self,1,60);
	self.m_heardAni2 = kd.class(kd.AniMultipleImg,self,1,60);
	self:addChild(self.m_heardAni1);
	self:addChild(self.m_heardAni2);
	self.m_heardAni1:SetMode(0);
	self.m_heardAni2:SetMode(0);
	for i=0,29 do 
		local str1 = "ResAll/ML_DongXiao_LM/biaoqianlan/ML_Home_LM/"..i..".png";
		local str2 = "ResAll/ML_DongXiao_LM/biaoqianlan/ML_Home2_LM/"..i..".png";
		local spr1 = kd.class(kd.Sprite, str1);
		local spr2 = kd.class(kd.Sprite, str2);
		self.m_heardAni1:InstFrameSpr(spr1);
		self.m_heardAni2:InstFrameSpr(spr2);
	end
	
	self.m_heardAni1:SetPos(x,y);
	self.m_heardAni2:SetPos(x,y);
	
	DC:RegisterCallBack(AniTab1[1],self,function (bo)
		if bo then
			self.m_heardAni1:Play();
		else
			self.m_heardAni1:Stop();
		end
	end);
	--[[DC:RegisterCallBack(AniTab2[1],self,function (bo)
		if bo then
			self.m_heardAni2:Play();
		else
			self.m_heardAni2:Stop();
		end
	end)--]]

	-- 方块
	self.m_square = {
			spr1 = 0,							--	蓝色方块
			spr2 = 0,							--	灰色方块
			gui = 0,
			SetVisible = function(this,bVisible)
				this.spr1:SetVisible(bVisible);
				this.spr2:SetVisible(not bVisible);
			end,
			SetGuiEnable = function(this,bVisible)
				this.gui:SetEnable(bVisible);
			end
	};	
	self.m_square.spr1 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM5);
	self.m_square.spr2 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM1);
	local i,j = self.m_square.spr2:GetPos();
	self.m_square.gui = gDef:AddGuiBySpr(self,self.m_square.spr2,idsw.ID_IMG_ML_MAIN_LM1,10,10,10,10);
	self.m_square:SetVisible(false);
	
	--创建散图纹理做帧动画播放
	self.m_squareAni1 = kd.class(kd.AniMultipleImg,self,1,60);
	self.m_squareAni2 = kd.class(kd.AniMultipleImg,self,1,60);
	self:addChild(self.m_squareAni1);
	self:addChild(self.m_squareAni2);
	self.m_squareAni1:SetMode(0);
	self.m_squareAni2:SetMode(0);
	for i=0,29 do 
		local str3 = "ResAll/ML_DongXiao_LM/biaoqianlan/ML_Video_LM/"..i..".png";
		local str4 = "ResAll/ML_DongXiao_LM/biaoqianlan/ML_Video2_LM/"..i..".png";
		local spr3 = kd.class(kd.Sprite,str3);
		local spr4 = kd.class(kd.Sprite,str4);
		self.m_squareAni1:InstFrameSpr(spr3);
		self.m_squareAni2:InstFrameSpr(spr4);
	end
	
	self.m_squareAni1:SetPos(i,j);
	self.m_squareAni2:SetPos(i,j);
	
	DC:RegisterCallBack(AniTab1[2],self,function (bo)
		if bo then
			self.m_squareAni1:Play();
		else
			self.m_squareAni1:Stop();
		end
	end);
	--[[DC:RegisterCallBack(AniTab2[2],self,function (bo)
		if bo then
			self.m_squareAni2:Play();
		else
			self.m_squareAni2:Stop();
		end
	end)--]]
	
	-- 铃铛
	self.m_bell = {
			spr1 = 0,							--	黄色铃铛
			spr2 = 0,							--	灰色铃铛
			gui	= 0,
			SetVisible = function(this,bVisible)
				this.spr1:SetVisible(bVisible);
				this.spr2:SetVisible(not bVisible);
			end,
			SetGuiEnable = function(this,bVisible)
				this.gui:SetEnable(bVisible);
			end
	};	
	self.m_bell.spr1 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM6);
	self.m_bell.spr2 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM2);
	local a,b = self.m_bell.spr2:GetPos();
	self.m_bell.gui = gDef:AddGuiBySpr(self,self.m_bell.spr2,idsw.ID_IMG_ML_MAIN_LM2,10,10,10,10);
	self.m_bell:SetVisible(false);
	
	--创建散图纹理做帧动画播放
	self.m_bellAni1 = kd.class(kd.AniMultipleImg,self,1,60);
	self.m_bellAni2 = kd.class(kd.AniMultipleImg,self,1,60);
	self:addChild(self.m_bellAni1);
	self:addChild(self.m_bellAni2);
	self.m_bellAni1:SetMode(0);
	self.m_bellAni2:SetMode(0);
	for i=0,29 do 
		local str5 = "ResAll/ML_DongXiao_LM/biaoqianlan/ML_Message_LM/"..i..".png";
		local str6 = "ResAll/ML_DongXiao_LM/biaoqianlan/ML_Message2_LM/"..i..".png";
		local spr5 = kd.class(kd.Sprite, str5);
		local spr6 = kd.class(kd.Sprite, str6);
		self.m_bellAni1:InstFrameSpr(spr5);
		self.m_bellAni2:InstFrameSpr(spr6);
	end
	self.m_bellAni1:SetPos(a,b);
	self.m_bellAni2:SetPos(a,b);
	DC:RegisterCallBack(AniTab1[3],self,function (bo)
		if bo then
			self.m_bellAni1:Play();
		else
			self.m_bellAni1:Stop();
		end
	end);
	--[[DC:RegisterCallBack(AniTab2[3],self,function (bo)
		if bo then
			self.m_bellAni2:Play();
		else
			self.m_bellAni2:Stop();
		end
	end)--]]
	
	-- 圆脸
	self.m_face = {
			spr1 = 0,							--	粉色圆脸
			spr2 = 0,							--	灰色圆脸
			gui = 0,
			SetVisible = function(this,bVisible)
				this.spr1:SetVisible(bVisible);
				this.spr2:SetVisible(not bVisible);
			end,
			SetGuiEnable = function(this,bVisible)
				this.gui:SetEnable(bVisible);
			end
	};	
	self.m_face.spr1 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM7);
	self.m_face.spr2 = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM3);
	local m,n = self.m_face.spr2:GetPos();
	self.m_face.gui = gDef:AddGuiBySpr(self,self.m_face.spr2,idsw.ID_IMG_ML_MAIN_LM3,10,10,10,10);
	self.m_face:SetVisible(false);
	
	--创建散图纹理做帧动画播放
	self.m_faceAni1 = kd.class(kd.AniMultipleImg,self,1,60);
	self.m_faceAni2 = kd.class(kd.AniMultipleImg,self,1,60);
	self:addChild(self.m_faceAni1);
	self:addChild(self.m_faceAni2);
	self.m_faceAni1:SetMode(0);
	self.m_faceAni2:SetMode(0);
	for i=0,29 do 
		local str7 = "ResAll/ML_DongXiao_LM/biaoqianlan/ML_Me_LM/"..i..".png";
		local str8 = "ResAll/ML_DongXiao_LM/biaoqianlan/ML_Me2_LM/"..i..".png";
		local spr7 = kd.class(kd.Sprite,str7);
		local spr8 = kd.class(kd.Sprite,str8);
		self.m_faceAni1:InstFrameSpr(spr7);
		self.m_faceAni2:InstFrameSpr(spr8);
	end
	self.m_faceAni1:SetPos(m,n);
	self.m_faceAni2:SetPos(m,n);
	
	--未读红点
	self.m_UnreadSign = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM8);
	self.m_UnreadSign:SetVisible(false)
	DC:RegisterCallBack(AniTab1[4],self,function (bo)
		if bo then
			self.m_faceAni1:Play();
		else
			self.m_faceAni1:Stop();
		end
	end);
	--[[DC:RegisterCallBack(AniTab2[4],self,function (bo)
		if bo then
			self.m_faceAni2:Play();
		else
			self.m_faceAni2:Stop();
		end
	end)--]]
	
	--	4种图案列表
	self.m_Tab = {self.m_heard,self.m_square,self.m_bell,self.m_face};
	self.m_TabAni1 = {self.m_heardAni1,self.m_squareAni1,self.m_bellAni1,self.m_faceAni1};
	--self.m_TabAni2 = {self.m_heardAni2,self.m_squareAni2,self.m_bellAni2,self.m_faceAni2};
	
	--	注册数据中心
	DC:RegisterCallBack("AHomePageButtom.Show",self,function(bool)
		self:SetVisible(bool)
	end);
	
	--	注册数据中心
	DC:RegisterCallBack("AHomePageButtom.SetUnread",self,function(bool)
		self.m_UnreadSign:SetVisible(bool)
	end);
	
	--	注册数据中心
	DC:RegisterCallBack("AHomePageButtom.SwitchIcon",self,function(index)
		self:SwitchIcon(index)
	end);
	
	--	注册数据中心
	DC:RegisterCallBack("AHomePageButtom.isLogingIn",self,function(bo)
		isLogingIn = bo;
	end);
end

function AHomePageButtom:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

function AHomePageButtom:onTouchBegan(x,y)
	echo("底部菜单栏点击开始");
	if y> ScreenH - gDef.AHomePageButtomH then
		return true;
	end
	return false;
end

function AHomePageButtom:onTouchMoved(x,y)
	echo("底部菜单栏点击移动");
	return true;
end

function AHomePageButtom:onTouchEnded(x,y)
	echo("底部菜单栏点击结束");
	return true;
end

function AHomePageButtom:update(delta)
	if self.m_index ~= 0 and self.m_TabAni1[self.m_index]:IsPlaying()== false then
		self.m_TabAni1[self.m_index]:Stop();
		self.m_index = 0;
	end
	--[[if self.m_index1 ~=0 and self.m_TabAni2[self.m_index1]:IsPlaying()== false then
		self.m_TabAni2[self.m_index1]:Stop();
		self.m_index1 = 0;
	end--]]
end

--	只有灰色能点，蓝色不操作
function AHomePageButtom:onGuiToucBackCall(id)
	local index = 0;
	if id == idsw.ID_IMG_ML_MAIN_LM then				--	灰心
		echo("灰心");
		index  = 1;
	DC:CallBack("AHomePageView.HideMenu",2);
	DC:CallBack("AHomePageView.Show",true);				--	首页
	elseif id == idsw.ID_IMG_ML_MAIN_LM1 then			--	灰色方块
		echo("灰色方块");
		index  = 2;
	elseif id == idsw.ID_IMG_ML_MAIN_LM2 then			--	灰色铃铛
		echo("灰色铃铛");
		index  = 3;
		self:RedManage();
	elseif id == idsw.ID_IMG_ML_MAIN_LM3 then			--	灰色圆脸
		echo("灰色圆脸");	
		index = 4;
	end
	DC:CallBack("AHomePageMenu1.Show",false);
	DC:CallBack("AHomePageMenu2.Show", false);
	DC:CallBack("MessageListView.Show",index == 3)
	DC:CallBack("MyView.Show",index == 4)
	if index > 0 then
		self:SwitchIcon(index);
	end
end

-- 菜单栏切换
function AHomePageButtom:SwitchIcon(index)
	if index == nil then return;end
	--	页面切换发包
	self:OnSendRequestList(index);
	if isLogingIn then
		self.m_heard:SetVisible(true);
		isLogingIn = false;
		return ;
	end
	-- 先初始化为全灰
	for i=1,4 do
		self.m_Tab[i]:SetVisible(false);
		self.m_Tab[i]:SetGuiEnable(true);
		if i== index then
			DC:CallBack(AniTab1[i],true);
			DC:CallBack(AniTab2[i],false);
			self.m_Tab[i]:SetVisible(true);
			self.m_Tab[i]:SetGuiEnable(false);
		end
	end
	if self.m_LastIndex >0then
		DC:CallBack(AniTab1[self.m_LastIndex],false);
		DC:CallBack(AniTab2[self.m_LastIndex],true);
	end
	-- 记录当前索引
	self.m_index = index;
	self.m_index1 = self.m_LastIndex;
	-- 重置上一次索引
	if self.m_LastIndex ~= index then
		self.m_LastIndex = index;
	end
end


-- 展示图切换(请求列表发包)
function AHomePageButtom:OnSendRequestList(index)
	if index ==  1	then
		DC:CallBack("AHomePageView.OnRequestList","推荐",2)
		DC:FillData("AHomePageMenu1.IsSwitch",true);
	elseif index ==  2 then
		self:RequestHatelist(0);			--	请求黑名单列表
	elseif index == 3 then
		
	elseif index == 4 then	
		
	end
	DC:CallBack("ADynamicView.Show",index == 2);
end

-- 红点逻辑
function AHomePageButtom:RedManage(bool)
	echo("红点管理");
end


function AHomePageButtom:RequestHatelist(page)
	gSink:Post("michat/get-hatelist",{page = page},function(data)
		local tData = {};
		if data.Result then
				local num = 0;
				for i =1,#data.Data do
					tData[tostring(data.Data[i].UserId)]=data.Data[i]
					num = num + 1;
				end
				tData["num"] = num;
			if data.IsEnd == false then
				page = page+1;
				self:RequestHatelist(page);
			else
				DC:CallBack("ADynamicView.Reset");
				DC:CallBack("ADynamicTitle.SetTextScale",1);
			end
		end
	end)
end