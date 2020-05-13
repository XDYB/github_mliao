--[[
	首页大图
--]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AHomePageBigMap = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_ZHUYEXIAZHEZHAO_LM           = 1001,
	ID_IMG_ML_MAIN_LM                      = 1002,		--	认证图标
	ID_IMG_ML_MAIN_LM1                     = 1003,		--	性别图标
	--/* Text ID */
	ID_TXT_NO0                             = 4001,		--	昵称
	ID_TXT_NO1                             = 4002,		--	签名
	ID_TXT_NO2                             = 4003,		--	年龄
	--/* Custom ID */
	ID_CUS_ML_DIKUANG2_LM                  = 6001,		--	图片
};

function AHomePageBigMap:init(father)

	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/SYLieBiao.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--	用户昵称
	self.m_nickName = self.m_thView:GetText(idsw.ID_TXT_NO0);
	self.m_nickName:SetHAlignment(kd.TextHAlignment.LEFT);
	local a,b = self.m_nickName:GetPos();
	self.m_nickName:SetPos(a,b);
	
	--	签名
	self.m_sign = self.m_thView:GetText(idsw.ID_TXT_NO1);
	self.m_sign:SetHAlignment(kd.TextHAlignment.LEFT);
	local x,y = self.m_sign:GetPos();
	self.m_sign:SetPos(x+10,y);
	
	--	年龄
	self.m_age = self.m_thView:GetText(idsw.ID_TXT_NO2);
	
	--	性别图标
	self.m_Sex = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM1);
	
	--	认证图标
	self.m_certification = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM);
	
	-- 	临时数据
	self.m_data = nil;
end

function AHomePageBigMap:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

--	数据分发
function AHomePageBigMap:SetData(data)
	if data ==  nil or data == 0 then return;end
	self.m_data = data;
	self:SetUserFace(data.CoverUrl);					-- 	设置头像
	self:SetName(data.NickName);						--	用户昵称
	self:SetSex(data.Sex)								--	用户性别
	self:SetSign(data.Introduce)						--	签名
	self:SetAge(data.Age);								--	年龄
	self:SetCertification(data.Certification);			--	认证图标
end

--	设置头像
function AHomePageBigMap:SetUserFace(url)
	if self.avatar then
		self.avatar:Del()
		self.avatar = nil
	end
	if url  ==  nil then return;end
	local _,_,w,h = self.m_thView:GetScaleRect(idsw.ID_CUS_ML_DIKUANG2_LM)
	self.avatar = gDef:SetAvatarA(self.m_thView,idsw.ID_CUS_ML_DIKUANG2_LM,w,h,gDef.domain..url)
end

--	用户昵称
function AHomePageBigMap:SetName(name)
	if name ==  nil then return;end
	name = gDef:GetName(string.format("%s",name),5)
	self.m_nickName:SetString(name);
end

--	签名1
function AHomePageBigMap:SetSign(sign)
	if sign ==  nil then return;end
	self.m_sign:SetString(sign);
end

--	年龄
function AHomePageBigMap:SetAge(age)
	if age ==  nil then return;end
	self.m_age:SetString(age);
end

--	性别图标
function AHomePageBigMap:SetSex(index)
	if index ==  nil then return;end
	if index == 1 then
		self.m_Sex:SetTextureRect(1797,1597,115,49);
		elseif index == 0 then
		self.m_Sex:SetTextureRect(1914,1597,115,49);
	end
end

--	认证图标
function AHomePageBigMap:SetCertification(index)
	if index ==  nil then return;end
	local m,n = self.m_certification:GetPos();
	self.m_certification:SetPos(m-260,n);
	self.m_certification:SetVisible(index == 1);
	
	if index == 1 then
		local list = {self.m_nickName,self.m_certification}
		gDef:Layout(list,80,n,30,1,70)
	end
end

--	模板高度
function AHomePageBigMap:GetWH()
	return ScreenW,1040;
end