--[[

相册选择子项

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

PhotoItem = kd.inherit(kd.Layer);
local impl = PhotoItem;
local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM            = 1001,
	ID_IMG_ML_MAIN_LM1           = 1002,
	--/* Custom ID */
	ID_CUS_ML_TX321_LM           = 6001,
}

function impl:init(father,index)
	self.m_father = father
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/GFRenZhengXiangCe.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	local bClick = false
	if index == 1 then
		bClick = true
	end
	--头像
	self.m_cusFace = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_TX321_LM,nil,bClick,4);
	--加号
	self.m_sprAddicon = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM);
	self.m_brnClose = gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM1,0,0,0,0)
end

function impl:SetIndex(index)
	self.m_index = index
end

function impl:GetWH()
	local w,h = self.m_sprAddicon:GetWH();
	return w + 14,h + 14;
end

function impl:onGuiToucBackCall(id)
	-- 相册 
	if id == idsw.ID_CUS_ML_TX321_LM then
		echo("打开相册")
		local localtime = kd.GetLocalTime();
			self.m_imgLoadUpFace = string.format("%u%04d%02d%02d%02d%02d%02d.jpg",
								--[[gSink:GetMeUserID()--]]12364,localtime.Year,localtime.Month, 
								localtime.Day,localtime.Hour,localtime.Minute,localtime.Second);
		gSink:OpenPhotoGetJPEG(0,"LocalFile/UserFace/", self.m_imgLoadUpFace, 180,self);
		
	elseif id == idsw.ID_IMG_ML_MAIN_LM1 then
		self:SetTimer(1010,500,1);
	end
end

--设置首个是否显示X
function impl:SetDleSpr(bool)
	self.m_brnClose:SetVisible(bool)
end

--删除照片
function impl:DelecPhoto()
	self.m_cusFace:SetFace();
	self.m_cusFace.clickGui:SetEnable(true);
end

function impl:OnTimerBackCall(id)
	if id == 1010 then
		self.m_father:delPhoto(self);
		DC:CallBack("OfficialCertification.CheckSubmit")
	end
end

--[[
			Id		int
            FileUrl	string
]]

--设置头像
function impl:SetCusPhoto(pic)
	self.m_szUserPhoto = pic.FileUrl;
	self.m_szUserPhotoId = pic.Id;
	if self.m_szUserPhotoId > 0 then
		self.m_szUserPhoto = gDef.domain .. pic.FileUrl;
		self.m_szUserPhotoId = pic.Id;
	end
	-- 默认头像
	self.m_cusFace:SetFace(self.m_szUserPhoto);
	kd.LogOut("KD_LOG:设置图完成");
	
	if self.m_index == 1 then
		self.m_cusFace.clickGui:SetEnable(false);
	end
end

--选取图片后回调
function impl:OnSystemPhotoRet(--[[string]] _filePath, --[[KDGame.emOpenPhotoType]] fileType)
	kd.LogOut("KD_LOG:选取图片后回调");
	if kd.IsFileExist(_filePath) then
		--self:SetCusPhoto(_filePath);	
		self.m_father:AddPhoto(_filePath);
		DC:CallBack("OfficialCertification.CheckSubmit")
	end
	self.m_imgUpLoadFace = self.m_imgLoadUpFace;
	self.m_filePath = _filePath;
end


