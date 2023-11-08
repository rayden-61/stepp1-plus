local t = Def.ActorFrame {};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenLogo/_NDA_IRO") )..{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+1;diffusealpha,0;sleep,3.60;linear,.2;diffusealpha,1)
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenLogo/LASH") )..{
	InitCommand=cmd(x,SCREEN_CENTER_X-145;y,SCREEN_CENTER_Y+23;diffusealpha,0;sleep,4.4;linear,.4;diffusealpha,1)
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenLogo/A") )..{
	InitCommand=cmd(x,SCREEN_CENTER_X-100;y,SCREEN_CENTER_Y);
	OnCommand=cmd(diffusealpha,0;linear,2;diffusealpha,1;sleep,1;linear,.8;zoom,0.265;x,SCREEN_CENTER_X-144)
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenLogo/M") )..{
	InitCommand=cmd(x,SCREEN_CENTER_X+80;y,SCREEN_CENTER_Y);
	OnCommand=cmd(diffusealpha,0;linear,2;diffusealpha,1;sleep,1;linear,.8;zoom,0.265;x,SCREEN_CENTER_X+34)
}

return t;