function SimplePlatPiu (xpos,ypos)
local plataforma = Def.ActorFrame{
	OnCommand=cmd(x,xpos;y,ypos);
	children = {
LoadActor(THEME:GetPathG("","_pad/plataforma.png"))..{
	InitCommand=cmd(stoptweening;diffusealpha,1;basezoom,.66);
	OffCommand=cmd(stoptweening);
};
LoadActor(THEME:GetPathG("","_pad/start.png"))..{
	InitCommand=cmd(stoptweening;y,-6;basezoom,.66;blend,'BlendMode_Add';queuecommand,'Loop');
	LoopCommand=cmd(stoptweening;diffusealpha,0;zoom,1;sleep,.3;linear,.05;diffusealpha,1;zoom,1.06;linear,.25;zoom,1;diffusealpha,0;queuecommand,'Loop');
	OffCommand=cmd(stoptweening);
};
LoadActor(THEME:GetPathG("","_pad/press_center_step.png"))..{
	InitCommand=cmd(stoptweening;y,-60;zoom,1;basezoom,.66;queuecommand,'Loop');
	LoopCommand=cmd(stoptweening;y,-60;linear,.3;y,-32;linear,.3;y,-60;queuecommand,'Loop');
	OffCommand=cmd(stoptweening);
};};};
return plataforma; 
end;

function PlayerMessage( pn )
local t = Def.ActorFrame {
	InitCommand=cmd(basezoom,.67);
	children = {
		LoadActor(THEME:GetPathG("","Messages/back.png"));
		LoadActor(THEME:GetPathG("","Messages/back_glow.png"))..{
			InitCommand=cmd(blend,"BlendMode_Add");
			OnCommand=cmd(diffusealpha,.2;playcommand,'Loop1');
			Loop1Command=function(self)
				if pn==PLAYER_1 then
					(cmd(horizalign,'HorizAlign_Right';x,120))(self);
				else
					(cmd(horizalign,'HorizAlign_Left';x,-120))(self);
				end;
				(cmd(zoomx,0;diffusealpha,0;linear,1;zoomx,1;diffusealpha,.2;queuecommand,'Loop2'))(self);
			end;
			Loop2Command=function(self)
				if pn==PLAYER_1 then
					(cmd(horizalign,'HorizAlign_Left';x,-120))(self);
				else
					(cmd(horizalign,'HorizAlign_Right';x,120))(self);
				end;
				(cmd(zoomx,1;linear,1;zoomx,0;diffusealpha,0;queuecommand,'Loop1'))(self);
			end;
		};
		LoadActor(THEME:GetPathG("","Messages/back.png"))..{
			InitCommand=cmd(blend,"BlendMode_Add");
			OnCommand=cmd(diffusealpha,0;playcommand,'Loop');
			LoopCommand=cmd(diffusealpha,0;linear,1;diffusealpha,1;linear,1;diffusealpha,0;queuecommand,'Loop');
		};
		LoadActor(THEME:GetPathG("","Messages/press_"..GetLanguageText()..".png"))..{
			PlayerStartedSelectProfileMessageCommand=function( self, params )
				if (params.Player == pn) then
					self:visible(false);
				end;
			end;
		};
		LoadActor(THEME:GetPathG("","Messages/use_"..GetLanguageText()..".png"))..{
			OnCommand=cmd(visible,false);
			PlayerStartedSelectProfileMessageCommand=function( self, params )
				if (params.Player == pn) then
					self:visible(true);
				end;
			end;
		};
	};
};
return t;
end;

-----------------------------------------------
-----------------------------------------------
function IsHD()
	local ratio = PREFSMAN:GetPreference("DisplayAspectRatio")
	return ratio > 1.5;
end;

function Actor:show_background_properly()
	self:Center();
	if IsHD() then
		if PREFSMAN:GetPreference("StretchBackgrounds") then
			self:stretchto(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
		else
			self:scaletofit(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
		end;
	else
		self:scale_or_crop_background();
	end;
end

function GetBackgroundPath()
	local bgpath = GAMESTATE:GetCurrentSong():GetBackgroundPath();
	local no_bg = THEME:GetPathG("","ScreenStageInformation/_no_background.png");
	if not bgpath then
		return no_bg;
	else
		if FILEMAN:DoesFileExist(bgpath) then
			return bgpath;
		else
			return no_bg;
		end;
	end;
end;