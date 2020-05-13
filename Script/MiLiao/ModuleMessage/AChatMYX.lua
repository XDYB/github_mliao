--眯一下 聊天顶部卡片
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

AChatMYX = kd.inherit(kd.Layer);
local impl = AChatMYX;

local idws =
{
	--/* Image ID */
	ID_IMG_ML_PIPEIJIEGUOBG_LM           = 1001,
	ID_IMG_ML_MAIN_LM0                   = 1002,
	ID_IMG_ML_MAIN3_LM                   = 1003,
	ID_IMG_ML_MAIN2_LM3                  = 1004,
	ID_IMG_ML_MAIN2_LM4                  = 1005,
	ID_IMG_ML_MAIN2_LM5                  = 1006,
	--/* Text ID */
	ID_TXT_NO0                           = 4001,
	--/* Custom ID */
	ID_CUS_ML_MAIN3_LM                   = 6001,
	ID_CUS_ML_MAIN_LM0                   = 6002,
}


function impl:init(datar,tp)
	local cusdata = datar.custom_elem_data
	local data = kd.CJson.DeCode(cusdata)
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/MYXPiPeiLiaoTian.UI"), self);
	self:addChild(self.m_thView)
	
	self.m_tp = tp -- 1 表示 自己主动发起眯一下 2 对方
	local cname = DC:GetData("AChat.Cname")
	--头像
	--[[local avatar_me = nil
	local avatar_2 = nil
	if avatars then
		avatar_me = avatars[1]
		avatar_2 = avatars[2]
	end
	--]]
	local avatar_me = DC:GetData("MyView.AvatarFile");
	local avatar_2 = DC:GetData("AChat.right_avater")
	
	self.m_cusleftFace = gDef:SetFaceForGame(self,idws.ID_CUS_ML_MAIN3_LM,avatar_me,false,2);
	self.m_cusrightFace = gDef:SetFaceForGame(self,idws.ID_CUS_ML_MAIN_LM0,avatar_2,false,2);
	
	--5个默契属性
	self.m_txtTitle = self.m_thView:GetText(idws.ID_TXT_NO0);
	self.m_txtTitle:SetHAlignment(kd.TextHAlignment.CENTER);
	
	self.m_sprCircle = self.m_thView:GetSprite(idws.ID_IMG_ML_MAIN3_LM);
	local x,y = self.m_sprCircle:GetPos()
	if type(data.TagsList) == "table" then
		self.m_txtTitle:SetString(#data.TagsList .. "个默契属性")
		local xlen = 0
		for k,v in ipairs(data.TagsList) do
			local item = kd.class(ACharMYXLable,false,false)
			item:init(v)
			self:addChild(item)
			item:SetPos(x - 180 + xlen ,y + 150 + ScreenH)
			xlen = xlen + item:GetWH()
		end
	end
	
	self.m_sprBG = self.m_thView:GetSprite(idws.ID_IMG_ML_PIPEIJIEGUOBG_LM);
	
	--提示背景
	self.m_sprtibgCenter = self.m_thView:GetSprite(idws.ID_IMG_ML_MAIN2_LM4);
	local x,y = self.m_sprtibgCenter:GetPos()
	
	-- 创建文字
	self.m_txt = kd.class(kd.StaticText,35,"---",kd.TextHAlignment.CENTER,ScreenW,40);
	self:addChild(self.m_txt);
	self.m_txt:SetColor(0xffffffff);
	self.m_txt:SetPos(x,y)
	
	self.m_data = data;
	
	-- 左
	self.m_sprLeft = self.m_thView:GetSprite(idws.ID_IMG_ML_MAIN2_LM3);
	-- 中
	self.m_sprCenter = self.m_thView:GetSprite(idws.ID_IMG_ML_MAIN2_LM4);
	-- 右
	self.m_sprRight = self.m_thView:GetSprite(idws.ID_IMG_ML_MAIN2_LM5);
	
	if tp == 1 then
		self:SetLabelData("我开启了聊天，聊点什么内容呢~")
	elseif tp == 2 then
		local name = cname or ""
		self:SetLabelData(name .. "开启聊天，打个招呼吧~")
	end
end

-- 设置文本
function impl:SetLabelData(str)
	self.m_txt:SetString(str);
	len = gDef:GetTextLen(35,str);
	local wc,hc = self.m_sprCenter:GetWH();
	self.m_sprCenter:SetScale(len/wc, 1);
	-- 计算中间位置的坐标
	local lx,ly = self.m_sprLeft:GetPos();
	local rx,ry = self.m_sprRight:GetPos();
	local wl,hl = self.m_sprLeft:GetWH();
	local wr,hr = self.m_sprRight:GetWH();
	--self.m_sprCenter:SetPos(x+wl/2+len/2, y);
	--self.m_txt:SetPos(x+wl/2+len/2, y);
	-- 设置右边位置的坐标
	--self.m_sprRight:SetPos(x+wl+len, y);
	
	--local cx,cy = self.m_sprCenter:GetPos()
	--local offset = cx - ScreenW/2
	self.m_sprCenter:SetPos(ScreenW/2,ly)
	self.m_txt:SetPos(ScreenW/2, ly);
	
	--local lx,ly = self.m_sprLeft:GetPos();
	self.m_sprLeft:SetPos(ScreenW/2 - len/2 - wl/2,ly);
	
	--local rx,ry = self.m_sprRight:GetPos();
	self.m_sprRight:SetPos(ScreenW/2 + len/2 + wr/2,ly);
	
	
end


function impl:Cls()

end

function impl:GetWH()
	local x,y = self.m_sprBG:GetPos();
	return ScreenW,y*2 + 70
end

function impl:SetTitle(str)
	self.m_txtTitle:SetString(str)
end

function impl:onGuiToucBackCall(id)
	
end
