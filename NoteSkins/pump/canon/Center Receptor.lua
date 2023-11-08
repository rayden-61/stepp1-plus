return Def.ActorFrame {
	LoadActor("BASE 1x2")..{
		InitCommand=cmd(pause;setstate,0);
	};
	LoadActor("BASE 1x2")..{
		Name="Glowpart";
		InitCommand=cmd(pause;setstate,1;blend,"BlendMode_Add";effectclock,"beat";diffuseramp;effectcolor1,color("1,1,1,0");effectcolor2,color("1,1,1,.6");effecttiming,.2,0,.8,0;effectoffset,.05);
	};
}