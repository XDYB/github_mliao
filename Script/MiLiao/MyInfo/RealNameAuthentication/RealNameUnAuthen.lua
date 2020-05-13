--[[

实名认证(未认证)

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM            = 1001,
	ID_IMG_ML_MAIN_LM8           = 1002,
	--/* Button ID */
	ID_BTN_ML_MAIN_LM            = 3001,
	--/* Text ID */
	ID_TXT_NO1                   = 4001,
	ID_TXT_NO4                   = 4002,
	ID_TXT_NO5                   = 4003,
	--/* Custom ID */
	ID_CUS_ML_MAIN_LM            = 6001,
	ID_CUS_ML_MAIN2_LM           = 6002,
}

RealNameUnAuthen = kd.inherit(kd.Layer);
local impl = RealNameUnAuthen;

function impl:init(father)
	self.m_father = father
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/WoRenZheng.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--头部
	self.Title = kd.class(Title,false,true)
	self.Title:init(self)
	self.Title:SetTitle("实名认证")
	self:addChild(self.Title)
	self.Title.onTouchBegan = function (this,x,y)
		local h = this:GetH();
		if y > h then
			return false
		else
			return true
		end
	end	
	
	local szTexFile = gDef.GetResPath("ResAll/Main2.png");
	--正面
	self.m_cusFont = self:SetCusFace(idsw.ID_CUS_ML_MAIN_LM,nil,true);
	
	--反面
	self.m_cusBack = self:SetCusFace(idsw.ID_CUS_ML_MAIN2_LM,nil,false);
	
	self.m_frontimg = "";
	self.m_backimg = "";
	
	local x,y = self:GetPos();
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);--]]
end

function impl:SetCusFace(iResID,avatar,bfornt)
	local x,y,faceR,h = self.m_thView:GetScaleRect(iResID);
    local faceGui = kd.class(kd.GuiObjectNew, self, iResID, 0, 0, faceR, faceR, false, false);
	faceGui.x,faceGui.y = x,y;
	-- 方形蒙版 默认残缺图片
	faceGui.maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"));
	-- 方形蒙版 默认“+”
	faceGui.maskSpr:SetTextureRect(0,0,659,431);
    local w,h = faceGui.maskSpr:GetWH();
    local scale = faceR/w;
	faceGui.scale = scale;
	faceGui.faceR = faceR;
    faceGui.maskSpr:SetScale(scale,scale);
    faceGui.maskSpr:SetPos(x,y);
	faceGui:setMaskingClipping(faceGui.maskSpr);
    
	 --设置头像
    self.m_thView:SetCustomRes(iResID,faceGui);
	
    if avatar == nil then
        -- 默认正面
		faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"));
		if bfornt then
			faceGui.faceSpr:SetTextureRect(0,0,659,431);
		else
			faceGui.faceSpr:SetTextureRect(0,431,659,431);
		end
		faceGui.faceSpr:SetScale(scale,scale);
		faceGui.faceSpr:SetPos(x,y);
		faceGui:addChild(faceGui.faceSpr);
		--默认反面
		
    else
        -- 本地
		if kd.IsFileExist(avatar) then
			faceGui.faceSpr = kd.class(kd.Sprite,avatar);
			if faceGui.faceSpr then
				local w1,h1 = faceGui.faceSpr:GetWH();
				local scale1 = GetAdapterScale(w1,h1,faceR,faceR);
				faceGui.faceSpr:SetScale(scale1,scale1);
				faceGui.faceSpr:SetPos(x,y);
				faceGui:addChild(faceGui.faceSpr);
			end
		end
		
    end
	faceGui.clickGui = kd.class(kd.GuiObjectNew, self, iResID, x-faceR/2, y-h/2, faceR, h, false, true);
	self:addChild(faceGui.clickGui)
	faceGui.clickGui:setDebugMode(true);
	faceGui.clickGui.id = iResID;
	
	 -- 设置新头像
    faceGui.SetFace = function(this,szFace)
		if faceGui then
            faceGui:RemoveChild(faceGui.faceSpr);
            faceGui.faceSpr = nil;
			
			if (szFace~=nil and string.len(szFace)>0 and 				
				kd.IsFileExist(szFace) == true) then	
					faceGui.faceSpr = kd.class(kd.Sprite, szFace);
			end		
			faceGui:addChild(faceGui.faceSpr);
			faceGui.faceSpr:SetPos(faceGui.x,faceGui.y);
			local w2,h = faceGui.faceSpr:GetWH();
			local scale1 = GetAdapterScale(w2,h,faceGui.faceR,faceGui.faceR);
			faceGui.faceSpr:SetScale(scale1,scale1)
		end	
	end
	faceGui.delFace = function (this,bfornt)
		faceGui:RemoveChild(faceGui.faceSpr);
        faceGui.faceSpr = nil;
		
		faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"));
		if bfornt then
			faceGui.faceSpr:SetTextureRect(0,0,659,431);
		else
			faceGui.faceSpr:SetTextureRect(0,431,659,431);
		end
		faceGui.faceSpr:SetScale(scale,scale);
		faceGui.faceSpr:SetPos(x,y);
		faceGui:addChild(faceGui.faceSpr);
	end
	
	
	return faceGui;
