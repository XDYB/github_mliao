--[[
	首页头部
--]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AHomePageTitle = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM2           = 1001,
	ID_IMG_ML_MAIN_LM3           = 1002,
	ID_IMG_ML_MAIN_LM4           = 1003,		--	九宫格切换
	ID_IMG_ML_MAIN_LM5           = 1004,		--	咪一下按钮
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
};
-- 文字颜色
local TxtTab = { 	[1] = "关注",		--	关注
					[2] = "推荐",		--	推荐
					[3] = "新人",		--	新人
					[4] = "唱歌",		--	唱歌
					[5] = "跳舞",		--	跳舞
					[6] = "颜值" 		--	颜值
				};
function AHomePageTitle:init(father)

	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/SYTouBu2.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--	初始为1张图
	self.m_index  = 1;		
	
	--	九宫格按钮，图标切换
	self.m_Sudoku =	self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM4);
	self.m_Sudoku:SetTextureRect(639,1954,95,79);
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM4,10,10,10,10);
	
	-- 	咪一下按钮
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM5,10,640,10,50);

	--	注册数据中心
	DC:FillData("AHomePageTitle.Index", self.m_index);
end

function AHomePageTitle:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

function AHomePageTitle:onTouchBegan(x,y)
	echo("顶部菜单栏点击开始");
	if y< 210 then
		return true;
	end
	return false;
end

function AHomePageTitle:onTouchMoved(x,y)
	echo("顶部菜单栏点击移动");
	return true;
end

function AHomePageTitle:onTouchEnded(x,y)
	echo("顶部菜单栏点击结束");
	return true;
end

-- 与你有缘
function AHomePageTitle:Destined()
	gSink:Post("michat/destined",{},function(data)
		if data.Result then
			DC:CallBack("SearchView.Show",true,data)
		end
	end);
end

--	UI
function AHomePageTitle:onGuiToucBackCall(id)
	if id == idsw.ID_IMG_ML_MAIN_LM4 then				--	九宫格切换按钮
		echo("九宫格切换");
		self:SwitchIcon(self.m_index);
	elseif id == idsw.ID_IMG_ML_MAIN_LM5 then			--	眯一下搜索按钮
		echo("眯一下搜索按钮");
		self:Destined()
	end
	DC:CallBack("AHomePageMenu1.Show", false);
	DC:CallBack("AHomePageMenu2.Show", false);
	DC:CallBack("AHomePageMenu3.Show", false);
	DC:CallBack("AHomePageMenu4.Show", false);
	DC:CallBack("AHomePageMenu5.Show", false);
	DC:CallBack("AHomePageMenu6.Show", false);
end

-- 九宫格格图标切换
function AHomePageTitle:SwitchIcon(index)
	if index == 1 then
		self.m_index = 2;
		self.m_Sudoku:SetTextureRect(736,1954,95,79);
	elseif index ==  2 then
		self.m_index = 1;
		self.m_Sudoku:SetTextureRect(639,1954,95,79);
	end
	DC:FillData("AHomePageTitle.Index", self.m_index);
	local nIndex = DC:GetData("AHomePageView.Index");
	DC:CallBack("AHomePageView.OnRequestList",TxtTab[nIndex],nIndex);
end