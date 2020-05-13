c_Require("Script/MiLiao/MyInfo/AInstall.lua")
c_Require("Script/MiLiao/MyInfo/MyDynamic/AMeDynamicView.lua");	--	我的动态
--[[

我的界面

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

MyView = kd.inherit(kd.Layer);
local impl = MyView;
local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MEZHEZHAO_LM            = 1001,
	ID_IMG_ML_MAIN2_LM                = 1002,
	ID_IMG_ML_MAIN3_LM                = 1003,
	ID_IMG_ML_MAIN3_LM1               = 1004,
	ID_IMG_ML_MAIN3_LM2               = 1005,
	ID_IMG_ML_MAIN3_LM3               = 1006,
	ID_IMG_ML_MAIN3_LM4               = 1007,
	ID_IMG_ML_MAIN3_LM5               = 1008,
	ID_IMG_ML_MAIN3_LM6               = 1009,
	ID_IMG_ML_MAIN3_LM7               = 1010,
	ID_IMG_ML_MAIN3_LM8               = 1011,
	ID_IMG_ML_MAIN3_LM9               = 1012,
	ID_IMG_ML_MAIN_LM                 = 1013,
	ID_IMG_ML_MAIN_LM6                = 1014,
	ID_IMG_ML_MAIN_LM14               = 1015,
	ID_IMG_ML_MAIN_LM15               = 1016,
	--/* Text ID */
	ID_TXT_NO1                        = 4001,
	ID_TXT_NO2                        = 4002,
	ID_TXT_NO3                        = 4003,
	ID_TXT_NO4                        = 4004,
	ID_TXT_NO5                        = 4005,
	--/* Custom ID */
	ID_CUS_ML_MEZIDINGYI_LM           = 6001,
	ID_CUS_ML_MAIN3_LM                = 6002,
}

function impl:init()
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/Wo.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--我的名字
	self.m_txtMyName = self.m_thView:GetText(idsw.ID_TXT_NO1);
	self.m_txtMyName:SetHAlignment(kd.TextHAlignment.CENTER);
	local x,y = self.m_txtMyName:GetPos()
	self.m_txtMyName:SetPos(ScreenW/2,y)
	
	--名字审核图标
	self.m_sprNameCertificationIcon = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM6);
	
	--编辑资料gui
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN2_LM,0,0,0,0);
	
	--关注数量
	self.m_txtFocusNum = self.m_thView:GetText(idsw.ID_TXT_NO2);
	self.m_txtFocusNum:SetHAlignment(kd.TextHAlignment.CENTER);
	local x,y =  self.m_txtFocusNum:GetPos();
	self.m_txtFocusNum:SetPos(x - 20,y);
	self.m_txtFocusNum:SetString("0");
	
	--关注GUI
	gDef:AddGuiByID(self,idsw.ID_TXT_NO2,90,80,40,80);
	
	--头像
	self.m_cusFace = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_MAIN3_LM,nil,true,2);
	--背景图片
	--self.m_cusBackPhoto = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_MEZIDINGYI_LM,nil,false,4);
	self.m_cusBackPhoto = self:SetCusFace(idsw.ID_CUS_ML_MEZIDINGYI_LM,nil)
	self.m_cusBackPhoto.clickGui:SetEnable(false)
	--粉丝数量
	self.m_txtfansCut = self.m_thView:GetText(idsw.ID_TXT_NO3);
	self.m_txtfansCut:SetHAlignment(kd.TextHAlignment.CENTER);
	local x,y =  self.m_txtfansCut:GetPos();
	self.m_txtfansCut:SetPos(x - 20,y);
	self.m_txtfansCut:SetString("0");
	
	--黑名单GUI
	gDef:AddGuiByID(self,idsw.ID_TXT_NO3,90,80,40,80);
	
	--我的动态
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM1,0,0,0,0);
	--官方认证
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM2,0,0,0,0);
	--实名认证
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM3,0,0,0,0);
	--我的标签
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM4,0,0,0,0);
	--黑名单
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM9,0,0,0,0);
	--清除缓存
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM5,0,0,0,0);
	--安全退出
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM6,0,0,0,0);
	--关于我们
	gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN3_LM7,0,0,0,0);
	
	--认证中icon
	self.m_sprCertificationIcon = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM14);
	self.ingRect = {self.m_sprCertificationIcon:GetTextureRect()}
	--已审核icon
	self.m_sprAuditIcon = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM15);
	self.edRect = {self.m_sprAuditIcon:GetTextureRect()}
	
	---------------------------------------------------------------
	
	--关注
	self.m_FocusListView = kd.class(FocusListView, false, true);
	self.m_FocusListView:SetVisible(false);
	self:addChild(self.m_FocusListView);
	self.m_FocusListView:init(self);
	self.m_FocusListView:SetVisible(false);
	
	--黑名单
	self.m_BlackListView = kd.class(BlackListView, false, true);
	self.m_BlackListView:SetVisible(false);
	self:addChild(self.m_BlackListView);
	self.m_BlackListView:init(self);
	self.m_BlackListView:SetVisible(false);
	
	--粉丝
	self.m_FanListView = kd.class(FanListView, false, true);
	self.m_FanListView:SetVisible(false);
	self:addChild(self.m_FanListView);
	self.m_FanListView:init(self);
	self.m_FanListView:SetVisible(false);
	
	--官方认证
	self.m_CertificationView = kd.class(CertificationView, false, true);
	self:addChild(self.m_CertificationView);
	self.m_CertificationView:SetVisible(false);
	self.m_CertificationView:init(self);
	self.m_CertificationView:SetVisible(false);

	--实名认证
	self.m_RealNameAuthened = kd.class(RealNameAuthened, false, true);
	self:addChild(self.m_RealNameAuthened);
	self.m_RealNameAuthened:SetVisible(false);
	self.m_RealNameAuthened:init(self);
	self.m_RealNameAuthened:SetVisible(false);
	
	self.m_RealNameAuthening = kd.class(RealNameAuthening, false, true);
	self:addChild(self.m_RealNameAuthening);
	self.m_RealNameAuthening:SetVisible(false);
	self.m_RealNameAuthening:init(self);
	self.m_RealNameAuthening:SetVisible(false);
	
	self.m_RealNameUnAuthen = kd.class(RealNameUnAuthen, false, true);
	self:addChild(self.m_RealNameUnAuthen);
	self.m_RealNameUnAuthen:SetVisible(false);
	self.m_RealNameUnAuthen:init(self);
	self.m_RealNameUnAuthen:SetVisible(false);
	
	-- 编辑资料
	self.m_EditMyName = kd.class(EditMyName, false, true);
	self.m_EditMyName:init(self);
	self:addChild(self.m_EditMyName);
	local x, y = self.m_EditMyName:GetPos();
	self.m_EditMyName:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	self.m_EditMyName:SetVisible(false);
	
	--	关于我们
	self.m_AInstall = kd.class(AInstall, false, true);
	self:addChild(self.m_AInstall);
	self.m_AInstall:SetVisible(false);
	self.m_AInstall:init(self);
	self.m_AInstall:SetVisible(false);
	
	-- 我的动态视图
	self.m_AMeDynamicView = kd.class(AMeDynamicView,false,true);
	self.m_AMeDynamicView:init();
	self:addChild(self.m_AMeDynamicView);
	--设置显示隐藏的动画模式
	local x, y = self.m_AMeDynamicView:GetPos();
	self.m_AMeDynamicView:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	self.m_AMeDynamicView:SetVisible(false);
		
	--我的标签展示图
	self.m_MyTagHelp = kd.class(MyTagHelp, false, true);
	self.m_MyTagHelp:init();
	self:addChild(self.m_MyTagHelp);
	local x, y = self.m_MyTagHelp:GetPos();
	self.m_MyTagHelp:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	self.m_MyTagHelp:SetVisible(false);
	
	self.m_AvatarFile = nil;
	
	--	注册数据中心
	DC:RegisterCallBack("MyView.Show",self,function(bool)
		self:SetVisible(bool)
		if bool then
			self:updateme()
		end	
	end)
		--	注册数据中心
	DC:RegisterCallBack("MyView.Clear",self,function()
		self:Clear()
	end)
		
	--	注册数据中心
	DC:RegisterCallBack("MyView.updateme",self,function ()
		self:updateme()
	end)
	
	DC:FillData("MyView.self.m_AvatarFile",nil);	
