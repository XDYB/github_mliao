KDGame = KDGame or {}

--检测一个table和他绑定的C对象是否为nil
function KDGame.IsNull(tab)
	return (tab == 0 or tab==nil or tab._object==nil or tab._object==0);
end

--创建一个简单_class对象,不会触发构造函数
function KDGame.new(_class)
	local object = {};
	object._super = _class;
	
	setmetatable(object, _class);
	_class.__index = _class;
	
	return object;
end

--仿OO的继承接口,只会继承对象,不会触发构造函数序列
function KDGame.inherit(_class)
	local object = {};
	object._super = _class;
	
	setmetatable(object, _class);
	_class.__index = _class;
	
	return object;
end

--实例化类的接口,会引发其多重父类的构造函数
function KDGame.class(_class, ...)
	local object = {};
	object._super = _class;
	
	setmetatable(object, _class);
	_class.__index = _class;
	
	do
		local create;
		create = function(c, ...)
			if c._super then
				create(c._super, ...);
			end
			
			c:constr(object, ...);
		end
		
		create(object._super, ...);
	end
	
	--如果是C绑定table,必须确保C层对象已经生成
	if (object.bCBindingObject and (object._object==nil or object._object==0)) then
		object = nil;
		return nil;
	end
	
	return object;
end

--仿OO的_class类析构,会引发其多重父类的析构函数
function KDGame.free(object)
	if (object._super == nil) then return; end
	
	do
		local _free;
		_free = function(c)
			if c._super then
				_free(c._super);
			end
			
			c:Ruin(object);
		end
		
		_free(object._super);
	end
end

--C层接口封装

--En2D
KDGame.FreeMemory = c_FreeMemory;
KDGame.GetSystemType = c_GetSystemType;
KDGame.GetSystemInfo = c_GetSystemInfo;
KDGame.RandomSeed = c_RandomSeed;
KDGame.RandomInt = c_RandomInt;
KDGame.RandomFloat = c_RandomFloat;
KDGame.GetTickCount = c_GetTickCount;
KDGame.GetLocalTime = c_GetLocalTime;
KDGame.CalculateTimedifference = c_CalculateTimedifference;
KDGame.GameExit = c_GameExit;
KDGame.SetDepthTest = c_SetDepthTest;
KDGame.GetCacheDirSize = c_GetCacheDirSize;
KDGame.ClearCacheDir = c_ClearCacheDir;
KDGame.GetSystemLanguage = c_GetSystemLanguage;

KDGame.AddLayer = function(--[[kd.Layer]] layer)
	if (KDGame.IsNull(layer) == false) then
		c_AddLayer(layer._object);
	end
end
	
KDGame.RemoveLayer = function(--[[kd.Layer]] layer)
	if (KDGame.IsNull(layer) == false) then
		c_RemoveLayer(layer._object);
	end
end

