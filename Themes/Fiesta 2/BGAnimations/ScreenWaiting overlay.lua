local t = Def.ActorFrame {};

t[#t+1] = LoadActor( BGDirB.."/Teaser" )..{
	InitCommand=cmd(FullScreen);
	OnCommand=cmd(play);
	OffCommand=cmd(stoptweening;pause);
};

--[[
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenWaiting/COIN_TEXT") )..{
	InitCommand=cmd(x,SCREEN_LEFT+130;y,SCREEN_BOTTOM-60);	
	OnCommand=cmd(stoptweening;zoom,1;decelerate,.2;zoomx,1.02;decelerate,.2;zoom,1;queuecommand,'On');
	OffCommand=cmd(stoptweening);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenWaiting/COIN_TEXT") )..{
	InitCommand=cmd(x,SCREEN_LEFT+130;y,SCREEN_BOTTOM-60);	
	OnCommand=cmd(stoptweening;zoom,1;diffusealpha,0;linear,.1;diffusealpha,1;linear,.1;zoomx,1.25;diffusealpha,0;sleep,.2;queuecommand,'On');
	OffCommand=cmd(stoptweening);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenWaiting/COIN_TEXT") )..{
	InitCommand=cmd(x,SCREEN_RIGHT-130;y,SCREEN_BOTTOM-60);	
	OnCommand=cmd(stoptweening;zoom,1;decelerate,.2;zoomx,1.02;decelerate,.2;zoom,1;queuecommand,'On');
	OffCommand=cmd(stoptweening);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenWaiting/COIN_TEXT") )..{
	InitCommand=cmd(x,SCREEN_RIGHT-130;y,SCREEN_BOTTOM-60);		
	OnCommand=cmd(stoptweening;zoom,1;diffusealpha,0;linear,.1;diffusealpha,1;linear,.1;zoomx,1.25;diffusealpha,0;sleep,.2;queuecommand,'On');
	OffCommand=cmd(stoptweening);
};
]]--

--1st Player
t[#t+1] = SimplePlatPiu(110,SCREEN_HEIGHT-160)..{ OffCommand=cmd(visible,false); };

--2nd Player
t[#t+1] = SimplePlatPiu(SCREEN_WIDTH-110,SCREEN_HEIGHT-160)..{ OffCommand=cmd(visible,false); };

return t;
