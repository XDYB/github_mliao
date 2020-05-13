local kd = KDGame;

kd.CJson = {};

--[[string]]function kd.CJson.EnCode(--[[table]] t)
	if(t==nil or type(t)~="table") then return nil; end
	return kd.cjson.encode(t);
end

--[[table]]function kd.CJson.DeCode(--[[string]] str)
	if(str==nil or type(str)~="string") then return nil; end
	local nFind1 = string.find(str,"{");
	local nFind2 = string.find(str,"%[");
	if((nFind1==nil or nFind1~=1) and (nFind2==nil or nFind2~=1)) then return nil; end
	local nFind3 = string.find(str,"}");
	local nFind4 = string.find(str,"]");	
	if(nFind3==nil and nFind4==nil) then return nil; end
	if(nFind1 and nFind3==nil) then return nil; end
	if(nFind2 and nFind4==nil) then return nil; end
	
	return kd.cjson.decode(str);
end

--[[table]]function kd.CJson.OpenFile(--[[string]] szFile)
	if(szFile==nil or type(szFile)~="string" or szFile=="") then return nil; end
	
	local file, serror = io.open(kd.GetSysWritablePath()..szFile, "r");
	if (file == nil) then return nil; end
	
	local str = "";
	for st in file:lines() do
		str = st;
	end
	io.close(file);	
	
	return kd.CJson.DeCode(str);
end

--[[bool]]function kd.CJson.WriteFile(--[[string]] szPath, --[[string]] szFile, --[[table]] t)
	local str = kd.CJson.EnCode(t);
	if(str==nil) then return false; end
	
	if(szPath==nil or type(szPath)~="string" or szPath=="") then return false; end
	kd.CreateDirectory(szPath);
	
	if(szFile==nil or type(szFile)~="string" or szFile=="") then return false; end	
	local file, serror = io.open(kd.GetSysWritablePath()..szPath..szFile, "w");
	if (file == nil) then return false; end	
	
	file:write(str);	
	io.close(file);	
	
	return true;
end