local t = Def.ActorFrame {};

t[#t+1] = LoadActor(THEME:GetPathS("","Sounds/JOIN.mp3"))..{
	PlayerJoinedMessageCommand=cmd(play);
}

t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectPlayModeBranch/BG.png"))..{
	InitCommand=cmd(show_background_properly);
	OnCommand=cmd(visible,false);
	PlayerJoinedMessageCommand=cmd(visible,true);
}

return t;