local t = Def.ActorFrame {}

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
local xBase = {197,-197};
local xBaseSC = {186,-187};
local InitDelay = .2;

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-- Base lights
for i=1,2 do
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/plights_nglow.png") )..{
	InitCommand=function(self)
		self:x(xBase[i]);
	end;
	OnCommand=cmd(stoptweening;diffusealpha,0;blend,'BlendMode_Add';sleep,InitDelay;decelerate,.2;diffusealpha,.6;sleep,.1;queuecommand,'Loop');
	LoopCommand=cmd(diffusealpha,.6;decelerate,.5;diffusealpha,1;decelerate,.5;diffusealpha,.6;queuecommand,'Loop');
	StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.2;linear,.1;diffusealpha,.6;playcommand,'Loop');
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.1;diffusealpha,0);
	OffCommand=cmd(stoptweening;diffusealpha,1;linear,.1;diffusealpha,0);
	};
end;

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-- Glow light (for next and previous)
for i=1,2 do
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/plights_nglow.png") )..{
	InitCommand=function(self)
		self:x(xBase[i]);
	end;
	OnCommand=cmd(stoptweening;diffusealpha,0;blend,'BlendMode_Add');
	NextSongMessageCommand=function(self)
	if i==1 then (cmd(stoptweening;zoom,1;diffusealpha,1;accelerate,.12;zoomx,5;decelerate,.01;diffusealpha,0))(self); end;
	end;
	PreviousSongMessageCommand=function(self)
	if i==2 then (cmd(stoptweening;zoom,1;diffusealpha,1;accelerate,.12;zoomx,5;decelerate,.01;diffusealpha,0))(self); end;
	end;
	StartSelectingSongMessageCommand=cmd(stoptweening;zoom,1;diffusealpha,0;visible,true);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;visible,false);
	OffCommand=cmd(stoptweening;visible,false);
	};
end;

return t