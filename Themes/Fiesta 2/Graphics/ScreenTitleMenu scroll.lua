local gc = Var("GameCommand");

return Def.ActorFrame {
	Def.Quad{
		InitCommand=cmd(zoomto,256,26;fadeleft,0.45;faderight,0.45);
		OnCommand=cmd(diffuseshift;effectcolor1,color("0,0,0,0.5");effectcolor2,color("0,0,0,0.5"));
		GainFocusCommand=cmd(stoptweening;decelerate,0.1;zoomto,256,26;diffusealpha,1);
		LoseFocusCommand=cmd(stoptweening;accelerate,0.1;zoomto,SCREEN_WIDTH,0;diffusealpha,0);
		OffCommand=cmd(visible,false);
	};
	LoadFont("Common Bold") .. {
		Text=THEME:GetString("ScreenTitleMenu",gc:GetText());
		InitCommand=cmd(shadowlength,0;y,-2;skewx,-.12;zoom,.75);
		GainFocusCommand=cmd(stoptweening;linear,0.1;zoom,.9;diffuse,0,1,1,1);
		LoseFocusCommand=cmd(stoptweening;linear,0.1;zoom,.75;diffuse,1,1,1,1);
		OffCommand=cmd(visible,false);
	};
};