return Def.ActorFrame {
	LoadActor("DownLeft frame")..{
		InitCommand=cmd(diffusealpha,0);
		PressCommand=cmd(finishtweening;diffusealpha,1;zoom,1;linear,0.2;diffusealpha,0;zoom,1.1);
	};
}