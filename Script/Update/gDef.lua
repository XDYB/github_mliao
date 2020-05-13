local kd = KDGame;

gDef = {};

-- =====================================================
-- 上线需要修改的配置 START
-- =====================================================
local Testt = false;		--测试 ture为本地
if Testt then
	gDef.PostUrl = "http://10.10.11.77:8668/";
	gDef.domain = "http://10.10.11.77/" -- 图片域名
else
	gDef.PostUrl = "http://47.97.65.170:8668/";
	gDef.domain = "http://47.97.65.170/" -- 图片域名
end

-- =====================================================
-- 上线需要修改的配置 END
-- =====================================================

-- 是否是测试环境
gDef.Test = true;

gDef.IphoneXWH = "_19X9";						-- 是否X界面适配1
gDef.Channel = "CG007";							-- 渠道
gDef.PackageName = "com.IVGOAL.test.CApp1";				-- 包名
gDef.IphoneXView = kd.SceneSize.ratio <= 0.5;	-- 是否X界面适配
gDef.SysStateBarStyle = 0						-- 系统状态栏默认颜色 0 黑 1 白

-- 权限
gDef.ConfigPath = "LocalFile/ConfigA/";
gDef.JurisdictionFile = "Jurisdiction.ini";

--弹框消息结构(最多支持3行字,每行文字支持单独设置颜色,固定2个按钮)
gDef.tagMsgBoxInfo =
{
	txt = {nil,nil,nil},						--文字内容列表
	cls = {0xff333333,0xff333333,0xff333333},	--文字颜色列表
	btn = {"No","Yes"},							--按钮标题列表
	fn = {nil,nil},								--回调函数列表
}

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



-- 域名
gDef.SysInfo = KDGame.GetSystemInfo();
-- Http头
local header = {
	-- 手机品牌
	"phoneBrand="..gDef.SysInfo.phone_brand,
	-- 操作系统
	"phoneSystem="..gDef.SysInfo.system_version,
	-- 手机型号
	"phoneModels="..gDef.SysInfo.phone_model,
	-- 渠道
	"appMarket="..gDef.Channel,
	-- app版本号
	"appVersionCode=5.0",
	-- app版本名字
	"appVersionName=1.0",
	-- api版本
	"apiVersion=text",
	-- 包名
	"packageName="..gDef.PackageName,
	-- app类型（主包默认0）
	"appType=0",
	--  'oaid、imei、idfa'
	"imei=oaid",
	-- 设备类型
	"deviceType=0",
	-- 本地ip
	"localIp=127.0.0.1",
	-- 是否平板
	"isTablet=0",
	-- 运营商
	"isp=yidong",
	-- mac
	"mac=mac",
	-- uuid
	"uuid="..(kd.CreateUUID()),
	-- 网络类型
	"networkType=5G",
	-- appId
	"appId=1",
}
gDef.HeadInfo = table.concat(header,"&")
gDef.Test = true;
gDef.Aes128Decode = "akajglk(U(hngl))";
gDef.policy = gDef.domain.."michat/html/privacy.html" -- 隐私政策
gDef.agreement = gDef.domain.."michat/html/agreement.html" -- 用户协议

-- =====================================================
-- 热更新测试 正式发布时删除 START
-- =====================================================
--gDef.PostUrl = "http://v5.online.test.vliao9.com:8668/"
-- =====================================================
-- 热更新测试 正式发布时删除 END
-- =====================================================


gDef.uiPrefix = "ML_"   -- 资源前缀
gDef.uiSuffix = "_LM"   -- 资源后缀
gDef.uiPath = gDef.uiPrefix.."jrui"..gDef.uiSuffix          -- 资源文件路径
gDef.uiPathX = gDef.uiPrefix.."jrui_19X9"..gDef.uiSuffix    -- 资源文件路径

