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

--thanks to StepMod / arka for this, extracted from StepMod 1.2
function songBarBlue()
	local MeterWidth = 235;
	local style = GAMESTATE:GetCurrentStyle():GetStyleType();
	if( (style=='StyleType_OnePlayerTwoSides') or (style=='StyleType_TwoPlayersSharedSides') ) then MeterWidth = 470 end;
	return 	Def.SongMeterDisplay {
		StreamWidth=MeterWidth;
		Stream=Def.Quad { InitCommand=cmd(diffusealpha,0); };
		Tip=LoadActor( THEME:GetPathG("","ScreenSelectMusic/_cursor_ball") );
	};
end;

function songBarRed()
	local MeterWidth = 235;
	local style = GAMESTATE:GetCurrentStyle():GetStyleType();
	if( (style=='StyleType_OnePlayerTwoSides') or (style=='StyleType_TwoPlayersSharedSides') ) then MeterWidth = 470 end;
	return 	Def.SongMeterDisplay {
		StreamWidth=MeterWidth;
		Stream=Def.Quad { InitCommand=cmd(diffusealpha,0); };
		Tip=LoadActor( THEME:GetPathG("","ScreenSelectMusic/_current_time_red") );
	};
end;

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
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


--P1 Time Meter Start--
if GAMESTATE:IsSideJoined(PLAYER_1) then
	local P1PosX = GetPlayerPosition(PLAYER_1)
	if( (style=='StyleType_OnePlayerTwoSides') or (style=='StyleType_TwoPlayersSharedSides') ) then P1PosX = P1PosX - 235 end;
	local GlassSoundNotPlayed = true;
	local MeterWidth = 235;
	if( (style=='StyleType_OnePlayerTwoSides') or (style=='StyleType_TwoPlayersSharedSides') ) then MeterWidth = 470 end;

	--P1 Red Timeline--
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/_time_line_red") ).. {
		InitCommand=cmd(SetWidth,MeterWidth;x,P1PosX;y,SCREEN_CENTER_Y-205);
	};

	--P1 Blue Timeline--
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/_cursor_line") ).. {
		InitCommand=cmd(SetWidth,MeterWidth;x,P1PosX;y,SCREEN_CENTER_Y-205);

		JudgmentMessageCommand=function(self,param)
			if GAMESTATE:IsSideJoined(PLAYER_1) then
				STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetCurrentLife();
				local deathP1=STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetReachedLifeZero();
				if deathP1 then		
					self:visible(false);
				else
					self:visible(true);
				end;
			end;		
		end;	
	};

	--P1 Red Cursor--
	t[#t+1] = songBarRed()..{
		InitCommand=cmd(x,P1PosX;y,SCREEN_CENTER_Y-205);
	};

	--P1 Blue Cursor--
	t[#t+1] = songBarBlue()..{
		InitCommand=cmd(x,P2PosX;y,SCREEN_CENTER_Y-205);
		JudgmentMessageCommand=function(self,param)
			if GAMESTATE:IsSideJoined(PLAYER_1) then
				STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetCurrentLife();
				local deathP1=STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetReachedLifeZero();
				if deathP1 then		
					self:visible(false);
				else
					self:visible(true);
				end;
			end;		
		end;
	};

	--P1 Glass Shatter Sound--
	t[#t+1] = LoadActor(THEME:GetPathS("","Rank/GLASS.mp3"))..{
		JudgmentMessageCommand=function(self,param)
			STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetCurrentLife();
			local deathP1=STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetReachedLifeZero();
			if deathP1 then
				if GlassSoundNotPlayed then
					self:play();
					GlassSoundNotPlayed = false;
				end
			end;	
		end;
	};

end;


--P2 Time Meter Start--
if GAMESTATE:IsSideJoined(PLAYER_2) then
	local P2PosX = GetPlayerPosition(PLAYER_2);
	local GlassSoundNotPlayed = true;
	local MeterWidth = 235;
	if( (style=='StyleType_OnePlayerTwoSides') or (style=='StyleType_TwoPlayersSharedSides') ) then MeterWidth = 470 end;

	--P2 Red Timeline--
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/_time_line_red") ).. {
		InitCommand=cmd(SetWidth,MeterWidth;x,P2PosX;y,SCREEN_CENTER_Y-205);
	};

	--P2 Blue Timeline--
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/_cursor_line") ).. {
		InitCommand=cmd(SetWidth,MeterWidth;x,P2PosX;y,SCREEN_CENTER_Y-205);

		JudgmentMessageCommand=function(self,param)
			if GAMESTATE:IsSideJoined(PLAYER_2) then
				STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetCurrentLife();
				local deathP2=STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetReachedLifeZero();
				if deathP2 then		
					self:visible(false);
				else
					self:visible(true);
				end;
			end;		
		end;	
	};

	--P2 Red Cursor--
	t[#t+1] = songBarRed()..{
		InitCommand=cmd(x,(P2PosX);y,SCREEN_CENTER_Y-205);
	};

	--P2 Blue Cursor--
	t[#t+1] = songBarBlue()..{
		InitCommand=cmd(x,(P2PosX);y,SCREEN_CENTER_Y-205);
		JudgmentMessageCommand=function(self,param)
			if GAMESTATE:IsSideJoined(PLAYER_2) then
				STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetCurrentLife();
				local deathP2=STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetReachedLifeZero();
				if deathP2 then		
					self:visible(false);
				else
					self:visible(true);
				end;
			end;		
		end;
	};

	--P2 Glass Shatter Sound--
	t[#t+1] = LoadActor(THEME:GetPathS("","Rank/GLASS.mp3"))..{
		JudgmentMessageCommand=function(self,param)
			STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetCurrentLife();
			local deathP2=STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetReachedLifeZero();
			if deathP2 then
				if GlassSoundNotPlayed then
					self:play();
					GlassSoundNotPlayed = false;
				end
			end;	
		end;
	};

end;

local songtitle = GAMESTATE:GetCurrentSong():GetDisplayMainTitle();

t[#t+1] = LoadFont("hdkarnivore 24px")..{
	InitCommand=cmd(settext,songtitle;y,SCREEN_BOTTOM-10;x,SCREEN_CENTER_X;zoom,.54);
};

return t;