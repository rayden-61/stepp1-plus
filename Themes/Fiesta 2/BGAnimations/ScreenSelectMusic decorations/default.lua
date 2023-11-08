local t = Def.ActorFrame {
	OnCommand=cmd(stoptweening;SetDrawByZPosition,true;vanishpoint,SCREEN_CENTER_X,174;fov,60);
}

collectgarbage();

-------------------------------------GENERAL------------------------------------------------------
--------------------------------------------------------------------------------------------------
cx = SCREEN_CENTER_X;
cy = SCREEN_CENTER_Y;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--PREVIEW

t[#t+1] = LoadActor("_preview")..{
	InitCommand=cmd(x,cx;draworder,6);
	OnCommand=cmd(stoptweening;y,145;sleep,.1;linear,.2;y,175);
	StartSelectingSongMessageCommand=cmd(stoptweening;y,145;diffusealpha,0;sleep,.25;linear,.1;y,175;diffusealpha,1);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;y,175;diffusealpha,1;sleep,.2;linear,.1;y,145;diffusealpha,0);
	OffCommand=cmd(stoptweening;y,175;diffusealpha,1;sleep,.2;linear,.1;y,145;diffusealpha,0);
	TimerOutSelectingSongCommand=cmd(playcommand,'Off');
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/fulllevel_"..PLAYER_1.."_stepball") )..{
	InitCommand=cmd(y,SCREEN_BOTTOM-93;x,SCREEN_CENTER_X-90;basezoom,.67);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.2;diffusealpha,0);
	StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;linear,.2;diffusealpha,1);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/fulllevel_"..PLAYER_2.."_stepball") )..{
	InitCommand=cmd(y,SCREEN_BOTTOM-93;x,SCREEN_CENTER_X+90;basezoom,.67);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.2;diffusealpha,0);
	StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;linear,.2;diffusealpha,1);
};

if GAMESTATE:IsSideJoined( PLAYER_1 ) then
t[#t+1] = GetHighScoresFrame( PLAYER_1, false )..{
	InitCommand=cmd(x,cx-207;y,SCREEN_BOTTOM-105);
}
end;

if GAMESTATE:IsSideJoined( PLAYER_2 ) then
t[#t+1] = GetHighScoresFrame( PLAYER_2, false )..{
	InitCommand=cmd(x,cx+207;y,SCREEN_BOTTOM-105);
}
end;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--GROUP WHEEL
t[#t+1] = LoadActor("_groupwheel")..{
	OnCommand=cmd(stoptweening;draworder,10;visible,true);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;visible,true);
	StartSelectingSongMessageCommand=cmd(stoptweening;sleep,.6;queuecommand,'Hide');
	HideCommand=cmd(visible,false);
	TimerOutSelectingSongCommand=cmd(visible,false);
	TimerOutSelectingGroupCommand=cmd(playcommand,'StartSelectingSong');
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--FULL MODE THINGS

t[#t+1] = LoadActor("_diff_FM.lua")..{
	OnCommand=cmd(draworder,15;stoptweening;y,560);
	StartSelectingStepsMessageCommand=cmd(stoptweening;playcommand,"ShowUp";y,SCREEN_BOTTOM+100;linear,.2;y,SCREEN_BOTTOM-93;queuecommand,'HideOffCommand'); 	
	GoBackSelectingSongMessageCommand=cmd(stoptweening;playcommand,"Hide";y,SCREEN_BOTTOM-93;sleep,.2;linear,.1;y,SCREEN_BOTTOM+100;queuecommand,'HideOnCommand');
	OffCommand=cmd(stoptweening;y,SCREEN_BOTTOM-93;sleep,.2;linear,.2;y,SCREEN_BOTTOM+100);
	GoFullModeMessageCommand=cmd(stoptweening;y,SCREEN_BOTTOM+100);
	HideOffCommand=cmd(visible,false);
	HideOnCommand=cmd(visible,true);
}

t[#t+1] = LoadActor("_diffbar_full")..{
	InitCommand=cmd(draworder,16;x,SCREEN_CENTER_X;basezoom,.535;zoom,1);
	OnCommand=cmd(stoptweening;diffusealpha,0;y,330;sleep,.45;linear,.3;y,305;diffusealpha,1);
	StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;y,330;sleep,.45;linear,.3;y,305;diffusealpha,1);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;y,305;zoom,1;linear,.3;y,330;diffusealpha,0);
	StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,1;y,305;zoom,1;sleep,.1;linear,.3;zoom,1.25;y,305);
	GoBackSelectingSongMessageCommand=cmd(stoptweening;zoom,1.25;y,305;sleep,.1;linear,.3;zoom,1;y,305);
	OffCommand=cmd(stoptweening;diffusealpha,1;sleep,.05;linear,.3;y,320;diffusealpha,0);
	TimerOutSelectingSongCommand=cmd(stoptweening;diffusealpha,1;sleep,.05;linear,.3;y,330;diffusealpha,0);
}