-- 声音
gDef.Sounds = {
	OnCall = "ResAll/"..gDef.uiPrefix.."sounds"..gDef.uiSuffix.."/video_chat_tip_OnCall.mp3",-- 对方正在通话中
	HangUp = "ResAll/"..gDef.uiPrefix.."sounds"..gDef.uiSuffix.."/video_chat_tip_HangUp.mp3",-- 对方暂时无法接听
	Sender = "ResAll/"..gDef.uiPrefix.."sounds"..gDef.uiSuffix.."/video_chat_tip_sender.mp3",-- 呼出
	Notify = "ResAll/"..gDef.uiPrefix.."sounds"..gDef.uiSuffix.."/video_chat_post_notification.mp3", -- 呼入
}


-- ==================================================================
-- 						 热更新 START
-- ==================================================================
gDef.updatePrefix = "VO_"
gDef.updateSuffix = "_OV"
gDef.updateUIPath = gDef.updatePrefix.."jrui"..gDef.updateSuffix
gDef.updateUIPathX = gDef.updatePrefix.."jrui_19X9"..gDef.updateSuffix
gDef.views = {
	-- 新版本
	["version"] = "jrgengxin",     -- 发现新版本
	-- 热更新
	["update"] = "jrgengxinjiazai",-- 更新进度条
	-- 加载
	["load"] = "jrjiazai",		   -- 加载
}

function gDef.GetUpdateView(layer,uiname)
	if gDef.IphoneXView then
        -- iphonex
		local path = "ResAll/"..gDef.uiPrefix.."update"..gDef.uiSuffix.. "/"..gDef.uiPathX.."/"..gDef.uiPrefix ..gDef.views[uiname]..gDef.uiSuffix.."."..kd.resallFix
		local path = "ResAll/"..gDef.updatePrefix.."update"..gDef.updateSuffix.. "/"..gDef.updateUIPathX.."/"..gDef.updatePrefix ..gDef.views[uiname]..gDef.updateSuffix.."."..kd.resallFix
		local thview =  kd.class(kd.ResManage,path,layer);
		return thview;
	else
        -- iphone 6 7 8
		local path = "ResAll/"..gDef.uiPrefix.."update"..gDef.uiSuffix.. "/"..gDef.uiPath.."/"..gDef.uiPrefix ..gDef.views[uiname]..gDef.uiSuffix.."."..kd.resallFix
		local path = "ResAll/"..gDef.updatePrefix.."update"..gDef.updateSuffix.. "/"..gDef.updateUIPath.."/"..gDef.updatePrefix ..gDef.views[uiname]..gDef.updateSuffix.."."..kd.resallFix
		local thview =  kd.class(kd.ResManage,path,layer);
		return thview;
	end
end
--得到添加前后缀的路径
function gDef.GetUpdateResPath(szPath)
	local str = szPath;
	local strNew = "";
	
	--根目录不加前后缀
	local nFind = string.find(str,"ResAll/");
	if(nFind) then 	
		strNew = "ResAll/";
		str = string.sub(str, nFind+7, -1);
	end	
	
	while(string.len(str)>0) do
		local nFind = string.find(str,"/");
		if(nFind==nil) then break; end
		local tmp = string.sub(str,1,nFind-1);
		if tmp=="UI" and gDef.IphoneXView then
			tmp = gDef.updatePrefix..tmp..gDef.IphoneXWH..gDef.updateSuffix.."/";
		else
			tmp = gDef.updatePrefix..tmp..gDef.updateSuffix.."/";
		end
		
		strNew = strNew..tmp;
		str = string.sub(str, nFind+1, -1);
	end
	
	nFind = string.find(str,"%.");
	if(nFind==nil) then return strNew; end
	
	local tmp = string.sub(str,1,nFind-1);
	tmp = gDef.updatePrefix..tmp..gDef.updateSuffix..".";	
	strNew = strNew..tmp;
	str = string.sub(str, nFind+1, -1);
	strNew = strNew..str;
	
	return strNew;
end


-- ==================================================================
-- 						 热更新 END
-- ==================================================================

