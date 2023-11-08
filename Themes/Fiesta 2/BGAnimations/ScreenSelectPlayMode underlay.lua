local t = Def.ActorFrame {}

t[#t+1] = SimplePlatPiu(SCREEN_CENTER_X,SCREEN_CENTER_Y+30)..{
	OnCommand=cmd(stoptweening;visible,false);
	ShowPlatCommand=cmd(stoptweening;visible,true);
	HidePlatCommand=cmd(stoptweening;visible,false);
	OffCommand=cmd(stoptweening;zoom,0);
}

t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,1;diffusealpha,0);
	OffCommand=cmd(stoptweening;linear,1.2;diffusealpha,1);
};

return t;