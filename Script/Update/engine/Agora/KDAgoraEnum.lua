--[[
	sky 声网枚举定义
]]

agora = {}

--[[///////////////////////////////////////////////////////////////////////////////]]
--枚举定义

--频道模式
agora.CHANNEL_PROFILE_TYPE = {
	--通信(默认),即常见的1对1单聊或群聊,频道内任何用户可以自由说话。
	CHANNEL_PROFILE_COMMUNICATION = 0,
	--直播,有两种用户角色:主播和观众.主播可以发送和接收音视频,而观众只能接收音视频
	CHANNEL_PROFILE_LIVE_BROADCASTING = 1,
	--游戏模式,频道中的任何用户都可以自由交谈.默认情况下,此模式使用低功耗和低比特率的编解码器
    CHANNEL_PROFILE_GAME = 2,
};

--直播模式下的角色定义
agora.CLIENT_ROLE_TYPE = {
	--主播
    CLIENT_ROLE_BROADCASTER = 1,
    --观众
    CLIENT_ROLE_AUDIENCE = 2,
};

--视频帧率
agora.FRAME_RATE = {
	FRAME_RATE_FPS_1 	= 1,		-- 1: 1 fps 
	FRAME_RATE_FPS_7 	= 7,		-- 7: 7 fps
	FRAME_RATE_FPS_10 	= 10,		-- 10: 10 fps
	FRAME_RATE_FPS_15 	= 15,		-- 15: 15 fps   
	FRAME_RATE_FPS_24 	= 24,		-- 24: 24 fps
	FRAME_RATE_FPS_30 	= 30,		-- 30: 30 fps   
	FRAME_RATE_FPS_60 	= 60,		-- 60: 60 fps (Windows and macOS only)
};

--视频输出方向模式
agora.ORIENTATION_MODE = {
	--[[
		0 ：（默认）自适应模式。
	    视频编码器适应视频输入设备的方向模式。

    	-如果从SDK捕获的视频的宽度大于高度，则编码器以横向模式发送视频。 编码器还发送视频的旋转信息，接收器使用旋转信息旋转接收到的视频。
    	-使用自定义视频源时，编码器的输出视频会继承原始视频的方向。 如果原始视频处于纵向模式，则编码器的输出视频也处于纵向模式。 编码器还将视频的旋转信息发送到接收器
	]] 
	ORIENTATION_MODE_ADAPTIVE 			= 0,
   
	--[[
		1：横向模式
		
		视频编码器始终以横向模式发送视频。 视频编码器在发送原始视频之前先对其进行旋转，并且旋转信息为0。此模式适用于涉及CDN实时流的方案
	]] 
	ORIENTATION_MODE_FIXED_LANDSCAPE	= 1,
	--[[
		2：人像模式
		
		视频编码器始终以纵向模式发送视频。 视频编码器在发送原始视频之前先对其进行旋转，并且旋转信息为0。此模式适用于涉及CDN实时流的方案
	]]
	ORIENTATION_MODE_FIXED_PORTRAIT 	= 2,
};

--带宽受限时的视频降级首选项
agora.DEGRADATION_PREFERENCE = {
	MAINTAIN_QUALITY 		= 0,		--0：（默认）降低帧频以保持视频质量
	MAINTAIN_FRAMERATE 		= 1,		--1：降低视频质量以保持帧频
	MAINTAIN_BALANCED 		= 2,		--2 ：（供将来使用）在帧频和视频质量之间保持平衡
};

--用户离线的原因
agora.USER_OFFLINE_REASON_TYPE = {
    USER_OFFLINE_QUIT = 0,				--0：用户退出呼叫
    USER_OFFLINE_DROPPED = 1, 			--1：SDK超时，用户在一定时间内未收到数据包，导致用户下线。 如果用户退出呼叫且消息未传递到SDK（由于通道不可靠），则SDK会假定用户已脱机
    USER_OFFLINE_BECOME_AUDIENCE = 2,	--2：(仅实时广播)客户端角色从主持人切换到听众
};

--本地视频状态类型
agora.LOCAL_VIDEO_STREAM_STATE = {
    LOCAL_VIDEO_STREAM_STATE_STOPPED = 0,		--初始状态
    LOCAL_VIDEO_STREAM_STATE_CAPTURING = 1,		--捕获器成功启动
    LOCAL_VIDEO_STREAM_STATE_ENCODING = 2,		--第一个视频帧已成功编码
    LOCAL_VIDEO_STREAM_STATE_FAILED = 3,		--本地视频无法启动
};

--本地视频状态错误代码
agora.LOCAL_VIDEO_STREAM_ERROR = { 
    LOCAL_VIDEO_STREAM_ERROR_OK = 0,					--本地视频正常
    LOCAL_VIDEO_STREAM_ERROR_FAILURE = 1,				--没有指定本地视频故障的原因
    LOCAL_VIDEO_STREAM_ERROR_DEVICE_NO_PERMISSION = 2,	--没有使用本地视频设备的权限
    LOCAL_VIDEO_STREAM_ERROR_DEVICE_BUSY = 3,			--使用本地视频捕获器
    LOCAL_VIDEO_STREAM_ERROR_CAPTURE_FAILURE = 4,		--本地视频捕获失败。 检查捕获器是否正常工作
    LOCAL_VIDEO_STREAM_ERROR_ENCODE_FAILURE = 5,		--本地视频编码失败
};


--远程视频的状态
agora.REMOTE_VIDEO_STATE = {
    REMOTE_VIDEO_STATE_STOPPED = 0,		--0：远程视频处于默认状态，可能是由于
    REMOTE_VIDEO_STATE_STARTING = 1,	--1：第一个远程视频包被接收
	
	--[[
		2：远程视频流被解码并正常播放，可能是由于
		#REMOTE_VIDEO_STATE_REASON.REMOTE_VIDEO_STATE_REASON_NETWORK_RECOVERY
		#REMOTE_VIDEO_STATE_REASON.REMOTE_VIDEO_STATE_REASON_LOCAL_UNMUTED
		#REMOTE_VIDEO_STATE_REASON.REMOTE_VIDEO_STATE_REASON_REMOTE_UNMUTED
		#REMOTE_VIDEO_STATE_REASON.REMOTE_VIDE_FIDE
	]]
    REMOTE_VIDEO_STATE_DECODING = 2,
	
	--[[
		--3：远程视频被冻结，可能是由于
		#REMOTE_VIDEO_STATE_REASON.REMOTE_VIDEO_STATE_REASON_NETWORK_CONGESTION
		#REMOTE_VIDEO_STATE_REASON.REMOTE_VIDEO_STATE_REASON_AUDIO_FALLBACK
	]]
    REMOTE_VIDEO_STATE_FROZEN = 3,

	--[[
		--4：远程视频无法启动，可能是由于#REMOTE_VIDEO_STATE_REASON.REMOTE_VIDEO_STATE_REASON_INTERNAL
	]]
    REMOTE_VIDEO_STATE_FAILED = 4,
};

--远程视频状态更改的原因
agora.REMOTE_VIDEO_STATE_REASON = {
    REMOTE_VIDEO_STATE_REASON_INTERNAL = 0,					--0：内部原因
    REMOTE_VIDEO_STATE_REASON_NETWORK_CONGESTION = 1,		--1：网络拥塞
    REMOTE_VIDEO_STATE_REASON_NETWORK_RECOVERY = 2,			--2：网络恢复
    REMOTE_VIDEO_STATE_REASON_LOCAL_MUTED = 3,				--3：本地用户停止接收远程视频流或禁用视频模块
    REMOTE_VIDEO_STATE_REASON_LOCAL_UNMUTED = 4,			--4：本地用户恢复接收远程视频流或启用视频模块
    REMOTE_VIDEO_STATE_REASON_REMOTE_MUTED = 5,				--5：远程用户停止发送视频流或禁用视频模块
    REMOTE_VIDEO_STATE_REASON_REMOTE_UNMUTED = 6,			--6：远程用户恢复发送视频流或启用视频模块
    REMOTE_VIDEO_STATE_REASON_REMOTE_OFFLINE = 7,			--7：远程用户离开频道
    REMOTE_VIDEO_STATE_REASON_AUDIO_FALLBACK = 8,			--8：由于网络状况不佳，远程媒体流会退回到纯音频流
    REMOTE_VIDEO_STATE_REASON_AUDIO_FALLBACK_RECOVERY = 9,	--9：网络条件改善后，远程媒体流切换回视频流

};

--连接状态
agora.CONNECTION_STATE_TYPE = {
	--[[
		1：SDK已从Agora的边缘服务器断开连接。

	   -这是调用\ ref agora :: rtc :: IRtcEngine :: joinChannel“ joinChannel”方法之前的初始状态。
	   -当应用程序调用\ ref agora :: rtc :: IRtcEngine :: leaveChannel“ leaveChannel”方法时，SDK也会进入此状态
	]]
	CONNECTION_STATE_DISCONNECTED = 1,
	
	--[[
		2：SDK正在连接到Agora的边缘服务器。

	    -当应用程序调用\ ref agora :: rtc :: IRtcEngine :: joinChannel“ joinChannel”方法时，SDK开始建立与指定通道的连接，并触发\ ref agora :: rtc :: IRtcEngineEventHandler :: onConnectionStateChanged“ onConnectionStateChanged”回调，并切换到#CONNECTION_STATE_CONNECTING状态。
	    -SDK成功加入频道后，会触发\ ref agora :: rtc :: IRtcEngineEventHandler :: onConnectionStateChanged“ onConnectionStateChanged”回调并切换到#CONNECTION_STATE_CONNECTED状态。
	    -SDK加入频道后，当完成媒体引擎的初始化后，SDK会触发\ ref agora :: rtc :: IRtcEngineEventHandler :: ononIninChannelSuccess“ onJoinChannelSuccess”回调
	]]
	CONNECTION_STATE_CONNECTING = 2,
	
	--[[
		3：SDK已连接到Agora的边缘服务器，并已加入渠道。 现在，您可以在频道中发布或订阅媒体流。

	    如果由于例如网络断开或切换而导致与通道的连接丢失，则SDK会自动尝试重新连接并触发onConnectionStateChanged回调并切换到#CONNECTION_STATE_RECONNECTING状态
	]]
	CONNECTION_STATE_CONNECTED = 3,
	
	--[[
		4：由于网络问题，从已加入的频道断开连接后，SDK会继续重新加入频道。

	    如果SDK在与Agora的边缘服务器断开连接后10秒钟内无法重新加入频道，则SDK会触发onConnectionLost”回调，保持在#CONNECTION_STATE_RECONNECTING状态,并保持重新加入这个频道。
	    如果SDK在与Agora的边缘服务器断开连接后20分钟内未能重新加入频道，则SDK会触发onConnectionStateChanged回调，切换到#CONNECTION_STATE_FAILED状态,并停止重新加入这个频道
	]]
	CONNECTION_STATE_RECONNECTING = 4,
	
	--[[
		 5：SDK无法连接到Agora的边缘服务器或加入频道。

    	您必须调用agora.leaveChannel方法退出此状态,然后再次调用agora.joinChannel方法才能重新加入频道

    	如果Agora的边缘服务器(通过RESTful API)禁止SDK加入频道,则SDK会触发onConnectionStateChanged回调
	]]
	CONNECTION_STATE_FAILED = 5,
};

--连接状态更改的原因
agora.CONNECTION_CHANGED_REASON_TYPE = {
	CONNECTION_CHANGED_CONNECTING = 0,					--0：SDK正在连接到Agora的边缘服务器

	CONNECTION_CHANGED_JOIN_SUCCESS = 1,				--1：SDK已成功加入频道

	CONNECTION_CHANGED_INTERRUPTED = 2,					--2：SDK与Agora边缘服务器之间的连接中断

	CONNECTION_CHANGED_BANNED_BY_SERVER = 3,			--3：Agora的边缘服务器禁止SDK和Agora的边缘服务器之间的连接

	CONNECTION_CHANGED_JOIN_FAILED = 4,					--4：SDK无法加入频道超过20分钟，并且停止重新连接到频道

	CONNECTION_CHANGED_LEAVE_CHANNEL = 5,				--5：SDK已离开频道

	CONNECTION_CHANGED_INVALID_APP_ID = 6,				--6：由于Appid无效，连接失败

	CONNECTION_CHANGED_INVALID_CHANNEL_NAME = 7,		--7：由于通道名称无效，连接失败
  
	--[[
		8：由于令牌无效，连接失败，可能是因为：

	   -在仪表板中启用了该项目的应用程序证书,但是在加入频道时不使用令牌.如果启用了应用程序证书,则必须使用令牌才能加入频道。
	   -您在agora.joinChannel方法中指定的uid与为生成令牌传递的uid不同
	]]
	CONNECTION_CHANGED_INVALID_TOKEN = 8,

	CONNECTION_CHANGED_TOKEN_EXPIRED = 9,				--9：由于令牌过期，连接失败

	CONNECTION_CHANGED_REJECTED_BY_SERVER = 10,			--10：服务器拒绝连接

	CONNECTION_CHANGED_SETTING_PROXY_SERVER = 11,		--11：由于SDK设置了代理服务器，因此连接更改为重新连接

	CONNECTION_CHANGED_RENEW_TOKEN = 12,				--12：当SDK连接失败时，续订令牌操作将使其连接

	CONNECTION_CHANGED_CLIENT_IP_ADDRESS_CHANGED = 13,	--13：SDK客户端的IP地址已更改。即网络运营商更改的网络类型或IP /端口可能会更改客户端IP地址

	CONNECTION_CHANGED_KEEP_ALIVE_TIMEOUT = 14,			--14：SDK和Agora边缘服务器之间的连接保持活动超时。连接状态更改为CONNECTION_STATE_RECONNECTING
};

--网络类型
agora.NETWORK_TYPE = {
  NETWORK_TYPE_UNKNOWN = -1,							--(-1)：网络类型未知
  NETWORK_TYPE_DISCONNECTED = 0,						--0：SDK与网络断开连接
  NETWORK_TYPE_LAN = 1,									--1：网络类型为LAN
  NETWORK_TYPE_WIFI = 2,								--2：网络类型为Wi-Fi（包括热点）
  NETWORK_TYPE_MOBILE_2G = 3,							--3：网络类型为移动2G
  NETWORK_TYPE_MOBILE_3G = 4,							--4：网络类型为移动3G
  NETWORK_TYPE_MOBILE_4G = 5,							--5：网络类型为移动4G
};

--直播中的客户角色
agora.CLIENT_ROLE_TYPE = {
    CLIENT_ROLE_BROADCASTER = 1,						--主播
    CLIENT_ROLE_AUDIENCE = 2,							--观众
};

--SDK错误枚举
agora.ERROR_CODE_TYPE = {
	ERR_OK = 0; --没有错误。

	ERR_FAILED =1; --一般性的错误（没有明确归类的错误原因）。

	ERR_INVALID_ARGUMENT = 2; --API 调用了无效的参数。例如指定的频道名含有非法字符。

	 --[[
		RTC 初始化失败。处理方法：
		检查音频设备状态。
		检查程序集完整性。
		尝试重新初始化 RTC 引擎。
	]]
	ERR_NOT_READY = 3;
	
	ERR_NOT_SUPPORTED = 4; --RTC 当前状态不支持此项操作。

	ERR_REFUSED = 5; --调用被拒绝。

	ERR_BUFFER_TOO_SMALL = 6; --传入的缓冲区大小不足以存放返回的数据。

	ERR_NOT_INITIALIZED = 7; --SDK 尚未初始化，就调用其 API。请确认在调用 API 之前已创建 RtcEngine 对象并完成初始化。

	ERR_NO_PERMISSION = 9; --没有操作权限，仅供 SDK 内部使用，不通过 API 或者回调事件返回给 App。

	ERR_TIMEDOUT = 10; --API 调用超时。有些 API 调用需要 SDK 返回结果，如果 SDK 处理事件过长，超过 10 秒没有返回，会出现此错误。

	ERR_CANCELED = 11; --请求被取消。仅供 SDK 内部使用，不通过 API 或者回调事件返回给 App。

	ERR_TOO_OFTEN=12; --调用频率太高。仅供 SDK 内部使用，不通过 API 或者回调事件返回给 App。

	ERR_BIND_SOCKET=13; --SDK 内部绑定到网络 Socket 失败。仅供 SDK 内部使用，不通过 API 或者回调事件返回给 App。

	ERR_NET_DOWN=14; --网络不可用。仅供 SDK 内部使用，不通过 API 或者回调事件返回给 App。

	ERR_NET_NOBUFS=15; --没有网络缓冲区可用。仅供 SDK 内部使用，不通过 API 或者回调事件返回给 App。

	--[[
		加入频道被拒绝。
		
		一般有以下原因：
		用户已进入频道，再次调用加入频道的 API，例如 joinChannel ，会返回此错误。停止调用该方法即可。
		用户在做 Echo 测试时尝试加入频道。等待 Echo test 结束后再加入频道即可。
		ERR_LEAVE_CHANNEL_REJECTED 	
		18; --离开频道失败。一般有以下原因：

		用户已离开频道，再次调用退出频道的 API，例如 leaveChannel ，会返回此错误。停止调用该方法即可。
		用户尚未加入频道，就调用退出频道的 API。这种情况下无需额外操作。
	]]
	ERR_JOIN_CHANNEL_REJECTED =17;
	
	ERR_ALREADY_IN_USE =19; --资源已被占用，不能重复使用。

	ERR_ABORTED = 20; --SDK 放弃请求，可能由于请求次数太多。

	ERR_INIT_NET_ENGINE = 21; --Windows 下特定的防火墙设置导致 SDK 初始化失败然后崩溃。

	ERR_RESOURCE_LIMITED = 22; --当用户 App 占用资源过多，或系统资源耗尽时，SDK 分配资源失败会返回该错误。

	ERR_INVALID_APP_ID = 101; --不是有效的 App ID。请更换有效的 App ID 重新加入频道。

	ERR_INVALID_CHANNEL_NAME = 102; --不是有效的频道名。请更换有效的频道名重新加入频道。

	ERR_CONNECTION_INTERRUPTED = 111; --网络连接中断。仅适用于 Agora Web SDK。

	ERR_CONNECTION_LOST = 112; --网络连接丢失。仅适用于 Agora Web SDK。

	ERR_NOT_IN_CHANNEL = 113; --用户不在频道内。在调用 sendStreamMessage 时，当调用发生在频道外时，会发生该错误.

	ERR_SIZE_TOO_LARGE = 114; --在调用 sendStreamMessage 时，当发送的数据长度大于 1024 个字节时，会发生该错误。

	ERR_BITRATE_LIMIT = 115; --在调用 sendStreamMessage 时，当发送的数据频率超过限制时(6 KB/s)，会发生该错误。

	ERR_TOO_MANY_DATA_STREAMS = 116; --在调用 createDataStream 时，如果创建的数据通道过多(超过 5 个通道)，会发生该错误。

	ERR_STREAM_MESSAGE_TIMEOUT = 117; --数据流发送超时。

	ERR_SET_CLIENT_ROLE_NOT_AUTHORIZED = 119; --切换角色失败。请尝试重新加入频道。

	ERR_DECRYPTION_FAILED = 120; --解密失败，可能是用户加入频道用了不同的密码。请检查加入频道时的设置，或尝试重新加入频道。

	ERR_CLIENT_IS_BANNED_BY_SERVER = 123; --此用户被服务器禁止。

	ERR_WATERMARK_PARAM = 124; --水印文件参数错误。

	ERR_WATERMARK_PATH = 125; --水印文件路径错误。

	ERR_WATERMARK_PNG = 126; --水印文件格式错误。

	ERR_WATERMARKR_INFO = 127; --水印文件信息错误。

	ERR_WATERMARK_ARGB = 128; --水印文件数据格式错误。

	ERR_WATERMARK_READ = 129; --水印文件读取错误。

	ERR_ENCRYPTED_STREAM_NOT_ALLOWED_PUBLISH = 130; --在调用 addPublishStreamUrl 时，如果开启了加密，则会返回该错误(推流不支持加密流)。

	ERR_INVALID_USER_ACCOUNT = 134; --无效的 User account.

	ERR_PUBLISH_STREAM_CDN_ERROR = 151; --CDN 相关错误。请调用 removePublishStreamUrl 方法删除原来的推流地址，然后调用 addPublishStreamUrl 方法重新推流到新地址。

	ERR_PUBLISH_STREAM_NUM_REACH_LIMIT = 152; --单个主播的推流地址数目达到上限 10。请删掉一些不用的推流地址再增加推流地址。

	ERR_PUBLISH_STREAM_NOT_AUTHORIZED = 153; --操作不属于主播自己的流，如更新其他主播的流参数、停止其他主播的流。请检查 App 逻辑。

	ERR_PUBLISH_STREAM_INTERNAL_SERVER_ERROR = 154; --推流服务器出现错误。请调用 addPublishStreamUrl 重新推流

	ERR_PUBLISH_STREAM_NOT_FOUND = 155; --服务器无法找到数据流。

	ERR_PUBLISH_STREAM_FORMAT_NOT_SUPPORTED = 156; --推流地址格式有错误。请检查推流地址格式是否正确

	ERR_LOAD_MEDIA_ENGINE = 1001; --加载媒体引擎失败。

	ERR_START_CALL = 1002; --启动媒体引擎开始通话失败。请尝试重新进入频道。

	ERR_START_VIDEO_RENDER = 1004; --启动视频渲染模块失败。

	ERR_ADM_GENERAL_ERROR = 1005; --音频设备模块：音频设备出现错误（未明确指明为何种错误）。请检查音频设备是否被其他应用占用，或者尝试重新进入频道。

	ERR_ADM_JAVA_RESOURCE = 1006; --音频设备模块：使用 Java 资源出现错误。

	ERR_ADM_SAMPLE_RATE = 1007; --音频设备模块：设置的采样频率出现错误。

	ERR_ADM_INIT_PLAYOUT = 1008; --音频设备模块：初始化播放设备出现错误。请检查播放设备是否被其他应用占用，或者尝试重新进入频道。

	ERR_ADM_START_PLAYOUT = 1009; --音频设备模块：启动播放设备出现错误。请检查播放设备是否正常，或者尝试重新进入频道。

	ERR_ADM_STOP_PLAYOUT = 1010; --音频设备模块：停止播放设备出现错误。

	ERR_ADM_INIT_RECORDING = 1011; --音频设备模块：初始化录音设备时出现错误。请检查录音设备是否正常，或者尝试重新进入频道。

	ERR_ADM_START_RECORDING = 1012; --音频设备模块：启动录音设备出现错误。请检查录音设备是否正常，或者尝试重新进入频道。

	ERR_ADM_STOP_RECORDING = 1013; --音频设备模块：停止录音设备出现错误。

	ERR_ADM_RUNTIME_PLAYOUT_ERROR = 1015; --音频设备模块：运行时播放出现错误。请检查播放设备是否正常，或者尝试重新进入频道。

	ERR_ADM_RUNTIME_RECORDING_ERROR = 1017; --音频设备模块：运行时录音错误。请检查录音设备是否正常，或者尝试重新进入频道。

	ERR_ADM_RECORD_AUDIO_FAILED = 1018; --音频设备模块：录音失败。

	ERR_ADM_INIT_LOOPBACK = 1022; --音频设备模块：初始化 Loopback 设备错误。

	ERR_ADM_START_LOOPBACK = 1023; --音频设备模块：启动 Loopback 设备错误。

	ERR_ADM_NO_PERMISSION = 1027; --音频设备模块：没有录音权限。请检查是否已经打开权限允许录音。

	ERR_ADM_RECORD_AUDIO_IS_ACTIVE = 1033; --音频设备模块：录制设备被占用。

	ERR_ADM_ANDROID_JNI_JAVA_RESOURCE = 1101; --音频设备模块：严重异常

	ERR_ADM_ANDROID_JNI_NO_RECORD_FREQUENCY = 1108; --音频设备模块：录制频率低于 50，常见为 0，即采集未启动，建议检查录音权限。

	ERR_ADM_ANDROID_JNI_NO_PLAYBACK_FREQUENCY = 1109; --音频设备模块：播放频率低于 50，常见为 0，即播放未启动，建议检查是否 AudioTrack 实例过多。

	ERR_ADM_ANDROID_JNI_JAVA_START_RECORD = 1111; --音频设备模块：AudioRecord 启动失败，系统 ROM 报错，建议重启 App 或重启手机、检查录音权限。

	ERR_ADM_ANDROID_JNI_JAVA_START_PLAYBACK = 1112; --音频设备模块：AudioTrack 启动失败，系统 ROM 报错，建议重启 App 或重启手机、检查播放权限。

	ERR_ADM_ANDROID_JNI_JAVA_RECORD_ERROR = 1115; --音频设备模块：AudioRecord 数据返回错误、SDK 会自动处理、重启 AudioRecord。

	ERR_ADM_IOS_INPUT_NOT_AVAILABLE = 1201; --音频设备模块：当前设备不支持音频输入，可能的原因是 Audio Session 的 category 配置不对或音频输入设备被占用。建议把后台所有 App 杀掉，重新加入频道。

	ERR_ADM_IOS_ACTIVATE_SESSION_FAIL = 1206; --音频设备模块：Audio Session 无法被启动。

	ERR_ADM_IOS_VPIO_INIT_FAIL = 1210; --音频设备模块：初始化音频设备出错。一般出错是因为音频设备的设置参数错误。

	ERR_ADM_IOS_VPIO_REINIT_FAIL = 1213; --音频设备模块：重新初始化音频设备出错。一般出错是因为音频设备的设置参数错误。

	ERR_ADM_IOS_VPIO_RESTART_FAIL = 1214; --音频设备模块：重新启动 Audio Unit 出错。一般出错是因为 Audio Session 的 category 设置与 Audio Unit 的设置不兼容。

	ERR_ADM_WIN_CORE_INIT = 1301; --音频设备模块：音频驱动异常或者兼容性问题 解决方案：禁用并重新启用音频设备，或者重启机器。

	ERR_ADM_WIN_CORE_INIT_RECORDING = 1303; --音频设备模块：音频驱动异常或者兼容性问题 解决方案：禁用并重新启用音频设备，或者重启机器。

	ERR_ADM_WIN_CORE_INIT_PLAYOUT = 1306; --音频设备模块：音频驱动异常或者兼容性问题 解决方案：禁用并重新启用音频设备，或者重启机器。

	ERR_ADM_WIN_CORE_INIT_PLAYOUT_NULL = 1307; --音频设备模块：无可用音频设备 解决方案：插入音频设备。

	ERR_ADM_WIN_CORE_START_RECORDING = 1309; --音频设备模块：音频驱动异常或者兼容性问题 解决方案：禁用并重新启用音频设备，或者重启机器。

	ERR_ADM_WIN_CORE_CREATE_REC_THREAD = 1311; --音频设备模块：系统内存不足或者机器性能较差 解决方案：重启机器或者更换机器。

	ERR_ADM_WIN_CORE_CAPTURE_NOT_STARTUP = 1314; --音频设备模块：音频驱动异常 解决方案：禁用并重新使能音频设备，或者重启机器，或者更新声卡驱动。

	ERR_ADM_WIN_CORE_CREATE_RENDER_THREAD = 1319; --音频设备模块：系统内存不足或者机器性能较差 解决方案：重启机器或者更换机器。

	ERR_ADM_WIN_CORE_RENDER_NOT_STARTUP = 1320; --音频设备模块：音频驱动异常 解决方案：禁用并重新使能音频设备，或者重启机器，或者更新声卡驱动。

	ERR_ADM_WIN_CORE_NO_RECORDING_DEVICE = 1322; --音频设备模块：无可用音频采集设备。解决方案：插入音频设备。

	ERR_ADM_WIN_CORE_NO_PLAYOUT_DEVICE = 1323; --音频设备模块：无可用音频播放设备。解决方案：插入音频设备

	ERR_ADM_WIN_WAVE_INIT = 1351; --音频设备模块：音频驱动异常或者兼容性问题 解决方案：禁用并重新使能音频设备，或者重启机器，或者更新声卡驱动。

	ERR_ADM_WIN_WAVE_INIT_RECORDING = 1353; --音频设备模块：音频驱动异常 解决方案：禁用并重新使能音频设备，或者重启机器，或者更新声卡驱动。

	ERR_ADM_WIN_WAVE_INIT_MICROPHONE = 1354; --音频设备模块：音频驱动异常 解决方案：禁用并重新使能音频设备，或者重启机器，或者更新声卡驱动。

	ERR_ADM_WIN_WAVE_INIT_PLAYOUT = 1355; --音频设备模块：音频驱动异常 解决方案：禁用并重新使能音频设备，或者重启机器，或者更新声卡驱动。

	ERR_ADM_WIN_WAVE_INIT_SPEAKER = 1356; --音频设备模块：音频驱动异常 解决方案：禁用并重新使能音频设备，或者重启机器，或者更新声卡驱动。

	ERR_ADM_WIN_WAVE_START_RECORDING = 1357; --音频设备模块：音频驱动异常 解决方案：禁用并重新使能音频设备，或者重启机器，或者更新声卡驱动。

	ERR_ADM_WIN_WAVE_START_PLAYOUT = 1358; --音频设备模块：音频驱动异常 解决方案：禁用并重新使能音频设备，或者重启机器，或者更新声卡驱动。

	ERR_ADM_NO_RECORDING_DEVICE = 1359; --音频设备模块：无录制设备。请检查是否有可用的录放音设备或者录放音设备是否已经被其他应用占用。

	ERR_ADM_NO_PLAYOUT_DEVICE = 1360; --音频设备模块：无播放设备。

	ERR_VDM_CAMERA_NOT_AUTHORIZED = 1501; --视频设备模块：没有摄像头使用权限。请检查是否已经打开摄像头权限。

	ERR_VCM_UNKNOWN_ERROR = 1600; --视频设备模块：未知错误。

	ERR_VCM_ENCODER_INIT_ERROR = 1601; --视频设备模块：视频编码器初始化错误。该错误为严重错误，请尝试重新加入频道。

	ERR_VCM_ENCODER_ENCODE_ERROR = 1602; --视频设备模块：视频编码器错误。该错误为严重错误，请尝试重新加入频道。

	ERR_VCM_ENCODER_SET_ERROR = 1603; --视频设备模块：视频编码器设置错误
};