KDGame.RegLuaTable = c_RegLuaTable;			--注意：不能在注册的时候立即回调，因为堆栈还没有还原初始状态
KDGame.UnRegLuaTable = c_UnRegLuaTable;
KDGame.PreloadMusic = c_PreloadMusic;
KDGame.PlayMusic = c_PlayMusic;
KDGame.PauseMusic = c_PauseMusic;
KDGame.ResumeMusic = c_ResumeMusic;
KDGame.StopMusic = c_StopMusic;
KDGame.RewindMusic = c_RewindMusic;
KDGame.IsMusicPlaying = c_IsMusicPlaying;
KDGame.GetMusicVolume = c_GetMusicVolume;
KDGame.SetMusicVolume = c_SetMusicVolume;
KDGame.PreloadEffect = c_PreloadEffect;
KDGame.UnloadEffect = c_UnloadEffect;
KDGame.PlayEffect = c_PlayEffect;
KDGame.PauseEffect = c_PauseEffect;
KDGame.ResumeEffect = c_ResumeEffect;
KDGame.StopEffect = c_StopEffect;
KDGame.StopAllEffect = c_StopAllEffect;
KDGame.GetEffectsVolume = c_GetEffectsVolume;
KDGame.SetEffectsVolume = c_SetEffectsVolume;
KDGame.GetAudioInfo = c_GetAudioInfo;
KDGame.GetVideoInfo = c_GetVideoInfo;
KDGame.SetTimer = c_SetTimer;
KDGame.KillTimer = c_KillTimer;
KDGame.KillAllTimer = c_KillAllTimer;
KDGame.KillLayerAllTimer = c_KillLayerAllTimer;
KDGame.MD5Encrypt = c_MD5Encrypt;
KDGame.File2MD5Code = c_File2MD5Code;
KDGame.Base64ExEncrypt = c_Base64ExEncrypt;
KDGame.Base64ExDecode = c_Base64ExDecode;
KDGame.Aes128EncryptStr = c_Aes128EncryptStr;
KDGame.Aes128DecodeStr = c_Aes128DecodeStr;
KDGame.CreateUUID = c_CreateUUID;
KDGame.AliPay = c_AliPay;
KDGame.WxPay = c_WxPay;
KDGame.AppStorePay = c_AppStorePay;
KDGame.sysMsgBox = c_SysMessageBox;
KDGame.LogOut = c_LogOut;
KDGame.GetSysWritablePath = c_GetSysWritablePath;
KDGame.IsFileExist = c_IsFileExist;
KDGame.RemoveFile = c_RemoveFile;
KDGame.CreateDirectory = c_CreateDirectory;
KDGame.RemoveDirectory = c_RemoveDirectory;
KDGame.MergeData = c_MergeData;
KDGame.OpenPhotoGetJPEG = c_OpenPhotoGetJPEG;
KDGame.GetUserWorldLocation = c_GetUserWorldLocation;
KDGame.GetPhoneBatteryInfo = c_GetPhoneBatteryInfo;
KDGame.GetNetworkType = c_GetNetworkType;
KDGame.ShareItUrlToWX = c_ShareItUrlToWX;
KDGame.ShareRoomTablePwd = c_ShareRoomTablePwd;
KDGame.InstallAPKFile = c_InstallAPKFile;
KDGame.GetSDCardAvailableCapacity = c_GetSDCardAvailableCapacity;
KDGame.IsAPPExisted = c_IsAPPExisted;
KDGame.OpenAPP = c_OpenAPP;
KDGame.OpenBrowserToUrl = c_OpenBrowserToUrl;
KDGame.CopyTextToShearPlate = c_CopyTextToShearPlate;
KDGame.DeviceIsPad = c_DeviceIsPad;
KDGame.SetJPushAlias = c_SetJPushAlias;
KDGame.SetSysStateBar = c_SetSysStateBar;
KDGame.SetSysStateBarStyle = c_SetSysStateBarStyle;
KDGame.WxLogin = c_WxLogin;
KDGame.QQLogin = c_QQLogin;
KDGame.WBLogin = c_WBLogin;
KDGame.CheckMicrophonePermissions = c_CheckMicrophonePermissions;
KDGame.CheckCameraPermissions = c_CheckCameraPermissions;
KDGame.CheckPhotoPermissions = c_CheckPhotoPermissions;
KDGame.CheckMsgPushPermissions = c_CheckMsgPushPermissions;
KDGame.RequestMicrophonePermissions = c_RequestMicrophonePermissions;
KDGame.RequestCameraPermissions = c_RequestCameraPermissions;
KDGame.RequestPhotoPermissions = c_RequestPhotoPermissions;
KDGame.RequestMsgPushPermissions = c_RequestMsgPushPermissions;
KDGame.IosOpenAppPermissionSetting = c_IosOpenAppPermissionSetting;
KDGame.AliPushBindAccount = c_AliPushBindAccount;
KDGame.AliPushUnBindAccount = c_AliPushUnBindAccount;

--socket
KDGame.SocketCreate = c_SocketCreate;
KDGame.SocketFree = c_SocketFree;
KDGame.NetworkIsIpv6 = c_NetworkIsIpv6;
KDGame.SocketConnect = c_SocketConnect;
KDGame.SocketSendData = c_SocketSendData;
KDGame.SocketClose = c_SocketClose;
KDGame.SocketGetConnectState = c_SocketGetConnectState;

