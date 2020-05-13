local kd = KDGame;

--数据中心,mvc设计方法核心,客户端界面相关所有数据保存于数据中心,数据由数据接收/产生方通知数据中心更新数据
--界面在初始化时注册数据监听,界面销毁时注销监听,在界面生存期内数据中心回调界面注册的方法通知界面更新


DC = {Datas = {}};

--比较两个值是否相等,支持table比较
function valueComp(value1, value2)
	if value1 == nil and value2 == nil then
		return true
	end
	
	--都是nil的情况已经处理过,所以有一个是nil就不相等
	if value1 == nil or value2 == nil then
		return false
	end
	
	if type(value1) ~= "table" and type(value2) ~= "table" then
		return value1 == value2
	end
	
	--都不是table的情况已经处理过,所以有一个不是table就不相等
	if type(value1) ~= "table" or type(value2) ~= "table" then
		return false
	end
	
	--都是table的情况,所有元素都要相等才相等
	for k,v in pairs(value1) do
		if valueComp(value2[k],v) == false then 
			return false
		end
	end
	return true
end


--回调注册的函数
function DC:CallBack(varName, ...)
	if (varName == nil) or (string.len(varName) == 0) then
		kd.LogOut("kd.DataCenter:CallBack("..varName..") 请检查参数,调用来自:"..getFileName(debug.getinfo(2).short_src)..":("..debug.getinfo(2).currentline..")");
		return
	end
	
	if self.Datas == nil then 
		self.Datas = {};
	end
	
	local v = self.Datas[varName];
	if v then
		self:CallBackWindow(varName, ...)
	end
end


--数据填充方法,向数据中心填充新产生的数据,或者更新已有数据
function DC:FillData(varName, value)
	if (varName == nil) or (string.len(varName) == 0) then
		kd.LogOut("kd.DataCenter:FillData("..varName..","..value..") 请检查参数,调用来自:"..getFileName(debug.getinfo(2).short_src)..":("..debug.getinfo(2).currentline..")");
		return
	end
	
	if self.Datas == nil then 
		self.Datas = {};
	end
	
	local v = self.Datas[varName];
	if v == nil then
		self.Datas[varName] = {};
		v = self.Datas[varName];
	end
	
	--检查数据是否修改
	if valueComp(v.value, value) == false then 
		v.value = value;
		self:DataChanged(varName, value)
	end	
end

--数据监听注册方法
--varName要注册的数据名称
--窗口显示时调用注册,窗口销毁时注销
--callBack是数据发生改变时调用的回调函数
function DC:Register(varName, pointer, callBack)
	if (varName == nil) or (string.len(varName) == 0) then
		kd.LogOut("kd.DataCenter:Register("..varName..","..pointer..","..callBack..") 请检查参数,调用来自:"..getFileName(debug.getinfo(2).short_src)..":("..debug.getinfo(2).currentline..")");
		return
	end
	if self.Datas == nil then 
		self.Datas = {};
	end
	
	local v = self.Datas[varName];
	if v == nil then 
		self.Datas[varName] = {};
		v = self.Datas[varName];
	end
	
	if v.Monitor == nil then
		v.Monitor = {};
	end
	v.Monitor[pointer] = callBack;
end

--回调注册方法
--varName要注册的回调名称
--窗口显示时调用注册,窗口销毁时注销
--callBack是提供给外部调用的回调方法
function DC:RegisterCallBack(varName, pointer, callBack)
	if (varName == nil) or (string.len(varName) == 0) then
		kd.LogOut("kd.DataCenter:RegisterCallBack("..varName..","..pointer..","..callBack..") 请检查参数,调用来自:"..getFileName(debug.getinfo(2).short_src)..":("..debug.getinfo(2).currentline..")");
		return
	end
	if self.Datas == nil then 
		self.Datas = {};
	end
	
	local v = self.Datas[varName];
	if v == nil then 
		self.Datas[varName] = {};
		v = self.Datas[varName];
	end
	
	if v.CallBack == nil then
		v.CallBack = {};
	end
	v.CallBack[pointer] = callBack;
end

--数据监听注销方法,按窗口指针注销,注销窗口注册的所有监听(数据不删除)
function DC:UnRegister(pointer)
	if pointer == nil then
		return;
	end
	
	self:DeleteKeys(self.Datas, pointer);
end

--递归删除table下所有key做下标的元素
function DC:DeleteKeys(tab, key)
	--递归到不是tab类型的子项则边界返回
	if type(tab) ~= "table" then
		return
	end
	for k,v in pairs(tab) do
		if k == key then
			tab[key] = nil;
		else 
			self:DeleteKeys(v, key);
		end
	end
end

--数据发生更改回调通知
function DC:DataChanged(varName, ...)
	local v = self.Datas[varName];
	--如果存在监听注册
	if v ~= nil and v.Monitor ~= nil then
		for this,callBack in pairs(v.Monitor) do
			if type(callBack) == "function" then
				--进行回调
				callBack(...);
			end
		end
	end
end

--回调方法
function DC:CallBackWindow(varName,...)
	local v = self.Datas[varName];
	--如果存在监听注册
	if v ~= nil and v.CallBack ~= nil then
		for this,callBack in pairs(v.CallBack) do
			if type(callBack) == "function" then
				--进行回调
				callBack(...);
			end
		end
	end
end

--窗口请求数据(窗口第一次初始化或者需要刷新窗口时调用)
function DC:updateMe(pointer)
	
	for k, v in pairs(self.Datas) do
		if v ~= nil and v.Monitor ~= nil then
			for pt, callBack in pairs(v.Monitor) do
				if pt == pointer then
					if type(callBack) == "function" then
						--进行回调
						callBack(v.value);
					end
				end
			end
		end
	end
end

--判断数据是否存在
function DC:HaveData(varName)
	if self.Datas == nil then
		return false;
	end
	if self.Datas[varName] == nil then
		return false;
	end
	return  self.Datas[varName].value ~= nil;
end

--获取数据
function DC:GetData(varName)
	if self.Datas == nil then
		return nil;
	end
	if self.Datas[varName] == nil then
		return nil;
	end
	if self.Datas[varName].value == nil then
		return nil;
	end
	
	return self.Datas[varName].value;
end