end

function impl:onGuiToucBackCall(id)
	-- 相册 
	if id == idsw.ID_CUS_ML_MAIN_LM then
		echo("打开相册")
		self.m_type = 1
		local localtime = kd.GetLocalTime();
			self.m_imgLoadUp = string.format("%u%04d%02d%02d%02d%02d%02d.jpg",
								gSink:GetUser().userId,localtime.Year,localtime.Month, 
								localtime.Day,localtime.Hour,localtime.Minute,localtime.Second);
		gSink:OpenPhotoGetJPEG(0,"LocalFile/UserFace/", self.m_imgLoadUp, 180,self);
		
	elseif id == idsw.ID_BTN_ML_MAIN_LM then
		if self.m_frontimg ~= "" and self.m_backimg ~= "" then
			self:SetTimer(1001,3000,1)
			self.m_loading = true
			gSink:messagebox_default("照片上传中请稍后...")
			self:UpCertification();
		else
			gSink:messagebox_default("需要上传2张照片哦~")
		end
		
	elseif id == idsw.ID_CUS_ML_MAIN2_LM then
		self.m_type = 2
		local localtime = kd.GetLocalTime();
			self.m_imgLoaddown = string.format("%u%04d%02d%02d%02d%02d%02d.jpg",
								gSink:GetUser().userId,localtime.Year,localtime.Month, 
								localtime.Day,localtime.Hour,localtime.Minute,localtime.Second);
		gSink:OpenPhotoGetJPEG(0,"LocalFile/UserFace/", self.m_imgLoaddown, 180,self);
	end
end

function impl:Clear()
	self.m_cusFont:delFace(true)
	self.m_cusBack:delFace(false)
	self.m_frontimg = "";
	self.m_backimg = "";
	self.m_type = 0
end

function impl:OnTimerBackCall(id)
	if id == 1001 then
		self:SetVisible(false)
		self.m_loading = false
		gSink:HideLoading();	
		self.m_father:updateme()
	end
end

--选取图片后回调
function impl:OnSystemPhotoRet(--[[string]] _filePath, --[[KDGame.emOpenPhotoType]] fileType)
	kd.LogOut("KD_LOG:选取图片后回调");
	if kd.IsFileExist(_filePath) then
		if self.m_type == 1 then
			self.m_cusFont:SetFace(_filePath)
			self.m_frontimg = _filePath;
		elseif self.m_type == 2 then
			self.m_cusBack:SetFace(_filePath)
			self.m_backimg = _filePath;
		end
	end
	self.m_type = 0
end

--[[
	上传实名认证
	"/michat/up-certification"
	userid
	userkey
	frontimg
	backimg
	成功消息：
	{
		Result bool
}
]]

function impl:UpCertification()
	if (self.m_httpLoadUp == nil) then
		self.m_httpLoadUp = kd.class(kd.HttpRequest);
		if (self.m_httpLoadUp) then
			self.m_httpLoadUp.m_father = self;
			self.m_httpLoadUp.OnHttpPOSTRequest = function(this,
														 _uID, 
														 data,  size,  nErrorCode,  szError)
				local _data = kd.CJson.DeCode(data);										
				if (nErrorCode == 0) and _data.Result then
					self.m_uploadOk = true
					if self.m_loading == false and self:IsVisible() == true then
						self:SetVisible(false);
						gSink:HideLoading();	
						self.m_father:updateme()
					end
				else
					--弹出错误MSGBOX
					gSink:messagebox_default("上传照片失败")
					self:KillTimer(1001)
					gSink:HideLoading();	
				end
				
			end
		end
	end
		
	if (self.m_httpLoadUp) then
		local szUrl = gDef.PostUrl.."michat/up-certification";
		local str = "userid="..gSink.m_User.userId.."&userkey="..gSink.m_User.userKey.."&fronttype=jpg".."&frontimg="..self.m_frontimg .. "|1".. "&backtype=jpg" .."&backimg="..self.m_backimg.. "|1";
		--str = kd.Aes128EncryptStr(str,gDef.Aes128Decode);
		--str = string.format("scrt=%s&file=%s|1",str,filename);
		gSink:ShowLoading();
		self.m_httpLoadUp:SendHttpPOSTRequest(1,
												szUrl,
											    "",
												str 
												);
	else
		--弹出错误MSGBOX
		gSink:messagebox_default("上传照片失败");
	end	
end

function impl:SetVisible(bool)
	kd.Node.SetVisible(self,bool)
	if bool and self.m_thView then
		DC:CallBack("AHomePageButtom.Show",false)
	end
end

function impl:OnActionEnd()
	if self:IsVisible() then
		print("打开")
	else
		if self.m_father:IsVisible() then
			DC:CallBack("AHomePageButtom.Show",true)
			self:Clear()
		end
	end
end




