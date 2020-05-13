local kd = KDGame;
local gDef = gDef;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;

local gSink = A_ViewManager;

PlayPhotoItem = kd.inherit(kd.Layer);

function PlayPhotoItem:init(nIndex,url)			--创建子项传递图片的地址
	self.m_nIndex = nIndex;
	self.m_szUrl = url;
	
	-- 裁剪GUI
	self.clipGui = kd.class(kd.GuiObjectNew, self, 1, 0,0,ScreenW,ScreenH, false, false);
	self.clipGui:setRectClipping(0,0,ScreenW,ScreenH);
	self:addChild(self.clipGui)
	
	
	--画封面
	if url then 
		self.m_cover = kd.class(kd.AsyncSprite,gDef.domain..url);
		self.m_cover:SetPos(ScreenW/2,ScreenH/2);
		self.clipGui:addChild(self.m_cover);
		self.m_cover.OnLoadTextrue = function(this, --[[int]] err_code --[[0:成功]], --[[string]] err_info)
			local w,h = this:GetTexWH();
			local sc = math.min(ScreenW/w,ScreenH/h);
			local sc1 = tonumber(string.format("%.2f",sc));
			if sc1>sc then sc1 =sc1 - 0.01;end 
			self.m_cover:SetScale(sc1,sc1);
		end
	end
end

function PlayPhotoItem:Clear()
	
end

