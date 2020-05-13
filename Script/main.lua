KDGame = KDGame or {}
local kd = KDGame;
kd.scriptFix = "lua";
kd.resallFix = "UI";
-- ========================================================================
--                              引擎文件
-- ========================================================================
local requireFiles = {
	--全局函数和枚举
	"public/KDEnum",
	"public/KDGame",
	--httpFile
	"httpFile/KDHttpFile",
	--httpRequest
	"httpRequest/httpRequest",
	--Json,
	"Json/KDJson",
	-- Util啊实打实大撒多多
	"Util/Function",
	"Util/Class",
	"Util/HashMap",
	"Util/Queue",
	
	--数据中心
	"DataCenter/DC",
	--KDUI
	"KDUI/KDNode",
	"KDUI/KDLayer",
	"KDUI/KDSprite",
	"KDUI/KDSpriteBlur",
	"KDUI/KDAnim",
	"KDUI/KDBigAnim",
	"KDUI/KDAsyncSprite",
	"KDUI/KDAsyncBlurSprite",
	"KDUI/KDButton",
	"KDUI/KDClockPro",
	"KDUI/KDEditBox",
	"KDUI/KDGeometryDraw",
	"KDUI/KDGuiObjectNew",
	"KDUI/KDParticleSystem",
	"KDUI/KDProgressTimer",
	"KDUI/KDScrollViewEx",
	"KDUI/KDSprite",
	"KDUI/KDStaticText",
	"KDUI/KDVideoView",
	"KDUI/KDWebView",
	--TH编辑器
	"TH/KDResourceManager",
	--解压
	"UnZip/UnZip",
	--Sokect
	"Net/ClientSocket",
	"Net/WebSocket",
	--EditBoxDelegate
	"EidtBoxDelegate/EidtBoxDelegate",
	-- NIM OSS
	"NIM/KDNimEngine",
	"OSS/KDOssEngine",
	
	--TIM
	"TIM/KDTimEngine",
	"TIM/KDTimEnum",
	
	--语聊
	"TVideo/KDTVideoEngine",

}




-- 加载A面引擎
function LoadAEngine()
	for i,v in ipairs(requireFiles) do
		c_Require("Script/Update/engine/"..v.."."..kd.scriptFix)
	end
end
-- 加载B面引擎
--[[
function LoadBEngine()
	for i,v in ipairs(requireFiles) do
		c_Require("Script/engine/"..v..".kds")
	end
	c_Require("Script/Fixed/Config/ConfigFix.kds")
	c_Require("Script/Fixed/Config/GDefineFix.kds")
	c_Require("Script/Fixed/Mask.kds")
	c_Require("Script/Fixed/PopUp/MessBox.kds")
	c_Require("Script/Public/GDefine.kds")
end
--]]
LoadAEngine();

--更新模块
c_Require("Script/Update/startup."..kd.scriptFix)
local gUpdateView = Startup;

local bHome = false;


function _GameStart()
	gUpdateView:init();
end

function _GameOver()
	kd.GameExit();	
end
--用户按下HOME键
function _onPause()
	bHome = true;
	if(gUpdateView.m_ViewManager and gUpdateView.m_ViewManager:IsInitFinish()) then
		gUpdateView.m_ViewManager:OnHomeBackCall();
	elseif(gUpdateView.m_MiniGame and gUpdateView.m_MiniGame:IsInitFinish()) then
		gUpdateView.m_MiniGame:OnHomeBackCall();
	end	
end
--HOME回来
function _onResume()
	--测试
	----------------------------------
	--gUpdateView.m_ViewManager:onResume();
	----------------------------------
	
	if(bHome == false) then return; end
	bHome = false;	
	gUpdateView:onResume();		
end

--清理缓存目录回调
function _OnOnCacheDirClearEnd()
	
end

--android后退键或者PC ESC键被按下
function _onBackKeyReleased()	
	--[[
	if(gUpdateView.m_ViewManager and gUpdateView.m_ViewManager:IsInitFinish()) then
		gUpdateView.m_ViewManager:onBackKeyReleased();
		return;
	elseif(gUpdateView.m_MiniGame and gUpdateView.m_MiniGame:IsInitFinish()) then
		gUpdateView.m_MiniGame:onBackKeyReleased();
		return;
	end
	--]]
	_GameOver();	
end

--android菜单键或者PC ALT键被按下
function _onMenuKeyReleased()

end

function _onKeyPressed(nKeyCode)
	if(nKeyCode==21) then --HOME
		_onPause();
	elseif(nKeyCode==28) then --UP
		_onResume();
	end
end

function _OnNetConnect(--[[KDGame.emNetworkError]] _error, 
						--[[int]] iError, 
						--[[string]] szError, 
						--[[CClientSocket*]] _socket)	
	return;
