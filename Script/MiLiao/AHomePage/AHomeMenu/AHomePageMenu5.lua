--[[
	首页头部选项卡
--]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AHomePageMenu5 = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	--/* Image ID */
	ID_IMG_ML_MAIN_LM2            = 1001,	
	ID_IMG_ML_MAIN_LM5            = 1002,	--	关注图标
	ID_IMG_ML_MAIN_LM6            = 1003,	--	推荐图标
	ID_IMG_ML_MAIN_LM7            = 1004,	--	新人图标
	ID_IMG_ML_MAIN_LM8            = 1005,	--	唱歌图标
	ID_IMG_ML_MAIN_LM9            = 1006,	--	跳舞图标
	ID_IMG_ML_MAIN_LM10           = 1007,	--	颜值图标
	--/* Text ID */
	ID_TXT_NO0                    = 4001,	--	关注
	ID_TXT_NO1                    = 4002,	--	推荐
	ID_TXT_NO2                    = 4003,	--	新人
	ID_TXT_NO3                    = 4004,	--	唱歌
	ID_TXT_NO4                    = 4005,	--	跳舞
	ID_TXT_NO5                    = 4006,	--	颜值
};

-- 文字颜色、
local colorTab = {  [1] = 0xffA082FD,			--	关注
					[2] = 0xffFDC331,			--	推荐
					[3] = 0xffFC86DF,			--	新人
					[4] = 0xff64CCFB,			--	唱歌
					[5] = 0xff4CEB7E,			--	跳舞
					[6] = 0xffFAADFF 			--	颜值
				};
-- 文字
local TxtTab = {  	[1] = "关注",		--	关注
					[2] = "推荐",		--	推荐
					[3] = "新人",		--	新人
					[4] = "唱歌",		--	唱歌
					[5] = "跳舞",		--	跳舞
					[6] = "颜值" 		--	颜值
				};

--	X适配
local x_Ip = 0;
if gDef.IphoneXView then
	x_Ip = 50;
end


function AHomePageMenu5:init()
	
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/SYFenQu.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	self.m_Index = 0;			--	首页九宫格状态值
	self.m_photo = {};			--	图标列表
	self.m_txt = {};			--	图标文字
	
	self.m_photo[1] = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM5);
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM5,10,10,10,10);
	self.m_txt[1] = self.m_thView:GetText(idsw.ID_TXT_NO0);
	
	self.m_photo[2] = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM6);
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM6,10,10,10,10);
	self.m_txt[2] = self.m_thView:GetText(idsw.ID_TXT_NO1);
	
	self.m_photo[3] = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM7);
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM7,10,10,10,10);
	self.m_txt[3] = self.m_thView:GetText(idsw.ID_TXT_NO2);
	
	self.m_photo[4] = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM8);
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM8,10,10,10,10);
	self.m_txt[4] = self.m_thView:GetText(idsw.ID_TXT_NO3);
	
	self.m_photo[5] = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM9);
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM9,10,10,10,10);
	self.m_txt[5] = self.m_thView:GetText(idsw.ID_TXT_NO4);
	
	self.m_photo[6] = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM10);
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM10,10,10,10,10);
	self.m_txt[6] = self.m_thView:GetText(idsw.ID_TXT_NO5);

	self.m_sprBG = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM2);
	
	--	注册数据中心
	DC:RegisterCallBack("AHomePageMenu5.Show",self,function(bool)
		self:SetVisible(bool)
	end);
	
	self.m_IsSwitch = true;
	DC:FillData("AHomePageMenu5.SetIsSwitch",self.m_IsSwitch);

	--	是否悬浮
	self.m_IsSuspend = false;
	DC:FillData("AHomePageMenu5.IsSuspend",self.m_IsSuspend);
	
	--	注册数据中心
	DC:RegisterCallBack("AHomePageMenu5.SwitchTextColor",self,function(index)
		if index ~= nil then
			self:SwitchTextColor(index);
		end
	end);
end

function AHomePageMenu5:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

function AHomePageMenu5:onTouchBegan(x,y)
	echo("顶部菜单栏点击开始");
	local w,h = self.m_sprBG:GetWH();
	if y< 430+h - x_Ip and y>200+h+x_Ip then
		return true;
	end
	return false;
end

function AHomePageMenu5:onTouchMoved(x,y)
	echo("顶部菜单栏点击移动");
	return true;
end

function AHomePageMenu5:onTouchEnded(x,y)
	echo("顶部菜单栏点击结束");
	return true;
end

--	点击事件
function AHomePageMenu5:onGuiToucBackCall(id)
	local index = 0;
	if id == idsw.ID_IMG_ML_MAIN_LM5 then				--	关注
		echo("关注");
		index = 1;
	elseif id == idsw.ID_IMG_ML_MAIN_LM6 then			--	推荐
		echo("推荐");
		index = 2;
	elseif id == idsw.ID_IMG_ML_MAIN_LM7 then			--	新人
		echo("新人");
		index = 3;
	elseif id == idsw.ID_IMG_ML_MAIN_LM8 then			--	唱歌
		echo("唱歌");
		index = 4;
	elseif id == idsw.ID_IMG_ML_MAIN_LM9 then			--	跳舞
		echo("跳舞");
		index = 5;
	elseif id == idsw.ID_IMG_ML_MAIN_LM10 then			--	颜值
		echo("颜值");
		index = 6;
	end
	-- 切换文字颜色
	if index >0 then
		self:GetIndex();				--	获取九宫格状态值
		DC:CallBack("AHomePageView.OnRequestList",TxtTab[index],index);
		DC:CallBack("AHomePageMenu5.Show",false);
		DC:CallBack("AHomePageView.HideMenu",index);
	end
end

-- 切换文字颜色
function AHomePageMenu5:SwitchTextColor(index)
	if index ==  nil or index < 0 then return;end
	for i = 1,6 do
		self.m_txt[i]:SetColor(0xff353235);
	end
	self.m_txt[index]:SetColor(colorTab[index]);
end

--	获取九宫格状态值
function AHomePageMenu5:GetIndex()
	self.m_Index = DC:GetData("AHomePageTitle.Index");
end

function AHomePageMenu5:SetData(data)

end

function AHomePageMenu5:SetIsSwitch(bvisible)
	DC:FillData("AHomePageMenu5.IsSwitch",bvisible);
end

--	模板高度
function AHomePageMenu5:GetWH()
	return ScreenW,240;
end