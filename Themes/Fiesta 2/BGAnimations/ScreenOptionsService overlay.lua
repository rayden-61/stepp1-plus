local t = Def.ActorFrame {};

t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(20);
		if GetLanguageText() == "es" then
			self:settext("Menu de Opciones");
		else
			self:settext("Options Menu");
		end;
	end;
	OffCommand=cmd(stoptweening;linear,.1;diffusealpha,0);
}

return t;