function gDef.GetView(layer,uiname)
	if gDef.IphoneXView then
        -- iphonex
		local thview =  kd.class(kd.ResManage,"ResAll/"..gDef.uiPathX.."/".. gDef.uiPrefix ..gDef.views[uiname]..gDef.uiSuffix.."."..kd.resallFix,layer);
		return thview;
	else
        -- iphone 6 7 8
		local thview =  kd.class(kd.ResManage,"ResAll/"..gDef.uiPath.. "/"..gDef.uiPrefix ..gDef.views[uiname]..gDef.uiSuffix.."."..kd.resallFix,layer);
		return thview;
	end
end


--1个汉字或大写字母=2个小写字母
-- @bCharAsSingle true 汉字视为1个字符 
function gDef.GetTextCount(str,bCharAsSingle)
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


--用户名称显示长度限制：1个中文等于2个字符长度,符号英文等于1个，超过限制长度显示为：...
function gDef:GetName(szName,nLenght)
	if(type(szName)~="string") then return szName; end
	nLenght = nLenght or 5;
	nLenght = nLenght*2;
	local szTxt = "";
	local szMaxTxt = "";
	local list = self:utf8tochars(szName);	--拆分
	local nCnt = 0;
	for i=1,#list do
		nCnt = nCnt+self:GetTextCount(list[i].char);
		if nCnt+3>nLenght then
			szTxt = szMaxTxt.."...";
			break;
		else
			szTxt = szTxt..list[i].char;
			if(nCnt<=nLenght) then szMaxTxt = szTxt; end
		end
	end
		
	return szTxt;
end


--功能：将字符串拆成单个字符，存在一个table中
function gDef:utf8tochars(input)
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
        -- print(str)
        index = index + offset;
        table.insert(list, {byteNum = offset, char = str});
     end

     return list;
end	


-- 获取文本的像素
function gDef:GetTextLen(nFontSize, str)
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

-- 创建文本输入框 定位方式参考精灵类
-- @father 父层
-- @x 中心点x坐标
-- @y 中心点y坐标
-- @w 宽
-- @h 高
-- @fontSize 字体大小
-- @fontColor 颜色
-- @isDebug 是否调试
function gDef:AddEditBox(father,x,y,w,h,fontSize,fontColor,isDebug)
	----------------------------发测后隐藏红框
	isDebug = false;
	----------------------------
	
    local input = kd.class(kd.EditBox, w, h,"null",fontSize,fontColor);
    input:SetPos(x,y)
    father:addChild(input);
	input.SetInputTextAlign = function(text)
		local ScreenW = kd.SceneSize.width;
		--[[
		local cnt = self:GetTextCount(text);
		local textW =  cnt * 22;
		--]]
		local textW = self:GetTextLen(44,text);
		local _,y = input:GetPos();
		input:SetPos(ScreenW-textW/2,y);
	end

    local delegate = kd.class(kd.EidtBoxDelegate);
    delegate.editBoxTextChanged = function(self,text)
        if input.OnTextChanged then
            input:OnTextChanged(text)
        end
    end	
	
	--编辑结束(失去焦点)
	 delegate.editBoxEditingDidEnd = function(self,text)
        if input.OnEditingDidEnd then
            input:OnEditingDidEnd(text)
        end
    end	
	
	--开始编辑的回调函数
	delegate.editBoxEditingDidBegin = function(self,text)
        if input.EditingDidBegin then
            input:EditingDidBegin(text)
        end
    end	
	
		
	--回车键被按下或键盘的外部区域被触摸时
	delegate.editBoxReturn = function(self)
		print("编辑框Return");
	    if input.EditingReturn then
            input:EditingReturn()
        end
	end;
	
	
		--[[	self.m_EditBoxDelegate01.editBoxReturn = function(self)
		self.father:onGuiToucBackCall(ID_GUI_SEND);
	end	--]]	
	
	
	
		
	input:SetDelegate(delegate);	

    if isDebug then
        --坐标系转换 文本框圆点（0,0）位于左上角   几何原点（0,0）位于左下角
        local me_Geometry = kd.class(kd.GeometryDraw);
        father:addChild(me_Geometry);
        local pints = {
            {x=x-w/2, y=kd.SceneSize.high-(y-h/2)},
            {x=x+w/2, y=kd.SceneSize.high-(y-h/2)},
            {x=x+w/2, y=kd.SceneSize.high-(y+h/2)},
            {x=x-w/2, y=kd.SceneSize.high-(y+h/2)},
        };
        me_Geometry:DrawPolygon(pints, 0, 2, 0xffff0000);    
    end  
    return input
