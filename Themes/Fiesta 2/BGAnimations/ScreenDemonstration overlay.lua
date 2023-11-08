return Def.ActorFrame {
	LoadActor( THEME:GetPathB("ScreenGamePlay","overlay") );
	LoadActor( THEME:GetPathG("","ScreenDemonstration/DemoPlay text") )..{
		InitCommand=cmd(x,SCREEN_CENTER_X-214;y,SCREEN_BOTTOM-17;basezoom,.60;zoom,.89);
	};
	LoadActor( THEME:GetPathG("","ScreenDemonstration/DemoPlay text") )..{
		InitCommand=cmd(x,SCREEN_CENTER_X+214;y,SCREEN_BOTTOM-17;basezoom,.60;zoom,.89);
	};
};