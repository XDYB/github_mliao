--[[

官方认证界面滑动层（主界面）

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

CertificationView = kd.inherit(kd.Layer);
local impl = CertificationView;

local listselects =  {
	{"年龄","体重"},
	{"星座","身高"},
	{"城市","特长"},
}

function impl:init(father)
	self.m_father = father
	self.Title = kd.class(Title,false,true)
	self.Title:init(self)
	self.Title:SetTitle("官方认证")
	self:addChild(self.Title,1)
	self.Title.onTouchBegan = function (this,x,y)
		local h = this:GetH();
		if y > h then
			return false
		else
			return true
		end
	end	
	
	self.m_ScrollView = kd.class(kd.ScrollViewEx, true, true);
	self:addChild(self.m_ScrollView);
	local headH = self.Title:GetH();
	self.m_ScrollView:init(self,0,headH, ScreenW,ScreenH, nil, false, true);
    self.m_ScrollView:SetRenderViewMaxH(ScreenH+500);

	self.m_ScrollView.onTouchMoved = function (this,x,y)
		local offsetx,offsety = math.abs(x - this.m_fBeganX),math.abs(y - this.m_fBeganY);
		local degd = math.deg(math.atan(offsety/offsetx));
		
		local ofx,ofy = this:GetViewPos();
		local ageitem = self.m_OfficialCertification:GetAgeItem();
		local ax,ay = ageitem:GetPos();
		local aw,ah = ageitem:GetWH();
		ay = ay - headH  -- 修复UI
		
		local offset = headH + ScreenH - ofy;  --向上滑动距离
		self.m_offset = offset;
		local s = ay - ah/2 + headH;
		local s2 = ay - ah/2 + ah*4 + headH;
		
		if  degd < 30 and offsetx > 80 and y  >= s2 - offset and y  <= s2 - offset + 362 then
			self.m_drict = 2;
		else
			self.m_drict = 0;
		end
		-------------------------------------------------------------------------
		if(--[[this.m_bEnable and this.m_bPause==false and--]] this.m_bTouch) then	
			if(this.m_bDirectX) then
				this.m_fMomentNew = x; 
				local fMove = x-this.m_fMoveX;
				local distance = this:GetSpringStretchLen(this.m_fMovePosX,this.m_fMovePosY);
				local fK = distance*this.m_fSpringK;
				if(fK<1) then fK = 1; end
				local fSetX = this.m_fMovePosX+fMove/fK;
				if(this.m_bNoSpringBack) then
					if(fSetX > this.m_VisibleRect.x1) then fSetX = this.m_VisibleRect.x1;
					elseif(fSetX < this.m_VisibleRect.x2 - this.m_fRenderMaxH) then fSetX = this.m_VisibleRect.x2 - this.m_fRenderMaxH; end
				end
				this:SetViewPos(fSetX,this.m_fMovePosY);			
			else
					this.m_fMomentNew = y; 
					local fMove = y-this.m_fMoveY;
					local distance = this:GetSpringStretchLen(this.m_fMovePosX,this.m_fMovePosY);
					local fK = distance*this.m_fSpringK;
					if(fK<1) then fK = 1; end
					local fSetY = this.m_fMovePosY+fMove/fK;
					if(this.m_bNoSpringBack) then
						if(fSetY > kd.MKCY(this.m_VisibleRect.y1)) then fSetY = kd.MKCY(this.m_VisibleRect.y1);
						elseif(fSetY < kd.MKCY(this.m_VisibleRect.y2 - this.m_fRenderMaxH)) then fSetY = kd.MKCY(this.m_VisibleRect.y2 - this.m_fRenderMaxH); end
					end		
					--print("fSetY = " .. fMove)
					this:SetViewPos(this.m_fMovePosX,fSetY);			
				end		
				this.m_fMoveX,this.m_fMoveY = x,y;
				this.m_fMovePosX,this.m_fMovePosY = this.m_thView:GetPos();	
		end
	end

	self.m_ScrollView.OnClickedCall = function (this,x,y)
		local ofx,ofy = this:GetViewPos();
		local ageitem = self.m_OfficialCertification:GetAgeItem();
		local userfaceitem = self.m_OfficialCertification:GetUserfaceItem();
		local ax,ay = ageitem:GetPos();
		local aw,ah = ageitem:GetWH();
		
		ay = ay - headH -- 修复UI
		
		local offset = headH + ScreenH - ofy;  --向上滑动距离
		
		local s = ay - ah/2 + headH;
		local s2 = ay - ah/2 + ah*3 + headH;
		if  y  >= ay - ah/2 - offset + headH and y  <= ay - ah/2 + ah*3 - offset + headH then
			
			local line = (y  - (ay - ah/2 - offset + headH ))//ah + 1;
			local cos =  x//(ScreenW/2) + 1;
			--print("line = " .. line .. "cos = " .. cos)
			local selectname = listselects[line][cos];
			if selectname then
				self:OnClick(selectname)
			end
		end
		
		--头像
		local fx,fy = userfaceitem:GetPos()
		local fw,fh = userfaceitem:GetWH()
		if y >= fy - fh/2 - offset + headH  and y <= fy - fh/2 + fh - offset + headH 
		and  x >= fx - fw/2 and x <= fx + fw/2 then
			--self:OnClickFace();
		end
		--print(ax - aw/2,ay - ah/2)
		--print(ScreenH)
	end
	
	local x,y = self:GetPos();
	self:SetActionType(kd.emActionType.LAYER_ACTION_SLIDE, x+ScreenW, y);
	
	self.m_OfficialCertification = kd.class(OfficialCertification, false, false);
	self.m_OfficialCertification:init(self);
	self.m_ScrollView:InsertItem(self.m_OfficialCertification);
	local x,y =  self.m_OfficialCertification:GetPos();
	self.m_OfficialCertification:SetPos(x,y - headH);-- 修复UI
	
	self.m_SelectOptionView = kd.class(SelectOptionView, false, true);
	self.m_SelectOptionView:SetVisible(false);
	self:addChild(self.m_SelectOptionView,1);
	self.m_SelectOptionView:init(self);
	self.m_SelectOptionView:SetVisible(false);
end

function impl:OnClickFace()
	echo("打开相册")
	local localtime = kd.GetLocalTime();
		self.m_imgLoadUpFace = string.format("%u%04d%02d%02d%02d%02d%02d.jpg",
							--[[gSink:GetMeUserID()--]]12364,localtime.Year,localtime.Month, 
							localtime.Day,localtime.Hour,localtime.Minute,localtime.Second);
	gSink:OpenPhotoGetJPEG(0,"LocalFile/UserFace/", self.m_imgLoadUpFace, 180,self);
end	

--选取图片后回调
function impl:OnSystemPhotoRet(--[[string]] _filePath, --[[KDGame.emOpenPhotoType]] fileType)
	kd.LogOut("KD_LOG:选取图片后回调");
	if kd.IsFileExist(_filePath) then
		self.m_OfficialCertification:SetCusPhoto(_filePath);	
	end
	self.m_imgUpLoadFace = self.m_imgLoadUpFace;
	self.m_filePath = _filePath;
end

--[[
    Age			int（年龄）
    Weight		int（体重）
    Height		int（身高）
    Constellation	string（星座）
    City		string（城市）
    Speciality		string（特长）
    Signature		string（个性签名）
    Introduce		string（个人介绍）
    Photolist		[
        {
            Id		int
            FileUrl	string
        },
        ...
    ]
]]

function impl:SetData(data)
	self.m_OfficialCertification:SetData(data);
end

function impl:OnClick(name)
	print(name);
	self.m_SelectOptionView:SetVisible(true);
	self.m_SelectOptionView:ShowView(name);
end

function impl:GetDrict()
	return self.m_drict;
end

function impl:Getoffset()
	return self.m_offset;
end


function impl:onGuiToucBackCall(id)
	
end

function impl:SetVisible(bool)
	kd.Node.SetVisible(self,bool)
	if bool and self.m_ScrollView then
		DC:CallBack("AHomePageButtom.Show",false)
		self.m_ScrollView:BackToTop(true)
	end
end

function impl:OnActionEnd()
	if self:IsVisible() then
		print("打开")
	else
		if self.m_father:IsVisible() then
			DC:CallBack("AHomePageButtom.Show",true)
		end
		self.m_OfficialCertification:Clear()
	end
end



