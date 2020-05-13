--[[
	sky 网易云信管理引擎全局唯一实例,不可派生
]]

c_Require("Script/Engine/Agora/KDAgoraEnum.lua")

local kd = KDGame


--[[///////////////////////////////////////////////////////////////////////////////]]
--公用接口

--初始化引擎
--[[
	参数:
	string app_key,					--开发者KEY
	agora.CHANNEL_PROFILE_TYPE type	--频道模式
	
	返回值:
	bool							--是否调用成功
]]
agora.init = c_AgoraInitSDK;

--设置本地视频配置
--[[
	参数:
	int w,h																								--视频编码的分辨率
	agora.FRAME_RATE feam_rate = agora.FRAME_RATE.FRAME_RATE_FPS_15										--视频编码的帧率
	agora.ORIENTATION_MODE orientationMode = agora.ORIENTATION_MODE.ORIENTATION_MODE_ADAPTIVE			--视频编码的方向模式
	agora.DEGRADATION_PREFERENCE degradationPreference = agora.DEGRADATION_PREFERENCE.MAINTAIN_QUALITY	--带宽受限时，视频编码降级偏好
	int minBitrate = -1																					--最低编码码率，单位为 Kbps
	int bitrate = 0																						--视频编码码率，单位为 Kbps
	int minBitrate = -1																					--最低编码码率，单位为 Kbps
	
	返回值:
	bool						--是否调用成功
]]
agora.SetLocalViewConfig = c_AgoraSetLocalViewConfig;

--启用或者关闭本地视频采集
--[[
	参数:
	bool enable					--启用或者关闭
	
	返回值:
	bool						--是否调用成功
]]
agora.enableLocalVideo = c_AgoraEnableLocalVideo;

--启用或者关闭本地视频流发送
--[[
	参数:
	bool enable					--启用或者关闭
	
	返回值:
	bool						--是否调用成功
]]
agora.enableLocalVideoStream = c_AgoraEnableLocalVideoStream;

--启用或者不启用远端特定用户的视频数据
--[[
	参数:
	int user_id					--禁用或者启用的远端用户ID
	bool enable					--启用或者关闭
	
	返回值:
	bool						--是否调用成功
]]
agora.enableRemoteVideo = c_AgoraEnableRemoteVideo;

--启用或者不启用所有远端特定用户的视频数据
--[[
	参数:
	bool enable					--启用或者关闭
	
	返回值:
	bool						--是否调用成功
]]
agora.enableAllRemoteVideo = c_AgoraEnableAllRemoteVideo;

--切换前后置摄像头(IOS/ANDROID下有效,windows下必然返回失败)
--[[
	参数:
	无
	
	返回值:
	bool						--是否调用成功
]]
agora.switchCamera = c_AgoraSwitchCamera;

--启用或者关闭本地音频采集
--[[
	参数:
	bool enable					--启用或者关闭
	
	返回值:
	bool						--是否调用成功
]]
agora.enableLocalAudio = c_AgoraEnableLocalAudio;

--启用或者关闭本地音频流发送
--[[
	参数:
	bool enable					--启用或者关闭
	
	返回值:
	bool						--是否调用成功
]]
agora.enableLocalAudioStream = c_AgoraEnableLocalAudioStream;

--启用或者不启用远端特定用户的音频数据
--[[
	参数:
	int user_id					--禁用或者启用的远端用户ID
	bool enable					--启用或者关闭
	
	返回值:
	bool						--是否调用成功
]]
agora.enableRemoteAudio = c_AgoraEnableRemoteAudio;

--启用或者不启用所有远端特定用户的音频数据
--[[
	参数:
	bool enable					--启用或者关闭
	
	返回值:
	bool						--是否调用成功
]]
agora.enableAllRemoteAudio = c_AgoraEnableAllRemoteAudio;

--加入频道
--[[
	参数:
	string token				--鉴权Token
	string channelName			--标识通话频道的字符,长度在 64 个字节以内的字符串
	int userID					--用户ID,如果不指定(即设为 0),SDK 会自动分配一个
	
	返回值:
	int							--是否调用成功
								0: Success.
								-2: 使用了无效的参数
								-3: SDK模块尚未准备就绪
								-5: 该请求被拒绝
]]
agora.joinChannel = c_AgoraJoinChannel;

--离开频道
--[[
	参数:
	无
	
	返回值:
	bool						--是否调用成功
]]
agora.leaveChannel = c_AgoraLeaveChannel;

--设置用户角色(直播模式专用)
--[[
	参数:
	CLIENT_ROLE_TYPE role		--角色枚举
	
	返回值:
	bool						--是否调用成功
]]
agora.setClientRole = c_AgoraSetClientRole;


--更新频道鉴权Token到SDK
--[[
	参数:
	string new_token			--新的鉴权Token
	
	返回值:
	bool						--是否调用成功
]]
agora.renewToken = c_AgoraRenewToken;

--创建本地视频视图(这是一个C层强管理视图,可以被addChild到任何对象中, RemoveChild只会移除管理但不会删除该对象,必须调用freeLocalVideoView删除)
--[[
	参数:
	无
	
	返回值:
	KDGame.Node					--本地视频视图
]]
agora.createLocalVideoView = --[[KDGame.Node]] function()
	--手动创建一个空的脚本NODE
	local local_node = kd.new(kd.Node);
	if (local_node) then
		--吧C层对象绑定进去
		local_node._object = c_AgoraCreateLocalVideoView();
		if (local_node._object == nil) then
			kd.free(local_node);
			local_node = nil;
		end
	end
	
	return local_node;
end;

--释放本地视频视图
--[[
	参数:
	无
	
	返回值:
	无
]]
agora.freeLocalVideoView = c_AgoraFreeLocalVideoView;

--创建一个远端用户的视频视图(这是一个C层强管理视图,可以被addChild到任何对象中, RemoveChild只会移除管理但不会删除该对象,必须调用freeRemoteVideoView删除)
--[[
	参数:
	int userID					--视频视图绑定的远端用户ID
	
	返回值:
	KDGame.Node					--远端用户视频视图
]]
agora.createRemoteVideoView = --[[KDGame.Node]] function(--[[int]] user_id)
	--手动创建一个空的脚本NODE
	local local_node = kd.new(kd.Node);
	if (local_node) then
		--吧C层对象绑定进去
		local_node._object = c_AgoraCreateRemoteVideoView(user_id);
		if (local_node._object == nil) then
			kd.free(local_node);
			local_node = nil;
		end
	end
	
	return local_node;
end;

--释放一个远端用户的视频视图
--[[
	参数:
	int userID					--视频视图绑定的远端用户ID
	
	返回值:
	无
]]
agora.freeRemoteVideoView = c_AgoraFreeRemoteVideoView;


--注册外部回调对象
local local_eventHandler = nil;
agora.registerEventHandler = function(eventHandler)
	local_eventHandler = eventHandler;
end;


--[[///////////////////////////////////////////////////////////////////////////////]]
--回调函数



--[[
	声网SDK运行时报告错误。

	在大多数情况下，SDK无法解决问题并继续运行。 SDK要求应用程序采取措施或将问题通知用户。
	例如，当初始化呼叫失败时，SDK报告一个#ERR_START_CALL错误。 该应用程序通知用户调用初始化失败，并调用agora.leaveChannel方法离开该通道。

	@param err	错误代码：#ERROR_CODE_TYPE。
	@param msg	指向错误消息的指针
]] 
agora.onError = function(--[[agora.ERROR_CODE_TYPE]] err, --[[string]] msg)
	if (local_eventHandler ~= nil and local_eventHandler.onError ~= nil) then
		local_eventHandler.onError(err, msg);
	end
end;

--[[
	当用户加入频道时发生。

	当应用程序调用IRtcEngine::joinChannel方法时，此回调通知应用程序用户已加入指定的频道。
	通道名称分配基于IRtcEngine::joinChannel方法中指定的channelName。
	如果未在joinChannel方法中指定uid，则服务器会自动分配一个uid。

	@param string channel	加入的通话频道的字符
	@param string user_id	加入频道的用户的用户ID。
	@param int elapsed		从用户调用agora.joinChannel方法直到SDK触发此回调为止的时间(ms)
]]
agora.onJoinChannelSuccess = function(--[[string]] channel, --[[string]] user_id, --[[int]] elapsed)
	if (local_eventHandler ~= nil and local_eventHandler.onJoinChannelSuccess ~= nil) then
		local_eventHandler.onJoinChannelSuccess(channel, user_id, elapsed);
	end
end;

--[[
	在用户离开频道时发生

	当应用程序调用IRtcEngine::leaveChannel方法时，此回调通知应用程序用户离开通道。
	该应用程序检索信息，例如通话时间和统计信息。

	@param string stats_json	统计信息json
]]
agora.onLeaveChannel = function(--[[string]] stats_json)
	if (local_eventHandler ~= nil and local_eventHandler.onLeaveChannel ~= nil) then
		local_eventHandler.onLeaveChannel(stats_json);
	end
end;

--[[
	在远程用户（通信）/主机（实时广播）加入频道时发生。

	通信模式下，该回调提示有远端用户加入了频道，并返回新加入用户的 ID；如果加入之前，已经有其他用户在频道中了，新加入的用户也会收到这些已有用户加入频道的回调
	直播模式下，该回调提示有主播加入了频道，并返回该主播的用户 ID。如果在加入之前，已经有主播在频道中了，新加入的用户也会收到已有主播加入频道的回调。Agora 建议连麦主播不超过 17 人

	在下列情况之一的情况下，SDK会触发此回调：
	远端用户/主播调用 joinChannel 方法加入频道
	远端用户加入频道后调用 setClientRole 将用户角色改变为主播
	远端用户/主播网络中断后重新加入频道
	主播通过调用 addInjectStreamUrl 方法成功导入在线媒体流

	@param int user_id		加入通道的用户或主机的用户ID。
	@param int elapsed		从本地用户调用agora.joinChannel方法开始的时间延迟（ms,直到SDK触发此回调为止)
]]
agora.onUserJoined = function(--[[int]] user_id, --[[int]] elapsed)
	if (local_eventHandler ~= nil and local_eventHandler.onUserJoined ~= nil) then
		local_eventHandler.onUserJoined(user_id, elapsed);
	end
end;

--[[
	远端用户（通信模式）/主播（直播模式）离开当前频道回调

	提示有远端用户/主播离开了频道（或掉线）。用户离开频道有两个原因，即正常离开和超时掉线：
	正常离开的时候，远端用户/主播会收到类似“再见”的消息，接收此消息后，判断用户离开频道.
	超时掉线的依据是，在一定时间内（通信场景为 20 秒，直播场景稍有延时），用户没有收到对方的任何数据包，则判定为对方掉线。在网络较差的情况下，有可能会误报。Agora 建议使用信令系统来做可靠的掉线检测/

	@param int user_id								离开频道或离线的用户的用户ID。
	@param agora.USER_OFFLINE_REASON_TYPE reason	用户离线的原因：#USER_OFFLINE_REASON_TYPE。
]]
agora.onUserOffline = function(--[[int]] user_id, --[[agora.USER_OFFLINE_REASON_TYPE]] reason)
	if (local_eventHandler ~= nil and local_eventHandler.onUserOffline ~= nil) then
		local_eventHandler.onUserOffline(user_id, reason);
	end
end;

--[[
	本地或远端视频大小和旋转信息发生改变回调

	@param int user_id	图像尺寸和旋转信息发生变化的用户的用户ID(本地用户的 user_id 为 0)
	@param int width	视频的新宽度（像素）.
	@param int height	视频的新高度（像素）.
	@param int rotation	视频的新旋转度[0到360].
]]
agora.onVideoSizeChanged = function(--[[int]] user_id, --[[int]] width, --[[int]] height, --[[int]] rotation)
	if (local_eventHandler ~= nil and local_eventHandler.onVideoSizeChanged ~= nil) then
		local_eventHandler.onVideoSizeChanged(user_id, width, height, rotation);
	end
end;

--[[
	在本地视频流状态更改时发生。

	@note 此回调指示本地视频流的状态，包括摄像机捕获和视频编码，并允许您在发生异常时解决问题。

	@param agora.LOCAL_VIDEO_STREAM_STATE localVideoState	状态类型
	@param agora.LOCAL_VIDEO_STREAM_ERROR err				详细的错误信息
]]
agora.onLocalVideoStateChanged = function(--[[agora.LOCAL_VIDEO_STREAM_STATE]] localVideoState, --[[agora.LOCAL_VIDEO_STREAM_ERROR]] err)
	if (local_eventHandler ~= nil and local_eventHandler.onLocalVideoStateChanged ~= nil) then
		local_eventHandler.onLocalVideoStateChanged(localVideoState, err);
	end
end;

--[[
	在远程视频状态更改时发生。

	@param uid		视频状态改变的远程用户的ID。
	@param state	远程视频的状态。 请参阅#REMOTE_VIDEO_STATE.
	@param reason	远程视频状态更改的原因。 请参阅#REMOTE_VIDEO_STATE_REASON.
	@param elapsed	从本地用户调用IRtcEngine::joinChannel方法经过的时间（ms）,直到SDK触发此回调.
]]
agora.onRemoteVideoStateChanged = function(--[[int]] uid, --[[agora.REMOTE_VIDEO_STATE]] state, --[[agora.REMOTE_VIDEO_STATE_REASON]] reason, --[[int]] elapsed)
	if (local_eventHandler ~= nil and local_eventHandler.onRemoteVideoStateChanged ~= nil) then
		local_eventHandler.onRemoteVideoStateChanged(uid, state, reason, elapsed);
	end
end;

--[[
	当SDK和服务器之间的连接状态更改时发生。

	@param agora.CONNECTION_STATE_TYPE state			状态
	@param agora.CONNECTION_CHANGED_REASON_TYPE	reason	原因
]]
agora.onConnectionStateChanged = function(--[[agora.CONNECTION_STATE_TYPE]] state, --[[agora.CONNECTION_CHANGED_REASON_TYPE]] reason)
	if (local_eventHandler ~= nil and local_eventHandler.onConnectionStateChanged ~= nil) then
		local_eventHandler.onConnectionStateChanged(state, reason);
	end
end;

--[[
	在本地网络类型更改时发生。

	当网络连接中断时,此回调指示该中断是由网络类型更改还是不良的网络状况引起的。

	@param agora.NETWORK_TYPE net_type	网络状态
]]
agora.onNetworkTypeChanged = function(--[[agora.NETWORK_TYPE]] net_type)
	if (local_eventHandler ~= nil and local_eventHandler.onNetworkTypeChanged ~= nil) then
		local_eventHandler.onNetworkTypeChanged(net_type);
	end
end

--[[
	在Token牌到期时发生。

	通过调用agora.joinChannel方法指定Token后，如果SDK由于网络问题而失去与Agora服务器的连接，则Token可能会在一段时间后过期，并且可能需要新的Token重新连接到服务器。
	此回调通知应用程序生成新令牌。 调用agora.renewToken方法来更新Token.
]]
agora.onRequestToken = function()
	if (local_eventHandler ~= nil and local_eventHandler.onRequestToken ~= nil) then
		local_eventHandler.onRequestToken();
	end
end;

--[[ Token将在30秒后过期时发生。

	如果agora.joinChannel方法中使用的令牌到期，则用户将变为脱机状态.
	SDK会在Token到期前30秒触发此回调，以提醒应用程序获取新Token.收到此回调后,在服务器上生成一个新Token,然后调用agora.renewToken方法将新令牌传递给SDK。

	@param string token	指向30秒后过期的令牌的指针.
]]
agora.onTokenPrivilegeWillExpire = function(--[[string]] token)
	if (local_eventHandler ~= nil and local_eventHandler.onTokenPrivilegeWillExpire ~= nil) then
		local_eventHandler.onTokenPrivilegeWillExpire(token);
	end
end;

--[[
	在实时广播中切换用户角色时发生。 例如，从主持人到听众，反之亦然。

	当应用程序调用IRtcEngine::setClientRole方法时，此回调通知应用程序用户角色切换。
	加入频道后，本地用户通过调用IRtcEngine::setClientRole方法来切换用户角色时，SDK会触发此回调。
	@param old_role	用户切换到的角色
	@param new_role	用户切换到的角色
]]
agora.onClientRoleChanged = function(--[[agora.CLIENT_ROLE_TYPE]] old_role, --[[agora.CLIENT_ROLE_TYPE]] new_role)
	if (local_eventHandler ~= nil and local_eventHandler.onClientRoleChanged ~= nil) then
		local_eventHandler.onClientRoleChanged(old_role, new_role);
	end
end;





