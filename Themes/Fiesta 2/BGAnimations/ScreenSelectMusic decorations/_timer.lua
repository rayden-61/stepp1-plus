local t = Def.ActorFrame {
	OnCommand=cmd(playcommand,'StartSelectingSong');
}

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
-- Channel text
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/selection_states 1x3") )..{
	InitCommand=cmd(y,42;zoom,.66;pause;setstate,1);
	GoBackSelectingGroupMessageCommand=cmd(finishtweening;setstate,0;playcommand,'Change');
	StartSelectingSongMessageCommand=cmd(finishtweening;setstate,1;playcommand,'Change');
	GoBackSelectingSongMessageCommand=cmd(finishtweening;setstate,1;playcommand,'Change');
	StartSelectingStepsMessageCommand=cmd(finishtweening;setstate,2;playcommand,'Change');
	GoBackSelectingStepsMessageCommand=cmd(finishtweening;setstate,2;playcommand,'Change');
	ChangeCommand=cmd(diffusealpha,1;linear,.2;diffusealpha,0;sleep,0;diffusealpha,1);
	OffCommand=cmd(stoptweening;diffusealpha,0);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/selection_states 1x3") )..{
	InitCommand=cmd(y,42;zoom,.66;pause;setstate,1;blend,'BlendMode_Add');
	GoBackSelectingGroupMessageCommand=cmd(finishtweening;setstate,0;playcommand,'Change');
	StartSelectingSongMessageCommand=cmd(finishtweening;setstate,1;playcommand,'Change');
	GoBackSelectingSongMessageCommand=cmd(finishtweening;setstate,1;playcommand,'Change');
	StartSelectingStepsMessageCommand=cmd(finishtweening;setstate,2;playcommand,'Change');
	GoBackSelectingStepsMessageCommand=cmd(finishtweening;setstate,2;playcommand,'Change');
	ChangeCommand=cmd(diffusealpha,0;sleep,.2;zoom,.66;diffusealpha,.8;linear,.2;diffusealpha,0;zoomx,.72);
	OffCommand=cmd(stoptweening;diffusealpha,0);
};

return t;