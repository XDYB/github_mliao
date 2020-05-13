local kd = KDGame;

local impl = gDef

function copy(orig)
  local copytb
  if type(orig) == "table" then
    copytb = {}
    for orig_key, orig_value in next, orig, nil do
      copytb[copy(orig_key)] = copy(orig_value)
    end
    setmetatable(copytb, copy(getmetatable(orig)))
  else
    copytb = orig
  end
  return copytb
end

function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

function swop(tb,a,b)
	local temp = tb[a]
    tb[a] = tb[b]
    tb[b] = temp
end


function io.pathinfo(path)
    local pos = string.len(path)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(path, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        end
        pos = pos - 1
    end

    local dirname = string.sub(path, 1, pos)
    local filename = string.sub(path, pos + 1)
    extpos = extpos - pos
    local basename = string.sub(filename, 1, extpos - 1)
    local extname = string.sub(filename, extpos)
    return {
        dirname = dirname,
        filename = filename,
        basename = basename,
        extname = extname
    }
end

--定义查找表，长度256，表中的数值表示以此为起始字节的utf8字符长度
local utf8_look_for_table = 
{
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 1, 1
};

--1个汉字或大写字母=2个小写字母
-- @bCharAsSingle true 汉字视为1个字符 
function impl:GetTextCount(str,bCharAsSingle)
	local n = bCharAsSingle == true and 1 or 2;
	if str == nil then return 0; end
	if(type(str)~="string") then return -1; end
	
	local cnt = 0;
	local offset = 1;
	local len = string.len(str);
	while(offset<=len) do
		local ch = string.byte(str,offset);
		if(ch==0) then break; end
		local off = utf8_look_for_table[ch];
		--全角字符第二个ch为226
		if(off>2 and ch~=226) then cnt = cnt+n;
		elseif(ch>=65 and ch<=90) then cnt = cnt+n;
		else cnt = cnt+1; end
		
		offset = offset+off;
	end
	
	return cnt;
end


function impl:utf8tochars(input)
	 local list = {};
     local len  = string.len(input);
     local index = 1;
     local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc};
     while index <= len do
        local c = string.byte(input, index);
        local offset = 1;
        if c < 0xc0 then
            offset = 1;
        elseif c < 0xe0 then
            offset = 2;
        elseif c < 0xf0 then
            offset = 3;
        elseif c < 0xf8 then
            offset = 4;
        elseif c < 0xfc then
            offset = 5;
        end
        local str = string.sub(input, index, index+offset-1);
        -- echo(str)
        index = index + offset;
        table.insert(list, {byteNum = offset, char = str});
     end

     return list;
end	

local special_char_len = {};
if(kd.GetSystemType()~=kd.SystemType.OS_WIN32) then
	special_char_len =
	{	
		[49] = 1,			--1
		[73] = 1,			--I
		[77] = 1.5,			--M
		[87] = 2,			--W
	};
else
	special_char_len =
	{
		[49] = 1,			--1
		[73] = 1,			--I
		[77] = 1,			--M
		[87] = 1,			--W		
	};
end

function impl:GetTextLen(nFontSize, str)
	if str == nil then return 0; end
	if(type(str)~="string") then return 0; end
	
	local nSizeHZ,nSizeSZ,nSizeDX,nSizeXX = nFontSize,nFontSize/2,nFontSize/2,nFontSize/2;
	if(kd.GetSystemType()~=kd.SystemType.OS_WIN32) then
		nSizeSZ = nSizeSZ * 1.3;	
		nSizeDX	= nSizeDX * 1.4;
	end
	local nLen = 0;
	
	local offset = 1;
	local len = string.len(str);
	while(offset<=len) do
		local ch = string.byte(str,offset);
		if(ch==0) then break; end
		local off = utf8_look_for_table[ch];		
		--全角字符第二个ch为226
		if(off>2 and ch~=226) then nLen = nLen+nSizeHZ;
		elseif(special_char_len[ch]) then nLen = nLen+special_char_len[ch]*nSizeXX;
		elseif(ch>=48 and ch<=57 and ch~=49) then nLen = nLen+nSizeSZ;	
		elseif(ch>=65 and ch<=90) then nLen = nLen+nSizeDX;	
		else nLen = nLen+nSizeXX; end
		
		offset = offset+off;
	end
	
	return nLen;	
end

function impl:SubString(szName,nLenght)
	if nLenght==nil then nLenght = 11 end
	local szTxt = "";
	local szMaxTxt = "";
	local list = gDef:utf8tochars(szName);	--拆分
