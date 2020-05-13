--[[
	sky 腾讯语聊组件唯一实例,不可派生
]]

--注册外部回调对象
local local_eventHandler = nil;

--腾讯游戏语音
TVideo = {
	-- 腾讯语聊的相关枚举定义
	GCloudVoiceErr = {
	  GCLOUD_VOICE_SUCC = 0,  --调用成功
	  GCLOUD_VOICE_PARAM_NULL = 0x1001,  --某些调用参数为NULL
	  GCLOUD_VOICE_NEED_SETAPPINFO = 0x1002,  --在调用其他api之前，应该先调用SetAppInfo
	  GCLOUD_VOICE_INIT_ERR = 0x1003,  --初始化出现未知错误
	  GCLOUD_VOICE_RECORDING_ERR = 0x1004,  --录音期间不可以做其他操作
	  GCLOUD_VOICE_POLL_BUFF_ERR = 0x1005, --poll缓冲区不够或空
	  GCLOUD_VOICE_MODE_STATE_ERR = 0x1006,  --调用的API复合先前的调用模式,请正确的调用SetMode设置语音模式
	  GCLOUD_VOICE_PARAM_INVALID = 0x1007,  --对于我们的请求，一些参数为null或值无效，请确保值的地址有效或者值的范围是正确的
	  GCLOUD_VOICE_OPENFILE_ERR = 0x1008,  --开启语音文件失败
	  GCLOUD_VOICE_NEED_INIT = 0x1009,  --在操作这个API之前，应该先调用Init初始化
	  GCLOUD_VOICE_ENGINE_ERR = 0x100A,  --你未获取引擎实例,该错误常见于 C# SDK 中
	  GCLOUD_VOICE_POLL_MSG_PARSE_ERR = 0x100B,  --parse poll msg err
	  GCLOUD_VOICE_POLL_MSG_NO = 0x100C,  --没有新的消息
	  GCLOUD_VOICE_REALTIME_STATE_ERR = 0x2001,  --你未加入一个聊天室,无法使用实时语音的API
	  GCLOUD_VOICE_JOIN_ERR = 0x2002,  --加入一个聊天室失败
	  GCLOUD_VOICE_QUIT_ROOMNAME_ERR = 0x2003,  --退出聊天室失败,退出的房间名和你处于的房间名不一致
	  GCLOUD_VOICE_OPENMIC_NOTANCHOR_ERR = 0x2004,  --open mic in bigroom,but not anchor role
	  GCLOUD_VOICE_AUTHKEY_ERR = 0x3001,  --调用语音key api接口失败
	  GCLOUD_VOICE_PATH_ACCESS_ERR = 0x3002,  --路径无法访问，可能是路径文件不存在或拒绝访问
	  GCLOUD_VOICE_PERMISSION_MIC_ERR = 0x3003,  --你没有访问麦克风的权限
	  GCLOUD_VOICE_NEED_AUTHKEY = 0x3004,  --你没有语音key,请先调用ApplyMessageKey申请语音key
	  GCLOUD_VOICE_UPLOAD_ERR = 0x3005,  --上传语音文件失败,请检测您的网络后重试
	  GCLOUD_VOICE_HTTP_BUSY = 0x3006,  --服务器繁忙,上传/下载语音文件失败,请稍后重试
	  GCLOUD_VOICE_DOWNLOAD_ERR = 0x3007,  --下载语音文件失败
	  GCLOUD_VOICE_SPEAKER_ERR = 0x3008,  --打开或关闭扬声器(TVE)错误
	  GCLOUD_VOICE_TVE_PLAYSOUND_ERR = 0x3009,  --扬声器(TVE)播放语音文件失败
	  GCLOUD_VOICE_AUTHING = 0x300a, --正在申请语音key中
	  GCLOUD_VOICE_INTERNAL_TVE_ERR = 0x5001,  --internal TVE err, our used
	  GCLOUD_VOICE_INTERNAL_VISIT_ERR = 0x5002,  --internal Not TVE err, out used
	  GCLOUD_VOICE_INTERNAL_USED = 0x5003,  --internal used, you should not get this err num
	  GCLOUD_VOICE_BADSERVER = 0x06001,  --错误的服务器地址
	  GCLOUD_VOICE_STTING = 0x07001,  --已经在speach中进行文本处理
	  GCLOUD_VOICE_INIT_FAIL = -1,  --创建语聊模块未成功
	};

	GCloudVoiceCompleteCode = {
	  GV_ON_JOINROOM_SUCC = 1,  --加入房间成功
	  GV_ON_JOINROOM_TIMEOUT = 2,  --加入房间超时
	  GV_ON_JOINROOM_SVR_ERR = 3,  --接入房间失败(与服务器通讯出现错误)
	  GV_ON_JOINROOM_UNKNOWN = 4,  --加入房间,出现内部异常
	  GV_ON_NET_ERR = 5,  --网络错误,请检查您的网络是否连接
	  GV_ON_QUITROOM_SUCC = 6,  --退出房间调用成功
	  GV_ON_MESSAGE_KEY_APPLIED_SUCC = 7,  --申请语音服务key成功
	  GV_ON_MESSAGE_KEY_APPLIED_TIMEOUT = 8,  --申请语音服务key超时
	  GV_ON_MESSAGE_KEY_APPLIED_SVR_ERR = 9,  --申请语音服务key失败(与服务器通讯出现错误)
	  GV_ON_MESSAGE_KEY_APPLIED_UNKNOWN = 10,   --申请语音服务key,出现内部异常
	  GV_ON_UPLOAD_RECORD_DONE = 11,  --上传语音文件成功
	  GV_ON_UPLOAD_RECORD_ERROR = 12,  --上传语音文件失败
	  GV_ON_DOWNLOAD_RECORD_DONE = 13,  --下载语音文件成功
	  GV_ON_DOWNLOAD_RECORD_ERROR = 14,  --下载语音文件失败
	  GV_ON_STT_SUCC = 15,  --STT 语音文字转换成功
	  GV_ON_STT_TIMEOUT = 16,  --STT 语音文字转换超时
	  GV_ON_STT_APIERR = 17,  --STT 语音文字转换失败(与服务器通讯出现错误)
	  GV_ON_RSTT_SUCC = 18,  --RSTT 语音文字转换成功
	  GV_ON_RSTT_TIMEOUT = 19,  --RSTT 语音文字转换超时
	  GV_ON_RSTT_APIERR = 20,  --RSTT 语音文字转换失败(与服务器通讯出现错误)
	  GV_ON_PLAYFILE_DONE = 21,  --语音消息播放完毕
	  GV_ON_ROOM_OFFLINE = 22,  --从房间里掉线
	};
	
	--[[GCloudVoiceErr, string]] init = c_TVideoInit;
	--[[GCloudVoiceErr, string]] SetVoiceMaxTime = c_TVideoSetVoiceMaxTime;
	--[[GCloudVoiceErr, string]] RecordingVoice = c_TVideoRecordingVoice;
	--[[GCloudVoiceErr, string]] UploadVoice = c_TVideoUploadVoice;
	--[[GCloudVoiceErr, string]] DownloadVoice = c_TVideoDownloadVoice;
	--[[GCloudVoiceErr, string]] PlayVoice = c_TVideoPlayVoice;
	--[[GCloudVoiceErr, string]] StopPlayVoice = c_TVideoStopPlayVoice;
	--[[GCloudVoiceErr, string]] GetAudioTime = c_TVideoGetAudioTime;
	
	--注册外部回调对象
	registerEventHandler = function(eventHandler)
		local_eventHandler = eventHandler;
	end;
	
	--[[
	初始化回调函数
	
	参数:
	_ncode:异步处理中可能产生的错误code
	_err_msg:异步处理中可能产生的错误消息
	]]
	OnApplyMsgKey = function( --[[GCloudVoiceCompleteCode]] _ncode, --[[string]] _err_msg)
		if (local_eventHandler and local_eventHandler.OnApplyMsgKey) then
			local_eventHandler.OnApplyMsgKey(_ncode, _err_msg);
		end
	end;
	
	
	--[[
	上传语聊回调函数
	
	参数:
	_sev_file_id:服务器中以供下载的文件索引
	_ncode:异步处理中可能产生的错误code
	_err_msg:异步处理中可能产生的错误消息
	]]
	OnUploadVoice = function(--[[string]] _sev_file_id, --[[GCloudVoiceCompleteCode]] _ncode, --[[string]] _err_msg)
		if (local_eventHandler and local_eventHandler.OnUploadVoice) then
			local_eventHandler.OnUploadVoice(_sev_file_id, _ncode, _err_msg);
		end
	end;
	
	--[[
	下载语聊回调函数
	
	参数:
	_sev_file_id:语音文件在服务器中的索引
	_save_file:本地保存路径
	_file_size:语音文件的磁盘大小
	_voice_time:语音文件的播放时长(秒)
	_ncode:异步处理中可能产生的错误code
	_err_msg:异步处理中可能产生的错误消息
	]]
	OnDownloadVoice = function(--[[string]] _sev_file_id, --[[string]] _save_file, --[[uint]] _file_size, --[[float]] _voice_time, --[[GCloudVoiceCompleteCode]] _ncode, --[[string]] _err_msg)
		if (local_eventHandler and local_eventHandler.OnDownloadVoice) then
			local_eventHandler.OnDownloadVoice(_sev_file_id, _save_file, _file_size, _voice_time, _ncode, _err_msg);
		end
	end;
	
	--[[
	语聊播放结束
	
	参数:
	_v_file:播放完毕的语音文件路径
	]]
	OnPlayVoiceEnd = function(--[[string]] _v_file)
		if (local_eventHandler and local_eventHandler.OnPlayVoiceEnd) then
			local_eventHandler.OnPlayVoiceEnd(_v_file);
		end
	end;
};