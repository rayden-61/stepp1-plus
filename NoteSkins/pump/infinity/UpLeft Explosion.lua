return Def.ActorFrame {
	LoadActor("_Tap Explosion Bright") .. {
		Frames = Sprite.LinearFrames( 5, 0.28);
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0;zoom,0.975);
		PressCommand=cmd(playcommand,"Bright");
		BrightCommand=cmd(stoptweening;setstate,0;diffusealpha,1;sleep,0.28;diffusealpha,0);
	};
	NOTESKIN:LoadActor(Var "Button", "Tap Note") .. {
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0);
		PressCommand=cmd(playcommand,"Bright");
		BrightCommand=cmd(stoptweening;diffusealpha,1;zoom,1;linear,0.2;zoom,1.075;linear,0.1;diffusealpha,0);
	};
	NOTESKIN:LoadActor(Var "Button", "Tap Note") .. {
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0);
		PressCommand=cmd(playcommand,"Bright");
		BrightCommand=cmd(stoptweening;;diffusealpha,0;sleep,0.075;diffusealpha,1;zoom,1;linear,0.2;zoom,1.075;linear,0.1;diffusealpha,0);
	};	
	NOTESKIN:LoadActor(Var "Button", "Ready Receptor") .. {
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0;animate,false;setstate,2);
		PressCommand=cmd(playcommand,"Bright");
		BrightCommand=cmd(stoptweening;diffusealpha,1;zoom,0.975;linear,0.2;zoom,1.1;linear,0.05;diffusealpha,0);
	};
	NOTESKIN:LoadActor(Var "Button", "Ready Receptor") .. {
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0;animate,false;setstate,2);
		PressCommand=cmd(playcommand,"Bright");
		BrightCommand=cmd(stoptweening;diffusealpha,1;zoom,0.975;linear,0.2;zoom,1.1;linear,0.05;diffusealpha,0);
	};
}