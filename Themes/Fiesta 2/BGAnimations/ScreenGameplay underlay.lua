--thanks to StepMod / arka for this, extracted from StepMod 1.2
local function GetStageNumberActor()
	local first_digit;
	local second_digit;
	local stage = STATSMAN:GetStagesPlayed()+1;
	
	if( stage > 99 ) then
		first_digit = 9;
		second_digit = 9;
	else
		first_digit = math.floor(stage/10);
		second_digit = stage - (first_digit*10);
	end;
		
	return Def.ActorFrame {
		LoadActor( THEME:GetPathG("","ScreenGameplay/STAGE_FM") ).. {
			InitCommand=cmd(FromTop,28);
		};
		LoadActor( THEME:GetPathG("","ScreenGameplay/N_FM") ).. {
			InitCommand=cmd(x,-12;FromTop,34;pause;setstate,first_digit);
		};
		LoadActor( THEME:GetPathG("","ScreenGameplay/N_FM") ).. {
			InitCommand=cmd(x,12;FromTop,34;pause;setstate,second_digit);
		};
	};
end;



local function PlayerName( Player )
	local t = Def.ActorFrame {
		LoadActor( THEME:GetPathG("","ScreenSystemLayer/PlayerName background heartless "..Player) )..{
			Name = "Back1";
		};
		LoadFont("","_myriad pro 20px") .. {
			Name = "Name";
			InitCommand=cmd(horizalign,left;y,-8;x,-70);
		};
	};
	return t;
end;

local t = Def.ActorFrame {};

local style = GAMESTATE:GetCurrentStyle():GetStyleType();
local pn;
if( GAMESTATE:IsSideJoined(PLAYER_1) ) then pn = PLAYER_1 else pn = PLAYER_2 end;

