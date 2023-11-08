return Def.ActorFrame {
	NOTESKIN:LoadActor(Var "Button", "Tap Note") .. {
		InitCommand=cmd(blend,"BlendMode_Add";SetAllStateDelays,.03;playcommand,"Bright";);
		BrightCommand=cmd(finishtweening;diffusealpha,1.0;zoom,1.0;linear,0.15;diffusealpha,0.9;zoom,1.1;linear,0.15;diffusealpha,0.0;zoom,1.2);
	};
	LoadActor("_Tap Explosion 4x2")..{
		InitCommand=cmd(blend,"BlendMode_Add";pause;SetAllStateDelays,.06;rotationz,90;playcommand,"Bright");
		BrightCommand=cmd(finishtweening;setstate,0;visible,true;play;sleep,.48;queuecommand,'Pause');
		PauseCommand=cmd(pause;setstate,7;visible,false);
	};
}