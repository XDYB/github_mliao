local kd = KDGame
local math = math
local gDef = gDef;
local fontSize = 50;
local ScreenW = kd.SceneSize.width;
local ScreenH = kd.SceneSize.high;
local heightUnit = 80;
local rotUnit = 20;
local height = 450
Picker = kd.inherit(kd.Layer);--主界面
function Picker:init(array,totalIndex,currentIndex,ontouchbeginy)
       self.area = self:GetScrollAreaByIndex(totalIndex,currentIndex,ontouchbeginy); --响应区域
   self.maxy = ScreenH/2+height/2;
   self.miny = ScreenH/2-height/2;
   self:__init(array);
end
function Picker:__init(array)
       self.time = 1;                        -- 动画时间
       self.sensitivity = 0.2;        -- 灵敏度 越大越容易产生惯性
       self.array = self:ListToMap(array);
       self.index = 1;--当前索引值
       self.curY = 0;-- 当前位置
       self.auto = false;
       self.t = 0;
       self.isBack = true;
       self.hasCallback = true;
       
       self.outMax = 0;
       self.outMin = (#self.array-1) * heightUnit * -1;
       self.outDis = 100;--最大超出距离
       self.clock = 0; -- 计时器
       
   self.sprs = {};
   for i=1,#self.array do
       local spr = {};
       spr.o = kd.class(kd.StaticText,fontSize,self.array[i][2],kd.TextHAlignment.CENTER,ScreenW,0);
               self:addChild(spr.o);
               spr.o:SetColor(0xff333333);
               table.insert(self.sprs,spr);
               spr.o:SetPos(ScreenW/2,ScreenH/2+(i-1)*heightUnit);
   end
       self:updateRot(0);
       self:updatePos(0);
       self:updateVisible();
end


function Picker:ListToMap(list)
       local map = {};
       if(type(list[1])=="table") then
               map = list;
       else
               for i,v in pairs(list) do
                       map[i] = {v,v};
               end
       end
       return map;
end




function Picker:onTouchBegan(--[[float]] x, --[[float]] y)


       if x>=self.area[1] and x<=self.area[2] and y>=self.area[3] and y<=self.area[4] then
               self.clock = 0; -- 复位计时器
               self.touchBeginY = y;
               self.touchLastY = y;
               self._startTime = self.clock;
               self.auto = false;
               self.beginY = self.beginY or self.curY;
               self.t = 0;
               self.isBack = true;
               self.hasCallback = true;
       return true;
   end
   return false;
end


function Picker:onTouchMoved(--[[float]] x, --[[float]] y)
       local diffy = y - self.touchLastY;
       if self.forward then
               if diffy*self.forward < 0 then
                       -- 改变方向 重新记录时间和点击起点
                       self.touchBeginY = y;
                       self._startTime = self.clock;
               end
       end
       local offset = self.curY + diffy;
       self:updatePos(offset)        ;
       self:updateRot(offset);
       self:updateVisible();
       self.curY = offset;
       self.beginY = offset;
       self.touchLastY = y;
       self.diffStamp = self.clock - self._startTime;
       self.diffDistance = diffy;
       self.forward = diffy > 0 and 1 or -1;
end


function Picker:onTouchEnded(--[[float]] x, --[[float]] y)


       local diffDistance = y - self.touchBeginY;
       local diffStamp = self.clock - self._startTime;
       self.beginY = self.curY;


       if diffStamp < self.sensitivity then
       -- 有惯性   
               if diffStamp<self.sensitivity/2 then
                       diffStamp = self.sensitivity/2;  --极限惯性
               end
               -- 自动滚动的距离
               local dis = (diffDistance / diffStamp);
               self.targetY = self:Rounding(self.curY + dis);
               self.dis = self.targetY - self.curY;
               self.auto = true;
               self.time = 1.5
       else
       -- 无惯性=>复位                
               self.targetY = self:Rounding(self.curY);
               self.dis = self.targetY - self.curY;
               self.auto = true;
               self.time = 0.4
       end
       
end


-- 目标距离四舍五入
function Picker:Rounding(number)
       local target = number;
       if number % heightUnit > 0 then
               local yu = number % heightUnit; --余数
               if yu >= heightUnit/2 then
                       -- 超过一半=>下一行
                       target = (math.floor(number / heightUnit)+1)*heightUnit;
               else
                       -- 回到上一行
                       target = math.floor(number / heightUnit)*heightUnit;
               end
       end        
       if target > self.outMax then target = self.outMax+self.outDis*2 end
       if target < self.outMin then target = self.outMin-self.outDis*2 end
       return target;
end


-- 根据位移计算下标
function Picker:CalIndex()
       self.index = math.floor(math.abs(self.curY / heightUnit) + 0.5)+1;
end


function Picker:update(delta)
       if self.auto then
               if self.t<=self.time then
                       self.curY = self:swing(self.t,self.beginY,self.dis,self.time);
                       if self.isBack and  self.curY>=self.outMax+self.outDis*0.6 then
                               self.time = 0.4
                               self.beginY = self.outMax+self.outDis
                               self.targetY = self.outMax;
                               self.isBack = false;
                               self.dis = - self.outDis;
                               self.t = 0;
                               
                       elseif self.isBack and self.curY<=self.outMin-self.outDis*0.6 then
                               self.time = 0.4
                               self.beginY = self.outMin-self.outDis
                               self.targetY = self.outMin;
                               self.isBack = false;
                               self.dis = self.outDis;
                               self.t = 0;


                       end
                       self:updatePos(self.curY);
                       self:updateRot(self.curY);
                       self:updateVisible();
                       self:CalIndex();
                       self.t = self.t + delta;
                       
                       
                       if self.hasCallback and math.abs(self.curY - self.targetY) < heightUnit/4 then
                               --回调
                               if self.OnScrollCallBack then
                                  self:OnScrollCallBack();
                               end
                               self.hasCallback = false;
                       end
               else


                       self:updatePos(self.targetY);        
                       self:updateRot(self.targetY);
                       self:updateVisible();
                       
                       self.auto = false;
                       self.t = 0;
                       self.curY = self.targetY;
                       self:CalIndex();
               end
       end
       self.clock = self.clock + delta;
end


function Picker:updatePos(diffy)        
       for i,v in ipairs(self.sprs) do
               local x,y = v.o:GetPos()
               v.o:SetPos(x,diffy+ScreenH/2+(i-1)*heightUnit);
       end
end


function Picker:updateRot(offset)
       local diffRot = rotUnit * offset / heightUnit;
       
       for i,v in ipairs(self.sprs) do
               local x,y,z = v.o:GetRotation3D();
               v.o:SetRotation3D((i-1)*rotUnit + diffRot-rotUnit ,y,z);
       end
end


function Picker:updateVisible()
       for i,v in ipairs(self.sprs) do
               local _,y = v.o:GetPos();
               if y>=self.miny and y<=self.maxy then
                       v.o:SetVisible(true);
               else
                       v.o:SetVisible(false);
               end
       end
end


function Picker:swing(t,b,c,d)        
   return   (t==d) and b+c or c * (- (2^(-10 * t/d)) + 1) + b  ;
end


--得到响应区域
-- height 可是区域高度
-- ontouchbeginy 响应中心y坐标
function Picker:GetScrollAreaByIndex(totalIndex,currentIndex,ontouchbeginy)
       local w = ScreenW / totalIndex ;--单元宽度
       local y1 = ontouchbeginy-height/2
       local y2 = ontouchbeginy+height/2
       local areas = {
       [1] = {
                       {0,w,y1,y2}
               },
       [2] = {
                       {0,w,y1,y2},
                       {w,ScreenW,y1,y2}
               },
       [3] = {
                       {0,w,y1,y2},
                       {w,2*w,y1,y2},
                       {2*w,ScreenW,y1,y2}
               },
               [4] = {
                       {0,w,y1,y2},
                       {w,2*w,y1,y2},
                       {2*w,3*w,y1,y2},
                       {3*w,ScreenW,y1,y2}
               },
   }
   return areas[totalIndex][currentIndex];
end


-- =====================================================================================
--                                        API
-- =====================================================================================


-- 获取 value
function Picker:GetValue()
       return self.array[self.index][1];
end


-- 获取 Text
function Picker:GetText()
       return self.array[self.index][2];
end


-- 重置 列表
function Picker:SetArray(array)
   self:ClearArray();
   self:__init(array);
end


--清空 列表
function Picker:ClearArray()
       for i=1,#self.array do
       self:RemoveChild(self.sprs[i].o);
               self.sprs[i].o = nil;
   end 
end


function Picker:SetText(text)
       for i,v in ipairs(self.array) do
               if v[2] == text then
                       self.index = i;
                       break;
               end
       end
       local offset = heightUnit * (self.index-1) * -1;
       self.curY = offset;
       self:updatePos(offset)        ;
       self:updateRot(offset);
       self:updateVisible();
end


function Picker:SetValue(value)
       for i,v in ipairs(self.array) do
               if v[1] == value then
                       self.index = i;
                       break;
               end
       end
       local offset = heightUnit * (self.index-1) * -1;
       self.curY = offset;
       self:updatePos(offset)        ;
       self:updateRot(offset);
       self:updateVisible();
end




function Picker:SetAsValue(value)
   local targetIndex = 1;
       for i,v in ipairs(self.array) do
               if v[1] == value then
                       targetIndex = i;
                       break;
               end
       end
   self:UpdateToIndex(targetIndex);  
end


function Picker:UpdateToIndex(targetIndex)
   local offset = heightUnit * (targetIndex-1) * -1;
   local dis = offset - self.curY;
   self.beginY = self.curY;
   self.targetY = offset;
   self.dis = self.targetY - self.curY;
   self.auto = true;
   self.time = 1
   
end

