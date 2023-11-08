return Def.ActorFrame {
	LoadActor( THEME:GetPathG("","ScreenWarning/warning_"..GetLanguageText()..".png") )..{
		InitCommand=cmd(Center;show_background_properly);	
	};
	Def.Quad {
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,1;diffusealpha,1;linear,.2;diffusealpha,0);
		OffCommand=cmd(diffusealpha,0;linear,.2;diffusealpha,1);
	};
};