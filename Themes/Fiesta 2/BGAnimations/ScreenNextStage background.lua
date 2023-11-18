local t = Def.ActorFrame {};

--t[#t+1] = LoadActor( BGDirB.."/NST"..tostring( STATSMAN:GetStagesPlayed() % 3 ) ) .. {
--	InitCommand=cmd(FullScreen;loop,false);
--	OnCommand=cmd(play);
--};

return t;