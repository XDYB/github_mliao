--[[

官方认证滑动层内部界面 

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;
local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

OfficialCertification = kd.inherit(kd.Layer);
local impl = OfficialCertification;
local idsw =
{
	--/* Image ID */
	ID_IMG_ML_MAIN2_LM            = 1001,
	ID_IMG_ML_MAIN_LM             = 1002,
	ID_IMG_ML_MAIN_LM11           = 1003,
	ID_IMG_ML_MAIN_LM12           = 1004,
	ID_IMG_ML_MAIN_LM13           = 1005,
	ID_IMG_ML_MAIN_LM14           = 1006,
	ID_IMG_ML_MAIN_LM15           = 1007,
	ID_IMG_ML_MAIN_LM16           = 1008,
	ID_IMG_ML_MAIN_LM17           = 1009,
	ID_IMG_ML_MAIN_LM18           = 1010,
	--/* Text ID */
	ID_TXT_NO5                    = 4001,
	ID_TXT_NO6                    = 4002,
	ID_TXT_NO7                    = 4003,
	ID_TXT_NO8                    = 4004,
	ID_TXT_NO9                    = 4005,
	ID_TXT_NO10                   = 4006,
	ID_TXT_NO11                   = 4007,
	ID_TXT_NO12                   = 4008,
	ID_TXT_NO13                   = 4009,
	ID_TXT_NO14                   = 4010,
	ID_TXT_NO15                   = 4011,
	ID_TXT_NO16                   = 4012,
	ID_TXT_NO17                   = 4013,
	ID_TXT_NO18                   = 4014,
	ID_TXT_NO19                   = 4015,
	--/* Custom ID */
	ID_CUS_ML_TX232_LM            = 6001,
}

local photoitem_width = 362;

function impl:init(father)
	self.m_father = father;
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/GFRenZheng.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	
	--照片张数
	self.m_photoNumber = self.m_thView:GetText(idsw.ID_TXT_NO13);
	self.m_photoNumber:SetString("0/8")
	
	--我的名字
	self.m_txtMyName = self.m_thView:GetText(idsw.ID_TXT_NO5);
	self.m_txtMyName:SetHAlignment(kd.TextHAlignment.LEFT);
	
	--头像
	self.m_userface = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_TX232_LM,nil,false,5);
	self.m_sprFace = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN_LM11);
	
	
	--年龄
	--gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN2_LM,0,0,0,0);
	self.m_sprAge = self.m_thView:GetSprite(idsw.ID_IMG_ML_MAIN2_LM);
	self.m_txtAge = self.m_thView:GetText(idsw.ID_TXT_NO14);
	self.m_txtAge:SetHAlignment(kd.TextHAlignment.RIGHT);
	local x,y = self.m_txtAge:GetPos()
	self.m_txtAge:SetPos(x - 30,y)
	
	--体重
	--gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM14,0,0,0,0);
	self.m_txtWeight = self.m_thView:GetText(idsw.ID_TXT_NO15);
	self.m_txtWeight:SetHAlignment(kd.TextHAlignment.RIGHT);
	local x,y = self.m_txtWeight:GetPos()
	self.m_txtWeight:SetPos(x - 30,y)
	
	--星座
	--gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM15,0,0,0,0);
	self.m_txtConstellation = self.m_thView:GetText(idsw.ID_TXT_NO16);
	self.m_txtConstellation:SetHAlignment(kd.TextHAlignment.RIGHT);
	local x,y = self.m_txtConstellation:GetPos()
	self.m_txtConstellation:SetPos(x - 30,y)
	
	--身高
	--gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM16,0,0,0,0);
	self.m_txtHeight = self.m_thView:GetText(idsw.ID_TXT_NO17);
	self.m_txtHeight:SetHAlignment(kd.TextHAlignment.RIGHT);
	local x,y = self.m_txtHeight:GetPos()
	self.m_txtHeight:SetPos(x - 30,y)
	
	--城市
	--gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM17,0,0,0,0);
	self.m_txtCity = self.m_thView:GetText(idsw.ID_TXT_NO18);
	self.m_txtCity:SetHAlignment(kd.TextHAlignment.RIGHT);
	local x,y = self.m_txtCity:GetPos()
	self.m_txtCity:SetPos(x - 30,y)
	
	--特长
	--gDef:AddGuiByID(self,idsw.ID_IMG_ML_MAIN_LM18,0,0,0,0);
	self.m_txtSpecialty = self.m_thView:GetText(idsw.ID_TXT_NO19);
	self.m_txtSpecialty:SetHAlignment(kd.TextHAlignment.RIGHT);
	local x,y = self.m_txtSpecialty:GetPos()
	self.m_txtSpecialty:SetPos(x - 30,y)
	
	self.m_txtMyPhoto = self.m_thView:GetText(idsw.ID_TXT_NO12);
	local x,y = self.m_txtMyPhoto:GetPos();
	--滑动相册
	self.m_ScrollView = kd.class(kd.ScrollViewEx, true, true);
	self:addChild(self.m_ScrollView);
	self.m_ScrollView:init(self,0,y + 29, ScreenW, photoitem_width, nil, true, true);
	self.m_ScrollView.onTouchBegan = function (this,x,y)
		--传递
		self.m_father.m_ScrollView:onTouchBegan(x,y);
		
		local y = 1221
		if(this.m_bEnable and this.m_bPause==false
		and x>=this.m_VisibleRect.x1 and x<=this.m_VisibleRect.x2
		and y>=this.m_VisibleRect.y1 and y<=this.m_VisibleRect.y2) then
			this.m_bTouch = true;
			this.m_bBack = false;
			this.m_bClickOK = this.m_cbInertiaMode==0;
			this.m_bApBack = false;
			
			if(this.m_bDirectX) then
				this.m_fMomentOld = x; 
				this.m_fMomentNew = x; 
				
			else
				this.m_fMomentOld = y; 
				this.m_fMomentNew = y; 
			end
			

			this.m_fBeganX,this.m_fBeganY = x,y;
			this.m_fBeganPosX,this.m_fBeganPosY = this.m_thView:GetPos();
			
			this.m_fMoveX,this.m_fMoveY = x,y;
			this.m_fMovePosX,this.m_fMovePosY = this.m_thView:GetPos();
			
			return true;
		end
		
		return true;
	end	
	
	self.m_ScrollView.onTouchMoved = function (this,x,y)
		self.m_father.m_ScrollView:onTouchMoved(x,y);
		local dirct =  self.m_father:GetDrict();
		local y = 1221
		-------------------------------------------------------------------------
		if dirct == 2 then	
			if(this.m_bDirectX) then
				this.m_fMomentNew = x; 
				local fMove = x-this.m_fMoveX;
				local distance = this:GetSpringStretchLen(this.m_fMovePosX,this.m_fMovePosY);
				local fK = distance*this.m_fSpringK;
				if(fK<1) then fK = 1; end
				local fSetX = this.m_fMovePosX+fMove/fK;
				if(this.m_bNoSpringBack) then
					if(fSetX > this.m_VisibleRect.x1) then 
						fSetX = this.m_VisibleRect.x1;
					elseif(fSetX < this.m_VisibleRect.x2 - this.m_fRenderMaxH) then 
						fSetX = this.m_VisibleRect.x2 - this.m_fRenderMaxH;
					end
				end
				this:SetViewPos(fSetX,this.m_fMovePosY);			
				print(fSetX)
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
					this:SetViewPos(this.m_fMovePosX,fSetY);			
				end		
				this.m_fMoveX,this.m_fMoveY = x,y;
				this.m_fMovePosX,this.m_fMovePosY = this.m_thView:GetPos();	
		end
	end
	
	self.m_ScrollView.onTouchEnded = function (this,x,y)
		self.m_father.m_ScrollView:onTouchEnded(x,y);
		if(this.m_bTouch) then	
			this.m_bTouch = false;
			
			this:CheckBack();
			if(this.m_bBack) then return; end
			
			local posx,posy = this:GetViewPos();
			if(math.abs(x-this.m_fBeganX)<=10 and math.abs(y-this.m_fBeganY)<=10 and this.m_bClickOK==true and this.m_bBack==false) then
				this.m_cbInertiaMode = 0;
				this:OnClickedCall(x,y);
				this:SetViewPos(this.m_fBeganPosX,this.m_fBeganPosY);
				return;
				end			
		end
	end
	
	self.m_photoItems = {}
	for i = 1,1 do
		local item = kd.class(PhotoItem, false, false);
		table.insert(self.m_photoItems,item);
		item:init(self,i);
		self.m_ScrollView:InsertItem(item);
		local width,_ = item:GetWH();
		item:SetPos(0 + width*(i-1),kd.MKCY(0));
		item:SetDleSpr(false);
		item:SetIndex(i)
	end
	
	self.m_ScrollView:SetRenderViewMaxH(photoitem_width*#self.m_photoItems);
	
	--个性签名
	self.m_personalsign = kd.class(PersonalInfoitem, false, false);
	self.m_personalsign:init();
	self:addChild(self.m_personalsign);
	self.m_personalsign:SetType(1);
	local sx,sy = self.m_personalsign:GetPos();
	sy = sy + 100
	local sw,sh = self.m_personalsign:GetWH();
	self.m_personalsign:SetPos(sx,ScreenH/2 + sy + photoitem_width);
	--个人介绍
	self.m_personalinfo = kd.class(PersonalInfoitem, false, false);
	self.m_personalinfo:init();
	self:addChild(self.m_personalinfo);
	self.m_personalinfo:SetType(2);
	self.m_personalinfo:SetPos(sx,ScreenH/2 + sy + photoitem_width + sh);
	
	--提交
	self.m_SubmitItem = kd.class(SubmitItem, false, false);
	self.m_SubmitItem:init(self);
	self:addChild(self.m_SubmitItem);
	self.m_SubmitItem:SetPos(sx,ScreenH/2 + sy + photoitem_width + 2*sh);
	self.m_photos = {};
	self.m_photoids = {}
	DC:RegisterCallBack("OfficialCertification.CheckSubmit",self,function()
		self:CheckSubmit();
	end)
	DC:RegisterCallBack("OfficialCertification.SetCusPhotoAndNmae",self,function(avatar,name)
		self:SetCusPhotoAndNmae(avatar,name);
	end)
end

--排布照片
function impl:LayoutPhotos()
	
	--设置图片
	local startindex = 1;
	if #self.m_photos == 8 then
		startindex = 0
	end
	
	local temp = {}
	for i = 1,#self.m_photos do
		temp[i] = self.m_photos[#self.m_photos - i + 1]
	end
	
	for k,v in ipairs(temp) do
		if self.m_photoItems[k + startindex]then
			self.m_photoItems[k + startindex]:SetCusPhoto(v)
		end
	end
	
	--设置位置
	for k,item in ipairs(self.m_photoItems) do
		local width,_ = item:GetWH();
		item:SetIndex(k)
		item:SetPos(0 + width*(k-1),kd.MKCY(0));
	end
	
	--设置首个是否显示X
	self.m_photoItems[1]:SetDleSpr(#self.m_photos == 8);
	
	--item:SetCusPhoto(pic)
	self.m_ScrollView:SetRenderViewMaxH(photoitem_width*#self.m_photoItems);
	self.m_photoNumber:SetString( #self.m_photos.. "/8张")
end

--添加一张图片
function impl:AddPhoto(pic)
	local pict = pic
	if type(pic) == "string" then
		pict = {}
		pict.Id = 0 - #self.m_photoItems
		pict.FileUrl = pic
	end
	table.insert(self.m_photos,pict);
	
	if #self.m_photoItems >= 1 and   #self.m_photoItems <= 7 then
		local item = kd.class(PhotoItem, false, false);
		table.insert(self.m_photoItems,2,item);
		self.m_ScrollView:InsertItem(item);
		item:init(self)
	end
	self:LayoutPhotos()
end

function impl:AddPhotos(photos)
	self:Clear()
	self.m_photos = photos
	local endindex = #photos
	if  endindex > 7 then
		endindex = 7
	end
	for i = 1,endindex do
		local item = kd.class(PhotoItem, false, false);
		table.insert(self.m_photoItems,2,item);
		self.m_ScrollView:InsertItem(item);
		item:init(self)
	end
	self:LayoutPhotos()
end

function impl:IsPhotoOk()
	return #self.m_photos > 0
end

--删除一张图片
function impl:delPhoto(item)
	if item.m_index == 1 or #self.m_photos == 8 then
		self.m_photoItems[1]:DelecPhoto();
	else
		for k,v in ipairs(self.m_photoItems) do
			if v == item then
				local item = table.remove(self.m_photoItems,k);
				self.m_ScrollView:DeleteItem(item);
				break;
			end
		end
	end
	
	for k,v in ipairs(self.m_photos) do
		if  v.Id == item.m_szUserPhotoId then
			table.remove(self.m_photos,k);
			break
		end
	end
	self:LayoutPhotos()
end

function impl:Clear()
	--if self.m_isSubmitFinished then
		--[[local endindex = #self.m_photoItems
		if endindex > 0 then
			for i = endindex,1,-1 do
				self:delPhoto(self.m_photoItems[i])
			end
		end
		local sum1 = #self.m_photoItems
		local sum2 = #self.m_photos--]]
	--end
	local endindex = #self.m_photoItems
	if endindex > 0 then
		for i = endindex,1,-1 do
			if i == 1 then
				self.m_photoItems[i]:DelecPhoto();
			else
				local item = table.remove(self.m_photoItems,i);
				self.m_ScrollView:DeleteItem(item);
			end
		end
	end
	self.m_photos = {}
	self:LayoutPhotos()
end

function impl:GetUserfaceItem()
	return self.m_sprFace;
end

function impl:GetAgeItem()
	return self.m_sprAge;
end

--设置头像
function impl:SetCusPhotoAndNmae(pic,name)
	self.m_szUserFace = pic;
	if pic =="" then 
		pic = nil;
	end
	-- 默认头像
	self.m_userface:SetFace(pic);
	local name = gDef:GetName(name,10)
	self.m_txtMyName:SetString(name)
	kd.LogOut("KD_LOG:设置头像完成");
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
	self:SetAges(data.Age)
	self:SetWights(data.Weight .. "kg")
	if data.Weight == 0 then
		self:SetWights(" ")
	end
	self:SetConstellation(data.Constellation)
	self:SetHigts(data.Height .. "cm")
	if data.Height == 0 then
		self:SetHigts(" ")
	end
	self:SetCitys(data.City)
	self:SetHoblys(data.Speciality)
	
	self.m_personalsign:SetData(data.Signature);
	self.m_personalinfo:SetData(data.Introduce);
	
	if type(data.Photolist) == "table" and #data.Photolist > 0 then
		--[[local endindex = #data.Photolist;
		for i = endindex,1,-1 do
			self:AddPhoto(data.Photolist[i])
		end--]]
		self:AddPhotos(data.Photolist)
	end
end


--设置年龄
function impl:SetAges(str)
	if str == 0 then
		str = " "
	end
	self.m_txtAge:SetString(str);
end

--设置体重
function impl:SetWights(str)
	if str == 0 then
		str = " "
	end
	self.m_txtWeight:SetString(str);
end

--设置星座
function impl:SetConstellation(str)
	if str == "" then
		str = " "
	end
	self.m_txtConstellation:SetString(str);
end

--设置身高
function impl:SetHigts(str)
	if str == 0 then
		str = " "
	end
	self.m_txtHeight:SetString(str);
end

--设置城市
function impl:SetCitys(str)
	if str == "" then
		str = " "
	end
	self.m_txtCity:SetString(str);
end

--设置特长
function impl:SetHoblys(str)
	if str == "" then
		str = " "
	end
	self.m_txtSpecialty:SetString(str);
end

--[[
	
提交官方认证
"/michat/set-official"
	userid
	userkey
	age（年龄）
	weight（体重）
	height（身高）
	constellation（星座）
	city（城市）
	speciality（特长）
	signature（个性签名）
	introduce（个人介绍）
	photolist[] (照片ID列表：[]int)
]]

function impl:Submit()
	local age = self.m_txtAge:GetString();
	local weight = self.m_txtWeight:GetString(str);
	local constellation = self.m_txtConstellation:GetString(str);
	local height = self.m_txtHeight:GetString(str);
	local city = self.m_txtCity:GetString(str);
	local speciality = self.m_txtSpecialty:GetString(str);
	
	local signature = self.m_personalsign:GetInfo();
	local introduce = self.m_personalinfo:GetInfo();
	
	local data = {}
	data.age = age
	data.weight = string.sub(weight,1,-3) 
	data.constellation = constellation
	data.height = string.sub(height,1,-3) 
	data.city = city	
	data.speciality	= speciality
	data.signature = signature
	data.introduce = introduce
	
	local photolist = {}
	
	for k,v in ipairs(self.m_photos) do
		if v.Id > 0 then
			table.insert(photolist,v.Id)
		end
	end
	
	data.photolist = photolist;
	--gSink:ShowLoading("提交审核中...")
	gSink:Post("michat/set-official",data,function(data)
		--gSink:ShowLoading("提交审核中...")
		if data.Result then
			--if self.m_loading == false then
				--gSink:HideLoading();
				if self.m_father:IsVisible() == true then
					self.m_father:SetVisible(false)
					gSink:HideLoading();
					self.m_MessBoxDlg:SetVisible(false)
					DC:CallBack("MyView.updateme") --更新官方认证状态
					--self.m_isSubmitFinished = true
				end
				--self.m_loading = false
			--end
		end
	end)
end

--先提交照片再提交信息
function impl:SubmitPhotos()
	--self.m_loading = true
	--self.m_isSubmitFinished = false
	--self:SetTimer(1001,3000,1)
	gSink:ShowLoading("提交审核中...")
	self.m_MessBoxDlg = gSink:messagebox_default("提交审核中...")
	self.m_tempPhoto = {}
	for k,v in ipairs(self.m_photos) do
		if  v.Id < 0 then
			table.insert(self.m_tempPhoto,v.FileUrl)
		end	
	end	
	
	
	if #self.m_tempPhoto > 0 then  --有新加图片
		local photo = table.remove(self.m_tempPhoto,1)
		self:UploadMyPhoto(photo,#self.m_photos - #self.m_tempPhoto);
	else
		self:Submit();
	end
end

function impl:OnTimerBackCall(id)
	if id == 1001 then
		gSink:HideLoading();
		if self.m_isSubmitFinished then
			self.m_father:SetVisible(false)
		end
		self.m_loading = false
	end
end

--[[
	上传照片
"/michat/up-photo"
userid
userkey
index
file
成功消息：
{
    Result bool
    Index int（客户端传来的索引，直接返回）
    Id int（照片ID，提交官方认证的时候需要）
}
]]

-- 上传图片
function impl:UploadMyPhoto(filename,index)
	echo("上传我的图片");
	--gSink:ShowLoading("提交审核中...")
	gSink:Post("michat/up-photo",{index = index,file = filename},function(data)
		if data.Result then
			--gSink:ShowLoading("提交审核中...")
		end
	end,false)
	
	if (self.m_httpLoadUp == nil) then
		self.m_httpLoadUp = kd.class(kd.HttpRequest);
		if (self.m_httpLoadUp) then
			self.m_httpLoadUp.m_father = self;
			self.m_httpLoadUp.OnHttpPOSTRequest = function(this,
														 _uID, 
														 data,  size,  nErrorCode,  szError)
				local _data = kd.CJson.DeCode(data);										
				if (nErrorCode == 0) and _data.Result then
					--self.m_photoids[self.m_photos_data.Index] = _data.Id;
					--table.insert(self.m_photoids,1,_data.Id)
					self.m_photos[_data.Index].Id = _data.Id
					if #self.m_tempPhoto > 0 then
						local photo = table.remove(self.m_tempPhoto,1)
						self:UploadMyPhoto(photo,#self.m_photos - #self.m_tempPhoto);
					elseif #self.m_tempPhoto == 0 then
						self:Submit();
					end
				else
					--弹出错误MSGBOX
					gSink:messagebox_default("上传照片失败")
					gSink:HideLoading();	
				end
				
			end
		end
	end
		
	if (self.m_httpLoadUp) then
		local szUrl = gDef.PostUrl.."michat/up-photo";
		local str = "userid="..gSink.m_User.userId.."&userkey="..gSink.m_User.userKey.."&filetype=jpg".."&index="..index.."&file="..filename.. "|1";
		--str = kd.Aes128EncryptStr(str,gDef.Aes128Decode);
		--str = string.format("scrt=%s&file=%s|1",str,filename);
		--gSink:ShowLoading();
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

function impl:CheckSubmit()
	local bool = false;
	
	local age = self.m_txtAge:GetString();
	local weight = self.m_txtWeight:GetString(str);
	local constellation = self.m_txtConstellation:GetString(str);
	local height = self.m_txtHeight:GetString(str);
	local city = self.m_txtCity:GetString(str);
	local speciality = self.m_txtSpecialty:GetString(str);
	
	local signature = self.m_personalsign:GetInfo();
	local introduce = self.m_personalinfo:GetInfo();
	
	if string.len(age) > 0 and age ~= " " and 
		string.len(weight) > 0 and weight ~= " "and 
		string.len(constellation) > 0 and constellation ~= " " and 
		string.len(signature) > 0 and signature ~= " " and 
		string.len(introduce) > 0 and introduce ~= " " and 
		string.len(height) > 0 and height ~= " " and 
		string.len(city) > 0 and city ~= " " and  string.len(speciality) > 0 and #self.m_photos > 0 then
		bool = true
	end
	
	self.m_SubmitItem:SetSubmitEable(true)
	
	return bool
end





