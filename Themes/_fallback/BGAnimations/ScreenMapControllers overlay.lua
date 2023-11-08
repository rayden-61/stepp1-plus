local waitTime = 7.5

local t = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
	OnCommand=cmd(queuecommand,"TweenOn";sleep,waitTime;queuecommand,"TweenOff");
}
t[#t+1] = Def.Quad {
	InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,color("0,0,0,1"));
	TweenOnCommand=cmd(diffusealpha,1;linear,0.5;diffusealpha,0.8);
	TweenOffCommand=cmd(linear,0.5;diffusealpha,0);
};
t[#t+1] = Def.ActorFrame {
	LoadFont("Common Normal") .. {
		Text=ScreenString("WarningHeader");
		InitCommand=cmd(y,-100;diffuse,color("#ed1c24"));
		TweenOnCommand=cmd(diffusealpha,0;zoomx,2;zoomy,0;sleep,0.5;tween,0.25, "TweenType_Bezier", {0, 0, 1, 1};zoom,1;diffusealpha,1);
		TweenOffCommand=cmd(linear,0.5;diffusealpha,0);
	};
	LoadFont("Common Normal") .. {
		Text=ScreenString("WarningText");
		InitCommand=cmd(y,10;wrapwidthpixels,SCREEN_WIDTH-48);
		TweenOnCommand=cmd(diffusealpha,0;sleep,0.5125;linear,0.125;diffusealpha,1);
		TweenOffCommand=cmd(linear,0.5;diffusealpha,0);
	};
};

return t