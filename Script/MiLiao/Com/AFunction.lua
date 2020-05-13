-- 控制台输出 用于替代 KD.Log 和 echo 以便上线时注释
function echo(s)
	-- do sth...
	print(s)
end

-- 调试打印全局方法 上线可注释
-- @t 要打印的table
function dump ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            echo(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        echo(indent.."["..pos.."] => {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        echo(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        echo(indent.."["..pos..'] => "'..val..'"')
                    else
                        echo(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                echo(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        echo(" {")
        sub_print_r(t,"  ")
        echo("}")
    else
        sub_print_r(t,"  ")
    end
--    echo()
end

--[[--

从表格中删除指定值，返回删除的值的个数

~~~ lua

local array = {"a", "b", "c", "c"}
echo(table.removebyvalue(array, "c", true)) -- 输出 2

~~~

@param table array 表格
@param mixed value 要删除的值
@param [boolean removeall] 是否删除所有相同的值

@return integer

]]
function table.removebyvalue(array, value, removeall)
    local c, i, max = 0, 1, #array;
    while i <= max do
        if array[i] == value then
            table.remove(array, i);
            c = c + 1;
            i = i - 1;
            max = max - 1;
            if not removeall then break end
        end
        i = i + 1;
    end
    return c;
end



--[[--

用指定字符或字符串分割输入字符串，返回包含分割结果的数组

~~~ lua

local input = "Hello,World"
local res = string.split(input, ",")
-- res = {"Hello", "World"}

local input = "Hello-+-World-+-Quick"
local res = string.split(input, "-+-")
-- res = {"Hello", "World", "Quick"}

~~~

@param string input 输入字符串
@param string delimiter 分割标记字符或字符串

@return array 包含分割结果的数组

]]
function string.split(input, delimiter)
    input = tostring(input);
    delimiter = tostring(delimiter);
    if (delimiter=='') then return false end
    local pos,arr = 0, {};
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1));
        pos = sp + 1;
    end
    table.insert(arr, string.sub(input, pos));
    return arr;
end



--[[

从表格中查找指定值，返回其索引，如果没找到返回 false

~~~ lua

local array = {"a", "b", "c"}
echo(table.indexof(array, "b")) -- 输出 2

~~~

@param table array 表格
@param mixed value 要查找的值
@param [integer begin] 起始索引值

@return integer

]]
function table.indexof(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then return i end
    end
	return false;
end


--[[--

根据系统时间初始化随机数种子，让后续的 math.random() 返回更随机的值

]]
function math.newrandomseed()
--    math.randomseed(os.time())
    math.randomseed(tostring(os.time()):reverse():sub(1, 7));
    math.random();
    math.random();
    math.random();
    math.random();
end



