--[[
	提交子项
--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

SubmitItem = kd.inherit(kd.Layer);
local impl = SubmitItem;
local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM            = 1001,
	ID_IMG_ML_MAIN_LM1           = 1002,
	--/* Button ID */
	ID_BTN_ML_MAIN_LM            = 3001,
	--/* Text ID */
	ID_TXT_NO3                   = 4001,
	ID_TXT_NO4                   = 4002,
}

function impl:init(father)
	self.m_father = father
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/GFRenZhengDiBu1.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	self.m_sprbg = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM);
	
	self.m_btnOk = self.m_thView:GetButton(idsw.ID_BTN_ML_MAIN_LM);
	self.m_btnOk:SetEnable(true)
end

function impl:GetWH()
	local x,y = self.m_sprbg:GetPos();
	return ScreenW,y*2;
end

function impl:onGuiToucBackCall(id)
	if id == idsw.ID_BTN_ML_MAIN_LM then
		if self.m_father:IsPhotoOk() then
			local bsubmit =  self.m_father:CheckSubmit()
			if bsubmit then
				self.m_father:SubmitPhotos();
			else
				gSink:messagebox_default("需要完善全部资料哦~");
			end
		else
			gSink:messagebox_default("至少要提交一张照片哦~");
		end
	end
end

function impl:SetSubmitEable(bool)
	self.m_btnOk:SetEnable(bool)
end


