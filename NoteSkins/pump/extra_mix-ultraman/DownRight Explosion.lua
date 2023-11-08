return Def.ActorFrame {
	NOTESKIN:LoadActorForNoteSkin(Var "Button", "Tap Note", "extra_mix") .. {
		OnCommand=cmd(blend,'BlendMode_Add');
		InitCommand=cmd(playcommand,"Bright";pause);
		BrightCommand=cmd(setstate,0;finishtweening;diffusealpha,1.0;zoom,1.0;linear,0.18;zoom,1.1;linear,.18;zoom,1;linear,.04;diffusealpha,0.0);
	};
	LoadActor("DownRight glow")..{
		InitCommand=cmd(playcommand,"Bright");
		BrightCommand=cmd(finishtweening;diffusealpha,1;zoom,1;rotationz,0;linear,.36;rotationz,369;linear,.04;diffusealpha,0;rotationz,410);
	};
}