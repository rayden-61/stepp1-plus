local t = Def.ActorFrame {};

t[#t+1] = LoadFont("Common Bold")..{
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_TOP + 40);
		self:settext("StepMania 5 (beta4)\nStepP1 V1.0.0 by xMAx; 1.0.1 to 1.0.3 updates by SheepyChris + TeamCrackitUp\nStepP1 Plus V1.0 by Rayden61\n");
		self:skewx(-.12);
		self:zoom(.35);
	end;
	OffCommand=function(self)
		SCREENMAN:GetTopScreen():lockinput(.5);	-- para que cualquier entrada no interrumpa la transición de ventanas
		(cmd(visible,false))(self);
	end;
}

return t;