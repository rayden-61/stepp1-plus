local t = Def.ActorFrame{}

t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectPlayModeBranch/BG.png"))..{
	OnCommand=cmd(show_background_properly);
}

t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectPlayModeBranch/boy.png"))..{
	OnCommand=cmd(basezoom,.67;y,SCREEN_CENTER_Y;x,-200;linear,.3;x,SCREEN_CENTER_X-314;linear,.1;x,SCREEN_CENTER_X-324);
}

t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectPlayModeBranch/girl.png"))..{
	OnCommand=cmd(basezoom,.67;y,SCREEN_CENTER_Y;x,SCREEN_WIDTH+200;linear,.3;x,SCREEN_CENTER_X+296;linear,.1;x,SCREEN_CENTER_X+306);
}

-- center
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectPlayModeBranch/text.png"))..{
	OnCommand=cmd(basezoom,.67;y,-100;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,0;sleep,.3;diffusealpha,1);
}

t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectPlayModeBranch/text.png"))..{
	InitCommand=cmd(blend,'BlendMode_Add');
	OnCommand=cmd(basezoom,.67;y,-100;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,0;sleep,.3+.1;diffusealpha,1;linear,.2;zoomx,1.1;diffusealpha,0);
}

-- arriba
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectPlayModeBranch/text.png"))..{
	InitCommand=cmd(blend,'BlendMode_Add');
	OnCommand=cmd(basezoom,.67;y,-100;x,SCREEN_CENTER_X;linear,.3;y,SCREEN_CENTER_Y;linear,.1;diffusealpha,0);
}

-- abajo
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectPlayModeBranch/text.png"))..{
	InitCommand=cmd(blend,'BlendMode_Add');
	OnCommand=cmd(basezoom,.67;y,SCREEN_HEIGHT+100;x,SCREEN_CENTER_X;linear,.3;y,SCREEN_CENTER_Y;linear,.1;diffusealpha,0);
}

-- izq
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectPlayModeBranch/text.png"))..{
	InitCommand=cmd(blend,'BlendMode_Add');
	OnCommand=cmd(basezoom,.67;y,SCREEN_CENTER_Y;x,-300;linear,.3;x,SCREEN_CENTER_X;linear,.1;diffusealpha,0);
}

-- der
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectPlayModeBranch/text.png"))..{
	InitCommand=cmd(blend,'BlendMode_Add');
	OnCommand=cmd(basezoom,.67;y,SCREEN_CENTER_Y;x,SCREEN_WIDTH+300;linear,.3;x,SCREEN_CENTER_X;linear,.1;diffusealpha,0);
}

return t;