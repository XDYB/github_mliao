--[[
	sky 网易云信管理引擎全局唯一实例,不可派生
]]

local kd = KDGame

tim = {};
tim.sdk = {}; 			--初始化,反初始化,登陆登出等接口全都在这table下
tim.Conv = {};			--会话相关的接口都在这table下
tim.Msg = {}; 			--消息相关的接口都在这table下
tim.Group = {};			--群组相关的接口都在这table下	
tim.UserProfile = {};	--用户资料的接口都在这table下
tim.Friendship = {};	--关系链的接口都在这table下


local local_sdk = tim.sdk;
local local_conv = tim.Conv;
local local_msg = tim.Msg;
local local_group = tim.Group;
local local_user = tim.UserProfile;
local local_friend = tim.Friendship;

--[[///////////////////////////////////////////////////////////////////////////////]]
--公用接口

--IM SDK 初始化
--[[
	参数:
	unsigned int64 sdk_app_id,					--开发者KEY
	string json_sdk_config,						--IM SDK 配置选项 JSON 字符串,详情参考
												  tim.sdk.SdKConfig->[https://cloud.tencent.com/document/product/269/33553#sdkconfig]
	
	注释1:
		- 在使用 IM SDK 进一步操作之前,需要先初始化 IM SDK
		- json_sdk_config可以""空字符串,在此情况下SdkConfig均为默认值
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_sdk.init = c_Tim_init;

--IM SDK 卸载(卸载 DLL 或退出进程前需此接口卸载 IM SDK，清理 IM SDK 相关资源)
local_sdk.uninit = c_Tim_uninit;

--获取 IM SDK 版本号
--[[
	参数:
	无
	
	返回值:
	string										--IM SDK 的版本号
]]
local_sdk.getSDKVersion = c_Tim_getSDKVersion;

--设置额外的用户配置
--[[
	参数:
	string json_config,							--配置选项 JSON 字符串,如果填写空字符串"",将会在tim.OnCommCallback中返回当前所有的配置信息,
												  详情请参考tim.sdk.SetConfig->[https://cloud.tencent.com/document/product/269/33553#setconfig]
												
	string user_data,							--用户自定义字符串(比如JSON)，IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_sdk.setConfig = c_Tim_setConfig;

--用户登录
--[[
	参数:
	string user_id,								--用户的 indentifier
	string user_sig								--用户的 sig											
	string user_data,							--用户自定义字符串(比如JSON)，IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:用户登录腾讯后台服务器后才能正常收发消息,登录需要用户提供 UserID、UserSig 等信息
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_sdk.login = c_Tim_login;

--用户登出
--[[
	参数:										
	string user_data,							--用户自定义字符串(比如JSON)，IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:如用户主动登出或需要进行用户的切换，则需要调用登出操作
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_sdk.logout = c_Tim_logout;

--创建会话
--[[
	参数:										
	string 		conv_id							--会话的ID
	TIMConvType conv_type						--会话类型,详情请参考tim.conv.TIMConvType->[https://cloud.tencent.com/document/product/269/33553#timconvtype]
	string 		user_data,						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:
		- 会话是指面向一个人或者一个群组的对话,通过与单个人或群组之间会话收发消息
		- 此接口创建或者获取会话信息,需要指定会话类型(群组或者单聊),以及会话对方标志(对方帐号或者群号).会话信息通过tim.OnCommCallback回传
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_conv.convCreate = c_Tim_convCreate;

--删除会话
--[[
	参数:										
	string 		conv_id							--会话的ID
	TIMConvType conv_type						--会话类型,详情请参考tim.conv.TIMConvType->[https://cloud.tencent.com/document/product/269/33553#timconvtype]
	string 		user_data,						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_conv.convDelete = c_Tim_convDelete;

--获取最近联系人的会话列表
--[[
	参数:										
	string 		user_data,						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_conv.convGetConvList = c_Tim_convGetConvList;

--设置指定会话的草稿
--[[
	参数:										
	string 		conv_id							--会话的ID
	TIMConvType conv_type						--会话类型,详情请参考tim.conv.TIMConvType->[https://cloud.tencent.com/document/product/269/33553#timconvtype]
	string 		json_draft_param,				--被设置的草稿 JSON 字符串,详情请参考tim.conv.Draft->[https://cloud.tencent.com/document/product/269/33553#draft]
	
	注释1:会话草稿一般用在保存用户当前输入的未发送的消息
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_conv.convSetDraft = c_Tim_convSetDraft;

--删除指定会话的草稿
--[[
	参数:										
	string 		conv_id							--会话的ID
	TIMConvType conv_type						--会话类型,详情请参考tim.conv.TIMConvType->[https://cloud.tencent.com/document/product/269/33553#timconvtype]
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_conv.convCancelDraft = c_Tim_convCancelDraft;

--发送新消息
--[[
	参数:										
	string 		conv_id							--会话的ID,特别注释1
	TIMConvType conv_type						--会话类型,详情请参考tim.conv.TIMConvType->[https://cloud.tencent.com/document/product/269/33553#timconvtype],
												  特别注释1
	string 		json_msg_param					--消息JOSN,详情参考tim.msg.Message->[https://cloud.tencent.com/document/product/269/33553#message],
												  特别注释2
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理

	注释1:发送新消息,单聊消息和群消息的发送均采用此接口.
		- 发送单聊消息时conv_id为对方的UserID,conv_type为kTIMConv_C2C.
		- 发送群聊消息时conv_id为群ID,conv_type为kTIMConv_Group.
	
	注释2:发送消息时不能发送kTIMElem_GroupTips,kTIMElem_GroupReport.他们由为后台下发,用于更新(通知)群的信息.可以的发送消息内元素.
		- 文本消息元素,请参考 tim.msg.TextElem->[https://cloud.tencent.com/document/product/269/33553#textelem]
		- 表情消息元素,请参考 tim.msg.FaceElem->[https://cloud.tencent.com/document/product/269/33553#faceelem]
		- 位置消息元素,请参考 tim.msg.LocationElem->[https://cloud.tencent.com/document/product/269/33553#locationelem]
		- 图片消息元素,请参考 tim.msg.ImageElem->[https://cloud.tencent.com/document/product/269/33553#imageelem]
		- 声音消息元素,请参考 tim.msg.SoundElem->[https://cloud.tencent.com/document/product/269/33553#soundelem]
		- 自定义消息元素,请参考 tim.msg.CustomElem->[https://cloud.tencent.com/document/product/269/33553#customelem]
		- 文件消息元素,请参考 tim.msg.FileElem->[https://cloud.tencent.com/document/product/269/33553#fileelem]
		- 视频消息元素,请参考 tim.msg.VideoElem->[https://cloud.tencent.com/document/product/269/33553#videoelem]
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_msg.msgSendNewMsg = c_Tim_msgSendNewMsg;

--消息上报已读
--[[
	参数:										
	string 		conv_id							--会话的ID
	TIMConvType conv_type						--会话类型,详情请参考tim.conv.TIMConvType->[https://cloud.tencent.com/document/product/269/33553#timconvtype]
	string 		json_msg_param					--消息JSON,详情参考tim.msg.Message->[https://cloud.tencent.com/document/product/269/33553#message],
												  特别注释1
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:json_msg_param可以填""空字符串.此时以会话当前最新消息的时间戳(如果会话存在最新消息)或当前时间为已读时间戳上报.当要指定消息时,
		则以该指定消息的时间戳为已读时间戳上报,最好用接收新消息获取的消息数组里面的消息 JSON 或者用消息定位符查找到的消息 JSON,避免重复构造消息JSON
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_msg.msgReportReaded = c_Tim_msgReportReaded;

--消息撤回
--[[
	参数:										
	string 		conv_id							--会话的ID
	TIMConvType conv_type						--会话类型,详情请参考tim.conv.TIMConvType->[https://cloud.tencent.com/document/product/269/33553#timconvtype]
	string 		json_msg_param					--消息JSON,详情参考tim.msg.Message->[https://cloud.tencent.com/document/product/269/33553#message],
												  特别注释1
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:使用保存的消息 JSON 或者用消息定位符查找到的消息 JSON，避免重复构造消息 JSON
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_msg.msgRevoke = c_Tim_msgRevoke;

--消息撤回
--[[
	参数:										
	string 		conv_id							--会话的ID
	TIMConvType conv_type						--会话类型,详情请参考tim.conv.TIMConvType->[https://cloud.tencent.com/document/product/269/33553#timconvtype]
	string 		json_msg_Locator_array			--消息定位符数组,详情请参考tim.msg.MsgLocator->[https://cloud.tencent.com/document/product/269/33553#msglocator]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:
		- 此接口根据消息定位符精准查找指定会话的消息,该功能一般用于消息撤回时查找指定消息等。
		- 一个消息定位符对应一条消息。
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_msg.msgFindByMsgLocatorList = c_Tim_msgFindByMsgLocatorList;

--导入消息列表到指定会话
--[[
	参数:										
	string 		conv_id							--会话的ID
	TIMConvType conv_type						--会话类型,详情请参考tim.conv.TIMConvType->[https://cloud.tencent.com/document/product/269/33553#timconvtype]
	string 		json_msg_array					--消息数组,详情参考tim.msg.Message->[https://cloud.tencent.com/document/product/269/33553#message]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:批量导入消息，可以自己构造消息去导入。也可以将之前要导入的消息数组 JSON 保存，然后导入的时候直接调用接口，避免构造消息数组
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_msg.msgImportMsgList = c_Tim_msgImportMsgList;

--保存自定义消息
--[[
	参数:										
	string 		conv_id							--会话的ID
	TIMConvType conv_type						--会话类型,详情请参考tim.conv.TIMConvType->[https://cloud.tencent.com/document/product/269/33553#timconvtype]
	string 		json_msg_param					--消息JSON,详情参考tim.msg.Message->[https://cloud.tencent.com/document/product/269/33553#message]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:消息保存接口,一般是自己构造一个消息 JSON 字符串,然后保存到指定会话
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_msg.msgSaveMsg = c_Tim_msgSaveMsg;

--获取指定会话的消息列表
--[[
	参数:										
	string 		conv_id							--会话的ID
	TIMConvType conv_type						--会话类型,详情请参考tim.conv.TIMConvType->[https://cloud.tencent.com/document/product/269/33553#timconvtype]
	string 		json_get_msg_param				--消息获取参数,详情请参考tim.msg.MsgGetMsgListParam->[https://cloud.tencent.com/document/product/269/33553#msggetmsglistparam]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:从kTIMMsgGetMsgListParamLastMsg指定的消息开始获取本地消息列表,kTIMMsgGetMsgListParamCount为要获取的消息数目。
		若指定kTIMMsgGetMsgListParamIsRamble为true则本地消息获取不够指定数目时,则会去获取云端漫游消息.kTIMMsgGetMsgListParamIsForward 
		指定向前获取还是向后获取
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_msg.msgGetMsgList = c_Tim_msgGetMsgList;

--删除指定会话的消息
--[[
	参数:										
	string 		conv_id							--会话的ID
	TIMConvType conv_type						--会话类型,详情请参考tim.conv.TIMConvType->[https://cloud.tencent.com/document/product/269/33553#timconvtype]
	string 		json_msgdel_param				--消息获取参数,详情请参考tim.msg.MsgDeleteParam->[https://cloud.tencent.com/document/product/269/33553#msgdeleteparam]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:
		- 当设置kTIMMsgDeleteParamMsg时,在会话中删除指定本地消息。
		- 当未设置kTIMMsgDeleteParamMsg时,kTIMMsgDeleteParamIsRamble为false表示删除会话所有本地消息,true表示删除会话所有漫游消息(删除漫游消息暂时不支持)
		- 一般直接使用保存的消息JSON,或者通过消息定位符查找得到的JSON.不用删除的时候构造消息JSON
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_msg.msgDelete = c_Tim_msgDelete;

--下载消息内元素到指定文件路径(图片、视频、音频、文件)
--[[
	参数:										
	string 		json_download_elem_param		--下载的参数 JSON 字符串,详情请参考tim.msg.DownloadElemParam->[https://cloud.tencent.com/document/product/269/33553#downloadelemparam]
	string 		path							--下载文件保存路径
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:json_download_elem_param内的参数皆可以在已收取到的消息JSON(Message)内找到
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_msg.msgDownloadElemToPath = c_Tim_msgDownloadElemToPath;

--群发消息
--[[
	参数:										
	string 		json_batch_send_param			--群发消息JSON字符串,详情请参考tim.msg.MsgBatchSendParam->[https://cloud.tencent.com/document/product/269/33553#msgbatchsendparam]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:批量发送消息的接口,每个 UserID 发送成功与否,通过回调tim.OnCommCallback返回
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_msg.msgBatchSend = c_Tim_msgBatchSend;

--创建群组
--[[
	参数:										
	string 		json_group_create_param			--创建群组的参数 JSON 字符串,详情请参考tim.Group.CreateGroupParam->[https://cloud.tencent.com/document/product/269/33553#creategroupparam]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:创建群组时可以指定群 ID,若未指定时IM通讯云服务器会生成一个唯一的ID,以便后续操作,群组ID通过(tim.OnCommCallback)回调返回。
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_group.groupCreate = c_Tim_groupCreate;

--删除(解散)群组
--[[
	参数:										
	string 		group_id						--要删除的群组 ID
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:权限说明：
		- 对于私有群,任何人都无法解散群组
		- 对于公开群,聊天室和直播大群，群主可以解散群组
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_group.groupDelete = c_Tim_groupDelete;

--申请加入群组
--[[
	参数:										
	string 		group_id						--要加入的群组 ID
	string		hello_msg						--申请理由
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:权限说明：
		- 私有群不能由用户主动申请入群
		- 公开群和聊天室可以主动申请进入(如果群组设置为需要审核,申请后管理员和群主会受到申请入群系统消息,需要等待管理员或者群主审核.
		  如果群主设置为任何人可加入,则直接入群成功.直播大群可以任意加入群组)
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_group.groupJoin = c_Tim_groupJoin;

--退出群组
--[[
	参数:										
	string 		group_id						--要退出的群组 ID
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:权限说明：
		- 对于私有群,全员可退出群组
		- 对于公开群,聊天室和直播大群,群主不能退出
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_group.groupQuit = c_Tim_groupQuit;

--邀请加入群组(此接口支持批量邀请成员加入群组)
--[[
	参数:										
	string 		json_group_invite_param			--邀请加入群组的 JSON 字符串,详情请查询tim.Group.GroupInviteMemberParam->[https://cloud.tencent.com/document/product/269/33553#groupinvitememberparam]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:权限说明：
		- 只有私有群可以拉用户入群
		- 公开群,聊天室邀请用户入群
		- 需要用户同意,直播大群不能邀请用户入群
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_group.groupInviteMember = c_Tim_groupInviteMember;

--删除群组成员(此接口支持批量删除群成员)
--[[
	参数:										
	string 		json_group_delete_param			--邀请加入群组的 JSON 字符串,详情请查询tim.Group.GroupDeleteMemberParam->[https://cloud.tencent.com/document/product/269/33553#groupdeletememberparam]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:权限说明：
		- 对于私有群,只有创建者可删除群组成员
		- 对于公开群和聊天室,只有管理员和群主可以踢人
		- 对于直播大群,不能踢人
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_group.groupDeleteMember = c_Tim_groupDeleteMember;

--获取已加入群组列表
--[[
	参数:										
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:权限说明：
		- 此接口可以获取自己所加入的群列表
		- 此接口只能获得加入的部分直播大群的列表
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_group.groupGetJoinedGroupList = c_Tim_groupGetJoinedGroupList;

--获取群组信息列表
--[[
	参数:
	string		json_group_getinfo_param		--获取群组信息列表参数的 JSON 字符串
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:
		- 此接口用于获取指定群 ID 列表的群详细信息
		- json_group_getinfo_param格式: ["群ID1","群ID2", ..., "群IDn"]
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_group.groupGetGroupInfoList = c_Tim_groupGetGroupInfoList;

--修改群信息
--[[
	参数:
	string		json_group_modifyinfo_param		--设置群信息参数的 JSON 字符串 JSON 字符串,详情请参考
												  tim.Group.GroupModifyInfoParam->[https://cloud.tencent.com/document/product/269/33553#groupmodifyinfoparam]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:权限说明：
		- 修改群主(群转让)的权限说明
			. 只有群主才有权限进行群转让操作
			. 直播大群不能进行群转让操作
		
		- 修改群其他信息的权限说明
			. 对于公开群、聊天室和直播大群，只有群主或者管理员可以修改群简介
			. 对于私有群，任何人可修改群简介
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_group.groupModifyGroupInfo = c_Tim_groupModifyGroupInfo;

--获取群成员信息列表
--[[
	参数:
	string		json_group_getmeminfos_param	--获取群成员信息列表参数的JSON字符串,详情参考
												  tim.Group.GroupMemberGetInfoOption->[https://cloud.tencent.com/document/product/269/33553#groupmembergetinfooption]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:权限说明：
		- 任何群组类型都可以获取成员列表
		- 直播大群只能拉取部分成员列表:包括群主,管理员和部分成员
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_group.groupGetMemberInfoList = c_Tim_groupGetMemberInfoList;

--修改群成员信息
--[[
	参数:
	string		json_group_modifymeminfo_param	--设置群信息参数的 JSON 字符串,详情参考
												  tim.Group.GroupModifyMemberInfoParam->[https://cloud.tencent.com/document/product/269/33553#groupmodifymemberinfoparam]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:权限说明：
		- 只有群主或者管理员可以进行对群成员的身份进行修改
		- 直播大群不支持修改用户群内身份
		- 只有群主或者管理员可以进行对群成员进行禁言
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_group.groupModifyMemberInfo = c_Tim_groupModifyMemberInfo;

--获取群未决信息列表群未决信息是指还没有处理的操作,例如,邀请加群或者请求加群操作还没有被处理,称之为群未决信息
--[[
	参数:
	string		json_group_getpendence_list_param	--设置群未决信息参数的 JSON 字符串,详情参考
													  tim.Group.GroupPendencyOption->[https://cloud.tencent.com/document/product/269/33553#grouppendencyoption]
	string 		user_data							--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:
		- 此处的群未决消息泛指所有需要审批的群相关的操作.例如:加群待审批,拉人入群待审批等等.即便审核通过或者拒绝后,该条信息也可通过
		  此接口拉回,拉回的信息中有已决标志
		
		- UserA 申请加入群 GroupA,则群管理员可获取此未决相关信息,UserA 因为没有审批权限,不需要获取此未决信息
		- 如果 AdminA 拉 UserA 进去 GroupA,则 UserA 可以拉取此未决相关信息,因为该未决信息待 UserA 审批
		- 权限说明:只有审批人有权限拉取相关未决信息
		- kTIMGroupPendencyOptionStartTime设置拉取时间戳,第一次请求填0,后边根据 server 返回的 
		  GroupPendencyResult 键kTIMGroupPendencyResultNextStartTime指定的时间戳进行填写。
		
		- kTIMGroupPendencyOptionMaxLimited拉取的建议数量,server 可根据需要返回或多或少,不能作为完成与否的标志。
	
	返回值:
	tim.sdk.TIMResult								--是否调用成功
]]
local_group.groupGetPendencyList = c_Tim_groupGetPendencyList;

--上报群未决信息已读
--[[
	参数:
	uint64		time_stamp					--已读时间戳(单位秒)
	string 		user_data					--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:时间戳 time_stamp 以前的群未决请求都将置为已读.上报已读后,仍然可以拉取到这些未决信息,但可通过对已读时戳的判断判定未决信息是否已读

	
	返回值:
	tim.sdk.TIMResult						--是否调用成功
]]
local_group.groupReportPendencyReaded = c_Tim_groupReportPendencyReaded;

--处理群未决信息
--[[
	参数:
	string		json_group_handle_pendency_param	--处理群未决信息参数的 JSON 字符串,详情请参考
													  tim.Group.GroupHandlePendencyParam->[https://cloud.tencent.com/document/product/269/33553#grouphandlependencyparam]
	string 		user_data							--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:
		- 已处理成功过的未决信息不能再次处理
		- 处理未决信息时需要带一个未决信息tim.Group.GroupPendency->[https://cloud.tencent.com/document/product/269/33553#grouppendency],
		  可以在接口 TIMGroupGetPendencyList 返回的未决信息列表将未决信息保存下来,在处理未决信息的时候将 GroupPendency 
		  传入键kTIMGroupHandlePendencyParamPendency

	
	返回值:
	tim.sdk.TIMResult								--是否调用成功
]]
local_group.groupHandlePendency = c_Tim_groupHandlePendency;

--获取指定用户列表的个人资料
--[[
	参数:
	string		json_get_user_profile_list_param	--获取指定用户列表的用户资料接口参数的 JSON 字符串,详情请参考
													  tim.UserProfile.FriendShipGetProfileListParam->[https://cloud.tencent.com/document/product/269/33553#friendshipgetprofilelistparam]
	string 		user_data							--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:可以通过该接口获取任何人的个人资料，包括自己的个人资料

	
	返回值:
	tim.sdk.TIMResult								--是否调用成功
]]
local_user.profileGetUserProfileList = c_Tim_profileGetUserProfileList;

--修改自己的个人资料
--[[
	参数:
	string		json_modify_self_user_profile_param	--修改自己的资料接口参数的 JSON 字符串,详情请参考
													  tim.UserProfile.UserProfileItem->[https://cloud.tencent.com/document/product/269/33553#userprofileitem]
	string 		user_data							--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:可以通过该接口获取任何人的个人资料，包括自己的个人资料

	
	返回值:
	tim.sdk.TIMResult								--是否调用成功
]]
local_user.profileModifySelfUserProfile = c_Tim_profileModifySelfUserProfile;

--获取好友列表
--[[
	参数:
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:此接口通过(tim.OnCommCallback)回调返回所有好友资料 tim.UserProfile.FriendProfile->[https://cloud.tencent.com/document/product/269/33553#friendprofile]
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_friend.friendshipGetFriendProfileList = c_Tim_friendshipGetFriendProfileList;

--添加好友
--[[
	参数:
	string		json_add_friend_param			--添加好友接口参数的 JSON 字符串,详情请参考
												  tim.Friendship.FriendshipAddFriendParam->[https://cloud.tencent.com/document/product/269/33553#friendshipaddfriendparam]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:好友关系有单向和双向好友之分,详情请参考"添加好友"->[https://cloud.tencent.com/document/product/269/1501#.E6.B7.BB.E5.8A.A0.E5.A5.BD.E5.8F.8B]
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_friend.friendshipAddFriend = c_Tim_friendshipAddFriend;

--处理好友请求
--[[
	参数:
	string		json_handle_friend_add_param	--处理好友请求接口参数的 JSON 字符串,详情请参考tim.Friendship.FriendRespone
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:当自己的个人资料的加好友权限kTIMUserProfileAddPermission设置为kTIMProfileAddPermission_NeedConfirm时,
		  别人添加自己为好友时会收到一个加好友的请求，可通过此接口处理加好友的请求
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_friend.friendshipHandleFriendAddRequest = c_Tim_friendshipHandleFriendAddRequest;

--更新好友资料(备注等)
--[[
	参数:
	string		json_modify_friend_info_param	--更新好友资料接口参数的 JSON 字符串,详情请参考
												  tim.Friendship.FriendProfileItem->[https://cloud.tencent.com/document/product/269/33553#friendprofileitem]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_friend.friendshipModifyFriendProfile = c_Tim_friendshipModifyFriendProfile;

--删除好友
--[[
	参数:
	string		json_delete_friend_param		--删除好友接口参数的 JSON 字符串,详情请参考tim.Friendship.FriendshipDeleteFriendParam
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:删除好友也有删除单向好友还是双向好友之分,详情请参考"删除好友"->[https://cloud.tencent.com/document/product/269/1501#.E5.88.A0.E9.99.A4.E5.A5.BD.E5.8F.8B]
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_friend.friendshipDeleteFriend = c_Tim_friendshipDeleteFriend;

--检测好友类型(单向的还是双向的)
--[[
	参数:
	string		json_check_friend_list_param	--检测好友接口参数的 JSON 字符串,详情请查询tim.Friendship.FriendshipCheckFriendTypeParam
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:开发者可以通过此接口检测指定UserID列表跟当前帐户的好友关系,详情请参考"检测好友"->[https://cloud.tencent.com/document/product/269/1501#.E6.A0.A1.E9.AA.8C.E5.A5.BD.E5.8F.8B]
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_friend.friendshipCheckFriendType = c_Tim_friendshipCheckFriendType;

--创建好友分组
--[[
	参数:
	string		json_create_friend_group_param	--创建好友分组接口参数的 JSON 字符串,详情请查询tim.Friendship.FriendGroupInfo
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	注释1:不能创建已存在的分组
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_friend.friendshipCreateFriendGroup = c_Tim_friendshipCreateFriendGroup;

--获取指定好友分组的分组信息
--[[
	参数:
	string		json_get_friend_group_list_param	--获取好友分组信息接口参数的 JSON 字符串->["分组ID1","分组ID2","分组ID3",.."分组IDn"]
	string 		user_data							--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	返回值:
	tim.sdk.TIMResult								--是否调用成功
]]
local_friend.friendshipGetFriendGroupList = c_Tim_friendshipGetFriendGroupList;

--修改好友分组
--[[
	参数:
	string		json_modify_friend_group_param	--修改好友分组接口参数的 JSON 字符串,详情请查询tim.Friendship.FriendshipModifyFriendGroupParam
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_friend.friendshipModifyFriendGroup = c_Tim_friendshipModifyFriendGroup;

--删除好友分组
--[[
	参数:
	string		json_delete_friend_group_param	--删除好友分组接口参数的 JSON 字符串->["分组ID1","分组ID2","分组ID3",.."分组IDn"]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_friend.friendshipDeleteFriendGroup = c_Tim_friendshipDeleteFriendGroup;

--添加指定用户到黑名单
--[[
	参数:
	string		json_add_to_blacklist_param		--添加指定用户到黑名单接口参数的 JSON 字符串->["用户ID1","用户ID2","用户ID3",.."用户IDn"]
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_friend.friendshipAddToBlackList = c_Tim_friendshipAddToBlackList;

--获取黑名单列表
--[[
	参数:
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_friend.friendshipGetBlackList = c_Tim_friendshipGetBlackList;

--从黑名单中删除指定用户列表
--[[
	参数:
	string		json_delete_from_blacklist_param	--添加指定用户到黑名单接口参数的 JSON 字符串->["用户ID1","用户ID2","用户ID3",.."用户IDn"]
	string 		user_data							--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	返回值:
	tim.sdk.TIMResult								--是否调用成功
]]
local_friend.friendshipDeleteFromBlackList = c_Tim_friendshipDeleteFromBlackList;

--获取好友添加请求未决信息列表
--[[
	参数:
	string		json_get_pendency_list_param	--获取未决列表接口参数的 JSON 字符串,详情请查询tim.Friendship.FriendshipGetPendencyListParam
	string 		user_data						--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	返回值:
	tim.sdk.TIMResult							--是否调用成功
]]
local_friend.friendshipGetPendencyList = c_Tim_friendshipGetPendencyList;

--删除指定好友添加请求未决信息
--[[
	参数:
	string		json_delete_pendency_param	--删除指定未决信息接口参数的 JSON 字符串,详情请查询tim.Friendship.FriendshipDeletePendencyParam
	string 		user_data					--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	返回值:
	tim.sdk.TIMResult						--是否调用成功
]]
local_friend.friendshipDeletePendency = c_Tim_friendshipDeletePendency;

--上报好友添加请求未决信息已读
--[[
	参数:
	uint64_t	time_stamp			--上报未决信息已读时间戳
	string 		user_data			--用户自定义字符串(比如JSON),IM SDK 只负责传回给回调函数(tim.OnCommCallback),不做任何处理
	
	返回值:
	tim.sdk.TIMResult				--是否调用成功
]]
local_friend.friendshipReportPendencyReaded = c_Tim_friendshipReportPendencyReaded;



--注册外部回调对象
local local_eventHandler = nil;
tim.registerEventHandler = function(eventHandler)
	local_eventHandler = eventHandler;
end;


--[[///////////////////////////////////////////////////////////////////////////////]]
--回调函数

--[[
	接口通用回调的定义

	@param code			值为 ERR_SUCC 表示成功,其他值表示失败
	@param msg			错误描述字符串
	@param json_params	JSON 字符串,不同的接口,JSON 字符串不一样
	@param user_data	调用API的时候传递进去的JSON数据
]] 
tim.OnComm = function(--[[tim.sdk.TIMError]] code, --[[string]] desc, --[[string]] json_params, --[[string]] user_data)
	if (local_eventHandler ~= nil and local_eventHandler.OnTimComm ~= nil) then
		local_eventHandler.OnTimComm(code, desc, json_params, user_data);
	end
end;


--[[
	新消息回调

	@param json_msg_array	新消息数组,详情请参考
							TIMRecvNewMsgCallback->[https://cloud.tencent.com/document/product/269/33552#timrecvnewmsgcallback]
]] 
tim.OnRecvNewMsg = function(--[[string]] json_msg_array)
	if (local_eventHandler ~= nil and local_eventHandler.OnRecvNewMsg ~= nil) then
		local_eventHandler.OnRecvNewMsg(json_msg_array);
	end
end;

--[[
	消息已读回执回调

	@param json_msg_readed_receipt_array	消息已读回执数组,详情请参考
											TIMMsgReadedReceiptCallback->[https://cloud.tencent.com/document/product/269/33552#timmsgreadedreceiptcallback]
]] 
tim.OnMsgReadedReceipt = function(--[[string]] json_msg_readed_receipt_array)
	if (local_eventHandler ~= nil and local_eventHandler.OnMsgReadedReceipt ~= nil) then
		local_eventHandler.OnMsgReadedReceipt(json_msg_readed_receipt_array);
	end
end;

--[[
	接收的消息被撤回回调

	@param json_msg_locator_array	消息定位符数组,详情请参考
									TIMMsgRevokeCallback->[https://cloud.tencent.com/document/product/269/33552#timmsgrevokecallback]
]]
tim.OnMsgRevoke = function(--[[string]] json_msg_locator_array)
	if (local_eventHandler ~= nil and local_eventHandler.OnMsgRevoke ~= nil) then
		local_eventHandler.OnMsgRevoke(json_msg_locator_array);
	end
end;

--[[
	消息内元素相关文件上传进度回调

	@param json_msg 	新消息
	@param index 		上传Elem元素在json_msg消息的下标
	@param json_msg 	上传当前大小
	@param json_msg 	上传总大小
]]
tim.OnMsgElemUploadProgress = function(--[[string]] json_msg, --[[int]] index, --[[int]] cur_size, --[[int]] total_size)
	if (local_eventHandler ~= nil and local_eventHandler.OnMsgElemUploadProgress ~= nil) then
		local_eventHandler.OnMsgElemUploadProgress(json_msg, index, cur_size, total_size);
	end
end;

--[[
	群事件回调

	@param json_group_tip_array 群提示列表,详情请参考
								TIMGroupTipsEventCallback->[https://cloud.tencent.com/document/product/269/33552#timgrouptipseventcallback]
]]
tim.OnGroupTipsEvent = function(--[[string]] json_group_tip_array)
	if (local_eventHandler ~= nil and local_eventHandler.OnGroupTipsEvent ~= nil) then
		local_eventHandler.OnGroupTipsEvent(json_group_tip_array);
	end
end;

--[[
	会话事件回调

	@param conv_event		会话事件类型
	@param json_conv_array	会话信息列表,详情请参考
							TIMConvEventCallback->[https://cloud.tencent.com/document/product/269/33552#timconveventcallback]
]]
tim.OnConvEvent = function(--[[tim.Conv.TIMConvEvent]] conv_event, --[[string]] json_conv_array)
	if (local_eventHandler ~= nil and local_eventHandler.OnConvEvent ~= nil) then
		local_eventHandler.OnConvEvent(conv_event, json_conv_array);
	end
end;

--[[
	网络状态回调

	@param status		网络状态
	@param code			错误码
	@param desc			错误描述字符串
]]
tim.OnNetworkStatusListener = function(--[[tim.sdk.TIMNetworkStatus]] status, --[[tim.sdk.TIMError]] code, --[[string]] desc)
	if (local_eventHandler ~= nil and local_eventHandler.OnNetworkStatusListener ~= nil) then
		local_eventHandler.OnNetworkStatusListener(status, code, desc);
	end
end;

--被踢下线回调
tim.OnKickedOffline = function()
	if (local_eventHandler ~= nil and local_eventHandler.OnKickedOffline ~= nil) then
		local_eventHandler.OnKickedOffline();
	end
end;

--用户票据过期回调
tim.OnUserSigExpired = function()
	if (local_eventHandler ~= nil and local_eventHandler.OnUserSigExpired ~= nil) then
		local_eventHandler.OnUserSigExpired();
	end
end;

--[[
	添加好友的回调

	@param json_identifier_array	添加好友列表,详情请参考
									TIMOnAddFriendCallback->[https://cloud.tencent.com/document/product/269/33552#timonaddfriendcallback]
]]
tim.OnAddFriend = function(--[[string]] json_identifier_array)
	if (local_eventHandler ~= nil and local_eventHandler.OnAddFriend ~= nil) then
		local_eventHandler.OnAddFriend(json_identifier_array);
	end
end;

--[[
	删除好友的回调

	@param json_identifier_array	添加好友列表,详情请参考
									TIMOnAddFriendCallback->[https://cloud.tencent.com/document/product/269/33552#timonaddfriendcallback]
]]
tim.OnDeleteFriend = function(--[[string]] json_identifier_array)
	if (local_eventHandler ~= nil and local_eventHandler.OnDeleteFriend ~= nil) then
		local_eventHandler.OnDeleteFriend(json_identifier_array);
	end
end;

--[[
	更新好友资料的回调

	@param json_friend_profile_update_array	添加好友列表,详情请参考
											TIMUpdateFriendProfileCallback->[https://cloud.tencent.com/document/product/269/33552#timupdatefriendprofilecallback]
]]
tim.OnUpdateFriendProfile = function(--[[string]] json_friend_profile_update_array)
	if (local_eventHandler ~= nil and local_eventHandler.OnUpdateFriendProfile ~= nil) then
		local_eventHandler.OnUpdateFriendProfile(json_friend_profile_update_array);
	end
end;

--[[
	好友添加请求的回调

	@param json_friend_add_request_pendency_array 	好友添加请求未决信息列表,详情请参考
													TIMFriendAddRequestCallback->[https://cloud.tencent.com/document/product/269/33552#timfriendaddrequestcallback]
]]
tim.OnFriendAddRequest = function(--[[string]] json_friend_add_request_pendency_array)
	if (local_eventHandler ~= nil and local_eventHandler.OnFriendAddRequest ~= nil) then
		local_eventHandler.OnFriendAddRequest(json_friend_add_request_pendency_array);
	end
end;

--[[
	日志回调

	@param level	日志级别
	@param log 		日志
]]
tim.OnLog = function(--[[tim.sdk.TIMLogLevel]] level, --[[string]] log)
	if (local_eventHandler ~= nil and local_eventHandler.OnLog ~= nil) then
		local_eventHandler.OnLog(level, log);
	end
end;

--[[
	消息更新回调

	@param json_msg_array 	更新的消息数组,详情请参考
							TIMMsgUpdateCallback->[https://cloud.tencent.com/document/product/269/33552#timmsgupdatecallback]
]]
tim.OnMsgUpdate = function(--[[string]] json_msg_array)
	if (local_eventHandler ~= nil and local_eventHandler.OnMsgUpdate ~= nil) then
		local_eventHandler.OnMsgUpdate(json_msg_array);
	end
end;