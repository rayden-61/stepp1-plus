local t = Def.ActorFrame {}

t[#t+1] = LoadActor( BGDirB.."/OPENING" )..{
	InitCommand=cmd(Center;show_background_properly;loop,false);	
	OnCommand=cmd(play);
};

t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,0);
	OffCommand=cmd(stoptweening;diffusealpha,0;linear,.3;diffusealpha,1);
};

return t
