local t = Def.ActorFrame {};

t[#t+1] = LoadActor( BGDirB.."/Teaser" )..{
	InitCommand=cmd(Center;show_background_properly);	
	OnCommand=cmd(play);
};
	
t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,.9);
};

return t;