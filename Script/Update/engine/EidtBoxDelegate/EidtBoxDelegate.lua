local kd = KDGame;

kd.EidtBoxDelegate = {
	bCBindingObject = true,
	_object = 0;
	nIdx = -1;
	
	--[[�ص��ӿ� ================================================================================]]
	
	--��ʼ�༭�Ļص�����
	editBoxEditingDidBegin = function(self)
		print("��ʼ�༭");
	end;
	
	--�༭����(ʧȥ����)
	editBoxEditingDidEnd = function(self)
		print("ֹͣ�༭");
	end;
	
	--���ַ����ı�
	editBoxTextChanged = function(self, --[[string]] text)
		print("���ַ����ı� text:"..text);
	end;
	
	--�س��������»���̵��ⲿ���򱻴���ʱ
	editBoxReturn = function(self)
		print("�༭��Return");
	end;
}

function kd.EidtBoxDelegate:constr(self, ...)
	self.nIdx = kd.RegLuaTable(self);
	self._object = kd.EditBoxDelegateCreate(self.nIdx);
	
	--C���������ʧ��,ȡ��tableȫ�ְ�
	if (self._object == nil) then
		kd.UnRegLuaTable(self.nIdx);
	end
end

function kd.EidtBoxDelegate:Ruin(self)
	kd.EditBoxDelegateFree(self._object);
end