end


function gDef:InRect(x,y,x1,y1,x2,y2)
	if x>x1 and x<x2 and y>y1 and y<y2 then
		return true;
	end
	return false;
end


--实现颜色渐变
--step 几个梯度
function gDef:gradientColor(begin_color,end_color,color_count)
	 if color_count < 2 then
        return nil;
	end
	local startRGB = {};
	local endRGB = {};
	local sRGB = {};
	local colorArr = "";
	for i=1,3 do
		local a = i*2;
		local tmp1 = string.sub(begin_color,a,a+1);
		startRGB[i] = tonumber(tmp1,16);
		
		local tmp2 = string.sub(end_color,a,a+1);
		endRGB[i] = tonumber(tmp2,16);
		
		--总差值
		sRGB[i] = startRGB[i]+(endRGB[i]-startRGB[i])*color_count//100;
		
		local x16 = string.format("%#x",sRGB[i]);
		colorArr = colorArr..string.sub(x16,3,4);
	end
	
	return colorArr;
end
	
	
-- 获取GUI 适用于获取UI编辑器的资源
-- @father
-- @iResID
-- @paddingTop int 上边距
-- @paddingRight int 右边距
-- @paddingBottom int 下边距
-- @paddingLeft int 左边距
function gDef:AddGuiByID(father,iResID,paddingTop,paddingRight,paddingBottom,paddingLeft)
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

--[[
根据精灵位置创建GUI
@father
@spr 精灵 或 文字（需要自己设边距）
@iResID onGuiToucBackCall参数
@paddingTop int 上边距
@paddingRight int 右边距
@paddingBottom int 下边距
@paddingLeft int 左边距
--]]
function gDef:AddGuiBySpr(father,spr,iResID,paddingTop,paddingRight,paddingBottom,paddingLeft)
    paddingTop = paddingTop and paddingTop or 0;
    paddingRight = paddingRight and paddingRight or 0;
    paddingBottom = paddingBottom and paddingBottom or 0;
    paddingLeft = paddingLeft and paddingLeft or 0;
    
    local width,height = 0,0;
	if spr.GetTexWH then
        width,height = spr:GetWH();
        local scalex,scaley = spr:GetScale();
        width = width * scalex;
        height = height * scaley;
    end
    
    local posX,posY = spr:GetPos();
    local x = posX - width/2 - paddingLeft;
    local y = posY - height/2 - paddingTop;
    local w = width + paddingLeft + paddingRight;
    local h = height + paddingTop + paddingBottom;
    
    local clickGui = kd.class(kd.GuiObjectNew, father, iResID, x, y, w, h, false, true);
    clickGui:setDebugMode(true);
    father:addChild(clickGui);
    clickGui.SetPos = function(this,px,py)
       local x = px - w/2 - paddingLeft;
       local y = py - h/2 - paddingTop;
       local w = w + paddingLeft + paddingRight;
       local h = h + paddingTop + paddingBottom;
       clickGui:SetTouchRect(x,y,w,h);
    end
    return clickGui;
end