end

function _OnNetRead(--[[int]] MainCmd, 
					--[[int]] SubCmd, 
					--[[string]] Data, 
					--[[int]] size, 
					--[[CClientSocket*]] _socket)
	return;
end

function _OnNetClose(--[[KDGame.emCloseSocketType]] _closeType, --[[CClientSocket*]] _socket)
	return;		
end

--登录
function _OnTimApplyMsgKey(--[[GCloudVoiceCompleteCode ]] _ncode, --[[string]] _err_msg)
	kd.LogOut("KD_LOG:登录语聊平台回调 code=".._ncode..",msg=".._err_msg);
end

--上传
function _OnTimUploadVoice(--[[string]] _sev_file_id, --[[GCloudVoiceCompleteCode ]] _ncode, --[[string]] _err_msg)
	kd.LogOut("KD_LOG:上传语音回调 code=".._ncode..",msg=".._err_msg);
end

--下载
function _OnTimDownloadVoice(--[[string]] _sev_file_id, --[[string]] _save_file, --[[uint]] _file_size, --[[float]] _voice_time, --[[GCloudVoiceCompleteCode ]] _ncode, --[[string]] _err_msg)
	kd.LogOut("KD_LOG:下载语音回调 code=".._ncode..",msg=".._err_msg);
end

--播放完毕
function _OnTimPlayVoiceEnd(--[[string]] _v_file)

end


--系统相册或相机操作成功的回调
function _OnSystemPhotoRet(--[[string]] _filePath, --[[int]] fileType)
	if(gUpdateView.m_ViewManager and gUpdateView.m_ViewManager:IsInitFinish()) then
		gUpdateView.m_ViewManager:OnSystemPhotoRet(_filePath,fileType);
	elseif(gUpdateView.m_MiniGame and gUpdateView.m_MiniGame:IsInitFinish()) then
		gUpdateView.m_MiniGame:OnSystemPhotoRet(_filePath,fileType);
	end
end

--获取用户位置(查询方式(1:GPS 2:网络(WIFI-3/4G)), 经度, 维度, 精度, 错误码(0:成功), 错误信息)
function _OnSystemGetLocation(--[[int]] _queryType, 
							--[[double]] _longitude, 
							--[[double]] _latitude, 
							--[[float]] _accuracy, 
							--[[int]] _errorCode, 
							--[[string]] _errorMsg)
end

--获取电池信息(电量百分比, 电池状态(0:未充电 1:充电中))
function _OnSystemGetBatteryInfo(--[[int]] _nElectricity, --[[int]] _BatteryState)

end

--苹果商城充值回调
function _OnSystemIosPayRet(--[[int]] _nErrorCode, --[[string]] _szErrorMsg, --[[string]] OrderID, --[[string]] receipt)
	if gUpdateView.m_MiniGame and gUpdateView.m_MiniGame.OnSystemIosPayRet then
		gUpdateView.m_MiniGame:OnSystemIosPayRet(_nErrorCode,_szErrorMsg,OrderID,receipt);
	end
end

--支付宝充值回调
function _OnSystemAliPayRet(--[[int]] _nErrorCode, --[[int]] _szErrorMsg)

end

--微信登录回调
function _OnSystemWXLoginRet(--[[int]] err_code,				--错误code(0:成功 非0:失败)
							--[[string]] err_msg,				--错误消息 
							--[[string]] wx_open_id,			--微信用户OPENID
							--[[string]] _wx_nick_name,			--微信用户昵称
							--[[string]] _wx_sex,				--微信用户性别
							--[[string]] _wx_province,			--微信用户的省份
							--[[string]] _wx_city,				--微信用户的城市
							--[[string]] _wx_country,			--微信用户的国家
							--[[string]] _wx_headimgurl,		--微信用户的头像
							--[[string]] _wx_unionid)			--微信用户的统一标识
	kd.LogOut("KD_LOG:main _OnSystemWXLoginRet");
	if(gUpdateView.m_ViewManager and gUpdateView.m_ViewManager:IsInitFinish()) then
		gUpdateView.m_ViewManager:OnSystemWXLoginRet(err_code,err_msg,wx_open_id,_wx_nick_name,_wx_sex,
													_wx_province,_wx_city,_wx_country,_wx_headimgurl,_wx_unionid);
	end							
end

