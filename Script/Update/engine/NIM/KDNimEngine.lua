--[[
	sky 网易云信管理引擎全局唯一实例,不可派生
]]

local kd = KDGame;

KDNim = {
	CallBackObj = nil;
	
	--[[///////////////////////////////////////////////////////////////////////////////]]
	--公用接口
	
	--初始化引擎
	init = --[[bool]]function(--[[KDGame.Node]] callbackObj,	--回调对象
							--[[string]] app_key, 				--开发者KEY
							--[[string]] data_en_key, 			--资源数据库KEY(默认"")
							--[[int]] timeout_retry_cnt, 		--登录失败的自动重连次数
							--[[bool]] use_https, 				--是否使用https协议
							--[[string]] ios_apns_cer)			--苹果的推送证书对应的云信ID
		if(KDNim.CallBackObj) then return false; end
		local bRet = c_nimInit(app_key,data_en_key,timeout_retry_cnt,use_https,ios_apns_cer);
		if(bRet) then KDNim.CallBackObj = callbackObj; end
		return bRet;
	end,
	
	--反初始化
	uninit = --[[void]]function()
		c_nimUninit();
		KDNim.CallBackObj = nil;
	end,
	
	--获取我的视频视图(这是一个全局视图,可以被addChild到任何对象中, RemoveChild只会移除管理但不会删除该对象)
	getNimMeVideoView = --[[KDGame.Node]] function()
		--已经创建就直接返回
		if(KDNim.MeVideoView) then return KDNim.MeVideoView; end
		--手动创建一个空的脚本NODE
		KDNim.MeVideoView = kd.new(kd.Node);
		if (KDNim.MeVideoView) then
			--把C层对象绑定进去
			KDNim.MeVideoView._object = c_getNimMeVideoView();
			if (KDNim.MeVideoView._object == nil) then
				kd.free(KDNim.MeVideoView);
				KDNim.MeVideoView = nil;
			end
		end
		
		return KDNim.MeVideoView;
	end,
	
	delNimMeVideoView = function()			
		if (KDNim.MeVideoView) then
			kd.free(KDNim.MeVideoView);
			KDNim.MeVideoView = nil;
		end	
	end,
	
	--获取通话对方的视频视图(这是一个全局视图,可以被addChild到任何对象中, RemoveChild只会移除管理但不会删除该对象)
	getNimNetVideoView = --[[KDGame.Node]] function()
		--已经创建就直接返回
		if(KDNim.NetVideoView) then return KDNim.NetVideoView; end
		--手动创建一个空的脚本NODE
		KDNim.NetVideoView = kd.new(kd.Node);
		if (KDNim.NetVideoView) then
			--把C层对象绑定进去
			KDNim.NetVideoView._object = c_getNimNetVideoView();
			if (KDNim.NetVideoView._object == nil) then
				kd.free(KDNim.NetVideoView);
				KDNim.NetVideoView = nil;
			end
		end
		
		return KDNim.NetVideoView;
	end,
	
	delNimNetVideoView = function()			
		if (KDNim.NetVideoView) then
			kd.free(KDNim.NetVideoView);
			KDNim.NetVideoView = nil;
		end	
	end,	
	
	--登录(异步)
	--[[
		参数:
		string account								--登录账号 
		string password								--登录密码或者token
		
		返回值:
		bool										--是否调用成功
	]]
	login = c_nimUserLogin;
	
	--退出或者注销等(异步)
	--[[
		参数:
		int out_type								--类型 1:注销 3:程序退出 2~4:内部保留
		
		返回值:
		无
	]]
	logout = c_nimUserLogout;
	
	--主动挂断通话
	--[[
		参数:
		无
		
		返回值:
		无
	]]
	endCall = c_nimEndAVCall;
	
	--检测是否正处于一个通话中
	--[[
		参数:
		无
		
		返回值:
		bool										--是否处于通话中(呼叫中,连接中,通话中都算是通话中)
	]]
	isCalling = c_nimIsCalling;
	
	--切换前后置摄像头
	--[[
		参数:
		无
		
		返回值:
		bool										--是否调用成功
	]]
	SwitchFACamera = c_nimSwitchFACamera;
	
	--关闭开启摄像头
	--[[
		参数:
		无
		
		返回值:
		bool										--是否调用成功
	]]
	CloseOrOpenCamera = c_nimCloseOrOpenCamera;	
	
	--通话两端的互通自定义消息接口(P2P 透传),可以用于红包等消息的传递
	--[[
		参数:
		string sz_msg								--消息内容
		
		返回值:
		bool										--是否调用成功
	]]
	SendP2PMessage = c_nimSendP2PMessage;		
	
	--获取用户信息
	--[[
		参数:
		string user_id								--用户ID
		
		返回值:
		bool										--是否调用成功
	]]
	GetUserInfo = c_nimGetUserInfo;		
	
	--视频截图
	--[[
		参数:
		int view_type								--视图类型(0:我的 1:对方的)
		string save_path							--保存地址(相对路径)
		
		返回值:
		bool										--是否调用成功
	]]
	ScreenShots2JPG = c_nimScreenShots2JPG;			
	
	--[[///////////////////////////////////////////////////////////////////////////////]]
	--呼出方接口
	
	--发起一个通话
	--[[
		参数:
		int mode,									--通话形式(1:音频 2:音视频)
		string push_msg,							--推送文本,如果对方没有登录APP的推送消息
		string custom_info,							--自定义消息(带给接收方)
		string Be_invited_uid,						--被邀请者ID
		int max_video_rate = 100000,				--通话最大码率
		int dpi_type = 0,							--视频质量(WIN32下无效,具体参数参考IOS 和 android的具体枚举)
		bool push_enable = true,					--是否需要推送本次请求
		bool need_nick= true						--推送是否显示用户昵称
		
		返回值:
		bool										--是否调用成功
	]]
	startCall = c_nimStartAVCall;
	
	--[[///////////////////////////////////////////////////////////////////////////////]]
	--被呼方接口
	
	--同意或者拒绝通话
	--[[
		参数:
		bool accept									--是否同意接通
		int dpi_type								--期望分辨率(详细见 ↓注1)
		
		返回值:
		bool										--是否调用成功
	]]
	agreedCall = c_nimAcceptAVCall;
	
	
	--[[///////////////////////////////////////////////////////////////////////////////]]
	--回调函数
	
	--登录回调
	OnNimUserLoginBack = function(--[[int]] err_code, 		--错误值(200:成功)
								--[[stirng]] err_msg, 		--错误消息
								--[[bool]] relogin, 		--是否为重连过程
								--[[int]] login_step, 		--登录状态(0:正在连接 1:连接服务器 2:正在登录 3:登录验证)
								--[[bool]] retrying)		--是否在重试，如果为false，需要检查登录步骤和错误码，明确问题后调用手动重连接口进行登录操作
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimUserLoginBack==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimUserLoginBack(err_code,err_msg,relogin,login_step,retrying);
	end,
	
	--登出回调
	OnNimUserLogoutBack = function(--[[int]] err_code --[[错误值(200:成功)]], --[[stirng]] err_msg)
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimUserLogoutBack==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimUserLogoutBack(err_code,err_msg);		
	end,
	
	--被踢(他端登录)回调
	OnNimUserKickBack = function(--[[int]] tick_type --[[目前只有被T的情况,无视]])
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimUserKickBack==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimUserKickBack(tick_type);
	end,
	
	--通话结束回调
	OnNimCallEndBack = function(--[[int]] end_type --[[0:自己主动挂断 1:对方挂断 2:连接中断 3:通话途中网络超时(10秒)]])
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimCallEndBack==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimCallEndBack(end_type);		
	end,
	
	--网络断开回调
	OnNimDisconnectBack = function()
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimDisconnectBack==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimDisconnectBack();
	end,
	
	--对端开启关闭摄像头回调
	OnNimNetUserCameraChange = function(--[[bool]] close)
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimNetUserCameraChange==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimNetUserCameraChange(close);
	end,	
	
	--收到对端自定义消息回调 
	OnNimP2PCustomMessage = function(--[[string]] sz_msg)
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimP2PCustomMessage==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimP2PCustomMessage(sz_msg);
	end,	
	
	--获取用户信息回调
	OnNimGetUserInfoBack = function(--[[int]] err_code,					-- 错误码(0:成功)
									--[[string]] _err_msg,				-- 错误信息
									--[[string]] accid_,				-- 用户ID
									--[[string]] nickname_,				-- 用户昵称
									--[[string]] icon_url_,				-- 用户头像下载地址
									--[[string]] signature_,			-- 用户签名
									--[[int]] gender_,					-- 用户性别
									--[[string]] email_,				-- 用户邮箱
									--[[string]] birth_,				-- 用户生日
									--[[string]] mobile_,				-- 用户电话
									--[[int64_t]] create_timetag_,		-- 用户档案创建时间戳(毫秒)
									--[[int64_t]] update_timetag_)		-- 用户档案更新时间戳(毫秒)
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimGetUserInfoBack==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimGetUserInfoBack(err_code,_err_msg,accid_,nickname_,icon_url_,signature_,gender_,
											email_,birth_,mobile_,create_timetag_,update_timetag_);
	end,
	
	--视频截图回调
	OnNimScreenShotsBack = function(--[[int]] view_type, 				-- 视图类型(0:我的 1:对方的)
									--[[string]] save_path)				-- 保存地址(绝对路径)
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimScreenShotsBack==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimScreenShotsBack(view_type,save_path);			
	end,
	
	--[[=========================================================]]
	--呼叫方回调
	--发起通话回调
	OnNimCallStartBack = function(--[[int]] err_code --[[错误值(200:成功)]], --[[stirng]] err_msg)
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimCallStartBack==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimCallStartBack(err_code,err_msg);		
	end,
	
	--对方的回应回调
	OnNimCallBeAgreedBack = function(--[[bool]] accept, 				--同意 or 拒绝
									--[[string]] be_user_id, 			--对方的ID
									--[[int]] refused_type)				--在 accept 为false时有效, 0:对方主动挂断 1:对方正忙
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimCallBeAgreedBack==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimCallBeAgreedBack(accept,be_user_id,refused_type);			
	end,
	
	--[[=========================================================]]
	--被呼叫方回调
	--有一个通话进入
	OnNimCallComeinBack = function(--[[long long]] chat_id,		--云信聊天ID
								--[[string]] call_user_id, 		--呼叫者ID
								--[[string]] custom_info,		--呼叫者留言 
								--[[int]] call_mode, 			--呼叫模式 1:语音通话 2:音视频通话
								--[[long long]] call_time)		--呼叫时间戳
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimCallComeinBack==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimCallComeinBack(chat_id,call_user_id,custom_info,call_mode,call_time);		
	end,
	
	--[[=========================================================]]
	--视频回调
	--我的视频视图已经准备完毕(读取到第一帧)
	OnNimMeVideoBeginBack = function(--[[int]] w, --[[int]] h)
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimMeVideoBeginBack==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimMeVideoBeginBack(w,h);			
	end,
	
	--对方的视频视图已经准备完毕(bFirst:是否读取到第一帧)
	OnNimNetVideoBeginBack = function(--[[bool]] bFirst, --[[int]] w, --[[int]] h)
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimNetVideoBeginBack==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimNetVideoBeginBack(bFirst,w,h);		
	end,
	
	--[[=========================================================]]
	--WIN32专用,设备开启回调
	OnNimWin32DeviceOpenBack = function(--[[int]] dev_type --[[0:麦克风, 2:音频播放器 3:摄像头]], --[[bool]] success)
		if(KDNim.CallBackObj==nil or KDNim.CallBackObj.OnNimWin32DeviceOpenBack==nil) then
			return;
		end
		
		KDNim.CallBackObj:OnNimWin32DeviceOpenBack(dev_type,success);			
	end,
};

--[[
注1:
WIN32下的dpi_type参考: 
0：默认分辨率 480x320
1：低分辨率 176x144
2：视频中分辨率 352x288
3：视频高分辨率 480x320
4：视频超高分辨率 640x480
5：用于桌面分享级别的分辨率1280x720，需要使用高清摄像头并指定对应的分辨率
6：介于720P与480P之间的类型，默认 960*540

Android下的dpi_type参考:
暂无

IOS下的dpi_type参考:
0：默认分辨率 480P
1：低视频质量
2：中等视频质量
3：高视频质量
4：480P 等级视频质量
5：540P 等级视频质量
6：720P 等级视频质量
]]