--设置头像
function gDef:SetCustomFace(father,iResID,avatar,clickAble,bAudit,typeId)
	local x,y,faceR,h = father.m_thView:GetScaleRect(iResID);
	
	local nR = 303;
	local fw,fh = nR,nR;		--默认头像
    local gui = kd.class(kd.GuiObjectNew, father, 0, 0, 0, faceR, faceR, false, false);
	if gui ==nil then	--创建GUI失败，return
		return;
	end
	
	-- 圆形蒙版
	local maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/QiTa/Zl_touxiang.png"));
	-- 方形蒙版 默认残缺图片
	if typeId == 2 then
		maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"),0, 1698, 329, 329);
		fw = faceR > h and faceR or h;
		fh = fw;
	-- 方形蒙版 默认“+”
	elseif typeId == 3 then
		maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"),926, 1746, 280, 280);
		fw = faceR > h and faceR or h;
		fh = fw;
	-- 圆形蒙版 默认“+”
	elseif typeId == 4 then
		maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"),331, 1728, 300, 300);
		fw = faceR > h and faceR or h;
		fh = fw;
	end
	
    -- 根据头像实际尺寸 缩放蒙板
    maskSpr:SetScale(faceR/fw,faceR/fh);
    maskSpr:SetPos(x,y);
    gui:setMaskingClipping(maskSpr);
	
	-- 圆形默认图
	local faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/QiTa/Zl_touxiang.png"));
	-- 方形 默认残缺图片
	if typeId == 2 then
		faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"),0, 1698, 329, 329);
	-- 方形蒙版 默认“+”
	elseif typeId == 3 then
		faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"),926, 1746, 280, 280);
	-- 圆形蒙版 默认“+”
	elseif typeId == 4 then
		faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"),331, 1728, 300, 300);
	end
	
	 -- local fw,fh = faceSpr:GetTexWH();
    faceSpr:SetScale(faceR/fw,faceR/fh);
    faceSpr:SetPos(x,y);
    gui:addChild(faceSpr);
	
	 --设置头像
    father.m_thView:SetCustomRes(iResID,gui);
	--local url = "http://cdn.vliao1.xyz/prod/image/default_avatar.jpg";
	if avatar then		--不传就显示默认头像
		if type(avatar)=="table" then
			if avatar.url~="" then
				local fLoadW,fLoadH = faceR,faceR;
				local szUrl = avatar.url;
				if(avatar.width > fLoadW and avatar.height > fLoadH) then
					local fScaleX = fLoadW/avatar.width;
					local fScaleY = fLoadH/avatar.height;
					local fScale,f = math.modf(math.max(fScaleX,fScaleY)*100);
					if(f>0) then fScale = fScale + 1; end
					szUrl = szUrl.."?x-oss-process=image/resize,p_"..fScale;
				end					
				faceSpr = kd.class(kd.AsyncSprite, szUrl);
				faceSpr:SetPos(x,y);
				gui:addChild(faceSpr);
			end
		elseif string.startsWith(avatar,"http") then
			--先把之前的默认头像清除掉
			gui:RemoveChild(faceSpr);
			faceSpr = nil;
			
			faceSpr = kd.class(kd.AsyncSprite, avatar);
			faceSpr:SetPos(x,y);
			gui:addChild(faceSpr);
			
		 else
			-- 本地
			if kd.IsFileExist(avatar) then
				--先把之前的默认头像清除掉
				gui:RemoveChild(faceSpr);
				faceSpr = nil;
				
				faceSpr = kd.class(kd.Sprite, avatar);
				faceSpr:SetPos(x,y);
				gui:addChild(faceSpr);
				
			else
				kd.LogOut("图片件不存在");
			end
		end
		
		--加载三级缓存纹理结果回调
		faceSpr.OnLoadTextrue = function(self, --[[int]] err_code --[[0:成功]], --[[string]] err_info)
			if err_code == 0 then
				local w,h = self:GetTexWH();
				if(w~=faceR or h~=faceR) then
					local fScaleX = faceR/w;
					local fScaleY = faceR/h;
					local fScale = math.max(fScaleX,fScaleY);
					self:SetScale(fScale,fScale);
				end
			end
		end
	end
	
	if bAudit then 
		faceSpr.audit = kd.class(kd.Sprite,self:GetResPath("ResAll/YinDao.png"),1290,1632,140,140);
		faceSpr.audit:SetPos(x,y);
		faceSpr.audit:SetScale(2,2);
		gui:addChild(faceSpr.audit);
		faceSpr.tip = kd.class(kd.StaticText,28,"审核中",kd.TextHAlignment.CENTER,3*28,28);
		gui:addChild(faceSpr.tip);
		faceSpr.tip:SetPos(x,y);
	end
    
	local clickGui= {};
    --可点击
    if clickAble then
		clickGui = kd.class(kd.GuiObjectNew, father, iResID, x-faceR/2, y-faceR/2, faceR, faceR, false, true);
        clickGui:setDebugMode(true);
        father:addChild(clickGui);
		clickGui.SetPos = function(this,px,py)
			local x = px - faceR/2
			local y = py - faceR/2
			clickGui:SetTouchRect(x,y,faceR,faceR);
		end
    end

	return faceSpr,maskSpr,clickGui;
