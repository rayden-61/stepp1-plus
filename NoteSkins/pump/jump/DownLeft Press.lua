return Def.ActorFrame {
	LoadActor("GLOW 5x1")..{
		InitCommand=cmd(pause;setstate,0;zoom,1;diffusealpha,0);
		PressCommand=cmd(finishtweening;diffusealpha,1;zoom,0.9;linear,0.2;diffusealpha,0;zoom,1.1);
	};
}