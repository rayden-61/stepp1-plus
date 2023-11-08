local t = Def.ActorFrame {	
	ChangeStepsMessageCommand=function(self, params)
		if params.Direction == 1 then	--der
			--MESSAGEMAN:Broadcast("NextStep");
			self:playcommand("NextStep");
		elseif params.Direction == -1 then	--izq
			--MESSAGEMAN:Broadcast("PreviousStep");
			self:playcommand("PreviousStep");
		end;
	end;
}

local goback = cmd(stoptweening;diffusealpha,1;linear,.2;diffusealpha,0);
local start  = cmd(stoptweening;diffusealpha,0;sleep,.1;linear,.1;diffusealpha,1);
local init_black = cmd(stoptweening;diffusealpha,0;sleep,.3;diffusealpha,1);
local common = cmd(stoptweening;diffusealpha,0;linear,.1;diffusealpha,.5;linear,.2;diffusealpha,1);
local init_pink_for_basic = cmd(stoptweening;diffusealpha,0;linear,.1;diffusealpha,.5;linear,.2;diffusealpha,1;linear,.5;diffusealpha,0);
local shift_command = cmd(stoptweening;stopeffect;zoom,1;diffusealpha,.7;sleep,.15;linear,.15;diffusealpha,0;zoom,1.02;queuecommand,'Effect');

local zoom_factor = 0.66;
--local zoom_factor = 1;
----------------------------------------------------------------------------------------------------------------------------
--UpLeft--

local UL_ARROW = Def.ActorFrame {
	InitCommand=cmd(x,35+135;y,35+135;zoom,zoom_factor);
	OnCommand=cmd(stoptweening;sleep,.1;linear,.1;x,35;y,35);
	OffCommand=cmd(stoptweening;x,35;y,35;sleep,.2;linear,.1;x,35+135;y,35+135;diffusealpha,.2;sleep,0;x,35;y,35;diffusealpha,1);
	children = {
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/left_black.png") )..{
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/left_pink.png") )..{
			GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.3;diffusealpha,0);
			StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.3;diffusealpha,.8);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/left_pink.png") )..{
			OnCommand=cmd(zoom,1.08;blend,'BlendMode_Add';diffuseshift;effectcolor1,1,1,1,.25;effectcolor2,1,1,1,0;effectperiod,2)
		};
	};
}

local UR_ARROW = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_WIDTH-35-135;y,35+135;zoom,zoom_factor);
	OnCommand=cmd(stoptweening;sleep,.1;linear,.1;x,SCREEN_WIDTH-35;y,35);
	OffCommand=cmd(stoptweening;x,SCREEN_WIDTH-35;y,35;sleep,.2;linear,.1;x,SCREEN_WIDTH-35-135;y,35+135;diffusealpha,.2;sleep,0;x,SCREEN_WIDTH-35;y,35;diffusealpha,1);
	children = {
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/right_black.png") )..{
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/right_pink.png") )..{
			GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.3;diffusealpha,0);
			StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.3;diffusealpha,.8);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/right_pink.png") )..{
			OnCommand=cmd(zoom,1.08;blend,'BlendMode_Add';diffuseshift;effectcolor1,1,1,1,.25;effectcolor2,1,1,1,0;effectperiod,2)
		};
	};
}

local blue_arrows_shine_shift = cmd(stoptweening;diffusealpha,0;zoomy,1;zoomx,1;sleep,.1;linear,.1;diffusealpha,.6;linear,.2;zoomy,.5;zoomx,1.5;diffusealpha,0);
local blue_arrows_graph_shift = cmd(stoptweening;stopeffect;diffusealpha,.1;zoom,1.08;linear,.2;diffusealpha,.5;zoom,1.1;linear,.2;diffusealpha,0;zoom,1.08;queuecommand,'ContinueEffect');

local DR_ARROW = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_WIDTH-35-135;y,SCREEN_HEIGHT-35-135;zoom,zoom_factor);
	OnCommand=cmd(stoptweening;sleep,.1;linear,.1;x,SCREEN_WIDTH-35;y,SCREEN_HEIGHT-36);
	OffCommand=cmd(stoptweening;x,SCREEN_WIDTH-35;y,SCREEN_HEIGHT-36;sleep,.2;linear,.1;x,SCREEN_WIDTH-35-135;y,SCREEN_HEIGHT-35-135;diffusealpha,.2;sleep,0;x,SCREEN_WIDTH-35;y,SCREEN_HEIGHT-36;diffusealpha,1);
	children = {
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/right_blue.png") )..{
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/right_blue.png") )..{
			OnCommand=cmd(zoom,1.08;blend,'BlendMode_Add';diffuseshift;effectcolor1,1,1,1,.25;effectcolor2,1,1,1,0;effectperiod,2);
			NextSongMessageCommand=blue_arrows_graph_shift;
			NextGroupMessageCommand=blue_arrows_graph_shift;
			ContinueEffectCommand=cmd(stoptweening;diffusealpha,1;diffuseshift;effectcolor1,1,1,1,.25;effectcolor2,1,1,1,0;effectperiod,2);
			OffCommand=cmd(visible,false);
		};
		Def.ActorFrame {
			BeginCommand=cmd(rotationz,-45);
			OffCommand=cmd(visible,false);
			children = {
				LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/SHINE.png") )..{
					OnCommand=cmd(zoom,1;blend,'BlendMode_Add';diffusealpha,0);
					NextSongMessageCommand=blue_arrows_shine_shift;
					NextGroupMessageCommand=blue_arrows_shine_shift;
				};
			};
		};
	};
}

local DL_ARROW = Def.ActorFrame {
	InitCommand=cmd(x,35+135;y,SCREEN_HEIGHT-35-135;zoom,zoom_factor);
	OnCommand=cmd(stoptweening;sleep,.1;linear,.1;x,35;y,SCREEN_HEIGHT-35);
	OffCommand=cmd(stoptweening;x,35;y,SCREEN_HEIGHT-35;sleep,.2;linear,.1;x,35+135;y,SCREEN_HEIGHT-35-135;diffusealpha,.2;sleep,0;x,35;y,SCREEN_HEIGHT-35;diffusealpha,1);
	children = {
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/left_blue.png") )..{
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/left_blue.png") )..{
			OnCommand=cmd(zoom,1.08;blend,'BlendMode_Add';diffuseshift;effectcolor1,1,1,1,.25;effectcolor2,1,1,1,0;effectperiod,2);
			PreviousSongMessageCommand=blue_arrows_graph_shift;
			PrevGroupMessageCommand=blue_arrows_graph_shift;
			OffCommand=cmd(visible,false);
			ContinueEffectCommand=cmd(stoptweening;diffusealpha,1;diffuseshift;effectcolor1,1,1,1,.25;effectcolor2,1,1,1,0;effectperiod,2);
		};
		Def.ActorFrame {
			BeginCommand=cmd(rotationz,45);
			OffCommand=cmd(visible,false);
			children = {
				LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/SHINE.png") )..{
					OnCommand=cmd(zoom,1;blend,'BlendMode_Add';diffusealpha,0);
					PreviousSongMessageCommand=blue_arrows_shine_shift;
					PrevGroupMessageCommand=blue_arrows_shine_shift;
				};
			};
		};
	};
}

t[#t+1] = UL_ARROW;
t[#t+1] = UR_ARROW;
t[#t+1] = DR_ARROW;
t[#t+1] = DL_ARROW;

return t;