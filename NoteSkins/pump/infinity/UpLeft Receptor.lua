return Def.ActorFrame {
	NOTESKIN:LoadActor(Var "Button", "Ready Receptor")..{
		Name="Base";
		Frames = { { Frame = 0 } };
		OnCommand=cmd(diffuse,0.95,0.95,0.95,1);
	};
	NOTESKIN:LoadActor(Var "Button", "Tap Note")..{
		Name="Base";
		InitCommand=cmd(pause;setstate,1;blend,"BlendMode_Add";effectclock,"beat";diffuseramp;effectcolor1,color("1,1,1,0");effectcolor2,color("1,1,1,.5");effecttiming,.2,0,.8,0);
	};
}