if( (style=='StyleType_OnePlayerTwoSides') or (style=='StyleType_TwoPlayersSharedSides') ) then
	t[#t+1] = GetStageNumberActor()..{ InitCommand=cmd(basezoom,.67;stoptweening;FromCenterX,-285); };
else
	t[#t+1] = GetStageNumberActor()..{ InitCommand=cmd(basezoom,.67;FromCenterX,0); };
end;


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetPlayerPosition( player )
	local P1PosX = SCREEN_CENTER_X-159;
	local P2PosX = SCREEN_CENTER_X+159;
	
	local style = GAMESTATE:GetCurrentSteps(player):GetStepsType();
	
	if IsUnderAttackForPlayer( player ) then
		if style == 'StepsType_Pump_Single' or style == 'StepsType_Pump_Couple' then
			if player == PLAYER_1 then return P1PosX; else return P2PosX; end;
		else
			return SCREEN_CENTER_X;
		end;
	end;
	
	if style == 'StepsType_Pump_Single' or style == 'StepsType_Pump_Couple' then
		if player == PLAYER_1 then return P1PosX; else return P2PosX; end;
	else
		return SCREEN_CENTER_X;
	end;
end;

-- gameplayutils.lua
if( GAMESTATE:IsSideJoined(PLAYER_1) or GAMESTATE:IsDemonstration() ) then
t[#t+1] = GetPlayerJudgment(PLAYER_1)..{	
	OnCommand=function(self)
		self:stoptweening();
		self:y(260);
		
		if IsNXForPlayer( PLAYER_1 ) then
			if IsDropForPlayer( PLAYER_1 ) or IsUnderAttackForPlayer( PLAYER_1 ) then
				self:y(SCREEN_CENTER_Y+130);
			else
				self:y(130);
			end;
		end;
		
		local xpos = GetPlayerPosition(PLAYER_1);
		
		if Center1Player() and not GAMESTATE:IsSideJoined(PLAYER_2) then
			xpos = SCREEN_CENTER_X;
		end;
		
		self:x(xpos);
	end;
}
end;

if( GAMESTATE:IsSideJoined(PLAYER_2) or GAMESTATE:IsDemonstration() ) then
t[#t+1] = GetPlayerJudgment(PLAYER_2)..{
	OnCommand=function(self)
		self:stoptweening();
		self:y(260);
		
		if IsNXForPlayer( PLAYER_2 ) then
			if IsDropForPlayer( PLAYER_2 ) or IsUnderAttackForPlayer( PLAYER_2 ) then
				self:y(SCREEN_CENTER_Y+130);
			else
				self:y(130);
			end;
		end;
		
		local xpos = GetPlayerPosition(PLAYER_2);
		
		if Center1Player() and not GAMESTATE:IsSideJoined(PLAYER_1) then
			xpos = SCREEN_CENTER_X;
		end;
		self:x(xpos);
	end;
}
end;


if GAMESTATE:IsSideJoined(PLAYER_1) then
	local P1PosX = GetPlayerPosition( PLAYER_1 );
	local profile = PROFILEMAN:GetProfile(PLAYER_1);
	local profilename = profile:GetDisplayName();
	if profilename == "" then profilename = "GUEST P1" end;
	
	--P1 Score Frame--
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSystemLayer/PlayerName background empty") )..{
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT;y,SCREEN_BOTTOM-18;basezoom,.54);
	};

	t[#t+1] = LoadFont("","_myriad pro 20px") .. {
		InitCommand=cmd(settext,string.upper(string.sub(profilename,1,8));horizalign,right;zoom,.51;maxwidth,82;x,SCREEN_LEFT+105;y,SCREEN_BOTTOM-23);
	};
	
	local maxcomboP1 = 0; 
	local pscoreP1 = 0;
	t[#t+1] = LoadFont("_karnivore lite white") .. {
		InitCommand=cmd(settext,"000.000";horizalign,left;zoom,.62;x,SCREEN_LEFT+5;y,SCREEN_BOTTOM-16,maxwidth,85);
		JudgmentMessageCommand=function(self,param)
			local curstats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
			local perfects = curstats:GetTapNoteScores('TapNoteScore_W2') + curstats:GetTapNoteScores('TapNoteScore_CheckpointHit');
			local greats = curstats:GetTapNoteScores('TapNoteScore_W3');
			local goods = curstats:GetTapNoteScores('TapNoteScore_W4');
			local bads = curstats:GetTapNoteScores('TapNoteScore_W5');
			local misses = curstats:GetTapNoteScores('TapNoteScore_Miss') + curstats:GetTapNoteScores('TapNoteScore_CheckpointMiss');
			local currentcombo = curstats:GetCurrentCombo();
			if currentcombo > maxcomboP1 then maxcomboP1 = currentcombo end;
			local stagebreak = curstats:GetReachedLifeZero();
			pscoreP1 = CalcPScore(perfects, greats, goods, bads, misses, maxcomboP1);
			local formatted_pscoreP1 = AddDots(pscoreP1);
			if pscoreP1 < 10 then
				formatted_pscoreP1 = "000.00"..formatted_pscoreP1;
			elseif pscoreP1 < 100 then
				formatted_pscoreP1 = "000.0"..formatted_pscoreP1;
			elseif pscoreP1 < 1000 then 
				formatted_pscoreP1 = "000."..formatted_pscoreP1;
			elseif pscoreP1 < 10000 then
				formatted_pscoreP1 = "00"..formatted_pscoreP1;
			elseif pscoreP1 < 100000 then
				formatted_pscoreP1 = "0"..formatted_pscoreP1;
			end
			self:settext(formatted_pscoreP1);
			formatted_pscoreP1 = "000.000";
			pscoreP1 = 0;
		end;
	};

	-- P1 Mods Display --
	local P1mods = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptionsString('ModsLevel_Preferred');
	local P1speedstring = string.sub(P1mods,1,6);
	local P1speed = "1x"
	local P1speedstart, P1speedend = 1,2;
	local P1judge = ", NJ"
	if string.find(P1mods, " Easy") then
		P1judge = ", EJ"
	elseif string.find(P1mods, " Normal") then
		P1judge = ", NJ"
	elseif string.find(P1mods, " Hard") then
		P1judge = ", HJ"
	elseif string.find(P1mods, " VeryHard") then
		P1judge = ", VJ"
	elseif string.find(P1mods, " ExtraHard") then
		P1judge = ", XJ"
	elseif string.find(P1mods, " UltraHard") then
		P1judge = ", UJ"
	end;
	if string.find(P1speedstring, "^%d.*x,") then
		P1speedstart, P1speedend = string.find(P1speedstring, "^%d.*x,");
		P1speed = string.sub(P1speedstring, P1speedstart,P1speedend-1);
	elseif string.find(P1speedstring, "^m%d%d%d,") then
		P1speedstart, P1speedend = string.find(P1speedstring, "^m%d%d%d,");
		P1speed = "AV"..string.sub(P1speedstring, P1speedstart+1,P1speedend-1);
	end;
	P1mods = P1speed..P1judge
	t[#t+1] = LoadFont("","_myriad pro 20px") .. {
		InitCommand=cmd(settext,P1mods;horizalign,right;zoom,.32;x,SCREEN_LEFT+105;y,SCREEN_BOTTOM-15;diffuse,color("#00FFFF"));
	};	

	--P1 Difficulty Ball--
	t[#t+1] = GetSimpleBallLevel( PLAYER_1 )..{ 
		InitCommand=cmd(horizalign,right;basezoom,.18;x,SCREEN_LEFT+120;playcommand,"ShowUp";y,SCREEN_BOTTOM-18);
	};

end;


