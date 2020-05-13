
local kd = KDGame;

--每个ID对应的url
kd.Aurl = 
{	

	Key = "6479C23EC38dec48f1c34d32420707CEB4FE923CDBD5585d09c25b4e71e948D5";

	["michat/get-captcha"]		= {"michat/get-captcha"},		-- 获取验证码
	["michat/phone-login"]		= {"michat/phone-login"},		-- 注册
	
	["michat/set-info"]		= {"michat/set-info"},		-- 登陆编辑资料
	["michat/edit-info"]	= {"michat/edit-info"},		-- 编辑资料
	
	--------------------------------------------------------------------
	["michat/get-mymenu"]		= {"michat/get-mymenu"},				-- 我的
	["michat/get-official"]		= {"michat/get-official"},				-- 查看官方认证
	["michat/set-official"]		= {"michat/set-official"},				-- 提交官方认证
	["michat/up-certification"]	= {"michat/up-certification"},			-- 上传实名认证
	["michat/get-certification"]= {"michat/get-certification"},			-- 查看实名认证
	["michat/get-hatelist"]		= {"michat/get-hatelist"},				-- 获取黑名单
	["michat/get-fanslist"]		= {"michat/get-fanslist"},				-- 获取粉丝列表
	["michat/get-lovelist"]		= {"michat/get-lovelist"},				-- 获取关注列表
	["michat/up-photo"]			= {"michat/up-photo"},					-- 上传照片
	["michat/search"]			= {"michat/search"},					-- 搜索用户
	["michat/destined"]			= {"michat/destined"},					-- 与你有缘
	["michat/hate"]				= {"michat/hate"},						-- 拉黑/取消拉黑
	["michat/love"]				= {"michat/love"},						-- 关注/取消关注
	["michat/is-hate"]			= {"michat/is-hate"},					-- 是否拉黑
	["michat/get-userinfolist"]	= {"michat/get-userinfolist"},			-- 批量用户详情
	--------------------------------------------------------------------

	------------------------ 咪一下 ------------------------
	["michat/get-matchsetup"]	= {"michat/get-matchsetup"},	-- 获取咪一下设置
	["michat/set-matchsetup"]	= {"michat/set-matchsetup"},	-- 修改咪一下设置
	["michat/get-mytags"]		= {"michat/get-mytags"},		-- 获取我的标签
	["michat/set-mytags"]		= {"michat/set-mytags"},		-- 设置我的标签
	["michat/get-tagslist"]		= {"michat/get-tagslist"},		-- 标签列表
	["michat/get-matchuser"] 	= {"michat/get-matchuser"},		-- 咪一下
	------------------------ 用户详情 ------------------------
	["michat/get-mydetail"]		= {"michat/get-mydetail"},		-- 获取 我的详情
	["michat/get-userdetail"]	= {"michat/get-userdetail"},	-- 获取 用户详情
	["michat/report"]			= {"michat/report"},			-- 举报
	----------------------------------------------------------------
	["michat/get-dynamiclist"]	= {"michat/get-dynamiclist"},	--	获取动态广场列表

	["michat/get-mydynamiclist"] = {"michat/get-mydynamiclist"},--	我的动态列表
	["michat/post-dynamic"]		 = {"michat/post-dynamic"},		--	发布动态
	["michat/delete-dynamic"]	 = {"michat/delete-dynamic"},	--	删除动态
	["michat/up-suggest"]		 = {"michat/up-suggest"},		-- 	意见反馈
	["michat/up-photo"]			 = {"michat/up-photo"},			--	上传图片
	["michat/up-dynamicimage"]   = {"michat/up-dynamicimage"}, 	--	上传动态照片
	["michat/up-dynamicvideo"]   = {"michat/up-dynamicvideo"},   --上传动态视频

	["michat/get-dynamicinfo"]	= {"michat/get-dynamicinfo"},	--	获取动态信息
	["michat/get-commentlist"]	= {"michat/get-commentlist"},	--	获取评论动态
	["michat/comment-dynamic"]	= {"michat/comment-dynamic"},	--	评论动态

	----------------------------------------------------------------
	["michat/recommend-list"]	 = {"michat/recommend-list"},	--	获取推荐列表
	["michat/up-face"]	= {"michat/up-face"},					--	上传头像
	["michat/like-dynamic"]		 = {"michat/like-dynamic"},		--	点赞/取消点赞动态
	["michat/report-dynamic"]	 = {"michat/report-dynamic"},	--	举报动态
}
	

local id = 1
for k,v in pairs(kd.Aurl) do
	if type(v)=="table" then
		v.id = id
		id = id + 1
	end
end

