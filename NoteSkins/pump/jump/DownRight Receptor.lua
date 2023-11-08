return Def.ActorFrame {
	LoadActor("DownRight Tap Note")..{
		InitCommand=cmd(stoptweening;diffusealpha,.5;visible,false);
		ShowNoteUpcomingCommand=cmd(stoptweening;visible,true);
		HideNoteUpcomingCommand=cmd(stoptweening;visible,false);
	};
}