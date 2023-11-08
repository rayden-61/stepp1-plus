return Def.ActorFrame {
	OnCommand=function(self)
		self:sleep(1);
	end;
	Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,1);
		OnCommand=cmd(stoptweening;diffusealpha,0;linear,.8;diffusealpha,1);
	};
};