--	if #list<= nLenght then
--		return szName
--	else
		local nCnt = 0;
		for i=1,#list do
			nCnt = nCnt+gDef:GetTextCount(list[i].char);
			if nCnt+3>nLenght then
				szTxt = szMaxTxt.."...";
				break;
			else
				szTxt = szTxt..list[i].char;
				if(nCnt<=nLenght) then szMaxTxt = szTxt; end
			end
		end
			
		return szTxt;
--	end
	
end

-- 等比 自适应容器尺寸，丢失边缘
function GetAdapterScale(w,h,targetW,targetH)
	local scaleX = targetW / w;
	local scaleY = targetH / h;
	return math.max(scaleX,scaleY);
end

-- 获取GUI 适用于获取UI编辑器的资源
-- @father
-- @iResID
-- @paddingTop int 上边距
-- @paddingRight int 右边距
-- @paddingBottom int 下边距
-- @paddingLeft int 左边距
function impl:AddGuiByID(father,iResID,paddingTop,paddingRight,paddingBottom,paddingLeft)
    paddingTop = paddingTop and paddingTop or 0;
    paddingRight = paddingRight and paddingRight or 0;
    paddingBottom = paddingBottom and paddingBottom or 0;
    paddingLeft = paddingLeft and paddingLeft or 0;
    
    local px,py,w,h = father.m_thView:GetScaleRect(iResID);
    local obj = {
        spr = 0,
        gui = 0,
        SetVisible = function(this,bool)
            this.spr:SetVisible(bool)
            this.gui:SetVisible(bool)
        end,
		SetSprVisible = function (this,bool)
			 this.spr:SetVisible(bool)
		end,
		SetGuiVisible = function (this,bool)
			 this.gui:SetVisible(bool)
		end,
        SetPos = function(this,px,py)
           if this.spr.SetHAlignment then
                this.spr:SetHAlignment(kd.TextHAlignment.CENTER);
           end
           this.spr:SetPos(px,py);
           local x = px - w/2 - paddingLeft;
           local y = py - h/2 - paddingTop;
           local w = w + paddingLeft + paddingRight;
           local h = h + paddingTop + paddingBottom;
           this.gui:SetTouchRect(x,y,w,h);
        end,
		SetZOrder= function(this,zorder)
			this.gui:SetZOrder(zorder)
		end,
    };
	obj.father = father
	obj.Del = function(this)
		obj.father:RemoveChild(obj.gui)
	end
		
    if w==0 then
		-- 文字
        obj.spr = father.m_thView:GetText(iResID)
		-- 自动设置边距
		if paddingRight == 0 then
			local text = obj.spr:GetString();
			local width = self:GetTextLen(35,text);
			paddingTop = 25
			paddingRight = width/2
			paddingBottom = 25
			paddingLeft = width /2
			
		end
    else
		-- 精灵
        obj.spr = father.m_thView:GetSprite(iResID)
    end

    local x = px - w/2 - paddingLeft;
    local y = py - h/2 - paddingTop;
    local w = w + paddingLeft + paddingRight;
    local h = h + paddingTop + paddingBottom;
    obj.gui = kd.class(kd.GuiObjectNew, father, iResID,x , y, w, h, false, true);
    obj.gui:setDebugMode(true);
    father:addChild(obj.gui);
    return obj;
end

function impl:AddGuiByIDCusID(father,iResID,cusID)
    paddingTop = paddingTop and paddingTop or 0;
    paddingRight = paddingRight and paddingRight or 0;
    paddingBottom = paddingBottom and paddingBottom or 0;
    paddingLeft = paddingLeft and paddingLeft or 0;
    
    local px,py,w,h = father.m_thView:GetScaleRect(iResID);
    local obj = {
        spr = 0,
        gui = 0,
        SetVisible = function(this,bool)
            this.spr:SetVisible(bool)
            this.gui:SetVisible(bool)
        end,
		SetSprVisible = function (this,bool)
			 this.spr:SetVisible(bool)
		end,
		SetGuiVisible = function (this,bool)
			 this.gui:SetVisible(bool)
		end,
        SetPos = function(this,px,py)
           if this.spr.SetHAlignment then
                this.spr:SetHAlignment(kd.TextHAlignment.CENTER);
           end
           this.spr:SetPos(px,py);
           local x = px - w/2 - paddingLeft;
           local y = py - h/2 - paddingTop;
           local w = w + paddingLeft + paddingRight;
           local h = h + paddingTop + paddingBottom;
           this.gui:SetTouchRect(x,y,w,h);
        end,
		SetZOrder= function(this,zorder)
			this.gui:SetZOrder(zorder)
		end,
    };
	obj.father = father
	obj.Del = function(this)
		obj.father:RemoveChild(obj.gui)
	end
		
    if w==0 then
		-- 文字
        obj.spr = father.m_thView:GetText(iResID)
		-- 自动设置边距
		if paddingRight == 0 then
			local text = obj.spr:GetString();
			local width = self:GetTextLen(35,text);
			paddingTop = 25
			paddingRight = width/2
			paddingBottom = 25
			paddingLeft = width /2
			
		end
    else
		-- 精灵
        obj.spr = father.m_thView:GetSprite(iResID)
    end

    local x = px - w/2 - paddingLeft;
    local y = py - h/2 - paddingTop;
    local w = w + paddingLeft + paddingRight;
    local h = h + paddingTop + paddingBottom;
    obj.gui = kd.class(kd.GuiObjectNew, father, cusID,x , y, w, h, false, true);
