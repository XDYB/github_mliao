-- 检测是否为数值
function checknumber(value, base)
    return tonumber(value, base) or 0
end
-- 检测是否为整数
function checkint(value)
    return math.round(checknumber(value))
end
-- 四舍五入
function math.round(value)
    value = checknumber(value)
    return math.floor(value + 0.5)
end


function string.startsWith(strs,str)
    local startIndex,endIndex = string.find(strs, str);
    if startIndex and startIndex==1 then
        return true;
    end
    return false;
end


-- 等比 自适应容器尺寸，丢失边缘
function GetAdapterScale(w,h,targetW,targetH)
	local scaleX = targetW / w;
	local scaleY = targetH / h;
	return math.max(scaleX,scaleY);
end
-- 等比 缩放到容器以内，边缘空白
function GetInnerScale(w,h,targetW,targetH)
	if w > h then
		return targetH / h;
	else
		return targetW / w;
	end
end
function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
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

--[[--

将来源表格中所有键及其值复制到目标表格对象中，如果存在同名键，则覆盖其值

~~~ lua

local dest = {a = 1, b = 2}
local src  = {c = 3, d = 4}
table.merge(dest, src)
-- dest = {a = 1, b = 2, c = 3, d = 4}

~~~

]]

-- end --

function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end


-- start --



-- 比较是否相等
function table.equal(value1, value2)
	if value1 == nil and value2 == nil then
		return true
	end
	
	if value1 == nil or value2 == nil then
		return false
	end
	
	if type(value1) ~= "table" and type(value2) ~= "table" then
		return value1 == value2
	end
	
	if type(value1) ~= "table" or type(value2) ~= "table" then
		return false
	end
	
	for k,v in pairs(value1) do
		if table.equal(value2[k],v) == false then 
			return false
		end
	end
	return true
end