end

--设置头像（PKLM）
-- @father		父层
-- @iResID		自定义层ID
-- @avatar		头像路径
-- @clickAble	是否可以点击
-- @nType		图片的类型（默认：显示残破的灰色图片）
function gDef:SetFaceForGame(father,iResID,avatar,clickAble,nType)
	local x,y,faceR,h = father.m_thView:GetScaleRect(iResID);
    local faceGui = kd.class(kd.GuiObjectNew, father, iResID, 0, 0, faceR, faceR, false, false);
	faceGui.x,faceGui.y = x,y;
	faceGui.nType = nType;
	
	
	-- 方形蒙版 默认残缺图片
	faceGui.maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"));
	faceGui.sprDefault = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"));
	-- 方形蒙版 默认“+”
	if nType == nil then
		faceGui.maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"));
		faceGui.maskSpr:SetTextureRect(1384, 1589, 294, 294);
	elseif nType == 1 then
		faceGui.maskSpr:SetTextureRect(926, 1746, 280, 280);
	-- 圆形头像
	elseif nType == 2 then
		faceGui.maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/TX263.png"));
	-- 相册默认图
	elseif nType == 4 then
		faceGui.maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/TX321.png"));
	elseif nType == 5 then
		faceGui.maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/TX2302.png"));
	elseif nType == 3 then
		faceGui.maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"),662, 905, 720, 720);
	elseif nType == 6 then
		faceGui.maskSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/TX263.png"));
	end

    local w,h = faceGui.maskSpr:GetWH();
    local scale = faceR/w;
	faceGui.scale = scale;
	faceGui.faceR = faceR;
    faceGui.maskSpr:SetScale(scale,scale);
    faceGui.maskSpr:SetPos(x,y);
	faceGui:setMaskingClipping(faceGui.maskSpr);
    
	 --设置头像
    father.m_thView:SetCustomRes(iResID,faceGui);
	
    if avatar == nil then
        -- 默认头像
		faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"));
		if nType == nil then
			faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"));
			faceGui.faceSpr:SetTextureRect(1384, 1589, 294, 294);
		elseif nType == 1 then
			faceGui.faceSpr:SetTextureRect(926, 1746, 280, 280);
		elseif nType == 2 then
			faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/TX263.png"));
		elseif nType == 4 then
			local offset = 20
			faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"),563 + offset, 1525+ offset, 343 - 2*offset, 343- 2*offset);
		elseif nType == 5 then
			faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/TX2302.png"));
		elseif nType == 3 then
			faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"),662, 905, 720, 720);
		elseif nType == 6 then
			faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"),593, 1555, 283, 283);
		end
        faceGui.faceSpr:SetScale(scale,scale);
        faceGui.faceSpr:SetPos(x,y);
        faceGui:addChild(faceGui.faceSpr);
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
			if father.OnLoadTextrueFinish then
				father:OnLoadTextrueFinish();
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
		else
			kd.LogOut("图片件不存在");
		end
		
        
    end

    --可点击
    if clickAble then
		if faceGui.clickGui ~= nil and (not faceGui.clickGui:IsVisible()) then
			father:RemoveChild(faceGui.clickGui);
		end
        faceGui.clickGui = kd.class(kd.GuiObjectNew, father, iResID, x-faceR/2, y-faceR/2, faceR, faceR, false, true);
        father:addChild(faceGui.clickGui)
		faceGui.clickGui:setDebugMode(true);
		faceGui.clickGui.id = iResID;
    end

    -- 刪除
    faceGui.DelCustomFace = function(this)
        if this then
            this:RemoveChild(this.faceSpr);
            this.faceSpr = nil;
			if bSquare == false then
				this:RemoveChild(this.faceSpr1);
				this.faceSpr1 = nil;
			end
        end
  
        -- 特別説明 不能从自己的响应中移除自己，暂时只能禁用。
        if this.clickGui then
			this.clickGui:SetVisible(false);   
			father:RemoveChild(faceGui.clickGui)
        end
        if this then
            father:RemoveChild(this);
            faceGui = nil;
        end
    end
	
	 -- 设置新头像
    faceGui.SetFace = function(this,szFace,bRemove)
		if faceGui then
			--默认移除上个图片
			if bRemove == nil then
				faceGui:RemoveChild(faceGui.faceSpr);
				faceGui.faceSpr = nil;
			end
			
			if (szFace~=nil and string.len(szFace)>0 and 				--有自定义头像
				kd.IsFileExist(szFace) == true) then	
					faceGui.faceSpr = kd.class(kd.Sprite, szFace);
			elseif szFace~=nil and string.startsWith(szFace,"http") then
				-- 网络
				faceGui.faceSpr = kd.class(kd.AsyncSprite, szFace);
				faceGui.faceSpr:SetPos(x,y);
				faceGui:addChild(faceGui.faceSpr);
				--加载三级缓存纹理结果回调
				faceGui.faceSpr.OnLoadTextrue = function(this, --[[int]] err_code --[[0:成功]], --[[string]] err_info)
					if err_code == 0 then
						local w,h = this:GetWH();
						local sprScale = GetAdapterScale(w,h,faceGui.faceR,faceGui.faceR);
						this:SetScale(sprScale,sprScale);
					end
					if father.OnLoadTextrueFinish then
						father:OnLoadTextrueFinish();
					end	
				end
				return ;
			else
				faceGui.faceSpr = kd.class(kd.Sprite, gDef.GetResPath("ResAll/Main2.png"));
				if faceGui.nType == nil then
					faceGui.faceSpr:SetTextureRect(1384, 1589, 294, 294);
				elseif faceGui.nType == 1 then
					faceGui.faceSpr:SetTextureRect(926, 1746, 280, 280);
				elseif nType == 2 then
					faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/TX263.png"));
				elseif nType == 5 then
					faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/TX2302.png"));
				elseif nType == 4 then
					local offset = 20
					faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"),563 + offset, 1525+ offset, 343 - 2*offset, 343- 2*offset);
				elseif nType == 3 then
					faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main2.png"),662, 905, 720, 720);
				elseif nType == 6 then
					faceGui.faceSpr = kd.class(kd.Sprite,gDef.GetResPath("ResAll/Main.png"),593, 1555, 283, 283);
				end
			end		
			faceGui:addChild(faceGui.faceSpr);
			faceGui.faceSpr:SetPos(faceGui.x,faceGui.y);
			local w2,h = faceGui.faceSpr:GetWH();
			local scale1 = GetAdapterScale(w2,h,faceGui.faceR,faceGui.faceR);
			faceGui.faceSpr:SetScale(scale1,scale1);
        end
	end	

	return faceGui;