--    obj.gui:setDebugMode(true);
    father:addChild(obj.gui);
    return obj;
end
-- 设置自定义图片
function impl:SetMCusImage(thview,id,url,isblur)
	local obj = {}
	local px,py,pw,ph = thview:GetScaleRect(id);
	local w,h = pw,ph
	obj.maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/QiTa/ZhuYeMoRen.png"),0, 0, 842, 842);
	local maskSprW,maskSprH = obj.maskSpr:GetWH()
	-- 缩放蒙板
	local maskScale = GetAdapterScale(maskSprW,maskSprH,w,h)
	obj.maskSpr:SetScale(maskScale,maskScale)
	obj.maskSpr:SetPos(px,py)

	obj.gui = kd.class(kd.GuiObjectNew,thview,1,px-w/2,py-h/2,w,h);
--	obj.gui:setDebugMode(true)
	obj.gui:setMaskingClipping(obj.maskSpr);
	thview:SetCustomRes(id,obj.gui);
	
	-- ============================
	-- 远程图片
	-- ============================
	if url then
		obj.img =  kd.class(kd.AsyncSpriteBlur,url);
		obj.gui:addChild(obj.img)
		obj.img:SetPos(px,py)
		
		obj.img.OnLoadTextrue = function(this,err_code ,err_info)
			if err_code == 0 then
				local _w,_h = this:GetTexWH();
				local scale = GetAdapterScale(_w,_h,w,h)
				this:SetScale(scale,scale)
			end
		end
		if isblur then
			obj.img:SetBlurRadius(5);
			obj.img:SetBlurSampleNum(5);
		end
		
			
	-- ============================
	-- 默认头像
	-- ============================
	else
		obj.img = kd.class(kd.Sprite,gDef.GetResPath("ResAll/QiTa/ZhuYeMoRen.png"),0, 0, 842, 842);
		obj.gui:addChild(obj.img)
		obj.img:SetPos(px,py)
		local scale = GetAdapterScale(300,300,w,h)
		obj.img:SetScale(scale,scale)
	end
	
	obj.Del = function()
		thview:DelCustomRes(id,obj.gui);
	end
	obj.SetBlurRadius = function(this,n)
		obj.img:SetBlurRadius(n);
	end
	obj.SetBlurSampleNum = function(this,n)
		obj.img:SetBlurSampleNum(n);
	end
	obj.SetVisible = function(this,bool)
		obj.img:SetVisible(bool)
	end
	return obj
end
-- 设置头像
function impl:SetMAvatar(thview,id,url)
	local px,py,pw,ph = thview:GetScaleRect(id);
	local w,h = pw,ph
	local maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/QiTa/Xq_touxiang.png"),0, 0, 240, 240);
	local maskSprW,maskSprH = maskSpr:GetWH()
	-- 缩放蒙板
	local maskScale = GetAdapterScale(maskSprW,maskSprH,w,h)
	maskSpr:SetScale(maskScale,maskScale)
	maskSpr:SetPos(px,py)

	local obj = {}
	
	obj.gui = kd.class(kd.GuiObjectNew,thview,1,px-w/2,py-h/2,w,h);