--TH
KDGame.RMCreate = c_RMCreate;
KDGame.RMSetBackVisible = c_RMSetBackVisible;
KDGame.RMSetCenterVisible = c_RMSetCenterVisible;
KDGame.RMSetUpVisible = c_RMSetUpVisible;
KDGame.RMGetRenderDec = c_RMGetRenderDec;
KDGame.RMGetSprite = c_RMGetSprite;
KDGame.RMGetAnimation = c_RMGetAnimation;
KDGame.RMGetText = c_RMGetText;
KDGame.RMGetButton = c_RMGetButton;
KDGame.RMSetCustomRes = c_RMSetCustomRes;
KDGame.RMDelCustomRes = c_RMDelCustomRes;
KDGame.RMSetVisible = c_RMSetVisible;
KDGame.RMIsVisible = c_RMIsVisible;
KDGame.RMSetViewVisible = c_RMSetViewVisible;
KDGame.RMIsViewVisible = c_RMIsViewVisible;
KDGame.RMGetRect = c_RMGetRect;
KDGame.RMGetScaleRect = c_RMGetScaleRect;

--Node
KDGame.NodeCreate = c_NodeCreate;
KDGame.NodeAddChild = c_NodeAddChild;
KDGame.NodeRemoveChild = c_NodeRemoveChild;
KDGame.NodeChangeParent = c_NodeChangeParent;
KDGame.NodeSetZOrder = c_NodeSetZOrder;
KDGame.NodeGetZOrder = c_NodeGetZOrder;
KDGame.NodeSetPos = c_NodeSetPos;
KDGame.NodeSetVisible = c_NodeSetVisible;
KDGame.NodeSetColor = c_NodeSetColor;
KDGame.NodeSetHotSpot = c_NodeSetHotSpot;
KDGame.NodeSetScale = c_NodeSetScale;
KDGame.NodeSetRotation = c_NodeSetRotation;
KDGame.NodeGetPos = c_NodeGetPos;
KDGame.NodeIsVisible = c_NodeIsVisible;
KDGame.NodeGetColor = c_NodeGetColor;
KDGame.NodeGetHotSpot = c_NodeGetHotSpot;
KDGame.NodeGetWH = c_NodeGetWH;
KDGame.NodeGetScale = c_NodeGetScale;
KDGame.NodeGetRotation = c_NodeGetRotation;
KDGame.NodeSetRotation3D = c_NodeSetRotation3D;
KDGame.NodeGetRotation3D = c_NodeGetRotation3D;

--Layer
KDGame.LayerCreate = c_LayerCreate;
KDGame.LayerSetVisible = c_LayerSetVisible;
KDGame.LayerSetActionType = c_LayerSetActionType;
KDGame.LayerSetDebugMode = c_LayerSetDebugMode;

--Sprite
KDGame.SprCreate = c_SprCreate;
KDGame.SprSetTexture = c_SprSetTexture;
KDGame.SprGetTexWH = c_SprGetTexWH;
KDGame.SprSetTextureRect = c_SprSetTextureRect;
KDGame.SprGetTextureRect = c_SprGetTextureRect;
KDGame.SprSetFlipX = c_SprSetFlipX;
KDGame.SprSetFlipY = c_SprSetFlipY;
KDGame.SprIsFlipX = c_SprIsFlipX;
KDGame.SprIsFlipY = c_SprIsFlipY;

--AsyncSprite
KDGame.AsyncSprCreate = c_AsyncSprCreate;
KDGame.AsyncSprSetTexture = c_AsyncSprSetTexture;
KDGame.AsyncSprGetTextureFilePath = c_AsyncSprGetTextureFilePath;

--AsyncSpriteBlur
KDGame.AsyncSprBlurCreate = c_AsyncSprBlurCreate;
KDGame.AsyncSprBlurSetTexture = c_AsyncSprBlurSetTexture;
KDGame.AsyncSprBlurGetTextureFilePath = luaAsyncSprBlurGetTextureFilePath;

--button
KDGame.BntCreate = c_BntCreate;
KDGame.BntSetEnable = c_BntSetEnable;
KDGame.BntsetNewTopImg = c_BntsetNewTopImg;
KDGame.BntsetEnabledImg = c_BntsetEnabledImg;
KDGame.BntSetTitle = c_BntSetTitle;
KDGame.BntSetPos = c_BntSetPos;
KDGame.BntGetPos = c_BntGetPos;
KDGame.BntSetTitlePosOffset = c_BntSetTitlePosOffset;

