return Def.ActorFrame {
	LoadActor("GLOW 5x2")..{
		InitCommand=cmd(pause;setstate,9;zoom,1;diffusealpha,0);
		PressCommand=cmd(finishtweening;diffusealpha,1;zoom,0.9;linear,0.2;diffusealpha,0;zoom,1.2);
	};
}