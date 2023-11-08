return Def.ActorFrame {
	NOTESKIN:LoadActor(Var "Button", "Tap Note") .. {
		InitCommand=cmd(blend,"BlendMode_Add";SetAllStateDelays,.06;playcommand,"Bright");
		BrightCommand=cmd(finishtweening;diffusealpha,1.0;zoom,1.0;linear,0.15;diffusealpha,0.9;zoom,1.1;linear,0.15;diffusealpha,0.0;zoom,1.2);
	};
	LoadActor("GLOW 5x2")..{
		InitCommand=cmd(pause;setstate,2;zoom,1;blend,"BlendMode_Add";diffusealpha,0;playcommand,"Bright");
		BrightCommand=cmd(finishtweening;diffusealpha,1;zoom,.9;linear,0.2;zoom,1.15;diffusealpha,0);
	};
	LoadActor("_explosion")..{
		InitCommand=cmd(blend,"BlendMode_Add";pause;SetAllStateDelays,.06;playcommand,"Bright");
		BrightCommand=cmd(setstate,0;finishtweening;play;sleep,.36;queuecommand,'Pause');
		PauseCommand=cmd(setstate,5;pause);
	};
}