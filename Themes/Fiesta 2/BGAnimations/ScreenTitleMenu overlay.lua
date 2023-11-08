local t = Def.ActorFrame {};

t[#t+1] = LoadFont("Common Bold")..{
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_TOP + 40);
		self:settext("StepMania 5 (beta4)\nBuild StepP1 V1.0.3 by xMAx\nSong pack base by NicklessGuy");
		self:skewx(-.12);
		self:zoom(.5);
	end;
	OffCommand=function(self)
		SCREENMAN:GetTopScreen():lockinput(.5);	-- para que cualquier entrada no interrumpa la transición de ventanas
		(cmd(visible,false))(self);
	end;
}

return t;