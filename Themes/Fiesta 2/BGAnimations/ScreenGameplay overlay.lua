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

local function DurationCursor()
	local MeterWidth = 235;
	local style = GAMESTATE:GetCurrentStyle():GetStyleType();
	if( (style=='StyleType_OnePlayerTwoSides') or (style=='StyleType_TwoPlayersSharedSides') ) then MeterWidth = 470 end;
	return 	Def.SongMeterDisplay {
		StreamWidth=MeterWidth;
		Stream=Def.Quad { InitCommand=cmd(diffusealpha,0); };
		Tip=LoadActor( THEME:GetPathG("","ScreenGameplay/_time_ball") );
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
	local P1PosX = GetPlayerPosition( PLAYER_1 );
	local MeterWidth = 235;
	local StageBreak = false;
	local HasMiss = 0;
	local HasBad = 0;
	local HasGood = 0;
	local HasGreat = 0;
	if( (style=='StyleType_OnePlayerTwoSides') or (style=='StyleType_TwoPlayersSharedSides') ) then MeterWidth = 470 end;

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

	--P1 Timeline--
	t[#t+1] = Def.ActorFrame {
		children = {
			LoadActor( THEME:GetPathG("","ScreenGameplay/_time_line") ).. {
				InitCommand=cmd(SetWidth,MeterWidth;x,P1PosX;y,SCREEN_CENTER_Y-204;diffusecolor,color("0,0.8,1,1"));
				Name="Timeline";		
			};

			--P1 Cursor--
			DurationCursor()..{
				InitCommand=cmd(x,P1PosX;y,SCREEN_CENTER_Y-204);
				Name="Cursor";
			};

			--P1 Glass Shatter Sound--
			LoadActor(THEME:GetPathS("","Rank/GLASS_P1.ogg"))..{
				Name="ShatterSound";
			};

			--P1 Glass Shatter Animation--
			LoadActor(THEME:GetPathG("","ScreenGameplay/broken.png"))..{
				InitCommand=cmd(x,((style=='StyleType_OnePlayerTwoSides') or (style=='StyleType_TwoPlayersSharedSides')) and SCREEN_CENTER_X-245 or P1PosX-125;y,SCREEN_CENTER_Y-220;diffusealpha,0;zoom,0.1);
				Name="ShatterAnimation";
			};
		};
		JudgmentMessageCommand=function(self,param)
			if StageBreak ~= true then
				local timeline = self:GetChild("Timeline");
				local shattersound = self:GetChild("ShatterSound");
				local shatteranimation = self:GetChild("ShatterAnimation");
				local cur_stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
				StageBreak = cur_stats:GetReachedLifeZero();
				if StageBreak then
					timeline:diffusecolor(color("1,0.3,0.3,1"));
					shattersound:play();
					shatteranimation:diffusealpha(0.9);
					shatteranimation:accelerate(0.2);
					shatteranimation:zoom(1);
					shatteranimation:diffusealpha(0);
				elseif HasMiss == 0 then
					HasMiss = cur_stats:GetTapNoteScores('TapNoteScore_Miss') + cur_stats:GetTapNoteScores('TapNoteScore_CheckpointMiss');
					if HasMiss > 0 then
						timeline:diffusecolor(color("0.95,0.95,0.95,1"));
					elseif HasBad == 0 then
						HasBad = cur_stats:GetTapNoteScores('TapNoteScore_W5');
						if HasBad > 0 then
							timeline:diffusecolor(color("1,0.55,1,1"));
						elseif HasGood == 0 then
							HasGood = cur_stats:GetTapNoteScores('TapNoteScore_W4');
							if HasGood > 0 then
								timeline:diffusecolor(color("1,1,0,1"));
							elseif HasGreat == 0 then
								HasGreat = cur_stats:GetTapNoteScores('TapNoteScore_W3');
								if HasGreat > 0 then
									timeline:diffusecolor(color("0,1,0.55,1"));
								end;
							end;
						end;
					end;
				end;
			end;
		end;						
	};

end;

if( GAMESTATE:IsSideJoined(PLAYER_2) or GAMESTATE:IsDemonstration() ) then
	local P2PosX = GetPlayerPosition( PLAYER_2 );
	local GlassSoundNotPlayed = true;
	local MeterWidth = 235;
	if( (style=='StyleType_OnePlayerTwoSides') or (style=='StyleType_TwoPlayersSharedSides') ) then MeterWidth = 470 end;
	local StageBreak = false;
	local HasMiss = 0;
	local HasBad = 0;
	local HasGood = 0;
	local HasGreat = 0;

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

	--P2 Timeline--
	t[#t+1] = Def.ActorFrame {
		children = {
			LoadActor( THEME:GetPathG("","ScreenGameplay/_time_line") ).. {
				InitCommand=cmd(SetWidth,MeterWidth;x,P2PosX;y,SCREEN_CENTER_Y-204;diffusecolor,color("0,0.8,1,1"));
				Name="Timeline";		
			};

			--P2 Cursor--
			DurationCursor()..{
				InitCommand=cmd(x,P2PosX;y,SCREEN_CENTER_Y-204);
				Name="Cursor";
			};

			--P2 Glass Shatter Sound--
			LoadActor(THEME:GetPathS("","Rank/GLASS_P2.ogg"))..{
				Name="ShatterSound";
			};

			--P2 Glass Shatter Animation--
			LoadActor(THEME:GetPathG("","ScreenGameplay/broken.png"))..{
				InitCommand=cmd(x,((style=='StyleType_OnePlayerTwoSides') or (style=='StyleType_TwoPlayersSharedSides')) and SCREEN_CENTER_X-245 or P2PosX+125;y,SCREEN_CENTER_Y-220;diffusealpha,0;zoom,0.1);
				Name="ShatterAnimation";
			};
		};
		JudgmentMessageCommand=function(self,param)
			if StageBreak ~= true then
				local timeline = self:GetChild("Timeline");
				local shattersound = self:GetChild("ShatterSound");
				local shatteranimation = self:GetChild("ShatterAnimation");
				local cur_stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
				StageBreak = cur_stats:GetReachedLifeZero();
				if StageBreak then
					timeline:diffusecolor(color("1,0.3,0.3,1"));
					shattersound:play();
					shatteranimation:diffusealpha(0.9);
					shatteranimation:accelerate(0.2);
					shatteranimation:zoom(1);
					shatteranimation:diffusealpha(0);
				elseif HasMiss == 0 then
					HasMiss = cur_stats:GetTapNoteScores('TapNoteScore_Miss') + cur_stats:GetTapNoteScores('TapNoteScore_CheckpointMiss');
					if HasMiss > 0 then
						timeline:diffusecolor(color("0.95,0.95,0.95,1"));
					elseif HasBad == 0 then
						HasBad = cur_stats:GetTapNoteScores('TapNoteScore_W5');
						if HasBad > 0 then
							timeline:diffusecolor(color("1,0.55,1,1"));
						elseif HasGood == 0 then
							HasGood = cur_stats:GetTapNoteScores('TapNoteScore_W4');
							if HasGood > 0 then
								timeline:diffusecolor(color("1,1,0,1"));
							elseif HasGreat == 0 then
								HasGreat = cur_stats:GetTapNoteScores('TapNoteScore_W3');
								if HasGreat > 0 then
									timeline:diffusecolor(color("0,1,0.55,1"));
								end;
							end;
						end;
					end;
				end;
			end;
		end;						
	};	

end;


return t;