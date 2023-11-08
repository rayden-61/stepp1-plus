local t = Def.ActorFrame {};

-- El Editor usa siempre el P1
-- gameplayutils.lua
t[#t+1] = GetPlayerJudgment(PLAYER_1)..{
	OnCommand=function(self)
		self:y(260);
		self:x(SCREEN_CENTER_X);
	end;
	PlayingCommand=cmd(finishtweening;visible,true);
	RecordCommand=cmd(finishtweening;visible,true);
	RecordPausedCommand=cmd(finishtweening;visible,true);
	EditCommand=cmd(finishtweening;visible,false);
}

-- Checkpoints
t[#t+1] = LoadFont("Common Bold")..{
	InitCommand=function(self)
		self:zoom(.6);
		self:horizalign('HorizAlign_Left');
		self:x(10);
		self:y(20);
		self:settext("Last hold\nhits: 0");
	end;
	CheckpointsPerfectCountMessageCommand=function(self,params)
		self:settext("Last hold\nhits: "..tostring(params.cp));
	end;
	PlayingCommand=cmd(finishtweening;visible,true;settext,"Last hold\nhits: 0");
	RecordCommand=cmd(finishtweening;visible,true);
	RecordPausedCommand=cmd(finishtweening;visible,true);
	EditCommand=cmd(finishtweening;visible,false);
}

-- Score
t[#t+1] = LoadFont("Common Bold")..{
	InitCommand=function(self)
		self:zoom(.6);
		self:horizalign('HorizAlign_Left');
		self:x(10);
		self:y(50);
		self:settext("Score: 0");
	end;
	ReadScoreChangedMessageCommand=function(self,params)
		self:settext("Score: "..tostring(params.Score));
	end;
	PlayingCommand=cmd(finishtweening;visible,true;settext,"Score: 0");
	RecordCommand=cmd(finishtweening;visible,true);
	RecordPausedCommand=cmd(finishtweening;visible,true);
	EditCommand=cmd(finishtweening;visible,false);
}

return t;