--amin
KDGame.AniMultipleImgCreate = c_AniMultipleImgCreate;
KDGame.InstFrameSpr = c_InstFrameSpr;
KDGame.MAniPlay = c_MAniPlay;
KDGame.MAniStop = c_MAniStop;
KDGame.MAnipause = c_MAnipause;
KDGame.MAniResume = c_MAniResume;
KDGame.MAniIsPlaying = c_MAniIsPlaying;
KDGame.MAniSetMode = c_MAniSetMode;
KDGame.MAniSetSpeed = c_MAniSetSpeed;
KDGame.MAniSetFrame = c_MAniSetFrame;
KDGame.MAniGetMode = c_MAniGetMode;
KDGame.MAniGetSpeed = c_MAniGetSpeed;
KDGame.MAniGetFrame = c_MAniGetFrame;
KDGame.MAniGetFrames = c_MAniGetFrames;

KDGame.AniWholeImgCreate = c_AniWholeImgCreate;
KDGame.WAniPlay = c_WAniPlay;
KDGame.WAniStop = c_WAniStop;
KDGame.WAniResume = c_WAniResume;
KDGame.WAnipause = c_WAnipause;
KDGame.WAniIsPlaying = c_WAniIsPlaying;
KDGame.WAniSetMode = c_WAniSetMode;
KDGame.WAniSetSpeed = c_WAniSetSpeed;
KDGame.WAniSetFrame = c_WAniSetFrame;
KDGame.WAniGetMode = c_WAniGetMode;
KDGame.WAniGetSpeed = c_WAniGetSpeed;
KDGame.WAniGetFrame = c_WAniGetFrame;
KDGame.WAniGetFrames = c_WAniGetFrames;
KDGame.WAniSetDynamicFPS = c_WAniSetDynamicFPS;

--static Text
KDGame.StaticTextCreate = c_StaticTextCreate;
KDGame.StaticTextGetString = c_StaticTextGetString;
KDGame.StaticTextSetString = c_StaticTextSetString;
KDGame.StaticTextSetColor = c_StaticTextSetColor;
KDGame.StaticTextSetWH = c_StaticTextSetWH;
KDGame.StaticTextSetHAlignment = c_StaticTextSetHAlignment;
KDGame.StaticTextSetLineHeight = c_StaticTextSetLineHeight;
KDGame.StaticTextGetLineHeight = c_StaticTextGetLineHeight;
KDGame.StaticTextSetAdditionalKerning = c_StaticTextSetAdditionalKerning;
KDGame.StaticTextGetAdditionalKerning = c_StaticTextGetAdditionalKerning;

--editbox
KDGame.EditCreate = c_EditCreate;
KDGame.EditSetMaxLength = c_EditSetMaxLength;
KDGame.EditGetMaxLength = c_EditGetMaxLength;
KDGame.EditSetInputMode = c_EditSetInputMode;
KDGame.EditSetInputFlag = c_EditSetInputFlag;
KDGame.EditSetReturnType = c_EditSetReturnType;
KDGame.EditSetTitle = c_EditSetTitle;
KDGame.EditSetText = c_EditSetText;
KDGame.EditGetText = c_EditGetText;
KDGame.EditSetDelegate = c_EditBoxSetDelegate;

--EidtBoxDelegate
KDGame.EditBoxDelegateCreate = c_EditBoxDelegateCreate;
KDGame.EditBoxDelegateFree = c_EditBoxDelegateFree;

--ScrollView
KDGame.ScrollViewCreate = c_ScrollViewCreate;
KDGame.SVsetVisibleRect = c_SVsetVisibleRect;
KDGame.SVgetVisibleRect = c_SVgetVisibleRect;
KDGame.SVsetSlipDirection = c_SVsetSlipDirection;
KDGame.SVaddReandChild = c_SVaddReandChild;
KDGame.SVRemovReandChild = c_SVRemovReandChild;
KDGame.SVSetRenderViewMaxWH = c_SVSetRenderViewMaxWH;
KDGame.SVgetRenderViewMaxWH = c_SVgetRenderViewMaxWH;