if GAMESTATE:IsSideJoined(PLAYER_2) then
	local P2PosX = GetPlayerPosition( PLAYER_2 );
	local profile = PROFILEMAN:GetProfile(PLAYER_2);
	local profilename = profile:GetDisplayName();
	if profilename == "" then profilename = "GUEST P2" end;

	--P2 Score Frame--
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSystemLayer/PlayerName background empty") )..{
		InitCommand=cmd(horizalign,right;x,SCREEN_RIGHT;y,SCREEN_BOTTOM-18;basezoom,.54);
	};

	t[#t+1] = LoadFont("","_myriad pro 20px") .. {
		InitCommand=cmd(settext,string.upper(string.sub(profilename,1,8));horizalign,left;zoom,.51;x,SCREEN_RIGHT-105;y,SCREEN_BOTTOM-23);
	};
	
	local maxcomboP2 = 0;
	local pscoreP2 = 0;
	t[#t+1] = LoadFont("_karnivore lite white") .. {
		InitCommand=cmd(settext,"000.000";horizalign,right;zoom,.62;x,SCREEN_RIGHT-5;y,SCREEN_BOTTOM-16;maxwidth,85);
		JudgmentMessageCommand=function(self,param)
			local curstats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
			local perfects = curstats:GetTapNoteScores('TapNoteScore_W2') + curstats:GetTapNoteScores('TapNoteScore_CheckpointHit');
			local greats = curstats:GetTapNoteScores('TapNoteScore_W3');
			local goods = curstats:GetTapNoteScores('TapNoteScore_W4');
			local bads = curstats:GetTapNoteScores('TapNoteScore_W5');
			local misses = curstats:GetTapNoteScores('TapNoteScore_Miss') + curstats:GetTapNoteScores('TapNoteScore_CheckpointMiss');
			local currentcombo = curstats:GetCurrentCombo();
			if currentcombo > maxcomboP2 then maxcomboP2 = currentcombo end;
			local stagebreak = curstats:GetReachedLifeZero();
			pscoreP2 = CalcPScore(perfects,greats,goods,bads,misses,maxcomboP2);
			local formatted_pscoreP2 = AddDots(pscoreP2);
			if pscoreP2 < 10 then
				formatted_pscoreP2 = "000.00"..formatted_pscoreP2;
			elseif pscoreP2 < 100 then
				formatted_pscoreP2 = "000.0"..formatted_pscoreP2;
			elseif pscoreP2 < 1000 then 
				formatted_pscoreP2 = "000."..formatted_pscoreP2;
			elseif pscoreP2 < 10000 then
				formatted_pscoreP2 = "00"..formatted_pscoreP2;
			elseif pscoreP2 < 100000 then
				formatted_pscoreP2 = "0"..formatted_pscoreP2;
			end
			self:settext(formatted_pscoreP2);
			formatted_pscoreP2 = "000.000";
			pscoreP2 = 0;
		end;
	};

	-- P2 Mods Display --
	
	local P2mods = GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptionsString('ModsLevel_Preferred');
	local P2speedstring = string.sub(P2mods,1,6);
	local P2speed = "1x"
	local P2speedstart, P2speedend = 1,2;
	local P2judge = ", NJ"
	if string.find(P2mods, " Easy") then
		P2judge = ", EJ"
	elseif string.find(P2mods, " Normal") then
		P2judge = ", NJ"
	elseif string.find(P2mods, " Hard") then
		P2judge = ", HJ"
	elseif string.find(P2mods, " VeryHard") then
		P2judge = ", VJ"
	elseif string.find(P2mods, " ExtraHard") then
		P2judge = ", XJ"
	elseif string.find(P2mods, " UltraHard") then
		P2judge = ", UJ"
	end;
	if string.find(P2speedstring, "^%d.*x,") then
		P2speedstart, P2speedend = string.find(P2speedstring, "^%d.*x,");
		P2speed = string.sub(P2speedstring, P2speedstart,P2speedend-1);
	elseif string.find(P2speedstring, "^m%d%d%d,") then
		P2speedstart, P2speedend = string.find(P2speedstring, "^m%d%d%d,");
		P2speed = "AV"..string.sub(P2speedstring, P2speedstart+1,P2speedend-1);
	end;
	P2mods = P2speed..P2judge
	t[#t+1] = LoadFont("","_myriad pro 20px") .. {
		InitCommand=cmd(settext,P2mods;horizalign,left;zoom,.32;x,SCREEN_RIGHT-105;y,SCREEN_BOTTOM-15;diffuse,color("#00FFFF"));
	};	

	-- P2 Difficulty Ball --

	t[#t+1] = GetSimpleBallLevel( PLAYER_2 )..{ 
		InitCommand=cmd(horizalign,right;basezoom,.18;x,SCREEN_RIGHT-120;playcommand,"ShowUp";y,SCREEN_BOTTOM-18);
	};

end;

-- Song Title --

local songtitle = GAMESTATE:GetCurrentSong():GetDisplayMainTitle();
songtitle = string.sub(songtitle,1,45);

t[#t+1] = Def.BitmapText {
	Font="hdkarnivore 24px",
	Text="♫"..songtitle,
	InitCommand=function(self)
		self:y(SCREEN_BOTTOM-9);
		self:x(SCREEN_CENTER_X);
		self:zoom(.64);
		self:maxwidth(440);
		self:AddAttribute(0, {Diffuse = color("#ccfffe"), Length = 1});
	end;
};

return t;