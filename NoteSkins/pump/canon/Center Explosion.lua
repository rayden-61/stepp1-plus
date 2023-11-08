return Def.ActorFrame {
	NOTESKIN:LoadActor(Var "Button", "Tap Note") .. {
		InitCommand=cmd(blend,"BlendMode_Add";playcommand,"Glow";SetAllStateDelays,.03);
		W1Command=cmd(playcommand,"Glow");
		W2Command=cmd(playcommand,"Glow");
		W3Command=cmd(playcommand,"Glow");
		W4Command=cmd();
		W5Command=cmd();
		HitMineCommand=cmd(playcommand,"Glow");
		HeldCommand=cmd(playcommand,"Glow");
		GlowCommand=cmd(setstate,0;finishtweening;diffusealpha,1.0;zoom,1.0;linear,0.15;diffusealpha,0.9;zoom,1.1;linear,0.15;diffusealpha,0.0;zoom,1.2);
	};
	LoadActor("GLOW 5x2")..{
		InitCommand=cmd(pause;setstate,2;zoom,1;blend,"BlendMode_Add";diffusealpha,0;playcommand,"Glow");
		W1Command=cmd(playcommand,"Glow");
		W2Command=cmd(playcommand,"Glow");
		W3Command=cmd(playcommand,"Glow");
		W4Command=cmd();
		W5Command=cmd();
		HitMineCommand=cmd(playcommand,"Glow");
		HeldCommand=cmd(playcommand,"Glow");
		GlowCommand=cmd(finishtweening;diffusealpha,1;zoom,.9;linear,0.2;zoom,1.15;diffusealpha,0);
	};
	LoadActor("_explosion")..{
		InitCommand=cmd(blend,"BlendMode_Add";pause;playcommand,"Frames";SetAllStateDelays,.06);
		W1Command=cmd(playcommand,"Frames");
		W2Command=cmd(playcommand,"Frames");
		W3Command=cmd(playcommand,"Frames");
		W4Command=cmd();
		W5Command=cmd();
		HitMineCommand=cmd(playcommand,"Frames");
		HeldCommand=cmd(playcommand,"Frames");
		
		FramesCommand=cmd(setstate,0;finishtweening;play;sleep,.36;queuecommand,'Pause');
		PauseCommand=cmd(setstate,5;pause);
	};
	
	Def.Quad {
		InitCommand=cmd(diffuse,1,1,1,0;zoomto,SCREEN_WIDTH*100,SCREEN_HEIGHT*100;zoomz,SCREEN_WIDTH*SCREEN_HEIGHT);
		HitMineCommand=cmd(finishtweening;diffusealpha,1;linear,0.3;diffusealpha,0);
	};
}