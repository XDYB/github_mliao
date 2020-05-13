--[[
	sky 阿里OSS文件管理引擎全局唯一实例,不可派生
]]

local kd = KDGame;

KDOss = {
	--回调对象列表(按顺序回调)
	CallBackObj = {};
	
	--[[///////////////////////////////////////////////////////////////////////////////]]
	--接口
	
	--设置配置参数
	SetConfig = --[[void]]function(--[[string]] end_point,
							--[[string]] bucket,
							--[[string]] object_path,
							--[[string]] callbackUrl)
		KDOss.EndPoint = end_point;
		KDOss.Bucket = bucket;
		KDOss.ObjectPath = object_path;
		KDOss.CallBackUrl = callbackUrl;
	end,	
	
	--初始化引擎 c_ossInit
	--[[
		参数:
		string end_point,					--oss域名(配置下发，eg:"oss-cn-hangzhou.aliyuncs.com")
		string app_key,						--阿里云帐号
		string key_secret,					--阿里云密钥
		string token						--
		
		返回值:
		bool								--是否调用成功
	]]
	init = --[[bool]]function(--[[string]] app_key,
							--[[string]] key_secret,
							--[[string]] token)
		return c_ossInit(KDOss.EndPoint,app_key,key_secret,token);
	end,
	
	--反初始化
	--[[
		参数:
		无
		
		返回值:
		无
	]]
	uninit = c_ossUninit;	
	
	--上传文件 c_ossUploadFile
	--[[
		参数:
		string bucket,						--"vchat"为配置下发
		string object,						--oss文件路径名（规则是"prod/image/文件名"：prod为配置下发; image为文件类型; 文件名为"用户id_时间戳_8位随机码"）
														eg:prod/image/688891_1523178500193_12345678
		string file_path,					--本地文件名
		string file_type, 					--文件类型(图片:"image/jpg"; 视频:"video/mp4"; 音频:"audio/amr") 
		string back_url_json				--回调给服务端的json
												callbackUrl:上传回调接口URL;
												callbackBodyType:参数body类型;
												callbackBody:   "userId=" + 用户ID  
															  + "&userKey=" + 用户Key
															  + "&sn= "+ 照片墙对应位置（仅上传图片使用 1,2,3,...） 
															  + "&fileName=" + 上传文件名（本地生成 格式为 用户id_时间戳_8位随机码）
															  + "&fileType=" +上传文件类型（图片 视频 音频）
															  + "&type=" + 上传图片详细类型（头像:"user_avatar"；海报:"user_photo"；视频聊天截图:"video_chat_snapshot"；小视频封面和第一帧:"small_video_image" ）
															  + "&voiceLength=" + 音乐时长（仅上传音频时使用）
															  + "&videoCoverID=" + 视频封面ID（仅上传视频时使用）
															  + "&videoLength=" + 视频长度（仅上传视频时使用）
															  + "&videoChatId="+视频聊天ID（上传聊天截图用，上传头像也要传该参数）
															  + "&bucket=${bucket}&object=${object}&etag=${etag}&size=${size}&mimeType=${mimeType}"
															  + "&imageInfo.height=${imageInfo.height}&imageInfo.width=${imageInfo.width}&imageInfo.format=${imageInfo.format}"

											  eg: {"callbackUrl":http://testapp.vliao2.com/oss-callback,
												  "callbackBodyType":"application/json",                                 
												  "callbackBody":"userId=688891&userKey=9e0f12295702b034ac68bcb34e7c8c0b&sn=3
																 &fileName=688891_1523174666354_ek5tnek0jzan6146fj4p&fileType=image&type=user_avatar
																 &voiceLength=0&videoCoverID=0&videoLength=0&videoChatId=0
																 &bucket=${bucket}&object=${object}&etag=${etag}&size=${size}&mimeType=${mimeType}
																 &imageInfo.height=${imageInfo.height}&imageInfo.width=${imageInfo.width}&imageInfo.format= ${imageInfo.format}"}
		
		返回值:
		bool								--是否调用成功
	]]
	
	--上传图片
	uploadImage = function(--[[KDGame.Node ]] callbackObj,	--回调对象
						--[[string]] object_name,			--oss文件名（不要后缀名）
						--[[string]] file_path,				--本地文件名
						--[[string]] userid,				--用户ID
						--[[string]] userkey,				--用户KEY
						--[[int]] sn,						--照片墙对应位置（1,2,3,...）
						--[[string]] image_type)			--图片类型					
		local _callbackBody = "userId="..userid.."&userKey="..userkey.."&sn="..sn.."&fileName="..object_name..
							"&fileType=image&type="..image_type.."&videoChatId=0"..
							"&bucket=${bucket}&object=${object}&etag=${etag}&size=${size}&mimeType=${mimeType}"..
							"&imageInfo.height=${imageInfo.height}&imageInfo.width=${imageInfo.width}&imageInfo.format= ${imageInfo.format}";
		local tJson = {callbackUrl=KDOss.CallBackUrl,callbackBodyType="application/json",callbackBody=_callbackBody};
		local back_url_json = kd.CJson.EnCode(tJson);
		local bRet = c_ossUploadFile(KDOss.Bucket,
									KDOss.ObjectPath.."image/"..object_name,
									file_path,
									"image/jpg",
									back_url_json);
		if(bRet) then table.insert(KDOss.CallBackObj,callbackObj); end
		return bRet;
	end,
	
	--上传视频截图
	uploadVideoChatImg  = function(--[[KDGame.Node ]] callbackObj,	--回调对象
						--[[string]] object_name,			--oss文件名（不要后缀名）
						--[[string]] file_path,				--本地文件名
						--[[string]] userid,				--用户ID
						--[[string]] userkey,				--用户KEY
						--[[string]] videoChatId)			--视频聊天ID					
		local _callbackBody = "userId="..userid.."&userKey="..userkey.."&sn=0&fileName="..object_name..
							"&fileType=image&type=video_chat_snapshot&videoChatId="..videoChatId..
							"&bucket=${bucket}&object=${object}&etag=${etag}&size=${size}&mimeType=${mimeType}"..
							"&imageInfo.height=${imageInfo.height}&imageInfo.width=${imageInfo.width}&imageInfo.format= ${imageInfo.format}";
		local tJson = {callbackUrl=KDOss.CallBackUrl,callbackBodyType="application/json",callbackBody=_callbackBody};
		local back_url_json = kd.CJson.EnCode(tJson);
		local bRet = c_ossUploadFile(KDOss.Bucket,
									KDOss.ObjectPath.."image/"..object_name,
									file_path,
									"image/jpg",
									back_url_json);
		if(bRet) then table.insert(KDOss.CallBackObj,callbackObj); end
		return bRet;
	end,	
	
	--[[///////////////////////////////////////////////////////////////////////////////]]
	--回调函数
	
	--上传结果回调
	OnAliOSSBackUploadFileResults = function(--[[int]] err_code, 		--错误值(200:成功)
											--[[stirng]] err_msg,		--错误消息
											--[[string]] object,		--oss文件路径名
											--[[string]] web_ret_json) 	--WEB返回json
		local callbackObj = KDOss.CallBackObj[1];
		if(callbackObj==nil or callbackObj.OnAliOSSBackUploadFileResults==nil) then
			return;
		end
		table.remove(KDOss.CallBackObj,1);
		
		local tJson = kd.CJson.DeCode(web_ret_json);
		callbackObj:OnAliOSSBackUploadFileResults(err_code,err_msg,object,tJson);
	end,
	
	--上传进度回调
	OnAliOSSBackUploadFileProgress = function(--[[int]] consumed_bytes, 	--已上传字节数
											--[[int]] total_bytes) 			--总字节数
		local callbackObj = KDOss.CallBackObj[1];
		if(callbackObj==nil or callbackObj.OnAliOSSBackUploadFileProgress==nil) then
			return;
		end
		
		callbackObj:OnAliOSSBackUploadFileProgress(consumed_bytes,total_bytes);
	end,	
}