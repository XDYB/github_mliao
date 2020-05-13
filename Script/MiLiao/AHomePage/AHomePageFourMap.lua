--[[
	首页四张小图
--]]

local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

AHomePageFourMap = kd.inherit(kd.Layer);

local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_ZHUYEXIAZHEZHAO_LM           = 1001,
	ID_IMG_ML_MAIN_LM                      = 1002,
	ID_IMG_ML_MAIN_LM1                     = 1003,
	--/* Text ID */
	ID_TXT_NO0                             = 4001,
	ID_TXT_NO1                             = 4002,
	ID_TXT_NO2                             = 4003,
	--/* Custom ID */
	ID_CUS_ML_DIKUANG2_LM                  = 6001,			--	头像
};

function AHomePageFourMap:init(father)

	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/SYLieBiao2.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--	背景
	self.m_BG = self.m_thView:GetSprite(idsw.ID_IMG_ML_ZHUYEXIAZHEZHAO_LM);
	local x,y = self.m_BG:GetPos();
	
	--	用户昵称
	self.m_nickName = self.m_thView:GetText(idsw.ID_TXT_NO0);
	local x,y = self.m_nickName:GetPos();
	
	--	签名
	self.m_sign = self.m_thView:GetText(idsw.ID_TXT_NO1);
	local x,y = self.m_sign:GetPos();
	
	--	年龄
	self.m_age = self.m_thView:GetText(idsw.ID_TXT_NO2);
	local x,y = self.m_age:GetPos();
	
	--	性别图标
	self.m_Sex = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM1);
	local x,y = self.m_Sex:GetPos();
	
	--	认证图标
	self.m_certification = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM);
	local x,y = self.m_certification:GetPos();	

	--	临时数据
	self.m_data  = nil;
end

function AHomePageFourMap:SetVisible(visible)
	kd.Node.SetVisible(self, visible);
end

--	数据分发
function AHomePageFourMap:SetData(data)
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
function AHomePageFourMap:SetUserFace(face)
	if self.avatar then
		self.avatar:Del()
		self.avatar = nil
	end
	if face  ==  nil then return;end
	local _,_,w,h = self.m_thView:GetScaleRect(idsw.ID_CUS_ML_DIKUANG2_LM)
	self.avatar = self:SetAvatar(self.m_thView,idsw.ID_CUS_ML_DIKUANG2_LM,w,h,gDef.domain..face);
end

--	用户昵称
function AHomePageFourMap:SetName(name)
	if name ==  nil then return;end
	name = gDef:GetName(string.format("%s",name),5)
	self.m_nickName:SetString(name);
end

--	签名
function AHomePageFourMap:SetSign(sign)
	if sign ==  nil then return;end
	self.m_sign:SetString(sign);
end

--	年龄
function AHomePageFourMap:SetAge(age)
	if age ==  nil then return;end
	self.m_age:SetString(age);
end

--	性别图标
function AHomePageFourMap:SetSex(index)
	if index ==  nil then return;end
	if index == 1 then
		self.m_Sex:SetTextureRect(1797,1597,115,49);
	elseif index == 0 then
		self.m_Sex:SetTextureRect(1914,1597,115,49);
	end
end


--	认证图标
function AHomePageFourMap:SetCertification(index)
	if index ==  nil then return;end
	local m,n = self.m_certification:GetPos();
	self.m_certification:SetPos(m-120,n);

	self.m_certification:SetVisible(index == 1);
	
	if index == 1 then
		local list = {self.m_nickName,self.m_certification}
		gDef:Layout(list,40,n,5,1,35)
	end
end

--	模板高度
function AHomePageFourMap:GetWH()
	return ScreenW/2,600;
end

-- 设置最近定义缩放图片
-- @thview 
-- @id 	自定义层ID
-- @w 	头像宽度
-- @url 图片路径 
function AHomePageFourMap:SetAvatar(thview,id,w,h,url)
	local px,py,pw,ph = thview:GetScaleRect(id);
	local maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Dikuang3.png"));
	local maskSprW,maskSprH = maskSpr:GetWH()
	-- 缩放蒙板
	local maskScale = GetAdapterScale(maskSprW,maskSprH,w,h)
	maskSpr:SetScale(maskScale,maskScale)
	maskSpr:SetPos(px,py)

	local obj = {}
	
	obj.gui = kd.class(kd.GuiObjectNew,thview,1,px-w/2,py-h/2,w,h);
	obj.gui:setDebugMode(true)
	obj.gui:setMaskingClipping(maskSpr);
	thview:SetCustomRes(id,obj.gui);

	-- ============================
	-- 远程图片1
	-- ============================
	if url then
		
		obj.img =  kd.class(kd.AsyncSprite,url);
		obj.gui:addChild(obj.img)
		obj.img:SetPos(px,py)
		obj.img.OnLoadTextrue = function(this,err_code ,err_info)
			if obj.img == nil then return end
			if err_code == 0 then
				local _w,_h = this:GetTexWH();
				local scale = GetAdapterScale(_w,_h,w,h)
				this:SetScale(scale,scale)
			else
				obj.img = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Dikuang3.png"));
				obj.gui:addChild(obj.img)
				obj.img:SetPos(px,py)
				local scale = GetAdapterScale(199,199,w,h)
				obj.img:SetScale(scale,scale)
			end
		end
	end
	obj.Del = function()
		thview:DelCustomRes(id, obj.gui);
		obj.img = nil
	end
	obj.SetRot = function(this,x)
		if x>=360 then x = 0 end
		obj.img:SetRotation(x)
	end
	obj.GetRot = function(this)
		return obj.img:GetRotation()
	end
	obj.SetVisible = function(this,bool)
		obj.gui:SetVisible(bool)
		obj.img:SetVisible(bool)
	end
	return obj;
end