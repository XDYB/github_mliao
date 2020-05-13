KDGame = KDGame or {}

KDGame.M_PI = 3.14159265358979323846
KDGame.M_PI_2 = 1.57079632679489661923
KDGame.M_PI_4 = 0.785398163397448309616
KDGame.M_1_PI = 0.318309886183790671538
KDGame.M_2_PI = 0.636619772367581343076

KDGame.KD_SLIP_DIR_Y = 1	--Y轴滑动
KDGame.KD_SLIP_DIR_X = 2	--X轴滑动
KDGame.KD_SLIP_DIR_TWO_WAY = (KDGame.KD_SLIP_DIR_Y | KDGame.KD_SLIP_DIR_X)

--裁剪Y轴坐标转换
KDGame.MKCY = function(y)
	return KDGame.SceneSize.high + y;
end

--全局宏定义

--网络翻译模块类型
KDGame.NetModeType = {
	NET_MODE_PLAZA = 1,		--大厅网络翻译模块
	NET_MODE_GAME = 2,		--游戏网络翻译模块
};

--系统类型
KDGame.SystemType = {
	OS_WIN32 = 1,
	OS_ANDROID = 2,
	OS_IOS = 3,
	OS_ERROR = -1,
};

--动画播放模式
KDGame.AniPlayMode = {
	HGEANIM_NULL = 0,					--无
	HGEANIM_REV = 1,					--反向播放
	HGEANIM_PINGPONG = 2,				--乒乓播放模式
	HGEANIM_LOOP = 4					--循环播放
};

--文字对齐模式
KDGame.TextHAlignment = {
	LEFT = 0,							--左对齐
	CENTER = 1,							--中间
	RIGHT = 2							--右对齐
};

KDGame.InputMode = {
	ANY = 0, 							--用户可以输入任何文本,包括换行符。
	EMAIL_ADDRESS = 1, 					--允许用户输入一个电子邮件地址。
	NUMERIC = 2,						--允许用户输入一个整数值。
	PHONE_NUMBER = 3,					--允许用户输入一个电话号码。
	URL = 4,							--允许用户输入一个URL。
	DECIMAL = 5, 						--允许用户输入一个实数 通过允许一个小数点扩展了kEditBoxInputModeNumeric模式
	SINGLE_LINE = 6						--除了换行符以外，用户可以输入任何文本,
};

KDGame.InputFlag = {
	PASSWORD = 0, 						--表明输入的文本是保密的数据，任何时候都应该隐藏起来 它隐含了EDIT_BOX_INPUT_FLAG_SENSITIVE
	SENSITIVE = 1, 						--表明输入的文本是敏感数据， 它禁止存储到字典或表里面，也不能用来自动补全和提示用户输入。 一个信用卡号码就是一个敏感数据的例子。
	INITIAL_CAPS_WORD = 2, 				--这个标志的作用是设置一个提示,在文本编辑的时候，是否把每一个单词的首字母大写。
	INITIAL_CAPS_SENTENCE = 3, 			--这个标志的作用是设置一个提示,在文本编辑，是否每个句子的首字母大写。
	INITIAL_CAPS_ALL_CHARACTERS = 4 	--自动把输入的所有字符大写。
};

--IMM键盘的回车显示类型
KDGame.KeyboardReturnType = {
	DEFAULT = 0,						--默认
    DONE = 1,							--确定
    SEND = 2,							--发送
    SEARCH = 3,							--搜索
    GO = 4								--出发
};

--网络相关
--连接状态定义
KDGame.emSocketState = {
	SocketState_NoConnect = 0,			--没有连接
	SocketState_Connecting = 1,			--正在连接
	SocketState_Connected = 2,			--成功连接
};

--网络连接错误
KDGame.emNetworkError = {
	NETWORK_ERROR_NULL = 0,				--连接成功
	NETWORK_ERROR_UNREACHABLE = 1,		--没有网络
	NETWORK_ERROR_REFUSED = 2,			--服务器未响应
	NETWORK_ERROR_OTHER = 3,			--其他
};

--网络关闭类型
KDGame.emCloseSocketType = {
	CLOSE_TYPE_NULL = 0,				--NULL
	CLOSE_TYPE_DESTRUCTOR = 1,			--析构
	CLOSE_TYPE_CONNECT_CATCH = 2,		--连接抛出异常
	CLOSE_TYPE_CLIENT_CLOSE = 3,		--客户端主动关闭
	CLOSE_TYPE_CONNECT_ERROR = 4,		--连接服务器返回错误
	CLOSE_TYPE_REAV_ERROR = 5,			--读取数据或数据处理错误
	CLOSE_TYPE_NET_DETECT = 6,			--心跳检测
	CLOSE_TYPE_SERVER = 7,				--服务端主动关闭
};

--控件动作定义
KDGame.emActionType = {
	LAYER_ACTION_NULL = 0,				--NULL
	LAYER_ACTION_SLIDE = 1,				--滑动模式
	LAYER_ACTION_FADEOUT = 2,			--渐隐模式
	LAYER_ACTION_SCALE = 3,				--放缩模式
	LAYER_ACTION_ERROR = 4,				--错误
};

--httpFile 操作类型定义
KDGame.emHttpFileTaskType = {
	HTTP_FILE_DOWNLOAD = 0,				--下载文件
	HTTP_FILE_UPLOAD = 1,				--上传文件
	HTTP_FILE_ERROR = 2,				--错误
};


--全局table类型定义
KDGame.SYSTEMTIME = {
	Year = 0,							--年
	Month = 0,							--月
	DayOfWeek = 0,						--星期几
	Day = 0,							--日
	Hour = 0,							--时
	Minute = 0,							--分
	Second = 0,							--秒
	Milliseconds = 0					--毫秒
};


KDGame.tRect = {
	x = 0,
	y = 0,
	width = 0,
	height = 0,
};

--打开相册类型
KDGame.emOpenPhotoType =
{
	OPEN_PH_TYPE_IMAGE	= 1,
	OPEN_PH_TYPE_VIDEO	= 2,
	OPEN_PH_TYPE_ALL	= 3,
};