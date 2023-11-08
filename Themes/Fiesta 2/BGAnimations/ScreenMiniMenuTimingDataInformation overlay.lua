local t = Def.ActorFrame {};

t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:x(15);
		self:y(20);
		self:horizalign(0);
		self:settext("Timing Menu");
	end;
	OnCommand=cmd(stoptweening;x,10;diffusealpha,.5;decelerate,.2;x,15;diffusealpha,1)
}

t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_BOTTOM-50);
		self:zoom(0.6);
		self:settext("Press (L)eft or (R)ight CTRL + Key (Number) in the edition screen\nto directly modify the parameter. For example L1 means \"Left CTRL + Key 1\"");
	end;
}

return t;