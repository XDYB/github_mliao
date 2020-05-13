local kd = KDGame;

kd.EidtBoxDelegate = {
	bCBindingObject = true,
	_object = 0;
	nIdx = -1;
	
	--[[回调接口 ================================================================================]]
	
	--开始编辑的回调函数
	editBoxEditingDidBegin = function(self)
		print("开始编辑");
	end;
	
	--编辑结束(失去焦点)
	editBoxEditingDidEnd = function(self)
		print("停止编辑");
	end;
	
	--文字发生改变
	editBoxTextChanged = function(self, --[[string]] text)
		print("文字发生改变 text:"..text);
	end;
	
	--回车键被按下或键盘的外部区域被触摸时
	editBoxReturn = function(self)
		print("编辑框Return");
	end;
}

function kd.EidtBoxDelegate:constr(self, ...)
	self.nIdx = kd.RegLuaTable(self);
	self._object = kd.EditBoxDelegateCreate(self.nIdx);
	
	--C层对象生成失败,取消table全局绑定
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
	end
end

function kd.EidtBoxDelegate:Ruin(self)
	kd.EditBoxDelegateFree(self._object);
end