end

function impl:updateme()
	gSink:Post("michat/get-mymenu",{},function(data)
		if data.Result then
			self:SetData(data)
		else
			
		end
	end,false);
end

--[[
    Nickname string
    Certification int（实名认证：0未认证，1已认证）
    AvatarFile string（头像地址）
    FansNum int（粉丝数）
    FocusNum int（关注数）
    Official_Id int（最新提交的官方认证id，=0表示未提交）
    Official_Audit int（在官方认证id>0的情况下，0认证中，1已认证，-1已拒绝）
    Certification_Status int（-1 未提交，0 认证中，1 已认证）
	AvatarAudit 0 审核中 1 已审核
]]

function impl:SetData(data)
	self.m_txtFocusNum:SetString(data.FocusNum)
	self.m_txtMyName:SetString(gDef:GetName(data.Nickname,6))
	local x,y = self.m_txtMyName:GetPos()
	local w,h = self.m_sprNameCertificationIcon:GetWH()
	local len = gDef:GetTextLen(75,gDef:GetName(data.Nickname,6))
	self.m_sprNameCertificationIcon:SetPos(ScreenW/2 + len/2 + w*3/2,y)
	self.m_txtfansCut:SetString(data.FansNum)
	DC:CallBack("EditMyName.SetData", data);
	
	if self.m_AvatarFile ~= gDef.domain .. data.AvatarFile then
		self.m_cusBackPhoto:SetFace(gDef.domain .. data.AvatarFile)
	end
	self.m_Certification = data.Certification
	self.m_AvatarFile = gDef.domain .. data.AvatarFile
	self.Official_Id = data.Official_Id
	self.Official_Audit = data.Official_Audit
	self.AvatarAudit = data.AvatarAudit
	self.Certification_Status = data.Certification_Status
	
	DC:FillData("MyView.self.m_AvatarFile",data.AvatarFile);	
	
	--保存自己的头像和名字
	DC:FillData("MyView.Nickname",data.Nickname);
	DC:FillData("MyView.AvatarFile",self.m_AvatarFile);
	
	DC:CallBack("OfficialCertification.SetCusPhotoAndNmae",self.m_AvatarFile,data.Nickname)
		
	self.m_cusFace:SetFace(self.m_AvatarFile)
	
	local ing = self.ingRect
	local ed = self.edRect
	
	--官方认证
	self.m_sprCertificationIcon:SetVisible(self.Official_Id  > 0)
	if self.Official_Id  > 0 then
		self.m_sprCertificationIcon:SetVisible(self.Official_Audit  >= 0)
		if  self.Official_Audit == 0 then
			self.m_sprCertificationIcon:SetTextureRect(table.unpack(ing))
		elseif  self.Official_Audit == 1 then
			self.m_sprCertificationIcon:SetTextureRect(table.unpack(ed))
		end
	end
	
	--实名认证
	self.m_sprAuditIcon:SetVisible(self.Certification_Status  >= 0)
	if self.Certification_Status  == 0 then
		self.m_sprAuditIcon:SetTextureRect(table.unpack(ing))
	elseif self.Certification_Status  == 1 then
		self.m_sprAuditIcon:SetTextureRect(table.unpack(ed))
	end
	
	--头像审核
	if self.AvatarAudit == 0 then
		local localFile = gDef.GetResPath("ResAll/ShenHeZhong.png");
		self.m_cusFace:SetFace(localFile,false)
	end
	
	self.m_sprNameCertificationIcon:SetVisible(self.Certification_Status == 1)
