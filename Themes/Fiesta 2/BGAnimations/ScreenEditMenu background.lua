local t = Def.ActorFrame {};

t[#t+1] = LoadActor( BGDirB.."/USB_OUT" )..{
	InitCommand=cmd(stoptweening;Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT);
	OnCommand=cmd(play);
};

t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,.5);
};

return t;