--SCORE GRADES
t[#t+1] = LoadActor("_grades") .. {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--PRESS CENTER STEP
t[#t+1] = SimplePlatPiu(cx,cy+80)..{ 
	OnCommand=cmd(visible,false;draworder,100);
	StepsChosenMessageCommand=function(self,params)
		if GAMESTATE:GetNumSidesJoined() == 1 then
			(cmd(stoptweening;visible,true))(self);
		else
			local screen = SCREENMAN:GetTopScreen();
			if screen:IsPlayerReady(PLAYER_1) and screen:IsPlayerReady(PLAYER_2) then
				(cmd(stoptweening;visible,true))(self);
			else
				(cmd(stoptweening;visible,false))(self);
			end;
		end;
		
	end;
	StepsPreselectedCancelledMessageCommand=cmd(stoptweening;visible,false);
	GoBackSelectingSongMessageCommand=cmd(stoptweening;visible,false);
	OffCommand=cmd(stoptweening;visible,false);
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--CHANNEL, CATEGORY
t[#t+1] = LoadActor("_stages")..{
	TimerOutSelectingSongCommand=cmd(playcommand,'Off');
	TimerOutSelectingGroupCommand=cmd(playcommand,'Off');
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--ARROWS
t[#t+1] = LoadActor("_arrows")..{
	TimerOutSelectingSongCommand=cmd(playcommand,'Off');
	TimerOutSelectingGroupCommand=cmd(playcommand,'Off');
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--JOIN MESSAGES
--[[
if not GAMESTATE:IsSideJoined(PLAYER_1) then
t[#t+1] = LoadActor( THEME:GetPathG("","Messages/"..GetLanguageText().."_join.png") )..{
	InitCommand=cmd(draworder,20;x,SCREEN_LEFT+100;y,SCREEN_BOTTOM-120;diffusealpha,0;decelerate,.2;x,SCREEN_LEFT+160;diffusealpha,1;sleep,6;decelerate,.2;x,SCREEN_LEFT-50;diffusealpha,0);
	TimerOutSelectingSongCommand=cmd(playcommand,'Off');
}
end;

if not GAMESTATE:IsSideJoined(PLAYER_2) then
t[#t+1] = LoadActor( THEME:GetPathG("","Messages/"..GetLanguageText().."_join.png") )..{
	InitCommand=cmd(draworder,20;x,SCREEN_RIGHT-100;y,SCREEN_BOTTOM-120;diffusealpha,0;decelerate,.2;x,SCREEN_RIGHT-160;diffusealpha,1;sleep,6;decelerate,.2;x,SCREEN_RIGHT+50;diffusealpha,0);
	TimerOutSelectingSongCommand=cmd(playcommand,'Off');
}
end;
]]
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--TIMER
-- DrawOrder = 1
t[#t+1] = LoadActor("_timer")..{
	OnCommand=cmd(x,cx;y,-10;decelerate,.1;y,10;decelerate,.1;y,2);
	OffCommand=cmd(x,cx;y,0;decelerate,.1;y,10;decelerate,.1;y,-58);
	TimerOutSelectingSongCommand=cmd(playcommand,'Off');
	TimerOutSelectingGroupCommand=cmd(playcommand,'Off');
};

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+90;diffusealpha,0;zoom,.7);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.3;linear,.2;diffusealpha,1;sleep,2;linear,.2;diffusealpha,0);
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
	children = {
		LoadActor(THEME:GetPathG("","Messages/back.png"));
		LoadActor(THEME:GetPathG("","Messages/back_glow.png"))..{
			InitCommand=cmd(blend,"BlendMode_Add");
			OnCommand=cmd(diffusealpha,.2);
		};
		LoadActor(THEME:GetPathG("","Messages/goback_"..GetLanguageText()..".png"))..{
			OnCommand=cmd(zoom,.47);
		};
	};
};

t[#t+1] = LoadActor( THEME:GetPathS("","Sounds/ST_BGM (loop)") )..{
	OnCommand=cmd(stop);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;play);
	StartSelectingSongMessageCommand=cmd(stoptweening;stop);
	PlayerJoinedMessageCommand=cmd(stoptweening;stop);
	OffCommand=cmd(stoptweening;stop);
}

return t
--code by xMAx