end

function impl:onGuiToucBackCall(id)
	-- 编辑资料 
	if id == idsw.ID_IMG_ML_MAIN2_LM then
		echo("打开编辑资料页面");
		DC:CallBack("EditMyName.Show",true);
	-- 关注页面
	elseif id == idsw.ID_TXT_NO2 then
		echo("关注页面");
		gSink:Post("michat/get-lovelist",{page = 0 },function(data)
			if data.Result then
				self.m_FocusListView:SetVisible(true)
				self.m_FocusListView:SetPage(0)
				self.m_FocusListView:SetData(data)
			end
		end)
		
		
	-- 粉丝
	elseif id == idsw.ID_TXT_NO3 then
		echo("粉丝页面");
		gSink:Post("michat/get-fanslist",{page = 0},function(data)
			if data.Result then
				self.m_FanListView:SetVisible(true);
				self.m_FanListView:SetPage(0)
				self.m_FanListView:SetData(data)
			end	
		end)
		
	-- 我的动态
	elseif id == idsw.ID_IMG_ML_MAIN3_LM1 then
		echo("我的动态");
		DC:CallBack("AMeDynamicView.Show",true);
	-- 官方认证
	elseif id == idsw.ID_IMG_ML_MAIN3_LM2 then
		echo("官方认证");
		self:Getofficial();
	-- 实名认证
	elseif id == idsw.ID_IMG_ML_MAIN3_LM3 then
		echo("实名认证");
		--Certification_Status int（-1 未提交，0 认证中，1 已认证）
		if self.Certification_Status == -1 then
			self.m_RealNameUnAuthen:SetVisible(true)
		elseif self.Certification_Status == 0 then
			self:GetCertification();
		elseif self.Certification_Status == 1 then
			self.m_RealNameAuthened:SetVisible(true)
		end
	-- 我的标签
	elseif id == idsw.ID_IMG_ML_MAIN3_LM4 then
		echo("我的标签");
		DC:CallBack("MyTagHelp.Show",true);
	-- 清除缓存
	elseif id == idsw.ID_IMG_ML_MAIN3_LM5 then
		echo("清除缓存");
		
		gSink:messagebox({
					txt = {"您的聊天记录、本地图片缓存将被清除","是否清除缓存?"},
					cls = {0xff333333,0xff999999},
					btn = {"否","是"},
					fn = {function()
						
					end	,
					function()
						print("点击了释放缓存");
						local bSuccess = kd.ClearCacheDir();
						--显示蒙版界面
						gSink:ShowLoading(true);
						self:SetTimer(1,3500,1);
						--kd.WebCleanCache();
					end},
				});
		
	-- 安全退出
	elseif id == idsw.ID_IMG_ML_MAIN3_LM6 then
		echo("安全退出");
		
		gSink:messagebox({
				txt = {"是否退出此账号?"},
				btn = {"否","是"},
				fn = {function()
					
				end	,
				function()
					print("安全退出");
					gSink:Exit();
				end},
			});
		
	--黑名单
	elseif id == idsw.ID_IMG_ML_MAIN3_LM9 then
		echo("黑名单");
		gSink:Post("michat/get-hatelist",{page = 0},function(data)
			if data.Result then
				self.m_BlackListView:SetVisible(true);
				self.m_BlackListView:SetPage(0)
				self.m_BlackListView:SetData(data)
			end	
		end)
	
	elseif id == idsw.ID_CUS_ML_MAIN3_LM then
		echo("头像")
		DC:CallBack("DetaileView.GetDetailData",gSink.m_User.userId);
	elseif id == idsw.ID_IMG_ML_MAIN3_LM7 then
		echo("关于我们");
		DC:CallBack("AInstall.Show",true);
	end