end



--得到添加前后缀的路径
function gDef.GetResPath(szPath)
	local str = szPath;
	local strNew = "";
	
	--根目录不加前后缀
	local nFind = string.find(str,"ResAll/");
	if(nFind) then 	
		strNew = "ResAll/";
		str = string.sub(str, nFind+7, -1);
	end	
	
	while(string.len(str)>0) do
		local nFind = string.find(str,"/");
		if(nFind==nil) then break; end
		local tmp = string.sub(str,1,nFind-1);
		if tmp=="UI" and gDef.IphoneXView then
			tmp = gDef.uiPrefix..tmp..gDef.IphoneXWH..gDef.uiSuffix.."/";
		else
			tmp = gDef.uiPrefix..tmp..gDef.uiSuffix.."/";
		end
		
		strNew = strNew..tmp;
		str = string.sub(str, nFind+1, -1);
	end
	
	nFind = string.find(str,"%.");
	if(nFind==nil) then return strNew; end
	
	local tmp = string.sub(str,1,nFind-1);
	tmp = gDef.uiPrefix..tmp..gDef.uiSuffix..".";	
	strNew = strNew..tmp;
	str = string.sub(str, nFind+1, -1);
	strNew = strNew..str;
	
	return strNew;
end


--WIN32模式下伪装系统状态栏
if(kd.GetSystemType()~=kd.SystemType.OS_IOS) then
	local szDingBu = "DingBu_Hei";
	if(gDef.IphoneXView) then szDingBu = szDingBu..gDef.IphoneXWH; end
	gDef.SysBarSpr = kd.class(kd.Sprite, "ResAll/WIN32/"..szDingBu..".png");
	if(gDef.SysBarSpr) then
		kd.AddLayer(gDef.SysBarSpr);
		gDef.SysBarSpr:SetZOrder(9999);
		local w,h = gDef.SysBarSpr:GetTexWH();
		gDef.SysBarSpr:SetPos(kd.SceneSize.width/2,h/2);
		gDef.SysBarSpr:SetVisible(false);
	end
	
	if(gDef.IphoneXView) then
		gDef.BottomBarSpr = kd.class(kd.Sprite,"ResAll/WIN32/DiBu_Hei_19X9.png");
		if(gDef.BottomBarSpr) then
			kd.AddLayer(gDef.BottomBarSpr);
			gDef.BottomBarSpr:SetZOrder(9998);
			local w,h = gDef.BottomBarSpr:GetTexWH();
			gDef.BottomBarSpr:SetPos(kd.SceneSize.width/2,kd.SceneSize.high - h/2);
			gDef.BottomBarSpr:SetVisible(true);
		end		
	end
	
	kd.SetSysStateBar = function(bVisible)
		if(gDef.SysBarSpr) then gDef.SysBarSpr:SetVisible(bVisible); end
	end
