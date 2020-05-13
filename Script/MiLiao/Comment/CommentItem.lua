--[[

	评论 -- 单项

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

CommentItem = kd.inherit(kd.Layer);
local impl = CommentItem;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

local idsw = {
	--/* Text ID */
	ID_TXT_NO0                 = 4001,
	ID_TXT_NO1                 = 4002,
	ID_TXT_NO2                 = 4003,
	ID_TXT_NO3                 = 4004,
	--/* Custom ID */
	ID_CUS_ML_TX1_LM           = 6001,
}

function impl:init(data)
	self.m_thView = kd.class(kd.ResManage, gDef.GetResPath("ResAll/UI/PLLieBiao.UI"), self);
	if (self.m_thView) then
		self:addChild(self.m_thView);
	end
	-- 设置头像
	self.m_cusFace = gDef:SetFaceForGame(self,idsw.ID_CUS_ML_TX1_LM,nil,false,2);
	-- 昵称
	self.m_txtName = self.m_thView:GetText(idsw.ID_TXT_NO1);
	self.m_txtName:SetHAlignment(kd.TextHAlignment.LEFT);
	-- 动态说明
	--[[self.m_txtContent = self.m_thView:GetText(idsw.ID_TXT_NO0);
	local str = self.m_txtContent:GetString();
	local len = gDef:GetTextLen(35,str);
	self.m_txtContent:SetWH(len, 35*2+10);
	self.m_txtContent:SetHAlignment(kd.TextHAlignment.LEFT);
	self.m_thView:SetVisible(idsw.ID_TXT_NO2, false);
	local x,y = self.m_txtContent:GetPos();
	self.m_txtContent:SetPos(x-20, y + 20);--]]
	self.m_txtContent1 = self.m_thView:GetText(idsw.ID_TXT_NO0);
	self.m_txtContent1:SetHAlignment(kd.TextHAlignment.LEFT);
	self.m_txtContent2 = self.m_thView:GetText(idsw.ID_TXT_NO2);
	self.m_txtContent2:SetHAlignment(kd.TextHAlignment.LEFT);
	-- 时间
	self.m_txtTime = self.m_thView:GetText(idsw.ID_TXT_NO3);
	self.m_txtTime:SetHAlignment(kd.TextHAlignment.RIGHT);
	local x,y = self.m_txtTime:GetPos();
	self.m_txtTime:SetPos(x-50,y);
	
	self:initView();
	
	self:SetViewData(data);
end

function impl:initView()
	self.m_cusFace:SetFace();
	self.m_txtName:SetString("----");
	self.m_txtContent1:SetString("----");
	self.m_txtContent2:SetString("");
	self.m_txtTime:SetString("----");
end

function impl:SetViewData(data)
	local name = data.NickName;
	local count = data.Content;
	local txtTime = self:SetTime(data.Cdate);
	local url = gDef.domain..data.AvatarFile;
	
	self.m_txtName:SetString(name);
	local tabStr = self:GetShortName(count, 36, 36);
	if tabStr and #tabStr == 2 then
		self.m_txtContent1:SetString(tabStr[1]);
		self.m_txtContent2:SetString(tabStr[2]);
	end
	self.m_cusFace:SetFace(url);
	self.m_txtTime:SetString(txtTime);
	
end

-- 获取页面高度
function impl:GetWH()
	local x,y = self.m_txtContent2:GetPos();
	return ScreenW, y + 30;
end

--设置加入时间
function impl:SetTime(szTime)
	if szTime==nil then
		return;
	end
	local dwTime = os.time(); 		--得到当前时间戳
	dwTime = dwTime-szTime;
	local strTime = "";
	local Day = dwTime//86400;		--得到天数
	local Hour = dwTime//3600;		--得到小时(天数不足时才能得到)
	local Minute = dwTime//60;		--得到分钟(同上)
	if Day>0 then
		if Day>=30 then
			strTime = "30天前";
		else
			strTime = Day.."天前";
		end
	elseif Hour>0 then
		strTime = Hour.."小时前";	
	elseif Minute>0 then	
		if Minute>30 and Minute<60 then
			strTime = "半小时前";	
		else
			strTime = Minute.."分钟前";	
		end
	else
		strTime = "刚刚";
	end
	return strTime;
end

--@param	sName:要切割的字符串
--@return	nMaxCount，字符串上限,中文字为2的倍数
--@param	nShowCount：显示英文字个数，中文字为2的倍数,可为空
function impl:GetShortName(sName,nMaxCount,nShowCount)
    if sName == nil or nMaxCount == nil then
        return
    end
    local sStr = sName
	local returnStr = {};
    local tCode = {}
    local tName = {}
    local nLenInByte = #sStr
    local nWidth = 0
    if nShowCount == nil then
       nShowCount = nMaxCount - 3
    end
    for i=1,nLenInByte do
        local curByte = string.byte(sStr, i)
        local byteCount = 0;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        local char = nil
        if byteCount > 0 then
            char = string.sub(sStr, i, i+byteCount-1)
            i = i + byteCount -1
        end
        if byteCount == 1 then
            nWidth = nWidth + 1
            table.insert(tName,char)
            table.insert(tCode,1)
            
        elseif byteCount > 1 then
            nWidth = nWidth + 2
            table.insert(tName,char)
            table.insert(tCode,2)
        end
    end
    
    if nWidth > nMaxCount then
        local _sN = ""
		local _eN = ""
        local _len = 0
        for i=1,#tName do
            if _len < nShowCount then
				_sN = _sN .. tName[i]
            elseif _len >= nShowCount then
                _eN = _eN .. tName[i]
            end
            _len = _len + tCode[i]
        end
        returnStr = {_sN, _eN }
	else
		returnStr = {sName,""}
    end
    return returnStr
end
