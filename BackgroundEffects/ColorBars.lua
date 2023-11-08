local Color1 = color(Var "Color1");
local Color2 = color(Var "Color2");

local t = Def.ActorFrame {
	LoadActor(Var "File1") .. {
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;scale_or_crop_background;effectclock,"music";loop,true);
		GainFocusCommand=cmd(play);
		LoseFocusCommand=cmd(pause);
	};

	LoadActor(Var "File2") .. {
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;scaletofit,0,0,SCREEN_WIDTH,SCREEN_HEIGHT;effectclock,"music";loop,false);
		GainFocusCommand=cmd(play);
		LoseFocusCommand=cmd(pause);
	};
};

return t;