--QQ登录回调
function _OnSystemQQLoginRet(--[[int]] err_code,				--错误code(0:成功 非0:失败)
							--[[string]] err_msg,				--错误消息 
							--[[string]] openid,				--QQ用户OPENID
							--[[string]] nickname,				--QQ用户昵称
							--[[string]] sex,					--QQ用户性别
							--[[string]] province,				--QQ用户的省份
							--[[string]] city,					--QQ用户的城市
							--[[string]] headimgurl,			--QQ用户的头像
							--[[string]] unionid)				--QQ用户的统一标识
	kd.LogOut("KD_LOG:main _OnSystemQQLoginRet");
	if(gUpdateView.m_ViewManager and gUpdateView.m_ViewManager:IsInitFinish()) then
		gUpdateView.m_ViewManager:OnSystemQQLoginRet(err_code,err_msg,openid,nickname,sex,
													province,city,headimgurl,unionid);
	end							
end

--微博登录回调
function _OnSystemWBLoginRet(--[[int]] err_code,				--错误code(0:成功 非0:失败)
							--[[string]] err_msg,				--错误消息 
							--[[string]] openid,				--微博用户OPENID
							--[[string]] nickname,				--微博用户昵称
							--[[string]] sex,					--微博用户性别
							--[[string]] location,				--微博用户的所在地
							--[[string]] headimgurl)			--微博用户的头像
	kd.LogOut("KD_LOG:main _OnSystemWBLoginRet");
	if(gUpdateView.m_ViewManager and gUpdateView.m_ViewManager:IsInitFinish()) then
		gUpdateView.m_ViewManager:OnSystemWBLoginRet(err_code,err_msg,openid,nickname,sex,
													location,headimgurl);
	end							
end

--阿里推送绑定账号回调
function _OnAliPushBindAccountRet(--[[int]] err_code, --[[string]] err_msg)
	kd.LogOut("KD_LOG:main _OnAliPushBindAccountRet");
	if(gUpdateView.m_ViewManager and gUpdateView.m_ViewManager:IsInitFinish()) then
		gUpdateView.m_ViewManager:OnAliPushBindAccountRet(err_code,err_msg);
	end		
end

--系统推送透传消息回调
function _OnSysPushThroughMsg(--[[string]] title, --[[string]] body)
	kd.LogOut("KD_LOG:main _OnAliPushThroughMsg");
	if(gUpdateView.m_ViewManager and gUpdateView.m_ViewManager:IsInitFinish()) then
		gUpdateView.m_ViewManager:OnSysPushThroughMsg(title,body);
	end		
end

--系统推送消息打开应用回调
function _OnSysPushMsgOpenApp(--[[string]] content)
	kd.LogOut("KD_LOG:main _OnAliPushMsgOpenApp");
	if(gUpdateView.m_ViewManager and gUpdateView.m_ViewManager:IsInitFinish()) then
		gUpdateView.m_ViewManager:OnSysPushMsgOpenApp(content);	
	end		
end


--获取一个音频的信息回调
function _OnAudioGetInfoRetEvent(--[[int]] err_code, 				--错误码(0为成功)
								--[[string]] audio_file, 			--请求的音频文件路径或网址
								--[[int]] play_time, 				--总时长
								--[[int]] in_fmt, 					--输入采样格式
								--[[int]] in_rate, 					--输入采样率
								--[[int]] in_channel)				--输入声道
	if(gUpdateView.m_ViewManager and gUpdateView.m_ViewManager:IsInitFinish()) then
		gUpdateView.m_ViewManager:OnAudioGetInfoRetEvent(err_code,audio_file,play_time,in_fmt,in_rate,in_channel);
	end
end

--获取一个视频的信息并生成封面回调
function _OnVideoGetInfoRetEvent(--[[int]] err_code, 				--错误码(0为成功)
								--[[string]] video_file, 			--请求的视频频文件路径或网址
								--[[int]] steams, 					--流数量(视频/声频)
								--[[int]] kbps, 					--混合码率
								--[[int]] w, 						--视频分辨率宽
								--[[int]] h, 						--视频分辨率高
								--[[float]] r,						--视频角度
								--[[int64]] rate, 					--视频采样率
								--[[int]] max_time,					--视频的总时间(ms) 			
								--[[int]] fps, 						--FPS
								--[[string]] cover_path)			--封面地址(由获取发起方传入,回调返回,如果发起方传入为空,将不会生成封面文件)
	kd.LogOut("KD_LOG:main _OnVideoGetInfoRetEvent err_code="..err_code);
	if(gUpdateView.m_ViewManager and gUpdateView.m_ViewManager:IsInitFinish()) then
		gUpdateView.m_ViewManager:OnVideoGetInfoRetEvent(err_code,video_file,steams,kbps,w,h,r,rate,max_time,fps,cover_path);
	elseif(gUpdateView.m_MiniGame and gUpdateView.m_MiniGame:IsInitFinish()) then
		gUpdateView.m_MiniGame:OnVideoGetInfoRetEvent(err_code,video_file,steams,kbps,w,h,r,rate,max_time,fps,cover_path);
	end
end