return Def.ActorFrame {
	--note graphic

	
	
	
	
	--explosion
	LoadActor("_Tap Explosion Bright") .. {
		Frames = Sprite.LinearFrames( 5, 0.28);
		InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0;zoom,0.975);
		--NoneCommand=cmd(playcommand,"Glow");
		PressCommand=cmd(playcommand,"Glow");
		W1Command=cmd(playcommand,"Glow");
		W2Command=cmd(playcommand,"Glow");
		W3Command=cmd(playcommand,"Glow");
		W4Command=cmd();
		W5Command=cmd();
		HitMineCommand=cmd(playcommand,"Glow");
		HeldCommand=cmd(playcommand,"Glow");
		GlowCommand=cmd(stoptweening;setstate,0;diffusealpha,1;sleep,0.28;diffusealpha,0);
		
	};


	NOTESKIN:LoadActor(Var "Button", "Tap Note") .. {
		InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0);
		--NoneCommand=cmd(playcommand,"Glow");
		PressCommand=cmd(playcommand,"Glow");
		W1Command=cmd(playcommand,"Glow");
		W2Command=cmd(playcommand,"Glow");
		W3Command=cmd(playcommand,"Glow");
		W4Command=cmd();
		W5Command=cmd();
		HitMineCommand=cmd(playcommand,"Glow");
		HeldCommand=cmd(playcommand,"Glow");
		TapCommand=cmd(playcommand,"Glow");
		GlowCommand=cmd(stoptweening;diffusealpha,1;zoom,1;linear,0.2;zoom,1.075;linear,0.1;diffusealpha,0);
	};
	
	
		NOTESKIN:LoadActor(Var "Button", "Tap Note") .. {
		InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0);
		--NoneCommand=cmd(playcommand,"Glow");
		PressCommand=cmd(playcommand,"Glow");
		W1Command=cmd(playcommand,"Glow");
		W2Command=cmd(playcommand,"Glow");
		W3Command=cmd(playcommand,"Glow");
		W4Command=cmd();
		W5Command=cmd();
		HitMineCommand=cmd(playcommand,"Glow");
		HeldCommand=cmd(playcommand,"Glow");
		TapCommand=cmd(playcommand,"Glow");
		GlowCommand=cmd(stoptweening;;diffusealpha,0;sleep,0.075;diffusealpha,1;zoom,1;linear,0.2;zoom,1.075;linear,0.1;diffusealpha,0);
	};	



	

	NOTESKIN:LoadActor(Var "Button", "Hit") .. {
		InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0;animate,false;setstate,0);
		NoneCommand=cmd(playcommand,"Glow");
		PressCommand=cmd(playcommand,"Glow");
		W1Command=cmd(playcommand,"Glow");
		W2Command=cmd(playcommand,"Glow");
		W3Command=cmd(playcommand,"Glow");
		W4Command=cmd();
		W5Command=cmd();
		HitMineCommand=cmd(playcommand,"Glow");
		HeldCommand=cmd(playcommand,"Glow");
		GlowCommand=cmd(stoptweening;diffusealpha,1;zoom,0.99;linear,0.2;zoom,1.1;linear,0.05;diffusealpha,0);
	};



	
}