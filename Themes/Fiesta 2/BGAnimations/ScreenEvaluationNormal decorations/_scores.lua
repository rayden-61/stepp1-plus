local t = Def.ActorFrame {
	GoNextScreenMessageCommand=cmd(playcommand,'Off');
};

local init_pos = 133;
local delta = 23;

-- Tick sound
local times = 1;
t[#t+1] = LoadActor(THEME:GetPathS("","Sounds/Tick.mp3"))..{
	OnCommand=cmd(sleep,2;queuecommand,'Play');
	PlayCommand=function(self)
		--SOUND:PlayOnce(THEME:GetPathS("","Sounds/Tick.WAV"));
		self:play();
		times = times + 1;
		if( times < 24 ) then
			self:sleep(.074);
			self:queuecommand('Play');
		end;
	end;
	OffCommand=cmd(stoptweening);
}

t[#t+1] = LoadActor(THEME:GetPathS("","Sounds/HEART_PLUS.mp3"))..{
	OnCommand=cmd(sleep,1.8;queuecommand,'Play');
	PlayCommand=function(self)
		self:play();
	end;
	OffCommand=cmd(stoptweening);
}

-- Scores
if GAMESTATE:IsSideJoined(PLAYER_1) then
	local curstats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1); 
	local perfects = curstats:GetTapNoteScores('TapNoteScore_W2') + curstats:GetTapNoteScores('TapNoteScore_CheckpointHit');
	local misses = curstats:GetTapNoteScores('TapNoteScore_Miss') + curstats:GetTapNoteScores('TapNoteScore_CheckpointMiss');
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos, 	perfects, 'HorizAlign_Left', 2 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta, curstats:GetTapNoteScores('TapNoteScore_W3'), 'HorizAlign_Left', 2.08 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta*2, curstats:GetTapNoteScores('TapNoteScore_W4'), 'HorizAlign_Left', 2.16 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta*3, curstats:GetTapNoteScores('TapNoteScore_W5'), 'HorizAlign_Left', 2.24 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta*4, misses, 'HorizAlign_Left', 2.32 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta*5, curstats:MaxCombo(), 'HorizAlign_Left', 2.40 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta*6, curstats:GetScore(), 'HorizAlign_Left', 2.48 )..{InitCommand=cmd(zoom,.84);};
	--kcal
	local kcal = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetCaloriesBurned();
	t[#t+1] = DrawRollingNumberP1( WideScale(106, 155), init_pos+delta*7, math.floor( (kcal - math.floor(kcal))*1000 ), 'HorizAlign_Left', 2.56 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta*7, math.floor( kcal ), 'HorizAlign_Left', 2.56 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = LoadFont("_karnivore lite white 20px")..{ InitCommand=cmd(settext,".";y,init_pos+delta*7;x,WideScale(101, 150);zoom,.84;diffusealpha,0;sleep,2.56;diffusealpha,1); };
end;

if GAMESTATE:IsSideJoined(PLAYER_2) then
	local curstats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2); 
	local perfects = curstats:GetTapNoteScores('TapNoteScore_W2') + curstats:GetTapNoteScores('TapNoteScore_CheckpointHit');
	local misses = curstats:GetTapNoteScores('TapNoteScore_Miss') + curstats:GetTapNoteScores('TapNoteScore_CheckpointMiss');
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos, 	perfects, 'HorizAlign_Right', 2 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta, curstats:GetTapNoteScores('TapNoteScore_W3'), 'HorizAlign_Right', 2.08 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta*2, curstats:GetTapNoteScores('TapNoteScore_W4'), 'HorizAlign_Right', 2.16 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta*3, curstats:GetTapNoteScores('TapNoteScore_W5'), 'HorizAlign_Right', 2.24 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta*4, misses, 'HorizAlign_Right', 2.32 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta*5, curstats:MaxCombo(), 'HorizAlign_Right', 2.40 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta*6, curstats:GetScore(), 'HorizAlign_Right', 2.48 )..{InitCommand=cmd(zoom,.84);};
	--kcal
	local kcal = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetCaloriesBurned();
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta*7, math.floor( (kcal - math.floor(kcal))*1000 ), 'HorizAlign_Right', 2.56 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(106, 155), init_pos+delta*7, math.floor( kcal ), 'HorizAlign_Right', 2.56 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = LoadFont("_karnivore lite white 20px")..{ InitCommand=cmd(settext,".";y,init_pos+delta*7;x,SCREEN_RIGHT-WideScale(101, 150);zoom,.84;diffusealpha,0;sleep,2.56;diffusealpha,1); };
end;

return t;