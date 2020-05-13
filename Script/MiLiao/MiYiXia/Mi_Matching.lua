--[[

咪一下 -- 匹配动效

--]]
local kd = KDGame;
local gDef = gDef;
local gSink = A_ViewManager;

Mi_Matching = kd.inherit(kd.Layer);
local impl = Mi_Matching;

local ScreenW,ScreenH = kd.SceneSize.width,kd.SceneSize.high;

function impl:init()
	self.mazeAni = kd.class(kd.AniMultipleImg,self,1,30);
	self:addChild(self.mazeAni);
	self.mazeAni:SetMode(0);
	for i=0,99 do
		local str = "ResAll/ML_DongXiao_LM/ML_PiPei_LM/"..i..".png";
		local spr = kd.class(kd.Sprite, str);
		self.mazeAni:InstFrameSpr(spr);
	end
	
	self.mazeAni:SetPos(ScreenW/2, ScreenH/2);
	
	DC:RegisterCallBack("Mi_Matching.Show",self,function (bo)
		self:SetVisible(bo);
		if bo then
			self.mazeAni:Play();
		else
			self.mazeAni:Stop();
		end
	end)
end