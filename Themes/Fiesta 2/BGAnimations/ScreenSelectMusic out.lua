return Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,0);
	OnCommand=cmd(diffusealpha,0;linear,.65;diffusealpha,1);
	--[[OnCommand=cmd(diffusealpha,0;linear,.7;diffusealpha,1;sleep,.05;queuecommand,'NextScreen');
	NextScreenCommand=function(self)
		local nexts = SCREENMAN:GetTopScreen():GetNextScreenName();
		SCREENMAN:SetNewScreen(nexts);
	end;]]--
};