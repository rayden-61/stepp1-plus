return Def.ActorFrame {
	NOTESKIN:LoadActor(Var "Button", "Ready Receptor")..{
		InitCommand=cmd(pause;setstate,2;blend,'BlendMode_Add';diffuse,0.85,0.75,0.3,0);
		PressCommand=cmd(stoptweening;diffusealpha,1;zoom,0.95;linear,0.2;zoom,1.1;diffusealpha,0);
	};
}