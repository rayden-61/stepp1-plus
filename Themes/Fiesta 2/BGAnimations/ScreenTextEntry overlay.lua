local t = Def.ActorFrame {};

t[#t+1] = LoadFont("Common Bold")..{
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_TOP + 20);
		self:settext("(Press ESC to cancel / Press ENTER to confirm)");
		self:zoom(.5);
	end;
}

return t;