--	obj.gui:setDebugMode(true)
	obj.gui:setMaskingClipping(maskSpr);
	thview:SetCustomRes(id,obj.gui);
	
	
	-- ============================
	-- 远程图片
	-- ============================
	if url then
		obj.img =  kd.class(kd.AsyncSprite,url);
		obj.gui:addChild(obj.img)
		obj.img:SetPos(px,py)
		obj.img.OnLoadTextrue = function(this,err_code ,err_info)
			if err_code == 0 then
				local _w,_h = this:GetTexWH();
				local scale = GetAdapterScale(_w,_h,w,h)
				this:SetScale(scale,scale)
			end
		end
	-- ============================
	-- 默认头像
	-- ============================
	else
		obj.img = kd.class(kd.Sprite,gDef.GetResPath("ResAll/QiTa/Xq_touxiang.png"),0, 0, 240, 240);
		obj.gui:addChild(obj.img)
		obj.img:SetPos(px,py)
		local scale = GetAdapterScale(240,240,w,h)
		obj.img:SetScale(scale,scale)
	end
	
	obj.Del = function()
		thview:DelCustomRes(id, obj.gui);
	end
	obj.SetRot = function(this,x)
		if x>=360 then x = 0 end
		obj.img:SetRotation(x)
	end
	obj.GetRot = function(this)
		return obj.img:GetRotation()
	end
	return obj
end

