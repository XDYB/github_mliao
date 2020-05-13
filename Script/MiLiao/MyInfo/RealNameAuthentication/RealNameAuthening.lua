--[[

实名认证(认证中)

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

RealNameAuthening = kd.inherit(kd.Layer);
local impl = RealNameAuthening;
local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN_LM             = 1001,
	ID_IMG_ML_MAIN_LM8            = 1002,
	ID_IMG_ML_MAIN_LM9            = 1003,
	ID_IMG_ML_MAIN_LM10           = 1004,
	--/* Text ID */
	ID_TXT_NO1                    = 4001,
	ID_TXT_NO5                    = 4002,
	--/* Custom ID */
	ID_CUS_ML_MAIN2_LM            = 6001,
	ID_CUS_ML_MAIN_LM0            = 6002,
}

function impl:init(father)
	self.m_father = father
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/WoRenZheng2.UI"), self);
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
	
	--正面
	self.m_cusFont = self:SetCusFace(idsw.ID_CUS_ML_MAIN2_LM,nil,false);
	--反面
	self.m_cusBack = self:SetCusFace(idsw.ID_CUS_ML_MAIN_LM0,nil,false);
	
	local x,y = self:GetPos();
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
end

function impl:SetPhoto(p1,p2)
	self.m_cusFont:SetFace(p1);
	self.m_cusBack:SetFace(p2);
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

--[[
	Result bool
    Front_img string（身份证正面）
    Back_img string（身份证背面）
    Is_audit int（0认证中，1已认证，-1未提交，只有认证中才显示图片）
]]

function impl:SetData(data)
	local front_img = gDef.domain .. data.Front_img
	local back_img = gDef.domain .. data.Back_img
	
	self:SetPhoto(front_img,back_img)
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
		end
	end
end