--GuiObjectNew
KDGame.GuiObjectNewCreate = c_GuiObjectNewCreate;
KDGame.GuiObjectNewSetEnable = c_GuiObjectNewSetEnable;
KDGame.GuiObjectNewSetRect = c_GuiObjectNewSetRect;
KDGame.GuiObjectNewGetTouchRect = c_GuiObjectNewGetTouchRect;
KDGame.GuiObjectNewSetRectClipping = c_GuiObjectNewSetRectClipping;
KDGame.GuiObjectNewsetMaskingClipping = c_GuiObjectNewsetMaskingClipping;
KDGame.GuiObjectNewcancelClipping = c_GuiObjectNewcancelClipping;
KDGame.GuiObjectNewSetPos = c_GuiObjectNewSetPos;
KDGame.GuiObjectNewSetDebugMode = c_GuiObjectNewSetDebugMode;

--ParticleSystem
KDGame.ParticleSystemCreate = c_ParticleSystemCreate;
KDGame.ParticleSystemFire = c_ParticleSystemFire;
KDGame.ParticleSystemStop = c_ParticleSystemStop;

--GeometryDraw
KDGame.GeometryCreateCreate = c_GeometryCreateCreate;
KDGame.GeometryClear = c_GeometryClear;
KDGame.GeometryDrawPoint = c_GeometryDrawPoint;
KDGame.GeometryDrawPoints = c_GeometryDrawPoints;
KDGame.GeometryDrawLine = c_GeometryDrawLine;
KDGame.GeometryDrawPolygon = c_GeometryDrawPolygon;
KDGame.GeometryDrawCircle = c_GeometryDrawCircle;

--WebView
KDGame.WebViewCreate = c_WebViewCreate;
KDGame.WebViewSetCookie = c_WebViewSetCookie;
KDGame.WebViewGetCookie = c_WebViewGetCookie;
KDGame.WebViewDeleteCookie = c_WebViewDeleteCookie;
KDGame.WebViewLoadUrl = c_WebViewLoadUrl;
KDGame.WebViewSetVisible = c_WebViewSetVisible;
KDGame.WebViewSetPos = c_WebViewSetPos;
KDGame.WebViewSetRect = c_WebViewSetRect;
KDGame.WebViewsetSPToFit = c_WebViewsetSPToFit;

--PageGrid3D
KDGame.PG3DCreate = c_PageGrid3DCreate;
KDGame.PG3DAddChildToGrid = c_PG3DAddChildToGrid;
KDGame.PG3DFlip = c_PG3DFlip;
KDGame.PG3DIsStart = c_PG3DIsStart;
KDGame.PG3DStart = c_PG3DStart;
KDGame.PG3DEnd = c_PG3DEnd;


--视频
KDGame.AVViewCreate = c_AVViewCreate;
KDGame.AVViewPlay = c_AVViewPlay;
KDGame.AVViewPause = c_AVViewPause;
KDGame.AVViewStop = c_AVViewStop;
KDGame.AVViewDebugOut = c_AVViewDebugOut;
KDGame.AVViewGetBufferClock = c_AVViewGetBufferClock;
KDGame.AVViewGetPlayClock = c_AVViewGetPlayClock;
KDGame.AVViewGetMaxTime = c_AVViewGetMaxTime;

--创建CJSON全局table
if (c_newCJosn) then KDGame.cjson = c_newCJosn(); end

--httpFile
KDGame.CreateHttpFileAgent = c_CreateHttpFileAgent;
KDGame.FreeHttpFileAgent = c_FreeHttpFileAgent;
KDGame.SendHttpFileRequest = c_SendHttpFileRequest;

--httpRequest
KDGame.CreateHttpRequestAgent = c_CreateHttpRequestAgent;
KDGame.FreeHttpRequestAgent = c_FreeHttpRequestAgent;
KDGame.SendHttpGETRequest = c_SendHttpGETRequest;
KDGame.SendHttpPOSTRequest = c_SendHttpPOSTRequest;

--UnZip
KDGame.CreateUnZipAgent = c_CreateUnZipAgent;
KDGame.FreeUnZipAgent = c_FreeUnZipAgent;
KDGame.UnZipFile = c_UnZipFile;

--设置浏览器的全局cookeis
KDGame.SetHttpCookeis = c_SetHttpCookeis;

