local t = Def.ActorFrame {};

t[#t+1] = LoadActor( BGDirB.."/Teaser" )..{
	InitCommand=cmd(Center;show_background_properly);	
	OnCommand=cmd(play);
};

return t;
