--[[
	搜索页面 与你有缘 列表子项
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

SearchOpenItem = kd.inherit(kd.Layer);
local impl = SearchOpenItem;
local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM2           = 1001,
	ID_IMG_ML_MAIN_LM3           = 1002,
	ID_IMG_ML_MAIN_LM4           = 1003,
	--/* Text ID */
	ID_TXT_NO0                   = 4001,
	ID_TXT_NO1                   = 4002,
	--/* Custom ID */
	ID_CUS_ML_TX145_LM           = 6001,
}

function impl:init(father)
	self.m_father = father
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/SYSouSuoLieBiao.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	self.m_sprBG = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM2);
	
	--名字 
	self.m_nickname = self.m_thView:GetText(idsw.ID_TXT_NO0)
	--头像
	self.m_cusFace = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_TX145_LM,nil,false,2);
	
	--位置
	self.m_sprLocation = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM3)
	self.m_txtLocation = self.m_thView:GetText(idsw.ID_TXT_NO1)
end

function impl:GetWH()
	local x,y = self.m_sprBG:GetPos();
	return ScreenW,y*2
end	

--[[
		UserId int
		Nickname string
		AvatarFile string
		City string
]]

--设置数据
function impl:SetData(data)
	self.UserId = data.UserId
	--头像
	self.m_cusFace:SetFace(gDef.domain .. data.AvatarFile);
	--设置名字
	local szName = gDef:GetName(data.Nickname,9)
	self.m_nickname:SetString(szName)
	--位置
	self.m_txtLocation:SetString(data.City)
	
	local len = gDef:GetTextLen(34,data.City);
	if len == 0 then
		len = 34*2
		self.m_txtLocation:SetString("未知")
	end
	local x,_ =  self.m_nickname:GetPos()
	local _,y =  self.m_txtLocation:GetPos()
	self.m_sprLocation:SetPos(x + len - 160,y)
end

function impl:onGuiToucBackCall(id)
	--关注
	if id == idsw.ID_IMG_ML_MAIN3_LM then
		echo("关注")
	--移除
	elseif id == idsw.ID_IMG_ML_MAIN_LM5 then
		echo("移除")
	elseif id == idsw.ID_CUS_ML_TX145_LM then
		
	end
end