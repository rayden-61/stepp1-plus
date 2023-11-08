local t = Def.ActorFrame {};

t[#t+1] = LoadActor( BGDirB.."/ARCADE_BG" )..{
--t[#t+1] = LoadActor( "ad.png" )..{
	OnCommand=function(self)
		(cmd(Center;show_background_properly;loop,true))(self)
		local cur_group = SCREENMAN:GetTopScreen():GetCurrentGroup();
	
		if ( cur_group == "SO_QUEST" or cur_group == "04-SKILLUP ZONE" ) then
			self:visible(false);
			self:pause();
		else
			self:play();
		end;
	end;
	ShowGreenStuffsMessageCommand=cmd(stoptweening;visible,false;pause);
	HideGreenStuffsMessageCommand=cmd(stoptweening;visible,true;play);
}

t[#t+1] = LoadActor( BGDirB.."/MISSION_BG" )..{
	OnCommand=function(self)
		(cmd(Center;show_background_properly;loop,true))(self)
		local cur_group = SCREENMAN:GetTopScreen():GetCurrentGroup();
		
		if not ( cur_group == "SO_QUEST" or cur_group == "04-SKILLUP ZONE" ) then
			self:visible(false);
			self:pause();
		else
			self:play();
		end;
	end;
	ShowGreenStuffsMessageCommand=cmd(stoptweening;visible,true;play);
	HideGreenStuffsMessageCommand=cmd(stoptweening;visible,false;pause);
}

return t;