impl.EnmuLayout = {
	LEFT = 1,
	CENTER = 2,
	RIGHT = 3,
}
function impl:Layout(list,x,y,margin,align,fontSize)
	margin = margin or 20;
	fontSize = fontSize or 44;
	align = align or gDef.EnmuLayout.CENTER;
	-- 为列表中的文字元素重写GetWH方法
	for i,v in ipairs(list) do
		local w = (v:GetWH());
		if w == 0 then
			v.GetWH = function(this)
				if this.GetFontSize then
					return self:GetTextLen(this.GetFontSize(),this:GetString())
				else
					return self:GetTextLen(fontSize,this:GetString())
				end
				
			end
			v:SetHAlignment(kd.TextHAlignment.CENTER);
		end
	end

	local totalWidth = 0;
	for i,v in ipairs(list) do
		local w = (v:GetWH());
		totalWidth = totalWidth + w;
	end
	totalWidth = totalWidth + margin*(#list-1);

	local startPosX = 0;
	if align ==  gDef.EnmuLayout.LEFT then
		startPosX = x;
	elseif align == gDef.EnmuLayout.CENTER then
		startPosX = x - totalWidth/2;
	elseif align == gDef.EnmuLayout.RIGHT then
		startPosX = x - totalWidth;
	end

	local nowPos = startPosX;
	for i,v in ipairs(list) do
		local w = (v:GetWH());
		v:SetPos(w/2+nowPos,y);
		nowPos = nowPos + w + margin;
	end
end
-- 性别
function impl:RectSex(spr,sex)
	if sex == 1 then
		-- 男
		spr:SetTextureRect(1307,302,42,42)
	else
		spr:SetTextureRect(1263,302,42,42)
	end
end
-- 首页热门标识
function impl:RectHot(spr,hot)
	if hot == "new" then
		spr:SetTextureRect(0,956,208,123)
	elseif hot == "hot" then
		spr:SetTextureRect(0,1080,208,123)
	elseif hot == "recommend" then
		spr:SetTextureRect(0,1206,208,123)
	end
end


-- 获取裁剪区域
-- @i 索引 1-9
-- @w 款
function impl:GetRect(i,width)
	local w = math.floor(width/3)
	if i==1 then
		return 0,0,w,w
	elseif i==2 then
		return w,0,w,w
	elseif i==3 then
		return 2*w,0,w,w
	elseif i==4 then
		return 0,w,w,w
	elseif i==5 then
		return w,w,w,w
	elseif i==6 then
		return 2*w,w,w,w	
	elseif i==7 then
		return 0,2*w,w,w
	elseif i==8 then
		return w,2*w,w,w
	elseif i==9 then
		return 2*w,2*w,w,w
	end
end



-- ===========================================================================
-- 									Http下载
-- ===========================================================================
--[[
GetFile("http://localhost/httpdown.zip","LocalFile/",function(filepath)
	-- 回调函数
end)
--]]		
-- @url 远程下载路径
-- @localPath 本地保存目录
-- @callback 回调函数
function impl:GetFile(url,localPath,callback,callback2)
	local pos = string.len(url)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(url, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        end
        pos = pos - 1
    end
    local filename = string.sub(url, pos + 1)
    local httpRequest = kd.class(kd.HttpFile)
	-- 回调函数注册到数据中心
	local varName1 = url..tostring(httpRequest).."callback1"
	local varName2 = url..tostring(httpRequest).."callback2"
	DC:RegisterCallBack(varName1,self,callback)
	DC:RegisterCallBack(varName2,self,callback2)
    httpRequest.OnHttpFileDownProgress = function(self, _dltotal, _dlnow, _progress)
		DC:CallBack(varName2,_progress);
	end
	httpRequest.OnHttpFileRequest = function(self,
									--[[KDGame.emHttpFileTaskType]] _type,
									--[[int]] _nErrorCode,
									--[[string]] _szError,
									--[[string]] _szFilePath,
									--[[uint]] param0,
									--[[uint]] param1,
									--[[uint]] param2,
									--[[uint]] param3)											
		if (_nErrorCode == 0) then	
			-- 向数据中心填充数据
			DC:CallBack(varName1,_szFilePath);
		end
	end
	httpRequest:SendHttpFileRequest(kd.emHttpFileTaskType.HTTP_FILE_DOWNLOAD,url, 
		localPath, filename);
end


-- 设置背景图片
-- @thview 
-- @id 	自定义层ID
-- @maskSpr table 蒙版/默认图(裁剪用，一般情况下 蒙版和默认图必须是相似)
-- e.g maskSpr = {filename = gDef.GetResPath("ResAll/Main2.png"),rect = {662, 905, 720, 720}}
-- @url 图片路径 
-- @bClick 点击 (默认不可点击)
function gDef:SetCusPictre(thview,id,url,masktable,bClick)
	local px,py,pw,ph = thview:GetScaleRect(id);
	if masktable == nil or masktable.filename == nil or masktable.rect == nil then
		return echo("error maskSpr")
	end
	local maskSpr = kd.class(kd.Sprite,masktable.filename,table.unpack(masktable.rect));
	local maskSprW,maskSprH = maskSpr:GetWH()
	-- 缩放蒙板
	local xs,ys = pw/maskSprW,ph/maskSprH
	maskSpr:SetScale(xs,ys)
	maskSpr:SetPos(px,py)

	local obj = {}
	local bClick = bClick or false
	obj.gui = kd.class(kd.GuiObjectNew,thview,id,px-pw/2,py-ph/2,pw,ph,false,bClick);
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
				
				obj.img = kd.class(kd.Sprite,masktable.filename,table.unpack(masktable.rect));
				obj.gui:addChild(obj.img)
				obj.img:SetPos(px,py)
				local scale = GetAdapterScale(720,720,w,h)
				obj.img:SetScale(scale,scale)
				
			end
			
		end
		
	-- ============================
	-- 默认头像
	-- ============================
	else
		obj.img = kd.class(kd.Sprite,masktable.filename,table.unpack(masktable.rect));
		obj.gui:addChild(obj.img)
		obj.img:SetPos(px,py)
		local scale = GetAdapterScale(720,720,w,h)
		obj.img:SetScale(scale,scale)
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
	return obj
end


-- 设置背景图片
-- @thview 
-- @id 	自定义层ID
-- @w 	头像宽度
-- @url 图片路径 
function gDef:SetAvatarA(thview,id,w,h,url)
	local px,py,pw,ph = thview:GetScaleRect(id);
	local maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"),662, 905, 720, 720);
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
				
				obj.img = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"),662, 905, 720, 720);
				obj.gui:addChild(obj.img)
				obj.img:SetPos(px,py)
				local scale = GetAdapterScale(720,720,w,h)
				obj.img:SetScale(scale,scale)
				
			end
			
		end
		
	-- ============================
	-- 默认头像
	-- ============================
	else
		obj.img = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"),662, 905, 720, 720);
		obj.gui:addChild(obj.img)
		obj.img:SetPos(px,py)
		local scale = GetAdapterScale(720,720,w,h)
		obj.img:SetScale(scale,scale)
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
	return obj
end

-- 设置头像 圆形
-- @thview 
-- @id 	自定义层ID
-- @w 	头像宽度
-- @url 图片路径 
function gDef:SetAvatarB(thview,id,w,h,url)
	local px,py,pw,ph = thview:GetScaleRect(id);
	local maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/TX263.png"));
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
				
				obj.img = kd.class(kd.Sprite,gDef.GetResPath("ResAll/TX263.png"));
				obj.gui:addChild(obj.img)
				obj.img:SetPos(px,py)
				local scale = GetAdapterScale(720,720,w,h)
				obj.img:SetScale(scale,scale)
				
			end
			
		end
		
	-- ============================
	-- 默认头像
	-- ============================
	else
		obj.img = kd.class(kd.Sprite,gDef.GetResPath("ResAll/TX263.png"));
		obj.gui:addChild(obj.img)
		obj.img:SetPos(px,py)
		local scale = GetAdapterScale(720,720,w,h)
		obj.img:SetScale(scale,scale)
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
	return obj
end