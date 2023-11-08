return Def.ActorFrame {
	--Def.ControllerStateDisplay {
	--	InitCommand=cmd(LoadGameController,
	--};
	Def.DeviceList {
		Font="Common Normal",
		InitCommand=cmd(x,SCREEN_LEFT+90;y,SCREEN_TOP+80;zoom,0.8;halign,0);
	};

	Def.InputList {
		Font="Common Normal",
		InitCommand=cmd(x,SCREEN_LEFT+90;y,SCREEN_CENTER_Y;zoom,.6;halign,0;vertspacing,8);
	};
};
