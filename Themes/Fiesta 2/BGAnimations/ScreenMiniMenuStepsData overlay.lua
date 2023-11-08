local t = Def.ActorFrame {};

t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:x(15);
		self:y(20);
		self:horizalign(0);
		self:settext("Steps Data");
		--self:skewx(-.1);
	end;
	OnCommand=cmd(stoptweening;x,10;diffusealpha,.5;decelerate,.2;x,15;diffusealpha,1)
}

return t;