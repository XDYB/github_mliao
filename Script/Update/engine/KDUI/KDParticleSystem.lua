local kd = KDGame;

kd.ParticleSystem = kd.inherit(kd.Node);

function kd.ParticleSystem:constr(self, ...)
	
end

function kd.ParticleSystem:Ruin(self)
	
end

function kd.ParticleSystem:create(...--[[string plistFile]])
	local cnt = select("#", ...);
	if (cnt < 1) then
		return;
	end
	
	local plistFile = select(1, ...);
	self._object = kd.ParticleSystemCreate(plistFile);
end

function kd.ParticleSystem:Fire()
	if (self._object ~= nil) then
		kd.ParticleSystemFire(self._object);
	end
end

function kd.ParticleSystem:Stop()
	if (self._object ~= nil) then
		kd.ParticleSystemStop(self._object);
	end
end