end

function impl:Clear()
	self:SetVisible(false);
	DC:FillData("MyView.self.m_AvatarFile",nil);
	self.m_BlackListView:SetVisible(false);
	self.m_FocusListView:SetVisible(false);
	self.m_CertificationView:SetVisible(false);
	self.m_RealNameAuthened:SetVisible(false);
	self.m_RealNameAuthening:SetVisible(false);
	self.m_RealNameUnAuthen:SetVisible(false);
	self.m_EditMyName:SetVisible(false);
	self.m_AInstall:SetVisible(false);
end

function impl:OnTimerBackCall(id)
	if id == 1 then
		gSink:messagebox_default("缓存清除成功");
		gSink:HideLoading();
		self:KillTimer(1);
	end
end

--查看官方认证
function impl:Getofficial()
	gSink:Post("michat/get-official",{},function(data)
		if data.Result then
			self.m_CertificationView:SetVisible(true);
			self.m_CertificationView:SetData(data)
		end
	end)
end

--查看实名认证
function impl:GetCertification()
	gSink:Post("michat/get-certification",{},function(data)
		if data.Result and data.Is_audit == 0 then
			self.m_RealNameAuthening:SetVisible(true)
			self.m_RealNameAuthening:SetData(data)
		end
	end)
end


function impl:SetCusFace(iResID,avatar)
	local x,y,faceR,h = self.m_thView:GetScaleRect(iResID);
    local faceGui = kd.class(kd.GuiObjectNew, self, iResID, 0, 0, faceR, faceR, false, false);
	faceGui.x,faceGui.y = x,y;
	-- 方形蒙版 默认残缺图片
	faceGui.maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/MeZiDingYi.png"));
	-- 方形蒙版 默认“+”
	--faceGui.maskSpr:SetTextureRect(0,0,659,431);
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
		faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/MeZheZhao.png"));
		--[[if bfornt then
			faceGui.faceSpr:SetTextureRect(0,0,659,431);
		else
			faceGui.faceSpr:SetTextureRect(0,431,659,431);
		end--]]
		faceGui.faceSpr:SetScale(scale,scale);
		faceGui.faceSpr:SetPos(x,y);
		faceGui:addChild(faceGui.faceSpr);
		--默认反面
	elseif string.startsWith(avatar,"http") then
        -- 网络
        faceGui.faceSpr = kd.class(kd.AsyncSprite, avatar);
        faceGui.faceSpr:SetPos(x,y);
        faceGui:addChild(faceGui.faceSpr);
        --加载三级缓存纹理结果回调
        faceGui.faceSpr.OnLoadTextrue = function(this, --[[int]] err_code --[[0:成功]], --[[string]] err_info)
            if err_code == 0 then
                local w,h = this:GetWH();
                local sprScale = GetAdapterScale(w,h,faceR,faceR);
                this:SetScale(sprScale,sprScale);
            end
        end	
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
			-- 网络
			faceGui.faceSpr = kd.class(kd.AsyncSprite, szFace);
			faceGui.faceSpr:SetPos(x,y);
			faceGui:addChild(faceGui.faceSpr);
			--加载三级缓存纹理结果回调
			faceGui.faceSpr.OnLoadTextrue = function(this, --[[int]] err_code --[[0:成功]], --[[string]] err_info)
            if err_code == 0 then
                local w,h = this:GetWH();
                local sprScale = GetAdapterScale(w,h,faceR,faceR);
                this:SetScale(sprScale,sprScale);
            end
        end
		end	
	end
	
	return faceGui;
end