end

kd.SetSysStateBarStyle = function(Style)
	--[[if true then
		c_SetSysStateBarStyle(0);
	end--]]
	
	if(Style==nil) then return; end
	if(gDef.SysBarSprStyle==Style) then return; end
	gDef.SysBarSprStyle=Style;
	
	if(kd.GetSystemType()~=kd.SystemType.OS_IOS) then
		if(gDef.SysBarSpr==nil) then return; end
		local szDingBu = "DingBu_Hei";
		if(Style==1) then szDingBu = "DingBu_Bai"; end	
		if(gDef.IphoneXView) then szDingBu = szDingBu..gDef.IphoneXWH; end
		gDef.SysBarSpr:SetTexture("ResAll/WIN32/"..szDingBu..".png");
		
		if(gDef.BottomBarSpr) then
			if(Style==1) then
				gDef.BottomBarSpr:SetTexture("ResAll/WIN32/DiBu_Bai_19X9.png");
			else
				gDef.BottomBarSpr:SetTexture("ResAll/WIN32/DiBu_Hei_19X9.png");
			end
		end
	else
		--IOS默认黑色------下期在优化
--		c_SetSysStateBarStyle(0);
		c_SetSysStateBarStyle(Style);
	end
end	

kd.GetSysStateBarStyle = function()
	return gDef.SysBarSprStyle;
end

gDef.SysBarSprStyle = 0;

kd.SetSysStateBarStyle(gDef.SysStateBarStyle)



--系统状态栏高度
gDef.SysBarH = 58;
if(gDef.IphoneXView) then gDef.SysBarH = 126; end
--多标签标题栏高度
gDef.TitleH = 126+gDef.SysBarH; 
--固定标题栏高度
gDef.HeadH = 126+gDef.SysBarH;
--底部状态栏高度
gDef.BottomH = 140; 

--消息时间提醒（秒）
gDef.MesTimeReminder = 180; 		