local function GetSCString()
	local temp = GAMESTATE:GetCurrentSong():GetSongCategory();
	local toret = "";
	if temp == "SongCategory_USE_GENRE" then
		toret = GAMESTATE:GetCurrentSong():GetGenre();
	else
		toret = string.gsub(temp,"SongCategory_","");
	end;
	
	return toret;
end;

local in_stg = cmd(stoptweening;diffusealpha,0;sleep,.2;decelerate,.2;diffusealpha,1);
local out_stg = cmd(stoptweening;linear,.1;diffusealpha,0;sleep,.02;linear,.08;diffusealpha,1;decelerate,.1;diffusealpha,0);

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
local t = Def.ActorFrame {};

-- CHANNEL TEXT
t[#t+1] = Def.ActorFrame {
	OnCommand=cmd(stoptweening;x,cx-124);
	children = {
		LoadFont("hdkarnivore 24px")..{
			InitCommand=cmd(y,27;zoom,.57;maxwidth,230);
			RefreshCommand=function(self)
				local Group = SCREENMAN:GetTopScreen():GetCurrentGroup();
				self:settext( string.upper(RenameGroup(Group)) );
			end;
			OnCommand=cmd(stoptweening;playcommand,'Refresh';diffusealpha,0;sleep,.2;linear,.2;diffusealpha,1);
			OffCommand=cmd(stoptweening;diffusealpha,1;sleep,.2;linear,.2;diffusealpha,0);
			ChangeGroupMessageCommand=function(self, params)
				self:finishtweening();
				self:settext( string.upper(RenameGroup(params.Group)) );
			end;
			OffCommand=cmd(finishtweening;linear,.2;diffusealpha,0);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/stage_channel.png") )..{
			InitCommand=cmd(y,15;zoom,.66);
			OnCommand=cmd(stoptweening;y,-5;linear,.2;y,15;sleep,.1;linear,.2;diffusealpha,1);
			OffCommand=cmd(stoptweening;diffusealpha,1;sleep,.1;linear,.1;diffusealpha,0);
			OffCommand=cmd(stoptweening;y,15;diffusealpha,1;sleep,.2;linear,.2;y,-5);
		};
	};
};

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-- CATEGORY TEXT
t[#t+1] = Def.ActorFrame {
	OnCommand=cmd(stoptweening;x,cx+124);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;x,cx+124;sleep,.4;zoom,0);
	StartSelectingSongMessageCommand=cmd(stoptweening;x,cx+124;zoom,1);
	children = {
		LoadFont("hdkarnivore 24px")..{
			InitCommand=cmd(y,27;zoom,.57;maxwidth,200);
			RefreshCommand=function(self)
				self:settext( string.upper(GetSCString()) );
			end;
			OnCommand=cmd(stoptweening;playcommand,'Refresh';diffusealpha,0;sleep,.2;linear,.2;diffusealpha,1);
			OffCommand=cmd(stoptweening;diffusealpha,1;sleep,.1;linear,.2;diffusealpha,0);
			CurrentCategoryChangedMessageCommand=function(self,params)
				self:stoptweening();
				self:diffusealpha(1);
				self:settext( string.upper(params.Category) );
			end;
			OffCommand=cmd(finishtweening;linear,.2;diffusealpha,0);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/stage_category.png") )..{
			InitCommand=cmd(y,15;zoom,.66);
			OnCommand=cmd(stoptweening;y,-5;linear,.2;y,15;sleep,.1;linear,.2;diffusealpha,1);
			OffCommand=cmd(stoptweening;y,15;diffusealpha,1;sleep,.2;linear,.2;y,-5);
		};
	};
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/moon 1x4.png") )..{
	InitCommand=cmd(stoptweening;pause;setstate,1;zoom,.66;vertalign,'VertAlign_Top';x,SCREEN_CENTER_X;y,0);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,.1;linear,.2;diffusealpha,0);
	StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.1;linear,.2;diffusealpha,1);
};

return t;