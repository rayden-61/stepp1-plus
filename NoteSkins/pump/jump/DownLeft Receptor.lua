return Def.ActorFrame {
	LoadActor("DownLeft Tap Note")..{
		InitCommand=cmd(stoptweening;diffusealpha,.5;visible,false);
		ShowNoteUpcomingCommand=cmd(stoptweening;visible,true);
		HideNoteUpcomingCommand=cmd(stoptweening;visible,false);
	};
}