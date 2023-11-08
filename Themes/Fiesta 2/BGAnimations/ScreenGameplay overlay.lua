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


return t;