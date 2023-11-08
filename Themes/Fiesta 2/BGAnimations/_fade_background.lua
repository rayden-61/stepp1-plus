local t = Def.ActorFrame {};

t[#t+1] = Def.Quad {
	InitCommand=cmd(Center;scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,.96);
};

return t;

